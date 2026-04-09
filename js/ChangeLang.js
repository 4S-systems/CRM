 
function reloadAE(nextMode) {
    
    console.log("reloadAE");
    console.log(nextMode);
    var url = "/ajaxGetItrmName?key=" + nextMode;
    if (window.XMLHttpRequest) {
        req = new XMLHttpRequest();
    } else if (window.ActiveXObject) {
        req = new ActiveXObject("Microsoft.XMLHTTP");
    }

    req.open("Post",url,true);
    req.onreadystatechange =  callbackFillreload;
    req.send(null);
      
}

function callbackFillreload() {
    if (req.readyState==4) {
        if (req.status == 200) {
            window.location.reload();
        }
    }
}
 
function reloadLang(nextMode, sys) {
    alert(sys + '/ajaxGetItrmNamekey=' + nextMode + '  ------------------------');
    $.ajax({
        type : 'post',
        url  : sys + '/ajaxGetItrmName',
        data : 'key=' + nextMode,
        success : function (msg) {
            window.location.reload();
        }
    });
}

function checkUrl(url, context) {
    var URL = context + "/ajaxServlet?op=checkUrl&url=" + url;
    if (window.XMLHttpRequest) {
        sender = new XMLHttpRequest();
    } else if (window.ActiveXObject) {
        sender = new ActiveXObject("Microsoft.XMLHTTP");
    }

    sender.open("Post", URL, true);
    sender.onreadystatechange =  callback;
    sender.send(null);
}

function callback(){
    if (sender.readyState==4) {
        if (sender.status == 200) {
            var url = sender.responseText;
            document.SWICH_APPLICATION_FORM.action = url;
            openFleetApplication();
        }
    }
}

function openFleetApplication() {
    openCustomDialogByAnthorApplication();
}
 