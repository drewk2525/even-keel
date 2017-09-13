import Vue from 'vue'
import VueRouter from 'vue-router'
import App from './App.vue'

// Leaving this for reference for using a custom plugin
// import $EvenKeel from '../js/vueMethods.js'

import LoginPage from './login.vue'
import Home from './home.vue'
import MyApp from './myApp.vue'

Vue.use(VueRouter);
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
//console.log(Vue);