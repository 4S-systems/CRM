<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>

<%@page pageEncoding="UTF-8" %>

<html>
    <%
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        ArrayList<WebBusinessObject> logsList = (ArrayList<WebBusinessObject>) request.getAttribute("logsList");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
        } else {
            align = "center";
            dir = "RTL";
        }
    %>
    <head>
        <script>
            $(document).ready(function () {
                oTable = $('#sla_history').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[-1], ["All"]],
                    iDisplayLength: -1,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[1, "asc"]]
                }).fadeIn(2000);
            });
        </script>
    </head>
    <body>
        <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup(this)"/>
        </div>
        <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
            <br/>
            <table align="<%=align%>" dir="<%=dir%>" width="100%" id="sla_history">
                <thead>
                    <tr>
                        <th style="color: #005599 !important; font-size: 14px; font-weight: bold;">وقت التنفيذ</th>
                        <th style="color: #005599 !important; font-size: 14px; font-weight: bold;">تاريخ التعديل</th>
                    </tr>
                <thead>
                <tbody >  
                    <%
                        for (WebBusinessObject wbo : logsList) {
                    %>
                    <tr>
                        <td>
                            <b><%=wbo.getAttribute("executionPeriod") != null ? wbo.getAttribute("executionPeriod") : "0"%></b>
                        </td>
                        <td>
                            <b><%=wbo.getAttribute("creationTime") != null ? ((String) wbo.getAttribute("creationTime")).substring(0, 16) : "---"%></b>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>  
            </table>
        </div>
    </body>
</html>     
