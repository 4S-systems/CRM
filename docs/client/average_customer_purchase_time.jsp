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
        String[] clientsAttributes = {"name", "mobile", "interPhone", "creationTime", "purchaseDate", "diff"};
        String[] clientsListTitles = new String[6];
        int s = clientsAttributes.length;
        int t = clientsListTitles.length;
        String attName = null;
        String attValue = null;
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        ArrayList<WebBusinessObject> campaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList");
        String campaignID = request.getAttribute("campaignID") != null ? (String) request.getAttribute("campaignID") : "";
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir, xAlign, display, campaign, all;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            clientsListTitles[0] = "Client Name";
            clientsListTitles[1] = "Mobile";
            clientsListTitles[2] = "Inter. Phone";
            clientsListTitles[3] = "Registration Date";
            clientsListTitles[4] = "Purchase Date";
            clientsListTitles[5] = "Diff. in Days";
            display = "Display Report";
            campaign = "Campaign";
            all = "All";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            clientsListTitles[0] = "اسم العميل";
            clientsListTitles[1] = "الموبايل";
            clientsListTitles[2] = "الدولي";
            clientsListTitles[3] = "تاريخ التسجيل";
            clientsListTitles[4] = "تاريخ الشراء";
            clientsListTitles[5] = "الفرق بالأيام";
            display = "أعرض التقرير";
            campaign = "الحملة";
            all = "الكل";
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
            $(document).ready(function () {
                $('#clients').dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[0, "asc"]]
                }).fadeIn(2000);
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
        <b style="float: <%=xAlign%>; font-size: 16px;color: #005599; font-style: oblique; margin-<%=xAlign%>: 80px;">Average Customer Purchase Time متوسط زمن الشراء للعميل</b>
        <fieldset align=center class="set" style="width: 95%">
            <form name="CLIENT_FORM" action="<%=context%>/ReportsServletThree?op=getAverageCustomerPurchaseTime" method="POST">
                <br/>
                <table class="blueBorder" align="center" dir="rtl" id="code" cellpadding="0" cellspacing="0" width="325" style="border-width: 1px; border-color: white; display: block;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size: 18px; width: 325;">
                            <b><font size=3 color="white"><%=campaign%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <select name="campaignID" id="campaignID" style="width: 80%;" onchange="JavaScript: getProjects(this);" class="chosen-select-campaign">
                                <sw:WBOOptionList wboList="<%=campaignsList%>" displayAttribute="campaignTitle" valueAttribute="id" scrollToValue="<%=campaignID%>" />
                            </select>
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
                    if (clientsList != null) {
                        DecimalFormat df = new DecimalFormat("#");
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
                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                                Double diff;
                                for (WebBusinessObject clientWbo : clientsList) {
                            %>
                            <tr>
                                <%
                                    diff = (sdf.parse((String) clientWbo.getAttribute("purchaseDate")).getTime() - sdf.parse((String) clientWbo.getAttribute("creationTime")).getTime()) / (1000 * 60 * 60 * 24.0);
                                    for (int i = 0; i < s; i++) {
                                        attName = clientsAttributes[i];
                                        attValue = clientWbo.getAttribute(attName) != null ? ((String) clientWbo.getAttribute(attName)).trim() : "";
                                        if (i == 3 || i == 4) {
                                            attValue = attValue.substring(0, 16);
                                        } else if (i == 5) {
                                            attValue = df.format(diff);
                                        }
                                %>
                                <td>
                                    <div>
                                        <%
                                            if (i == 0) {
                                        %>
                                        <a target="blanck" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=clientWbo.getAttribute("id")%>">
                                            <img src="images/client_details.jpg" width="30" style="float: left;">
                                        </a>
                                        <%
                                            }
                                        %>
                                        <b><%=attValue.equalsIgnoreCase("UL") ? "" : attValue%></b>
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
        <script>
            var config = {
                '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
    </body>
</html>