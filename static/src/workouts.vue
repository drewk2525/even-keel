<template>
  <div>
    <div class="dashboardActions">
      <h1>Workouts</h1>
      <button class="deleteButton">Delete Selected</button>
      <button class="addButton" @click="openNewWorkoutSessionForm">Add Workout</button>
    </div>
    <v-data-table
      v-bind:headers="workoutSessionHeader"
      v-bind:items="userWorkoutSessions"
      class="mainTable workoutSessionTable"
      v-model="selected"
      item-key="WorkoutSessionID"
      select-all
      v-bind:rows-per-page-items="defaultRowsPerPage"
      v-bind:pagination.sync="workoutSessionPagination"
      id="dashboardDataTable"
      ref="workoutSessionRef"
    >
      <template slot="items" slot-scope="props">
        <tr @click="expandWorkoutSession(props)" @expand-new-workout-session="expandNewWorkoutSession(props, props.item.WorkoutSessionID)">
          <td class="rowCheckbox">
            <v-icon medium v-bind:class="{ expandedRow: props.expanded }">keyboard_arrow_right</v-icon>
            <v-checkbox
              primary
              v-model="props.selected"
            ></v-checkbox>
          </td>
          <td>{{ props.item.WorkoutSessionTypeDescription }}</td>
          <td>{{ props.item.WorkoutSessionDescription }}</td>
          <td>{{ props.item.CreateDT | dateTime }}</td>
        </tr>
      </template>
      <template slot="expand" slot-scope="props">
        <h2>Activities</h2>
        <v-btn color="primary darken-1" flat small @click.native="newWorkoutModal=!newWorkoutModal" v-if="!noWorkoutsInSession(props.item.WorkoutSessionID)">
          Add New Activity
        </v-btn>
        <v-card v-if="noWorkoutsInSession(props.item.WorkoutSessionID) || newWorkoutModal">
          <v-card-title>Add an activity to this workout:</v-card-title>
          <v-text-field label="Activity Description" required v-model="newWorkout.workoutDescription" ></v-text-field>
          <v-card-actions>
            <v-btn color="green darken-1" flat small @click="addWorkout(props.item.WorkoutSessionID, newWorkout.workoutDescription)">Add Activity</v-btn>
            <v-btn color="primary darken-1" flat small @click="newWorkoutModal=!newWorkoutModal">Cancel</v-btn>
          </v-card-actions>
        </v-card>
        <v-data-table
          v-bind:headers="workoutHeader"
          v-bind:items="userWorkouts"
          v-bind:rows-per-page-items="workoutRowsPerPage"
          hide-actions
          hide-headers
          item-key="WorkoutID"
          class="workoutTable"
          v-bind:pagination.sync="workoutPagination"
          ref="workoutRef"
        >
          <template slot="items" slot-scope="workout_props">
            <tr @click="workout_props.expanded = !workout_props.expanded" v-if="showWorkout(props.item.WorkoutSessionID, workout_props.item.WorkoutSessionID)">
              <td class="rowCheckbox">
                <v-icon medium v-bind:class="{ expandedRow: workout_props.expanded }">keyboard_arrow_right</v-icon>
              </td>
              <td v-if="workout_props.item.WorkoutDescription">{{ workout_props.item.WorkoutDescription }}</td>
            </tr>
          </template>
        </v-data-table>
      </template>
    </v-data-table>
    <v-dialog v-model="newWorkoutSessionModal" persistent max-width="400">
      <v-card>
        <v-card-title>Add Workout</v-card-title>
        <v-select label="Type of workout" 
                  required
                  v-model="newWorkoutSession.workoutSessionTypeID"
                  v-bind:items="workoutSessionTypes"
                  item-text="WorkoutSessionTypeDescription"
                  item-value="WorkoutSessionTypeID"
                  v-if="workoutSessionTypes.length > 1"
        >
        </v-select>
        <v-text-field label="Workout Description" required v-model="newWorkoutSession.workoutSessionDescription"></v-text-field>
        <v-card-actions>
          <v-btn color="primary darken-1" flat @click.native="newWorkoutSessionModal = false">Cancel</v-btn>
          <v-btn color="green darken-1" flat @click="addWorkoutSession">Submit</v-btn>
        </v-card-actions>

      </v-card>
    </v-dialog>
  </div>
</template>


<script>
  import { generalAPICall } from '../js/api.js'
  import { formatDateTime } from '../js/basicMethods.js'
  
  export default {
    name: 'app',
    data () {
      return {
        createdWorkout: false,
        createdWorkoutError: false,
        workoutData: [],
        selected: [],
        userWorkouts: [],
        userWorkoutSets: [],
        userWorkoutSessions: [],
        workoutSessionTypes: [],
        defaultRowsPerPage:[25, 50, 100, 200],
        workoutRowsPerPage:[1000],
        newWorkoutSessionModal: false,
        newWorkoutModal: false,
        expandWorkoutSessionID: null,
        anw: true,
        workoutSessionHeader: [
          {
            text: 'Workout Type', 
            align: 'center',
            sortable: true,
            value: 'WorkoutSessionTypeDescription'
          },
          {
            text: 'Workout Description', 
            align: 'center',
            sortable: true,
            value: 'WorkoutSessionDescription'
          },
          {
            text: 'Date Created',
            align: 'center',
            sortable: true,
            value: 'CreateDT'
          },
        ],
        workoutHeader: [
          {
            text: 'Activity Description', 
            align: 'center',
            sortable: true,
            value: 'WorkoutDescription'
          }
        ],
        newWorkoutSession: {
          workoutSessionDescription: '',
          workoutSessionTypeID: 1
        },
        newWorkout:{
          workoutDescription: '',
          workoutSessionID: 0
        },
        workoutPagination: {
          sortBy: 'WorkoutID'
        },
        workoutSessionPagination: {
          sortBy: 'CreateDT',
          descending: true
        },
      }
    }, 
    methods: {
      addWorkoutSession: function(event){
        generalAPICall('addWorkoutSession', this.newWorkoutSession).then(function(data){
          if(data === false){
            this.$parent.$emit('update-alert', "Failure", "Workout was not added, please try again later.");
            this.newWorkoutSessionModal = false;
          } else{
            this.pullWorkoutData().then(function(){
              this.expandWorkoutSessionID = Math.max.apply(Math, this.userWorkoutSessions.map(function(o){
                return o.WorkoutSessionID;
              }));
              this.$refs.workoutSessionRef.expanded[this.expandWorkoutSessionID] = true;
              this.$forceUpdate();
            }.bind(this));
            this.$parent.$emit('update-alert', "Success", "Workout added successfully!");
            this.newWorkoutSessionModal = false;
          }
        }.bind(this));
      },
      addWorkout: function(WorkoutSessionID, ActivityDescription){
        this.newWorkout = {
          workoutDescription: ActivityDescription,
          workoutSessionID: WorkoutSessionID
        }
        generalAPICall('addWorkout', this.newWorkout).then(function(data){
          if(data === false){
            this.$parent.$emit('update-alert', "Failure", "Workout was not added, please try again later.");
            this.newWorkoutModal = false;
          } else{
            this.pullWorkoutData().then(function(){
              this.expandWorkoutSessionID = Math.max.apply(Math, this.userWorkoutSessions.map(function(o){
                return o.WorkoutSessionID;
              }));
              this.$refs.workoutRef.expanded[this.expandWorkoutSessionID] = true;
              this.$forceUpdate();
            }.bind(this));
            this.$parent.$emit('update-alert', "Success", "Workout added successfully!");
            this.newWorkoutModal = false;
          }
        }.bind(this));
      },
      openNewWorkoutSessionForm: function(){
        this.newWorkoutSession = { workoutSessionTypeID: 1, workoutDescription: ''}
        this.$parent.$emit('reset-alerts');
        this.newWorkoutSessionModal = true;
      },
      showWorkout: function(a, b){
        return a == b;
      },
      noWorkoutsInSession: function(workoutSessionID){
        var workoutExists = 0;
        var i = 0;
        for(i = 0; i < this.userWorkouts.length; i++){
          if(this.userWorkouts[i].WorkoutSessionID == workoutSessionID){
            workoutExists = 1;
          }
        }
        return !workoutExists;
      },
      pullWorkoutData: function(){
        generalAPICall('getUserWorkouts').then(function(data){
          this.userWorkouts = data;
        }.bind(this));
        generalAPICall('getUserWorkoutSets').then(function(data){
          this.userWorkoutSets = data;
          console.log(data);
        }.bind(this));
        return generalAPICall('getUserWorkoutSessions').then(function(data){
          this.userWorkoutSessions = data;
          var i = 0;
          while(i < this.userWorkoutSessions.length){
            this.userWorkoutSessions[i].CreateDT = formatDateTime(this.userWorkoutSessions[i].CreateDT);
            i++;
          }
        }.bind(this));
        generalAPICall('getWorkoutSessionTypes').then(function(data){
          this.workoutSessionTypes = data;
          this.newWorkoutSession.workoutType = data[0];
        }.bind(this));
      },
//      expandNewWorkoutSession(props, sessionID){
//        if(sessionID == this.expandWorkoutSessionID){
//          props.expanded = !props.expanded;
//        }
//        return;
//      },
      expandWorkoutSession: function(props){
        this.newWorkout = {
          workoutDescription: '',
          workoutSessionID: 0
        }
        props.expanded = !props.expanded
        this.newWorkoutModal = false;
        this.$forceUpdate();
      }
    },
    mounted: function(){
      this.pullWorkoutData();
    }
  }
</script>