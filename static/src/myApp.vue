<template>
  <div class="myApp-page main-body">
    <h2>{{title}}</h2>
    <ul>
      <li>{{email}}</li>
      <li>{{firstName}} {{lastName}}</li>
      <li>{{userTypeID}}-{{userTypeDescription}}</li>
    </ul>
  </div>
</template>


<script>
  export default {
    name: 'app',
    data () {
      return {
        title: 'My App Landing Page',
        email: this.$route.params.email,
        firstName: this.$route.params.first,
        lastName: this.$route.params.last,
        userTypeID: this.$route.params.userTypeID,
        userTypeDescription: this.$route.params.userTypeDescription
      }
    },
    //created function code won't run until this page is created by navigating to it
    created: function() {
      //$route keeps the parameters persistent. That's why we can access the .params
      console.log(this.$route.params);
    }
  }
</script>