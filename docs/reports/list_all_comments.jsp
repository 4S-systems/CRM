<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Issue.getCompl3"  />

    <head>
        <%
            ArrayList<WebBusinessObject> arrayOfRequests = (ArrayList<WebBusinessObject>) request.getAttribute("data");
            WebBusinessObject issue = (WebBusinessObject) request.getAttribute("issue");
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link rel="stylesheet" href="css/demo_table.css">    
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script>
            $(document).ready(function () {
                $('#comments').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                });
            });
           
        </script>
        <style type="text/css">
            /* loading progress bar*/
            .container {width: 100px; margin: 0 auto; overflow: hidden;}
            .contentBar {width:100px; margin:0 auto; padding-top:0px; padding-bottom:0px;}
            .barlittle {
                background-color:#2187e7;  
                background-image: -moz-linear-gradient(45deg, #2187e7 25%, #a0eaff); 
                background-image: -webkit-linear-gradient(45deg, #2187e7 25%, #a0eaff);
                border-left:1px solid #111; border-top:1px solid #111; border-right:1px solid #333; border-bottom:1px solid #333; 
                width:10px;
                height:10px;
                float:left;
                margin-left:5px;
                opacity:0.1;
                -moz-transform:scale(0.7);
                -webkit-transform:scale(0.7);
                -moz-animation:move 1s infinite linear;
                -webkit-animation:move 1s infinite linear;
            }
            #block_1{
                -moz-animation-delay: .4s;
                -webkit-animation-delay: .4s;
            }
            #block_2{
                -moz-animation-delay: .3s;
                -webkit-animation-delay: .3s;
            }
            #block_3{
                -moz-animation-delay: .2s;
                -webkit-animation-delay: .2s;
            }
            #block_4{
                -moz-animation-delay: .3s;
                -webkit-animation-delay: .3s;
            }
            #block_5{
                -moz-animation-delay: .4s;
                -webkit-animation-delay: .4s;
            }
            @-moz-keyframes move{
                0%{-moz-transform: scale(1.2);opacity:1;}
                100%{-moz-transform: scale(0.7);opacity:0.1;}
            }
            @-webkit-keyframes move{
                0%{-webkit-transform: scale(1.2);opacity:1;}
                100%{-webkit-transform: scale(0.7);opacity:0.1;}
            }
        </style>
    </head>
    <body>
        <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup(this)"/>
        </div>

        <!--<h1>رسالة قصيرة</h1>-->
        <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;overflow: auto;height: 300px; text-align: center;">
            <b style="font-size: x-large;"> <fmt:message key="Nofollow" /> : <font color="red"><%=issue.getAttribute("businessID")%></font><font color="blue">/<%=issue.getAttribute("businessIDbyDate")%></font></b>
            <br/><br/>
            <table id="comments" dir="<fmt:message key='direction' />" style="width: 100%">
                <thead>
                    <tr>
                        <td style="width: 12%"><fmt:message key="request" /></td>
                        <td style="width: 25%"><fmt:message key="comment1" /></td>
                        <td style="width: 12%"><fmt:message key="means" /></td>
                        <td style="width: 25%"><fmt:message key="date" /></td>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String creationTime;
                        for (WebBusinessObject wbo : arrayOfRequests) {
                            creationTime = (String) wbo.getAttribute("creationTime");
                            if(creationTime.length() > 17) {
                                creationTime = creationTime.substring(0, creationTime.lastIndexOf(":"));
                            }
                    %>
                    <tr>
                        <td>
                            <b><%=wbo.getAttribute("businessCompID")%></b>
                        </td>
                        <td>
                            <b><%=wbo.getAttribute("comment")%></b>
                        </td>
                        <td>
                            <b><%=wbo.getAttribute("userName")%></b>
                        </td>
                        <td>
                            <b><%=creationTime%></b>
                        </td>
                    </tr>
                    <%}%>
                </tbody>
            </table>
        </div>
        <div id="loading" class="container" style="float: left; margin-left: 0px; margin-bottom: 5px; margin-top: 15px; display: none">
            <div class="contentBar">
                <div id="block_1" class="barlittle"></div>
                <div id="block_2" class="barlittle"></div>
                <div id="block_3" class="barlittle"></div>
                <div id="block_4" class="barlittle"></div>
                <div id="block_5" class="barlittle"></div>
            </div>
        </div>
    </body>
</html>
