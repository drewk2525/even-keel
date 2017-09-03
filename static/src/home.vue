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
        <input type="text" name="first-name" placeholder="First Name" v-model="newUser.firstName"><br>
        <label>Last Name:</label>
        <input type="text" name="last-name" placeholder="Last Name" v-model="newUser.lastName">
        <label>Email Address:</label>
        <input type="text" name="email" placeholder="you@example.com" v-model="newUser.email">
        <label>Password:</label>
        <input type="password" name="password" v-model="newUser.password">
        <label>Repeat Password:</label>
        <input type="password" name="repeat-password" v-model="newUser.repeatPassword">
        <button>Create Account</button>
      </form>
    </div>
  </div>
</template>

<script>  
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
        title: 'Even Keel Login'
      }
    },
    methods: {
      createNewUser: function(event){
        $.post('/api/newUser', JSON.stringify(this.newUser) )
          .done(function(data){
            this.user = data;
            this.$router.push('/myApp');
          }.bind(this));
      },
      
      checkLogin: function(event){
        $.post('/api/login', JSON.stringify(this.checkUser) )
          .done(function(data){
            this.result = data;
            console.log(data);
            if(this.result != 'false'){
              //re-routing and passing params, this.result goes to page
              this.$router.push({
                //we had to use this name for the route, defined in main.js
                name: 'my-app', 
                params: this.result
              });
            } else {
              this.loginFail = true;
            }
        }.bind(this));
      }
      
    }
  }
</script>