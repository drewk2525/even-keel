import axios from 'axios'

function generalAPICall(str, obj=null){
  return axios.post('/api/'+str, JSON.stringify(obj))
    .then(function(data){
      if(data['data'] == 0){
        return 0;
      }
      return data['data'];
  },
  function(error){
    return false;
  });
}

//function getHeartRateTypes(){
//  return axios.post('/api/getHeartRateTypes')
//    .then(function(data){
//      if(data['data'] == 0){
//        return 0;
//      }
//      return data['data'];
//    });
//}
//
//function addHeartRate(HR){
//  return axios.post('/api/addHeartRate', JSON.stringify(HR))
//    .then(function(data){
//      if(data['data'] == 0){
//        return 0;
//      }
//      return data['data'];
//    });
//}

export { generalAPICall }