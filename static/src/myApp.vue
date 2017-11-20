<template>
  <div class="myAppPage mainBody">
    <div class="mainBodyWrapper">
      <nav class="mainNavigation">
        <button class="workouts" id="workouts" @click="updateDataView"></button><span>Workouts</span>
        <button class="heartRates" id="heartRates" @click="updateDataView"></button><span>Heart Rates</span>
        <button class="athleteData" id="athleteData" @click="updateDataView"></button><span>Athlete Data</span>
        <button class="performance" id="performance" @click="updateDataView"></button><span>Performance</span>
      </nav>
      <div>
        <workouts v-if="dataView == 'workouts'"></workouts>
        <heart-rates v-if="dataView == 'heartRates'"></heart-rates>
      </div>
    </div>
  </div>  
</template>


<script>
  import axios from 'axios'
  import { getUserData } from '../js/session.js'
  import { generalAPICall } from '../js/api.js'
  import heartRates from './heartRates.vue'
  import workouts from './workouts.vue'
  
  export default {
    name: 'app',
    data: {
      
    },
    components: {
      heartRates,
      workouts
    },
    data () {
      return {
        userData: {},
        dataView: "heartRates"
      }
    },
    methods: {
      updateDataView: function(event){
        this.dataView = event.target.id;
      }
    },
    mounted: function(){
      
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