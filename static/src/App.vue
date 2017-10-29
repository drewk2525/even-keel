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
<!--        <button v-if="validSession" @click="logout">Log Out</button>-->         <nav v-if="validSession">
          <button @click="logout">Log Out</button>
        </nav>
        <nav v-else>
          | <a href="/">Home</a> | <a href="/">About</a> | <a href="/">Contact</a> |
        </nav>
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
          this.validSession = false;
          this.$router.push({
            name: 'home', 
            params: this.result
          });
        }.bind(this));
      },
      updateIsValidSession: function(userData){
        this.validSession = isValidSession(userData);
      }
    },
    created: function(){

    }
  }
</script>