<template>
  <div class="home mainBody">
    <div class="landingPageHeader">
      <nav id="navigation">
        | <a href="/">Home</a> | <a href="#aboutSection">About</a> | <a href="/">Contact</a> |
      </nav>
    </div>
    <div class="landingPage">
      <v-parallax src="/static/assets/singleRower.jpg" height="1100">
      </v-parallax>
      <img class="logo" src="../assets/logo.png">
      <div class="buttons">
        <button id="registerButton" class="greenButton landingRegisterButton" @click="routeLoginRegister">
          Register
        </button>
        <button id="loginButton" class="blueButton landingLoginButton" @click="routeLoginRegister">
          Login
        </button>
      </div>
    </div>
    <div class="contentBody" id="aboutSection">
      <h1>About Section</h1>
    </div>
  </div>
</template>

<!--
<style>
  header.mainHeader {
    display: none;
  }
</style>
-->

<script> 
  import axios from 'axios'
  export default {
    name: 'app',
    props: ['msg'],
    data () {
      return {
        newUser: {
          userTypeID: 1,
          firstName: '',
          lastName: '',
          email: '',
          password: '',
          repeatPassword: ''
        },
        loginFail: false,
        user: {},
        checkUser: {
          email: '',
          password:''
        },
        currentUser: {
          firstName: '',
          lastName: '',
          email: '',
          userTypeID: ''
        },
        formErrors: {
          firstName: [],
          lastName: [],
          email: [],
          password: [],
          repeatPassword: []
        },
        formErrorsExist: 0,
        title: 'Even Keel Login'
      }
    },
    methods: {
      routeLoginRegister: function(event){
        var b = event.path[0].id;
        var i = b.indexOf("Button");
        b = b.substr(0, i);
        this.$router.push({
          name: 'registration',
          params: { formDisplay: b }
        });
      },
      createNewUser: function(event){
        this.checkFormErrors();
        if (this.formErrorsExist > 0)
          return false;
        axios.post('/api/newUser', JSON.stringify(this.newUser) )
          .then(function(data){
            this.user = data;
            this.$router.push('/myApp');
          }.bind(this));
      },
      checkLogin: function(event){
        this.checkFormErrors();
        axios.post('/api/login', JSON.stringify(this.checkUser) )
          .then(function(data){
            this.result = data;
            if(data['data'] != 0){
              //re-routing and passing params, this.result goes to page
              this.$router.push({
                //we had to use this name for the route, defined in main.js
                name: 'my-app', 
                params: this.result['data']
              });
            } else {
              console.log("Login Failed");
            }
        }.bind(this));
      },
      validateFirstName: function(event){
        this.$set(this.formErrors, 'firstName', validateName(this.newUser.firstName));
      },
      validateLastName: function(event){
        this.$set(this.formErrors, 'lastName', validateName(this.newUser.lastName));
      },
      validateEmail: function(event){
        this.$set(this.formErrors, 'email', validateEmail(this.newUser.email));
      },
      validatePassword: function(event){
        this.$set(this.formErrors, 'password', validatePassword(this.newUser.password));
      },
      validateRepeatPassword: function(event){
        var test = 1
        if(event.type == 'keyup' && this.formErrors['repeatPassword'].length == 0){
          test = 0;
        }
        this.$set(this.formErrors, 'repeatPassword', validateRepeatPassword(this.newUser.password, this.newUser.repeatPassword, test));
      },
      checkFormErrors: function(event){
        this.$set(this.formErrors, 'firstName', validateName(this.newUser.firstName));
        this.$set(this.formErrors, 'lastName', validateName(this.newUser.lastName));
        this.$set(this.formErrors, 'email', validateEmail(this.newUser.email));
        this.$set(this.formErrors, 'password', validatePassword(this.newUser.password));
        this.$set(this.formErrors, 'repeatPassword', validateRepeatPassword(this.newUser.password, this.newUser.repeatPassword));
        this.formErrorsExist = 0;
        for(var key in this.formErrors){
          if(this.formErrors[key].length > 0){
            this.formErrorsExist = 1;
          }
        }
      }
    },
    created: function(){
      console.log(this);
    },
    beforeRouteEnter (to, from, next){
      axios.post('/api/checkValidSession')
        .then(function(data){
          if(data['data'] != 0){
            next('/myApp');
          } else {
            next();
          }
      });
    }
  }
</script>