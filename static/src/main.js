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
//require('smoothscroll-polyfill').polyfill();

Vue.use(VueRouter);
Vue.use(Vuetify);
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

router.afterEach((to, from, next) => {
  var h = document.getElementById("header");
  if(to.name == "home"){
    h.style.display = "none";
  } else {
    h.style.display = "grid";
  }
});

var vm = new Vue({
  el: '#app',
  router,
  render: h => h(App)
});
//console.log(Vue);