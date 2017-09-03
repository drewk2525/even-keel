<template>
  <div class="home main-body">
    <div class="login">
      <h2>Log in to existing account</h2>
      <form action="#/login" method="POST">
        <label>Email Address:</label>
        <input type="text" name="email" placeholder="Email Address">
        <label>Password:</label>
        <input type="password" name="password">
        <button>Sign In</button>
      </form>
      <!--<br>{{ msg }}-->
    </div>
    <div class="new-account">
      <h2>Create an account</h2>
      <form v-on:submit.prevent="login">
        <fieldset>
          <legend>User Type:</legend>
          <label class="radio-label" for="user-type-1">Athlete:</label>
          <input type="radio" name="user-type" value="1" id="user-type-1" v-model="newUser.userType">
          <label class="radio-label" for="user-type-2">Coach:</label>
          <input type="radio" name="user-type" value="2" id="user-type-2" v-model="newUser.userType">
          <label class="radio-label" for="user-type-3">Admin</label>
          <input type="radio" name="user-type" value="3" id="user-type-3" v-model="newUser.userType">
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
          userType: 1,
          firstName: '',
          lastName: '',
          email: '',
          password: '',
          repeatPassword: ''
        },
        user: {},
        title: 'Even Keel Login'
      }
    },
    methods: {
      login: function(event){
        $.post('/api/newUser', JSON.stringify(this.newUser) )
          .done(function(data){
            this.user = data;
            this.$router.push('/login');
//            console.log(this.user.first);
//            console.log(this.user.last);
//            console.log(this.user.email);
          }.bind(this));
      }
    }
  }
</script>