<template>
  <div class="mainWrapper">
    <header id="header" class="mainHeader">
      <div class="headerLogo">
        <a href="#/">
          <img src="../assets/logo.png" class="logo">
        </a>
      </div>
      <div class="title">
<!--        <nav-bar @reload-nav="reloadNav"></nav-bar>-->
<!--        <button v-if="validSession" @click="logout">Log Out</button>-->
        <nav v-if="validSession">
          <button @click="logout">Log Out</button>
        </nav>
        <nav v-else>
          | <a href="/">Home</a> | <a href="/">About</a> | <a href="/">Contact</a> |
        </nav>
      </div>
      <h1 v-if="validSession">Welcome back {{ userData.firstName | camel }}</h1>
    </header>
    <v-app>
      <v-alert color="success" dismissible v-model="alertSuccess">{{ alertMessage }}</v-alert>
      <v-alert color="error" dismissible v-model="alertFailure">{{ alertMessage }}</v-alert>
      <router-view :msg="msg" @update-session="updateIsValidSession" @update-alert="updateAlert" @reset-alerts="resetAlerts">
      </router-view>
    </v-app>
  </div>
</template>

<script>
  import axios from 'axios'
  import { isValidSession } from '../js/session.js'
  import navBar from './navBar.vue'
  import { clearAlerts } from '../js/basicMethods.js'
  
  export default {
    name: 'app',
    components: {
      navBar
    },
    data () {
      return {
        alertSuccess: false,
        alertFailure: false,
        alertMessage: '',
        validSession: false,
        userData: {}
      }
    },
    methods:{
      logout: function(){
        axios.post('/api/logout').then(function(data){
          this.validSession = false;
          this.$router.push({
            name: 'home', 
            params: this.result
          });
        }.bind(this));
      },
      updateIsValidSession: function(userData){
        this.validSession = isValidSession(userData);
        this.userData = userData;
      },
      resetAlerts: function(){
        clearAlerts(this);
      },
      updateAlert: function(alertType, alertMessage){    
        switch(alertType){
          case "Success":
            this.alertSuccess = true
            break;
          case "Failure":
            this.alertFailure = true
            break;
        }
        this.alertMessage = alertMessage;
        window.scrollTo(0, 0);
      }
    },
    created: function(){
      
    }
  }
</script>