//var $j = jQuery.noConflict();           
console.log("  event");
var socket = new WebSocket("ws://" + window.location.host + "/crm/notify");
//console.log(socket);

socket.onopen = function (event) {
    console.log(event);

    if (event.data != undefined)
        writeResponse(event.data);

};

socket.onmessage = onMessage;
var counter = 0;
var conn = false;
function onMessage(event) {
    console.log("onmessage");
    conn = true;
    if (conn)
    {
        console.log("start onMessage event");
        console.log(event);
        var device = JSON.parse(event.data);
        var action = device.action;
        var msg = device.msg;
        console.log("device.action = ");
        console.log(action);
        console.log("device.msg");
        console.log(msg);
        if (action == 'NOTIFY')
        {
            console.log("Notify");
            notify(device.msg);
        }
        if (action == 'ONLINE_USERS')
        {
            var users = device.users;
            console.log("ONLINE_USERS");


            // $("#onlineusers").clear().rows.add(users).draw()
            var arrayLength = users.length;
            $('#onlineusers').dataTable().fnClearTable();
            if (arrayLength != 0)
            {
                $('#onlineusers').dataTable().fnAddData(users);

            }
            console.log("arrayLength= " + arrayLength);
            for (var i = 0; i < arrayLength; i++) {
                console.log(users[i]);
                //Do something
            }
        }
        if (action === 'REDIRECT') {
            console.log("redirect");
            redirectToClient(msg);
        }

    }
    else
    {
        console.log("connection is not established");
    }
    if (event.data == 'Connection Established') {
        conn = true;
    }

}

function sendMessage() {
    console.log("sendMessage");
    console.log("rows_selected.length" + rows_selected.length);
    for (var i = 0; i < rows_selected.length; i++) {

        var id = rows_selected[i];
        console.log(id);
    }
    var message = document.getElementById('message').value;
    var notificationmsg =
            {msg: message,
                action: 'NOTIFY', //ONLINE_USERS
                users: rows_selected
            };
    console.log(message);
    socket.send(JSON.stringify(notificationmsg));

}

function sendMessageByUser(userName, msg) {
    console.log("sendMessage");

    var id = [userName];
    console.log(id);

    var message = msg;
    var notificationmsg =
            {msg: message,
                action: 'NOTIFY', //ONLINE_USERS
                users: id
            };
            
    console.log(message);
    socket.send(JSON.stringify(notificationmsg));
}

function redirect(fromUserName) {
    var clientNo = document.getElementById('message').value + "@" + fromUserName;
    var clientNoMsg =
            {
                msg: clientNo,
                action: 'REDIRECT',
                users: rows_selected
            };
    socket.send(JSON.stringify(clientNoMsg));
}

function  notify(msg, type)
{
    //var errormsg='<strong style="font-size: 20px;">'+msg+'</strong>'
    var id = Math.floor((Math.random() * 100000) + 1);
    var image = "4s_logo.png";
    var width = "200";
    switch (type) {
        case "database":
            image = "icons/database_store.png";
            width = "40";
            break;
        case "alert":
            image = "icons/alert.png";
            width = "100";
            break;
        case "fatal":
            image = "delete.png";
            width = "80";
            break;
        case "info":
            image = "icons/info.png";
            width = "100";
            break;
    }
    var notification = '<div class="sticky border-top-right sticky-error" id=' + id + ' style="display: none;"><img src="img/close1.png" class="sticky-close" rel=' + id + ' title="Close"><div class="sticky-note" rel=' + id + ' ><img src="images/' + image + '" style="width: ' + width + 'px;height: ' + width + 'px;float:left" /> <strong style="font-size: 20px;">&nbsp;' + msg + '</strong></div></div>';
    //console.log(notification);
    $("#stickyalerts").append(notification);
    $("#" + id).slideDown("slow");

    $(".sticky-close").click(function () {
        $("#" + $(this).attr("rel")).fadeOut("slow");
    });

}

// Make the function wait until the connection is made...
function waitForSocketConnection(callback) {
    setTimeout(
            function () {
                if (socket.readyState === 1) {
                    console.log("Connection is made")
                    if (callback != null) {
                        callback();
                    }
                    return;

                } else {
                    console.log("wait for connection...")
                    waitForSocketConnection(socket, callback);
                }

            }, 5); // wait 5 milisecond for the connection...
}

function get_Online_Users()
{
    waitForSocketConnection(function () {
        console.log("callnack fn: ");
        console.log(socket.readyState);
        console.log("sendMessage to get_Online_Users");
        var notificationmsg =
                {msg: "",
                    action: 'ONLINE_USERS' //ONLINE_USERS
                };
        socket.send(JSON.stringify(notificationmsg));

    });

}