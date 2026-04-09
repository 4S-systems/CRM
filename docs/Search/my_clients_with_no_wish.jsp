<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    Calendar cal = Calendar.getInstance();
    String endDateVal = request.getAttribute("endDate") != null ? (String) request.getAttribute("endDate") : sdf.format(cal.getTime());
    cal.add(Calendar.MONTH, -1);
    String beginDateVal = request.getAttribute("endDate") != null ? (String) request.getAttribute("beginDate") : sdf.format(cal.getTime());
    String hasVisits = request.getAttribute("hasVisits") != null ? (String) request.getAttribute("hasVisits") : "";
    String stat = (String) request.getSession().getAttribute("currentMode");;
    String align, dir, style, title, beginDate, endDate, customerName, visitorsOnly, mobile, entryDate, search;
    if (stat.equals("En")) {
        align = "left";
        dir = "LTR";
        style = "text-align:right";
        title = "My CLients with no Wish List";
        beginDate = "From Date";
        endDate = "To Date";
        customerName = "Customer name";
        visitorsOnly = "Visitors Only";
        mobile = "Mobile";
        entryDate = "Registration Date";
        search = "Search";
    } else {
        dir = "RTL";
        align = "right";
        style = "text-align:Right";
        title = "عملائي بدون رغبات";
        beginDate = "من تاريخ";
        endDate = "إلي تاريخ";
        customerName = "اسم العميل";
        visitorsOnly = "عملاء زائرون فقط";
        mobile = "المحمول";
        entryDate = "تاريخ التسجيل";
        search = "بحث";
    }
%>
<html>
    <head>  
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
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
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script language="JavaScript" type="text/javascript">
            $(document).ready(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
                oTable = $('#clients').dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]]
                }).fadeIn(2000);
            });

            function submitForm() {
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                if (beginDate === "") {
                    alert("من فضلك أدخل تاريخ البداية");
                } else if (endDate === "") {
                    alert("من فضلك أدخل تاريخ النهاية");
                } else {
                    document.REPORT_FORM.action = "<%=context%>/SearchServlet?op=getMyClientsWithNoWish";
                    document.REPORT_FORM.submit();
                }
            }
        </script>
        <style type="text/css">
            .titlebar {
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
        </style>
    </head>
    <body>
        <form name="REPORT_FORM" method="post">
            <fieldset class="set" style="border-color: #006699; width: 80%;margin-top: 10px;border-radius: 5px;">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">
                            <%=title%>
                            </font>
                        </td>
                    </tr>
                </table>
                <br />
                <table align="center" dir="<%=dir%>" width="570" cellspacing="2" cellpadding="1">
                    <tr>
                        <td class="blueBorder blueHeadertd" style="font-size: 18px;" width="50%">
                            <b><font size=3 color="white"><%=beginDate%></b>
                        </td>
                        <td   class="blueBorder blueHeadertd" style="font-size: 18px;" width="50%">
                            <b> <font size=3 color="white"><%=endDate%></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center;" bgcolor="#dedede" valign="middle">
                            <input id="beginDate" name="beginDate" type="text" value="<%=beginDateVal%>"/><img src="images/showcalendar.gif" /> 
                            <br /><br/>
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="endDate" name="endDate" type="text" value="<%=endDateVal%>"><img src="images/showcalendar.gif" /> 
                            <br/><br/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeadertd" style="font-size:18px;">
                            <%=visitorsOnly%>
                        </td>
                        <td bgcolor="#dedede" rowspan="2">
                            <button onclick="JavaScript: submitForm();" style="color: #000; font-size: 15px; margin-top: 2px; font-weight: bold; width: 150px;"><%=search%><img height="15" src="images/search.gif" /></button>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede">
                            <input id="hasVisits" name="hasVisits" type="checkbox" value="true" style="margin-<%=align%>: 10px;"
                                   <%="true".equals(hasVisits) ? "checked" : ""%>/>
                        </td>
                    </tr>
                </table>
                <%
                    if (data != null) {
                %>
                <br />
                <br />
                <div style="width: 65%; margin-left: auto; margin-right: auto;">
                    <table class="blueBorder" id="clients" align="center" dir="<%=dir%>" width="100%" celladding="0" cellspacing="0" style="display: none;">
                        <thead>
                            <tr>
                                <th class="blueBorder backgroundTable" style="text-align: center; font-size: <%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px;"><b><%=customerName%></b></th>
                                <th class="blueBorder backgroundTable" style="text-align: center; font-size: <%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px;"><b><%=mobile%></b></th>
                                <th class="blueBorder backgroundTable" style="text-align: center; font-size: <%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px;"><b><%=entryDate%></b></th>
                            </tr>
                        </thead> 
                        <tbody  id="planetData2">
                            <%
                                for (WebBusinessObject wbo : data) {
                            %>
                            <tr style="padding: 1px;">
                                <td>
                                    <b><%=wbo.getAttribute("name")%></b>
                                    <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("id")%>" target="details">
                                        <img src="images/client_details.jpg" width="30" style="float: left;"/>
                                    </a>
                                </td>
                                <td style="width: 10%;">
                                    <b><%=wbo.getAttribute("mobile") != null ? (String) wbo.getAttribute("mobile") : ""%></b>
                                </td>
                                <td style="width: 10%;">
                                    <b><%=wbo.getAttribute("creationTime") != null ? ((String) wbo.getAttribute("creationTime")).substring(0, 10) : ""%></b>
                                </td>
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
                <br />
                <br />
            </fieldset>
        </form>
    </body>
</html>
