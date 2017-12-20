function clearAlerts(t){
  t.alertMessage = ""
  t.alertSuccess = false;
  t.alertFailure = false;
}

function formatDateTime(date){
  var moment = require('moment');
  return moment(date).format("YYYY-MM-DD hh:mm:ss");
}

export { clearAlerts, formatDateTime }