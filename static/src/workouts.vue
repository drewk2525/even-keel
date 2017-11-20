<template>
  <div>
    <v-data-table
        v-bind:headers="workoutHeader"
        v-bind:items="userWorkouts"
        class="mainTable"
        v-model="selected"
        item-key="WorkoutID"
        select-all
        v-bind:rows-per-page-items="defaultRowsPerPage"
      >
        <template slot="items" scope="props">
          <td>
            <v-checkbox
              primary
              v-model="props.selected"
            ></v-checkbox>
          </td>
          <td>{{ props.item.WorkoutID }}
          </td>
          <td>{{ props.item.WorkoutSessionID }}</td>
          <td>{{ props.item.WorkoutDescription }}</td>
        </template>
      </v-data-table>
<!--
      <form v-on:submit.prevent="addHeartRate">
        <fieldset>
          <legend>Add Heart Rate</legend>
          <label for="heart-rate-type">Type of heart rate:</label>
          <select name="heart-rate-type" v-model="newWorkout.workoutSessionID">
            <option v-for="hr in workoutData" v-bind:value="hr[0]">{{ hr[1] }}</option>
          </select>
          <label for="heart-rate-value">HeartRate:</label>
          <input type="text" name="heart-rate-value" placeholder="BPM" v-model="newWorkout.heartRateValue"><br>
          <button>Submit Heart Rate</button>
          <v-alert success v-model="createdWorkout">Successfully submitted Heart Rate</v-alert>
          <v-alert error v-model="createdWorkoutError">There was an error submitting your Heart Rate.  Please try again later.</v-alert>
        </fieldset>
      </form>
-->
  </div>
</template>


<script>
  import { generalAPICall } from '../js/api.js'
  
  export default {
    name: 'app',
    data () {
      return {
        createdWorkout: false,
        createdWorkoutError: false,
        workoutData: [],
        selected: [],
        userWorkouts: [],
        defaultRowsPerPage:[25, 50, 100, 200],
        workoutHeader: [
          {
            text: 'ID',
            align: 'center',
            sortable: true,
            value: 'WorkoutID'
          },
          {
            text: 'Workout Session', 
            align: 'center',
            sortable: true,
            value: 'WorkoutSessionID'
          },
          {
            text: 'Workout Description', 
            align: 'center',
            sortable: true,
            value: 'WorkoutDescription'
          }
        ],
        newWorkout: {
          workoutSessionID: 1,
          workoutDescription: ''
        }
      }
    }, 
    methods: {
      addHeartRate: function(event){
        generalAPICall('addHeartRate', this.newWorkout).then(function(data){
          this.createdWorkout = true;
          setTimeout(function(){
            this.createdWorkout = false;
          }.bind(this), 5000);
        }.bind(this),
        function(error){
          this.createdWorkoutError = true;
          setTimeout(function(){
            this.createdWorkoutError = false;
          }.bind(this), 5000);
        }.bind(this));
//        addHeartRate(this.newWorkout).then(function(data){
//          this.createdWorkout = true;
//        }.bind(this));
      }
    },
    mounted: function(){
      generalAPICall('getHeartRateTypes').then(function(data){
        this.workoutData = data;
      }.bind(this));
      generalAPICall('getUserWorkouts').then(function(data){
        this.userWorkouts = data;
        console.log(data);
      }.bind(this));
    }
  }
</script>