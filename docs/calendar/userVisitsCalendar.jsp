<%-- 
    Document   : userVisitingCalendar
    Created on : Nov 21, 2017, 10:04:32 AM
    Author     : fatma
--%>

<%@page import="java.util.Map"%>
<%@page import="com.crm.common.CalendarUtils.Day"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.crm.common.CalendarUtils"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
	
    List<Integer> years = (List<Integer>) request.getAttribute("years");
    List<CalendarUtils.Month> months = (List<CalendarUtils.Month>) request.getAttribute("months");
    List<CalendarUtils.Day> days = (List<CalendarUtils.Day>) request.getAttribute("days");
    
    Integer selectedYear = (Integer) request.getAttribute("selectedYear");
    Integer selectedMonth = (Integer) request.getAttribute("selectedMonth");
    
    ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
    
    String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";
    
    Map<String, Map<String, WebBusinessObject>> data = (Map<String, Map<String, WebBusinessObject>>) request.getAttribute("data");
	
    String stat = (String) request.getSession().getAttribute("currentMode");
    
    int xAxis, yAxis;
    
    String align, dir, showVisitsDuring, mnth, yr, dprt, noDprt, updt, guide, sDone, future, cared, neglected, thr, xAlign, agentVisit;
    String agentNm;
    
    if (stat.equals("En")) {
	xAxis = 0;
	yAxis = 0;
	
	align = "center";
	dir = "LTR";
	showVisitsDuring = " Show visits during ";
	mnth = " Month ";
	yr = " Year ";
	dprt = " Department ";
	noDprt = " No Department ";
	updt = " Update ";
	guide = " Guide ";
	sDone = " Successfully Done ";
	future = " Futuristic ";
	cared = " Cared ";
	neglected = " Neglected ";
	thr = " There Is No ";
	xAlign = "right";
	agentVisit = " Agents Visits ";
	agentNm = " Agents Name ";
    } else {
	xAxis = 1100;
	yAxis = 0;
	
	align = "center";
	dir = "RTL";
	showVisitsDuring = " عرض المقابلات خلال ";
	mnth = " شهر ";
	yr = " سنة ";
	dprt = " الإدارة ";
	noDprt = " لا توجد إدارة ";
	updt = " تحديث ";
	guide = " الدليل ";
	sDone = " تمت بنجاح ";
	future = " مستقبلية ";
	cared = " معتنى بها ";
	neglected = " مهملة ";
	thr = " لا يوجد ";
	xAlign = "left";
	agentVisit = " مقابلات العملاء ";
	agentNm = " اسم الموظف ";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Users Visits Calender </title>
	
        <script src="js/custom_popup/jquery-1.10.2.js"></script>
        <script src="js/custom_popup/jquery-ui.js"></script>
	
	<link rel="stylesheet" href="js/custom_popup/jquery-ui.css" />
	
	<script type="text/javascript">
            function showCalendar() {
                var selectedMonth = $("#selectedMonth").val();
                var selectedYear = $("#selectedYear").val();
                document.visitForm.action = "<%=context%>/CalendarServlet?op=getUsersVisitsCalendar&selectedYear=" + selectedYear + "&selectedMonth=" + selectedMonth;
                document.visitForm.submit();
            }
	    
	    function openDailog(userId, date) {
                var divTag = $("<div></div>");
		
                $.ajax({
                    type: "post",
                    url: '<%=context%>/AppointmentServlet?op=showAppointmentsForUser',
                    data: {
                        userId: userId,
                        date: date
                    },
                    success: function(data) {
                        divTag.html(data).dialog({
			    modal: true,
			    title: "",
			    show: "blind",
			    hide: "explode",
			    width: 1200,
			    position: {
				my: 'center',
				at: 'center'
			    },
			    buttons: {
				Ok: function() {
				    $(this).dialog('close');
				}
			    }
			})
			.dialog('open');
                    }
                });
            }
	</script>
    </head>
    
    <body onload="window.scrollTo(<%=xAxis%>,<%=yAxis%>)">
        <div style="width: 100%;">
	    
	</div>
	
        <FORM NAME="visitForm" METHOD="POST">
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="98%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4;">
                <TR>
                    <TD width="12%" STYLE="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <DIV>
			     <%=showVisitsDuring%> 
                        </DIV>
                    </TD>
		    
                    <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
			 <%=mnth%> 
                    </TD>
		    
                    <TD width="10%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <select id="selectedMonth" name="selectedMonth" style="font-size: 14px; width: 100px;">
                            <% 
				for (CalendarUtils.Month month : months) {
			    %>
				    <option style="font-weight: bold" value="<%=month.getNumber()%>" <%= (month.getNumber() == selectedMonth) ? "selected" : ""%>> <%=month.getName()%> </option>
                            <%
				}
			    %>
                        </select>
                    </TD>
		    
                    <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px;" nowrap CLASS="silver_even_main" >
			 <%=yr%> 
		    </TD>
		    
                    <TD width="20%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <select id="selectedYear" name="selectedYear" style="font-size: 14px; width: 70px">
                            <%
				for (Integer year : years) {
			    %>
				    <option style="font-weight: bold" value="<%=year%>" <%= (year.equals(selectedYear)) ? "selected" : ""%>> <%=year%> </option>
                            <%
				}
			    %>
                        </select>
                    </TD>
		    
                    <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
			 <%=dprt%> 
                    </TD>
		    
                    <TD width="20%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <select id="departmentID" name="departmentID" style="font-size: 14px; width: 140px">
			    <%
				if(departments != null && !departments.isEmpty()){
			    %>
				    <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
			   <%
				} else {
			    %>
				    <option value="" selected> <%=noDprt%> </option>
			    <%
				}
			    %>
                        </select>
                    </TD>
		    
                    <TD width="10%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px;" nowrap CLASS="silver_even_main" >
                        <button style="width: 100px;" type="button" onclick="showCalendar();">
			    <b style="font-weight: bold; font-size: 14px; vertical-align: middle;">
				 <%=updt%> 
			    </b>
			    
			    <img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle;"/> 
			</button>
                    </TD>
		    
                    <TD STYLE="text-align: right; color: blue; font-size: 14px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                        <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="98%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4;">
                            <TR>
                                <TD STYLE="text-align: center; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px;" nowrap CLASS="silver_even_main" >
                                     <%=guide%> 
                                </TD>
				
                                <TD STYLE="text-align: right; color: purple; font-size: 14px; padding-left: 10px; border-left-width: 0px;" nowrap CLASS="silver_even_main" >
                                     <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DONE)%>" width="20" height="20" style="vertical-align: middle;"/> 
                                     <%=sDone%> 
                                </TD>
				
                                <TD STYLE="text-align: right; color: purple; font-size: 14px; padding-left: 10px; border-left-width: 0px;" nowrap CLASS="silver_even_main" >
                                     <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_OPEN)%>" width="20" height="20" style="vertical-align: middle;"/> 
                                     <%=future%> 
                                </TD>
				
                                <TD STYLE="text-align: right; color: purple; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                                     <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_CARED)%>" width="20" height="20" style="vertical-align: middle;"/> 
                                     <%=cared%> 
                                </TD>
				
                                <TD STYLE="text-align: right; color: purple; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                                     <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_NEGLECTED)%>" width="20" height="20" style="vertical-align: middle;"/> 
                                     <%=neglected%>  
                                </TD>
                                <TD STYLE="text-align: right; color: purple; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                                     <img src="images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_IMAGE_DEFAULT)%>" width="20" height="20" style="vertical-align: middle"/> 
                                     <%=thr%> 
                                </TD>
                            </TR>
                        </TABLE>
				
                        <font size="1" style="float: <%=xAlign%>;"> APPOINTMENTS NOT FOLLOWED UP WILL BE MARKED AS NEGLECTED AFTER 12 HOURS </font>
                    </TD>
                </TR>
            </TABLE>
		    
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="98%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                <TR>
                    <TD class="blueBorder blueHeaderTD" COLSPAN="<%=(days.size() + 2)%>" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:14px">
                        <DIV>
                            <B>
                                 <%=agentVisit%> 
                            </B>
                        </DIV>
                    </TD>
                </TR>
		
                <TR>
                    <TD rowspan="2" STYLE="text-align: center;" BGCOLOR="#DDDD00" nowrap  CLASS="silver_odd_main" >
                        <b>
			    <font size="2" color="#000080" style="text-align: center;">
				 # 
			    </font>
			</b>
                    </TD>
		    
                    <TD rowspan="2" class="silver_footer" bgcolor="#808000" STYLE="width: 200px;text-align:center;color:black;font-size:14px">
                        <b>
			    <font color="#000080" style="text-align: center;">
				 <%=agentNm%> 
			    </font>
			</b>
                    </TD>
                </TR>
		
                <TR>
                    <%
			for (Day day : days) {
		    %>
			<TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="silver_odd_main" >
			    <font color="red">
				 <%=day.getName()%> 
			    </font>
			    
			    <br>
			    
			    <B>
				 <%=day.getDay()%> 
			    </B>
			</TD>
                    <%
			}
		    %>
                </TR>
		
                <%
                    String userId, userName, currentStatusCode, imageName, bgColorm;
                    String cursor, clickAction, date;
                    Integer timeRemaining;
                    Map<String, WebBusinessObject> dayInfo;
                    WebBusinessObject appointment;
                    int flipper = 0;
                    for (Map.Entry<String, Map<String, WebBusinessObject>> entry : data.entrySet()) {
                        userId = entry.getKey().split("@@")[0];
                        userName = entry.getKey().split("@@")[1];
                        dayInfo = entry.getValue();
			
                        if ((flipper % 2) == 1) {
                            bgColorm = "silver_odd_main";
                        } else {
                            bgColorm = "silver_even_main";
                        }
                        flipper++;
                %>
		
			<TR>
			    <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
				<DIV>
				     <%=flipper%> 
				</DIV>
			    </TD>

			    <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
				<DIV>
				     <%=userName%> 
				</DIV>
			    </TD>

			    <%
				for (Day day : days) {
				    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_IMAGE_DEFAULT);
				    cursor = "default";
				    clickAction = "";
				    appointment = dayInfo.get(day.getDay() + "");
				    if (appointment != null) {
					currentStatusCode = (String) appointment.getAttribute("currentStatusCode");
					timeRemaining = Integer.parseInt((String) appointment.getAttribute("timeRemaining"));
					if (CRMConstants.APPOINTMENT_STATUS_DONE.equalsIgnoreCase(currentStatusCode)) {
					    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DONE);
					} else if (CRMConstants.APPOINTMENT_STATUS_CARED.equalsIgnoreCase(currentStatusCode)) {
					    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_CARED);
					} else if (timeRemaining >= -(12 * 60) && CRMConstants.APPOINTMENT_STATUS_OPEN.equalsIgnoreCase(currentStatusCode)) {
					    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_OPEN);
					} else {
					    imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_NEGLECTED);
					}

					cursor = "hand";
					date = (String) appointment.getAttribute("appointmentDate");
					String tempDate = date.split(" ")[0];
					String[] dateArr = tempDate.contains("-") ? tempDate.split("-") : tempDate.split("/");
					if(dateArr.length == 3) {
					    if(dateArr[0].length() == 4) {
						date = dateArr[2] + "/" + dateArr[1] + "/" + dateArr[0] + " " + date.split(" ")[1];
					    } else {
						date = dateArr[0] + "/" + dateArr[1] + "/" + dateArr[2] + " " + date.split(" ")[1];
					    }
					}
					clickAction = "JavaScript: openDailog('" + userId + "', " + "'" + selectedYear + "/" + (selectedMonth + 1) + "/" + day.getDay() + "');";
				    }
			    %>

				    <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
					<DIV>                           
					    <img src="images/icons/<%=imageName%>" onclick="<%=clickAction%>" width="24" height="24" style="vertical-align: middle; cursor: <%=cursor%>"/>
					</DIV>
				    </TD>
			    <%
				}
			    %>
			<TR>
                    <%
			}
		    %>
            </TABLE>
        </FORM>
    </body>
</html>
