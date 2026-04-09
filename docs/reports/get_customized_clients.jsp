<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    ArrayList<WebBusinessObject> Clients = (ArrayList<WebBusinessObject>) request.getAttribute("customizedClients");
    String empID = (String) request.getAttribute("empID");
    String employee = (String) request.getAttribute("employee");
    ArrayList<WebBusinessObject> groupsList = (ArrayList<WebBusinessObject>) request.getAttribute("groupsList");
    String beginDate = "";
    if (request.getAttribute("beginDate") != null) {
        beginDate = (String) request.getAttribute("beginDate");
    }
    String endDate = "";
    if (request.getAttribute("endDate") != null) {
        endDate = (String) request.getAttribute("endDate");
    }
    
    String jsonText = request.getAttribute("jsonText") != null ? (String) request.getAttribute("jsonText") : "";
    String groupId = "";
    if (request.getAttribute("groupId") != null) {
        groupId = (String) request.getAttribute("groupId");
    }
    String stat = (String) request.getSession().getAttribute("currentMode");
    String title, fromDate, toDate, search, num, clntNm, mob, email, emp, createdBy, creationTime,
            group, employ;
    if (stat.equals("En")) {
        title = "Customized Clients Report";
        fromDate = "From Date";
        toDate = "To Date";
        search = "Search";
        num = "No.";
        clntNm = "Client";
        mob = "Mobile";
        email = "Email";
        emp = "Employee";
        createdBy = "Source";
        creationTime = "Creation Time";
        group = "Group";
        employ = "Employee";
    } else {
        title = "تقرير العملاء المخصصين";
        fromDate = "من تاريخ";
        toDate = "إلى تاريخ";
        search = "بحث";
        num = "م";
        clntNm = "العميل";
        mob = "الموبايل";
        email = "الإيميل";
        emp = "الموظف";
        createdBy = "المصدر";
        creationTime = "الوقت";
        group = "المجموعة";
        employ = "الموظف";
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        
        
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        
        <script type="text/javascript" src="js/json2.js"></script>
        <script type="text/javascript" src="js/highcharts.js"></script>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.rowsGroup.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        
        <script>
            
            $(document).ready(function () {
                getGrpEmp();
                $("#showLockedClientsTbl").dataTable({
                        "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[0, "asc"]],
                    "columnDefs": [
                        {
                            "targets": 4,
                            "visible": false
                        }, {
                            "targets": [0,1, 2, 3, 5, 6],
                            "orderable": false
                        }],
                    "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(4, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
				    '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: lightgray;" colspan="2"><%=emp%></td><td class="blueBorder blueBodyTD" style="font-size: 16px; color: #a41111;" colspan="5">'
				    + group + '</td></tr>'
				);
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
                
                 $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
                        
            function search(){
                var sBeginDate = $("#beginDate").val();
                var sEndDate = $("#endDate").val();
                var employee = $("#createdBy option:selected").val();
                var groupId = $("#groupId option:selected").val();
                document.LOCKED_CLIENT_FORM.action = "<%=context%>/ClientServlet?op=getAllCustomizedClnts&beginDate=" + sBeginDate + "&endDate=" + sEndDate+"&employee="+employee+"&groupId="+groupId;
                document.LOCKED_CLIENT_FORM.submit();
            }
            
            <%
                if(jsonText != null && !jsonText.isEmpty()){
            %>     
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
                                    return '<b>' + this.point.empNm + '</b>: '  + this.y;
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
                                            return '<b>' + this.point.empNm + '</b>: ' + '%' + Highcharts.numberFormat(this.percentage, 2);
                                        }
                                    }
                                }
                            }, series: [{
                                type: 'pie',
                                data: <%=jsonText%>
                            }]
                        });
                    });
            <%
                }
            %>
                
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
			var createdBy = '<%=employee%>';
			
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
        
        <style type="text/css">
            .titlebar {
                /*background-image: url(images/title_bar.png);*/
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
                background-color: #3399ff;
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
                border: none;
                margin-bottom: 30px;
            }
            
            .remove{
                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);
            }
            
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 500;
                top: 0px;
                left: 0px;
                position: fixed;
            }
            
            .img:hover{
                cursor: pointer ;
            }

            #mydiv {
                text-align:center;
            }
        </style>
    </head>
    <body>
        <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td width="100%" class="titlebar">
                        <font color="white" size="4">
                            <%=title%>
                        </font>
                    </td>
                </tr>
            </table>
            
            <br>
            
            <form name="LOCKED_CLIENT_FORM" method="POST">
                
                <input type="hidden" value="<%=empID%>"  id="empID">                
                <br>
                
                <table ALIGN="center" DIR="RTL" WIDTH="50%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;" WIDTH="30%">
                            <b>
                                <font size=3 color="white"><%=fromDate%>
                            </b>
                        </td>
                        
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;"WIDTH="30%">
                            <b>
                                <font size=3 color="white"><%=toDate%>
                            </b>
                        </td>
                        
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;"WIDTH="30%">
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="beginDate" name="beginDate" type="text" value="<%=beginDate%>">
                        </td>
                        
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="endDate" name="endDate" type="text" value="<%=endDate%>" >
                        </td>
                        
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle" rowspan="3">
                            <input type="button" class="button" value=" <%=search%> "  onclick="search();" style="width: 80%">
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;" WIDTH="30%">
                            <b>
                                <font size=3 color="white"><%=group%>
                            </b>
                        </td>
                        
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px; background-color: #0059b3; background-image: none;"WIDTH="30%">
                            <b>
                                <font size=3 color="white"><%=employ%>
                            </b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 250px;" name="groupId" id="groupId" onchange="getGrpEmp();" >
				<option value="" selected> إختر مجموعة </option>
                                <sw:WBOOptionList wboList='<%=groupsList%>' displayAttribute="groupName" valueAttribute="groupID" scrollToValue="<%=groupId%>"/>
                            </select>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 250px;" name="createdBy" id="createdBy">
                                
                            </select>
                        </td>
                    </tr>
                </table>
                <br>
                <%
                    if(Clients != null){
                %>
                    <%
                        if(jsonText != null && !jsonText.isEmpty() && (employee == null || employee == "" || employee == " ")){
                    %>
                            <div id="container" style="width: 600px; height: 300px; margin: 0 auto; border: none;"></div>
                    <%
                        }
                    %>
                    <div style="width: 99%;margin-right: auto;margin-left: auto;" id="showLockedClients">
                        <TABLE style="display" id="showLockedClientsTbl" ALIGN="center" dir="rtl" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4;">
                            <thead>                
                                <tr>

                                    <th STYLE="text-align:center; font-size:14px">
                                        <b><%=num%></b>
                                    </th>

                                    <th STYLE="text-align:center; font-size:14px">
                                        <b><%=clntNm%></b>
                                    </th>

                                    <th STYLE="text-align:center; font-size:14px">
                                        <b><%=mob%></b>
                                    </th>

                                    <th STYLE="text-align:center; font-size:14px">
                                        <b><%=email%></b>
                                    </th>

                                    <th STYLE="text-align:center; font-size:14px">
                                        <b> <%=emp%> </b>
                                    </th>

                                    <th STYLE="text-align:center; font-size:14px">
                                        <b><%=createdBy%></b>
                                    </th>
                                    
                                    <th STYLE="text-align:center; font-size:14px">
                                        <b><%=creationTime%></b>
                                    </th>
                                </tr>
                            </thead>

                            <tbody>
                                <%
                                    int counter = 0;
                                    String clazz = "";
                                    for (WebBusinessObject ClientsWbo : Clients) {
                                        counter++;
                                %>

                                        <tr class="<%=clazz%>" style="cursor: pointer" onMouseOver="this.className = ''" onMouseOut="this.className = '<%=clazz%>'">
                                            <TD STYLE="text-align: center; width: 5%" nowrap>
                                                <DIV>                   
                                                    <b><%=counter%></b>
                                                </DIV>
                                            </TD>

                                            <TD STYLE="text-align: center" nowrap>
                                                <DIV>                           
                                                    <b>
                                                        <%=ClientsWbo.getAttribute("clientNm")%>
                                                    </b>
                                                </DIV>
                                            </TD>

                                            <TD STYLE="text-align: center" nowrap>
                                                <DIV>                   
                                                    <b>
                                                        <%=(ClientsWbo.getAttribute("mobile") != null ? ClientsWbo.getAttribute("mobile") : "")%>
                                                    </b>
                                                </DIV>
                                            </TD>

                                            <TD STYLE="text-align: center">
                                                <DIV>                   
                                                    <b>
                                                        <%=(ClientsWbo.getAttribute("email") != null) ? ClientsWbo.getAttribute("email") : ""%>
                                                    </b>
                                                </DIV>
                                            </TD>

                                            <TD STYLE="text-align: center" nowrap>
                                                <DIV>                           
                                                    <b>
                                                        <%=ClientsWbo.getAttribute("empNm") != null ? ClientsWbo.getAttribute("empNm") : ""%>
                                                    </b>
                                                </DIV>
                                            </TD>

                                            <TD STYLE="text-align: center" nowrap>
                                                <DIV>                           
                                                    <b>
                                                        <%=ClientsWbo.getAttribute("createdBy") != null ? ClientsWbo.getAttribute("createdBy") : ""%>
                                                    </b>
                                                </DIV>
                                            </TD>
                                            
                                            <TD STYLE="text-align: center" nowrap>
                                                <DIV>                           
                                                    <b>
                                                        <%=ClientsWbo.getAttribute("creationTime") != null ? ClientsWbo.getAttribute("creationTime").toString().split(" ")[0] : ""%>
                                                    </b>
                                                </DIV>
                                            </TD>
                                        </tr>
                                    <%}%>
                                </tbody>
                            </table>
                        </div>
                        <%
                            }
                        %>
                </form>
            </table>
        </fieldset>
    </body>
</html>