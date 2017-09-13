<template>
  <div id="app" class="container">
    <header class="">
      <div class="">
        <a href="#/">
          <img src="../assets/logo.png">
        </a>
      </div>
      <div class="title">
<!--        <nav-bar @reload-nav="reloadNav"></nav-bar>-->
        <button v-if="validSession" @click="logout">Log Out</button>
      </div>
    </header>
    <router-view :msg="msg" @update-session="updateIsValidSession">
    </router-view>
  </div>
</template>

<script>
  import axios from 'axios'
  import { isValidSession } from '../js/session.js'
  import navBar from './navBar.vue'
  
  export default {
    name: 'app',
    components: {
      navBar
    },
    data () {
      return {
        validSession: false,
        userData: {}
      }
    },
    methods:{
      logout: function(){
        axios.post('/api/logout').then(function(data){
          this.$router.push({
            name: 'home', 
            params: this.result
          });
        }.bind(this));
      },
      updateIsValidSession: function(userData){
        this.validSession = isValidSession(userData);
      }
    }
  }
</script>