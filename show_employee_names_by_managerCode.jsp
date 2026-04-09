<%-- 
    Document   : show_employee_names_by_managerCode
    Created on : Sep 28, 2014, 8:59:14 AM
    Author     : time
--%>

<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <%
            String[] header = {"#", "أسم الموظف"};
            ArrayList<LiteWebBusinessObject> arrayOfEmployees = (ArrayList<LiteWebBusinessObject>) request.getAttribute("employees");

        %>
        <script>
            function closePopup (obj){
             $(obj).bPopup().close();
//             $('#show_emp').css("display", "none");
//             $('#show_emp').bPopup().close();
            }
        </script>
        <style>
            .login  h1 {
                font-size: 16px;
                font-weight: bold;

                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 96%;
                margin-left: auto;
                margin-right: auto;
                text-height: 30px;
                color: black;
                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #FFBB00;
                /*background: #cc0000;*/
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
            .login {
                /*display: none;*/
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                /*        width:30%;*/
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;

                background: #7abcff; /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzdhYmNmZiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM0MDk2ZWUiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
        </style>
    </head>
    <body>
        <% if (arrayOfEmployees != null && !arrayOfEmployees.isEmpty()) {%>
        
        <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <%--<img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup(this)"/>--%>
        </div>
        <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;overflow: auto;">
            <table  border="0px"  style="width:100%;"  class="blueBorder" id="showComment">
                <thead>
                    <% for (int i = 0; i < header.length; i++) {%>
                <th style="font-size: large">
                    <%=header[i]%>
                </th>
                <%}%>
                </thead>
                
                <%
                    String empName;
                    int empCount = 0;
                    for (LiteWebBusinessObject wbo : arrayOfEmployees) {
                        empName = (String) wbo.getAttribute("employeeName");
                        empCount++;
                %>

                
                <tbody>
                    <tr>
                        <td >
                            <b style="font-size: large;font-weight: bold">
                                <%=empCount%>
                            </b> 
                        </td>
                        <td>
                            <b style="font-size: large;font-weight: bold">
                           <%=empName%>
                           </b> 
                        </td>

                    </tr>
                    <% } %>
                </tbody> 
            </table>
        </div>
        <% } else { %>
        <div style="clear: both;margin-left: 68%;margin-top: 0px;margin-bottom: -35px;width: 32px;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
        </div>
        <div class="login" style="width: 40%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
            <div style="margin-right: auto;margin-left: auto;width: 100%;font-size: 24px;color: white;text-align: center;">لا يوجد موظفين</div>
        </div>
        <% }%>
    </body>
</html>
