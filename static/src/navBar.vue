<template>
  <h4>Here's my nav bar XOXO</h4>
  {{ title }}
</template>


<script>
  export default {
    name: 'app',
    data () {
      return {
        title: 'navs'
      }
    }, 
    methods: {
      reloadNav: function(vars){
        console.log("reloadNav function");
        console.log(vars);
      }
    }
  }
</script>