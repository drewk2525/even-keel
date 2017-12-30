from flask import json, jsonify
import random
import hashlib
import logging
from database import db
from datetime import datetime
from sqlalchemy import and_, or_, not_

logger = logging.getLogger('even_keel')
hdlr = logging.FileHandler('static/logs/even_keel.log')
formatter = logging.Formatter('%(asctime)s %(levelname)s $(message)s')
hdlr.setFormatter(formatter)
logger.addHandler(hdlr)
logger.setLevel(logging.INFO)


def create_salt():
    alphabet = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    chars = []
    for i in range(128):
        chars.append(random.choice(alphabet))

    return "".join(chars)


# user being passed in here is user data from the form
def check_login(user):
    # accessing the email of that user from form
    user_email = user['email']
    check_user = db.session.query(Users.UserID, Users.FirstName, Users.LastName,
                                 Users.Email, Users.Salt, Users.Password,
                                 Users.UserTypeID,
                                 LKUserType.UserTypeDescription).join(
        LKUserType).filter(Users.Email == user_email).first()
    if check_user is None:
        # when returning bools, change to json.dumps(bool)
        return json.dumps(False)

    hashed_pw = hashlib.sha512(user['password'] + check_user.Salt).hexdigest()
    if hashed_pw == check_user.Password:
        return jsonify(
            firstName=check_user.FirstName,
            lastName=check_user.LastName,
            email=check_user.Email,
            userTypeID=check_user.UserTypeID,
            userTypeDescription=check_user.UserTypeDescription
        )
    else:
        return json.dumps(False)


# User Table
class Users(db.Model):
    __table__ = db.Table('Users', db.metadata, autoload=True,
                         autoload_with=db.engine)

    def __init__(self):
        """init method to declare variables used in Users class.
        """
        self.UserTypeID = None
        self.FirstName = None
        self.LastName = None
        self.Email = None
        self.Salt = None
        self.Password = None

    def add_user(self, new_user):
        """Create a new user in the database.  
        new_user is a JSON object pulled in from the front end.
        """
        self.UserTypeID = new_user['userTypeID']
        self.FirstName = new_user['firstName']
        self.LastName = new_user['lastName']
        self.Email = new_user['email']
        password = new_user['password']
        self.Salt = create_salt()
        self.Password = hashlib.sha512(password + self.Salt).hexdigest()
        try:
            db.session.add(self)
            db.session.commit()
        except Exception as e:
            return_value = "Failed to add new user, please try again later"
            logger.exception(e)
        else:
            return_value = "Success"
        return return_value

    # user being passed in here is user data from the form
    @staticmethod
    def get_user_id(user):
        # accessing the email of that user from form
        user_email = user['email']
        check_user = db.session.query(Users.UserID, Users.Salt,
                                     Users.Password).filter(
            Users.Email == user_email).first()
        if check_user is None:
            # when returning bools, change to json.dumps(bool)
            return json.dumps(False)

        hashed_pw = hashlib.sha512(user['password'] +
                                  check_user.Salt).hexdigest()
        if hashed_pw == check_user.Password:
            return check_user.UserID
        else:
            return json.dumps(False)


# LKHeartRateType Table
class LKHeartRateType(db.Model):
    __table__ = db.Table('LKHeartRateType', db.metadata, autoload=True,
                         autoload_with=db.engine)

    @staticmethod
    def get_heart_rate_types_json():
        hr_types = db.session.query(LKHeartRateType.HeartRateTypeID,
                                   LKHeartRateType.HeartRateTypeDescription).order_by(
            LKHeartRateType.HeartRateTypeID).all()
        return jsonify([r._asdict() for r in hr_types])

    @staticmethod
    def add_heart_rate(hr, user_id):
        bpm = hr['heartRateValue']
        heart_rate_type_id = hr['heartRateType']
        heart_rate = HeartRates(HeartRateTypeID=heart_rate_type_id, BPM=bpm,
                               UserID=user_id, CreateDT=datetime.utcnow())
        db.session.add(heart_rate)
        db.session.commit()
        return json.dumps(True)


# LKUserType Table
class LKUserType(db.Model):
    __table__ = db.Table('LKUserType', db.metadata, autoload=True,
                         autoload_with=db.engine)

    @staticmethod
    def get_user_types():
        user_types = db.session.query.order_by(LKUserType.UserTypeID)
        return user_types


# LKWorkoutSessionType Table
class LKWorkoutSessionType(db.Model):
    __table__ = db.Table('LKWorkoutSessionType', db.metadata, autoload=True,
                         autoload_with=db.engine)

    @staticmethod
    def get_workout_session_types_json(user_id=0):
        user_type = db.session.query(Users.UserTypeID).filter(Users.UserID ==
                                                              user_id).one()
        workout_session_types = db.session.query(
            LKWorkoutSessionType.WorkoutSessionTypeID,
            LKWorkoutSessionType.WorkoutSessionTypeDescription).filter(
             or_(LKWorkoutSessionType.UserType == user_type[0],
                 user_type[0] == 0, LKWorkoutSessionType.UserType == None)
             ).order_by(LKWorkoutSessionType.WorkoutSessionTypeID).all()
        return jsonify([r._asdict() for r in workout_session_types])


# LKWorkoutSetType Table
class LKWorkoutSetType(db.Model):
    __table__ = db.Table('LKWorkoutSetType', db.metadata, autoload=True,
                         autoload_with=db.engine)

    @staticmethod
    def get_workout_set_types_json(user_id=0):
        user_type = db.session.query(Users.UserTypeID).filter(
            Users.UserID ==
            user_id).one()
        workout_session_types = db.session.query(
            LKWorkoutSetType.WorkoutSetTypeID,
            LKWorkoutSetType.WorkoutSetTypeDescription).filter(
            or_(LKWorkoutSetType.OwnerTypeID == user_type[0],
                user_type[0] == 0, LKWorkoutSetType.OwnerTypeID == None)
        ).order_by(LKWorkoutSetType.WorkoutSetTypeID).all()
        return jsonify([r._asdict() for r in workout_session_types])


# HeartRates Table
class HeartRates(db.Model):
    __table__ = db.Table('HeartRates', db.metadata, autoload=True,
                         autoload_with=db.engine)

    def __init__(self):
        self.BPM = None
        self.HeartRateTypeID = None
        self.UserID = None
        self.CreateDT = None

    def add_heart_rate(self, hr, user_id):
        self.BPM = hr['heartRateValue']
        self.HeartRateTypeID = hr['heartRateType']
        self.UserID = user_id
        self.CreateDT = datetime.utcnow()
        db.session.add(self)
        db.session.commit()
        return json.dumps(True)

    @staticmethod
    def get_user_heart_rates(user_id):
        user_heart_rates = db.session.query(HeartRates.HeartRateID,
                                            LKHeartRateType.HeartRateTypeDescription,
                                            HeartRates.BPM,
                                            HeartRates.CreateDT).join(
            LKHeartRateType).filter(
            HeartRates.UserID == user_id).order_by(
            HeartRates.CreateDT.desc()).all()
        return jsonify([r._asdict() for r in user_heart_rates])


# Workouts table
class Workout(db.Model):
    __table__ = db.Table('Workout', db.metadata, autoload=True,
                         autoload_with=db.engine)
    
    def __init__(self):
        self.WorkoutSessionID = None
        self.WorkoutDescription = None

    def add_workout(self, workout):
        self.WorkoutSessionID = workout['workoutSessionID']
        self.WorkoutDescription = workout['workoutDescription']
        db.session.add(self)
        db.session.commit()
        return json.dumps(True)

    @staticmethod
    def get_user_workouts(user_id):
        user_workouts = db.session.query(Workout.WorkoutID,
                                         Workout.WorkoutSessionID,
                                         Workout.WorkoutDescription,
                                         Workout.RequestCoachEndorsementDT,
                                         Workout.CoachEndorsementDT,
                                         Workout.EndorsedByUserID).join(
            WorkoutSession).filter(
            WorkoutSession.UserID == user_id).all()
        return jsonify([r._asdict() for r in user_workouts])


class WorkoutSets(db.Model):
    __table__ = db.Table('WorkoutSets', db.metadata, autoload=True,
                         autoload_with=db.engine)

    def __init__(self):
        self.WorkoutSetID = None
        self.WorkoutID = None
        self.WorkoutSetTypeID = None
        self.Weight = None
        self.Reps = None
        self.ExerciseTime = None
        self.SplitTime = None
        self.SPM = None
        self.RestTime = None
        self.DesiredIntensity = None
        self.DesiredIntensityTypeID = None
        self.HeartRateID = None

    def add_workout_set(self, workout_set):
        print "Adding new set"

    @staticmethod
    def get_user_workout_sets(user_id):
        user_workout_sets = db.session.query(WorkoutSets.WorkoutSetID,
                                             WorkoutSets.WorkoutID,
                                             WorkoutSets.WorkoutSetTypeID,
                                             WorkoutSets.Weight,
                                             WorkoutSets.Reps,
                                             WorkoutSets.ExerciseTime,
                                             WorkoutSets.SplitTime,
                                             WorkoutSets.SPM,
                                             WorkoutSets.RestTime,
                                             WorkoutSets.DesiredIntensity,
                                             WorkoutSets.DesiredIntensityTypeID,
                                             WorkoutSets.HeartRateID).join(
            Workout).join(WorkoutSession).filter(WorkoutSession.UserID ==
                                                 user_id).all()
        return jsonify([r._asdict() for r in user_workout_sets])
        # return jsonify(user_workout_sets)
        # return json.dumps(user_workout_sets, default=json_util.default)


class WorkoutSession(db.Model):
    __table__ = db.Table('WorkoutSession', db.metadata, autoload=True,
                         autoload_with=db.engine)

    def __init__(self):
        self.WorkoutSessionTypeID = None
        self.UserID = None
        self.WorkoutSessionDescription = None
        self.CreateDT = None

    def add_workout_session(self, workout_session, user_id):
        self.WorkoutSessionTypeID = workout_session['workoutSessionTypeID']
        self.UserID = user_id
        self.WorkoutSessionDescription = workout_session[
            'workoutSessionDescription']
        self.CreateDT = datetime.utcnow()
        db.session.add(self)
        db.session.commit()
        return json.dumps(True)

    @staticmethod
    def get_user_workout_sessions(user_id):
        user_workout_sessions = db.session.query(
            WorkoutSession.WorkoutSessionID,
            WorkoutSession.WorkoutSessionTypeID,
            WorkoutSession.WorkoutSessionDescription,
            WorkoutSession.CreateDT,
            LKWorkoutSessionType.WorkoutSessionTypeDescription
        ).join(LKWorkoutSessionType).filter(WorkoutSession.UserID ==
                                          user_id).all()
        return jsonify([r._asdict() for r in user_workout_sessions])

    @staticmethod
    def check_user_workout_session(user_id, workout_session_id):
        user_workout_session = db.session.query(
            WorkoutSession.WorkoutSessionID).filter(WorkoutSession.UserID ==
                                                    user_id).filter(
            WorkoutSession.WorkoutSessionID == workout_session_id).all()
        if user_workout_session > 0:
            return_value = True
        else:
            return_value = False
        return return_value
