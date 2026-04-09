function IsNumeric(sText) {
    var ValidChars = "0123456789.";
    var IsNumber=true;
    var Char;
    
    if(sText.length == 0){
        IsNumber = false;
    }
    
    for (i = 0; i < sText.length && IsNumber == true; i++) { 
        Char = sText.charAt(i); 
        if (ValidChars.indexOf(Char) == -1) {
            IsNumber = false;
        }
    }
    return IsNumber;
    
}

function createNumericValidator(elementToValidate) {
    var elm;
    if(!(elm = document.getElementById(elementToValidate))) {
        return;
    }
    document.write("<div id='validate" + elm.id +"' class='pwdvalid'></div>");
    elm.onkeyup = function () {validateNumeric(elm.id)};	
}

function validateNumeric(elementToValidate) {
    var elm;
    if(!(elm = document.getElementById(elementToValidate))) {
        return;
    }
    var div = document.getElementById("validate" + elm.id);
    //var sNumber = elm.value;
    
    if(IsNumeric(elm.value)){
        div.innerHTML = "Valid";
        return;
    } else {
        div.innerHTML = "Not Valid";
        return;
    }		
}