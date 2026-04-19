<%-- 
    Document   : employeesWithdraws
    Created on : Nov 26, 2017, 11:52:12 AM
    Author     : shimaa
--%>

<%@page import="java.util.List"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    ArrayList<WebBusinessObject> withdrawLst = request.getAttribute("withdrawLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("withdrawLst") : null;
    ArrayList<WebBusinessObject> users = request.getAttribute("users") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("users") : null;
    
    String my = request.getAttribute("my") != null ? (String) request.getAttribute("my") : "0";
    
    String disStatus = request.getAttribute("disStatus") != null ? (String) request.getAttribute("disStatus") : null;
    
    ArrayList<WebBusinessObject> requestTypes = request.getAttribute("requestTypes") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("requestTypes") : null;
    
    ArrayList<WebBusinessObject> distributionsList = request.getAttribute("distributionsList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("distributionsList") : null;
    
    ArrayList<WebBusinessObject> usersIDsList = request.getAttribute("usersIDsList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("usersIDsList") : null;
    
    ArrayList<WebBusinessObject> salesEmployees = (ArrayList<WebBusinessObject>) request.getAttribute("salesEmployees");
    
    Calendar cal = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());
    cal.add(Calendar.DAY_OF_MONTH, -3);
    String beDate = request.getAttribute("beginDate") != null ? (String) request.getAttribute("beginDate") : sdf.format(cal.getTime());
    String eDate = request.getAttribute("endDate") != null ? (String) request.getAttribute("endDate") : nowTime;
    
    String createdBy = (String) request.getAttribute("createdBy");
    String source = (String) request.getAttribute("source");
    
    String stat = (String) request.getSession().getAttribute("currentMode");
    String title, fDateStr, tDateStr, srch, clntNm, clntNo,
            clntMb, clntPh, clntIntPh, dstTo, wdWth, wdTime, rqTyp,
            dstMsg, withD, withDf;
    if(stat.equals("En")){
	if(my != null && my.equals("1")){
	    title = " My Drawing ";
	} else {
	    title = " All Withdrawals ";
	}
	
	fDateStr = " From Date ";
	tDateStr = " To Date ";
	srch = " Search ";
	clntNo = " Client No. ";
	clntNm = " Client Name ";
	clntMb = " Mobile ";
	clntPh = " Phone ";
	clntIntPh = " International Phone ";
	dstTo = " Distributed For ";
	wdWth = " Withdrawn By";
	wdTime = " Withdrawal Date ";
	
	rqTyp = " Request Type ";
	
	dstMsg = " Clients Distributed Successfully ";
        
        withD = "Withdrawer";
        withDf = "Withdraw From";
    } else {
	if(my != null && my.equals("1")){
	    title = " مسحوباتى ";
	} else {
	    title = " كل المسحوبات  ";
	}
	
	fDateStr = " من تاريخ ";
	tDateStr = " إلى تاريخ ";
	srch = " بحث ";
	clntNo = " رقم العميل ";
	clntNm = " إسم العميل ";
	clntMb = " الموبايل ";
	clntPh = " التليفون ";
	clntIntPh = " الرقم الدولى ";
	dstTo = " وزع إلى ";
	wdWth = " سحب بواسطة ";
	wdTime = " تاريخ السحب ";
	
	rqTyp = " نوع الطلب  ";
	dstMsg = " تم توزيع العملاء بنجاح ";
        
        withD = "الساحب";
        withDf = "المسحوب منه ";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Withdraw Report </title>
	
	<script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
	
	<script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
	
	<script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
	
	<script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
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
	    $(document).ready(function(){
                $("#createdBy").select2();
                $("#source").select2();
                
		$("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd"
                });
		
		$('#withdrawTbl').dataTable({
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
		
		$("#employeeId").select2();
	    });
	    
	    
	    function getWithDraws(){
                var createdBy = $("#createdBy option:selected").val();
                var source = $("#source option:selected").val();
		document.withdraw_report_form.action = "<%=context%>/ReportsServletThree?op=employeesWithdraws&my=" + <%=my%> + "&createdBy=" + createdBy + "&source="+source;
		document.withdraw_report_form.submit();
	    }
	    
	    function selectAllClnt(){
		var selectAll = $("#selectAll").val();
		
		if(selectAll != null && selectAll == "off"){
		     $("#selectAll").val("on");
		     
		     $("input[name=customerId]").prop("checked", true);
		} else if(selectAll != null && selectAll == "on"){
		     $("#selectAll").val("off");
		     
		     $("input[name=customerId]").prop("checked", false);
		}
	    }
	    
	    function distribution(mode) {
                if (!validateData("req", document.withdraw_report_form.requestType, "من فضلك اختار نوع الطلب...")) {
                    $("#requestType").focus();
                } else if ($("input[name=customerId]:checked").length <= 0) {
                    alert(" Choose At Least One Client ");
                } else if ($("#employeeId option:selected").length <= 0) {
                    alert(" Choose At Least One Employee ");
		    $("#employeeId").focus();
                } else {
                    $("#manualBTN").attr("disabled", "true");
                    $("#autoBtn").attr("disabled", "true");
                    var loggedOnly = $("#loggedOnly").is(":checked");
                    document.withdraw_report_form.action = "<%=context%>/AutoPilotModeServlet?op=distributeWithdrawemployeesClients&mode=" + mode + "&fromURL=unHandledClients" + "&loggedOnly=" + loggedOnly + "&requestType=" + $("#requestType").val();
                    document.withdraw_report_form.submit();
                }
            }
	</script>
    </head>
    <body>
	<fieldset class="set" style="width: 80%;">
	    <legend align="center">
		<font color="blue" size="6">
		     <%=title%> 
		</font>
	    </legend>
		
	    <form id="withdraw_report_form" name="withdraw_report_form" method="post">
		<table style="width: 60%; padding-bottom: 2%; padding-top: 2%; margin-bottom: 2%; margin-top: 2%;">
		    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 33%;">
                            <font size=3 color="white">
				 <%=fDateStr%> 
                        </td>
                        
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 33%;">
                            <font size=3 color="white">
				 <%=tDateStr%> 
                        </td>
                        
                        
                        <td bgcolor="#F7F6F6" style="text-align:center; width: 33%; border: none;" valign="middle" rowspan="2">
                            <button class="button" class="button2" onclick="getWithDraws();" style="width: 50%; color: #27272A; font-size:15; font-weight:bold;">
                                 <%=srch%> 
                                 <IMG HEIGHT="15" SRC="images/search.gif" > 
                            </button>  
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="text-align:center; height: 100%; padding: 10px;  border: none;" bgcolor="#F7F6F6" valign="MIDDLE" >
                             <input id="beginDate" name="beginDate" type="text" value="<%=beDate != null && !beDate.isEmpty() ? beDate : ""%>" readonly /> 
                        </td>
                        
                        <td bgcolor="#F7F6F6" style="text-align:center; height: 100%; padding: 10px;  border: none;" valign="middle"> 
                             <input id="endDate" name="endDate" type="text" value="<%=eDate != null && !eDate.isEmpty() ? eDate : ""%>" readonly /> 
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 33%;">
                            <font size=3 color="white">
				 <%=withDf%> 
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 33%;">
                            <font size=3 color="white">
				 <%=withD%> 
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="width: 33%;">
                            <select style="float: right;width: 180px;" id="createdBy">
                                <option value="all">all</option>
                                <sw:WBOOptionList wboList="<%=users%>" displayAttribute="fullName" valueAttribute="userId" scrollToValue='<%=createdBy%>'/>
                            </select>
                        </td>
                        <td class="blueBorder blueHeaderTD" style=" width: 33%;">
                            <select style="float: right;width: 180px;" id="source">
                                <option value="all">all</option>
                                <sw:WBOOptionList wboList="<%=users%>" displayAttribute="fullName" valueAttribute="userId" scrollToValue='<%=source%>'/>
                            </select> 
                        </td>
                    </tr>
		</table>
			
		<%
		    if(my != null && my.equals("0")){
		%>
			<table ALIGN="center" DIR="RTL" bgcolor="#dedede" WIDTH="60%" style="border: none; padding-bottom: 2%; padding-top: 2%; margin-bottom: 2%; margin-top: 2%;" CELLSPACING=2 CELLPADDING=1>
			    <tr>
				<td style="font-size:18px; text-align: right" WIDTH="1%">
				    <button id="autoBtn" type="button" onclick="JavaScript: distribution('auto');" value="" style="margin-left: 5%; text-align: center; width: 150px; font-size: 16px; color: blue; font-weight: bold; display: none;">
					Auto-Pilot
					<img src="images/icons/plane_icon.png" height="24" width="24" alt="distribute client" style="vertical-align: middle" />
				    </button>
				    <input type="checkbox" id="loggedOnly" value="1" style="display: none;"/> <span style="display: none;">Logged Only</span>
				</td>
				<td style="font-size:18px; text-align: right" WIDTH="33%">
				    <select name="requestType" id="requestType" style="width: 200px; font-size: 18px;">
					<option value="" style="color: blue;"> <%=rqTyp%> </option>
					<sw:WBOOptionList wboList="<%=requestTypes%>" displayAttribute="projectName" valueAttribute="projectName" />
				    </select>
				</td>
				<td style="font-size:14px; text-align: left; border-left-width: 0px" WIDTH="33%">
				    <button id="manualBTN" type="button" onclick="JavaScript: distribution('manual');" value="" style="margin-left: 5%; text-align: center; width: 150px; font-size: 16px; color: blue; font-weight: bold;">
					Manual
					<img src="images/icons/manual_pilot.png" height="24" width="24" alt="distribute client" style="vertical-align: middle" />
				    </button>
				</td>

				<td style="font-size:16px; color: blue; text-align: right; border-right-width: 0px; border-left-width: 0px" WIDTH="33%">
				    <select name="employeeId" id="employeeId" style="font-size: 14px;font-weight: bold; width: 99%; height: 25px" class="" multiple>
					<%
					    for (WebBusinessObject userWbo : distributionsList) {
					%>
						<option value="<%=userWbo.getAttribute("userId")%>" style="<%=usersIDsList.contains(userWbo.getAttribute("userId")) ? "color: red; font-weight: bold;" : ""%>"><%=userWbo.getAttribute("fullName")%></option>
					<%
					    }
					%>
				    </select>
				    <select name="salesEmployeeId" id="salesEmployeeId" style="font-size: 14px;font-weight: bold; width: 99%; height: 25px; display: none">
					<sw:WBOOptionList wboList='<%=salesEmployees%>' displayAttribute="fullName" valueAttribute="userId"/>
				    </select>
				</td>
			    </tr>
			</table>
		<%
		    }
	        %>
		
		<%
		    if(disStatus != null && disStatus.equals("saved")){
		%>
			<label style="color: green; font-size: 25px">
			     <%=dstMsg%> 
			</label>
		<%
		    }
		%>
		
		<div style="width: 80%;  padding-bottom: 2%; padding-top: 2%; margin-bottom: 2%; margin-top: 2%;">
		    <table id="withdrawTbl" style="width: 100%;">
			<thead>
			    <tr>
				<th style="width: 1%;">
				    <input type="checkbox" id="selectAll" name="select" value="off" onclick="selectAllClnt();">
				</th>
				
				<th style="width: 5%;">
				     <%=clntNo%> 
				</th>

				<th style="width: 14%;">
				     <%=clntNm%> 
				</th>

				<th style="width: 12%;">
				     <%=clntMb%> 
				</th>

				<th style="width: 12%;">
				     <%=clntPh%> 
				</th>

				<th style="width: 12%;">
				     <%=clntIntPh%> 
				</th>

				<th style="width: 14%;">
				     <%=dstTo%> 
				</th>

				<th style="width: 14%;">
				     <%=wdWth%> 
				</th>

				<th style="width: 16%;">
				     <%=wdTime%> 
				</th>
			    </tr>
			</thead>
			
			<tbody>
			    <%
				if(withdrawLst != null && !withdrawLst.isEmpty()){
				    WebBusinessObject withdrawWbo = new WebBusinessObject();
				    
				    for (int i = 0; i < withdrawLst.size(); i++) {
					withdrawWbo = withdrawLst.get(i);
			    %>
				<tr>
				    <td>
					<input type="checkbox" id="<%=withdrawWbo.getAttribute("clntID")%>" name="customerId" value="<%=withdrawWbo.getAttribute("clntID")%>">
				    </td>
				    
				    <td>
					 <%=withdrawWbo.getAttribute("clientNo")%> 
				    </td>

				    <td>
					 <%=withdrawWbo.getAttribute("clientName")%> 
				    </td>

				    <td>
					<%=withdrawWbo.getAttribute("mobile") != null && !withdrawWbo.getAttribute("mobile").equals("UL") ? withdrawWbo.getAttribute("mobile") : ""%> 
				    </td>

				    <td>
					 <%=withdrawWbo.getAttribute("phone") != null && !withdrawWbo.getAttribute("phone").equals("UL") ? withdrawWbo.getAttribute("phone") : ""%> 
				    </td>

				    <td>
					 <%=withdrawWbo.getAttribute("interPhone") != null && !withdrawWbo.getAttribute("interPhone").equals("UL") ? withdrawWbo.getAttribute("interPhone") : ""%> 
				    </td>

				    <td>
					 <%=withdrawWbo.getAttribute("owner")%> 
				    </td>

				    <td>
					 <%=withdrawWbo.getAttribute("withdrawedBy")%> 
				    </td>

				    <td>
					 <%=withdrawWbo.getAttribute("withdrawedTime")%> 
				    </td>
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
