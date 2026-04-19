<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page contentType="text/HTML; charset=UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
      <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Sales_Market.Sales_Market"  />
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript">

            $(document).ready(function() {
                $('#calls').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 40, 70,100, -1], [20, 40, 70,100, "All"]],
                    iDisplayLength: 20,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                   
                    "aaSorting": [[ 0, "desc" ]],

                    "aaSorting": [[ 3, "asc" ]]

                }).show();
            });

            var TableIDvalue = "indextable";

            //
            //////////////////////////////////////
            var TableLastSortedColumn = -1;
            function SortTable() {
                var sortColumn = parseInt(arguments[0]);
                var type = arguments.length > 1 ? arguments[1] : 'T';
                var dateformat = arguments.length > 2 ? arguments[2] : '';
                var table = document.getElementById(TableIDvalue);
                var tbody = table.getElementsByTagName("tbody")[0];
                var rows = tbody.getElementsByTagName("tr");
                var arrayOfRows = new Array();
                type = type.toUpperCase();
                dateformat = dateformat.toLowerCase();
                for (var i = 0, len = rows.length; i < len; i++) {
                    arrayOfRows[i] = new Object;
                    arrayOfRows[i].oldIndex = i;
                    var celltext = rows[i].getElementsByTagName("td")[sortColumn].innerHTML.replace(/<[^>]*>/g, "");
                    if (type == 'D') {
                        arrayOfRows[i].value = GetDateSortingKey(dateformat, celltext);
                    }
                    else {
                        var re = type == "N" ? /[^\.\-\+\d]/g : /[^a-zA-Z0-9]/g;
                        arrayOfRows[i].value = celltext.replace(re, "").substr(0, 25).toLowerCase();
                    }
                }
                if (sortColumn == TableLastSortedColumn) {
                    arrayOfRows.reverse();
                }
                else {
                    TableLastSortedColumn = sortColumn;
                    switch (type) {
                        case "N" :
                            arrayOfRows.sort(CompareRowOfNumbers);
                            break;
                        case "D" :
                            arrayOfRows.sort(CompareRowOfNumbers);
                            break;
                        default  :
                            arrayOfRows.sort(CompareRowOfText);
                    }
                }
                var newTableBody = document.createElement("tbody");
                for (var i = 0, len = arrayOfRows.length; i < len; i++) {
                    newTableBody.appendChild(rows[arrayOfRows[i].oldIndex].cloneNode(true));
                }
                table.replaceChild(newTableBody, tbody);
            } // function SortTable()

            function CompareRowOfText(a, b) {
                var aval = a.value;
                var bval = b.value;
                return(aval == bval ? 0 : (aval > bval ? 1 : -1));
            } // function CompareRowOfText()

            function CompareRowOfNumbers(a, b) {
                var aval = /\d/.test(a.value) ? parseFloat(a.value) : 0;
                var bval = /\d/.test(b.value) ? parseFloat(b.value) : 0;
                return(aval == bval ? 0 : (aval > bval ? 1 : -1));
            } // function CompareRowOfNumbers()

            function GetDateSortingKey(format, text) {
                if (format.length < 1) {
                    return "";
                }
                format = format.toLowerCase();
                text = text.toLowerCase();
                text = text.replace(/^[^a-z0-9]*/, "", text);
                text = text.replace(/[^a-z0-9]*$/, "", text);
                if (text.length < 1) {
                    return "";
                }
                text = text.replace(/[^a-z0-9]+/g, ",", text);
                var date = text.split(",");
                if (date.length < 3) {
                    return "";
                }
                var d = 0, m = 0, y = 0;
                for (var i = 0; i < 3; i++) {
                    var ts = format.substr(i, 1);
                    if (ts == "d") {
                        d = date[i];
                    }
                    else if (ts == "m") {
                        m = date[i];
                    }
                    else if (ts == "y") {
                        y = date[i];
                    }
                }
                if (d < 10) {
                    d = "0" + d;
                }
                if (/[a-z]/.test(m)) {
                    m = m.substr(0, 3);
                    switch (m) {
                        case "jan" :
                            m = 1;
                            break;
                        case "feb" :
                            m = 2;
                            break;
                        case "mar" :
                            m = 3;
                            break;
                        case "apr" :
                            m = 4;
                            break;
                        case "may" :
                            m = 5;
                            break;
                        case "jun" :
                            m = 6;
                            break;
                        case "jul" :
                            m = 7;
                            break;
                        case "aug" :
                            m = 8;
                            break;
                        case "sep" :
                            m = 9;
                            break;
                        case "oct" :
                            m = 10;
                            break;
                        case "nov" :
                            m = 11;
                            break;
                        case "dec" :
                            m = 12;
                            break;
                        default    :
                            m = 0;
                    }
                }
                if (m < 10) {
                    m = "0" + m;
                }
                y = parseInt(y);
                if (y < 100) {
                    y = parseInt(y) + 2000;
                }
                return "" + String(y) + "" + String(m) + "" + String(d) + "";
            } // function GetDateSortingKey()
        </script>


    </head>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        Calendar weekCalendar = Calendar.getInstance();
        Calendar beginWeekCalendar = Calendar.getInstance();
        Calendar endWeekCalendar = Calendar.getInstance();

        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Hashtable logos = new Hashtable();
        logos = parseSideMenu.getCompanyLogo("configration" + metaMgr.getCompanyName() + ".xml");
        String weeksNo = logos.get("weeksNo").toString();

        int dayOfBack = new Integer(weeksNo).intValue() * 7;

        int dayOfWeekValue = weekCalendar.getTime().getDay();
        Calendar beginSecondWeekCalendar = Calendar.getInstance();
        Calendar endSecondWeekCalendar = Calendar.getInstance();
        beginSecondWeekCalendar = (Calendar) weekCalendar.clone();
        endSecondWeekCalendar = (Calendar) weekCalendar.clone();

        beginSecondWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue - dayOfBack);
        endSecondWeekCalendar.add(endWeekCalendar.DATE, -dayOfWeekValue);

        java.sql.Date beginSecondInterval = new java.sql.Date(beginSecondWeekCalendar.getTimeInMillis());
        java.sql.Date endSecondInterval = new java.sql.Date(endSecondWeekCalendar.getTimeInMillis());
        String beginDate = null;
        String endDate = null;

        DateFormat sqlDateParser = new SimpleDateFormat("yyyy/MM/dd");
        beginDate = sqlDateParser.format(beginSecondInterval);
        endDate = sqlDateParser.format(endSecondInterval);

        session = request.getSession();
        IssueMgr issueMgr = IssueMgr.getInstance();

        Vector<WebBusinessObject> issuesVector = new Vector();

        String context = metaMgr.getContext();

        int iTotal = 0;

        beginWeekCalendar = (Calendar) weekCalendar.clone();
        endWeekCalendar = (Calendar) weekCalendar.clone();

        beginWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue);
        endWeekCalendar.add(endWeekCalendar.DATE, 6 - dayOfWeekValue);

        java.sql.Date beginInterval = new java.sql.Date(beginWeekCalendar.getTimeInMillis());
        java.sql.Date endInterval = new java.sql.Date(endWeekCalendar.getTimeInMillis());
        IssueByComplaintAllCaseMgr issueByComplaintAllCaseMgr = IssueByComplaintAllCaseMgr.getInstance();
        // issuesVector = issueMgr.getIssuesListInRangeByEmg(new java.sql.Date(beginWeekCalendar.getTimeInMillis()), new java.sql.Date(endWeekCalendar.getTimeInMillis()),session);
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String[] key = new String[1];
        String[] value = new String[1];

        key[0] = "key8";

        value[0] = "7";

        String bDate = beginInterval.toString().substring(8, 10) + "-" + beginInterval.toString().substring(5, 7) + "-" + beginInterval.toString().substring(0, 4);
        String day = endInterval.toString().substring(8, 10);
        int endDay = Integer.parseInt(day) + 1;
        String eDate = endDay + "-" + endInterval.toString().substring(5, 7) + "-" + endInterval.toString().substring(0, 4);
        String resp = "1";
        issueMgr = IssueMgr.getInstance();
        
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        int withinCalls = 24;
        Map<String, String> withinIntervals = securityUser.getWithinIntervals();
        if (request.getParameter("withinCalls") != null) {
            withinCalls = new Integer(request.getParameter("withinCalls"));
            withinIntervals.put("withinCalls", "" + withinCalls);
        } else if (withinIntervals.containsKey("withinCalls")) {
            withinCalls = (new Integer(withinIntervals.get("withinCalls")));
        }
        issuesVector = issueMgr.getIssues(withinCalls, (String) userWbo.getAttribute("userId"));
      String stat = (String) request.getSession().getAttribute("currentMode");
        
        
        
        String sat, sun, mon, tue, wed, thu, fri, view, complaintCode, type, compStatus, compSender, noResponse, ageComp;
        String complStatus, senderName = null, fullName = null, viewDocuments, photoGallery;
        if (stat.equals("En")) {
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
            viewDocuments = "View Documents";
            photoGallery = "Photo Gallery";
        } else {
              sat = "السبت";
            sun = "الاحد";
            mon = "الاثنين";
            tue = "الثلاثاء";
            wed = "الاربعاء";
            thu = "الخميس";
            fri = "الجمعة";
            view = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
            complaintCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1591;&#1604;&#1576;";
            type = "النوع";
            compStatus = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
            compSender = "&#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;";
            noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
            viewDocuments = "مشاهدة المرفقات";
            photoGallery = "عرض الصور";
        }
        String sDate, sTime = null;
        
        
        
    %>


    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function changePage(url) {
            window.navigate(url);
        }

        function changeMode(name) {
            if (document.getElementById(name).style.display == 'none') {
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }

        function showLaterOrders() {
            var beginDate = document.getElementById("beginDate").value;
            var endDate = document.getElementById("endDate").value;
            var projectName = document.getElementById("projectName").value;
            var statusName = 'Schedule';

            window.navigate('<%=context%>/SearchServlet?op=StatusProjectList&beginDate=' + beginDate + '&endDate=' + endDate + '&projectName=' + projectName + '&statusName=' + statusName);
        }

        function showLaterClosedOrders() {
            var beginDate = document.getElementById("beginDate").value;
            var endDate = document.getElementById("endDate").value;
            var projectName = document.getElementById("projectName").value;
            var statusName = 'Finished';

            window.navigate('<%=context%>/SearchServlet?op=getJobOrdersByLateClosed&beginDate=' + beginDate + '&endDate=' + endDate + '&projectName=' + projectName + '&statusName=' + statusName);
        }

        function getComplaint(issueId, compId) {
            window.navigate('<%=context%>/IssueServlet?op=getCompl&issueId=' + issueId + '&compId=' + compId);
        }
        function closeComp(issueId, compId) {
            window.navigate('<%=context%>/IssueServlet?op=closeComp&issueId=' + issueId + '&compId=' + compId);
        }
        function removeComp(issueId, compId) {
            window.navigate('<%=context%>/IssueServlet?op=removeComp&issueId=' + issueId + '&compId=' + compId);
        }
      
        function updateCallType(obj){
           
            $(obj).parent().parent().find("#showContent").css("display","none");
            $(obj).parent().parent().find("#showContent1").css("display","block");
        }
        function removeCallType(obj){
           
            $(obj).parent().parent().find("#showContent1").css("display","none");
            $(obj).parent().parent().find("#showContent").css("display","block");
        }
        function removeCallDir(obj){
         
            $(obj).parent().parent().find("#showContent3").css("display","none");
            $(obj).parent().parent().find("#showContent2").css("display","block");
           
        }
        function updateCallType2(obj){
         
            $(obj).parent().parent().find("#showContent3").css("display","block");
            $(obj).parent().parent().find("#showContent2").css("display","none");
           
        }
        function updateDirections(obj){
            
            var direction= $(obj).parent().find("#direction:checked").val();


            var x="";
            if(direction=="incoming"){
                x="واردة";
            }
            if(direction=="out_call"){
                x="صادرة";
            }
                   
            var issueId=$(obj).parent().parent().parent().find("#issueId").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=updateCallDirection",
                data: {
                    direction:direction,
                    issueId:issueId
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                                                    
                    if (info.status == 'ok') {
                        $(obj).parent().parent().find("#showContent2").css("display","block");
                        $(obj).parent().parent().find("#showContent3").css("display","none");
                                                        
                        $(obj).parent().parent().find("#callType").html(x);
                    }
                    if (info.status == 'no') {
                        $(obj).parent().parent().find("#showContent2").css("display","none");
                        $(obj).parent().parent().find("#showContent3").css("display","block");
                        alert("وقع خطأ فى التحديث");
                    }
                    if (info.status == 'noChoose') {
                        $(obj).parent().parent().find("#showContent2").css("display","none");
                        $(obj).parent().parent().find("#showContent3").css("display","block");
                        alert("إختر اولا ثم قم بالتعديل");
                    }
                    
                }
            });
                
            
            
        }
        function updateType(obj){
            //            var x= $(obj).parent().find("#note").val();
            //            alert(x.length)
            //            if(x.length>0){
                
            var callType= $(obj).parent().find("#note:checked").val();
            var issueId=$(obj).parent().parent().parent().find("#issueId").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=updateCallType",
                data: {
                    callType:callType,
                    issueId:issueId
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $(obj).parent().parent().find("#showContent").css("display","block");
                        $(obj).parent().parent().find("#showContent1").css("display","none");
                      
                        $(obj).parent().parent().find("#callType").html(callType);
                    }
                    if (info.status == 'no') {
                        $(obj).parent().parent().find("#showContent").css("display","none");
                        $(obj).parent().parent().find("#showContent1").css("display","block");
                        alert("وقع خطأ فى التحديث");
                    }
                    if (info.status == 'noChoose') {
                        $(obj).parent().parent().find("#showContent2").css("display","none");
                        $(obj).parent().parent().find("#showContent3").css("display","block");
                        alert("إختر اولا ثم قم بالتعديل");
                    }
                }
            });
       }
        
        function viewDocuments(issueId) {
            var url='<%=context%>/IssueDocServlet?op=ListAttachedDocs&issueId=' + issueId +'';
            var wind = window.open(url,"عرض المستندات","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
            wind.focus();
        }
        
        function viewImages(issueId) {
            var url='<%=context%>/IssueDocServlet?op=ViewIssueImages&issueId=' + issueId +'';
            var wind = window.open(url,"عرض الصور","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
            wind.focus();
        }
        function submitformCalls()
        {
            document.within_form2.submit();
        }
    </SCRIPT>
    <style type="text/css">
        #link :hover{

            background: #f9f9f9;
        }
        .save__{
            width:20px;
            height:20px;
            background-image:url(images/icons/icon-32-publish.png);
            background-repeat: no-repeat;
            background-position: bottom;
            cursor: pointer;
            display: inline-block;
            margin-right: 3px;

        }
        .update__{
            width:20px;
            height:20px;
            background-image:url(images/icons/icon-32-unpublish.png);
            background-repeat: no-repeat;
            background-color: transparent;
            background-position: top;
            cursor: pointer;

        }
        .remove__{
            width:20px;
            height:20px;
            background-image:url(images/icons/icon-32-remove.png);
            background-repeat: no-repeat;
            background-color: transparent;
            background-position: top;
            cursor: pointer;
            display: inline-block
        }
    </style>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
    <CENTER>
        <FIELDSET class="set" style="width:96%;" >

            <DIV align=<fmt:message key="align"/>  >

            </DIV><br />
            <form name="within_form2" style="direction:<fmt:message key="direction"/>">
                 <b style="font-size: medium; direction:<fmt:message key="direction"/>"><fmt:message key="showsince"/> </b>
                <SELECT name="withinCalls" STYLE="width:125px; font-size: medium; font-weight: bold;" onchange="JavaScript: submitformCalls();">
                   <OPTION value="1" <%=withinCalls == 1? "selected": ""%>><fmt:message key="hour"/></OPTION>
                    <OPTION value="2" <%=withinCalls == 2? "selected": ""%>><fmt:message key="twohour"/></OPTION>
                    <OPTION value="3" <%=withinCalls == 3? "selected": ""%>> <fmt:message key="threehour"/></OPTION>
                    <OPTION value="24" <%=withinCalls == 24? "selected": ""%>><fmt:message key="day"/></OPTION>
                    <OPTION value="48" <%=withinCalls == 48? "selected": ""%>><fmt:message key="twoday"/></OPTION>
                    <OPTION value="72" <%=withinCalls == 72? "selected": ""%>><fmt:message key="threeday"/></OPTION>
                    <OPTION value="168" <%=withinCalls == 168? "selected": ""%>><fmt:message key="week"/></OPTION>
                    <OPTION value="720" <%=withinCalls == 720? "selected": ""%>><fmt:message key="month"/></OPTION>
                    <OPTION value="1440" <%=withinCalls == 1440? "selected": ""%>><fmt:message key="twomonth"/></OPTION>
                    <option value="10000" <%=withinCalls >= 10000? "selected": ""%>> <fmt:message key="unspecified"/> </OPTION>
                </SELECT>
            </form>
            <div style="width:70%;margin-right: auto;margin-left: auto;">
                <TABLE class="blueBorder"  id="calls" align="center" DIR=<fmt:message key="direction"/> WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none;">
                    <thead><TR>
                            <!--    <TH  width="7%"><SPAN ></SPAN></TH>-->
                            <TH  style="font-size: 13px;" ><SPAN ><img src="images/icons/Numbers.png" width="20" height="20" /><b>  <fmt:message key="callerno"/>  </b></SPAN></TH>
                            <TH  style="font-size: 13px;" ><b>    <fmt:message key="callscount"/></b></TH>
                            <TH  style="font-size: 13px;" ><b>  <fmt:message key="calltype"/></b></TH>
                            <TH  style="font-size: 13px;" ><b>  <fmt:message key="calldirec"/> </b></TH>
                            <TH style="font-size: 13px;"  ><b> <fmt:message key="calldate"/> </b></TH>
                            <TH  style="font-size: 13px;" ><b>  <fmt:message key="number"/></b></TH>
                            <TH style="font-size: 13px;"  >
                                <SPAN><img src="images/icons/client.png" width="20" height="20" /><b> 
                                        <fmt:message key="clientname"/>
                                    </b></SPAN></TH>



                        </TR></thead>
                    <tbody>  
                        <%
                            for (WebBusinessObject wbo : issuesVector) {

                                iTotal++;
                                String compStyle = "";
                        %>
                        <TR>

                            <TD id="link">
                                <a href='JavaScript:viewImages("<%=wbo.getAttribute("issueId")%>")'>
                                    <img src="images/imicon.gif" width="17" height="17" title="<%=photoGallery%>" />
                                </a>
                                <a href='JavaScript:viewDocuments("<%=wbo.getAttribute("issueId")%>")'>
                                    <img src="images/view.png" width="17" height="17" title="<%=viewDocuments%>" />
                                </a>
                                <%
                                    if (wbo.getAttribute("numOfOrders").equals("empty")) {
                                %>
                                <a style="color: red"><%=wbo.getAttribute("busId")%></a>
                                <%} else {%>

                                <a href="<%=context%>/IssueServlet?op=getCompUnderIssue&issueId=<%=wbo.getAttribute("issueId")%>" style="color: blue">
                                    <%=wbo.getAttribute("busId")%>
                                </a> 
                                <%}%>
                                <input type="hidden" id="issueId" value="<%=wbo.getAttribute("issueId")%>" />
                            </TD>
                            <TD style="width: 10%;">
                                <% if (wbo.getAttribute("numOfOrders").equals("empty")) {
                                %>

                                <LABEL style="color: #27272A">0</LABEL>
                                <%} else {%>
                                <LABEL style="color: #27272A"><%=wbo.getAttribute("numOfOrders")%></LABEL>
                                <%}%>

                            </TD>
                            <TD nowrap>
                                <div id="showContent" style="display: block">
                                    <b id="callType" onclick="updateCallType(this)" style="cursor: pointer"
                                       onMouseOver="Tip('تعديل', LEFT, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')" onMouseOut="UnTip()">
                                        <img src="images/dialogs/phone.png" alt="phone" width="20px" style="display: <%=((String) wbo.getAttribute("issueDesc")).equalsIgnoreCase("call")? "" : "none"%>"/>
                                        <img src="images/dialogs/handshake.png" alt="meeting" width="20px" style="display: <%=((String) wbo.getAttribute("issueDesc")).equalsIgnoreCase("meeting")? "" : "none"%>"/>
                                        <img src="images/dialogs/internet-icon.png" alt="internet" width="20px" style="display: <%=((String) wbo.getAttribute("issueDesc")).equalsIgnoreCase("internet")? "" : "none"%>"/>
                                        <%=wbo.getAttribute("issueDesc")%></b>
                                    <!-- <div  class="update__" onclick="updateCallType(this)" ></div>
                                    -->
                                </div>
                                <div id="showContent1" style="display: none">
                                    <input  name="note" type="radio" value="call"  id="note" />
                                    <label><img src="images/dialogs/phone.png" alt="phone" width="20px"/>مكالمة</label>
                                    <input name="note" type="radio" value="meeting" id="note" style="margin-right: 10px;"/>
                                    <label><img src="images/dialogs/handshake.png" alt="meeting" width="20px"/>مقابلة</label>
                                    <input name="note" type="radio" value="internet" id="note" style="margin-right: 10px;">
                                    <label> <img src="images/dialogs/internet-icon.png" alt="internet" width="20px"> أنترنت</label>
                                    <div class="save__" onclick="updateType(this)"></div>
                                    <div class="remove__" onclick="removeCallType(this)"></div>
                                </div>
                            </TD>
                            <TD nowrap>

                                <% String callType = "";
                                    if (wbo.getAttribute("callType").equals("incoming")) {

                                        callType = "واردة";%>


                                <%
                                } else if (wbo.getAttribute("callType").equals("out_call")) {
                                    callType = "صادرة";%>


                                <%} else if (wbo.getAttribute("callType").equals("") || wbo.getAttribute("callType").equals("null")) {
                                    callType = "";%>

                                <%}%>
                                <div id="showContent2">
                                    <b id="callType" onclick="updateCallType2(this)" style="cursor: pointer"
                                        onMouseOver="Tip('تعديل', LEFT, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')" onMouseOut="UnTip()">
                                        <img src="images/dialogs/call-incoming.png" width="20px" style="display: <%=wbo.getAttribute("callType").equals("incoming")? "" : "none"%>"/>
                                        <img src="images/dialogs/call-outgoing.png" width="20px" style="display: <%=wbo.getAttribute("callType").equals("out_call")? "" : "none"%>"/><%=callType%></b>
                                    <!--<div  class="update__" onclick="updateCallType2(this)"></div>-->

                                </div>
                                <div id="showContent3"  style="display: none">
                                    <input  name="direction" type="radio" value="incoming"  id="direction" />
                                    <label><img src="images/dialogs/call-incoming.png" width="24px"/>واردة</label>
                                    <input name="direction" type="radio" value="out_call" id="direction" style="margin-right: 10px;"/>
                                    <label><img src="images/dialogs/call-outgoing.png" width="24px"/>صادرة</label>
                                    <div class="save__" onclick="updateDirections(this)"></div>
                                    <div class="remove__" onclick="removeCallDir(this)"></div>
                                </div>



                            </TD>


                            <TD ><b><%=wbo.getAttribute("creationTime")%></b></TD>
                            <TD ><%=wbo.getAttribute("clientNo")%></TD>
                            <TD ><b><%=wbo.getAttribute("clientName")%></b></TD>


                        </TR>
                        <% }%>
                    </tbody>

                </TABLE>
            </div>
            <input type="hidden" name="beginDate" id="beginDate" value="<%=beginDate%>">
            <input type="hidden" name="endDate" id="endDate" value="<%=endDate%>">
            <input type="hidden" name="projectName" id="projectName" value="All">
            <input type="hidden" name="statusName" id="statusName" value="Schedule">
            <BR>
        </FIELDSET>
    </CENTER>
</BODY>
</HTML>
