function validateName(str){
  var errors = [];
  if (str.length <= 0){
    errors.push("This field cannot be left blank.");
  }
  if(str.length == 60){
    errors.push("You are currently at the maxiumum length for this field");
  }
  return errors;
}

function validateEmail(email) {
  var errors = [];
  var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  
  // check email length
  // check if email contains @
  if(email.length <= 0){
    errors.push("Please enter your email address.");
  } else if(email.indexOf('@') === -1){
    errors.push("The email address you entered is not valid.");
  }
  return errors;
}

function validatePassword(password){
  var errors = [];
  if (password.length < 8){
    errors.push("Your password must be at least 8 characters in length.");
  }
  if(password.length > 64){
    errors.push("Your password is too long.  Please make sure your password is 64 characters or less in length.");
  }
  return errors;
}

function validateRepeatPassword(pass, repeat, test=1){
  var errors = [];
  if(test == 0){
    return errors;
  }
  if (pass !== repeat){
    errors.push("Both password fields do NOT match.")
  }
  return errors;
}