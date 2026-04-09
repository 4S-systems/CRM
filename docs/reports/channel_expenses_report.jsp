<%@page import="java.text.DecimalFormat"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] clientsAttributes = {"englishName", "expenseDate", "amount", "currencyType", "companyName", "exchangeRate", "paidAmount"};
        String[] clientsListTitles = new String[7];
        int s = clientsAttributes.length;
        int t = clientsListTitles.length;
        String attName = null;
        String attValue = null;
        ArrayList<WebBusinessObject> expensesList = (ArrayList<WebBusinessObject>) request.getAttribute("expensesList");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign, fromDate, toDate, display, dollar, pound, euro;
        String dir = null;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            clientsListTitles[0] = "Client Name";
            clientsListTitles[1] = "Client Mobile";
            clientsListTitles[2] = "International";
            clientsListTitles[3] = "Client Registration Date";
            clientsListTitles[4] = "Divisional ID";
            clientsListTitles[5] = "Campaign";
            clientsListTitles[6] = "Source";
            fromDate = "From Date";
            toDate = "To Date";
            display = "Display Report";
            dollar = "Dollar";
            pound = "Pound";
            euro = "Euro";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            clientsListTitles[0] = "قناة الأتصال";
            clientsListTitles[1] = "التاريخ";
            clientsListTitles[2] = "القيمة";
            clientsListTitles[3] = "العملة";
            clientsListTitles[4] = "الشركة";
            clientsListTitles[5] = "معدل التغيير";
            clientsListTitles[6] = "القيمة المدفوعة";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            display = "أعرض التقرير";
            dollar = "دولار";
            pound = "جنية";
            euro = "يورو";
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
                    "order": [[0, "asc"]],
                    "columnDefs": [
                        {
                            "targets": 0,
                            "visible": false
                        }, {
                            "targets": [1, 2, 3, 4, 5, 6],
                            "orderable": false
                        }],
                    "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(0, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
                                        '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: lightgray;" colspan="3"><%=clientsListTitles[0]%></td><td class="blueBorder blueBodyTD" style="font-size: 16px; color: #a41111;" colspan="2">'
                                        + group + '</td><td class="blueBorder blueBodyTD" colspan="2"></td></tr>'
                                        );
                                last = group;
                            }
                        });
                    }
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

        </style>
    </HEAD>
    <body>
        <b style="float: <%=xAlign%>; font-size: 16px;color: #005599; font-style: oblique; margin-<%=xAlign%>: 80px;">Campaigns Expenses تكاليف الحملات</b>
        <fieldset align=center class="set" style="width: 95%">
            <form name="CHANNELS_FORM" action="<%=context%>/CampaignServlet?op=getChannelsExpenses" method="POST">
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
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <input type="submit" value="<%=display%>" class="button" style="margin: 10px;"/>
                        </td>
                    </tr>
                </table>
                <br/>
                <br/>
                <%
                    if (expensesList != null) {
                        DecimalFormat df = new DecimalFormat("0.00");
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
                                for (WebBusinessObject expenseWbo : expensesList) {
                            %>
                            <tr>
                                <%
                                    for (int i = 0; i < s; i++) {
                                        attName = clientsAttributes[i];
                                        attValue = expenseWbo.getAttribute(attName) != null ? ((String) expenseWbo.getAttribute(attName)).trim() : "";
                                        switch (i) {
                                            case 1:
                                                attValue = attValue.substring(0, 10);
                                                break;
                                            case 2:
                                            case 5:
                                            case 6:
                                                attValue = df.format(Double.parseDouble(attValue));
                                                break;
                                            case 3:
                                                switch (attValue) {
                                                    case "dollar":
                                                        attValue = dollar;
                                                        break;
                                                    case "pound":
                                                        attValue = pound;
                                                        break;
                                                    case "euro":
                                                        attValue = euro;
                                                        break;
                                                    default:
                                                        break;
                                                }
                                                break;
                                        }
                                %>
                                <td>
                                    <div>
                                        <b><%=attValue.equalsIgnoreCase("UL") ? "---" : attValue%></b>
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