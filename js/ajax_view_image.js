function getImage(context, path, width, height) {
    var url = context + "/ajaxServlet?op=getImage&path=" + path + "&width=" + width + "&height=" + height;
    if (window.XMLHttpRequest) {
        req = new XMLHttpRequest();
    } else if (window.ActiveXObject) {
        req = new ActiveXObject("Microsoft.XMLHTTP");
    }

    req.open("Post", url, true);
    req.onreadystatechange =  callbackFillImage;
    req.send(null);
}

function callbackFillImage(){
    if (req.readyState==4) {
        if (req.status == 200) {
            var responseText = req.responseText.split("<&&>");
            var path = responseText[0];
            var width = responseText[1];
            var height = responseText[2];
        }
    }
}

function getLoadingImage() {
    setTempImage('images/loading.gif', 200, 200);
}

function getNoImage() {
    setTempImage('images/no_image.jpg', 200, 200);
}

function setTempImage(image, width, height) {
    document.getElementById("image").src = image;
    document.getElementById("image").style.width = width;
    document.getElementById("image").style.height = height;
}


