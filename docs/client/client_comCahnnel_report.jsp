<%@page import="java.text.DecimalFormat"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  

<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] clientsAttributes = {"Communication Channel","name", "mobile", "creationTime",  "sourceName","campaignTitle",};
        String[] clientsListTitles = new String[8];
        int s = clientsAttributes.length;
        int t = clientsListTitles.length;
        String clientType = (String) request.getAttribute("clientType");
        String channelID = request.getAttribute("channelID") != null ? (String) request.getAttribute("channelID") : "";
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        ArrayList<WebBusinessObject> channelsList = (ArrayList<WebBusinessObject>) request.getAttribute("channelsList");
        ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
        String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";
        Map<String, Long> channelsCount = (HashMap<String, Long>) request.getAttribute("channelsCount");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign, fromDate, toDate, display, alert, campaign, all, withdraw, withdrawRedirect,extra, count, department;
        String dir = null;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            clientsListTitles[0] = "Communication Channel";
            clientsListTitles[1] = "Client No";
            clientsListTitles[2] = "Client Name";
            clientsListTitles[3] = "Client Mobile";
            clientsListTitles[4] = "Client Email";
            clientsListTitles[5] = "Client Registration Date";
            clientsListTitles[6] = "Source";
            clientsListTitles[7] = "Campaign";
            fromDate = "From Date";
            toDate = "To Date";
            display = "Display Report";
            alert = "Alert";
            withdraw = "Withdraw";
            withdrawRedirect = "Redirect";
            campaign = "Campaign";
            all = "All";
            extra = "Extra Campaign";
            count = "Clients Count";
            department = "Department";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            clientsListTitles[0] = "قناة الاتصال";
            clientsListTitles[1] = "رقم العميل";
            clientsListTitles[2] = "اسم العميل";
            clientsListTitles[3] = "الموبايل";
            clientsListTitles[4] = "الايميل";
            clientsListTitles[5] = "تاريخ تسجيل العميل";
            clientsListTitles[6] = "المصدر";
            clientsListTitles[7] = "الحملة";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            display = "أعرض التقرير";
            alert = "تنبيه";
            withdraw = "سحب";
            withdrawRedirect = "إعادة توجيه";
            campaign = "الحملة";
            all = "الكل";
            extra = "حملات أضافية";
            count = "عدد العملاء";
            department = "الأدارة";
        }
        
        List<WebBusinessObject> employees = (List<WebBusinessObject>) request.getAttribute("employees");
        ArrayList<WebBusinessObject> requestTypes = (ArrayList<WebBusinessObject>) request.getAttribute("requestTypes");
        for (int i = requestTypes.size() - 1; i >= 0; i--) {
            if ("0".equals(requestTypes.get(i).getAttribute("mainProjId"))) {
                requestTypes.remove(i);
                break;
            }
        }
    %>
    <HEAD>
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
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function () {
                oTable = $('#clients').dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[0, "asc"]],
                    "columnDefs": [
                        {
                            "targets": 0,
                            "visible": false
                        }, {
                            "targets": [1, 2, 3, 4, 5, 6, 7],
                            "orderable": false
                        }],
                    "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(0, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                if(group === "" || group === null){
                                    group = "غير محدد";  
                                }
                                $(rows).eq(i).before(
				    '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: lightgray;" colspan="1"><%=clientsListTitles[0]%></td><td class="blueBorder blueBodyTD" style="font-size: 16px; color: #a41111;" colspan="7">'
				    + group + '</td></tr>'
				);
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
                oTable = $('#channels').dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[0, "asc"]]
                }).fadeIn(2000);
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });

            function redirectComplaint(clientId, employeeId) {
                hideAllIcon(clientId);
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=redirectClientComplaint2",
                    data: {
                        clientID: clientId,
                        employeeId: employeeId,
                        ticketType: '<%=CRMConstants.CLIENT_COMPLAINT_TYPE_ORDER%>',
                        comment: 'Redirect Order',
                        subject: 'عميل مهم - تواصل فورا',
                        notes: 'عميل مهم - تواصل فورا'
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            $("#icon" + id).css("display", "block");
                            $("#loading" + id).css("display", "none");
                        }
                    }, error: function (jsonString) {
                        alert(jsonString);
                    }
                });
            }

            function hideAllIcon(id) {
                $("#button" + id).css("display", "none");
                $("#icon" + id).css("display", "block");
            }
            
            function deleteTask(issueId) {
                var r = confirm("Are You Sure You want to delete task and all its data.");
                if (r === true){
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/DatabaseControllerServlet?op=dragClient",
                        data: {
                            issueId : issueId,
                            flag: 'report'
                        }, success: function () {
                            window.location.reload();
                        }, error: function (jsonString) {
                            alert(jsonString);
                    }
                });
                }
                }
            
            function showRedirectTask(issueId) {
                $("#issueId").val(issueId);
                $('#redirectClient').show();
                $('#redirectClient').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }
            
            function deleteRedirectTask() {
                if($("#requestType").val() === '') {
                    alert("You must select a request type to create new request");
                    return;
                }
                if($("#employeeID").val() === '') {
                    alert("You must select an employee to distrubite new request to it");
                    return;
                }
                var r = confirm("Are You Sure You want to delete task and all its data.");
                if (r === true){
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/DatabaseControllerServlet?op=dragClient",
                        data: {
                            issueId : $("#issueId").val(),
                            employeeID : $("#employeeID").val(),
                            requestType : $("#requestType").val(),
                            flag: 'redirect'
                        },
                                success: function () {
                                    window.location.reload();
                                }, error: function (jsonString) {
                                    alert(jsonString);
                                }
                            });
                            }
                            }
        </script>
        <style type="text/css">
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
        </style>
    </HEAD>
    <body>
        <b style="float: <%=xAlign%>; font-size: 16px;color: #005599; font-style: oblique; margin-<%=xAlign%>: 80px;">Clients' Communication channels Report تقرير عملاء قنوات الاتصال</b>
        <fieldset align=center class="set" style="width: 95%">
            <form name="CLASSIFICATION_FORM" action="<%=context%>/ReportsServletThree?op=clientComChannelReport" method="POST">
                <br/>
                <table class="blueBorder" align="center" dir="rtl" id="code" cellpadding="0" cellspacing="0" width="650" style="border-width: 1px; border-color: white; display: block;" >
                    <tr style="display: none;">
			<td class="blueBorder blueHeaderTD" style="font-size:18px;" width="12%">
                            <input type="radio" name="clientType" id="inbound" value="inbound" checked>
			</td>
			
			<td bgcolor="#dedede" valign="middle" width="38%">
			    <font style="font-size: 15px;">
				Inbound
			    </font>
			</td>
			
			<td class="blueBorder blueHeaderTD" style="font-size:18px;" width="12%">
			    <input type="radio" name="clientType" id="outbound" value="outbound" >
			</td>
			
			<td bgcolor="#dedede" valign="middle" width="38%">
			    <font style="font-size: 15px;">
				Outbound
			    </font>
			</td>
		    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px" colspan="2">
                            <b><font size=3 color="white"> <%=fromDate%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px" colspan="2">
                            <b><font size=3 color="white"> <%=toDate%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <input type="text" style="width:190px" id="fromDate" name="fromDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("fromDate") == null ? "" : request.getAttribute("fromDate")%>" title="Client Registration Date"/>
                        </td>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <input type="text" style="width:190px" id="toDate" name="toDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("toDate") == null ? "" : request.getAttribute("toDate")%>" title="Client Registration Date"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px" colspan="2">
                            <b><font size=3 color="white"><%=clientsListTitles[0]%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px" colspan="2">
                            <b><font size=3 color="white"><%=department%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <select style="width:190px" id="channelID" name="channelID">
                                <option value=""><%=all%></option>
                                <sw:WBOOptionList wboList="<%=channelsList%>" valueAttribute="id" displayAttribute="englishName" scrollToValue="<%=channelID%>"/>
                            </select>
                        </td>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <select style="width:190px" id="departmentID" name="departmentID">
                                <sw:WBOOptionList wboList="<%=departments%>" valueAttribute="projectID" displayAttribute="projectName" scrollToValue="<%=departmentID%>"/>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="4">
                            <input type="submit" value="<%=display%>" class="button" style="margin: 10px;"/>
                        </td>
                    </tr>
                </table>
                <br/>
                <br/>
                <%
                    if (clientsList != null){
                %>
                <div style="width: 40%; margin-left: auto; margin-right: auto; margin-bottom: 7px;">
                    <table align="<%=align%>" dir="<%=dir%>" id="channels" style="width: 100%;">
                        <thead>
                            <tr>              
                                <th>
                                    <b><%=clientsListTitles[0]%></b>
                                </th>
                                <th>
                                    <b><%=count%></b>
                                </th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                            for(String channelTitle : channelsCount.keySet()) {
                            %>
                            <tr>
                                <td>
                                    <b>
                                        <%=!channelTitle.equals("none") ? channelTitle : "غير محدد"%>
                                    </b>  
                                </td>
                                <td>
                                    <b>
                                        <%=channelsCount.get(channelTitle)%>
                                    </b>  
                                </td>
                            </tr>
                            <%
                            }
                            %>
                        </tbody>
                    </table>
                </div>
                <div style="width: 90%; margin-left: auto; margin-right: auto; margin-bottom: 7px;">
                    <br/>
                    <table align="<%=align%>" dir="<%=dir%>" id="clients" style="width:100%;">
                        <thead>
                            <tr>
                                <%
                                    for (int i = 0; i < t; i++) {
                                %>                
                                <th style="width:10%">
                                    <b><%=clientsListTitles[i]%></b>
                                </th>
                                <%
                                    }
                                %>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (WebBusinessObject clientWbo : clientsList) {
                            %>
                            <tr>
                                <td>
                                    <B>
                                        <%=clientWbo.getAttribute("comChannel") != null ? clientWbo.getAttribute("comChannel") : "غير محدد" %>
                                    </B>  
                                </td>
                                <td>
                                    <B>
                                        <%=clientWbo.getAttribute("clientNo")%>
                                    </B> 
                                </td>
                                <td>
                                    <B>
                                        <%=clientWbo.getAttribute("name")%>
                                    </B>  
                                </td>
                                <td>
                                    <B>
                                        <%=clientWbo.getAttribute("mobile")%>
                                    </B>  
                                </td>
                                <td>
                                    <B>
                                        <%=clientWbo.getAttribute("email")%>
                                    </B>  
                                </td>
                                <td>
                                    <B>
                                        <%=clientWbo.getAttribute("creationTime")%>
                                    </B>  
                                </td>
                                <td>
                                    <B>
                                        <%=clientWbo.getAttribute("createdBy")%>
                                    </B>  
                                </td>
                                <td>
                                    <B>
                                        <%=clientWbo.getAttribute("camp")%>
                                    </B>  
                                </td>

                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            <%
                }
            %>
                <br/><br/>
            </form>
        </fieldset>
        <script>
            var config = {
                '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
        </script>
          <div id="redirectClient" style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 500px;">
            <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table  border="0px"  style="width:100%;"  class="table">
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">نوع الطلب</td>
                        <td style="width: 70%;">
                            <select name="requestType" id="requestType" style="width: 200px;">
                                <option value="">أختر</option>
                                <sw:WBOOptionList wboList="<%=requestTypes%>" displayAttribute="projectName" valueAttribute="projectName" />
                            </select>
                        </td>
                    </tr> 
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">الموظف</td>
                        <td style="width: 70%;">
                            <select name="employeeID" id="employeeID" style="width: 200px;">
                                <option value="">أختر</option>
                                <sw:WBOOptionList wboList="<%=employees%>" displayAttribute="fullName" valueAttribute="userId" />
                            </select>
                            <input type="hidden" name="issueId" id="issueId" />
                        </td>
                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > <input type="button" value="سحب وتوزيع" onclick="JavaScript: deleteRedirectTask();" id="redirectClient" class="login-submit"/></div>
            </div>
        </div>
    </body>
</html>