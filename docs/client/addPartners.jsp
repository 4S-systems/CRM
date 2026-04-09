<%-- 
    Document   : addPartners
    Created on : Nov 28, 2017, 9:48:50 AM
    Author     : fatma
--%>

<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    String oClntID = request.getAttribute("oClntID") != null ? (String) request.getAttribute("oClntID") : "";
    String unitCode = request.getAttribute("unitCode") != null ? (String) request.getAttribute("unitCode") : "";
    String srchVl = request.getAttribute("srchVl") != null ? (String) request.getAttribute("srchVl") : "";
    ArrayList<WebBusinessObject> clntLst = request.getAttribute("clntLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("clntLst") : null;
	
    String stat = (String) request.getSession().getAttribute("currentMode");
    
    String slctPrtnr, sTitle, dir, direction, srch, slctAll, clntNo, clntNm, clntMb, clntPh, clntIntrPh, 
	    clntEml, addPrtnr;
    
    if (stat.equals("En")) {
	slctPrtnr = " Select At Least One Partner ";
	sTitle = " Client List ";
	dir = "ltr";
	direction = "left";
	srch = " Search ";
	slctAll = " Select All ";
	clntNo = " CLient No. ";
	clntNm = " Name ";
	clntMb = " Mobile ";
	clntPh = " Phone ";
	clntIntrPh = " International No. ";
	clntEml = " E-Mail ";
	addPrtnr = " Add Partners ";
    } else {
	slctPrtnr = " إختر شريك واحد على الأقل ";
	sTitle = " قائمة العملاء ";
	dir = "rtl";
	direction = "right";
	srch = " بحث ";
	slctAll = " تحديد الكل ";
	clntNo = " كود العميل ";
	clntNm = " الإسم ";
	clntMb = " الموبايل ";
	clntPh = " التليفون ";
	clntIntrPh = " الرقم الدولى ";
	clntEml = " البريد الإلكترونى ";
	addPrtnr = " إضافة شركاء ";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> Add Partners </title>
	
	<link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="//code.jquery.com/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
	
	<link rel="stylesheet" href="css/demo_table.css">
	<script type="text/javascript" src="js/jquery.dataTables.js"></script>
	
	<style>
	    .button2{
		font-family: "Script MT", cursive;
		font-size: 18px;
		font-style: normal;
		font-variant: normal;
		font-weight: 400;
		line-height: 20px;
		width: 134px;
		height: 32px;
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
	</style>
	    
	<script>
	    $(document).ready(function(){
		$('#clntLst').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[-1], ["All"]],
                    iDisplayLength: -1,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
	    });
	    
	    function getClient() {
		document.ADD_PARTNERS_FORM.action = "<%=context%>/UnitServlet?op=addPartner&srch=1&vl=" + $("#searchValue").val() + "&oClntID=" + $("#oClntID").val() + "&unitCode=" + $("#unitCode").val();
		document.ADD_PARTNERS_FORM.submit();
	    }
	    
	    function selectAll(){
		//slct
		
		if($("#slctAll").val() == "off"){
		    $("input[name='slct']").each(function(){
			$(this).prop("checked", true);
		    });
		    
		    $("#slctAll").val("on");
		} else if($("#slctAll").val() == "on"){
		    $("input[name='slct']").each(function(){
			$(this).prop("checked", false);
		    });
		    
		    $("#slctAll").val("off");
		}
	    }
	    
	    function addPrtnr(){
		if($("input[name='slct']:checked").length > 0){
		    document.ADD_PARTNERS_FORM.action = "<%=context%>/UnitServlet?op=addPartner&srch=0&oClntID=" + $("#oClntID").val() + "&unitCode=" + $("#unitCode").val();
		    document.ADD_PARTNERS_FORM.submit();

		    window.close();
		} else {
		    $("#errorMsg").fadeIn();
		}
	    }
	</script>
    </head>
    
    <body>
	<center>
	    <form name="ADD_PARTNERS_FORM" method="POST">
		<div style="display: none; width: 90%; margin-top: 10px; margin-left: auto; margin-right: auto; height: 20px; background-color: #f3f3f5;" id="errorMsg">
		    <font style="color: red; font-size: 16px;">
			<b>
			     <%=slctPrtnr%> 
			</b>
		    </font>
		</div>

		<FIELDSET style="width: 90%; border-color: #006699; border" >
		    <legend align="center" width="80%">
			<font color="#005599" size="4">
			     <%=sTitle%> 
			</font>
		    </legend>

		    <table align="center" dir="<%=dir%>" width="90%" bgcolor="#dedede">
			<tr>
			    <td style="border: none;" width="50%">
				<img src="images/user.ico" width="190" style="border: none; vertical-align: middle;" />
			    </td>

			    <td style="border: none;" width="50%">
				<input type="text" name="searchValue" id="searchValue" value="<%=srchVl%>"/>
				<input type="button" class="button2" value=" <%=srch%> " width="40%" onclick="getClient();"/>
			    </td>
			</tr>
			
			<tr>
			    <td style="border: none; text-align: center;" width="50%" colspan="2">
				<input type="button" class="button2" value=" <%=addPrtnr%> " width="40%" onclick="addPrtnr();" style="text-align: center;"/>
			    </td>
			</tr>
		    </table>
		    
		    <div style="width: 90%;">
			<table id="clntLst" name="clntLst"  style="width: 100%; direction: <%=dir%>">
			    <thead>
				<tr>
				    <th style="width: 1%;">
					 <input type="checkbox" id="slctAll" name="slctAll" value="off" onclick="selectAll()"> 
				    </th>

				    <th style="width: 16%;">
					 <%=clntNo%> 
				    </th>

				    <th style="width: 17%;">
					 <%=clntNm%> 
				    </th>

				    <th style="width: 16%;">
					 <%=clntMb%> 
				    </th>

				    <th style="width: 16%;">
					 <%=clntPh%> 
				    </th>

				    <th style="width: 17%;">
					 <%=clntIntrPh%> 
				    </th>

				    <th style="width: 17%;">
					 <%=clntEml%> 
				    </th>
				</tr>
			    </thead>
			    
			    <tbody>
				<%
				    if(clntLst != null && !clntLst.isEmpty()){
					for(WebBusinessObject clntWbo : clntLst){
				%>
				    <tr>
					<td>
					     <input type="checkbox" id="slct<%=clntWbo.getAttribute("clntID")%>" name="slct" value="<%=clntWbo.getAttribute("clntID")%>"> 
					</td>
					
					<td>
					     <%=clntWbo.getAttribute("clntNo")%> 
					</td>
					
					<td>
					     <%=clntWbo.getAttribute("clntNm")%> 
					</td>
					
					<td>
					     <%=clntWbo.getAttribute("clntMb")%> 
					</td>
					
					<td>
					     <%=clntWbo.getAttribute("clntPh") != null && !clntWbo.getAttribute("clntPh").equals("UL")? clntWbo.getAttribute("clntPh") : ""%> 
					</td>
					
					<td>
					     <%=clntWbo.getAttribute("clntIntPh") != null && !clntWbo.getAttribute("clntIntPh").equals("UL")? clntWbo.getAttribute("clntIntPh") : ""%>  
					</td>
					
					<td>
					    <%=clntWbo.getAttribute("clntEML") != null && !clntWbo.getAttribute("clntEML").equals("UL")? clntWbo.getAttribute("clntEML") : ""%> 
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
			    
		<input type="hidden" name="oClntID" id="oClntID" value="<%=oClntID%>"/>
		<input type="hidden" name="unitCode" id="unitCode" value="<%=unitCode%>"/>
	    </form>
	</center>
    </body>
</html>
