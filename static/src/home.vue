<template>
  <div class="home main-body">
    <div class="login">
      <h2>Log in to existing account</h2>
      <form v-on:submit.prevent="checkLogin">
        <div class="error" v-if='loginFail'>Login Failed</div>
        <label>Email Address:</label>
        <input type="text" name="email" placeholder="Email Address" v-model="checkUser.email">
        <label>Password:</label>
        <input type="password" name="password" v-model="checkUser.password">
        <button>Sign In</button>
      </form>
      <!--<br>{{ msg }}-->
    </div>
    <div class="new-account">
      <h2>Create an account</h2>
      <form v-on:submit.prevent="createNewUser">
        <fieldset class="error" v-if="formErrorsExist > 0">
          Please correct errors on this form.
        </fieldset>
        <fieldset>
          <legend>User Type:</legend>
          <label class="radio-label" for="user-type-1">Athlete:</label>
          <input type="radio" name="user-type" value="1" id="user-type-1" v-model="newUser.userTypeID">
          <label class="radio-label" for="user-type-2">Coach:</label>
          <input type="radio" name="user-type" value="2" id="user-type-2" v-model="newUser.userTypeID">
          <label class="radio-label" for="user-type-3">Admin:</label>
          <input type="radio" name="user-type" value="3" id="user-type-3" v-model="newUser.userTypeID">
        </fieldset>
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
        <button>Create Account</button>
      </form>
    </div>
  </div>
</template>

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
              console.log(data);
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
      this.$emit('update-session', this.userData);
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