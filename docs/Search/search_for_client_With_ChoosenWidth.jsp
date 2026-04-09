<%@page import="com.maintenance.db_access.ProjectsByGroupMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.maintenance.db_access.IssueByComplaintAllCaseMgr"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>

<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    Hashtable logos = new Hashtable();
    logos = (Hashtable) session.getAttribute("logos");
    int iTotal = 0;
//get session logged user and his trades
//    WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
    ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    String hasVisits = request.getAttribute("hasVisits") != null ? (String) request.getAttribute("hasVisits") : "";
    String reportType = request.getAttribute("reportType") != null ? (String) request.getAttribute("reportType") : "withWish";
    String compStatusVal = (String) request.getAttribute("compStatus");
    ArrayList<WebBusinessObject> groups = (ArrayList<WebBusinessObject>) request.getAttribute("groups");
    String groupID = request.getAttribute("groupID") != null ? (String) request.getAttribute("groupID") : "";
    IssueByComplaintAllCaseMgr issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
    String statusName = issueByComplaintAllCaseMgr.getStatusName(compStatusVal);
    Calendar cal = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());
    cal = Calendar.getInstance();
    cal.add(Calendar.MONTH, -1);
    int a = cal.get(Calendar.YEAR);
    int b = (cal.get(Calendar.MONTH)) + 1;
    int d = cal.get(Calendar.DATE);
    String prev = a + "/" + b + "/" + d;
    String age = "";
    int diffDays = 0;
    int diffMonths = 0;
    int diffYears = 0;

    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
    String jsonText = (String) request.getAttribute("jsonText");

    String stat = "Ar";
    String align = "center";
    String dir = null;
    String style = null, lang, langCode, cancel, title, beginDate, endDate, customerName, PN, withWish, withoutWish, mobile, entryDate;
    if (stat.equals("En")) {
        align = "left";
        dir = "LTR";
        style = "text-align:right";
        lang = "&#1593;&#1585;&#1576;&#1610;";
        langCode = "Ar";
        cancel = "Cancel";
        title = "CLients With Desired Spaces";
        beginDate = "From Date";
        endDate = "To Date";
        customerName = "Customer name";
        PN = "Requests No.";
        withWish = "With Wish";
        withoutWish = "Without Wish";
        mobile = "Mobile";
        entryDate = "Registration Date";
    } else {
        dir = "RTL";
        align = "right";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        title = "عملاء مع المساحات المطلوبة";
        PN = "عدد الرغبات";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        withWish = "عملاء برغبات";
        withoutWish = "عملاء بلا رغبات";
        mobile = "المحمول";
        entryDate = "تاريخ التسجيل";

    }
%>

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
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    $(function () {
        $("#beginDate, #endDate").datepicker({
            changeMonth: true,
            changeYear: true,
            maxDate: 0,
            dateFormat: "yy/mm/dd"
        });
    });

    var oTable;
    $(document).ready(function () {
        oTable = $('#indextable').dataTable({
            "bJQueryUI": true,
            "destroy": true,
            "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
            "order": [[0, "asc"]],
            "columnDefs": [
                {
                    "targets": 0,
                    "visible": false
                }, {
                    "targets": [1, 2, 3, 4, 5],
                    "orderable": false
                }],
            "drawCallback": function (settings) {
                var api = this.api();
                var rows = api.rows({page: 'current'}).nodes();
                var last = null;
                api.column(0, {page: 'current'}).data().each(function (group, i) {
                    if (last !== group) {
                        $(rows).eq(i).before(
                                '<tr class="group"><td class="blueBorder blueBodytd" style="font-size: 16px; background-color: lightgray; color: #a41111;" colspan="5">' + group + '</td></tr>'
                                );
                        last = group;
                    }
                });
            }

        }).fadeIn(2000);
        oTable = $('#clients').dataTable({
            "bJQueryUI": true,
            "destroy": true,
            "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]]
        }).fadeIn(2000);
    });




    function getComplaints() {
//        alert("asd");
        var beginDate = $("#beginDate").val();
        var endDate = $("#endDate").val();
        if ((beginDate = null || beginDate == "")) {
            alert("من فضلك أدخل تاريخ البداية");
        } else if ((endDate = null || endDate == "")) {
            alert("من فضلك أدخل تاريخ النهاية");

        } else {
            beginDate = $("#beginDate").val();
            endDate = $("#endDate").val();
                    document.COMP_FORM.action = "<%=context%>/SearchServlet?op=getClientsWithDesiredDetailed&beginDate=" + beginDate + "&endDate=" + endDate;
            document.COMP_FORM.submit();
        }
    }


    /* preparing pie chart */
    var chart;
    $(document).ready(function () {
        chart = new Highcharts.Chart({
            chart: {
                renderTo: 'container',
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false
            },
            title: {
                text: null
            },
            tooltip: {
                formatter: function () {
                    return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        color: '#000000',
                        connectorColor: '#000000',
                        formatter: function () {
                            return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                        }
                    }
                }
            },
            series: [{
                    type: 'pie',
                    data: <%=jsonText%>
                }]
        });
    });
    /* -preparing pie chart */


</script>


<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">   
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">

    </head>
    <body>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>

        <FORM NAME="COMP_FORM" METHOD="POST">

            <table align="center" width="90%">
                <tr><td class="td">
                        <fieldset >
                            <legend align="center">
                                <table dir="rtl" align="center">
                                    <tr>
                                        <td class="td">
                                            <font color="blue" size="6"> <%=title%>

                                            </font>

                                        </td>
                                    </tr>
                                </table>
                            </legend>
                            <TABLE ALIGN="center" DIR="RTL" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                                <tr>
                                    <td class="blueBorder blueHeadertd" style="font-size:18px;" width="50%">
                                        <b><font size=3 color="white"><%=withWish%></font></b>
                                    </td>
                                    <td class="blueBorder blueHeadertd" style="font-size:18px;" width="50%">
                                        <b><font size=3 color="white"><%=withoutWish%></font></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: center;" bgcolor="#dedede" valign="middle" >
                                        <input id="withWish" name="reportType" type="radio" value="withWish" <%=reportType.equals("withWish") ? "checked" : ""%> />
                                    </td>
                                    <td style="text-align:center" bgcolor="#dedede" valign="middle">
                                        <input id="withoutWish" name="reportType" type="radio" value="withoutWish" <%=reportType.equals("withoutWish") ? "checked" : ""%> />
                                    </td>
                                </tr>
                                <tr>

                                    <td class="blueBorder blueHeadertd" style="font-size:18px;" WIDTH="50%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </td>
                                    <td   class="blueBorder blueHeadertd" style="font-size:18px;"WIDTH="50%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </td>
                                </tr>
                                <tr>

                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <%
                                            String url = request.getRequestURL().toString();
                                            String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                                            Calendar c = Calendar.getInstance();
                                        %>
                                        <% if (beDate != null && !beDate.isEmpty()) {%>

                                        <input id="beginDate" name="beginDate" type="text" value="<%=beDate%>" title="تاريخ الرغبه فى المشروع"/><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=prev%>" title="تاريخ الرغبه فى المشروع"><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>

                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <% if (eDate != null && !eDate.isEmpty()) {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=eDate%>" title="تاريخ الرغبه فى المشروع"><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" title="تاريخ الرغبه فى المشروع"><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="blueBorder blueHeadertd" style="font-size:18px;">
                                        المجموعة
                                    </td>
                                    <td class="blueBorder blueHeadertd" style="font-size:18px;">
                                        عملاء زائرون فقط
                                    </td>
                                </tr>
                                <tr>
                                    <td bgcolor="#dedede">
                                        <select id="groupID" name="groupID" style="font-size: 14px; width: 200px;">
                                            <sw:WBOOptionList wboList="<%=groups%>" displayAttribute="groupName" valueAttribute="group_id" scrollToValue="<%=groupID%>" />
                                        </select>
                                    </td>
                                    <td bgcolor="#dedede" >
                                        <input id="hasVisits" name="hasVisits" type="checkbox" value="true" style="float: <%=align%>; margin-<%=align%>: 10px;"
                                               <%="true".equals(hasVisits) ? "checked" : ""%>/>
                                    </td>
                                </tr>

                                <tr>
                                <br><br>
                                <td style="text-align:center" class="td" colspan="3">  
                                    <button  onclick="JavaScript: getComplaints();"   style="color: #000;font-size:15;margin-top: 20px;font-weight:bold; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  

                                </td>
                                </tr>
                            </table>

                        </fieldset>
                        <%
                            if (reportType.equals("withWish")) {
                        %>
                        <div id="container" style="width: 600px; height: 300px; margin: 0 auto"></div>
                        <br/><br/>
                        <%
                            }
                            if (data != null && !data.isEmpty()) {
                                if (reportType.equals("withWish")) {
                        %>
                        <TABLE ALIGN="center" DIR="RTL" WIDTH=480 CELLSPACING=2 CELLPADDING=1>

                        </table>
                <center> <b> <font size="3" color="red"> <%=PN%> : <%=data.size()%> </font></b></center> 
                <table class="blueBorder"  id="indextable" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none;">
                    <thead>
                        <tr>
                            <%--<th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%"><SPAN ><b>#</b></SPAN></th>--%>
                            <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width=""><SPAN><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></SPAN></th>
                            <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="40%"><SPAN><b> المشروع</b></SPAN></th>
                            <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="40%"><SPAN><b> الوحده</b></SPAN></th>
                            <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="40%"><SPAN><b> تاريخ اضافة الرغبه</b></SPAN></th>
                            <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="40%"><SPAN><b> المصدر</b></SPAN></th>
                            <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="40%"><SPAN><b> المساحة</b></SPAN></th>


                        </tr>
                    </thead> 
                    <tbody  id="planetData2">  

                        <%
                            for (WebBusinessObject wbo : data) {
                                iTotal++;

                        %>

                        <tr style="padding: 1px;">
                            <%--<td><DIV>
                                    <b> <%=iTotal%> </b>
                                </DIV>
                            </td>--%>
                            <td>
                                <%if (wbo.getAttribute("name") != null) {%>
                                <b><%=wbo.getAttribute("name")%></b>
                                <%}%>

                            </td>

                            <td style="width: 10%;">
                                <%if (wbo.getAttribute("projNm") != null) {%>
                                <b><%=(String) wbo.getAttribute("projNm")%></b>
                                <%}%>
                            </td>

                            <td style="width: 10%;">
                                <%if (wbo.getAttribute("unitNm") != null) {%>
                                <b><%=(String) wbo.getAttribute("unitNm")%></b>
                                <%}%>
                            </td>
                            <%
                                String Time;
                                Time = wbo.getAttribute("creationTime").toString().split(" ")[0];
                            %>
                            <td style="width: 10%;">
                                <%if (wbo.getAttribute("creationTime") != null) {%>
                                <b><%=Time%></b>
                                <%}%>
                            </td>

                            <td style="width: 10%;">
                                <%if (wbo.getAttribute("fullName") != null) {%>
                                <b><%=(String) wbo.getAttribute("fullName")%></b>
                                <%}%>
                            </td>

                            <td style="width: 10%;">
                                <%if (wbo.getAttribute("budget") != null) {%>
                                <b><%=(String) wbo.getAttribute("budget")%></b>
                                <%}%>
                            </td>
                        </tr>
                        <%
                            }
                        %>

                    </tbody>

                </table>
                <%
                } else {
                %>
                <br />
                <br />
                <div style="width: 50%; margin-left: auto; margin-right: auto;">
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
                                    iTotal++;
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
                    <br />
                    <br />
                </div>
                <%
                        }
                    }
                %>
                </td>
                </tr>
            </table>
        </form>

    </BODY>
</HTML>     
