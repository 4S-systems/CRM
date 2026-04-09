<%-- 
    Document   : lstClntMails
    Created on : Nov 7, 2017, 12:37:59 PM
    Author     : fatma
--%>

<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    ArrayList<WebBusinessObject> ratesList = request.getAttribute("ratesList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("ratesList") : null;
    String mainClientRate = request.getAttribute("mainClientRate") != null ? (String) request.getAttribute("mainClientRate") : "";

    String up = request.getAttribute("up") != null ? (String) request.getAttribute("up") : "";

    ProjectMgr projectMgr = ProjectMgr.getInstance();
    ArrayList<WebBusinessObject> projectsList = request.getAttribute("projectsList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("projectsList") : new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKey("44", "key4"));
    String mainClientPrj = request.getAttribute("mainClientPrj") != null ? (String) request.getAttribute("mainClientPrj") : "";
    
    ArrayList<WebBusinessObject> clientsList = request.getAttribute("clientsList") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("clientsList") : null;
    
    Calendar c = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    
    String toDate = sdf.format(c.getTime());
    if (request.getAttribute("toDate") != null) {
	toDate = (String) request.getAttribute("toDate");
    }
    
    c.add(Calendar.DATE, -1);
    String fromDate = sdf.format(c.getTime());
    if (request.getAttribute("fromDate") != null) {
	fromDate = (String) request.getAttribute("fromDate");
    }
	
    String stat = (String) request.getSession().getAttribute("currentMode");
    String title, dir, nDir, direction, nDirection, fromDateTitle, toDateTitle, clntCls, all, srch, add, clntNo, clntNm, clntPhn;
    String clntMb, intrNum, mail, projct, addTm, src, clntPrj, save, addmail;
    
    if (stat.equals("En")) {
	title = " Choose Clients ";
	dir = "LTR";
	nDir = "RTL";
	direction = "left";
	nDirection = "right";
	fromDateTitle = " From Date ";
	toDateTitle = " To Date ";
	clntCls = " Classification ";
	clntPrj = " Projects ";
	all = " All ";
	srch = " Search ";
	add = " Add To Send E-mail ";
	clntNo = " Client No. ";
	clntNm = " Name ";
	clntPhn = " Phone ";
	clntMb = " Mobile ";
	intrNum = " International Number ";
	mail = " E-Mail ";
	projct = " Project ";
	addTm = " Addition Time ";
	src = " Source ";
	save = " Save ";
	addmail = " Add E-mail ";
    } else {
	title = " إختيار العملاء ";
	dir = "RTL";
	nDir = "LTR";
	direction = "right";
	nDirection = "left";
	fromDateTitle = " من تاريخ ";
	toDateTitle = " إلى تاريخ ";
	clntCls = " التصنيف ";
	clntPrj = " المشروع ";
	all = " الكل ";
	srch = " بحث";
	add = " إضافة لإرسال بريد إلكترونى ";
	clntNo = " رقم العميل ";
	clntNm = " الإسم ";
	clntPhn = " التليفون ";
	clntMb = " الموبايل ";
	intrNum = " الرقم الدولى ";
	mail = " البريد الإلكترونى ";
	addTm = " تاريخ الإضافة ";
	src = " المصدر ";
	save = " حفظ ";
	addmail = " إضافة بريد إلكترونى ";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> My Client List </title>
	
	<script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
	<link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" href="css/blueStyle.css"/>
        <link rel="stylesheet" href="css/Button.css"/>
	
	<script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>
	<link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />
	
	<script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
	<link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
	
	<script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
	
	<script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
	
	<style type="text/css">
            .remove{
                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);
            }
	    
            #showHide{
                padding: 10px;
                font-size: 16px;
                font-weight: bold;
                color: #0066cc;
                cursor: pointer;
                padding: 5px;
            }
	    
            #dropDown{
                position: relative;
            }
	    
            .backStyle{
                border-bottom-width:0px;
                border-left-width:0px;
                border-right-width:0px;
                border-top-width:0px
            }
	    
            .datepick {}
	    
            .save {
                width:20px;
                height:20px;
                background-image:url(images/icons/icon-32-publish.png);
                background-repeat: no-repeat;
                cursor: pointer;
            }
	    
            .silver_odd_main,.silver_even_main {
                text-align: center;
            }
	    
            input { font-size: 18px; }
	    
            textarea{
                resize:none;
            }
	    
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
            }
	    
            #claim_division {
                width: 97%;
                display: none;
                margin:3px auto;
                border: 1px solid #999;
            }
	    
            #order_division{
                width: 97%;
                display: none;
                margin:3px auto;
                border: 1px solid #999;
            }
	    
            label{
                font:Verdana, Geneva, sans-serif;
                font-size:14px;
                font-weight:bold;
                color:#005599;
            }
	    
            .login {
                direction: rtl;
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
                /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzdhYmNmZiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM0MDk2ZWUiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
	    
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                margin-bottom: 30px;
            }
	    
            .dropdown 
            {
                color: #555;
                width: 128px;
                position: relative;
                height: 17px;
                text-align:left;
            }
	    
            .dropdown li a 
            {
                color: #555555;
                display: block;
                font-family: arial;
                font-weight: bold;
                padding: 6px 15px;
                cursor: pointer;
                text-decoration:none;
            }
	    
            .dropdown li a:hover
            {
                background:#155FB0;
                color:yellow;
                text-decoration: none;
            }
	    
            .submenux
            {
                background:#FFFFCC;
                position: absolute;
                top: 30px;
                left:0px;
                width: 120px;
                display: none;
                margin-left: 0px;;
                padding: 0px 0 5px;
                border-radius: 6px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.45);
            }
	    
            .submenuxx{
                background:#FFFFCC;
                position: absolute;
                top: 30px;
                left:30px;
                width: 120px;
                display: none;
                margin-left: 0px;;
                padding: 0px 0 5px;
                border-radius: 6px;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.45);
            }
	    
            #call_center{
                direction:rtl;
                padding:0px;
                margin-top: 10px;
                margin-left: auto;
                margin-right: auto;
                margin-bottom: 5px;
                color:#005599;
                width:98%;
                border:1px solid #f1f1f1;
                font:Verdana, Geneva, sans-serif;
                font-size:18px;
                font-weight:bold;
            }
	    
            #title{
		padding:10px;
	       margin:0px 10px;
	       height:30px;
	       width:95%;
	       clear: both;
	       text-align:center;
            }
	    
            .text-success{
                font-family:Verdana, Geneva, sans-serif;
                font-size:24px;
                font-weight:bold;
            }
	    
            #tableDATA th{
                font-size: 15px;
            }
	    
            .save {
                width:32px;
                height:32px;
                background-image:url(images/icons/check.png);
                background-repeat: no-repeat;
                cursor: pointer;
            }
	    
            .status{
                width:32px;
                height:32px;
                background-image:url(images/icons/status.png);
                background-repeat: no-repeat;
                cursor: pointer;
            }
	    
            .remove {
                width:32px;
                height:32px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/remove.png);
            }
	    
            .button_commx {
                width:135px;
                height:29px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/comm.png);
            }
	    
            .button_attach{
                width:128px;
                height:27px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/attach.png);
            }
	    
            .button_bookmar {
                width:135px;
                height:29px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/bookmark.png);
            }
	    
            .button_redirec{
                width:132px;
                height:29px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/redi.png);
            }

            .button_finis{
                width:135px;
                height:29px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/finish.png);
            }
	    
            .button_clos {
                width:135px;
                height:29px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/close.png);
            }
	    
            .rejectedBtn{
                width:145px;
                height:40px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/button5.png);
            }
	    
            .attach_button{
                width:145px;
                height:40px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/attachF.png);
            }
	    
            .button_clientO{
                width:135px;
                height:29px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/clientO.png);
            }
	    
	    .managerBt{
                width:135px;
                height:29px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/manager.png);
            }
	    
            .popup_conten{ 
                border: none;
                direction:rtl;
                padding:0px;
                margin-top: 10px;
                border: 1px solid tomato;
                background-color: #f1f1f1;
                margin-bottom: 5px;
                width: 300px;
                font:Verdana, Geneva, sans-serif;
                font-size:18px;
                font-weight:bold;
                display: none;
            }
	    
            .ui-tooltip, .arrow:after {
                background: lightblue;
                border: 2px solid white;
            }
	    
            .ui-tooltip {
                padding: 10px 20px;
                color: black;
                border-radius: 20px;
                font: bold 14px "Helvetica Neue", Sans-Serif;
                text-transform: uppercase;
                box-shadow: 0 0 7px black;
            }
	    
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
	    
            .arrow {
                width: 70px;
                height: 16px;
                overflow: hidden;
                position: absolute;
                left: 50%;
                margin-left: -35px;
                bottom: -16px;
            }
	    
            .arrow.top {
                top: -16px;
                bottom: auto;
            }
	    
            .arrow.left {
                left: 20%;
            }
	    
            .arrow:after {
                content: "";
                position: absolute;
                left: 20px;
                top: -20px;
                width: 25px;
                height: 25px;
                box-shadow: 6px 5px 9px -9px black;
                -webkit-transform: rotate(45deg);
                -moz-transform: rotate(45deg);
                -ms-transform: rotate(45deg);
                -o-transform: rotate(45deg);
                tranform: rotate(45deg);
            }
	    
            .arrow.top:after {
                bottom: -20px;
                top: auto;
            }
        </style>
	
	<script>
	    $(function() {
		$("#fromDate, #toDate").datepicker({
		    changeMonth: true,
		    changeYear: true,
		    maxDate: 0,
		    dateFormat: "yy-mm-dd"
		});
		
		try {
                    $("#mainClientRate").msDropDown();
                } catch (e) {
                    alert(e.message);
                }
		
		 $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[-1], [""]],
                    iDisplayLength: -1,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[2, "asc"]]
                }).fadeIn(2000);
		
		$("#mainClientPrj").select2();
	    });
	    
	    function validateEmail(email){
		var re = /\S+@\S+\.\S+/;
		return re.test(email);
	    }

	    function insertAllSelected() {
		// For Email
		var mailsList = $("[name='toMails']", window.opener.document);
		var checkList = $("[name='clientID']:checked");
		if(mailsList != 'undefined') {
		    checkList.each(function(){
			var clientID = this.value;
			if($("#email" + clientID).val() != '' && validateEmail($("#email" + clientID).val())) {
			    if($("#toMails option[value='"+ $("#email" + clientID).val() +"']", window.opener.document).length == 0){
				mailsList.append("<option value='" + $("#email" + clientID).val() + "'>" + $("#email" + clientID).val() + "</option>");
			    }
			}
		    });
		    opener.selectAllItems();
		}
	    }
	    
	    function chngMail(clntID){
		$("#updateMail").bPopup();
		$('#updateMail').css("display", "block");
		
		$("#nwClntEmail").val(clntID);
	    }
	    
	    function closePopup(){
		$("#updateMail").bPopup().close();
	    }
	    
	    function upMail(){
		var email = $("#nwEmail").val();
		
		if(validateEmail(email)){
		    document.client_form.action = "<%=context%>/ClientServlet?op=salesMail&ppu=1&up=1&nwEmail=" + $("#nwEmail").val() + "&nwClntEmail=" + $("#nwClntEmail").val();
		    document.client_form.submit();
		} else {
		    alert(" Please, Edit E-mail Format To urmail@yahoo.com ");
		}
	    }
	    
	    
	    function checkAll(){
		if($("#selectAll").val() == "off"){
		    $("input[name=clientID]").prop("checked", true);
		    $("#selectAll").val("on");
		} else if($("#selectAll").val() == "on"){
		    $("input[name=clientID]").prop("checked", false);
		    $("#selectAll").val("off");
		}
	    }
	</script>
    </head>
    <body>
	<center>
	    <fieldset class="set" align="center" style="width: 90%; border-color: #006699;">
		<LEGEND style="font-size: 20px;">
		    <span>
			 <%=title%> 
		    </span>
		</LEGEND>
		    
		    <%
			if (up.equals("1")) {
		    %>
			<div style="margin-left: auto;margin-right: auto;color: green;"> تم التعديل بنجاح </div>
		    <%
			} else if (up.equals("0")) {
		    %>
			<div style="margin-left: auto;margin-right: auto;color: red;">لم يتم التعديل</div>
		    <%
			}
		    %>

		<form id="client_form" name="client_form" method="post">
		    <TABLE ALIGN="center" DIR="<%=dir%>" WIDTH="50%">
			<tr>
			    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
				<b>
				    <font size=3 color="white">
					 <%=fromDateTitle%> 
				</b>
			    </td>

			    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
				<b>
				    <font size=3 color="white">
					 <%=toDateTitle%> 
				</b>
			    </td>
			</tr>

			<tr>
			    <td style="text-align: center;" bgcolor="#dedede" valign="MIDDLE">
				<input id="fromDate" name="fromDate" type="text" value="<%=fromDate%>" style="width: 80%;"/>
			    </td>

			    <td  bgcolor="#dedede" style="text-align: center;" valign="middle">
				<input id="toDate" name="toDate" type="text" value="<%=toDate%>" style="width: 80%;"/>

			    </td>
			</tr>

			<TR>
			    <TD class="blueBorder blueHeaderTD" style="font-size: 18px;" WIDTH="50%">
				<b>
				    <font size=3 color="white">
					 <%=clntCls%> 
				    </font>
				</b>
			    </TD>
			    
			    <TD class="blueBorder blueHeaderTD" style="font-size: 18px;" WIDTH="50%">
				<b>
				    <font size=3 color="white">
					 <%=clntPrj%> 
				    </font>
				</b>
			    </TD>
			</tr>

			<tr>
			    <TD style="text-align: center;" bgcolor="#dedede" valign="MIDDLE" WIDTH="50%">
				<select style="font-size: 14px; font-weight: bold; width: 90%;" id="mainClientRate" name="mainClientRate">
				    <option value="" selected> <%=all%> </option>
				    <%
					for (WebBusinessObject rateWbo : ratesList) {
				    %>
					    <option value="<%=rateWbo.getAttribute("projectID")%>" <%=rateWbo.getAttribute("projectID").equals(request.getAttribute("mainClientRate")) ? "selected" : ""%>  data-image="images/msdropdown/<%="UL".equals(rateWbo.getAttribute("optionThree")) ? "black" : rateWbo.getAttribute("optionThree")%>.png"><%=rateWbo.getAttribute("projectName")%> </option>
				    <%
					}
				    %>
				</select>

				<input type="hidden" name="op" value="getClientsWithDetails"/>

				<%--<input type="hidden" name="<%=forPopup != null && forPopup.equals("true") ? "forPopup" : "forFull"%>" value="true"/>--%>
			    </TD>
			    
			    <TD style="text-align: center;" bgcolor="#dedede" valign="MIDDLE" WIDTH="50%">
				<select style="font-size: 14px; font-weight: bold; width: 90%;" id="mainClientPrj" name="mainClientPrj">
				    <option value="" selected> <%=all%> </option>
				    <%
					for (WebBusinessObject prjWbo : projectsList) {
				    %>
					    <option value="<%=prjWbo.getAttribute("projectID")%>" <%=prjWbo.getAttribute("projectID").equals(request.getAttribute("mainClientPrj")) ? "selected" : ""%>> <%=prjWbo.getAttribute("projectName")%> </option>
				    <%
					}
				    %>
				</select>


				
			    </TD>
			</TR>

			<tr>
			    <TD STYLE="text-align: center;" CLASS="td" colspan="2">  
				<button type="submit" class="button2" STYLE="color: #000; font-size:15; margin-top: 20px; font-weight: bold; width: 25%; text-align: center;">
				     <%=srch%> 
				     <IMG HEIGHT="15" SRC="images/search.gif"> 
				</button> 
			    </td>
			</tr>
		    </table>
				     
		 <input type="button" class="button2" style="text-align: center; width: 25%;" onclick="insertAllSelected();" value=" <%=add%> "/>
		    <table id="clients" style="width: 100%; border-width: thin; border-color: black;" dir="rtl">
			<THEAD>
			    <TR >
				<th style="color: #005599 !important;font: 14px; font-weight: bold;">
				    <input type="checkbox" id="selectAll" name="selectAll" onchange="checkAll();" value="off"/>
				</th>

				<th style="color: #005599 !important;font: 14px; font-weight: bold;">
				     <%=clntNo%> 
				</th>

				<th style="color: #005599 !important;font: 14px; font-weight: bold;">
				     <%=clntNm%> 
				</th>

				<th style="color: #005599 !important;font: 14px; font-weight: bold;">
				     <%=clntPhn%> 
				</th>

				<th style="color: #005599 !important;font: 14px; font-weight: bold;">
				     <%=clntMb%> 
				</th>

				<th style="color: #005599 !important;font: 14px; font-weight: bold;">
				     <%=intrNum%> 
				</th>

				<th style="color: #005599 !important;font: 14px; font-weight: bold;">
				     <%=mail%> 
				</th>

				<th style="color: #005599 !important;font: 14px; font-weight: bold;">
				     <%=addTm%> 
				</th>

				<th style="color: #005599 !important;font: 14px; font-weight: bold;"> 
				     <%=addmail%>
				</th>
			    </TR>
			</THEAD>

			<tbody>
			    <% 
				for (int x = 0; x < clientsList.size(); x++) {
				    WebBusinessObject wboClient = new WebBusinessObject();
				    wboClient = (WebBusinessObject) clientsList.get(x);
				    String clientNo = (String) wboClient.getAttribute("clientNO");
				    String creationTime = (String) wboClient.getAttribute("creationTime");
				    if (creationTime != null) {
					creationTime = creationTime.substring(0, creationTime.lastIndexOf(":"));
				    } else {
					creationTime = "";
				    }
			    %>
				    <tr>
					<TD>
					    <%--<span>
						<a id="bookmarked<%=wboClient.getAttribute("id")%>" href="JavaScript: deleteBookmark(this,'<%=wboClient.getAttribute("markID")%>','<%=wboClient.getAttribute("id")%>');"
						   style="display: <%=wboClient.getAttribute("markID") != null ? "block" : "none"%>">
						    <image id="bookmarkImg<%=wboClient.getAttribute("id")%>" value="" width="19px" height="19px" src="images/icons/bookmark_selected.png" style="margin: -4px 0"
							   title="<%=wboClient.getAttribute("bookmarkText") != null ? wboClient.getAttribute("bookmarkText") : ""%>"/>
						</a>
						<a id="unbookmarked<%=wboClient.getAttribute("id")%>" href="JavaScript: createBookmark(this,'<%=wboClient.getAttribute("id")%>', '<%=wboClient.getAttribute("name")%>');"
						   style="display: <%=wboClient.getAttribute("markID") == null ? "block" : "none"%>">
						    <image id="unbookmarkImg<%=wboClient.getAttribute("id")%>" value="" width="19px" height="19px" src="images/icons/bookmark_uns.png" style="margin: -4px 0" />
						</a>
					    </span>

					    <span>--%>
						<input type="checkbox" value="<%=wboClient.getAttribute("id")%>" name="clientID"/>
					    <%--</span>--%>
					</TD>

					<TD>
					    <%--<A  HREF="<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=wboClient.getAttribute("id").toString()%>" style="color: #000" >--%>
						<%=clientNo%>
					    <%--</A>--%>
					</TD>

					<td nowrap> 
					    <%=wboClient.getAttribute("name")%> 
					    <input type="hidden" id="clientName<%=wboClient.getAttribute("id")%>" value="<%=wboClient.getAttribute("name")%>"/>
					</td>

					<tD>
					    <%=wboClient.getAttribute("phone") != null && !((String) wboClient.getAttribute("phone")).equals("UL") ? wboClient.getAttribute("phone") : ""%> 
					</tD>

					<tD>
					    <%=wboClient.getAttribute("mobile") != null && !((String) wboClient.getAttribute("mobile")).equals("UL") ? wboClient.getAttribute("mobile") : ""%>  
					    <input type="hidden" id="mobile<%=wboClient.getAttribute("id")%>" value="<%=wboClient.getAttribute("mobile") != null && !((String) wboClient.getAttribute("mobile")).equals("UL") ? wboClient.getAttribute("mobile") : ""%>"/>
					</tD>

					<tD>
					    <%=wboClient.getAttribute("interPhone") != null && !((String) wboClient.getAttribute("interPhone")).equals("UL") ? wboClient.getAttribute("interPhone") : ""%>  
					</tD>

					<tD>
					    <%=wboClient.getAttribute("email") != null && !((String) wboClient.getAttribute("email")).equals("UL") ? wboClient.getAttribute("email") : ""%> 
					    <input type="hidden" id="email<%=wboClient.getAttribute("id")%>" value="<%=wboClient.getAttribute("email") != null && !((String) wboClient.getAttribute("email")).equals("UL") ? wboClient.getAttribute("email") : ""%>"/>
					</tD>

					<td nowrap>
					    <%=creationTime%> 
					</td>

					<td nowrap>
					    <% String imgSrc = "<img src=\"images/buttons/attach-file.png\" title=\" Add Email \" onclick=\"chngMail(\'" + wboClient.getAttribute("id").toString() + "\');\" style=\"width: 30px; hight: 35px;\">";%>
					    <%=wboClient.getAttribute("email") != null && !((String) wboClient.getAttribute("email")).equals("UL") ? "" : imgSrc%> 
					</td>
				    </tr>
			    <%}%>
			</tbody>
		    </table>

		    <div id="updateMail"  style="width: 40% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
			<div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
			    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
				 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
				 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
				 -webkit-border-radius: 100px;
				 -moz-border-radius: 100px;
				 border-radius: 100px;" onclick="closePopup()"/>
			</div>

			<div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
			    <table  border="0px"  style="width:100%;" class="table">
				<tr>
				    <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 40%;">
					<input class="set" type="email" id="nwEmail" name="nwEmail" placeholder=" Add E-mail With Format ahmed@yahoo.com">
					<input type="hidden" id="nwClntEmail" name="nwClntEmail">
				    </td>
				</tr>
			    </table>
			    <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > <input type="button" class="button2 set" value=" <%=save%>"   onclick="upMail();" id="saveClient"class="login-submit"/></div> 
			    <div id="progressClient" style="display: none;">
				<img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
			    </div>
			    <div style="margin: 0 auto;width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold; display: none;" id="createClientMsg">
				تم إضافة البريد الإلكترونى
			    </div>
			</div>
		    </div>
		</form>
	    </fieldset>
	</center>
    </body>
</html>
