<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@ page pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    int iTotal = 0;
    ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
    ArrayList<WebBusinessObject> Ccount = (ArrayList<WebBusinessObject>) request.getAttribute("Ccount");
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    String hasVisits = request.getAttribute("hasVisits") != null ? (String) request.getAttribute("hasVisits") : "";
    
    String smry = request.getAttribute("smry") != null ? (String) request.getAttribute("smry") : "1";
    
    String projectID = "";
    if (request.getAttribute("projectID") != null) {
        projectID = (String) request.getAttribute("projectID");
        if(!projectID.equals("all")){
            smry = "0";
        }
    }
    
    String jsonText = (String) request.getAttribute("jsonText");
    
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
    
    String stat = (String) request.getSession().getAttribute("currentMode");
    
    String align = "center";
    String dir = null;
    String style = null, title, beginDate, endDate, project, rlct, wrngClntMsg, wrngPrjMsg, customerName, clientNo, all, smryStr, dtls,
            total, visitorsOnly;
    if (stat.equals("En")) {
        align = "left";
        dir = "LTR";
        style = "text-align:right";
        title = "Clients by Project";
        beginDate = "From Date";
        endDate = "To Date";
        clientNo = "Clients No.";
        customerName = "Name";
        project = "Project";
	all =  " All ";
        rlct = " Relocate ";
        wrngClntMsg = " Please, Choose At Least One Client ";
        wrngPrjMsg = " Please, Choose Project ";
        
        smryStr = " Summery ";
        dtls = " Detailes ";
        total = " Total ";
        visitorsOnly = "Visitors Only";
    } else {
        dir = "RTL";
        align = "right";
        style = "text-align:Right";
        title = "العملاء بالمشروع";
        clientNo = "عدد العملاء";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        project = "المشروع";
	all = " الكل ";
        
        rlct = " تحويل ";
        wrngClntMsg = " من فضلك إختر عميل ";
        wrngPrjMsg = " من فضلك إختر مشروع ";
        
        smryStr = " الملخص ";
        dtls = " التفاصيل ";
        total = " المجموع ";
        visitorsOnly = "عملاء زائرون فقط";
    }
    
        SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
        ArrayList<WebBusinessObject> prvType = new ArrayList();
        prvType = securityUser.getComplaintMenuBtn();
        ArrayList<String> privilegesList = new ArrayList<String>();
        for (WebBusinessObject wboTemp : prvType) {
            if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                privilegesList.add((String) wboTemp.getAttribute("prevCode"));
            }
        }
%>

<html>
    <head>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css"/>
        <link rel="stylesheet" href="css/chosen.css"/>

        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        
        <script type="text/javascript">
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
            
	    var oTable;
            $(document).ready(function () {
		oTable = $('#indextable').dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[1, "asc"]],
                    "columnDefs": [
                        {
                            "targets": 1,
                            "visible": false
                        }, {
                            "targets": [0,2,3,4,5,6,7],
                            "orderable": false
                        }],
                    <%
			if(projectID != null && projectID.equals("all")){
		    %>
			    "drawCallback": function (settings) {
				var api = this.api();
				var rows = api.rows({page: 'current'}).nodes();
				var last = null;
				api.column(1, {page: 'current'}).data().each(function (group, i) {
				    if (last !== group) {
					$(rows).eq(i).before(
					    '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 16px; background-color: lightgray; color: #a41111;" colspan="10">' + group + '</td></tr>'
					);
					last = group;
				    }
				});
			    }
		    <%
			}
		    %>
                }).fadeIn(2000);
                
                <%
                    if(projectID != null && projectID.equals("all")){
                %>
                        $("#smryTr").show();
                <%
                    } else {
                %>    
                        $("#smryTr").hide();
                <%
                    }
                %>        
                
                $('#smryTbl').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[0, "asc"]]
                }).fadeIn(2000);
            });
            
            var chart;
            $(document).ready(function(){
               chart = new Highcharts.Chart({
                    chart: {
                        renderTo: 'container',
                        plotBackgroundColor: null,
                        plotBorderWidth: null,
                        plotShadow: false
                    }, title: {
                        text: null
                    }, tooltip: {
                        formatter: function () {
                            return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                        }
                    }, plotOptions: {
                        pie: {
                            allowPointSelect: true,
                            cursor: 'pointer',
                            dataLabels: {
                                enabled: true,
                                color: '#000000',
                                connectorColor: '#000000',
                                formatter: function () {
                                    return '<b>' + this.point.name + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                                }
                            }
                        }
                    }, series: [{
                        type: 'pie',
                        data: <%=jsonText%>
                    }]
                }); 
            });
            
            function getComplaints() {
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                var projectID = $("#projectID").val();
                
                if ((beginDate = null || beginDate == "")) {
                    alert("من فضلك أدخل تاريخ البداية");
                } else if ((endDate = null || endDate == "")) {
                    alert("من فضلك أدخل تاريخ النهاية");

                } else {
                    beginDate = $("#beginDate").val();
                    endDate = $("#endDate").val();
                    document.CLIENT_FORM.action = "<%=context%>/ClientServlet?op=getClientsByProject&beginDate=" + beginDate + "&endDate=" + endDate + "&projectID=" + projectID + "&smry=" + $("input[name='smry']:checked").val();
                    document.CLIENT_FORM.submit();
                }
            }
            
            function slctAllFun(){
                var slctAll = $("#slctAll").val();
                
                if(slctAll != null && slctAll == "off"){
                    $("#slctAll").val("on");
                    
                    $("input[name='clntIDs']").prop('checked', true);
                } else if(slctAll != null && slctAll == "on"){
                    $("#slctAll").val("off");
                    
                    $("input[name='clntIDs']").prop('checked', false);
                }
            }
            
            function relocate(){
                var projectID = $("#projectID option:selected").val();
                var prvsPrj = $("#prvsPrj").val();
                
                if($("input[name='clntIDs']:checked").size() > 0 && projectID != null && projectID != "all"){
                    document.CLIENT_FORM.action = "<%=context%>/ClientServlet?op=getClientsByProject&rlct=1&prjNm=" + $("#projectID option:selected").text();
                    document.CLIENT_FORM.submit();
                } else if($("input[name='clntIDs']:checked").size() == 0){
                    var wrngClntMsg = '<%=wrngClntMsg%>';
                    alert(wrngClntMsg);
                } else if(projectID == null || projectID == "all" || projectID == prvsPrj){
                    var wrngPrjMsg = '<%=wrngPrjMsg%>';
                    alert(wrngPrjMsg);
                }
            }
            
            function changeDetOrSmry(){
                var projectID = $("#projectID option:selected").val();
                if(projectID != null && projectID == "all"){
                    $("#smryTr").show();    
                } else {
                    $("#smryTr").hide();    
                }
            }
        </script>
    </head>
    
    <body>
        <form name="CLIENT_FORM" method="post">
            <input type="hidden" value="<%=projectID%>" name="prvsPrj" id="prvsPrj">
            
            <table align="center" width="90%">
                <tr>
                    <td class="td">
                        <fieldset >
                            <legend align="center">
                                <table dir="rtl" align="center">
                                    <tr>
                                        <td class="td">
                                            <font color="blue" size="6">
                                                 <%=title%> 
                                            </font>
                                        </td>
                                    </tr>
                                </table>
                            </legend>
                                            
                            <table align="center" dir="RTL" width="570" cellspacing="2" cellpadding="1">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size: 18px;" width="50%" colspan="2">
                                        <b>
                                            <font size=3 color="white">
                                                 <%=beginDate%> 
                                        </b>
                                    </td>
                                    
                                    <td class="blueBorder blueHeaderTD" style="font-size: 18px;"width="50%" colspan="2">
                                        <b>
                                            <font size=3 color="white">
                                                 <%=endDate%> 
                                        </b>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td style="text-align: center;" bgcolor="#dedede"  valign="MIDDLE"  colspan="2">
                                        <%
                                            if (beDate != null && !beDate.isEmpty()) {
                                        %>
                                                <input id="beginDate" name="beginDate" type="text" value="<%=beDate%>" readonly="true" title="تاريخ اضافه العميل"/>
                                                <img src="images/showcalendar.gif"/> 
                                        <%
                                            } else {
                                        %>
                                                <input id="beginDate" name="beginDate" type="text" value="<%=prev%>" readonly="true" title="تاريخ اضافه العميل">
                                                <img src="images/showcalendar.gif"/> 
                                        <%
                                            }
                                        %>
                                    </td>
                                    
                                    <td bgcolor="#dedede" style="text-align:center" valign="middle" colspan="2">
                                        <%
                                            if (eDate != null && !eDate.isEmpty()) {
                                        
                                        %>
                                                <input id="endDate" name="endDate" type="text" value="<%=eDate%>" readonly="true" title="تاريخ اضافه الرغبه"><img src="images/showcalendar.gif" /> 
                                        <%
                                            } else {
                                        %>
                                                <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" readonly="true" title="تاريخ اضافه الرغبه"><img src="images/showcalendar.gif" /> 
                                        <%
                                            }
                                        %>
                                    </td>
                                </tr>
                                <tr id="smryTr">
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="12%">
                                        <input type="radio" name="smry" value="1" <%="1".equals(smry) ? "checked" : ""%>/>
                                    </td>
                                    <td bgcolor="#dedede" valign="middle" width="38%">
                                        <font style="font-size: 15px;">
                                            <%=smryStr%>
                                        </font>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="12%">
                                        <input type="radio" name="smry" value="0" <%="0".equals(smry) ? "checked" : ""%>/>
                                    </td>
                                    <td bgcolor="#dedede" valign="middle" width="38%">
                                        <font style="font-size: 15px;">
                                            <%=dtls%>
                                        </font>
                                    </td>
                                </tr>    
                                
                                <TR>
                                    <TD class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                                        <b>
                                            <font size=3 color="white">
                                                 <%=project%> 
                                            </font>
                                        </b>
                                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                                            <font size=3 color="white">
                                                <%=visitorsOnly%>
                                            </font>
                                        </td>
                                    </TD>
                                </TR>
                                
                                <TR>
                                    <td  bgcolor="#dedede" valign="middle" colspan="2">
                                        <select name='projectID' id='projectID' style='width:170px;font-size:16px;' onchange="changeDetOrSmry();">
					    <option value="all"> <%=all%> </option>
                                            <sw:WBOOptionList wboList="<%=projectsList%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                                        </select>
                                    </td>
                                    <td bgcolor="#dedede" colspan="2">
                                        <input id="hasVisits" name="hasVisits" type="checkbox" value="true"
                                               <%="true".equals(hasVisits) ? "checked" : ""%>/>
                                    </td>
                                </TR>
                                
                                <tr>
                                    <td STYLE="text-align:center" CLASS="td" colspan="<%=privilegesList.contains("RELOCATE_CLIENT") ? "2" : "4"%>">  
                                        <button onclick="JavaScript: getComplaints();" style="color: #000;font-size:15px;margin-top: 20px;font-weight:bold; ">
                                             بحث 
                                             <img height="15" src="images/search.gif" /> 
                                        </button>  
                                    </td>
                                    
                                    <td STYLE="text-align:center; display: <%=privilegesList.contains("RELOCATE_CLIENT") ? "block" : "none"%>;" CLASS="td" colspan="2">  
                                        <input type="button" onclick="JavaScript: relocate();" style="color: #000;font-size:15px;margin-top: 20px;font-weight:bold; " value="<%=rlct%>">
                                    </td>
                                </tr>
                            </table>
                        
                            <%
                                if(jsonText != null ){
                            %>                
                                    <div id="container" style="width: 95%; height: 40%; margin: 0 auto"></div> 
                            <%
                                }
                                if(smry != null && smry.equals("1") && Ccount != null){
                                    iTotal = 0;
                            %>
                                    <center>
                                        <div style="width: 30%;">
                                            <table align="<%=align%>" dir="<%=dir%>" id="smryTbl" style="width:100%;">
                                                <thead>
                                                    <tr>
                                                        <th>
                                                             <%=project%> 
                                                        </th>

                                                        <th>
                                                             <%=total%> 
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%
                                                        for (WebBusinessObject wbo : Ccount) {
                                                            iTotal += Long.valueOf((String) wbo.getAttribute("clientsCount"));
                                                    %>
                                                    <tr>
                                                        <td>
                                                             <%=wbo.getAttribute("projectName")%>
                                                        </td>

                                                        <td>
                                                             <%=wbo.getAttribute("clientsCount")%> 
                                                        </td>
                                                    </tr>
                                                    <%
                                                        }
                                                    %>
                                                </tbody>
                                                <tfoot>
                                                    <tr>
                                                        <th>
                                                            <%=total%>
                                                        </th>
                                                        <th>
                                                            <%=iTotal%>
                                                        </th>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                        </div>
                                    </center>        
                                <%
                                    } else {

                                        if (data != null && !data.isEmpty()) {
                                %>
                                        <div style="text-align: center; width: 100%;">
                                            <b>
                                                <font size="3" color="red">
                                                     <%=clientNo%> : <%=data.size()%> 
                                                </font>
                                            </b>
                                        </div> 

                                        <table class="blueBorder" id="indextable" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0" style="display: none;">
                                            <thead>
                                                <tr style="">
                                                    <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px">
                                                        <input type="checkbox" name="slctAll" id="slctAll" value="off" onclick="slctAllFun();">
                                                    </th>

                                                    <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="">
                                                        <SPAN>
                                                            <b>
                                                                Project Name 
                                                            </b>
                                                        </SPAN>
                                                    </th>

                                                    <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px">
                                                        <SPAN>
                                                            <b>
                                                                 <%=customerName%> 
                                                            </b>
                                                        </SPAN>
                                                    </th>

                                                    <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px">
                                                        <SPAN>
                                                            <b>
                                                                اضافة العميل
                                                            </b>
                                                        </SPAN>
                                                    </th>

                                                    <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px"><SPAN>
                                                            <b>
                                                                الرغبه فى المشروع
                                                            </b>
                                                        </SPAN>
                                                    </th>

                                                    <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px">
                                                        <SPAN>
                                                            <b>
                                                                المصدر
                                                            </b>
                                                        </SPAN>
                                                    </th>

                                                    <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px">
                                                        <SPAN>
                                                            <b>
                                                                رقم التليفون
                                                            </b>
                                                        </SPAN>
                                                    </th>

                                                    <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px">
                                                        <SPAN>
                                                            <b>
                                                                الموبايل
                                                            </b>
                                                        </SPAN>
                                                    </th>

                                                    <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px">
                                                        <SPAN>
                                                            <b>
                                                                الرقم الطالب
                                                            </b>
                                                        </SPAN>
                                                    </th>

                                                    <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px">
                                                        <SPAN>
                                                            <b>
                                                                الرقم الدولي
                                                            </b>
                                                        </SPAN>
                                                    </th>

                                                    <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px">
                                                        <SPAN>
                                                            <b>
                                                                البريد اﻷلكتروني
                                                            </b>
                                                        </SPAN>
                                                    </th>
                                                </tr>
                                            </thead> 

                                            <tbody>  
                                                <%
                                                    for (WebBusinessObject wbo : data) {
                                                        iTotal++;
                                                %>
                                                        <tr style="padding: 1px;">
                                                            <td>
                                                                <div>
                                                                    <input type="checkbox" name="clntIDs" id="clntIDs<%=wbo.getAttribute("id")%>" value="<%=wbo.getAttribute("id")%>">
                                                                </div>
                                                            </td>

                                                            <td>
                                                                <div>
                                                                    <b>
                                                                         <%=wbo.getAttribute("prjNm")%> 
                                                                    </b>
                                                                </div>
                                                            </td>

                                                            <td>
                                                                <%
                                                                    if (wbo.getAttribute("name") != null) {
                                                                %>
                                                                        <b>
                                                                             <%=wbo.getAttribute("name")%> 
                                                                        </b>
                                                                <%
                                                                    }
                                                                %>
                                                            </td>

                                                            <td>
                                                                <%
                                                                    String creationTime = "";
                                                                    if (wbo.getAttribute("creationTime") != null) {
                                                                        creationTime = ((String) wbo.getAttribute("creationTime")).split(" ")[0];
                                                                %>
                                                                        <b>
                                                                             <%=creationTime%> 
                                                                        </b>
                                                                <%
                                                                    }
                                                                %>
                                                            </td>

                                                            <td>
                                                                <%
                                                                    String interestedTime = "";
                                                                    if (wbo.getAttribute("interestedTime") != null) {
                                                                        interestedTime = ((String) wbo.getAttribute("interestedTime")).split(" ")[0];
                                                                %>
                                                                        <b>
                                                                             <%=interestedTime%> 
                                                                        </b>
                                                                <%
                                                                    }
                                                                %>
                                                            </td>

                                                            <td>
                                                                <%
                                                                    if (wbo.getAttribute("createdBy") != null) {
                                                                %>
                                                                        <b>
                                                                             <%=wbo.getAttribute("createdBy")%> 
                                                                        </b>
                                                                <%
                                                                    }
                                                                %>
                                                            </td>

                                                            <td style="width: 10%;">
                                                                <b>
                                                                     <%=wbo.getAttribute("phone") != null && !wbo.getAttribute("phone").equals("UL") ? wbo.getAttribute("phone") : ""%> 
                                                                </b>
                                                            </td>

                                                            <td style="width: 10%;">
                                                                <b>
                                                                     <%=wbo.getAttribute("mobile") != null && !wbo.getAttribute("mobile").equals("UL") ? wbo.getAttribute("mobile") : ""%> 
                                                                </b>
                                                            </td>

                                                            <td style="width: 10%;">
                                                                <b>
                                                                     <%=wbo.getAttribute("option3") != null && !wbo.getAttribute("option3").equals("UL") ? wbo.getAttribute("option3") : ""%> 
                                                                </b>
                                                            </td>

                                                            <td style="width: 10%;">
                                                                <b>
                                                                     <%=wbo.getAttribute("interPhone") != null && !wbo.getAttribute("interPhone").equals("UL") ? wbo.getAttribute("interPhone") : ""%> 
                                                                </b>
                                                            </td>

                                                            <td style="width: 10%;">
                                                                <b>
                                                                     <%=wbo.getAttribute("email") != null && !wbo.getAttribute("email").equals("UL") ? wbo.getAttribute("email") : ""%> 
                                                                </b>
                                                            </td>
                                                        </tr>
                                                <%
                                                    }
                                                %>
                                            </tbody>
                                        </table>
                            <%
                                    }
                                }
                            %>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>