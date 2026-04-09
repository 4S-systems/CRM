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
    if(email.length <= 0){
        return (true);
    }
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

function getASSCIChar(value) {
    var res = "";

    for (var i=0;i < value.length; i++) {
        res += value.charCodeAt(i) + ',';
    }

    res = res.substr(0, res.length - 1);

    return res;
}

function IsNumericInt(id) {
    var ValidChars = "0123456789";
    var IsNumber=true;
    var Char;
    var sText=document.getElementById(id).value;

    for (var i = 0; i < sText.length && IsNumber == true; i++) {
        Char = sText.charAt(i);

        if (ValidChars.indexOf(Char) == -1) {
            IsNumber = false;
            alert("This Value { " + sText +" } must be positive integer and more than zero");
            document.getElementById(id).value='';
            document.getElementById(id).focus();
        }
    }

    return IsNumber;
}

function roundNumber(number, decimal) {
    var result = Math.round(number * Math.pow(10, decimal)) / Math.pow(10, decimal);
    return result;
}

function cahangePage(url){
    window.navigate(url);
}