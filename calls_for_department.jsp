<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page contentType="text/HTML; charset=UTF-8" %>
<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>
        <script type="text/javascript">
            $(document).ready(function() {
                $('#calls').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 40, 70, 100, -1], [20, 40, 70, 100, "All"]],
                    iDisplayLength: 20,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[0, "desc"]],
                    "aaSorting": [[3, "asc"]]

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
        String context = metaMgr.getContext();

        session = request.getSession();
        IssueMgr issueMgr = IssueMgr.getInstance();
        ProjectMgr projectMgr = ProjectMgr.getInstance();

        Vector<WebBusinessObject> issuesVector = new Vector();

        WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String userId = (String) loggedUser.getAttribute("userId");
        String projectCode = projectMgr.getByKeyColumnValue("key5", userId, "key3");
        
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        int withinCallDepartment = 24;
        Map<String, String> withinIntervals = securityUser.getWithinIntervals();
        if (request.getParameter("withinCallDepartment") != null) {
            withinCallDepartment = new Integer(request.getParameter("withinCallDepartment"));
            withinIntervals.put("withinCallDepartment", "" + withinCallDepartment);
        } else if (withinIntervals.containsKey("withinCallDepartment")) {
            withinCallDepartment = (new Integer(withinIntervals.get("withinCallDepartment")));
        }
        
        if (projectCode != null && !projectCode.isEmpty()) {
            issuesVector = issueMgr.getIssuesByDepartmentWithin(withinCallDepartment, projectCode);
        }
        
        String align, dir, customerName, viewDocuments, photoGallery;
        String stat = (String) request.getSession().getAttribute("currentMode");
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            customerName = "Customer name";
            viewDocuments = "View Documents";
            photoGallery = "Photo Gallery";
        } else {
            align = "right";
            dir = "RTL";
            customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
            viewDocuments = "مشاهدة المرفقات";
            photoGallery = "عرض الصور";
        }
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

        function updateCallType(obj) {

            $(obj).parent().parent().find("#showContent").css("display", "none");
            $(obj).parent().parent().find("#showContent1").css("display", "block");
        }
        function removeCallType(obj) {

            $(obj).parent().parent().find("#showContent1").css("display", "none");
            $(obj).parent().parent().find("#showContent").css("display", "block");
        }
        function removeCallDir(obj) {

            $(obj).parent().parent().find("#showContent3").css("display", "none");
            $(obj).parent().parent().find("#showContent2").css("display", "block");

        }
        function updateCallType2(obj) {

            $(obj).parent().parent().find("#showContent3").css("display", "block");
            $(obj).parent().parent().find("#showContent2").css("display", "none");

        }
        function updateDirections(obj) {

            var direction = $(obj).parent().find("#direction:checked").val();


            var x = "";
            if (direction == "incoming") {
                x = "واردة";
            }
            if (direction == "out_call") {
                x = "صادرة";
            }

            var issueId = $(obj).parent().parent().parent().find("#issueId").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=updateCallDirection",
                data: {
                    direction: direction,
                    issueId: issueId
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $(obj).parent().parent().find("#showContent2").css("display", "block");
                        $(obj).parent().parent().find("#showContent3").css("display", "none");

                        $(obj).parent().parent().find("#callType").html(x);
                    }
                    if (info.status == 'no') {
                        $(obj).parent().parent().find("#showContent2").css("display", "none");
                        $(obj).parent().parent().find("#showContent3").css("display", "block");
                        alert("وقع خطأ فى التحديث");
                    }
                    if (info.status == 'noChoose') {
                        $(obj).parent().parent().find("#showContent2").css("display", "none");
                        $(obj).parent().parent().find("#showContent3").css("display", "block");
                        alert("إختر اولا ثم قم بالتعديل");
                    }

                }
            });



        }
        function updateType(obj) {
            //            var x= $(obj).parent().find("#note").val();
            //            alert(x.length)
            //            if(x.length>0){

            var callType = $(obj).parent().find("#note:checked").val();
            var issueId = $(obj).parent().parent().parent().find("#issueId").val();
            $.ajax({
                type: "post",
                url: "<%=context%>/IssueServlet?op=updateCallType",
                data: {
                    callType: callType,
                    issueId: issueId
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $(obj).parent().parent().find("#showContent").css("display", "block");
                        $(obj).parent().parent().find("#showContent1").css("display", "none");

                        $(obj).parent().parent().find("#callType").html(callType);
                    }
                    if (info.status == 'no') {
                        $(obj).parent().parent().find("#showContent").css("display", "none");
                        $(obj).parent().parent().find("#showContent1").css("display", "block");
                        alert("وقع خطأ فى التحديث");
                    }
                    if (info.status == 'noChoose') {
                        $(obj).parent().parent().find("#showContent2").css("display", "none");
                        $(obj).parent().parent().find("#showContent3").css("display", "block");
                        alert("إختر اولا ثم قم بالتعديل");
                    }
                }
            });
            //            }else{alert("قم بالإختيار للتعديل")}


        }

        function viewDocuments(issueId) {
            var url = '<%=context%>/IssueDocServlet?op=ListAttachedDocs&issueId=' + issueId + '';
            var wind = window.open(url, "عرض المستندات", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
            wind.focus();
        }

        function viewImages(issueId) {
            var url = '<%=context%>/IssueDocServlet?op=ViewIssueImages&issueId=' + issueId + '';
            var wind = window.open(url, "عرض الصور", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
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
            <DIV align="<%=align%>" style="padding:<%=align%>; ">
            </DIV><br />
            <form name="within_form2">
                <b style="font-size: medium;">عرض منذ :</b>
                <SELECT name="withinCallDepartment" STYLE="width:125px; font-size: medium; font-weight: bold;" onchange="JavaScript: submitformCalls();">
                    <OPTION value="1" <%=withinCallDepartment == 1 ? "selected" : ""%>>ساعة</OPTION>
                    <OPTION value="2" <%=withinCallDepartment == 2 ? "selected" : ""%>>ساعتان</OPTION>
                    <OPTION value="3" <%=withinCallDepartment == 3 ? "selected" : ""%>>3 ساعات</OPTION>
                    <OPTION value="24" <%=withinCallDepartment == 24 ? "selected" : ""%>>يوم</OPTION>
                    <OPTION value="48" <%=withinCallDepartment == 48 ? "selected" : ""%>>يومان</OPTION>
                    <OPTION value="72" <%=withinCallDepartment == 72 ? "selected" : ""%>>3 أيام</OPTION>
                    <OPTION value="168" <%=withinCallDepartment == 168 ? "selected" : ""%>>أسبوع</OPTION>
                    <OPTION value="1000" <%=withinCallDepartment == 1000 ? "selected" : ""%>>غير محدد</OPTION>
                </SELECT>
            </form>

            <div style="width:70%;margin-right: auto;margin-left: auto;">
                <TABLE class="blueBorder"  id="calls" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none;">
                    <thead>
                        <TR>
                            <TH  style="font-size: 13px;" ><SPAN ><img src="images/icons/Numbers.png" width="20" height="20" /><b> رقم الإتصال</b></SPAN></TH>
                            <TH  style="font-size: 13px;" ><b>عدد الطلبات/الإنصال</b></TH>
                            <TH  style="font-size: 13px;" ><b>نوع الإتصال</b></TH>
                            <TH  style="font-size: 13px;" ><b>إتجاة الإتصال </b></TH>
                            <TH style="font-size: 13px;"  ><b>تاريخ المكالمة</b></TH>
                            <TH  style="font-size: 13px;" ><b>رقم العميل</b></TH>
                            <TH style="font-size: 13px;"  ><SPAN><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></SPAN></TH>
                        </TR>
                    </thead>
                    <tbody>  
                        <% for (WebBusinessObject wbo : issuesVector) { %>
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
                                <% } else { %>
                                <a href="<%=context%>/IssueServlet?op=getCompUnderIssue&issueId=<%=wbo.getAttribute("issueId")%>" style="color: blue">
                                    <%=wbo.getAttribute("busId")%>
                                </a> 
                                <% } %>
                                <input type="hidden" id="issueId" value="<%=wbo.getAttribute("issueId")%>" />
                            </TD>
                            <TD style="width: 10%;">
                                <% if (wbo.getAttribute("numOfOrders").equals("empty")) { %>
                                <LABEL style="color: #27272A">0</LABEL>
                                <% } else { %>
                                <LABEL style="color: #27272A"><%=wbo.getAttribute("numOfOrders")%></LABEL>
                                <% } %>

                            </TD>
                            <TD >
                                <div id="showContent" style="display: block">
                                    <b id="callType" onclick="updateCallType(this)" style="cursor: pointer" onMouseOver="Tip('تعديل', LEFT, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')" onMouseOut="UnTip()"><%=wbo.getAttribute("issueDesc")%></b>
                                </div>
                                <div id="showContent1" style="display: none">
                                    <input  name="note" type="radio" value="مكالمة"  id="note" />
                                    <label>مكالمة</label>
                                    <input name="note" type="radio" value="مقابلة" id="note" style="margin-right: 10px;"/>
                                    <label>مقابلة</label>
                                    <div class="save__" onclick="updateType(this)"></div>
                                    <div class="remove__" onclick="removeCallType(this)"></div>
                                </div>
                            </TD>
                            <TD >
                                <% 
                                String callType = "";
                                if (wbo.getAttribute("callType").equals("incoming")) {
                                        callType = "واردة";
                                } else if (wbo.getAttribute("callType").equals("out_call")) {
                                    callType = "صادرة";
                                } else if (wbo.getAttribute("callType").equals("") || wbo.getAttribute("callType").equals("null")) {
                                    callType = "";
                                }
                                %>
                                <div id="showContent2">
                                    <b id="callType" onclick="updateCallType2(this)" style="cursor: pointer"
                                       onMouseOver="Tip('تعديل', LEFT, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')" onMouseOut="UnTip()"><%=callType%></b>
                                </div>
                                <div id="showContent3"  style="display: none">
                                    <input  name="direction" type="radio" value="incoming"  id="direction" />
                                    <label>واردة</label>
                                    <input name="direction" type="radio" value="out_call" id="direction" style="margin-right: 10px;"/>
                                    <label>صادرة</label>
                                    <div class="save__" onclick="updateDirections(this)"></div>
                                    <div class="remove__" onclick="removeCallDir(this)"></div>
                                </div>
                            </TD>
                            <%
                                WebBusinessObject formattedTime = DateAndTimeControl.getFormattedDateTime((String) wbo.getAttribute("creationTime"), stat);
                            %>
                            <TD nowrap  ><font color="red"><%=formattedTime.getAttribute("day")%> - </font><b><%=formattedTime.getAttribute("time")%></b></TD>
                            <TD ><%=wbo.getAttribute("clientNo")%></TD>
                            <TD ><b><%=wbo.getAttribute("clientName")%></b></TD>
                        </TR>
                        <% }%>
                    </tbody>
                </TABLE>
            </div>
            <input type="hidden" name="projectName" id="projectName" value="All">
            <input type="hidden" name="statusName" id="statusName" value="Schedule">
            <BR>
        </FIELDSET>
    </CENTER>
</BODY>
</HTML>