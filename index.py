from flask import render_template, request, jsonify, json, session
from flask_session import Session
# from flask_sqlalchemy import *
# from flask.ext.session import Session
from database import app, db
from dataModel import Users, check_login, HeartRates, LKHeartRateType, \
    Workout, WorkoutSession, WorkoutSets, LKWorkoutSessionType, \
    LKWorkoutSetType, LKDistanceType, Notes
import jinja2

app.debug = True
app.secret_key = 'super-secret'
app.config['SESSION_TYPE'] = 'filesystem'
# 14400 = 4 hour session lifetime
app.config['PERMANENT_SESSION_LIFETIME'] = 14400

Session(app)


@app.route("/")
def home():
    return render_template('home.html')


@app.route("/api/newUser", methods=['POST'])
def create_new_user():
    if request.method == 'POST':
        new_user = request.get_json(force=True, silent=True)
        new_user_result = Users().add_user(new_user)
        return jsonify(
            new_user_result
        )
    else:
        return json.dumps(False)


@app.route("/api/login", methods=['POST'])
def login():
    if request.method == 'POST':
        user = request.get_json(force=True, silent=True)
        session['user'] = check_login(user)
        if session['user'] != "false":
            session['isValid'] = 'True'
            session['userID'] = Users.get_user_id(user)
            return session['user']
        else:
            session.clear()
            return json.dumps(False)
    else:
        return json.dumps(False)


@app.route("/api/logout", methods=['POST'])
def logout():
    session.clear()
    return json.dumps(True)


@app.route("/api/addWorkoutNote", methods=['POST'])
def add_workout_note():
    if request.method == 'POST':
        note_details = request.get_json(force=True, silent=True)
        user_id = session['userID']
        note_result = Notes().add_note(user_id, 1, note_details)
        return note_result
    else:
        return json.dumps(False)


@app.route("/api/getWorkoutNotes", methods=['POST'])
def get_workout_notes():
    if request.method == 'POST':
        if request.method == 'POST':
            workout_notes = request.get_json(force=True, silent=True)
            return Notes.get_notes(session['userID'], 1, workout_notes[
                'workoutSessionID'])
    else:
        return json.dumps(False)


@app.route("/api/checkValidSession", methods=['POST'])
def check_valid_session():
    return session.get('user', 'false')


@app.route("/api/getHeartRateTypes", methods=['POST'])
def hr_types():
    if request.method == 'POST':
        heart_rate_types = LKHeartRateType.get_heart_rate_types_json()
        return heart_rate_types
    else:
        return json.dumps(False)


@app.route("/api/getWorkoutSessionTypes", methods=['POST'])
def workout_session_types():
    if request.method == 'POST':
        return LKWorkoutSessionType.get_workout_session_types_json(session[
                                                                       'userID'])
    else:
        return json.dumps(False)


@app.route("/api/getWorkoutSetTypes", methods=['POST'])
def workout_set_types():
    if request.method == 'POST':
        return LKWorkoutSetType.get_workout_set_types_json(session['userID'])
    else:
        return json.dumps(False)


@app.route("/api/getDistanceTypes", methods=['POST'])
def distance_types():
    if request.method == 'POST':
        return LKDistanceType.get_distance_types_json(session['userID'])
    else:
        return json.dumps(False)


@app.route("/api/getUserHeartRates", methods=['POST'])
def user_heart_rates():
    if request.method == 'POST':
        return HeartRates.get_user_heart_rates(session['userID'])
    else:
        return json.dumps(False)


@app.route("/api/addHeartRate", methods=['POST'])
def add_hr():
    if request.method == 'POST':
        hr = request.get_json(force=True, silent=True)
        user_id = session['userID']
        hr_result = HeartRates().add_heart_rate(hr, user_id)
        return hr_result
    else:
        return json.dumps(False)


@app.route("/api/addWorkoutSession", methods=['POST'])
def add_workout_session():
    if request.method == 'POST':
        workout_session = request.get_json(force=True, silent=True)
        workout_session_result = WorkoutSession().add_workout_session(
            workout_session, session['userID'])
        return workout_session_result
    else:
        return json.dumps(False)


@app.route("/api/addWorkout", methods=['POST'])
def add_workout():
    if request.method == 'POST':
        workout = request.get_json(force=True, silent=True)
        # print WorkoutSession().check_user_workout_session(session['userID'],
        #                                                   workout['workoutSessionID'])
        if (WorkoutSession().check_user_workout_session(session['userID'],
                                                        workout['workoutSessionID']) == True):
            workout_result = Workout().add_workout(workout)
            return workout_result
        else:
            return json.dumps(False)
    else:
        return json.dumps(False)


@app.route("/api/addWorkoutSet", methods=['POST'])
def add_workout_set():
    if request.method == 'POST':
        workout_set = request.get_json(force=True, silent=True)
        # print WorkoutSession().check_user_workout_session(session['userID'],
        #                                                   workout_set[
        #                                                       'workoutSetSessionID'])
        if (WorkoutSession().check_user_workout_session(session['userID'],
                                                        workout_set[
                                                            'workoutSetSessionID']) == True):
            workout_set_result = WorkoutSets().add_workout_set(workout_set)
            return workout_set_result
        else:
            return json.dumps(False)
    else:
        return json.dumps(False)


@app.route("/api/getUserWorkoutSets", methods=['POST'])
def get_user_workout_sets():
    if request.method == 'POST':
        return WorkoutSets.get_user_workout_sets(session['userID'])
    else:
        return json.dumps(False)


@app.route("/api/getUserWorkouts", methods=['POST'])
def get_user_workouts():
    if request.method == 'POST':
        return Workout.get_user_workouts(session['userID'])
    else:
        return json.dumps(False)
    

@app.route("/api/getUserWorkoutSessions", methods=['POST'])
def get_user_workout_sessions():
    if request.method == 'POST':
        return WorkoutSession.get_user_workout_sessions(session['userID'])
    else:
        return json.dumps(False)