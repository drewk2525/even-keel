<template>
  <div id="app" class="container">
    <header class="">
      <div class="">
        <a href="#/">
          <img src="../assets/logo.png">
        </a>
      </div>
      <div class="title">
        <h3>{{ title }}</h3>
      </div>
    </header>
    <router-view :msg="msg">
    </router-view>
  </div>
</template>

<script>
export default {
  name: 'app',
  data () {
    return {
      msg: 'some Message',
      title: 'Welcome to Even Keel'
    }
  }
}
</script>