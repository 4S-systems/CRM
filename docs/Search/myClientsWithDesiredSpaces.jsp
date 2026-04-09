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
    Vector data = (Vector) request.getAttribute("data"); 
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    String compStatusVal = (String) request.getAttribute("compStatus");
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
    String style = null, lang, langCode, cancel, title, beginDate, endDate, print;
    String complaintNo, customerName, complaintDate, complaint;
    String sat, sun, mon, tue, wed, thu, fri, view, complaintCode, PN, type, compStatus, compSender, noResponse, ageComp;
    String complStatus, senderName = null, fullName = null;
    if (stat.equals("En")) {
        align = "left";
        dir = "LTR";
        style = "text-align:right";
        lang = "&#1593;&#1585;&#1576;&#1610;";
        langCode = "Ar";
        cancel = "Cancel";
        title = "My Clients With Desired Spaces";
        beginDate = "From Date";
        endDate = "To Date";
        print = "Print";
        complaintNo = "Order No.";
        customerName = "Customer name";
        complaintDate = "Calling date";
        complaint = "Complaint";
        sat = "Sat";
        sun = "Sun";
        mon = "Mon";
        tue = "Tue";
        wed = "Wed";
        thu = "Thu";
        fri = "Fri";
        view = "View";
        complaintCode = "Complaint code";
        type = "Type";
        compStatus = "Staus";
        compSender = "Sender";
        noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
        ageComp = "A.C(day)";
        PN = "Requests No.";
    } else {
        dir = "RTL";
        align = "right";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        title = "عملائى مع المساحات المطلوبة";
        PN = "عدد الرغبات";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        print = "&#1591;&#1576;&#1575;&#1593;&#1577; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
        complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
        customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        complaintDate = "&#1608;&#1602;&#1578; &#1575;&#1604;&#1575;&#1578;&#1589;&#1575;&#1604;";
        complaint = "&#1575;&#1604;&#1591;&#1604;&#1576;";
        sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
        sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
        mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
        tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
        wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
        thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
        fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
        view = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
        complaintCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1591;&#1604;&#1576;";
        type = "النوع";
        compStatus = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
        compSender = "&#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;";
        noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
        ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";

    }
    String sDate, sTime = null;
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
    $(function() {
        $("#beginDate, #endDate").datepicker({
            changeMonth: true,
            changeYear: true,
            maxDate: 0,
            dateFormat: "yy/mm/dd"
        });
    });
    
    var oTable;
    $(document).ready(function() {
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
                    "targets": [1,2,3,4,5],
                    "orderable": false
                }],
                "drawCallback": function (settings) {
                    var api = this.api();
                    var rows = api.rows({page: 'current'}).nodes();
                    var last = null;
                    api.column(0, {page: 'current'}).data().each(function (group, i) {
                        if (last !== group) {
                            $(rows).eq(i).before(
                                '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 16px; background-color: lightgray; color: #a41111;" colspan="5">' + group + '</td></tr>'
                            );
                            last = group;
                        }
                    });
                }

        }).fadeIn(2000);
    });




    function getComplaints() {
//        alert("asd");
        var beginDate = $("#beginDate").val();
        var endDate = $("#endDate").val();
        if ((beginDate = null || beginDate == "")) {
            alert("من فضلك أدخل تاريخ البداية");
        }
        else if ((endDate = null || endDate == "")) {
            alert("من فضلك أدخل تاريخ النهاية");

        } else {
            beginDate = $("#beginDate").val();
            endDate = $("#endDate").val();
            document.COMP_FORM.action = "<%=context%>/SearchServlet?op=myClientsWithDesiredSpaces&beginDate=" + beginDate + "&endDate=" + endDate ;
            document.COMP_FORM.submit();
        }
    }


    /* preparing pie chart */
        var chart;
        $(document).ready(function() {
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
                    formatter: function() {
                        return '<b>'+ this.point.name +'</b>: '+ '%'+Highcharts.numberFormat(this.percentage, 2);
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
                            formatter: function() {
                                return '<b>'+ this.point.name +'</b>: '+  '%'+ Highcharts.numberFormat(this.percentage, 2);
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
                                <TR>

                                    <TD class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </TD>
                                    <TD   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </TD>
                                </TR>
                                <TR>

                                    <TD style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
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
                                    </TD>

                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <% if (eDate != null && !eDate.isEmpty()) {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=eDate%>" title="تاريخ الرغبه فى المشروع"><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" title="تاريخ الرغبه فى المشروع"><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>

                                </TR>
                                
                                <tr>
                                <br><br>
                                <TD STYLE="text-align:center" CLASS="td" colspan="3">  
                                    <button  onclick="JavaScript: getComplaints();"   STYLE="color: #000;font-size:15;margin-top: 20px;font-weight:bold; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  

                                </TD>
                                </tr>
                            </table>

                        </fieldset>

        <div id="container" style="width: 600px; height: 300px; margin: 0 auto"></div>
        <br/><br/>
        <% if (data != null && !data.isEmpty()) {%>
        <TABLE ALIGN="center" DIR="RTL" WIDTH=480 CELLSPACING=2 CELLPADDING=1>
           
        </table>
    <center> <b> <font size="3" color="red"> <%=PN%> : <%=data.size()%> </font></b></center> 
    <table class="blueBorder"  id="indextable" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none;">
        <thead>
            <TR>
                <%--<TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%"><SPAN ><b>#</b></SPAN></TH>--%>
                <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width=""><SPAN><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></SPAN></TH>
                <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="40%"><SPAN><b> المشروع</b></SPAN></TH>
                <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="40%"><SPAN><b> الوحده</b></SPAN></TH>
                <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="40%"><SPAN><b> تاريخ اضافة الرغبه</b></SPAN></TH>
                <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="40%"><SPAN><b> المصدر</b></SPAN></TH>
                <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="40%"><SPAN><b> المساحة</b></SPAN></TH>


            </TR>
        </thead> 
        <tbody  id="planetData2">  

            <%

                Enumeration e = data.elements();
                String compStyle = "";
                WebBusinessObject wbo = new WebBusinessObject();
                while (e.hasMoreElements()) {
                    iTotal++;
                    wbo = (WebBusinessObject) e.nextElement();
                   
                    
            %>

            <TR style="padding: 1px;">
                <%--<TD><DIV>
                        <b> <%=iTotal%> </b>
                    </DIV>
                </td>--%>
                <TD>
                    <%if (wbo.getAttribute("name") != null) {%>
                    <b><%=wbo.getAttribute("name")%></b>
                    <%}%>

                </TD>
                
                <TD style="width: 10%;">
                    <%if (wbo.getAttribute("projNm") != null) {%>
                    <b><%=(String)wbo.getAttribute("projNm")%></b>
                    <%}%>
                </TD>
                
                <TD style="width: 10%;">
                    <%if (wbo.getAttribute("unitNm") != null) {%>
                    <b><%=(String)wbo.getAttribute("unitNm")%></b>
                    <%}%>
                </TD>
                <%
                    String Time;
                    Time = wbo.getAttribute ("creationTime").toString().split(" ")[0];
                %>
                <TD style="width: 10%;">
                    <%if (wbo.getAttribute("creationTime") != null) {%>
                    <b><%=Time%></b>
                    <%}%>
                </TD>
                
                <TD style="width: 10%;">
                    <%if (wbo.getAttribute("fullName") != null) {%>
                    <b><%=(String)wbo.getAttribute("fullName")%></b>
                    <%}%>
                </TD>
                
                <TD style="width: 10%;">
                    <%if (wbo.getAttribute("budget") != null) {%>
                    <b><%=(String)wbo.getAttribute("budget")%></b>
                    <%}%>
                    </TD>
                 </TR>
            <%
                    }
            %>
            
        </tbody>

    </table>
    <%
            }
    %>
    </td>
                </tr>
            </table>
        </form>
    
</BODY>
</HTML>     
