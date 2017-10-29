<template>
  <div class="myAppPage mainBody">
    <div class="mainBodyWrapper">
      <h2>Welcome {{ userData.firstName }} {{ userData.lastName }}!</h2>
      <ul>
        <li>{{ userData.email }}</li>
        <li>{{ userData.userTypeID }} - {{ userData.userTypeDescription }}</li>
      </ul>
      <form v-on:submit.prevent="addHeartRate">
        <fieldset>
          <legend>Add Heart Rate</legend>
          <label for="heart-rate-type">Type of heart rate:</label>
          <select name="heart-rate-type" v-model="newHeartRate.heartRateType">
            <option v-for="hr in heartRateData" v-bind:value="hr[0]">{{ hr[1] }}</option>
          </select>
          <label for="heart-rate-value">HeartRate:</label>
          <input type="text" name="heart-rate-value" placeholder="BPM" v-model="newHeartRate.heartRateValue"><br>
          <button>Submit Heart Rate</button>
          <v-alert success v-model="createdHeartRate">Successfully submitted Heart Rate</v-alert>
          <v-alert error v-model="createdHeartRateError">There was an error submitting your Heart Rate.  Please try again later.</v-alert>
        </fieldset>
      </form>
    </div>
  </div>  
</template>


<script>
  import axios from 'axios'
  import { getUserData } from '../js/session.js'
  import { getHeartRateTypes, addHeartRate, generalAPICall } from '../js/api.js'
  
  export default {
    name: 'app',
    data () {
      return {
        userData: {},
        createdHeartRate: false,
        createdHeartRateError: false,
        heartRateData: [],
        newHeartRate: {
          heartRateType: 1,
          heartRateValue: ''
        }
      }
    },
    created: function() {
      console.log("Heart Rate Data, CREATED:");
      console.log(this.heartRateData);
      console.log(this.heartRateData.length);
      for(var i=0; i<this.heartRateData.length; i++){
        console.log(this.heartRateData[i].heartRateType + " " + this.heartRateData[i].heartRateValue);
      }
    },
    methods: {
      addHeartRate: function(event){
        generalAPICall('addHeartRate', this.newHeartRate).then(function(data){
          this.createdHeartRate = true;
          setTimeout(function(){
            this.createdHeartRate = false;
          }.bind(this), 5000);
        }.bind(this),
        function(error){
          this.createdHeartRateError = true;
          setTimeout(function(){
            this.createdHeartRateError = false;
          }.bind(this), 5000);
        }.bind(this));
//        addHeartRate(this.newHeartRate).then(function(data){
//          this.createdHeartRate = true;
//        }.bind(this));
      }
    },
    mounted: function(){
      generalAPICall('getHeartRateTypes').then(function(data){
        this.heartRateData = data;
      }.bind(this));
//      getHeartRateTypes().then(function(data){
//        this.heartRateData = data;
//      }.bind(this));
    },
    beforeCreate: function(){
      generalAPICall('checkValidSession').then(function(data){
        this.userData = data;
        this.$emit('update-session', data);
      }.bind(this));
    },
    beforeRouteEnter (to, from, next){
      axios.post('/api/checkValidSession')
        .then(function(data){
          if(data['data'] == 0){
            next('/register');
          } else {
            next();
          }
      });
    }
  }
</script>