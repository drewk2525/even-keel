<template>
  <div>
    <div class="dashboardActions">
      <h1>Workouts</h1>
      <button class="deleteButton">Delete Selected</button>
      <button class="addButton" @click="openNewWorkoutSessionForm">Add Workout</button>
    </div>
    
<!-- Workout Activities -->
    
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
        <tr @click="expandWorkoutSession($event, props)" @expand-new-workout-session="expandNewWorkoutSession(props, props.item.WorkoutSessionID)">
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
          <v-tooltip class="addNote" bottom>
            <v-icon medium class="addNoteButton" slot="activator" @click="viewWorkoutNotes($event, props.item.WorkoutSessionID)">description</v-icon>
            <span>Workout Notes</span>
          </v-tooltip>
        </tr>
      </template>
      
      <template slot="expand" slot-scope="props">
        <h2>Activities</h2>
        <v-btn color="primary darken-1" flat small @click.native="newWorkoutModal=!newWorkoutModal" :disabled="noWorkoutsInSession(props.item.WorkoutSessionID) || newWorkoutModal" class="addToWorkoutButton">
          Add New Activity
        </v-btn>
        <v-card v-if="noWorkoutsInSession(props.item.WorkoutSessionID) || newWorkoutModal">
          <v-card-title>Add an activity to this workout:</v-card-title>
          <v-text-field label="Activity Description" required v-model="newWorkout.workoutDescription" ></v-text-field>
          <v-card-actions>
            <v-btn color="green darken-1" flat small @click="addWorkout(props.item.WorkoutSessionID, newWorkout.workoutDescription)">Add Activity</v-btn>
            <v-btn color="primary darken-1" flat small @click="newWorkoutModal=!newWorkoutModal" v-if="!noWorkoutsInSession(props.item.WorkoutSessionID)">Cancel</v-btn>
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
            <tr @click="expandWorkoutSet(workout_props)" v-if="showWorkout(props.item.WorkoutSessionID, workout_props.item.WorkoutSessionID)">
              <td class="rowCheckbox">
                <v-icon medium v-bind:class="{ expandedRow: workout_props.expanded }">keyboard_arrow_right</v-icon>
              </td>
              <td v-if="workout_props.item.WorkoutDescription">{{ workout_props.item.WorkoutDescription }}</td>
            </tr>
          </template>
        
          <!-- Workout Sets --> 
            
          <template slot="expand" slot-scope="props2">
            <h2>Sets</h2>
            <v-btn color="primary darken-1" flat small @click.native="newWorkoutSetModal=!newWorkoutSetModal" :disabled="noWorkoutSetsInWorkout(props2.item.WorkoutID) || newWorkoutSetModal" class="addToWorkoutButton">
              Add New Set
            </v-btn>
            <v-card v-if="noWorkoutSetsInWorkout(props2.item.WorkoutID) || newWorkoutSetModal" class="newSetCard">
              <v-card-title>Add a new set to this activity:</v-card-title>
              <v-select label="Set Type" 
                  required
                  v-model="newWorkoutSet.workoutSetTypeID"
                  v-bind:items="workoutSetTypes"
                  item-text="WorkoutSetTypeDescription"
                  item-value="WorkoutSetTypeID"
                  v-if="workoutSetTypes.length > 1"
                  class="newSetType"
              >
              </v-select>
              <br>
              <h4>Rest Time After Set:</h4>
              <v-text-field label="Minutes" v-model="newWorkoutSet.workoutSetRestTimeMinutes" class="newSetRestMinutes minutes"></v-text-field><span>:</span>
              <v-text-field label="Seconds" v-model="newWorkoutSet.workoutSetRestTimeSeconds" class="newSetRestSeconds seconds"></v-text-field>
              <br>
              <h3>Weight Workout Details:</h3>
              <v-text-field label="Weight" required v-model="newWorkoutSet.workoutSetWeight" class="newSetWeight"></v-text-field>
              <v-text-field label="Reps" required v-model="newWorkoutSet.workoutSetReps" class="newSetReps"></v-text-field>
              <br>
              <h3>Distance Workout Details:</h3>
              <v-select label="Units" 
                  required
                  v-model="newWorkoutSet.workoutSetDistanceTypeID"
                  v-bind:items="distanceTypes"
                  item-text="DistanceTypeDescription"
                  item-value="DistanceTypeID"
                  v-if="distanceTypes.length > 1"
                  class="newSetDistanceUnits"
              >
              </v-select>
              <v-text-field label="Distance" required v-model="newWorkoutSet.workoutSetDistance" class="newSetDistance"></v-text-field>
              <v-text-field label="Cadence" v-model="newWorkoutSet.workoutSetSPM" class="newSetSPM"></v-text-field>
              <br>
              <h4>Workout Time:</h4>
              <v-text-field label="Hours" required v-model="newWorkoutSet.workoutSetExerciseTimeHours" class="newSetTimeHours hours"></v-text-field><span>:</span>
              <v-text-field label="Minutes" required v-model="newWorkoutSet.workoutSetExerciseTimeMinutes" class="newSetTimeMinutes minutes"></v-text-field><span>:</span>
              <v-text-field label="Seconds" required v-model="newWorkoutSet.workoutSetExerciseTimeSeconds" class="newSetTimeSeconds seconds"></v-text-field>
              <h4>Split:</h4>
              <v-text-field label="Minutes" required v-model="newWorkoutSet.workoutSetSplitTimeMinutes" class="newSetSplitMinutes minutes"></v-text-field><span>:</span>
              <v-text-field label="Seconds" required v-model="newWorkoutSet.workoutSetSplitTimeSeconds" class="newSetSplitSeconds seconds"></v-text-field>
              <v-card-actions>
                <v-btn color="green darken-1" flat small @click="addWorkoutSet(props2.item.WorkoutID, props.item.WorkoutSessionID)">Add Set</v-btn>
                <v-btn color="primary darken-1" flat small @click="newWorkoutSetModal=!newWorkoutSetModal"  v-if="!noWorkoutSetsInWorkout(props2.item.WorkoutID)">Cancel</v-btn>
              </v-card-actions>
            </v-card>
            <v-data-table
              v-bind:headers="workoutSetHeader"
              v-bind:items="userWorkoutSets"
              v-bind:rows-per-page-items="workoutRowsPerPage"
              hide-actions
              hide-headers
              item-key="WorkoutSetID"
              class="workoutSetTable"
              ref="workoutSetRef"
            >
              <template slot="items" slot-scope="workout_set_props">
<!--                @click="workout_set_props.expanded = !workout_set_props.expanded"-->
                <tr v-if="showWorkoutSet(props2.item.WorkoutID, workout_set_props.item.WorkoutID)">
                  <td class="rowCheckbox">
<!--                    <v-icon medium v-bind:class="{ expandedRow: workout_set_props.expanded }">keyboard_arrow_right</v-icon>-->
                  </td>
                  <td v-if="workout_set_props.item.WorkoutSetID">{{ workout_set_props.item.WorkoutSetID }}</td>
                  <td>{{ workout_set_props.item.WorkoutSetTypeDescription }}</td>
                  <td>{{ workout_set_props.item.Weight }}</td>
                  <td>{{ workout_set_props.item.Reps }}</td>
                  <td>{{ workout_set_props.item.Distance }} {{ workout_set_props.item.DistanceTypeUnits }}</td>
                  <td>{{ workout_set_props.item.ExerciseTime | secondsToHours }}{{ workout_set_props.item.ExerciseTime | secondsToMinutes }}:{{ workout_set_props.item.ExerciseTime | secondsToSeconds }}</td>
                  <td>{{ workout_set_props.item.SplitTime | secondsToMinutes }}:{{ workout_set_props.item.SplitTime | secondsToSeconds }}</td>
                  <td>{{ workout_set_props.item.SPM }}</td>
                  <td>{{ workout_set_props.item.RestTime | secondsToMinutes }}:{{ workout_set_props.item.RestTime | secondsToSeconds }}</td>
                </tr>
              </template>
            </v-data-table>
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
    
    <v-dialog v-model="workoutNotesModal" persistent max-width="800">
      <v-card>
        <v-card-title>Workout Notes</v-card-title>
          <v-data-table
            v-bind:headers="workoutNotesHeader"
            v-bind:items="workoutNotes"
            class="notesTable"
            v-bind:rows-per-page-items="notesRowsPerPage"
            v-bind:pagination.sync="workoutNotesPagination"
            id="workoutNotesDataTable"
          >
            <template slot="items" slot-scope="props">
              <td>{{ props.item.CreateDT | dateTime }}</td>
              <td>{{ props.item.FirstName | camel }} {{ props.item.LastName | camel }}</td>
              <td>{{ props.item.NoteContent }}</td>  
            </template>
          </v-data-table>
        
        
        <h3 v-if="showNewNoteTextField">Create a new note:</h3>
        <v-text-field label="Workout Note" required v-model="newWorkoutNote.noteContent" multi-line v-if="showNewNoteTextField"></v-text-field>
        
        <!--
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
-->
        <v-card-actions>
          <v-btn color="primary darken-1" flat @click.native="workoutNotesModal=false; showNewNoteTextField=false">Cancel</v-btn>
          <v-btn color="green darken-1" flat @click="showNewNoteTextField=true" v-if="!showNewNoteTextField">Create New Note</v-btn>
          <v-btn color="green darken-1" flat @click="addNewNote()" v-if="showNewNoteTextField">Submit</v-btn>
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
        workoutSetTypes: [],
        distanceTypes: [],
        defaultRowsPerPage:[25, 50, 100, 200],
        workoutRowsPerPage:[1000],
        notesRowsPerPage:[10],
        newWorkoutSessionModal: false,
        newWorkoutModal: false,
        newWorkoutSetModal: false,
        workoutNotesModal: false,
        showNewNoteTextField: false,
        expandWorkoutSessionID: null,
        anw: true,
        workoutNotesHeader: [
          {
            text: 'Create Date',
            align: 'left',
            sortable: false
          },
          {
            text: 'Created by',
            align: 'left',
            sortable: false
          },
          {
            text: 'Note',
            align: 'left',
            sortable: false
          }
        ],
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
          {
            text: '',
            sortable: false
          }
        ],
        workoutHeader: [
          {
            text: 'Activity Description', 
            align: 'center',
            sortable: true,
            value: 'WorkoutDescription',
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
        newWorkoutSet:{
          workoutSetTypeID: 1,
          workoutSetWeight: "",
          workoutSetReps: null,
          workoutSetExerciseTimeHours: null,
          workoutSetExerciseTimeMinutes: null,
          workoutSetExerciseTimeSeconds: null,
          workoutSetSplitTimeMinutes: null,
          workoutSetSplitTimeSeconds: null,
          workoutSetSPM: null,
          workoutSetRestTimeMinutes: null,
          workoutSetRestTimeSeconds: null,
          workoutSetWorkoutID: null,
          workoutSetSessionID: null,
          workoutSetDistanceTypeID: 1,
          workoutSetDistance: null
        },
        workoutPagination: {
          sortBy: 'WorkoutID'
        },
        workoutNotesPagination: {
          sortBy: 'NoteID'
        },
        workoutSessionPagination: {
          sortBy: 'CreateDT',
          descending: true
        },
        workoutNotes: [],
        newWorkoutNote: {
          systemAreaID: 1,
          noteContent: "",
          forUserID: 0
        }
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
      addWorkoutSet: function(workoutID, workoutSessionID){
        if(this.newWorkoutSet.workoutSetWeight.replace(/\s/g,'') == ""){
          this.newWorkoutSet.workoutSetWeight = null;
        }
        this.newWorkoutSet.workoutSetWorkoutID = workoutID;
        this.newWorkoutSet.workoutSetSessionID = workoutSessionID;
        generalAPICall('addWorkoutSet', this.newWorkoutSet).then(function(data){
          if(data === false){
            this.$parent.$emit('update-alert', "Failure", "Set was not added, please try again later.");
          } else {
            this.pullWorkoutData().then(function(){
              this.$parent.$emit('update-alert', "Success", "Set added successfully!");
              this.newWorkoutSetModal = false;
              this.newWorkoutSet.workoutSetTypeID = 1,
              this.newWorkoutSet.workoutSetWeight = "",
              this.newWorkoutSet.workoutSetReps = null,
              this.newWorkoutSet.workoutSetExerciseTimeHours = null,
              this.newWorkoutSet.workoutSetExerciseTimeMinutes = null,
              this.newWorkoutSet.workoutSetExerciseTimeSeconds = null,
              this.newWorkoutSet.workoutSetSplitTimeMinutes = null,
              this.newWorkoutSet.workoutSetSplitTimeSeconds = null,
              this.newWorkoutSet.workoutSetSPM = null,
              this.newWorkoutSet.workoutSetRestTimeMinutes = null,
              this.newWorkoutSet.workoutSetRestTimeSeconds = null,
              this.newWorkoutSet.workoutSetWorkoutID = null,
              this.newWorkoutSet.workoutSetSessionID = null
            }.bind(this));
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
      showWorkoutSet: function(a, b){
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
      noWorkoutSetsInWorkout: function(workoutID){
        var setExists = 0;
        var i = 0;
        for(i = 0; i < this.userWorkoutSets.length; i++){
          if(this.userWorkoutSets[i].WorkoutID == workoutID){
            setExists = 1;
          }
        }
        return !setExists;
      },
      pullWorkoutData: function(){
        var apiPromises = [];
        
        apiPromises.push(generalAPICall('getUserWorkouts').then(function(data){
          this.userWorkouts = data;
          return true;
        }.bind(this)));
        
//        generalAPICall('getUserWorkoutSets').then(function(data){
//          this.userWorkoutSets = data;
//        }.bind(this));
        
        apiPromises.push(generalAPICall('getUserWorkoutSessions').then(function(data){
          this.userWorkoutSessions = data;
          var i = 0;
          while(i < this.userWorkoutSessions.length){
            this.userWorkoutSessions[i].CreateDT = formatDateTime(this.userWorkoutSessions[i].CreateDT);
            i++;
            return true;
          }
        }.bind(this)));
        
        apiPromises.push(generalAPICall('getUserWorkoutSets').then(function(data){
          this.userWorkoutSets = data;
          return true;
        }.bind(this)));
        
        if(this.workoutSessionTypes.length == 0){
          apiPromises.push(generalAPICall('getWorkoutSessionTypes').then(function(data){
            this.workoutSessionTypes = data;
            this.newWorkoutSession.workoutType = data[0];
            return true;
          }.bind(this)));
        }
        
        if(this.workoutSetTypes.length == 0){
          apiPromises.push(generalAPICall('getWorkoutSetTypes').then(function(data){
            this.workoutSetTypes = data;
            //this.newWorkoutSet.workoutSetTypeID = data[0];
            return true;
          }.bind(this)));
        }
        
        if(this.distanceTypes.length == 0){
          apiPromises.push(generalAPICall('getDistanceTypes').then(function(data){
            this.distanceTypes = data;
            //this.newWorkoutSet.workoutSetTypeID = data[0];
            return true;
          }.bind(this)));
        }
        
        return Promise.all(apiPromises).then(function(values){
          return values;
        });
      },
//      expandNewWorkoutSession(props, sessionID){
//        if(sessionID == this.expandWorkoutSessionID){
//          props.expanded = !props.expanded;
//        }
//        return;
//      },
      expandWorkoutSession: function(event, props){
        if(event.target.tagName == "I"){
          return;
        }
        this.newWorkoutSessionModal = false;
        this.newWorkoutModal = false;
        this.newWorkoutSetModal = false;
        this.newWorkout = {
          workoutDescription: '',
          workoutSessionID: 0
        }
        props.expanded = !props.expanded
        this.newWorkoutModal = false;
        this.$forceUpdate();
      },
      expandWorkoutSet: function(props){
        this.newWorkoutSessionModal = false;
        this.newWorkoutModal = false;
        this.newWorkoutSetModal = false;
        props.expanded = !props.expanded
//        this.newSet = {
//          workoutSetID: 0
//        }
//        props.expanded = !props.expanded
//        this.newSettModal = false;
//        this.$forceUpdate();
      },
      addNewNote: function(){
        //this.newWorkoutNote.systemAreaID = workoutSessionID;
        generalAPICall('addWorkoutNote', this.newWorkoutNote).then(function(data){
          if(data === false){
            this.$parent.$emit('update-alert', "Failure", "Note was not added, please try again later.");
          } else {
            this.$parent.$emit('update-alert', "Success", "Note was added successfully to your workout!");
          }
          this.showNewNoteTextField = false;
          this.workoutNotesModal = false;
        }.bind(this));
      },
      viewWorkoutNotes: function(event, workoutSessionID){
        this.workoutNotes = [];
        this.newWorkoutNote.systemAreaID = workoutSessionID;
        var workoutSessionJSON = { workoutSessionID: workoutSessionID };
        generalAPICall('getWorkoutNotes', workoutSessionJSON).then(function(data){
          this.workoutNotes = data;
          var i = 0;
//          while(i < this.workoutNotes.length){
//            this.workoutNotes[i].CreateDT = formatDateTime(this.workoutNotes[i].CreateDT);
//            console.log(this.workoutNotes[i].CreateDT);
//            i++;
//          }
          this.workoutNotesModal = true;
          this.$forceUpdate();
        }.bind(this))      
        return true;
      }
    },
    mounted: function(){
      this.pullWorkoutData();
    }
  }
</script>