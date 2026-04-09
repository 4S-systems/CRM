<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.system_events.WebAppStartupEvent"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*,com.tracker.business_objects.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<html>
    <%
        ServletContext context = getServletContext();
        ArrayList<String> parameterNames = Collections.list(context.getInitParameterNames());
        String align = null;
        String dir = null;

        align = "center";
        dir = "LTR";

    %>
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/silkworm_validate.js"></script>
        <script type="text/javascript" src="js/jquery-1.10.2.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>

        <script type="text/javascript">
            var oTable;
            var users = new Array();
            $(document).ready(function () {
                oTable = $('#parameters').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[-1], ["All"]],
                    iDisplayLength: -1,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[0, "asc"]]
                }).fadeIn(2000);
            });
        </script>
        <style type="text/css" >
        </style>
    </head>
    <body style="background-color: #F5F5F5;">
        <fieldset class="set" style="width: 60%; padding-left: 50px; padding-right: 50px;">
            <legend align="center">
                <table align="<%=align%>" dir="<%=dir%>">
                    <tr>
                        <td class="td">
                            <font color="#616D7E" style="font-weight:bolder;" size="5">System Configurations</font>
                        </td>
                    </tr>
                </table>
            </legend>
            <br />
            <table id="parameters" cellpading="0" cellspacing="0" border="0" dir="<%=dir%>" width="100%">
                <thead>
                    <tr>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            Parameter Name
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            Parameter Value
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (String parameterName : parameterNames) {
                    %>
                    <tr STYLE="padding-top:5px;padding-bottom:3px">
                        <td>
                            <%=parameterName%>
                        </td>
                        <td>
                            <%=context.getInitParameter(parameterName)%>
                        </td>
                    </tr>
                    <% }%>
                </tbody>
            </table>
            <br />
        </fieldset>
    </body>
</html>
