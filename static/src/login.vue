<template>
  <div class="registrationPage mainBody">
    <div class="registrationPageForms mainBodyWrapper">
      <div> </div>
      <div class="formWrapper">
        <button class="registrationTab" id="registerButton" @click="updateDisplay" v-bind:class="{active: formDisplay == 'register'}" :disabled="formDisplay == 'register'">Register</button>
        <button class="registrationTab" id="loginButton" @click="updateDisplay" v-bind:class="{active: formDisplay == 'login'}" :disabled="formDisplay == 'login'">Login</button>
        <div v-if="formDisplay == 'login'">
          <form @submit.prevent="checkLogin">
            <div class="error" v-if='loginFail'>Login Failed</div>
            <label>Email Address:</label>
            <input type="text" name="email" placeholder="Email Address" v-model="checkUser.email">
            <label>Password:</label>
            <input type="password" name="password" v-model="checkUser.password">
            <button type="submit" class="greenButton">Sign In</button>
          </form>
        </div>
        <div v-else>
          <form @submit.prevent="createNewUser" id="registrationForm">
            <fieldset class="error" v-if="formErrorsExist > 0">
              Please correct errors on this form.
            </fieldset>
            <label>User Type:</label>
            <input type="radio" name="user-type" value="1" id="user-type-1" v-model="newUser.userTypeID">
            <label class="radio-label" for="user-type-1">Athlete</label>
            <input type="radio" name="user-type" value="2" id="user-type-2" v-model="newUser.userTypeID">
            <label class="radio-label" for="user-type-2">Coach</label>     
            <input type="radio" name="user-type" value="3" id="user-type-3" v-model="newUser.userTypeID">
            <label class="radio-label" for="user-type-3">Admin</label>
            <br>
            <label>First Name:</label>
            <input type="text" name="first-name" placeholder="First Name" v-model="newUser.firstName" @blur="validateFirstName" v-bind:class="{ error: formErrors['firstName'].length > 0 }">
            <ul class="error" v-if="formErrors['firstName'].length > 0">
              <li v-for="error in formErrors['firstName']">{{ error }}</li>
            </ul>
            <label>Last Name:</label>
            <input type="text" name="last-name" placeholder="Last Name" v-model="newUser.lastName" @blur="validateLastName" v-bind:class="{ error: formErrors['lastName'].length > 0 }">
            <ul class="error" v-if="formErrors['lastName'].length > 0">
              <li v-for="error in formErrors['lastName']">{{ error }}</li>
            </ul>
            <label>Email Address:</label>
            <input type="text" name="email" placeholder="you@example.com" v-model="newUser.email" @blur="validateEmail" v-bind:class="{ error: formErrors['email'].length > 0 }">
            <ul class="error" v-if="formErrors['email'].length > 0">
              <li v-for="error in formErrors['email']">{{ error }}</li>
            </ul>
            <label>Password:</label>
            <input type="password" name="password" v-model="newUser.password" @blur="validatePassword" v-bind:class="{ error: formErrors['password'].length > 0 }">
            <ul class="error" v-if="formErrors['password'].length > 0">
              <li v-for="error in formErrors['password']">{{ error }}</li>
            </ul>
            <label>Repeat Password:</label>
            <input type="password" name="repeat-password" v-model="newUser.repeatPassword" @blur="validateRepeatPassword" @keyup="validateRepeatPassword" v-bind:class="{ error: formErrors['repeatPassword'].length > 0 }">
            <ul class="error" v-if="formErrors['repeatPassword'].length > 0">
              <li v-for="error in formErrors['repeatPassword']">{{ error }}</li>
            </ul>
            <button type="submit" class="greenButton">Register</button>
          </form>
        </div>
      </div>
      <div></div>
    </div>
  </div>
</template>

<style>
  header.mainHeader {
    display: grid;
  }
</style>

<script> 
  import axios from 'axios'
  import { generalAPICall } from '../js/api.js'
  import { clearAlerts } from '../js/basicMethods.js'
  
  export default {
    name: 'app',
    props: ['msg'],
    data () {
      return {
        formDisplay: '',
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
      updateDisplay: function(event){
        var eid = event.path[0].id;
        if(eid == 'loginButton'){
          this.formDisplay = 'login';
        } else {
          this.formDisplay = 'register';
        }
      },
      createNewUser: function(event){
        this.$emit('reset-alerts');
        this.checkFormErrors();
        if (this.formErrorsExist > 0)
          return false;
        axios.post('/api/newUser', JSON.stringify(this.newUser) )
          .then(function(data){
            //this.user = data;
            this.registrationMessage = data.data;
            if (data.data == "Success"){
              this.$emit('update-alert', data.data, "Your account has been successfully created!");
              document.getElementById("registrationForm").reset();
            } else{
              this.$emit('update-alert', "Failure", data.data);
            }
            this.$router.push('/myApp');
          }.bind(this));
      },
      checkLogin: function(event){
        generalAPICall('login', this.checkUser)
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
      if(typeof this.$route.params.formDisplay == "undefined"){
        this.formDisplay = "register"
      } else {
        this.formDisplay = this.$route.params.formDisplay;
      }
      //this.$emit('update-session', this.userData);
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