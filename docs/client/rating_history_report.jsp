<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page pageEncoding="UTF-8" %>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] ratesAttributes = {"rateName", "creationTime", "fullName"};
        String[] ratesListTitles = new String[3];
        int s = ratesAttributes.length;
        int t = ratesListTitles.length;
        String attName = null;
        String attValue = null;
        ArrayList<WebBusinessObject> ratesList = (ArrayList<WebBusinessObject>) request.getAttribute("ratesList");
        String clientID = request.getAttribute("clientID") != null ? (String) request.getAttribute("clientID") : "1561364882640";
        String clientNameVal = request.getAttribute("clientName") != null ? (String) request.getAttribute("clientName") : "";
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, xAlign, clientName, display, dir, search;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            ratesListTitles[0] = "Rate Name";
            ratesListTitles[1] = "Rate Date";
            ratesListTitles[2] = "Rated by";
            clientName = "Client";
            display = "Display Report";
            search = "Search";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            ratesListTitles[0] = "التصنيف";
            ratesListTitles[1] = "بتاريخ";
            ratesListTitles[2] = "بواسطة";
            clientName = "العميل";
            display = "أعرض التقرير";
            search = "بحث";
        }
    %>
    <head>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>

        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">

        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function () {
                oTable = $('#rates').dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "columnDefs": [
                        {
                            "targets": 2,
                            "visible": false
                        }],
                    "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(2, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
                                        '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: lightgray;" colspan="1"><%=ratesListTitles[2]%></td><td class="blueBorder blueBodyTD" style="font-size: 16px; color: #a41111;" colspan="1">'
                                        + group + '</td></tr>'
                                        );
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
            });
            function openSearch() {
                getDataInPopup('ClientServlet?op=getClientsPopup&value=' + $("#clientName").val());
            }
        </script>
        <style type="text/css">
        </style>
    </head>
    <body>
        <b style="float: <%=xAlign%>; font-size: 16px;color: #005599; font-style: oblique; margin-<%=xAlign%>: 80px;">Client's Rating History Report تاريخ تصنيف عميل</b>
        <fieldset align=center class="set" style="width: 95%">
            <form name="REPORT_FORM" action="<%=context%>/ReportsServletThree?op=getClientRateingHistory" method="POST">
                <br/>
                <table class="blueBorder" align="center" dir="rtl" id="code" cellpadding="0" cellspacing="0" width="325" style="border-width: 1px; border-color: white; display: block;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"> <%=clientName%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="text" style="width:190px" id="clientName" name="clientName" size="20" maxlength="100" value="<%=clientNameVal%>"/>
                            <input type="button" onclick="JavaScript: openSearch(this);" value="<%=search%>" />
                            <input type="hidden" id="clientID" name="clientID" value="<%=clientID%>" />
                            <input type="hidden" id="treatType" name="treatType" value="4" />
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="submit" value="<%=display%>" class="button" style="margin: 10px;"/>
                        </td>
                    </tr>
                </table>
                <br/>
                <br/>
                <%
                    if (ratesList != null) {
                %>
                <div style="width: 50%; margin-left: auto; margin-right: auto; margin-bottom: 7px;">
                    <table align="<%=align%>" dir="<%=dir%>" id="rates" style="width:100%;">
                        <thead>
                            <tr>
                                <%
                                    for (int i = 0; i < t; i++) {
                                %>                
                                <th style="width:10%">
                                    <b><%=ratesListTitles[i]%></b>
                                </th>
                                <%
                                    }
                                %>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (WebBusinessObject clientWbo : ratesList) {
                            %>
                            <tr>
                                <%
                                    for (int i = 0; i < s; i++) {
                                        attName = ratesAttributes[i];
                                        attValue = clientWbo.getAttribute(attName) != null ? ((String) clientWbo.getAttribute(attName)).trim() : "";
                                        if (i == 1 && !attValue.isEmpty()) {
                                            attValue = attValue.substring(0, 19);
                                        }
                                %>
                                <td>
                                    <div>
                                        <b><%=attValue%></b>
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