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
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>

        <script type="text/javascript">

            $(document).ready(function() {
                $('#closed').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 40, 70, 100, -1], [20, 40, 70, 100, "All"]],
                    iDisplayLength: 20,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[10, "asc"]]



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

        session = request.getSession();
        String context = metaMgr.getContext();

        Vector<WebBusinessObject> complaints = new Vector<WebBusinessObject>();
        int since = 24;
        if (request.getParameter("since") != null) {
            since = (new Integer(request.getParameter("since").toString()));
        }
        if (request.getAttribute("complaints") != null) {
            complaints = (Vector<WebBusinessObject>) request.getAttribute("complaints");
        }

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir;
        String complaintNo, customerName, type, complaint;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            complaintNo = "Order No.";
            customerName = "Customer name";
            type = "Type";
            complaint = "Complaint";
        } else {
            align = "right";
            dir = "RTL";
            complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
            customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
            type = "النوع";
            complaint = "&#1575;&#1604;&#1591;&#1604;&#1576;";
        }
    %>


    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function submitform()
        {
            document.within_form.submit();
        }
        function printDocument()
        {
            var url = "<%=context%>/ReportsServlet?op=printEscalationReport&since=" + $("#since").val();
            openWindow(url);
        }
      
        function openWindow(url) {
            window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=400");
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
    <CENTER>
        <FIELDSET class="set" style="width:96%;" >
            <DIV align="<%=align%>" style="padding:<%=align%>; ">
            </DIV><br />
            <form name="within_form" action="ReportsServlet?op=getEscalationReport" method="post">
                <b style="font-size: medium;">عرض منذ :</b>
                <SELECT id="since" name="since" STYLE="width:125px; font-size: medium; font-weight: bold;" onchange="JavaScript: submitform();">
                    <OPTION value="1" <%=since == 1 ? "selected" : ""%>>ساعة</OPTION>
                    <OPTION value="2" <%=since == 2 ? "selected" : ""%>>ساعتان</OPTION>
                    <OPTION value="3" <%=since == 3 ? "selected" : ""%>>3 ساعات</OPTION>
                    <OPTION value="24" <%=since == 24 ? "selected" : ""%>>يوم</OPTION>
                    <OPTION value="48" <%=since == 48 ? "selected" : ""%>>يومان</OPTION>
                    <OPTION value="72" <%=since == 72 ? "selected" : ""%>>3 أيام</OPTION>
                    <OPTION value="168" <%=since == 168 ? "selected" : ""%>>أسبوع</OPTION>
                </SELECT>
            </form>
                
        <br />
        <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
            <button onclick="printDocument(); return false;" class="button">
                طباعة التقرير<img src="<%=context%>/images/pdf_icon.gif" HEIGHT="20">
            </button>
        </div>
            
            <TABLE class="blueBorder"  id="closed" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none;">
                <thead><TR>
                        <TH><SPAN>&nbsp;</SPAN></TH>
                        <TH><SPAN><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></SPAN></TH>
                        <TH><SPAN><b>نوع العميل</b></SPAN></TH>
                        <TH><SPAN><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></SPAN></TH>
                        <TH><SPAN><img src="images/icons/key.png" width="20" height="20" /><b>رقم الموبايل</b></SPAN></TH>
                        <TH><SPAN><b><%=type%></b></SPAN></TH>
                        <TH><SPAN><img src="images/icons/list_.png" width="20" height="20" /><b><%=complaint%></b></SPAN></TH>
                        <TH><b>الحالة</b></TH>
                        <TH><b>تاريخ الحالة</b></TH>
                        <TH><b>المسئول</b></TH>
                        <TH><b>المدير</b></TH>
                    </TR></thead>
                <tbody>  
                    <% for (WebBusinessObject wbo : complaints) {%>
                    <TR>
                        <TD ><b><img src="images/urgent.jpg" width="17" height="17" style="display: <%=("2").equalsIgnoreCase((String) wbo.getAttribute("urgency")) ? "block" : "none"%>;" /></b></TD>
                        <TD style="cursor: pointer" onmouseover="this.className = '<%=wbo.getAttribute("complaintStyle")%>'" onmouseout="this.className = ''">
                            <a href="<%=context%>/IssueServlet?op=getCompl3&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>&clientType=<%=wbo.getAttribute("age")%>&currentOwnerId=<%=wbo.getAttribute("currentOwnerId")%>"> <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font>
                            </a>
                            <input type="hidden" id="issue_id" value="<%=wbo.getAttribute("issue_id")%>" />
                            <input type="hidden" id="comp_Id" value="<%=wbo.getAttribute("clientComId")%>" />
                            <input type="hidden" id="receip_id" value="<%=wbo.getAttribute("receipId")%>" />
                            <input type="hidden" id="sender_id" value="<%=wbo.getAttribute("senderId")%>" />
                        </TD>
                        <TD><b><%=wbo.getAttribute("customerType")%></b></TD>
                        <TD><b><%=wbo.getAttribute("customerName")%></b></TD>
                        <TD><b><%=wbo.getAttribute("mobile")%></b></TD>
                        <TD><b><%=wbo.getAttribute("complaintType")%></b></TD>
                        <TD><b><%=wbo.getAttribute("complaintSubject")%></b></TD>
                        <TD><b><%=wbo.getAttribute("statusName")%></b></TD>
                        <TD nowrap><font color="red"><%=wbo.getAttribute("statusDay")%> - </font><b><%=wbo.getAttribute("statusTime")%></b></TD>
                        <TD><b><%=wbo.getAttribute("employeeName")%></b></TD>
                        <TD><b><%=wbo.getAttribute("managerName")%></b></TD>
                    </TR>
                    <% }%>
                </tbody>
            </TABLE>
            <BR>
        </FIELDSET>
    </CENTER>
</BODY>
</HTML>