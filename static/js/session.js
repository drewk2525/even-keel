import axios from 'axios'

//function isValidSession(callBack = null){
//  axios.post('/api/checkValidSession')
//    .then(function(data){
//      if(typeof callBack === "function"){
//        if(data['data'] != 0){
//          callBack(true);
//        } else {
//          callBack(false);
//        }
//      }
//      return 0;
//  });
//}

function isValidSession(userData){
  if(typeof userData === "undefined" || userData.isValidSession == 0){
    return false;
  }
  return true;
}

function getUserData(callBack = null){
  axios.post('/api/checkValidSession')
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

export { getUserData, isValidSession }