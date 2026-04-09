<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page contentType="text/HTML; charset=UTF-8" %>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        metaMgr.setMetaData("xfile.jar");
        session = request.getSession();
        String context = metaMgr.getContext();

        ArrayList<WebBusinessObject> issuesList = (ArrayList<WebBusinessObject>) request.getAttribute("issuesList");

        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, style;
        String customerName;
        String viewDocuments, photoGallery;
        if (stat.equals("En")) {
            dir = "LTR";
            style = "text-align:left";
            customerName = "Customer Name";
            viewDocuments = "View Documents";
            photoGallery = "Photo Gallery";
        } else {
            dir = "RTL";
            style = "text-align:Right";
            customerName = "اسم العميل";
            viewDocuments = "مشاهدة المرفقات";
            photoGallery = "عرض الصور";
        }
    %>
    <head>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript">

            $(document).ready(function () {
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

        <script LANGUAGE="JavaScript" TYPE="text/javascript">
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
            function getUnitsList(clientId, obj) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getUnitsListAjax",
                    data: {
                        clientId: clientId
                    }
                    ,
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        $(obj).attr("title", "الوحدات: " + info.unitsCodes);
                    }
                });
            }
        </script>
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
    </head>
    <body>
    <center>
        <br/><br/>
        <fieldset class="set" style="width:96%;" >
            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td width="100%" class="titlebar">
                        <font color="#005599" size="4">المقاولات - قيد المتابعة </font>
                    </td>
                </tr>
            </table>
            <br/>
            <div style="width:70%;margin-right: auto;margin-left: auto;">
                <table class="blueBorder" id="calls" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0" style="display: none;">
                    <thead>
                        <tr>
                            <th style="font-size: 13px;"><img src="images/icons/Numbers.png" width="20" height="20" /><b> رقم الإتصال</b></th>
                            <th style="font-size: 13px;"><b>عدد الطلبات</b></th>
                            <th style="font-size: 13px;"><b>تاريخ الطلب</b></th>
                            <th style="font-size: 13px;"><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></th>
                        </tr>
                    </thead>
                    <tbody>  
                        <%
                            for (WebBusinessObject wbo : issuesList) {
                                String creationTime = (String) wbo.getAttribute("creationTime");
                                creationTime = creationTime != null ? creationTime.substring(0, creationTime.lastIndexOf(":")) : "";
                        %>
                        <tr>
                            <td id="link">
                                <a href='JavaScript:viewImages("<%=wbo.getAttribute("id")%>")'>
                                    <img src="images/imicon.gif" width="17" height="17" title="<%=photoGallery%>" />
                                </a>
                                <a href='JavaScript:viewDocuments("<%=wbo.getAttribute("id")%>")'>
                                    <img src="images/view.png" width="17" height="17" title="<%=viewDocuments%>" />
                                </a>
                                <a href="<%=context%>/IssueServlet?op=getCompUnderIssue&issueId=<%=wbo.getAttribute("id")%>" style="color: blue">
                                    <%=wbo.getAttribute("businessID")%>
                                </a>
                                <input type="hidden" id="issueId" value="<%=wbo.getAttribute("id")%>" />
                            </td>
                            <td style="width: 10%;">
                                <label style="color: #000">
                                    <%=wbo.getAttribute("complaintsNo")%>
                                </label>
                            </td>
                            <td nowrap><b><%=creationTime%></b></td>
                            <td><b onmouseover="JavaScript: getUnitsList('<%=wbo.getAttribute("clientId")%>', this)"><%=wbo.getAttribute("clientName")%></b></td>
                        </tr>
                        <% }%>
                    </tbody>
                </table>
            </div>
            <br/>
        </fieldset>
    </center>
</body>
</html>