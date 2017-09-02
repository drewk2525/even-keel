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
          <input type="radio" name="user-type" value="1" id="user-type-1">
          <label class="radio-label" for="user-type-2">Coach:</label>
          <input type="radio" name="user-type" value="2" id="user-type-2">
          <label class="radio-label" for="user-type-3">Admin</label>
          <input type="radio" name="user-type" value="3" id="user-type-3">
        </fieldset>
        <label>First Name:</label>
        <input type="text" name="first-name" placeholder="First Name"><br>
        <label>Last Name:</label>
        <input type="text" name="last-name" placeholder="Last Name">
        <label>Email Address:</label>
        <input type="text" name="email" placeholder="you@example.com">
        <label>Password:</label>
        <input type="password" name="password">
        <label>Repeat Password:</label>
        <input type="password" name="repeat-password">
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
        user: {},
        title: 'Even Keel Login'
      }
    },
    methods: {
      login: function(event){
        $.post('/login')
          .done(function(data){
            this.user = data;
            console.log(this.user.email);
            console.log(this.user.first);
            console.log(this.user.last);
          }.bind(this));
      }
    }
  }
</script>