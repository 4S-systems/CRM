<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    ClientMgr clientMgr = ClientMgr.getInstance();
    String count;
    count = clientMgr.getCounter();
%>
<HTML> 
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.employee_agenda.employee_agenda"  />
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>
        <script type="text/javascript">
            $(function() {
                
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: "+d",
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });

            $("#closedEndDate").datetimepicker({
                changeMonth: true,
                changeYear: true,
                minDate: "+d",
                maxDate: 0,
                dateFormat: "yy/mm/dd",
                timeFormat: "hh:mm:ss"
            });

            var minDateFilter;
            var maxDateFilter;
            var time;
            var users = new Array();
            $(document).ready(function() {
                $("#tblData").css("display", "none");
                var oTable = $('#incomingCCMsg').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).show();
                $("#min").keyup(function() {
                    oTable.fnDraw();
                });
                $("#min").change(function() {
                    oTable.fnDraw();
                });
                $("#max").keyup(function() {
                    oTable.fnDraw();
                });
                $("#max").change(function() {
                    oTable.fnDraw();
                });

            });

            function removeInMsg() {
                var selectedMsg = $("#incomingCCMsg").find(":checkbox:checked");
                var rowCount = $('#incomingCCMsg tr').length - 2;
                //                if (selectedMsg.length > 0 & rowCount > 0) {
                var ids = "";
                $(selectedMsg).each(function(index, obj) {

                    //                    alert(index)
                    ;
                    var id = $(obj).val();

                    ids = ids + id + ",";

                })
                //                alert(ids)
                //                    }
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ComplaintEmployeeServlet?op=removeSelectedComp",
                    data: {
                        selectedId: ids
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'ok') {
                            //                            alert("done");
                            //                                $(selectedMsg).parent().parent().remove();
                            $(selectedMsg).parent().parent().parent().each(function(index, obj) {
                                var pos = oTable.fnGetPosition(obj);
                                oTable.fnDeleteRow(pos);
                            })
                        }
                    }
                });
            }
            //                else {
            //                    alert("لاتوجد بيانات للتعامل معها");
            //                }

            //            }
            //          
            //          
            //          
            //          
            //          
            //          
            //          
            //          
            //            $("#tblData").keypress(function(e) {
            //                if (e.keyCode == 27) {
            ////                    $("#tblData").fadeOut(500);
            ////                    //or
            ////                    $("#tblData").clo
            //                    window.close();
            //                }
            //            });
            function test() {
                $("#tblData").bPopup();
                $("#tblData").css("display", "block");
            }
            function saveComplaintEmp(c, x) {
                //alert('entered ');
                //                var complaintId = $("#complaintId").val();
                //                alert("df");
                var selectedMsg = $("#incomingCCMsg").find(".case:checkbox:checked");
                var empIdArr = $('input[name=empId]');
                var empId = $(empIdArr[x - 1]).val();
                var commentsArr = $('input[name=comments]');
                var comments = $(commentsArr[x - 1]).val();
                var responsibleArr = $('select[name=responsible]');
                var clientCompId = $("#clientCompId").val();
                //                var complaintComment = $("#complaintComment").val();
                var compSubject = $("#compSubject").val();
                var selectedId = $("#ids").val();
                //                alert(selectedId);
                var responsible = $(responsibleArr[x - 1]).val();
                //alert('res= '+responsible);
                $("#save" + x).html("<img src='images/icons/spinner.gif'/>");

                $.ajax({
                    type: "post",
                    url: "<%=context%>/ComplaintEmployeeServlet?op=saveComplaintEmp",
                    data: {
                        selectedId: selectedId,
                        empId: empId,
                        comments: comments,
                        responsible: responsible,
                        clientCompId: clientCompId,
                        //                        complaintComment: complaintComment,
                        compSubject: compSubject
                    },
                    success: function(jsonString) {
                        var eqpEmpInfo = $.parseJSON(jsonString);

                        if (eqpEmpInfo.status == 'Ok') {
                            $("#save" + x).html("");
                            $("#save" + x).css("background-position", "top");
                            $("#save" + x).removeAttr("onclick");
                            $(selectedMsg).parent().parent().parent().each(function(index, obj) {
                                var pos = oTable.fnGetPosition(obj);
                                oTable.fnDeleteRow(pos);
                            }
                            )
                        }
                    }
                });

            }

            function remove(t, index) {
                //alert;

                if ($(t).parent().parent().parent().parent().attr('rows').length != 1) {
                    $(t).parent().parent().remove();
                    if ($("#empOne").val() != t.id) {
                        users[t.id] = 0;
                    }

                    var check = document.getElementsByName('order');
                    var index_ = document.getElementsByName('index');
                    //alert(check.length);
                    for (var i = 0; i < check.length; i++) {
                        //alert(i+1);
                        check[i].innerHTML = i + 1;
                        index_[i].value = i + 1;
                        //alert(index_[i].id);
                        index_[i].id = 'index' + (i + 1);
                        //alert(index_[i].id);
                        //$('#order'+index).val(i+1);
                    }

                }
                else {
                    $(t).parent().parent().parent().parent().parent().parent().remove();
                    segment[t.title] = 0;
                    var check = document.getElementsByName('order');
                    var index_ = document.getElementsByName('index');
                    //alert(check.length);
                    for (var i = 0; i < check.length; i++) {
                        //alert(i+1);
                        check[i].innerHTML = i + 1;
                        index_[i].value = i + 1;
                        //alert(index_[i].id);
                        index_[i].id = 'index' + (i + 1);
                        //alert(index_[i].id);
                        //$('#order'+index).val(i+1);
                    }

                }
            }
        </script>
        <script type="text/javascript">
            function closeAlert(obj) {

                $("#closeNote").window('close');
            }
//            $(function() {
//                var currentRow = ($("#incomingCCMsg tr").length);
//                //                alert(currentRow);
//                var current = currentRow - 2;
//                var count ='<%=count%>';
//                //                alert(current);
//                //                alert(count);
//                //                alert(x - 1);
//                if (current > count) {
//
//                    var diff = current - count;
//                    $("#comingMsg").text(diff);
//                    //                    alert("عدد الرسائل الواردة " + diff);
//                    $.ajax({
//                        type: "post",
//                        url: "<%=context%>/ClientServlet?op=updateCounter",
//                        data: {count: current},
//                        success: function(jsonString) {
//                            var info = $.parseJSON(jsonString);
//
//                            if (info.status == 'ok') {
//
//                            }
//                        }
//                    });
//                } else if (current < count) {
//
//                    var diff = count - current;
//                    $("#comingMsg").text("0");
//                    //                    alert("عدد الرسائل الواردة " + diff);
//                    $.ajax({
//                        type: "post",
//                        url: "<%=context%>/ClientServlet?op=updateCounter",
//                        data: {count: current},
//                        success: function(jsonString) {
//                            var info = $.parseJSON(jsonString);
//
//                            if (info.status == 'ok') {
//
//                            }
//                        }
//                    });
//                } else if (current == count) {
//
//
//                    $("#comingMsg").text("0");
//                }
//
//            })

            function saveCount(o) {
                var count = $(o).val();

                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getCount",
                    data: {count: count},
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'ok') {
                        }
                    }
                });

            }
            function getCount() {


                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getCounter",
                    data: {count: count},
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'ok') {

                            alert("count = " + info.count);

                        }
                    }
                });

            }
            var TableIDvalue = "incomingCCMsg";

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
        session = request.getSession();
        Vector<WebBusinessObject> issuesVector = new Vector();

        EmployeeViewMgr employeeViewMgr = EmployeeViewMgr.getInstance();
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String[] key = new String[1];
        String[] value = new String[1];
        key[0] = "key3";
        value[0] = userWbo.getAttribute("userId").toString();
        
        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Hashtable logos = new Hashtable();
        logos = parseSideMenu.getCompanyLogo("configration" + metaMgr.getCompanyName() + ".xml");
        String weeksNo = logos.get("weeksNo").toString();
        Calendar weekCalendar = Calendar.getInstance();
        Calendar beginWeekCalendar = Calendar.getInstance();
        Calendar endWeekCalendar = Calendar.getInstance();
        
        int dayOfBack = new Integer(weeksNo).intValue() * 7;
        
        String beginDate = null;
        String endDate = null;
        
        int dayOfWeekValue = weekCalendar.getTime().getDay();
        Calendar beginSecondWeekCalendar = Calendar.getInstance();
        Calendar endSecondWeekCalendar = Calendar.getInstance();
        beginSecondWeekCalendar = (Calendar) weekCalendar.clone();
        endSecondWeekCalendar = (Calendar) weekCalendar.clone();
        
        beginSecondWeekCalendar.add(beginWeekCalendar.DATE, -dayOfWeekValue - dayOfBack);
        endSecondWeekCalendar.add(endWeekCalendar.DATE, -dayOfWeekValue);
        
        java.sql.Date beginSecondInterval = new java.sql.Date(beginSecondWeekCalendar.getTimeInMillis());
        java.sql.Date endSecondInterval = new java.sql.Date(endSecondWeekCalendar.getTimeInMillis());
        
        DateFormat sqlDateParser = new SimpleDateFormat("yyyy/MM/dd");
        beginDate = sqlDateParser.format(beginSecondInterval);
        endDate = sqlDateParser.format(endSecondInterval);

        String resp = "2";
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        int withinCC = 24;
        Map<String, String> withinIntervals = securityUser.getWithinIntervals();
        if (request.getParameter("withinCC") != null) {
            withinCC = new Integer(request.getParameter("withinCC"));
            withinIntervals.put("withinCC", "" + withinCC);
        } else if (withinIntervals.containsKey("withinCC")) {
            withinCC = (new Integer(withinIntervals.get("withinCC")));
        }
        
        Calendar cal = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        String nowTime = sdf.format(cal.getTime());
        String toDateVal = nowTime;
        if(request.getParameter("toDate") != null) {
            toDateVal = request.getParameter("toDate");
            withinIntervals.put("toDate", "" + toDateVal);
        } else if (withinIntervals.containsKey("toDate")) {
            toDateVal = withinIntervals.get("toDate");
        }
        cal.add(Calendar.DAY_OF_MONTH, -1);
        nowTime = sdf.format(cal.getTime());
        String fromDateVal = nowTime;
        if(request.getParameter("fromDate") != null) {
            fromDateVal = request.getParameter("fromDate");
            withinIntervals.put("fromDate", "" + fromDateVal);
        } else if (withinIntervals.containsKey("fromDate")) {
            fromDateVal = withinIntervals.get("fromDate");
        }
        
        issuesVector = employeeViewMgr.getComplaintsWithoutDate(1, value, key, "key7", resp, withinCC,  new java.sql.Date(sdf.parse(fromDateVal).getTime()), new java.sql.Date(sdf.parse(toDateVal).getTime()));
        
        String stat = (String) request.getSession().getAttribute("currentMode");
        
        String  type, noResponse, ageComp;
        String complStatus, senderName = null;
        String codeStr, projectStr, distanceStr, deleteStr, responsibleStr, save;
        if (stat.equals("En")) {
           save = "Save";
             type = "Type";
              noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "A.C(day)";
            codeStr = "Code";
            projectStr = "Employee name";
            distanceStr = "Notes";
            deleteStr = "Delete";
            responsibleStr = "Responsibility";
        } else {
            save = "&#1578;&#1587;&#1580;&#1610;&#1604;";
               type = "النوع";
              noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
            ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
            codeStr = "&#1575;&#1604;&#1603;&#1608;&#1583;";
            projectStr = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;";
            distanceStr = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
            deleteStr = "&#1581;&#1584;&#1601;";
            responsibleStr = "&#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;";
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
        function cancelComp() {
            var selectedProductArr = $('#incomingCCMsg').find(':checkbox:checked');
            var x = "";
            var compId;
            $(selectedProductArr).each(function(index, complaint) {
                //                productId = $(product).val();
                compId = $(complaint).parent().find('#compId').val();
                x = x + compId + ",";
            });
            $.ajax({
                type: "post",
                url: "<%=context%>/ComplaintEmployeeServlet?op=cancelComp",
                data: {
                    selectedId: x
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $(selectedProductArr).parent().parent().parent().remove();
                    }
                }
            });
        }

        function close_comp(obj) {
            var selectedMsg = "";
            var note = "";
            var ids = "";
            selectedMsg = $("#incomingCCMsg").find(".case:checkbox:checked");

            note = $(obj).parent().parent().parent().parent().find("#notes").val();
            var endDate = $(obj).parent().parent().parent().parent().find('#closedEndDate').val();

            if ($(selectedMsg).length > 0) {
                $(selectedMsg).each(function(index, obj) {
                    var id = $(obj).val();

                    ids = ids + id + ",/";

                });
                $("#ids").val(ids);
            } else {
                ids = $("#ids").val();
            }


            $.ajax({
                type: "post",
                //                url: "<%=context%>/ComplaintEmployeeServlet?op=closeSelectedComp",
                url: "<%=context%>/ComplaintEmployeeServlet?op=closeMultiComp",
                data: {
                    selectedId: ids,
                    note: note,
                    endDate: endDate
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {

                        $(selectedMsg).parent().parent().parent().each(function(index, obj) {
                            var pos = oTable.fnGetPosition(obj);
                            oTable.fnDeleteRow(pos);
                            //                            oTable.fnDraw(true);

                        });
                        $('#closeNote').window("close");

                        $("#actionBtn").css("display", "none");
                        $("#selectAll").removeAttr("checked");
                        $(obj).parent().parent().parent().find("#notes").val("");


                    }
                    if (info.status == 'error') {
                        $('#closeNote').window("close");

                        alert("error");
                    }
                }
            });
            return false;
        }

        function saveMultiBookmark(obj) {

            //            $("#businessCompId").val(obj);
            $("#emptyNote").text("");
            $("#ids").val('');

            $('#bookmark').window('open');

            var selectedMsg = "";
            var note = $(obj).parent().parent().parent().parent().find("#notes").val();
            var ids = "";
            selectedMsg = $("#incomingCCMsg").find(".case:checkbox:checked");

            if ($(selectedMsg).length > 0) {
                $(selectedMsg).each(function(index, obj) {
                    var id = $(obj).val();

                    var x = id.split(',');

                    $(obj).parent().attr("id", "bookmarkDiv");
                    ids = ids + x[0] + ",";

                });


                $.ajax({
                    type: "post",
                    //                url: "<%=context%>/ComplaintEmployeeServlet?op=closeSelectedComp",
                    url: "<%=context%>/IssueServlet?op=multiBookmark",
                    data: {
                        selectedId: ids,
                        note: note,
                        endDate: endDate
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);

                        if (info.status == 'ok') {

                            $(selectedMsg).parent().parent().parent().each(function(index, obj) {

                                $("#bookmarkDiv").find("#bookmarkImg").attr("class", "tt");
                                $("#bookmarkDiv").find(".tt").attr("src", "images/icons/bookmark_selected.png");
                                //                                $("#bookmarkDiv").find("#bookmarkImg").removeAttr("onclick");
                                $("#bookmarkDiv").find("#bookmarkImg").attr("onclick", "deleteBookmark(" + info.bookmarkId + ",this)");
                                //                         $("#bookmarkDiv").find("#bookmarkImg").attr("onclick","deleteBookmark()");
                                $("#bookmarkDiv").find(".tt").attr("onmouseover", "Tip('" + note + "', CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99', FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT, 'BOLD', TITLEALIGN, 'center', TITLEFONTCOLOR, 'black', TITLEBGCOLOR, '#6699FF')");
                                $("#bookmarkDiv").find(".tt").attr("onMouseOut", "UnTip()");
                                $("#incomingCCMsg").find(".case:checkbox:checked").attr("checked", false);
                                $("#bookmarkDiv").attr("id", "");
                                $("#notes").val("");
                                $("#businessCompId").val();
                            });

                            $('#bookmark').window('close');


                        }
                        if (info.status == 'error') {
                            $('#closeNote').window("close");

                            alert("error");
                        }
                    }
                });
            } else {
                alert("please select only one");
            }
            return false;
        }
        function redirect() {

            $("#ids").val();
            var ids = "";
            var selectedMsg = "";
            selectedMsg = $("#incomingCCMsg").find(".case:checkbox:checked");

            $(selectedMsg).each(function(index, obj) {
                var id = $(obj).val();
   ids = ids + id + ",/";

            });
          
            $("#ids").val(ids);

            return getDataInPopup('ComplaintEmployeeServlet?op=getEmpByGroup2&formName=CLIENT_COMPLAINT_FORM&selectionType=multi&complaintId=' + $('#complaintId').val())
        }
        function closeComplaint(obj) {
            $("#ids").val(obj);
        }
        function redirectOnly(obj) {

            $("#ids").val(obj);


            return getDataInPopup('ComplaintEmployeeServlet?op=getEmpByGroup2&formName=CLIENT_COMPLAINT_FORM&selectionType=multi&complaintId=' + $('#complaintId').val())
        }
          function popupCloseO(obj) {
            if ($(".case:checked").length > 0) {
                $('#closeNote').bPopup();
                $('#closeNote').css("display", "block");
            } else {
                alert("select first!");
            }
        }
        $("#selectAll").click(function() {
            $(".case").attr("checked", this.checked)
            if ($(".case").attr("checked")) {
                $("#actionBtn").css("display", "block");
                //                $("#actionBtn").toggle(1000);

            } else {

                $("#actionBtn").css("display", "none");
            }
        });
      
    </SCRIPT>
    <script type="text/javascript">


        function menuHandler(item) {

            if (item.name == "new") {
                var url = "<%=context%>/IssueServlet?op=getCompl&issueId=" + $("#ISSUEID").val() + "&compId=" + $("#COMPID").val() + "&statusCode=" + "" + "&receipId=" + $("#RECID").val() + "&senderID=" + $("#SENDERID").val();
                window.location = url;
            }
            if (item.name == "save") {

                var url = "<%=context%>/IssueServlet?op=getCompl&issueId=" + $("#ISSUEID").val() + "&compId=" + $("#COMPID").val() + "&statusCode=" + "" + "&receipId=" + $("#RECID").val() + "&senderID=" + $("#SENDERID").val();
                window.location = url;
            }

            if (item.name == "selectAll") {

                $("#incomingCCMsg tr #compId").prop("checked", true);
                if ($("#incomingCCMsg tr #compId").prop("checked") == true) {
                    $("#unselect").css("display", "block");
                }

                var checked = $("#incomingCCMsg").find('.case:checkbox:checked');
                if ($(checked).length > 1) {
                    $("#completeRemove").css("display", "block");
                    $("#completeMove").css("display", "block");
                    $("#simpleRemove").css("display", "none");
                    $("#simpleMove").css("display", "none");
                    $("#multiBookmark").css("display", "block");
                    $("#view").css("display", "none");
                    $("#multiMark").show();
                    $("#insertBookmark").hide();
                } else {
                    $("#completeRemove").css("display", "none");
                    $("#completeMove").css("display", "none");
                    $("#simpleRemove").css("display", "block");
                    $("#simpleMove").css("display", "block");
                    $("#multiBookmark").css("display", "none");
                    $("#view").css("display", "block");
                    $("#multiMark").css("display", "none");
                    $("#insertBookmark").css("display", "block");
                }

            }
            if (item.name == "unselect") {

                $("#incomingCCMsg tr #compId").prop("checked", false);
                if ($("#incomingCCMsg tr #compId").prop("checked") == false) {
                    $("#unselect").css("display", "none");
                    $("#completeRemove").css("display", "none");
                    $("#completeMove").css("display", "none");
                    $("#simpleRemove").css("display", "block");
                    $("#simpleMove").css("display", "block");
                    $("#view").css("display", "block");
                }
            }
            if (item.name == "removeSelected") {

            }
            if (item.name == "moveSelected") {
                redirect();
            }

            if (item.name == "removeFile") {

                $('#singleFile').window('open');
            }
            if (item.name == "multiMark") {

                $('#bookmark').window('open');
            }
            if (item.name == "moveFile") {
                var id = $("#COMPID").val() + "," + $("#ISSUEID").val() + ",/"
                redirectOnly(id);
                //                    $('#moveFile').window('open');
                //                    $("#mainProjectName").val("");
            }
            if (item.name == "closeComplaint") {
                var id = $("#COMPID").val() + "," + $("#ISSUEID").val() + ",/"
                //                    closeComplaint(id);
                $("#ids").val(id);
                $('#closeNote').window('open');
                //                    $('#moveFile').window('open');
                //                    $("#mainProjectName").val("");
            }
            if (item.name == "mark") {
                var id = $("#COMPID").val();
                mark(id, this);

            }

            if (item.name == "closeMultiComplaint") {

                $("#ids").val("");
                $('#closeNote').window('open');
                //                    $('#moveFile').window('open');
                //                    $("#mainProjectName").val("");
            }
            if (item.name == "removeAllSelected") {
                $("#incomingCCMsg tr #check").prop("checked", true);
                $('#w').window('open');


            }

        }
        $(function() {

            $("#incomingCCMsg tr").mouseup(function() {
                $("#incomingCCMsg tr").css("background-color", "");
            })
            $("#incomingCCMsg tr").bind('contextmenu', function(e) {
                e.preventDefault();

                if ($("#incomingCCMsg").find(':checkbox:checked').length > 1) {

                    $("#completeRemove").css("display", "block");
                    $("#completeMove").css("display", "block");
                    $("#simpleRemove").css("display", "none");
                    $("#simpleMove").css("display", "none");
                    $("#multiBookmark").css("display", "block");

                    $("#multiMark").show();
                    $("#insertBookmark").hide();


                    $("#incomingCCMsg tr").css("background-color", "");
                    $("#multiMark").show();
                    $("#insertBookmark").hide();
                    $('#menu').menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    });
                } else {

                    $("#completeRemove").css("display", "none");
                    $("#completeMove").css("display", "none");
                    $("#simpleRemove").css("display", "block");
                    $("#simpleMove").css("display", "block");
                    $("#multiBookmark").css("display", "none");
                    $("#multiMark").css("display", "none");
                    $("#insertBookmark").css("display", "block");

                    $("#multiMark").hide();
                    $("#insertBookmark").show();
                    $('#menu').menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    });
                    $("#incomingCCMsg tr").css("background-color", "");
                    $(this).css("background-color", "#005599");
                }
                $("#ISSUEID").val($(this).find("#issue_id").val());
                $("#COMPID").val($(this).find("#comp_Id").val());
                $("#RECID").val($(this).find("#receip_id").val());
                $("#SENDERID").val($(this).find("#sender_id").val());




            });
        });
        function submitformCC()
        {
            document.within_form_cc.submit();
        }
        function submitform()
        {
            document.within_form2.submit();
        }
    </script>

    <BODY>
    <CENTER>
        <FIELDSET  class="set" style="width:100%;" >
            <form name="within_form2" style="margin-left: auto; margin-right: auto;">
                <table class="blueBorder" id="code2" align="center" dir="<fmt:message key="direction"/>" width="650" cellspacing="2" cellpadding="1"
                       style="border-width:1px;border-color:white;display: block;">
                    <tr class="head">
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><fmt:message key="fromDate"/></font></b>
                        </td>
                        <td class="blueHeaderTD" style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 325px;">
                            <b><font size=3 color="white"><fmt:message key="toDate"/></font></b>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white; width: 250px;" bgcolor="#EEEEEE" valign="middle" rowspan="2">
                            <button type="submit" class="button" style="width: 170px;"><fmt:message key="search"/><img height="15" src="images/search.gif"/></button>
                            <br/>
                            <br/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" valign="middle">
                            <input class="fromToDate" id="fromDate3" name="fromDate" type="text" value="<%=fromDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                        <td style="text-align: center; font-size: 14px; border-width: 1px; border-color: white;" bgcolor="#EEEEEE" style="text-align:right" valign="middle">
                            <input class="fromToDate" id="toDate3" name="toDate" type="text" value="<%=toDateVal%>" readonly/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
            </form>
            <DIV align=<fmt:message key="align"/> style="display: inline ; width: 100%; margin-bottom: 10px;">
                <TABLE class="blueBorder" dir="rtl" style="width: 100%; padding-top: 10px; padding-bottom: 4px; padding-left: 10px; padding-right: 10px; margin-top: 15px;border: none !important;" border="0">
                    <tr style="border: none;">
                        <TD class="backgroundTable" style="border: none;background-color: transparent;text-align: <fmt:message key="align"/>;">
                            <LABEL style="font-size: 16px;color: blue;"> 
                                <fmt:message key="recently"/> : 
                            <b id="comingMsg" style="color: red;font-size: 16px;">0</b>
                            </LABEL>
                        </td>
                    </tr>
                </TABLE>
            </DIV>
            <DIV style="width: 50%;display: none;float: right;margin: 0px;" id="actionBtn">
                <div class="turn_off"onclick="popupCloseO(this);"></DIV>
                <div style="float: right;margin-top: 3px;"> <input type="button"  onclick="redirect()" class="button_redirec"></div>
                <div style="float: right;margin-top: 3px;">    <INPUT type="button" value="" onclick="removeInMsg()"class="button_remove"/></div>
            </div>
            <TABLE id="incomingCCMsg"  align="center" WIDTH="100%" CELLPADDING="0" cellspacing="0" style="display: none;">
                <thead>
                    <TR>
                        <!--TH><SPAN style=""></SPAN></TH-->
                        <TH><SPAN ><img src="images/icons/Numbers.png" width="20" height="20" /><b> <fmt:message key="requestno"/> </b></SPAN></TH>
                        <TH><SPAN><img src="images/icons/client.png" width="20" height="20" /><b> <b><fmt:message key="clientname"/></b></SPAN></TH>
                        <TH><SPAN><b><%=type%></b></SPAN></TH>
                        <TH><SPAN><img src="images/icons/list_.png" width="20" height="20" /><b> <fmt:message key="request"/></b></SPAN></TH>
                        <TH><SPAN><b><fmt:message key="source"/></b></SPAN></TH>
                        <TH><SPAN><img src="images/icons/key.png" width="20" height="20" /><b><fmt:message key="requestcode"/></b></SPAN></TH>
                        <TH><SPAN><img src="images/icons/status_.png" width="18" height="18" /><b> <fmt:message key="status"/></b></SPAN></TH>
                        <TH><SPAN><img src="images/icons/manager.png" width="18" height="18" /><b> <fmt:message key="sender"/></b></SPAN></TH>
                        <TH><img src="images/icons/Time.png" width="20" height="20" /><b> <fmt:message key="callingdate"/></b></TH>
                        <TH><b><%=ageComp%></b></TH>
                    </TR>
                </thead>
                <tbody  >  
                    <%
                        for (WebBusinessObject wbo : issuesVector) {
                            String compStyle = "";
                    %>
                    <TR id="xx">
                        <% WebBusinessObject clientCompWbo = null;
                            ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            clientCompWbo = clientComplaintsMgr.getOnSingleKey(wbo.getAttribute("clientComId").toString());
                            if (CRMConstants.CLIENT_COMPLAINT_TYPE_COMPLAINT.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "comp";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_ORDER.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "order";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_QUERY.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "query";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_EXTRACT.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "order";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "order";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_FINANCIAL.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "order";
                            } else if (CRMConstants.CLIENT_COMPLAINT_TYPE_CLIENT_VISIT.equalsIgnoreCase(clientCompWbo.getAttribute("ticketType").toString())) {
                                compStyle = "order";
                            }
                        %>
                        <!--TD style="background-color: transparent;">
                            <SPAN style="display: inline-block;height: 20px;background: transparent;"><INPUT type="checkbox" id="compId" class="case" value="<%=wbo.getAttribute("clientComId") + "," + wbo.getAttribute("issue_id")%>" name="selectedIssue"  onchange="showSubMenu(this)"/>
                                <input type="hidden" id="selectedId" value="<%=wbo.getAttribute("clientComId")%>" />
                            </SPAN>
                        </TD-->
                        <TD style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                            <a href="<%=context%>/IssueServlet?op=getCompl&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>&clientType=<%=wbo.getAttribute("age")%>" > <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font></a>
                            <input type="hidden" id="issue_id" value="<%=wbo.getAttribute("issue_id")%>" />
                            <input type="hidden" id="comp_Id" value="<%=wbo.getAttribute("clientComId")%>" />
                            <input type="hidden" id="receip_id" value="<%=wbo.getAttribute("receipId")%>" />
                            <input type="hidden" id="sender_id" value="<%=wbo.getAttribute("senderId")%>" />
                        </TD>
                        <TD><b><%=wbo.getAttribute("customerName").toString()%></b>
                            <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("customerId")%>">
                                <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"
                                     onmouseover="JavaScript: changeCommentCounts('<%=wbo.getAttribute("customerId")%>', this);"/>
                            </a>
                        </TD>
                        <TD><b><%=wbo.getAttribute("typeName")%></b></TD>
                        <TD  STYLE="text-align:center;padding: 5px; font-size: 12px;" width="20%">
                        <% String sCompl = " ";
                            if (wbo.getAttribute("compSubject") != null && !wbo.getAttribute("compSubject").equals("")) {
                                sCompl = (String) wbo.getAttribute("compSubject");
                                if (sCompl.length() > 10) {
                        %>
                        <b><%=sCompl%></b>
                                <% } else {%>
                        <b><%=sCompl%></b>
                                <% }%>
                                <% } else {%>
                        <b><%=sCompl%></b>
                        <%}
                        if(clientCompWbo.getAttribute("ticketType") != null && (((String) clientCompWbo.getAttribute("ticketType")).equals(CRMConstants.CLIENT_COMPLAINT_TYPE_REQUEST_EXTRADITION)
                                || ((String) clientCompWbo.getAttribute("ticketType")).equals(CRMConstants.CLIENT_COMPLAINT_TYPE_DELIVERY_OF_QUALITY))) {
                        %>
                            <a href="#" onclick="JavaScript: viewRequest('<%=wbo.getAttribute("issue_id")%>','<%=wbo.getAttribute("clientComId")%>');">
                                <IMG value="" onclick="" height="25px" src="images/icons/checklist-icon.png" style="margin: 0px 0; float: left;" title="مشاهدة طلب تسليم"/>
                            </a>
                        <%
                            }
                        %>
                        </TD>
                        <TD nowrap><b><%=wbo.getAttribute("senderName")%></b></TD>
                        <TD><b><%=wbo.getAttribute("businessCompId")%></b></TD>
                        <% if (stat.equals("En")) {
                                complStatus = (String) wbo.getAttribute("statusEnName");
                            } else {
                                complStatus = (String) wbo.getAttribute("statusArName");
                            }
                        %>
                        <TD><b><%=complStatus%></b></TD>
                        <% if (wbo.getAttribute("senderName") != null && !wbo.getAttribute("senderName").equals("")) {
                                senderName = (String) wbo.getAttribute("senderName");
                            } else {
                                senderName = "";
                            }
                        %>
                        <TD><b><%=senderName%></b></TD>
                        <% wbo = DateAndTimeControl.getFormattedDateTime(wbo.getAttribute("entryDate").toString(), stat); %>
                        <TD nowrap  ><font color="red"><%=wbo.getAttribute("day")%> - </font><b><%=wbo.getAttribute("time")%></b></TD>
                        <td style="border-left:0px; border-right:0px; border-bottom: 1px black; ">
                            <%
                                try {
                                    out.write(DateAndTimeControl.getDelayTime(wbo.getAttribute("entryDate").toString(), "Ar"));
                                } catch (Exception E) {
                                    out.write(noResponse);
                                }
                            %>
                        </td>
                    </TR>
                    <% } %>
                </tbody>
            </TABLE>
            <input type="hidden" name="projectName" id="projectName" value="All">
            <input type="hidden" name="statusName" id="statusName" value="Schedule">
            <BR>
        </FIELDSET>

        <TABLE id="tblData" class="blueBorder"  ALIGN="center" dir=<fmt:message key="direction"/> width="50%" cellpadding="0" cellspacing="0" style="display: none;margin:auto;">
            <TR>
                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b>#</b></TD>
                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%" ><b><%=codeStr%></b></TD>
                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="20%" id="empNameShown" value=""><b><%=projectStr%></b></TD>
                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><%=distanceStr%></b></TD>
                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="10%"><b><%=responsibleStr%></b></TD>
                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><%=save%></b></TD>
                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><%=deleteStr%></b></TD>
            </TR>
        </TABLE>
        <INPUT type="hidden" id="ids" />
        <input type="hidden" id="ISSUEID" value="" />
        <input type="hidden" id="COMPID" value="" />
        <input type="hidden" id="RECID" value="" />
        <input type="hidden" id="SENDERID" value="" />
    </CENTER>
</BODY>
</HTML>