<%-- 
    Document   : jobOrderTrack
    Created on : Sep 14, 2017, 10:14:27 AM
    Author     : fatma
--%>

<%@page import="com.clients.db_access.AppointmentMgr"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Vector"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    int iTotal = 0;
    
    AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
    
    
    Calendar cal = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());
    cal.add(Calendar.DAY_OF_MONTH, -3);
    String beDate = request.getAttribute("beginDate") != null ? (String) request.getAttribute("beginDate") : sdf.format(cal.getTime());
    String eDate = request.getAttribute("endDate") != null ? (String) request.getAttribute("endDate") : nowTime;
    
    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
    String usrID = (String) loggedUser.getAttribute("userId");
    
    ArrayList<WebBusinessObject> data = request.getAttribute("data") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("data") : appointmentMgr.getJobOrdersList(beDate, eDate, null, null, /* areaID, userID*/ /*usrID*/ usrID);
    
    jDateFormat = "yyyy/MM/dd HH:mm";
    
    String stat = (String) request.getSession().getAttribute("currentMode");
    String dir = null;
    String title, beginDate, endDate, search;
    String complaintNo, customerName, branch;
    String sat, sun, mon, tue, wed, thu, fri;
    String complStatus;
    String sDate, close, usr, status, ordrDate;
    if (stat.equals("En")) {
        dir = "LTR";
        title = " Job Order Tracking ";
        beginDate = " From Date ";
        endDate = " To Date ";
        complaintNo = "Order No.";
        customerName = "Customer name";
        branch = " Branch ";
        sat = "Sat";
        sun = "Sun";
        mon = "Mon";
        tue = "Tue";
        wed = "Wed";
        thu = "Thu";
        fri = "Fri";
        close = "Close";
        search = " Search ";
        usr = " Requested By ";
        status = " Status ";
        ordrDate = " Order Date ";
    } else {
        dir = "RTL";
        title = " Job Order Tracking ";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
        customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        branch = " الفرع ";
        sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
        sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
        mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
        tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
        wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
        thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
        fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
        close = "إغلاق كل الأوامر المختارة";
        search = " بحث ";
        usr = " عامل الإتصال ";
        status = " الحالة ";
        ordrDate = " تاريخ الأمر ";
    }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Job Order Track </title>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
        
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <style>
            *>*{
                vertical-align: middle;
            }
            
            #compDiv {
                width: 90%;
                margin:3px auto;
                border: 1px solid #999;
                background: #FFDAE2;
            }
        
            #tableDATA th{
                font-size: 15px;
            }
            
            .div{
                direction: rtl;
            }
            
            .save3{
                width:20px;
                height:20px;
                background-image:url(images/icons/icon-32-publish.png);
                background-repeat: no-repeat;
                background-position: bottom;
                cursor: pointer;
                background-color:transparent;
                border:none;    

            }
        </style>
        
        <script>
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd"
                });
                
                $('#indextable').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "bAutoWidth": true,
                    "aaSorting": [[0, "asc"]]
                }).fadeIn(2000);
            });
            
            function selectAll(obj) {
                $("input[name='moveTo']").prop('checked', $(obj).is(':checked'));
            }
            
            function getComplaints(){
                document.COMP_FORM.action = "<%=context%>/AppointmentServlet?op=listJobOrders&pg=3";
                document.COMP_FORM.submit();
            }
            
            function complaintPopup(compID, comPrj, issueId){
                $("#pursuanceNO").html("<img src='images/icons/spinner.gif'/>");
                var entryDate = $("#entryDate").val();
                 
                /*$.ajax({
                    type: "post",
                    url: "<%=context%>/IssueServlet?op=jobOrderComplaint",
                    data: {
                        getIssueID: "getIssueID",
                        entryDate: entryDate,
                        clientId: "1502277730347",
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'success') {
                            $("#pursuanceNO").html("");
                            $("#pursuanceNO").html('<lable id="busNumber"><font color="red" size="3">' + info.businessID + '/</font><font color="blue" size="3" >' + info.businessIDbyDate + '</font></lable>');
                            $("#nwIssueID").val(info.issueId);
                        } else {
                            $("#pursuanceNO").html("");
                            $("#pursuanceNO").html('<font color="red" size="3">Save Failed!/</font>');
                        }
                    }
                });*/
        
                $("#oldIssueID").val(issueId);
                $("#compPopup").bPopup({
                    easing: 'easeInOutSine', 
                    speed: 400,
                    transition: 'slideDown'
                });
                
                $("#compID").val(compID);
            }
            
            function validateQueryFiled2() {
                var comment = $('#complaint').val();
                var y = false;
                if (comment == "") {

                    $('#complaint').css("background-color", "#FFDAE2");
                    $('#complaint').css("placeholder", " Please, Enter Your Complaint ");
                } else {
                    y = true;
                }
                return y;
            }
            
            function saveComplaint() {
                var comment = $('#complaint').val();
                var urgency = $("input[name='orderUrgency']:checked").val();
                if (validateQueryFiled2()) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/IssueServlet?op=jobOrderComplaint",
                        data: {
                            usrID: "1506242629014",
                            comment: comment,
                            ticketType: "3",
                            clientId: <%=usrID%>,
                            urgency: urgency,
                            compID: $("#compID").val(),
                            issueID:  $("#oldIssueID").val()
                        },
                        success: function(jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status == 'Ok') {
                                alert(" Your Complaint Has Been Added ");
                                closeAttachPopup();
                                // change update icon state
                                /*$(obj).html("");
                                $(obj).css("background-position", "top");
                                $(obj).removeAttr("onclick");
                                $(obj).attr("onclick", "showMsg()");
                                $(obj).parent().parent().parent().find(".status").removeAttr("onclick");
                                $(obj).parent().parent().parent().find(".user").removeAttr("onclick");
                                $(obj).parent().parent().parent().find(".status").attr("onclick", "showMsg()");
                                $(obj).parent().parent().parent().find(".user").attr("onclick", "showMsg()");
                                $(obj).parent().parent().parent().find("#mgrBtn").removeAttr("onclick");
                                $(obj).parent().parent().parent().find("#user").removeAttr("onclick");
                                $(obj).parent().parent().parent().find("#unknownBtn").removeAttr("onclick");
                                $(obj).parent().parent().parent().find("#mgrBtn").css("background-image", "url(images/icons/notavailable.png)");*/
                            }
                        }
                    });
                } else {
                    alert(" Enter Your Complaint ");
                }
            }
    
            function closeAttachPopup() {
                $("#compPopup").bPopup().close();
            }
            var issued=$("#oldIssueID").val();
        </script>
    </head>
    <body>
        <fieldset class="set" style="width: 80%; padding-bottom: 20px;">
            <legend align="center">
                <font color="blue" size="6">
                    <%=title%>
                </font>
            </legend>
            
                <input name="entryDate" id="entryDate" type="hidden" size="50" maxlength="50" style="width: 50%; " value="<%=nowTime%>"/>
                
            <form NAME="COMP_FORM" METHOD="POST">
                <table align="center" style="direction: <%=dir%>; width: 60%;" cellspacing="2" cellpadding="1">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 37%;" width="33%">
                            <font size=3 color="white">
                                 <%=beginDate%> 
                        </td>

                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 37%; height: 100%;">
                            <font size=3 color="white">
                                 <%=endDate%> 
                        </td>


                        <td bgcolor="#F7F6F6" style="text-align:center; width: 26%; height: 100%; border: none;" valign="middle" rowspan="2">
                            <button class="button" onclick="JavaScript: getComplaints();" style="width: 50%; color: #27272A; font-size:15; font-weight:bold;">
                                 <%=search%> 
                                 <IMG HEIGHT="15" SRC="images/search.gif" > 
                            </button>  
                        </td>
                    </tr>

                    <tr>
                        <td style="text-align:center; height: 100%; padding: 10px;  border: none;" bgcolor="#F7F6F6" valign="MIDDLE" >
                             <input id="beginDate" name="beginDate" type="text" value="<%=beDate != null && !beDate.isEmpty() ? beDate : ""%>" readonly /> 
                             <img src="images/showcalendar.gif" > 
                        </td>

                        <td bgcolor="#F7F6F6" style="text-align:center; height: 100%; padding: 10px;  border: none;" valign="middle">
                             <input id="endDate" name="endDate" type="text" value="<%=eDate != null && !eDate.isEmpty() ? eDate : ""%>" readonly /> 
                             <img src="images/showcalendar.gif" > 
                        </td>
                    </tr>
                </table>
            </form>
                         
           <%
                if (data != null && !data.isEmpty()) {
            %>
                <div style="width: 80%;">
                    <table class="display" id="indextable" align="center" cellpadding="0" cellspacing="0" style="direction: <%=dir%>;">
                        <thead>
                            <tr>
                                <th style="text-align:center; font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px; width: 1%;">
                                    <b>
                                         # 
                                    </b>
                                </th>

                                <th style="width: 1%;">
                                     <input type="checkbox" id="ToggleTo" name="ToggleTo" onchange="JavaScript: selectAll(this);"/> 
                                </th>   

                                <th style="text-align:center; font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%">
                                    <img src="images/icons/Numbers.png" width="20" height="20" />
                                    <b>
                                         <%=complaintNo%> 
                                    </b>
                                </th>

                                <th style="width: 1%;">
                                      
                                </th>

                                <th style="text-align:center; font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="25%">
                                    <b>
                                         <%=branch%> 
                                    </b>
                                </th>

                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%">
                                    <b>
                                         <%=status%> 
                                    </b>
                                </th>

                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%">
                                    <b>
                                         <%=ordrDate%> 
                                    </b>
                                </th>
                                
                                <th style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="6%">
                                 Add Complaint 
                                </th>
                            </tr>
                        </thead>
                        
                        <tbody  id="planetData2">  
                            <%
                                String compStyle = "";
                                String clientDescription;
                                String disabled;
                                Calendar c = Calendar.getInstance();
                                for (WebBusinessObject wbo : data) {
                                    iTotal++;
                                    clientDescription = (String) wbo.getAttribute("description");
                                    if (clientDescription == null || clientDescription.equalsIgnoreCase("UL")) {
                                        clientDescription = "";
                                    }
                                    disabled = "";
                                    if (wbo.getAttribute("statusCode") != null && wbo.getAttribute("statusCode").equals("7")) {
                                        disabled = "disabled";
                                    }
                            %>
                                <tr style="padding: 1px; background-color: <%=wbo.getAttribute("trColor")%>;">
                                    <td>
                                         <%=iTotal%> 
                                    </td>
                                    
                                    <td>
                                         <input type="checkbox" id="moveTo" name="moveTo" value="<%=wbo.getAttribute("clientComplaintId")%>" <%=disabled%>/> 
                                         <input type="hidden" id="issueID<%=wbo.getAttribute("clientComplaintId")%>" value="<%=wbo.getAttribute("issueId")%>"/> 
                                         <input type="hidden" id="clientID<%=wbo.getAttribute("clientComplaintId")%>" value="<%=wbo.getAttribute("clientId")%>"/> 
                                    </td>
                                    
                                    <td style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                                        <%
                                            if (wbo.getAttribute("issueId") != null) {
                                        %>
                                            <a href="#" onclick="JavaScript: viewAppointment('<%=wbo.getAttribute("id")%>')">
                                                 <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDByDate").toString()%></font>
                                            </a>
                                        <%
                                            }
                                        %>
                                    </td>

                                    <td>
                                        <b title="<%=clientDescription%>" style="cursor: hand;">
                                            <a target="_blanck" href="<%=context%>/IssueServlet?op=jobOrderInvoice&issueId=<%=wbo.getAttribute("clientComplaintId")%>&clientID=1502277730347">
                                                <img src="images/icons/icon-claims.png" width="30" height="30" title=" Invoice "/> 
                                            </a>
                                        </b>
                                    </td>
                                    
                                    <td>
                                        <%
                                            if (wbo.getAttribute("branchName") != null) {%>
                                                <b style="cursor: hand;">
                                                     <%=wbo.getAttribute("branchName") != null ? wbo.getAttribute("branchName") : ""%> 
                                                </b>
                                        <%
                                            }
                                        %>
                                    </td>

                                    <% if (stat.equals("En")) {
                                            complStatus = (String) wbo.getAttribute("statusEnName");
                                        } else {
                                            complStatus = (String) wbo.getAttribute("statusArName");
                                        }
                                    %>
                                    
                                    <td>
                                        <b>
                                             <%=complStatus%> 
                                        </b>
                                    </td>
                                    
                                    <%  
                                        c = Calendar.getInstance();
                                        DateFormat formatter;
                                        formatter = new SimpleDateFormat("dd/MM/yyyy");
                                        String[] arrDate = wbo.getAttribute("appointmentDate").toString().split(" ");
                                        Date date = new Date();
                                        sDate = arrDate[0];
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
                                    
                                    <%
                                        if (currentDate.equals(sDate)) {
                                    %>
                                            <td nowrap>
                                                <font color="red">
                                                 Today 
                                                 </font>
                                            </td>
                                    <%
                                        } else {
                                    %>
                                            <td nowrap  >
                                                <font color="red"> <%=sDay%> - </font><b><%=sDate%> </b>
                                            </td>
                                    <%
                                        }
                                    %>
                                    
                                    <td>
                                        <img src="images/dialogs/Complaint-128.png" width="40" height="40" title=" Add Complaint " onclick="complaintPopup('<%=wbo.getAttribute("clientComplaintId")%>', '<%=wbo.getAttribute("comPrj")%>', '<%=wbo.getAttribute("issueId")%>')"/>
                                        <input type="hidden" id="issueID" name="issueID">
                                    </td>
                                </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                
                <%
                    } else if (data != null && data.isEmpty()) {
                %>
                    <b style="color: red; font-size: x-large;">
                         No Result. 
                    </b>
                <%
                    }
                %>
        </fieldset>
        
        <div id="compPopup" style="display: none; width: 90%;">
            <input type="hidden" id="compID" name="compID">
            <input type="hidden" id="oldIssueID" name="oldIssueID">
            <div style="clear: both;margin-left: 10%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closeAttachPopup()"/>
            </div>
            
            <div id="compDiv" style="width:80%; clear: both;margin: auto;"class="div">
                <table width="99%;" border="1px" style="margin-top: 10px;" id="tableDATA">
                    <tr>
                        <th style="width: 10%;">
                             Priority Level 
                        </th>
                        
                        <th style="width: 60%;">
                            Complaint Description 
                        </th>
                        
                        <%--<th style="width: 20%;">
                             To Employee 
                        </th>--%>
                        
                        <th style="width: 10%;">
                             Send 
                        </th>
                    </tr>

                    <tr id="claimROW">
                        <td>
                            <table width="99%;" border="0" style="">
                                <tr>
                                    <td style="border: 0px; font-size: medium; padding-top: 10px; padding-bottom: 10px;">
                                        <input type="radio" id="orderUrgency" name="orderUrgency" value="1" checked> Normal 
                                    </td>
                                </tr>

                                <tr>
                                    <td style="border: 0px; font-size: medium; padding-top: 10px; padding-bottom: 10px;">
                                        <input type="radio" name="orderUrgency" value="2"> Urgent 
                                    </td>
                                </tr>
                            </table>

                            <input type="hidden" id="clientCompId" value=""/>
                        </td>

                        <td>
                            <textarea rows="3" id="complaint" style="width: 90%;"></textarea>
                        </td>
                        
                        <td>
                            <input type="button" class='save3'id="mgrBtn" style="background-color: transparent;display: block;margin-right: auto;margin-left: auto;"  onclick='saveComplaint(this)'/>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </body>
</html>
