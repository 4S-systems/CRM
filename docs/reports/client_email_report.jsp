<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] clientsAttributes = {"clientName", "mobile", "interPhone", "subject", "plaintext"};
        String[] clientsListTitles = new String[5];
        int s = clientsAttributes.length;
        int t = clientsListTitles.length;
        String attName = null;
        String attValue = null;
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        String type = request.getAttribute("type") != null ? (String) request.getAttribute("type") : "";
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign, fromDate, toDate, display, emailType, received, sent;
        String dir = null;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            clientsListTitles[0] = "Client Name";
            clientsListTitles[1] = "Client Mobile";
            clientsListTitles[2] = "International";
            clientsListTitles[3] = "Subject";
            clientsListTitles[4] = "Email Body";
            fromDate = "From Date";
            toDate = "To Date";
            display = "Display Report";
            emailType = "Email Type";
            received = "Received";
            sent = "Sent";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            clientsListTitles[0] = "اسم العميل";
            clientsListTitles[1] = "الموبايل";
            clientsListTitles[2] = "الدولي";
            clientsListTitles[3] = "الموضوع";
            clientsListTitles[4] = "الرسالة";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            display = "أعرض التقرير";
            emailType = "نوع البريد";
            received = "مستلم";
            sent = "مرسل";
        }
    %>
    <HEAD>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function () {
                oTable = $('#clients').dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[0, "asc"]]
                }).fadeIn(2000);
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
        </script>
        <style type="text/css">
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;

                background: #7abcff; /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }

            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
        </style>
    </HEAD>
    <body>
        <b style="float: <%=xAlign%>; font-size: 16px;color: #005599; font-style: oblique; margin-<%=xAlign%>: 80px;">Clients' Emails Report تقرير رسائل العملاء</b>
        <fieldset align=center class="set" style="width: 95%">
            <form name="CLASSIFICATION_FORM" action="<%=context%>/ReportsServletThree?op=getClientsEmailsReport" method="POST">
                <br/>
                <table class="blueBorder" align="center" dir="rtl" id="code" cellpadding="0" cellspacing="0" width="650" style="border-width: 1px; border-color: white; display: block;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"> <%=fromDate%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"> <%=toDate%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="text" style="width:190px" id="fromDate" name="fromDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("fromDate") == null ? "" : request.getAttribute("fromDate")%>"/>
                        </td>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="text" style="width:190px" id="toDate" name="toDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("toDate") == null ? "" : request.getAttribute("toDate")%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=3 color="white"><%=emailType%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <select name="type" id="type" style="width: 200px; font-size: 16px;">
                                <option value="RECEIVED" <%="RECEIVED".equals(type) ? "selected" : ""%>><%=received%></option>
                                <option value="SENT" <%="SENT".equals(type) ? "selected" : ""%>><%=sent%></option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <input type="submit" value="<%=display%>" class="button" style="margin: 10px;"/>
                        </td>
                    </tr>
                </table>
                <br/>
                <br/>
                <%
                    if (clientsList != null) {
                %>
                <div style="width: 90%; margin-left: auto; margin-right: auto; margin-bottom: 7px;">
                    <table align="<%=align%>" dir="<%=dir%>" id="clients" style="width:100%;">
                        <thead>
                            <tr>
                                <%
                                    for (int i = 0; i < t; i++) {
                                %>                
                                <th style="width:10%">
                                    <b><%=clientsListTitles[i]%></b>
                                </th>
                                <%
                                    }
                                %>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (WebBusinessObject clientWbo : clientsList) {
                            %>
                            <tr>
                                <%
                                    for (int i = 0; i < s; i++) {
                                        attName = clientsAttributes[i];
                                        attValue = clientWbo.getAttribute(attName) != null ? ((String) clientWbo.getAttribute(attName)).trim() : "";
                                %>
                                <td>
                                    <div>
                                        <b <%=i == 4 ? "title=\"" + attValue + "\"" : ""%>><%=attValue.equalsIgnoreCase("UL") ? "" : (i == 4 && attValue.length() > 10 ? attValue.substring(0, 10) + " ..." : attValue)%></b>
                                        <%
                                            if (i == 0) {
                                        %>
                                        <a target="_blanck" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=clientWbo.getAttribute("clientID")%>">
                                            <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل" onmouseover="JavaScript: changeCommentCounts('23878', this);">
                                        </a>
                                        <%
                                            }
                                        %>
                                    </div>
                                </td>
                                <%
                                    }
                                %>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <%
                    }
                %>
                <br/><br/>
            </form>
        </fieldset>
    </body>
</html>