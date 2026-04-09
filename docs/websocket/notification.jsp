<%-- 
    Document   : notification
    Created on : Mar 14, 2015, 12:14:08 PM
    Author     : walid
--%>

<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%
    MetaDataMgr dataMgr = MetaDataMgr.getInstance();
    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
    String context = dataMgr.getContext();
    String host = request.getServerName();
    int port = request.getServerPort();
    String userid = securityUser.getUserId();
%>
<html>
    <link rel="stylesheet" type="text/css" href="css/stickynotify.css"/>
   <!--script type="text/javascript" src="js/notifications/websocket.js"></script--> 
 <style>
        div.container {
            margin:  4px;
            padding: 4px;
        }

        p.centered {
            width:          50%;
            text-align:     center;
            vertical-align: middle;
        }
    </style>
    </head>
    <body>
        
</body>
</html>
