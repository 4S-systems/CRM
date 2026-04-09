<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.maintenance.db_access.ProjectsByGroupMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.maintenance.db_access.IssueByComplaintAllCaseMgr"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@page import="com.silkworm.international.TouristGuide"%>
<%@page import="com.silkworm.util.DateAndTimeConstants"%>
<%@page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    IssueStatusMgr issueStatusMgr = IssueStatusMgr.getInstance();
    String context = metaMgr.getContext();

    ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    Calendar cal = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());
    cal.add(Calendar.MONTH, -1);
    String prev = sdf.format(cal.getTime());
    ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();

    String stat = "Ar";
    String align = "center";
    String dir = null;
    String style = null, lang, langCode, cancel, title, beginDate, endDate, print;
    String complaintNo, requestTitle, complaintDate, complaint;
    String sat, sun, mon, tue, wed, thu, fri, view, complaintCode, PN, type, compStatus, compSender, noResponse, ageComp;
    String complStatus, senderName = null, fullName = null;
    if (stat.equals("En")) {
        align = "left";
        dir = "LTR";
        style = "text-align:right";
        lang = "&#1593;&#1585;&#1576;&#1610;";
        langCode = "Ar";
        cancel = "Cancel";
        title = "Complaints Reprot";
        beginDate = "From Date";
        endDate = "To Date";
        print = "Print";
        complaintNo = "Order No.";
        requestTitle = "Customer name";
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
        title = "عمليات أدارة التشطيبات";
        PN = "عدد الطلبات";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        print = "&#1591;&#1576;&#1575;&#1593;&#1577; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
        complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
        requestTitle = "طلب - وحدة";
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
    String statusStartDate, statusEndDate, flag, statusFirstDate, statusLastDate, finalStatus;
%>



<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">   
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });


            $(document).ready(function () {
                $('#indextable').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 40, 70, 100, -1], [20, 40, 70, 100, "All"]],
                    iDisplayLength: 20,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).show();
                $(".dataTables_length, .dataTables_info").css("float", "left");
                $(".dataTables_filter, .dataTables_paginate").css("float", "right");
            });


            function viewAllIssueComments(issueID) {
                var url = "<%=context%>/CommentsServlet?op=viewAllIssueComments&issueID=" + issueID;
                jQuery('#show_comments').load(url);
                $('#show_comments').css("display", "block");
                $('#show_comments').bPopup();
            }
        </SCRIPT>
        <style>
            .totalTD {
                background-color: #FFFFCC;
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
        <div id="show_comments" name="show_comments" style="width: 70% !important;display: none;position: fixed ;">

        </div>
        <FORM NAME="COMP_FORM" METHOD="POST">
            <table align="center" width="80%">
                <tr>
                    <td class="td">
                        <fieldset>
                            <legend align="center">
                                <table dir="rtl" align="center">
                                    <tr>
                                        <td class="td">
                                            <font color="blue" size="6"> <%=title%></font>
                                        </td>
                                    </tr>
                                </table>
                            </legend>

                            <TABLE ALIGN="center" DIR="RTL" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                                <TR>
                                    <TD class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </TD>
                                    <TD  class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
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
                                        <input id="beginDate" name="beginDate" type="text" value="<%=beDate%>" /><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=prev%>" ><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </TD>

                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <% if (eDate != null && !eDate.isEmpty()) {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=eDate%>" ><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>
                                </TR>

                                <tr>
                                    <TD STYLE="text-align:center" CLASS="td" colspan="2">  
                                        <button  onclick="JavaScript: getComplaints();"   STYLE="color: #000;font-size:15;margin-top: 20px;font-weight:bold; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </TD>
                                </tr>
                            </table>
                        </fieldset>
                    </td>
                </tr>
            </table>

            <div id="loading" class="container" style="display: none">
                <div class="contentBar">
                    <div id="block_1" class="barlittle"></div>
                    <div id="block_2" class="barlittle"></div>
                    <div id="block_3" class="barlittle"></div>
                    <div id="block_4" class="barlittle"></div>
                    <div id="block_5" class="barlittle"></div>
                </div>
            </div>
            <% if (data != null && !data.isEmpty()) {%>
            <table class="blueBorder"  id="indextable" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none; text-align: center">
                <thead>
                    <TR>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><b>#</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="15%" colspan="1"><img src="images/icons/operation.png" width="24" height="24"/></TH>  
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%" rowspan="2"><img src="images/icons/client.png" width="20" height="20" /><b> <%=requestTitle%></b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><img src="images/icons/key.png" width="20" height="20" /><b> <%=complaintCode%></b></TH>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%" colspan="4"><b>ادارة التشطيبات</b></th>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" colspan="4"><b>ادارة الجودة</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" colspan="4"><b>خدمة العملاء</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" colspan="2"><b>الزمن الكلي</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><b>الحالة النهائية</b></TH>
                        <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><b>عدد المعتمدات</b></TH>
                    </TR>

                    <TR>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</TH>

                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">تاريخ الإرسال</TH>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">تاريخ الإغلاق</th>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">يوم</th>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">ساعة</th>

                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">تاريخ الإرسال</TH>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">تاريخ الإغلاق</th>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">يوم</th>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">ساعة</th>

                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">تاريخ الإرسال</TH>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">تاريخ الإغلاق</th>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">يوم</th>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">ساعة</th>

                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">يوم</th>
                        <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">ساعة</th>
                    </TR>
                </thead>
                <tbody id="planetData2">
                    <%
                        String compStyle = "";
                        int iTotal = 0, noOfComplaints;
                        for (WebBusinessObject wbo : data) {
                            finalStatus = "مفتوح";
                            iTotal++;
                            WebBusinessObject clientCompWbo = null;
                            String compType = "";
                            clientCompWbo = clientComplaintsMgr.getOnSingleKey((String) wbo.getAttribute("clientComId"));
                            noOfComplaints = clientComplaintsMgr.getNumberOfAppropriations((String) clientCompWbo.getAttribute("issueId"));

                            //get client complaint - issue status
                            Vector<WebBusinessObject> complaintStatusVec = issueStatusMgr.getAllStatusForObject((String) clientCompWbo.getAttribute("id"));
                            WebBusinessObject firstStatus = new WebBusinessObject();
                            WebBusinessObject lastStatus = new WebBusinessObject();

                            firstStatus = (WebBusinessObject) complaintStatusVec.get(0);
                            statusStartDate = (String) firstStatus.getAttribute("beginDate");
                            statusFirstDate = (String) firstStatus.getAttribute("beginDate");

                            if (complaintStatusVec.size() > 1) {
                                lastStatus = (WebBusinessObject) complaintStatusVec.get(complaintStatusVec.size() - 1);

                                String statusType = (String) lastStatus.getAttribute("statusName");

                                if (statusType.equals("7")) {
                                    flag = "old";
                                    statusEndDate = (String) lastStatus.getAttribute("beginDate");
                                    statusLastDate = (String) lastStatus.getAttribute("beginDate");
                                } else {
                                    flag = "today";
                                    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                    cal = Calendar.getInstance();
                                    statusEndDate = dateFormat.format(cal.getTime());
                                    statusLastDate = dateFormat.format(cal.getTime());
                                }
                            } else {
                                flag = "today";
                                DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                cal = Calendar.getInstance();
                                statusEndDate = dateFormat.format(cal.getTime());
                                statusLastDate = dateFormat.format(cal.getTime());
                            }

                            //get the diffrenence between end and start date
                            DateAndTimeControl dtControl = new DateAndTimeControl();
                            Vector duration = dtControl.calculateDateDiff(statusStartDate, statusEndDate);

                            if (((String) clientCompWbo.getAttribute("ticketType")).equals("1")) {
                                compType = "شكوى";
                                compStyle = "comp";
                            } else if (((String) clientCompWbo.getAttribute("ticketType")).equals("2")) {
                                compType = "طلب";
                                compStyle = "order";
                            } else if (((String) clientCompWbo.getAttribute("ticketType")).equals("3")) {
                                compType = "استعلام";
                                compStyle = "query";
                            }
                    %>
                    <tr>
                        <TD>
                            <%=iTotal%>
                        </td>
                        <td width="2.5%">
                            <a href="JavaScript: viewAllIssueComments('<%=wbo.getAttribute("issue_id")%>');">
                                <img style="margin: 3px" src="images/icons/accept-with-note.png" width="24" height="24"/>
                            </a>
                        </td>
                        <TD  style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                            <%if (wbo.getAttribute("issue_id") != null) {%>
                            <a href="<%=context%>/IssueServlet?op=getCompl3&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>"> <font color="red"><%=wbo.getAttribute("businessID")%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate")%></font></a>
                                <%}%>
                        </TD>
                        <TD nowrap>
                            <%if (wbo.getAttribute("compSubject") != null) {%><b><%=wbo.getAttribute("compSubject")%></b><%}%>
                        </TD>


                        <TD ><b><%=wbo.getAttribute("businessCompId")%></b></TD>

                        <%
                            c = Calendar.getInstance();
                            DateFormat formatter;
                            formatter = new SimpleDateFormat("dd/MM/yyyy");
                            String[] arrDate = statusStartDate.split(" ");
                            Date date = new Date();
                            sDate = arrDate[0];
                            sTime = arrDate[1];
                            String[] arrTime = sTime.split(":");
                            sTime = arrTime[0] + ":" + arrTime[1];
                            sDate = sDate.replace("-", "/");
                            arrDate = sDate.split("/");
                            sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
                            c.setTime((Date) formatter.parse(sDate));
                            int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                            String currentDate = formatter.format(date);
                            String sDay = null;
                            if (dayOfWeek == 7) {
                                sDay = sat;
                            } else if (dayOfWeek == 1) {
                                sDay = sun;
                            } else if (dayOfWeek == 2) {
                                sDay = mon;
                            } else if (dayOfWeek == 3) {
                                sDay = tue;
                            } else if (dayOfWeek == 4) {
                                sDay = wed;
                            } else if (dayOfWeek == 5) {
                                sDay = thu;
                            } else if (dayOfWeek == 6) {
                                sDay = fri;
                            }
                        %>
                        <TD nowrap style=" background-color: #FFDDED"><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>

                        <%
                            formatter = new SimpleDateFormat("dd/MM/yyyy");
                            String[] arrEndDate = statusEndDate.split(" ");
                            date = new Date();
                            sDate = arrEndDate[0];
                            sTime = arrEndDate[1];
                            String[] arrEndTime = sTime.split(":");
                            sTime = arrEndTime[0] + ":" + arrEndTime[1];
                            sDate = sDate.replace("-", "/");
                            arrEndDate = sDate.split("/");
                            sDate = arrEndDate[2] + "/" + arrEndDate[1] + "/" + arrEndDate[0];
                            c.setTime((Date) formatter.parse(sDate));
                            dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                            currentDate = formatter.format(date);
                            sDay = null;
                            if (dayOfWeek == 7) {
                                sDay = sat;
                            } else if (dayOfWeek == 1) {
                                sDay = sun;
                            } else if (dayOfWeek == 2) {
                                sDay = mon;
                            } else if (dayOfWeek == 3) {
                                sDay = tue;
                            } else if (dayOfWeek == 4) {
                                sDay = wed;
                            } else if (dayOfWeek == 5) {
                                sDay = thu;
                            } else if (dayOfWeek == 6) {
                                sDay = fri;
                            }
                        %>
                        <TD nowrap style=" background-color: #b9d2ef"  ><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>
                        <TD><b><%=duration.get(0)%></b></TD>
                        <TD><b><%=duration.get(1)%></b></TD>

                        <%
                            complaintStatusVec = issueStatusMgr.getAllStatusForIssueAndDepCode((String) clientCompWbo.getAttribute("issueId"), "QM");
                            firstStatus = new WebBusinessObject();
                            lastStatus = new WebBusinessObject();
                            if (!complaintStatusVec.isEmpty()) {
                                firstStatus = (WebBusinessObject) complaintStatusVec.get(0);
                                statusStartDate = (String) firstStatus.getAttribute("beginDate");

                                if (complaintStatusVec.size() > 1) {
                                    lastStatus = (WebBusinessObject) complaintStatusVec.get(complaintStatusVec.size() - 1);

                                    String statusType = (String) lastStatus.getAttribute("statusName");

                                    if (statusType.equals("7")) {
                                        flag = "old";
                                        statusEndDate = (String) lastStatus.getAttribute("beginDate");
                                        statusLastDate = (String) lastStatus.getAttribute("beginDate");
                                    } else {
                                        flag = "today";
                                        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                        cal = Calendar.getInstance();
                                        statusEndDate = dateFormat.format(cal.getTime());
                                        statusLastDate = dateFormat.format(cal.getTime());
                                    }
                                } else {
                                    flag = "today";
                                    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                    cal = Calendar.getInstance();
                                    statusEndDate = dateFormat.format(cal.getTime());
                                    statusLastDate = dateFormat.format(cal.getTime());
                                }
                                formatter = new SimpleDateFormat("dd/MM/yyyy");
                                arrDate = statusStartDate.split(" ");
                                date = new Date();
                                sDate = arrDate[0];
                                sTime = arrDate[1];
                                arrTime = sTime.split(":");
                                sTime = arrTime[0] + ":" + arrTime[1];
                                sDate = sDate.replace("-", "/");
                                arrDate = sDate.split("/");
                                sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
                                c.setTime((Date) formatter.parse(sDate));
                                dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                                currentDate = formatter.format(date);
                                sDay = null;
                                if (dayOfWeek == 7) {
                                    sDay = sat;
                                } else if (dayOfWeek == 1) {
                                    sDay = sun;
                                } else if (dayOfWeek == 2) {
                                    sDay = mon;
                                } else if (dayOfWeek == 3) {
                                    sDay = tue;
                                } else if (dayOfWeek == 4) {
                                    sDay = wed;
                                } else if (dayOfWeek == 5) {
                                    sDay = thu;
                                } else if (dayOfWeek == 6) {
                                    sDay = fri;
                                }


                        %>
                        <TD nowrap style=" background-color: #FFDDED"><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>

                        <%
                            formatter = new SimpleDateFormat("dd/MM/yyyy");
                            arrEndDate = statusEndDate.split(" ");
                            date = new Date();
                            sDate = arrEndDate[0];
                            sTime = arrEndDate[1];
                            arrEndTime = sTime.split(":");
                            sTime = arrEndTime[0] + ":" + arrEndTime[1];
                            sDate = sDate.replace("-", "/");
                            arrEndDate = sDate.split("/");
                            sDate = arrEndDate[2] + "/" + arrEndDate[1] + "/" + arrEndDate[0];
                            c.setTime((Date) formatter.parse(sDate));
                            dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                            currentDate = formatter.format(date);
                            sDay = null;
                            if (dayOfWeek == 7) {
                                sDay = sat;
                            } else if (dayOfWeek == 1) {
                                sDay = sun;
                            } else if (dayOfWeek == 2) {
                                sDay = mon;
                            } else if (dayOfWeek == 3) {
                                sDay = tue;
                            } else if (dayOfWeek == 4) {
                                sDay = wed;
                            } else if (dayOfWeek == 5) {
                                sDay = thu;
                            } else if (dayOfWeek == 6) {
                                sDay = fri;
                            }
                            duration = dtControl.calculateDateDiff(statusStartDate, statusEndDate);
                        %>
                        <TD nowrap style=" background-color: #b9d2ef"  ><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>

                        <TD><b><%=duration.get(0)%></b></TD>
                        <TD><b><%=duration.get(1)%></b></TD> 
                                <%
                                } else {
                                %>
                        <TD><b>---</b></TD> 
                        <TD><b>---</b></TD> 
                        <TD><b>---</b></TD> 
                        <TD><b>---</b></TD> 
                            <%
                                }
                            %>
                            <%
                                complaintStatusVec = issueStatusMgr.getAllStatusForIssueAndDepCode((String) clientCompWbo.getAttribute("issueId"), "CSR");
                                firstStatus = new WebBusinessObject();
                                lastStatus = new WebBusinessObject();
                                if (!complaintStatusVec.isEmpty()) {
                                    firstStatus = (WebBusinessObject) complaintStatusVec.get(0);
                                    statusStartDate = (String) firstStatus.getAttribute("beginDate");

                                    if (complaintStatusVec.size() > 1) {
                                        lastStatus = (WebBusinessObject) complaintStatusVec.get(complaintStatusVec.size() - 1);

                                        String statusType = (String) lastStatus.getAttribute("statusName");

                                        if (statusType.equals("7")) {
                                            flag = "old";
                                            statusEndDate = (String) lastStatus.getAttribute("beginDate");
                                            statusLastDate = (String) lastStatus.getAttribute("beginDate");
                                            if(noOfComplaints == 3) {
                                                finalStatus = "مغلق";
                                            }
                                        } else {
                                            flag = "today";
                                            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                            cal = Calendar.getInstance();
                                            statusEndDate = dateFormat.format(cal.getTime());
                                            statusLastDate = dateFormat.format(cal.getTime());
                                        }
                                    } else {
                                        flag = "today";
                                        DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                                        cal = Calendar.getInstance();
                                        statusEndDate = dateFormat.format(cal.getTime());
                                        statusLastDate = dateFormat.format(cal.getTime());
                                    }
                                    formatter = new SimpleDateFormat("dd/MM/yyyy");
                                    arrDate = statusStartDate.split(" ");
                                    date = new Date();
                                    sDate = arrDate[0];
                                    sTime = arrDate[1];
                                    arrTime = sTime.split(":");
                                    sTime = arrTime[0] + ":" + arrTime[1];
                                    sDate = sDate.replace("-", "/");
                                    arrDate = sDate.split("/");
                                    sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
                                    c.setTime((Date) formatter.parse(sDate));
                                    dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                                    currentDate = formatter.format(date);
                                    sDay = null;
                                    if (dayOfWeek == 7) {
                                        sDay = sat;
                                    } else if (dayOfWeek == 1) {
                                        sDay = sun;
                                    } else if (dayOfWeek == 2) {
                                        sDay = mon;
                                    } else if (dayOfWeek == 3) {
                                        sDay = tue;
                                    } else if (dayOfWeek == 4) {
                                        sDay = wed;
                                    } else if (dayOfWeek == 5) {
                                        sDay = thu;
                                    } else if (dayOfWeek == 6) {
                                        sDay = fri;
                                    }


                            %>
                        <TD nowrap style=" background-color: #FFDDED"><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>

                        <%
                            formatter = new SimpleDateFormat("dd/MM/yyyy");
                            arrEndDate = statusEndDate.split(" ");
                            date = new Date();
                            sDate = arrEndDate[0];
                            sTime = arrEndDate[1];
                            arrEndTime = sTime.split(":");
                            sTime = arrEndTime[0] + ":" + arrEndTime[1];
                            sDate = sDate.replace("-", "/");
                            arrEndDate = sDate.split("/");
                            sDate = arrEndDate[2] + "/" + arrEndDate[1] + "/" + arrEndDate[0];
                            c.setTime((Date) formatter.parse(sDate));
                            dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                            currentDate = formatter.format(date);
                            sDay = null;
                            if (dayOfWeek == 7) {
                                sDay = sat;
                            } else if (dayOfWeek == 1) {
                                sDay = sun;
                            } else if (dayOfWeek == 2) {
                                sDay = mon;
                            } else if (dayOfWeek == 3) {
                                sDay = tue;
                            } else if (dayOfWeek == 4) {
                                sDay = wed;
                            } else if (dayOfWeek == 5) {
                                sDay = thu;
                            } else if (dayOfWeek == 6) {
                                sDay = fri;
                            }
                            duration = dtControl.calculateDateDiff(statusStartDate, statusEndDate);
                        %>
                        <TD nowrap style=" background-color: #b9d2ef"  ><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>

                        <TD><b><%=duration.get(0)%></b></TD>
                        <TD><b><%=duration.get(1)%></b></TD> 
                                <%
                                } else {
                                %>
                        <TD><b>---</b></TD> 
                        <TD><b>---</b></TD> 
                        <TD><b>---</b></TD> 
                        <TD><b>---</b></TD> 
                            <%
                                }

                                duration = dtControl.calculateDateDiff(statusFirstDate, statusLastDate);
                            %> 

                        <TD class="totalTD"><b><%=duration.get(0)%></b></TD>
                        <TD class="totalTD"><b><%=duration.get(1)%></b></TD> 
                        <td><%=finalStatus%></td>
                        <td><%=noOfComplaints%></td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <% } else if (data != null && data.isEmpty()) {%>
            <table align="center" width="80%">
                <tr>
                    <td class="td">
                        <fieldset>
                            <center><b style="color: red; font-size: x-large;">لا يوجد نتائج للبحث</b></center>
                        </fieldset>
                    </td>
                </tr>
            </table>
            <%
                }
            %>
        </form>
    </body>
</html>