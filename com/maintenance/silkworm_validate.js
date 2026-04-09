function IsNumeric(sText)
{
    var ValidChars = "0123456789.";
    var IsNumber=true;
    var Char;
    for (i = 0; i < sText.length && IsNumber == true; i++) 
    { 
        Char = sText.charAt(i); 
        if (ValidChars.indexOf(Char) == -1) 
        {
            IsNumber = false;
        }
    }
    return IsNumber;
}

function validatePhone(control, message){
    if(!IsNumeric(control.value)){
        alert (message);
        control.focus();
    }
}

function checkEmail(email) {
   if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){
       return (true)
   }
   return (false)
}

function validateEmail(control, message){
    if(!checkEmail(control.value)){
        alert (message);
        control.focus();
    }
}