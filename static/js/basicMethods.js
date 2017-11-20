function clearAlerts(t){
  console.log(t);
  t.alertMessage = ""
  t.alertSuccess = false;
  t.alertFailure = false;
}

export { clearAlerts }