import axios from 'axios'

function getHeartRateTypes(callBack = null){
  axios.post('/api/getHeartRateTypes')
    .then(function(data){
      if(data['data'] == 0){
        return 0;
      }
      if(typeof callBack === "function"){
        callBack(data['data']);
      } else {
        return data['data'];
      }
    });
}

function addHeartRate(callBack = null, HR){
  axios.post('/api/addHeartRate', JSON.stringify(HR))
    .then(function(data){
      if(data['data'] == 0){
        return 0;
      }
      if(typeof callBack === "function"){
        callBack(data['data']);
      } else {
        return data['data'];
      }
    });
}

export { getHeartRateTypes, addHeartRate }