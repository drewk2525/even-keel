import axios from 'axios'

const $EvenKeel = {};
$EvenKeel.install = function(Vue, options){
  Vue.prototype.checkValidSession = function(destination){
    axios.post('/api/checkValidSession')
      .then(function(data){
        console.log("Data: ")
        console.log(data);
        if(data['data'] == 0){
          return;
        }
        this.result = data;
        //re-routing and passing params, this.result goes to page
        this.$router.push({
          //we had to use this name for the route, defined in main.js
          name: destination, 
          params: this.result['data']
        });
        return "Huzzah!";
      });
  }
};

export default $EvenKeel;