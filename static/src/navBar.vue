<template>
  <div>
    <h4>Here's my nav bar XOXO</h4>
    {{ title }}
  </div>
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
//        console.log("reloadNav function");
//        console.log(vars);
      }
    },
    mounted: function(){
      console.log("mounted nav");
    }
  }
</script>