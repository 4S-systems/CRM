<%-- 
    Document   : emailReport
    Created on : Nov 29, 2017, 8:42:39 AM
    Author     : fatma
--%>

<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
	
    String stat = (String) request.getSession().getAttribute("currentMode");
    
    ArrayList<WebBusinessObject> emailLst = request.getAttribute("emailLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("emailLst") : null;
    
    String my = request.getAttribute("my") != null ? (String) request.getAttribute("my") : null;
    
    ArrayList<WebBusinessObject> grpLst = new ArrayList<WebBusinessObject>();
    ArrayList<WebBusinessObject> usrLst = new ArrayList<WebBusinessObject>();
    String grpID = new String();
    String usrID = new String();
    if(my == null){
	grpLst = request.getAttribute("grpLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("grpLst") : new ArrayList<WebBusinessObject>();
	usrLst = request.getAttribute("usrLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("usrLst") : new ArrayList<WebBusinessObject>();
	grpID = request.getAttribute("grpID") != null ? (String) request.getAttribute("grpID") : "";
	usrID = request.getAttribute("usrID") != null ? (String) request.getAttribute("usrID") : "";
    }
    
    Calendar cal = Calendar.getInstance();
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    String toDate = request.getAttribute("toDate") != null ? (String) request.getAttribute("toDate") : sdf.format(cal.getTime());
    cal.add(Calendar.DAY_OF_MONTH, -1);
    String fromDate = request.getAttribute("fromDate") != null ? (String) request.getAttribute("fromDate") : sdf.format(cal.getTime());
    
    cal.add(Calendar.YEAR, 1);
    int currentDay = cal.get(Calendar.DAY_OF_MONTH);
    int currentYear = cal.get(Calendar.YEAR);
    int currentMonth = cal.get(Calendar.MONTH);
	
    String title, dir, fromDateStr, toDateStr, grpStr, usrStr, srch, all, clntNo, clntNm, clntEml, sub,
	    bdy, sentTmStr, sentByStr;
    if (stat.equals("En")) {
	title = " Email Report ";
	dir = "ltr";
	fromDateStr = " From Date ";
	toDateStr = " To Date ";
	grpStr = " Department ";
	usrStr = " Employee ";
	all = " All ";
	srch = " Search ";
	clntNo = " Client No. ";
	clntNm = " Name ";
	clntEml = " Email ";
	sub = " Subject ";
	bdy = " Body ";
	sentTmStr = " Sent Time ";
	sentByStr = " Sent From ";
    } else {
	title = " تقرير البريد الإلكترونى ";
	dir = "rtl";
	fromDateStr = " من تاريخ ";
	toDateStr = " إلى تاريخ ";
	grpStr = " المجموعة ";
	usrStr = " الموظف ";
	all = " الكل ";
	srch = " بحث ";
	clntNo = " رقم العميل ";
	clntNm = " الإسم ";
	clntEml = " البريد الإلكترونى ";
	sub = " الموضوع ";
	bdy = " المحتوى ";
	sentTmStr = " تاريخ الإرسال ";
	sentByStr = " المرسل ";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Email Report </title>
	
	<script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
	
	<script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
	
	<script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
	
	<script type="text/javascript" src="js/jquery.dataTables.js"></script>
	<link rel="stylesheet" href="css/demo_table.css"/>
	
	<style>
	    .button2{
                font-size: 15px;
                font-style: normal;
                font-variant: normal;
                font-weight: bold;
                line-height: 20px;
                width: 150px;
                height: 30px;
                text-decoration: none;
                display: inline-block;
                margin: 4px 2px;
                -webkit-transition-duration: 0.4s;
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
	
	<script>
	    $(document).ready(function () {
		$("#fromDate, #toDate").datepicker({
		    changeMonth: true,
		    changeYear: true,
		    dateFormat: 'yy/mm/dd',
		    maxDate: '<%=currentYear%>' + '/' + '<%=currentMonth + 1%>' + '/' + '<%=currentDay%>',
		});
	    
                $("#groupId").select2();
		
		$("#usrID").select2();
		
		$('#emailTbl').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
	    });
	    
	    function getUsers(){
		var groupId = $("#groupId option:selected").val();
		//$('#usrID option[value=""]').prop('selected', true);
		$("#usrID>*").remove();
		
		var options = [];
		
		$.ajax({
                    type: "post",
                    url: "<%=context%>/EmailServlet?op=emailReport",
                    data: {
                        gtUsr: "1",
                        groupID: groupId
                    }, success: function (jsonString) {
                        var result = $.parseJSON(jsonString);
			options.push('<option value="" selected><%=all%></option>');
			$.each(result, function () {
			    console.log(this.userId);
                            options.push('<option value="', this.userId, '">', this.fullName, '</option>');
                        });
			
			$("#usrID").append(options.join(''));
                    }
                });
	    }
	</script>
    </head>
    <body>
	<fieldset class="set" style="width: 90%; border-color: #006699">
	    <legend>
                <font color="#005599" size="4">
		     <%=title%> 
            </legend>
			
	    <form name="emailReport" id="emailReport" method="post">
		<table ALIGN="center" DIR="<%=dir%>" WIDTH="40%">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b>
				<font size=3 color="white">
				     <%=fromDateStr%> 
			    </b>
                        </td>
			
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; "WIDTH="50%">
                            <b>
				<font size=3 color="white">
				    <%=toDateStr%> 
			    </b>
                        </td>
		    </tr>
		    
		    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE" WIDTH="50%"> 
			     <input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>"/> 
			     <img src="images/showcalendar.gif"/> 
                        </td>
			
                        <td bgcolor="#dedede" style="text-align:center" valign="middle" WIDTH="50%">
                             <input id="toDate" name="toDate" type="text" value="<%=toDate%>"/> 
			     <img src="images/showcalendar.gif"/> 
                        </td>
                    </tr>
		    
		    <%
			if(my == null){
		    %>
			<tr>
			    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
				<b>
				    <font size=3 color="white">
					 <%=grpStr%> 
				</b>
			    </td>

			    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
				<b>
				    <font size=3 color="white">
					<%=usrStr%> 
				</b>
			    </td>
			</tr>

			<tr>
			    <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE" WIDTH="50%">
				<select style="width: 200px; font-weight: bold; font-size: 13px; margin-top: 5px;" id="groupId" name="groupId" onchange="getUsers();">
				    <option value="" selected> <%=all%> </option>
				    <sw:WBOOptionList displayAttribute="groupName" valueAttribute="groupID" wboList="<%=grpLst%>" scrollToValue='<%=grpID%>' />
				</select>
			    </td>

			    <td bgcolor="#dedede" style="text-align:center" valign="middle" WIDTH="50%" id="usrIdtd">
				<select style="width: 200px; font-weight: bold; font-size: 13px; margin-top: 5px;" id="usrID" name="usrID">
				    <option value="" selected> <%=all%> </option>
				    <%
					for (WebBusinessObject usrWbo : usrLst) {
					
				    %>
				    <option value="<%=usrWbo.getAttribute("userId")%>" <%=usrWbo.getAttribute("userId").equals(usrID) ? "selected" : ""%>> <%=usrWbo.getAttribute("fullName")%> </option>
				    <%
					}
				    %>
				</select>
			    </td>
			</tr>
		    <%
			}
		    %>
		    
		    <tr>
                        <td STYLE="text-align:center" bgcolor="#dedede" colspan="2" WIDTH="50%">  
                            <button onclick="JavaScript: submitForm();" class="button2" STYLE="color: #27272A;font-size:15px;font-weight:bold;height: 35px">
				 <%=srch%> 
				 <IMG HEIGHT="15" SRC="images/search.gif"/> 
			    </button>
                        </td>
                    </tr>
		</table>
				 
		<div style="width: 90%; margin-right: auto; margin-left: auto; padding-top: 5px;">
                    <table ALIGN="center" dir="<%=dir%>" WIDTH="100%" id="emailTbl">
                        <thead>
                            <tr>
				<th style="color: #005599; width: 8%;">
				     <%=clntNo%> 
				</th>
				
				<th style="color: #005599; width: 16%;">
				     <%=clntNm%> 
				</th>
				
                                <th style="color: #005599; width: 18%;">
				     <%=clntEml%> 
				</th>
				
                                <th style="color: #005599; width: 18%;">
				     <%=sub%> 
				</th>
				
                                <th style="color: #005599; width: <%if(my == null){%>20%<%}else{%>32%<%}%>;">
				     <%=bdy%> 
				</th>
				
                                <th style="color: #005599; width: 8%;">
				     <%=sentTmStr%> 
				</th>
				
				<%
				    if(my == null){
				%>
					<th style="color: #005599; width: 12%;">
					     <%=sentByStr%> 
					</th>
				<%
				    }
				%>
                            </tr>
                        </thead>
			
                        <tbody>
                            <%
				if(emailLst != null && !emailLst.isEmpty()){
				    for (WebBusinessObject emailWbo : emailLst) {
                            %>
					<tr style="cursor: pointer" id="row">
					    <td>
						<%
						    if (emailWbo.getAttribute("clntNo") != null) {
						%>
							<b>
							     <%=emailWbo.getAttribute("clntNo")%> 
							</b>
						<%
						    }
						%>
					    </td>
					    
					    <td>
						<%
						    if (emailWbo.getAttribute("clntName") != null) {
						%>
							<b>
							     <%=emailWbo.getAttribute("clntName")%> 
							</b>
						<%
						    }
						%>
					    </td>
					    
					    <td>
						<%
						    if (emailWbo.getAttribute("clntEmail") != null) {
						%>
							<b>
							     <%=emailWbo.getAttribute("clntEmail")%> 
							</b>
						<%
						    }
						%>
					    </td>
					    
					    <td>
						<%
						    if (emailWbo.getAttribute("subject") != null) {
						%>
							<b>
							     <%=emailWbo.getAttribute("subject")%> 
							</b>
						<%
						    }
						%>
					    </td>
					    
					    <td>
						<%
						    if (emailWbo.getAttribute("body") != null) {
						%>
							<b>
							     <%=emailWbo.getAttribute("body")%> 
							</b>
						<%
						    }
						%>
					    </td>
					    
					    <td>
						<%
						    if (emailWbo.getAttribute("sentTime") != null) {
						%>
							<b>
							     <%=emailWbo.getAttribute("sentTime").toString().split(" ")[0]%> 
							</b>
						<%
						    }
						%>
					    </td>
					    
					    <%
						if(my == null){
					    %>
						    <td>
							<%
							    if (emailWbo.getAttribute("sentBy") != null) {
							%>
								<b>
								     <%=emailWbo.getAttribute("sentBy")%> 
								</b>
							<%
							    }
							%>
						    </td>
					    <%
						}
					    %>
					</tr>
                            <%
				    }
				}
			    %>
                        </tbody>
                    </table>
                </div>
	    </form>
	</fieldset>
    </body>
</html>
