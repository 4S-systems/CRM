<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.silkworm.common.UserMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    int iTotal = 0;
    ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    String compStatusVal = (String) request.getAttribute("compStatus");
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
    UserMgr userMgr = UserMgr.getInstance();

    ArrayList<WebBusinessObject> statusTypes = (ArrayList<WebBusinessObject>) request.getAttribute("statusTypes");
    String stat = "Ar";

    stat = (String) request.getSession().getAttribute("currentMode");

    String sat, sun, mon, tue, wed, thu, fri, responsible,excel;
    String complStatus = null;
    if (stat.equals("En")) {
        sat = "Sat";
        sun = "Sun";
        mon = "Mon";
        tue = "Tue";
        wed = "Wed";
        thu = "Thu";
        fri = "Fri";
        responsible = "Responsible ";
        excel = "Excel";
    } else {
        sat = "السبت";
        sun = "الاحد";
        mon = "الاثنين";
        tue = "الثلاثاء";
        wed = "الاربعاء";
        thu = "الخميس";
        fri = "الجمعة";
        responsible = "Responsible ";
        excel = "اكسل";
    }
    String sDate, sTime = null;
%>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Main.Main"  />
    <head>
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
        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });

            function getComplaints() {
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                if ((beginDate === null || beginDate === "")) {
                    alert("من فضلك أدخل تاريخ البداية");
                }
                else if ((endDate === null || endDate === "")) {
                    alert("من فضلك أدخل تاريخ النهاية");

                } else {
                    beginDate = $("#beginDate").val();
                    endDate = $("#endDate").val();
                    var compStatus = $("#compStatus").val();
                    document.COMP_FORM.action = "<%=context%>/SearchServlet?op=searchForMyActivity&beginDate=" + beginDate + "&endDate=" + endDate + "&compStatus=" + compStatus;
    document.COMP_FORM.submit();
                }
            }
            
            function getComplaintsExcel() {
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                var excel = $("#excel").val();
                if ((beginDate === null || beginDate === "")) {
                    alert("من فضلك أدخل تاريخ البداية");
                }
                else if ((endDate === null || endDate === "")) {
                    alert("من فضلك أدخل تاريخ النهاية");

                } else {
                    beginDate = $("#beginDate").val();
                    endDate = $("#endDate").val();
                    var compStatus = $("#compStatus").val();
                    document.COMP_FORM.action = "<%=context%>/SearchServlet?op=searchForMyActivity&beginDate=" + beginDate + "&endDate=" + endDate + "&compStatus=" + compStatus + "&excel=" + excel;
    document.COMP_FORM.submit();
                }
            }

            function assignClientComplaintToProject() {
                var projectId = $("#toFolder").val();
                var clientComplaintIds = $("#moveTo:checked").map(function () {
                    return $(this).val();
                }).get();
                if (clientComplaintIds === '') {
                    $('#saveToFileMsg').html('Please select at least one request.');
                    return;
                }
                $.ajax({
                    type: 'POST',
                    url: "<%=context%>/ProjectServlet?op=addClientComplaintIntoProject",
                    data: {clientComplaintIds: clientComplaintIds.join(","), projectId: projectId},
                    success: function (data) {
                        var jsonString = $.parseJSON(data);
                        if (jsonString.status === 'ok') {
                            $('#saveToFileMsg').html('Save To Folder Done');
                        } else if (jsonString.status === 'failed') {
                            $('#saveToFileMsg').html('Problem at Saving To Folder , Please Contact Administrator');
                        }
                    }
                });
            }

            $(document).ready(function () {
                $('#indextable').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[20, 40, 70, 100, -1], [20, 40, 70, 100, "All"]],
                    iDisplayLength: 20,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[10, "asc"]]
                }).show();
                $(".dataTables_length, .dataTables_info").css("float", "left");
                $(".dataTables_filter, .dataTables_paginate").css("float", "right");
            });

            var divAttachmentTag;
            function openAttachmentDialog(issueId, objectType) {
                loading("block");
                divAttachmentTag = $("div[name='divAttachmentTag']");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/FileUploadServlet?op=getUploadDialog',
                    data: {
                        businessObjectId: issueId,
                        objectType: objectType
                    },
                    success: function (data) {
                        divAttachmentTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "ارفاق مستندات",
                                    show: "fade",
                                    hide: "explode",
                                    width: 800,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Cancel: function () {
                                            divAttachmentTag.dialog('close');
                                        },
                                        Done: function () {
                                            divAttachmentTag.dialog('close');
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function (data) {
                        alert(data);
                    }
                });
                loading("none");
            }

            function loading(val) {
                if (val === "none") {
                    $('#loading').fadeOut(2000, function () {
                        $('#loading').css("display", val);
                    });
                } else {
                    $('#loading').fadeIn("fast", function () {
                        $('#loading').css("display", val);
                    });
                }
            }

            function viewDocuments(issueId) {
                var url = '<%=context%>/IssueDocServlet?op=ListAttachedDocs&issueId=' + issueId + '';
                var wind = window.open(url, "عرض المستندات", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                wind.focus();
            }

            var divCommentsTag;
            function openCommentsDialog(complaintId) {
                loading("block");
                divCommentsTag = $("div[name='divCommentsTag']");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/CommentsServlet?op=showCommentsPopup',
                    data: {
                        clientComplaintId: complaintId
                    },
                    success: function (data) {
                        divCommentsTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "عرض التعليقات",
                                    show: "fade",
                                    hide: "explode",
                                    width: 1000,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Cancel: function () {
                                            divCommentsTag.dialog('close');
                                        },
                                        Done: function () {
                                            divCommentsTag.dialog('close');
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function (data) {
                        alert('Data Error = ' + data);
                    }
                });
                loading("none");
            }
            function getRequestsCount(issueId, obj) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/IssueServlet?op=getRequestsCountAjax",
                    data: {
                        issueId: issueId
                    }
                    ,
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        $(obj).attr("title", "عدد المعتمدات: " + info.count);
                    }
                });
            }
        </script>
    </head>
    <body>
        <div name="divAttachmentTag"></div>
        <div name="divCommentsTag"></div>
        <form name="COMP_FORM" method="POST">
            <table align="center" width="80%">
                <tr>
                    <td class="td">
                        <fieldset class="set" style="width:85%;border-color: #006699; margin-left:auto; margin-right:auto;">
                            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <tr>
                                    <td width="100%" class="titlebar">
                                        <font color="#005599" size="4"><fmt:message key="searchmywork" /></font>
                                    </td>
                                </tr>
                            </table>
                            <br/>

                            <table ALIGN="center" DIR="RTL" width="570" cellspacing="2" cellpadding="1">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                                        <b><font size=3 color="white"> 
                                            <fmt:message key="fromdate" />
                                        </b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"width="50%">
                                        <b> <font size=3 color="white"> <fmt:message key="todate" /> </b>
                                    </td>
                                </tr>

                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede" valign="middle" >
                                        <%
                                            Calendar c = Calendar.getInstance();
                                        %>
                                        <% if (beDate != null && !beDate.isEmpty()) {%>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=beDate%>" /><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=prev%>" ><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>

                                    <td  bgcolor="#dedede" style="text-align:center" valign="middle">
                                        <% if (eDate != null && !eDate.isEmpty()) {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=eDate%>" ><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                                        <b><font size=3 color="white"><fmt:message key="status" /></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <select style="font-size: 14px;font-weight: bold; width: 170px;"id="compStatus" >
                                            <sw:WBOOptionList wboList='<%=statusTypes%>' displayAttribute = "enDesc" valueAttribute="id" scrollToValue="<%=compStatusVal%>"/>
                                        </select>
                                    </td>
                                </tr>

                                <tr>
                                    <td style="text-align:center" class="td" colspan="2">
                                        <button onclick="JavaScript: getComplaintsExcel();" id="excel" value="excel" style="color: #000;font-size:15px;margin-top: 20px;font-weight:bold; "><%=excel%><IMG HEIGHT="15" SRC="images/excelIcon.png" ></button>  
                                        <button onclick="JavaScript: getComplaints();" style="color: #000;font-size:15px;margin-top: 20px;font-weight:bold; "><fmt:message key="search" /><IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </td>
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
            <br/>
            <table class="blueBorder" id="indextable" align="center" DIR=<fmt:message key="direction" /> width="100%" cellpadding="0" cellspacing="0" style="display: none; text-align: center">
                <thead>
                    <tr>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><b>#</b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><input type="checkbox" id="ToggleTo" name="ToggleTo"></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="15%" colspan="3"><img src="images/icons/operation.png" width="24" height="24"/></th>  
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><img src="images/icons/Numbers.png" width="20" height="20" /><b><fmt:message key="followno" />   </b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%" rowspan="2"><img src="images/icons/client.png" width="20" height="20" /><b><fmt:message key="clientname" />  </b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%" rowspan="2"><img src="images/icons/list_.png" width="20" height="20" /><b><fmt:message key="request" />  </b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><img src="images/icons/key.png" width="20" height="20" /><b> <fmt:message key="recode" /> </b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%" rowspan="2"><b><fmt:message key="source" /> </b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><b> <%=responsible%>  </b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><b><fmt:message key="status" /> </b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%" rowspan="2"><b> <fmt:message key="date" />  </b></th>
                    </tr>

                    <tr>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</th>
                        <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="2.5%">&ensp;</th>
                    </tr>
                </thead>

                <tbody  id="planetData2">
                    <%
                        String compStyle = "";
                        for (WebBusinessObject wbo : data) {
                            iTotal++;
                            WebBusinessObject senderInf = null;

                            senderInf = userMgr.getOnSingleKey(wbo.getAttribute("senderId").toString());
                            WebBusinessObject clientCompWbo = null;
                            String compType = "";
                            ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            clientCompWbo = clientComplaintsMgr.getOnSingleKey(wbo.getAttribute("clientComId").toString());
                            if (clientCompWbo.getAttribute("ticketType").toString().equals("1")) {
                                compType = "شكوى";
                                compStyle = "comp";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("2")) {
                                compType = "طلب";
                                compStyle = "order";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("3")) {
                                compType = "استعلام";
                                compStyle = "query";
                            }
                    %>
                    <tr style="padding: 1px;">
                        <td>
                            <%=iTotal%>
                        </td>
                        <td>
                            <input type="checkbox" id="moveTo" name="moveTo" value="<%=wbo.getAttribute("clientComId")%>">
                        </td>
                        <td width="2.5%">
                            <a href="JavaScript: openAttachmentDialog('<%=wbo.getAttribute("issue_id")%>', '<%=CRMConstants.OBJECT_TYPE_ISSUE%>');">
                                <img style="margin: 3px" src="images/icons/attachment.png" width="24" height="24"/>
                            </a>
                        </td>
                        <td width="2.5%">
                            <a href="JavaScript: viewDocuments('<%=wbo.getAttribute("issue_id")%>')"
                               onmouseover="JavaScript: getDocumentCount(this, '<%=wbo.getAttribute("issue_id")%>')">
                                <img style="margin: 3px" src="images/Foldericon.png" width="24" height="24"/>
                            </a>
                        </td>
                        <td width="2.5%">
                            <a href="JavaScript: openCommentsDialog('<%=wbo.getAttribute("clientComId")%>');">
                                <img style="margin: 3px" src="images/icons/accept-with-note.png" width="24" height="24"/>
                            </a>
                        </td>
                        <td  style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                            <%if (wbo.getAttribute("issue_id") != null) {%>
                            <a target="_SELF" href="<%=context%>/ClientServlet?op=clientDetails&amp;clientId=<%=wbo.getAttribute("sysID")%>">
                                <img class="icon" src="images/client_details.jpg" width="23" height="23" style="float: left;" />
                            </a>

                            <%}%>
                        </td>
                        <td>
                            <%if (wbo.getAttribute("customerName") != null) {%><b><%=wbo.getAttribute("customerName")%></b><%}%>
                        </td>
                        <td >
                            <b>
                                <% String sCompl = " ";
                                    if (wbo.getAttribute("compSubject") != null && !wbo.getAttribute("compSubject").equals("")) {
                                        sCompl = (String) wbo.getAttribute("compSubject");
                                        if (sCompl.length() > 10) {
                                %>
                                <%=sCompl%>
                                <%
                                } else {
                                %>
                                <%=sCompl%>
                                <%
                                    }
                                } else {
                                %>
                                <%=sCompl%>
                                <%
                                    }
                                %>
                            </b>
                        </td>
                        <td ><b><%=wbo.getAttribute("businessCompId")%></b></td>
                        <td>
                            <%if (wbo.getAttribute("createdByName") != null) {%><b><%=wbo.getAttribute("createdByName")%></b><%}%>
                        </td>
                        <td>
                            <%if (wbo.getAttribute("CURRENT_OWNER") != null) {%><b><%=wbo.getAttribute("CURRENT_OWNER")%></b><%}%>
                        </td>

                        <% if (stat.equals("En")) {
                                complStatus = (String) wbo.getAttribute("userStatusEn");
                            } else {
                                complStatus = (String) wbo.getAttribute("userStatusAR");
                            }
                        %>
                        <td><b><%=complStatus%></b></td>

                        <%  c = Calendar.getInstance();
                            DateFormat formatter;
                            formatter = new SimpleDateFormat("dd/MM/yyyy");
                            String[] arrDate = wbo.getAttribute("beginDate").toString().split(" ");
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
                        <td nowrap>
                            <%
                                if (currentDate.equals(sDate)) {
                            %>
                            <font color="red">Today - </font><b><%=sTime%></b>
                                <%
                                } else {
                                %>
                            <font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b>
                                <%
                                    }
                                %>
                        </td>
                    </tr>
                    <%}%>
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