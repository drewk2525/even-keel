import Vue from 'vue'
import VueRouter from 'vue-router'
import App from './App.vue'
import Vuetify from 'vuetify'

// Leaving this for reference for using a custom plugin
// import $EvenKeel from '../js/vueMethods.js'

import LoginPage from './login.vue'
import Home from './home.vue'
import MyApp from './myApp.vue'
import Login from './login.vue'
import '../../node_modules/vuetify/dist/vuetify.min.css'
import { getUserData } from '../js/session.js'
import { clearAlerts } from '../js/basicMethods.js'
//require('smoothscroll-polyfill').polyfill();

Vue.use(VueRouter);
Vue.use(Vuetify);

Vue.config.devtools = true

Vue.filter('camel',function(str){
  return str.toLowerCase().replace(/^\w|\s\w/g, function (letter) {
    return letter.toUpperCase();
  });
});

Vue.filter('secondsToHours', function(sec){
  var hours = Math.floor(sec/3600);
  if(hours == 0){
    hours = "";
  } else {
    hours = hours + ":"
  }
  return hours;
});
Vue.filter('secondsToMinutes', function(sec){
  var hours = Math.floor(sec/3600);
  var minutes = Math.floor((sec-hours*3600)/60);
  if(hours > 0 && minutes < 10){
    minutes = "0" + minutes;
  }
  return minutes;
});
Vue.filter('secondsToSeconds', function(sec){
  var hours = Math.floor(sec/3600);
  var minutes = Math.floor((sec-hours*3600)/60);
  var seconds = (Math.round(10*parseFloat(sec - (hours*3600 + minutes*60)))/10).toFixed(1);
  if(seconds < 10){
    seconds = "0" + seconds;
  }
  return seconds;
});


var moment = require('moment');

Vue.filter('dateTime', function(date){
  var d = moment(date).format("MM/DD/YYYY hh:mm a");
  return d;
});

// Leaving this for reference for using a custom plugin
// Vue.use($EvenKeel);

const routes = [
  {
    path: '/login',
    component: LoginPage
  },
  {
    path: '/',
    name: 'home',
    component: Home
  },
  {
    path: '/myApp',
    name: 'my-app',
    component: MyApp
  },
  {
    path: '/register',
    name: 'registration',
    component: Login
  }
]

const router = new VueRouter({
  routes
});

var vm = new Vue({
  el: '#app',
  router,
  render: h => h(App)
});

router.afterEach((to, from, next) => {
  clearAlerts(vm.$children[0]);
  var h = document.getElementById("header");
  if(to.name == "home"){
    h.style.display = "none";
  } else {
    h.style.display = "grid";
  }
});