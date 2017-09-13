<template>
  <div class="myApp-page main-body">
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
        <div v-if="createdHeartRate">Successfully submitted Heart Rate</div>
      </fieldset>
    </form>
  </div>
</template>


<script>
  import axios from 'axios'
  import { getUserData } from '../js/session.js'
  import { getHeartRateTypes, addHeartRate } from '../js/api.js'
  
  export default {
    name: 'app',
    data () {
      return {
        userData: {},
        createdHeartRate: false,
        heartRateData: {},
        newHeartRate: {
          heartRateType: 0,
          heartRateValue: ''
        }
      }
    },
    created: function() {

    },
    methods: {
      addHeartRate: function(event){
        console.log("Before");
        addHeartRate(function(data){
          this.createdHeartRate = true;
          console.log(data);
        }.bind(this), this.newHeartRate);
        console.log("After");
      }
    },
    beforeCreate: function(){
      getUserData(function(data){
        this.userData = data;
        this.$emit('update-session', data);
      }.bind(this));
      getHeartRateTypes(function(data){
        this.heartRateData = data;
        console.log(data);
      }.bind(this));
    },
    beforeRouteEnter (to, from, next){
      axios.post('/api/checkValidSession')
        .then(function(data){
          if(data['data'] == 0){
            next('/');
          } else {
            next();
          }
      });
    }
  }
</script>