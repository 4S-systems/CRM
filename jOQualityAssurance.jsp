<%-- 
    Document   : jOQualityAssurance
    Created on : Sep 19, 2017, 11:23:21 AM
    Author     : fatma
--%>

<%@page import="com.clients.db_access.AppointmentMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    Calendar c = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    String nowDate = sdf.format(c.getTime());
    c.add(Calendar.DAY_OF_MONTH, -3);
    String beDate = request.getAttribute("beginDate") != null ? (String) request.getAttribute("beginDate") : sdf.format(c.getTime());
    String eDate = request.getAttribute("endDate") != null ? (String) request.getAttribute("endDate") : nowDate;
    
    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
    String loggegUserId = (String) loggedUser.getAttribute("userId");
                
    AppointmentMgr appointmentMgr = AppointmentMgr.getInstance();
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    ArrayList<WebBusinessObject> jOComplaintLst = request.getAttribute("jOComplaintLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("jOComplaintLst") : appointmentMgr.getJOComplaint(beDate, eDate, loggegUserId);
    
    int monthMaxDays = c.getActualMaximum(Calendar.DAY_OF_MONTH);
    
    String stat = (String) request.getSession().getAttribute("currentMode");
    String dir, beginDate, endDate, search, jobOrdr, clientName, direction, equClass, equ, techSpName, createdBy, SLA;
    String deadLine, CRC, comment, save, done, title;
    
    if (stat.equals("En")) {
        dir = "LTR";
        beginDate = " From Date ";
        endDate = " To Date ";
        search = " Search ";
        jobOrdr = " Job Order ";
        clientName = " Client Name ";
        direction = "Left";
        equClass = " Equipment Class ";
        equ = " Equipment ";
        techSpName = " Technical Specialist Name ";
        createdBy = " Created By ";
        SLA = "SLA";
        deadLine = " DeadLine ";
        CRC = "CRC";
        comment = " Comment ";
        save = " Save ";
        done = " Order Has Been Added ";
        title = " Job Orders Complaints ";
    } else {
        dir = "RTL";
        beginDate = " من تاريخ ";
        endDate = " إلى تاريخ ";
        search = " بحث ";
        jobOrdr = " أمر شغل ";
        clientName = " إسم العميل ";
        direction = "Right";
        equClass = " نوع المعدة ";
        equ = " Equipment ";
        techSpName = " إسم الفنى ";
        createdBy = " بواسطة ";
        SLA = "SLA";
        deadLine = " DeadLine ";
        CRC = "CRC";
        comment = " التعليق ";
        save = " حفظ ";
        done = " تم إضافة الطلب ";
        title = " Job Orders Complaints ";
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Job Order Complaint </title>
        
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
        
        <script>
            $(function (){
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd"
                });
                
                $("#complaintLst").dataTable({
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
            
            function getComplaints(){
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                
                document.COMP_FORM.action = "<%=context%>/AppointmentServlet?op=listJobOrderComplaint&beginDate=" + beginDate + "&endDate=" + endDate;
                document.COMP_FORM.submit();
            }
            
            function popupJoborder(compID) {
                var divID = "client_joborder";
                $('#joborderClientName').html($('#clName' + compID).val() ? $('#clName' + compID).val() : $('#clName' + compID).html());
                $('#joborderEqu').html($('#eqName' + compID).val() ? $('#eqName' + compID).val() : $('#eqName' + compID).html());
                $('#joborderEquID').val($('#eqID' + compID).val());
                $('#joborderTechnician').html($('#reciptUsr' + compID).val() ? $('#reciptUsr' + compID).val() : $('#reciptUsr' + compID).html());
                $('#eqClassLabel').html($('#eqClass' + compID).val() ? $('#eqClass' + compID).val() : $('#eqClass' + compID).html());
                $('#jOClientID').val($('#clientID' + compID).val() ? $('#clientID' + compID).val() : $('#clientID' + compID).html());
                $('#joborderEqClass').val($('#eqClassID' + compID).val() ? $('#eqClassID' + compID).val() : $('#eqClassID' + compID).html());
                $("#joborderOIssID").val($('#oIssID' + compID).val() ? $('#oIssID' + compID).val() : $('#oIssID' + compID).html());
                $("#joborderOUsrID").val($('#oUsrID' + compID).val() ? $('#oUsrID' + compID).val() : $('#oUsrID' + compID).html());
                $("#joborderClintCom").html(compID);
                $('#joborderUserID').val();

                $('#client_joborder').css("display", "block");
                $('#client_joborder').bPopup();
            }
            
            function closePopupDialog(){
                $('#client_joborder').bPopup().close();
            }
            
            function calcDeadLine(){
                 var sla = Number($("#SLA").val());
                 var monthDays = Number("<%=monthMaxDays%>");
                 var now;

                 var nowSplit = "<%=nowDate%>".split("/");
                 var day=Number(nowSplit[2]), month=Number(nowSplit[1]), year=Number(nowSplit[0]);
                 var days=day+sla;
                if(days > monthDays){
                    var x = Math.floor((days/monthDays));
                    month = month + Number(x);
                    if(month > 12){
                        var y = Math.floor((month/12));
                        year = Number(year) + Number(y);
                        month = month - (12*Number(y));
                        if(month == 0){
                            month = 12;
                            year = Number(year) - 1;
                        }
                    } else{
                        day = days - (monthDays*Number(x));
                        if(day == 0){
                            day = 1;
                            month = Number(month) - 1;
                        }
                    }
                } else {
                    day = day + sla;
                }
                
                if(Number(day) < 10 && day.toString().length < 2){
                    day = "0" + day;
                }
                if(Number(month) < 10 && month.toString().length < 2){
                    month = "0" + month;
                }
                 
                now = year + "/" + month + "/" + day;
                $("#joborderDate").val(now);
            }
            
            function saveJoborderManager() {
                var ticketType = "12";
                var comment = " Based on customer complaint No. " + $("#joborderClintCom").html() + $('#joborderComment').val();
                var userId = $('#joborderOUsrID').val();
                var clientId = $('#jOClientID').val();
                var joborderDate = $('#joborderDate').val();
                var unitID = $('#joborderEquID').val();
                var equClassID = $("#joborderEqClass").val();
                var CRC = $('#CRC').val();
                var SLA = $('#SLA').val();
                var issueId = $("#joborderOIssID").val();
                
                if (validateJoborder()) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/IssueServlet?op=saveJoborderManager",
                        data: {
                            userId: userId,
                            comment: comment,
                            ticketType: ticketType,
                            clientId: clientId,
                            joborderDate: joborderDate,
                            title: 'Job Order',
                            note: 'Job Order',
                            unitID: unitID,
                            subject: 'Job Order',
                            equClassID: equClassID,
                            SLA: SLA,
                            CRC: CRC,
                            issueId: issueId
                        }, success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            
                            if (info.status == 'ok') {
                                alert(' Job Order Has Been Added ');
                                closePopupDialog('client_joborder');
                            } else if (info.status == 'notManager') {
                                alert(' Can not save... Admin on this area is not a manager ');
                            }
                        }
                    });
                }
            }
            
            function validateJoborder() {
                return true;
            }
        </script>
        
        <style>
            *>*{
                vertical-align: middle;
            }
            
            .login {
                direction: <%=dir%>;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;
                background: #7abcff; /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
            
            .login  h1 {
                font-size: 16px;
                font-weight: bold;
                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 96%;
                margin-left: auto;
                margin-right: auto;
                text-height: 30px;
                color: #ffffff;
                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #FF9900;
                /*background: #cc0000;*/
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
            
            .titlebar {
                height: 30px;
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
            
            textarea{
                resize:none;
            }
            
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                height:20px;
                border: none;
            }
            
            label{
                font: Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight:bold;
                color:#005599;
            }
            
            .div{
                direction: rtl;
            }
            
            .button2{
                font-family: "Script MT", cursive;
                font-size: 18px;
                font-style: normal;
                font-variant: normal;
                font-weight: 400;
                line-height: 20px;
                width: 110px;
                height: 25px;
                text-decoration: none;
                display: inline-block;
                margin: 4px 2px;
                -webkit-transition-duration: 0.4s; /* Safari */
                transition-duration: 0.8s;
                cursor: pointer;
                border-radius: 12px;
                border: 1px solid #008CBA;
                padding-left:2%;
                text-align: center;
            }


            .button2:hover {
                background-color: #afdded;
                padding-top: 0px;
            }
        </style>
    </head>
    <body>
        <fieldset class="set" style="width: 95%; padding-bottom: 20px;">
            <legend align="center">
                <font color="blue" size="6">
                    <%=title%>
                </font>
            </legend>
                    
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
                            <button class="button" onclick="JavaScript: getComplaints();" style="width: 50%; color: #000; font-size:15; font-weight:bold;">
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

            <div style="width: 80%; display: <%if(jOComplaintLst != null){%> block <%} else {%> none <%}%>;">
                <table id="complaintLst">
                    <thead>
                        <th style="width: 14%;">
                             Client Name 
                        </th>

                        <th style="width: 14%;">
                             Phone
                        </th>

                        <th style="width: 35%;">
                             Complaint 
                        </th>

                        <th style="width: 7%;">
                             Priority 
                        </th>

                        <th style="width: 7%;">
                             Status 
                        </th>

                        <th style="width: 14%;">
                             Complaint Date 
                        </th>

                        <th style="width: 7%;">

                        </th>
                    </thead>

                    <tbody>
                        <%
                            if(jOComplaintLst != null){
                                WebBusinessObject jOComplaintWbo = new WebBusinessObject();
                                for(int index = 0; index<jOComplaintLst.size(); index++){
                                    jOComplaintWbo = jOComplaintLst.get(index);
                        %>
                                    <tr>
                                        <td>
                                             <%=jOComplaintWbo.getAttribute("clientName")%> 
                                        </td>

                                        <td>
                                             <%=jOComplaintWbo.getAttribute("clientPhone")%> 
                                        </td>

                                        <td>
                                             <%=jOComplaintWbo.getAttribute("compliantDesc")%> 
                                        </td>

                                        <td>
                                             <%=jOComplaintWbo.getAttribute("priorty")%> 
                                        </td>

                                        <td>
                                             <%=jOComplaintWbo.getAttribute("complaintStatus")%> 
                                        </td>

                                        <td>
                                             <%=jOComplaintWbo.getAttribute("creationTime")%> 
                                        </td>

                                        <td>
                                             <img src="images/icons/transfer.png" width="25" height="25" title=" Recreate Job Order " onclick="popupJoborder('<%=jOComplaintWbo.getAttribute("complaintID")%>')"/> 

                                             <input type="hidden" id="clName<%=jOComplaintWbo.getAttribute("complaintID")%>" name="clName" value="<%=jOComplaintWbo.getAttribute("clientName")%>">
                                             <input type="hidden" id="reciptUsr<%=jOComplaintWbo.getAttribute("complaintID")%>" name="reciptUsr" value="<%=jOComplaintWbo.getAttribute("reciptUsr")%>">
                                             <input type="hidden" id="eqClass<%=jOComplaintWbo.getAttribute("complaintID")%>" name="eqClass" value="<%=jOComplaintWbo.getAttribute("eqClass")%>">
                                             <input type="hidden" id="eqClassID<%=jOComplaintWbo.getAttribute("complaintID")%>" name="eqClassID" value="<%=jOComplaintWbo.getAttribute("eqClassID")%>">
                                             <input type="hidden" id="clientID<%=jOComplaintWbo.getAttribute("complaintID")%>" name="clientID" value="<%=jOComplaintWbo.getAttribute("clientID")%>">
                                             <input type="hidden" id="oIssID<%=jOComplaintWbo.getAttribute("complaintID")%>" name="oIssID" value="<%=jOComplaintWbo.getAttribute("oIssID")%>">
                                             <input type="hidden" id="oUsrID<%=jOComplaintWbo.getAttribute("complaintID")%>" name="oUsrID" value="<%=jOComplaintWbo.getAttribute("oUsrID")%>">
                                             <input type="hidden" id="eqID<%=jOComplaintWbo.getAttribute("complaintID")%>" name="eqID" value="<%=jOComplaintWbo.getAttribute("eqID")%>">
                                             <input type="hidden" id="eqName<%=jOComplaintWbo.getAttribute("complaintID")%>" name="eqName" value="<%=jOComplaintWbo.getAttribute("eqName")%>">
                                        </td>
                                    </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </fieldset>
                
        <div id="client_joborder" style="width: 45% !important; display: none; position: relative; z-index: 10000; direction: <%=dir%>;">
            <div style="clear: both; margin-left: 90%; margin-top: 0px; margin-bottom: -38px; direction: <%=dir%>">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat; -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -moz-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0); box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                                                                                -webkit-border-radius: 100px; -moz-border-radius: 100px; border-radius: 100px;" onclick="closePopupDialog()"/>
            </div>
            
            <div class="login" style="width: 90%; margin-bottom: 10px; margin-left: auto; margin-right: auto; direction: <%=dir%>;">
                <h1 align="center" style="vertical-align: middle; background-color: #006daa;">
                     <%=jobOrdr%> 
                     <img src="images/icons/visit_icon.png" alt="phone" width="24px"/>
                </h1>
                     
                <table class="table" style="width:90%; direction: <%=dir%>;" >
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">
                            <%=clientName%> : 
                        </td>
                        
                        <td style="text-align: <%=direction%>;">
                            <label id="joborderClientName">
                            </label>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">
                            <%=equClass%> : 
                        </td>
                        
                        <td style="text-align: <%=direction%>;">
                            <label id="eqClassLabel">
                            </label>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">
                            <%=equ%> : 
                        </td>
                        
                        <td style="text-align: <%=direction%>;">
                            <label id="joborderEqu">
                            </label>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: <%=direction%>;">
                             <%=techSpName%> : 
                        </td>
                        <td style="text-align: <%=direction%>;">
                            <label id="joborderTechnician">
                            </label>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: <%=direction%>;">
                             <%=createdBy%> : 
                        </td>
                        <td style="text-align: <%=direction%>;">
                            <label id="joborderEmployee">
                                <%=loggedUser.getAttribute("userName")%>
                            </label>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">
                            <%=SLA%> : 
                        </td>
                        
                        <td style="text-align: <%=direction%>;">
                            <INPUT id="SLA" name="SLA" type="number"  min="0" onchange="calcDeadLine();">
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:red; font-size: 16px;font-weight: bold; text-align: left;">
                            <%=deadLine%> : 
                        </td>
                        
                        <td style="text-align: <%=direction%>; color:red;">
                            <INPUT id="joborderDate" name="joborderDate" style="border: none; color: red;" readonly>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">
                            <%=CRC%> : 
                        </td>
                        
                        <td style="text-align: <%=direction%>;">
                            <INPUT id="CRC" name="CRC" type="text">
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: <%=direction%>;">
                            <%=comment%> : 
                        </td>
                        <td style="text-align: <%=direction%>;">
                            <label> Based on customer complaint No. <label id="joborderClintCom">  </label> </label> <br> <br>
                            <textarea cols="26" rows="10" id="joborderComment" style="width: 99%; background-color: #FFF7D6;">
                            </textarea>
                        </td>
                    </tr>
                </table>
                        
                <div style="text-align: <%=direction%>; margin-left: 2%; margin-right: auto; direction: <%=dir%>;" >
                    <button type="button" id="joborderManager" onclick="javascript: saveJoborderManager(this);" style="font-size: 14px; font-weight: bold; width: 150px">
                        <%=save%>
                    </button>
                    
                    <input type="hidden" id="jOClientID" name="jOClientID">
                    <input type="hidden" id="joborderOUsrID" name="joborderOUsrID"/>
                    <input type="hidden" id="joborderEqClass" name="joborderEqClass"/>
                    <input type="hidden" id="joborderOIssID" name="joborderOIssID"/>
                    <input type="hidden" id="joborderEquID" name="joborderEquID"/>
                </div>
                    
                <div id="progress" style="display: none; direction: <%=dir%>;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                    
                    <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="appMsg">
                         <%=done%>
                    </div>
            </div>  
        </div>
    </body>
</html>
