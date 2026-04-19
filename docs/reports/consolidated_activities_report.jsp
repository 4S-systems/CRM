<%@page import="com.silkworm.common.UserGroupMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE html>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    WebBusinessObject dataWbo = (WebBusinessObject) request.getAttribute("dataWbo");
    ArrayList<WebBusinessObject> groupsList = (ArrayList<WebBusinessObject>) request.getAttribute("groupsList");
    String departmentID = (String) request.getAttribute("departmentID");
    String fromDate = "";
    if (request.getAttribute("fromDate") != null) {
        fromDate = (String) request.getAttribute("fromDate");
    }
    String createdBy = "";
    if (request.getAttribute("createdBy") != null) {
        createdBy = (String) request.getAttribute("createdBy");
    }
    
    String groupId = "";
    if (request.getAttribute("groupId") != null) {
        groupId = (String) request.getAttribute("groupId");
    }
    
    List<WebBusinessObject> userGroups = new ArrayList<>(UserGroupMgr.getInstance().getByUserId(createdBy));
    String groupID = "";
    if(!userGroups.isEmpty()) {
        groupID = (String) userGroups.get(0).getAttribute("groupID");
    }
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <style type="text/css">
            .titlebar {
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
        </style>
        <script  type="text/javascript">
            $(function () {
                $("#fromDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
		
		getGrpEmp();
            });
	    
            function openInNewWindow(url) {
                var win = window.open(url, '_blank');
                win.focus();
            }
	    
	    function getGrpEmp(){
		var grpId = $("#groupId option:selected").val();
		
		var options = [];
                options.push(' <option value=""> إختر موظف </option>');
		
		$.ajax({
		    type: "post",
		    url: "<%=context%>/ReportsServletThree?op=consolidatedActivitiesReport",
		    data: {
			grpId: grpId,
			getGrpEmp: "1"
		    }, success: function(jsonString) {
			var grpEmpInfo = $.parseJSON(jsonString);
			var createdBy = '<%=createdBy%>';
			
			$.each(grpEmpInfo, function () {
			    if(createdBy == this.userId){
				options.push('<option value="', this.userId, '" selected>', this.userName, '</option>');
			    } else {
				 options.push('<option value="', this.userId, '">', this.userName, '</option>');
			    }
                        });
			
			$("#createdBy").html(options.join(''));
		    }
		});
	    }
        </script>
    </head>
    <body>
        <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
            <form name="SEARCH_FORM" action="<%=context%>/ReportsServletThree?op=consolidatedActivitiesReport" method="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">الأنشطة المجمع <img src="images/icons/activity.png" style="width: 40px;"/></font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table align="center" dir="rtl" width="60%" cellspacing="2" cellpadding="1">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="40%">
                            <b><font size=3 color="white">في تاريخ</b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="40%">
                            <b><font size=3 color="white"> المجموعة </b>
                        </td>
                        <td STYLE="text-align:center" bgcolor="#dedede" width="20%" rowspan="3"> 
                            <button type="submit" onclick="JavaScript: search();" style="color: #27272A;font-size:15px;margin-top: 20px;font-weight:bold; width: 70%; ">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>">
                            <br/><br/>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 250px;" name="groupId" id="groupId" onchange="getGrpEmp();" >
				<option value="" selected> إختر مجموعة </option>
                                <sw:WBOOptionList wboList='<%=groupsList%>' displayAttribute="groupName" valueAttribute="groupID" scrollToValue="<%=groupId%>"/>
                            </select>
                            <br/><br/>
                        </td>
                    </tr>
		    
		    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="40%">
                            <b><font size=3 color="white"> الموظف </b>
                        </td>
			
			<td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 250px;" name="createdBy" id="createdBy">
                                
                            </select>
                        </td>
                    </tr>
		    
                </table>
            </form>
            <br/>
            <%
                if (request.getAttribute("createdBy") != null) {
            %>
            <form name="USERS_FORM" method="POST">
                <div style="width: 60%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table style="display" id="clients" ALIGN="center" dir="rtl" WIDTH="90%" CELLPADDING="5" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4; font-size: 16px;">
                        <thead>
                            <tr>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; font-size:14px">&nbsp;</th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; font-size:14px" colspan="3"><b>النشاط</b></th>
                                <th class="blueBorder blueHeaderTD" bgcolor="#669900" style="text-align:center; font-size:14px;"><b>العدد</b></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (!"0".equals(metaMgr.getTargetCalls())) {
                            %>
                            <tr style="cursor: pointer; background-color: #d3d5d4;">
                                <td style="text-align: center;" nowrap>
                                    <img src="images/icons/Target_Icon.png" style="width: 40px; margin: 5px;"/>
                                </td>
                                <td style="text-align: center" nowrap colspan="3">
                                    <b>المستهدف</b>
                                </td>
                                <td style="text-align: center" nowrap>
                                    <b><%=metaMgr.getTargetCalls()%></b>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                            <tr style="cursor: pointer">
                                <td style="text-align: center" nowrap>
                                    <img src="images/dialogs/comment_channel.png" style="width: 40px; margin: 5px;"/>
                                </td>
                                <td style="text-align: center" nowrap colspan="3">
                                    <b>التعليقات</b>
                                </td>
                                <td style="text-align: center" nowrap>
                                    <b><a target="_blank" title="مشاهدة التفاصييل" href="<%=context%>/ReportsServletTwo?op=listEmployeeComments&fromDate=<%=fromDate%>&toDate=<%=fromDate%>&createdBy=<%=createdBy%>&reportType=client"><%=dataWbo.getAttribute("commentsCount") != null ? dataWbo.getAttribute("commentsCount") : "0"%></a></b>
                                </td>
                            </tr>
                            <tr style="cursor: pointer">
                                <td style="text-align: center" nowrap rowspan="2">
                                    <img src="images/dialogs/comment_public.ico" style="width: 40px; margin: 5px;"/>
                                </td>
                                <td style="text-align: center" nowrap rowspan="2">
                                    <b>تعليقات على المتابعات</b>
                                </td>
                                <td style="width: 100px;" nowrap>
                                    تم الرد عليها
                                </td>
                                <td>
                                    <b><%=dataWbo.getAttribute("answeredAppointmentCount") != null ? dataWbo.getAttribute("answeredAppointmentCount") : "0"%></b>
                                </td>
                                <td style="text-align: center" nowrap rowspan="2">
                                    <b><a target="_blank" title="مشاهدة التفاصييل" href="<%=context%>/AppointmentServlet?op=lstEmpAppCmnt&fromDate=<%=fromDate%>&toDate=<%=fromDate%>&createdBy=<%=createdBy%>&reportType=client&type=true"><%=dataWbo.getAttribute("appCmntCount") != null ? dataWbo.getAttribute("appCmntCount") : "0"%></a></b>
                                </td>
                            </tr>
                            <tr style="cursor: pointer">
                                <td style="width: 100px;" nowrap>
                                    لم يتم الرد عليها
                                </td>
                                <td>
                                    <b><%=dataWbo.getAttribute("notAnsweredAppointmentCount") != null ? dataWbo.getAttribute("notAnsweredAppointmentCount") : "0"%></b>
                                </td>
                            </tr>
                            <tr style="cursor: pointer">
                                <td style="text-align: center" nowrap rowspan="2">
                                    <img src="images/icons/call_center.png" style="width: 40px; margin: 5px;"/>
                                </td>
                                <td style="text-align: center" nowrap rowspan="2">
                                    <b>المكالمات</b>
                                </td>
                                <td style="width: 100px;" nowrap>
                                    تم الرد عليها
                                </td>
                                <td>
                                    <b><%=dataWbo.getAttribute("answeredCallsCount") != null ? dataWbo.getAttribute("answeredCallsCount") : "0"%></b>
                                </td>
                                <td style="text-align: center" nowrap rowspan="2">
                                    <b><a target="_blank" title="مشاهدة التفاصييل" href="<%=context%>/AppointmentServlet?op=getAllClientAppointments&fromDate=<%=fromDate%>&toDate=<%=fromDate%>&createdBy=<%=createdBy%>&appointmentType=call&departmentID=<%=departmentID != null ? departmentID : ""%>"><%=dataWbo.getAttribute("callsCount") != null ? dataWbo.getAttribute("callsCount") : "0"%></a></b>
                                </td>
                            </tr>
                            <tr style="cursor: pointer">
                                <td style="width: 100px;" nowrap>
                                    لم يتم الرد عليها
                                </td>
                                <td>
                                    <b><%=dataWbo.getAttribute("notAnsweredCallsCount") != null ? dataWbo.getAttribute("notAnsweredCallsCount") : "0"%></b>
                                </td>
                            </tr>
                            <tr style="cursor: pointer">
                                <td style="text-align: center" nowrap rowspan="2">
                                    <img src="images/dialogs/handshake.png" style="width: 40px; margin: 5px;"/>
                                </td>
                                <td style="text-align: center" nowrap rowspan="2">
                                    <b>المقابلات</b>
                                </td>
                                <td style="width: 100px;" nowrap>
                                    تم الحضور
                                </td>
                                <td>
                                    <b><%=dataWbo.getAttribute("attendedMeetingsCount") != null ? dataWbo.getAttribute("attendedMeetingsCount") : "0"%></b>
                                </td>
                                <td style="text-align: center" nowrap rowspan="2">
                                    <b><a target="_blank" title="مشاهدة التفاصييل" href="<%=context%>/AppointmentServlet?op=getAllClientAppointments&fromDate=<%=fromDate%>&toDate=<%=fromDate%>&createdBy=<%=createdBy%>&appointmentType=meeting&departmentID=<%=departmentID != null ? departmentID : ""%>"><%=dataWbo.getAttribute("meetingsCount") != null ? dataWbo.getAttribute("meetingsCount") : "0"%></a></b>
                                </td>
                            </tr>
                            <tr style="cursor: pointer">
                                <td style="width: 100px;" nowrap>
                                    لم يتم الحضور
                                </td>
                                <td>
                                    <b><%=dataWbo.getAttribute("notAttendedMeetingsCount") != null ? dataWbo.getAttribute("notAttendedMeetingsCount") : "0"%></b>
                                </td>
                            </tr>
                            <tr style="cursor: pointer">
                                <td style="text-align: center" nowrap>
                                    <img src="images/icons/stop.png" style="width: 40px; margin: 5px;"/>
                                </td>
                                <td style="text-align: center" nowrap colspan="3">
                                    <b>الأنهاء</b>
                                </td>
                                <td style="text-align: center" nowrap>
                                    <b><a target="_blank" title="مشاهدة التفاصييل" href="<%=context%>/ReportsServletTwo?op=listClosureNotes&fromDate=<%=fromDate%>&toDate=<%=fromDate%>&createdBy=<%=createdBy%>&statusCode=6"><%=dataWbo.getAttribute("closureCount") != null ? dataWbo.getAttribute("closureCount") : "0"%></a></b>
                                </td>
                            </tr>
                            <tr style="cursor: pointer">
                                <td style="text-align: center" nowrap>
                                    <img src="images/icons/finish.png" style="width: 40px; margin: 5px;"/>
                                </td>
                                <td style="text-align: center" nowrap colspan="3">
                                    <b>الأغلاق</b>
                                </td>
                                <td style="text-align: center" nowrap>
                                    <b><a target="_blank" title="مشاهدة التفاصييل" href="<%=context%>/ReportsServletTwo?op=listClosureNotes&fromDate=<%=fromDate%>&toDate=<%=fromDate%>&createdBy=<%=createdBy%>&statusCode=7"><%=dataWbo.getAttribute("finishCount") != null ? dataWbo.getAttribute("finishCount") : "0"%></a></b>
                                </td>
                            </tr>
                            <tr style="cursor: pointer">
                                <td style="text-align: center" nowrap>
                                    <img src="images/dialogs/mailbox.png" style="width: 40px; margin: 5px;"/>
                                </td>
                                <td style="text-align: center" nowrap colspan="3">
                                    <b>البريد الألكتروني</b>
                                </td>
                                <td style="text-align: center" nowrap>
                                    <b><a target="_blank" title="مشاهدة التفاصييل" href="<%=context%>/EmailServlet?op=emailReport&fromDate=<%=fromDate%>&toDate=<%=fromDate%>&usrID=<%=createdBy%>&groupId=<%=groupID%>"><%=dataWbo.getAttribute("emailsCount") != null ? dataWbo.getAttribute("emailsCount") : "0"%></a></b>
                                </td>
                            </tr>
                            <tr style="cursor: pointer">
                                <td style="text-align: center" nowrap>
                                    <img src="images/icons/interest.png" style="width: 40px; margin: 5px;"/>
                                </td>
                                <td style="text-align: center" nowrap colspan="3">
                                    <b>الحجوزات</b>
                                </td>
                                <td style="text-align: center" nowrap>
                                    <b><a target="_blank" title="مشاهدة التفاصييل" href="<%=context%>/UnitServlet?op=employeeReservedUnits&fromDate=<%=fromDate%>&toDate=<%=fromDate%>&userID=<%=createdBy%>&departmentID=<%=departmentID%>"><%=dataWbo.getAttribute("reservationCount") != null ? dataWbo.getAttribute("reservationCount") : "0"%></a></b>
                                </td>
                            </tr>
                            <tr style="cursor: pointer">
                                <td style="text-align: center" nowrap>
                                    <img src="images/client.png" style="width: 40px; margin: 5px;"/>
                                </td>
                                <td style="text-align: center" nowrap colspan="3">
                                    <b>أضافة عملاء</b>
                                </td>
                                <td style="text-align: center" nowrap>
                                    <b><a target="_blank" title="مشاهدة التفاصييل" href="<%=context%>/SearchServlet?op=searchNewClientsGroup&beginDate=<%=fromDate%> 00:00&endDate=<%=fromDate%> 23:59&description=&senderID=<%=createdBy%>&groupID=&reportType=detail"><%=dataWbo.getAttribute("clientsCount") != null ? dataWbo.getAttribute("clientsCount") : "0"%></a></b>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <br/>
                <br/>
            </form>
            <%
                }
            %>
        </fieldset>
    </body>
</html>
