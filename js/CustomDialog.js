var window_chaild;
var window_another_application;

function openCustomDialog(url, setting) {
    window_chaild = window.open(url, "window_chaild", setting);
    window_chaild.focus();
}
    
function openCustomDialogByAnthorApplication() {
    window_another_application = window.open("", "window_another_application");
    document.SWICH_APPLICATION_FORM.target = "window_another_application";
    document.SWICH_APPLICATION_FORM.submit();
    window_another_application.focus();
}


