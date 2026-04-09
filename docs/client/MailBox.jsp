
<%@page import="java.text.SimpleDateFormat"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    List<WebBusinessObject> clientemails2 = (List<WebBusinessObject>) request.getAttribute("clientemails");
%>

<!DOCTYPE html>
<html>
    <head>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.accordion.js"></script>  

        <script>

        </script>

        <style>
            button.accordion {
                background-color: #eee;
                color: #444;
                cursor: pointer;
                padding: 12px;
                width: 100%;
                border: none;
                text-align: left;
                outline: none;
                font-size: 15px;
                transition: 0.4s;
                margin-bottom:1px;
            }

            button.accordion.active, button.accordion:hover {
                background-color: #ddd;
            }

            button.accordion:after {
                content: '\002B';
                color: #777;
                font-weight: bold;
                float: right;
                margin-left: 5px;
            }

            button.accordion.active:after {
                content: "\2212";
            }

            div.panel {
                padding: 0 18px;
                background-color: white;
                max-height: 0;
                overflow: hidden;
                transition: max-height 0.2s ease-out;
            }
        </style>
    </head>
    <body>
        <div id="mails_container" style="overflow-y: scroll; max-height:  400px">
            <c:if test="${empty clientemails}">
                <p align="center">No Mails</p>
            </c:if>
            <c:forEach items="${clientemails}" var="item">
                <button class="accordion">
                    <table  style="float: left; width: 97%" >
                        <tr>
                            <td style="border: 0px ;text-align: left ; font-weight: normal">
                                <b title="${item.getAttribute('from_email')}"> 
                                    <c:out value="${item.getAttribute('from_email_name')}"/></b>
                                to
                                <b title="${item.getAttribute('to_email')}"> <c:out value="${item.getAttribute('to_email_name')}"/> </b>
                            </td>
                            <td style="border: 0px ;text-align: center ; font-weight: normal">
                                 <c:out value="${item.getAttribute('subject')}"/>
                            </td>
                            <td style="border: 0px ; text-align: right ; font-weight: normal">
                                
                                <span title=" <fmt:formatDate pattern="hh:mm a" value="${item.getAttribute('date_email')}" />">
                                  
                                    <fmt:formatDate pattern="EEE MMM d" value="${item.getAttribute('date_email')}" />
                                
                                </span>
                               
                            </td>
                        </tr>
                    </table>
                     
                </button>
                <div class="panel">
                    <p><c:out value="${item.getAttribute('plaintext')}"/></p>


                </div>
            </c:forEach>


        </div>

        <script>
            var acc = document.getElementsByClassName("accordion");
            var i;

            for (i = 0; i < acc.length; i++) {
                acc[i].onclick = function () {
                    this.classList.toggle("active");
                    var panel = this.nextElementSibling;
                    if (panel.style.maxHeight) {
                        panel.style.maxHeight = null;
                    } else {
                        panel.style.maxHeight = panel.scrollHeight + "px";
                    }
                }
            }
        </script>
    </body>
</html>
