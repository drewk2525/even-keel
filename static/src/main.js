import Vue from 'vue'
import VueRouter from 'vue-router'
import App from './App.vue'
//
//import ProductLIst from './ProductList.vue'
import LoginPage from './login.vue'
import Home from './home.vue'

Vue.use(VueRouter);

const routes = [
  {
    path: '/login',
//    ,
//    component: ProductList
    component: LoginPage
  },
  {
    path: '/',
    component: Home
  }
//  ,
//  {
//    path: '/products/:id',
//    component: Product
//  }
]

const router = new VueRouter({
  routes
});

new Vue({
  el: '#app',
  router,
  render: h => h(App)
})
