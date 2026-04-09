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
        String[] clientsAttributes = {"name", "mobile", "interPhone", "creationTime", "businessCompID", "campaignTitle", "sourceName", "campaignTime", "Time_Diff", "requestAge", "ownerName"};
        String[] clientsListTitles = new String[14];
        int s = clientsAttributes.length;
        int t = clientsListTitles.length;
        String attName = null;
        String attValue = null;
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        ArrayList<WebBusinessObject> campaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList");
        String campaignID = request.getAttribute("campaignID") != null ? (String) request.getAttribute("campaignID") : "";
        String extraCampaign = (String) request.getAttribute("extraCampaign");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign, fromDate, toDate, display, alert, campaign, all, withdraw, withdrawRedirect,extra, project;
        String dir = null;
        
        String employeeID = request.getAttribute("employeeID") != null ? (String) request.getAttribute("employeeID") : "";
        ArrayList<WebBusinessObject> employeeList = (ArrayList<WebBusinessObject>) request.getAttribute("employeeList");
        ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
        String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";
        String department,employee; 
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            clientsListTitles[0] = "Client Name";
            clientsListTitles[1] = "Client Mobile";
            clientsListTitles[2] = "International";
            clientsListTitles[3] = "Client Registration Date";
            clientsListTitles[4] = "Divisional ID";
            clientsListTitles[5] = "Campaign";
            clientsListTitles[6] = "Source";
            clientsListTitles[7] = "Client Campaign Date";
            clientsListTitles[8] = "Time Between Regtion (h)";
            clientsListTitles[9] = "Age (d)";
            clientsListTitles[10] = "Responsible";
            clientsListTitles[11] = "Alert";
            clientsListTitles[12] = "Withdraw";
            clientsListTitles[13] = "Redirect";
            fromDate = "From Date";
            toDate = "To Date";
            display = "Display Report";
            alert = "Alert";
            withdraw = "Withdraw";
            withdrawRedirect = "Redirect";
            campaign = "Campaign";
            all = "All";
            extra = "Extra Campaign";
            project = " Projects ";
            
            department ="Department";
            employee="Employee";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            clientsListTitles[0] = "اسم العميل";
            clientsListTitles[1] = "الموبايل";
            clientsListTitles[2] = "الدولي";
            clientsListTitles[3] = "تاريخ تسجيل العميل";
            clientsListTitles[4] = "الرقم الأداري";
            clientsListTitles[5] = "الحملة";
            clientsListTitles[6] = "المصدر";
            clientsListTitles[7] = "تاريخ التسجيل في الحملة";
            clientsListTitles[8] = "فرق التسجيل (ساعة)";
            clientsListTitles[9] = "عمر الطلب (يوم)";
            clientsListTitles[10] = "المسؤول";
            clientsListTitles[11] = "تنبيه";
            clientsListTitles[12] = "سحب";
            clientsListTitles[13] = "إعادة توجيه";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            display = "أعرض التقرير";
            alert = "تنبيه";
            withdraw = "سحب";
            withdrawRedirect = "إعادة توجيه";
            campaign = "الحملة";
            all = "الكل";
            extra = "حملات أضافية";
            project = " المشاريع ";
            
            department ="الأداره";
            employee="الموظف";
            
            
        }
        
        List<WebBusinessObject> employees = (List<WebBusinessObject>) request.getAttribute("employees");
        ArrayList<WebBusinessObject> requestTypes = (ArrayList<WebBusinessObject>) request.getAttribute("requestTypes");
        for (int i = requestTypes.size() - 1; i >= 0; i--) {
            if ("0".equals(requestTypes.get(i).getAttribute("mainProjId"))) {
                requestTypes.remove(i);
                break;
            }
        }
        
        ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
        
        String projectID = "";
        if (request.getAttribute("projectID") != null) {
            projectID = (String) request.getAttribute("projectID");
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
        
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
        
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function () {
                 $("#departmentID").val('<%=departmentID %>');
                 
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
                            "targets": [1, 2, 3, 4, 5],
                            "orderable": false
                        }],
                    "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(0, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
				    '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: lightgray;" colspan="3"><%=clientsListTitles[0]%></td><td class="blueBorder blueBodyTD" style="font-size: 16px; color: #a41111;" colspan="7">'
				    + group + '</td><td class="blueBorder blueBodyTD" colspan="3"></td></tr>'
				);
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
                
                $("#projectID").select2();
            });
              function getEmployees(obj, isReload) {
                var departmentID = $(obj).val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CommentsServlet?op=getEmployeesList",
                    data: {
                        departmentID: departmentID
                    },
                    success: function (jsonString) {
                        try {
                            var output = [];
                            output.push('<option value="">' + '<%=all%>' + '</option>');
                            var createdBy = $("#employeeID");
                            $(createdBy).html("");
                            var info = $.parseJSON(jsonString);
                            for (i = 0; i < info.length; i++) {
                                var item = info[i];
                                output.push('<option value="' + item.userId + '">' + item.fullName + '</option>');
                            }
                            createdBy.html(output.join(''));
                            if (isReload) {
                                $("#employeeID").val('<%=employeeID%>');
                            }
                        } catch (err) {
                        }
                    }
                });
                
               document.CLASSIFICATION_FORM.submit();
            }
            
          
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
                        subject: 'VIC',
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
                            
            function getProjects(obj) {
                $.ajax({
                    type: "post",
                    url: '<%=context%>/CampaignServlet?op=getProjectsAjax',
                    data: {
                        campaignID: $(obj).val()
                    }, success: function (dataStr) {
                        var result = $.parseJSON(dataStr);
                        var options = [];
                        options.push("<option value=''>", "الكل", "</option>");
                        try {
                            $.each(result, function () {
                                if (this.projectName) {
                                    options.push('<option value="', this.projectID, '">', this.projectName, '</option>');
                                }
                            });
                        } catch (err) {
                        }
                        $("#projectID").html(options.join(''));
                    }
                });
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
        <b style="float: <%=xAlign%>; font-size: 16px;color: #005599; font-style: oblique; margin-<%=xAlign%>: 80px;">Clients' Campaigns Report تقرير حملات العملاء</b>
        <fieldset align=center class="set" style="width: 95%">
            <form name="CLASSIFICATION_FORM" action="<%=context%>/ReportsServletThree?op=clientCampaignsReport" method="POST">
                <br/>
                <table class="blueBorder" align="center" dir="rtl" id="code" cellpadding="0" cellspacing="0" width="650" style="border-width: 1px; border-color: white; display: block;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"> <%=fromDate%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"> <%=toDate%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="text" style="width:190px" id="fromDate" name="fromDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("fromDate") == null ? "" : request.getAttribute("fromDate")%>"/>
                        </td>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="text" style="width:190px" id="toDate" name="toDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("toDate") == null ? "" : request.getAttribute("toDate")%>"/>
                        </td>
                    </tr>

                  <!--  <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"> <%=department%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b><font size=3 color="white"> <%=employee%></b>
                        </td>
                    </tr>
                    <tr>
                        <td  bgcolor="#dedede" valign="middle">
                            <select id="departmentID" name="departmentID" style="font-size: 14px; font-weight: bold; width: 300px;"
                                        onchange="getEmployees(this, false);">
                               <option ></option>
                                <% if( departments != null) { %>
                                    <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=departmentID%>" />
                                <% } %>
                            </select>
                        </td>
                        <td  bgcolor="#dedede" valign="middle">
                            <select name="employeeID" id="employeeID" style="width: 300px; font-size: 18px;">
                                <option value=""><%=all%></option>
                                <sw:WBOOptionList wboList="<%=employeeList%>" displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=employeeID%>" />
                            </select>
                        </td>
                        
                    </tr>
                      -->
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=campaign%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white">&nbsp;</b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <select name="campaignID" id="campaignID" style="width: 80%;" onchange="JavaScript: getProjects(this);" class="chosen-select-campaign">
                                <option value=""><%=all%></option>
                                <sw:WBOOptionList wboList="<%=campaignsList%>" displayAttribute="campaignTitle" valueAttribute="id" scrollToValue="<%=campaignID%>" />
                            </select>
                        </td>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="checkbox" name="extraCampaign" value="1" <%=extraCampaign != null ? "checked" : ""%> /> <b><font size="3"><%=extra%></font></b>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=project%></b>
                        </td>
                        <td bgcolor="#dedede" valign="middle" rowspan="2">
                            <input type="submit" value="<%=display%>" class="button" style="margin: 10px;"/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <select style="font-size: 14px; width: 80%;" id="projectID" name="projectID" >
                                <option value="">الكل</option>
                                <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                            </select>
                        </td>
                    </tr>
                </table>
                <br/>
                <br/>
                <%
                    if (clientsList != null) {
                        DecimalFormat df = new DecimalFormat("#");
                %>
                <div style="width: 90%; margin-left: auto; margin-right: auto; margin-bottom: 7px;">
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
                                <%
                                    for (int i = 0; i < s; i++) {
                                        attName = clientsAttributes[i];
                                        attValue = clientWbo.getAttribute(attName) != null ? ((String) clientWbo.getAttribute(attName)).trim() : "";
                                        if (i == 8 || i == 9) {
                                            attValue = df.format(Double.parseDouble(attValue));
                                        }
                                %>
                                <td>
                                    <div>
					<%
                                            if (i == 0) {
                                        %>
						<a target="blanck" href="<%=context%>/ClientServlet?op=clientDetails&issueID=<%=clientWbo.getAttribute("issueID")%>&clientId=<%=clientWbo.getAttribute("id")%>">
						    <img src="images/client_details.jpg" width="30" style="float: left;">
						</a>
				        <%
					    }
					%>
					    
                                        <%
                                            if (i == 1) {
                                        %>
                                        <a href="<%=context%>/ClientServlet?op=showClientHistory&num=<%=attValue%>">
                                            <%
                                                }
                                            %>
                                            <b><%=attValue.equalsIgnoreCase("UL") ? "" : attValue%></b>
                                            <%
                                                if (i == 1) {
                                            %>
                                        </a>
					
                                        <%
                                            }
                                        %>
                                    </div>
                                </td>
                                <%
                                    }
                                %>

                                <td nowrap>
                                    <button type="button" id="button<%=clientWbo.getAttribute("id")%>" onclick="JavaScript: redirectComplaint('<%=clientWbo.getAttribute("id")%>', '<%=clientWbo.getAttribute("ownerID")%>');" style="margin-bottom: 5px; display: <%=CRMConstants.CLIENT_RATE_FOLLOWUP_ID.equals(clientWbo.getAttribute("rateID")) ? "none" : ""%>;"><%=alert%><img src="images/icons/forward.png" width="15" height="15" /></button>
                                    <img id="icon<%=clientWbo.getAttribute("id")%>" src="images/icons/done.png" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; display: none;"/>
                                    <img id="loading<%=clientWbo.getAttribute("id")%>" src="images/icons/loading.gif" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; vertical-align: middle; display: none"/>
                                </td>
                                <td nowrap>
                                    <button class="withdrawbtn" type="button" id="button<%=clientWbo.getAttribute("issueID")%>" onclick="JavaScript: deleteTask(<%=clientWbo.getAttribute("issueID")%>);" style="margin-bottom: 5px; display: <%=CRMConstants.CLIENT_RATE_FOLLOWUP_ID.equals(clientWbo.getAttribute("rateID")) ? "none" : ""%>;"><%=withdraw%><img src="images/icons/forward.png" width="15" height="15" /></button>
                                    <img id="icon<%=clientWbo.getAttribute("id")%>" src="images/icons/done.png" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; display: none;"/>
                                    <img id="loading<%=clientWbo.getAttribute("id")%>" src="images/icons/loading.gif" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; vertical-align: middle; display: none"/>
                                </td>
                                <td nowrap>
                                    <button type="button" id="button<%=clientWbo.getAttribute("issueID")%>" onclick="JavaScript: showRedirectTask(<%=clientWbo.getAttribute("issueID")%>);" style="margin-bottom: 5px; display: <%=CRMConstants.CLIENT_RATE_FOLLOWUP_ID.equals(clientWbo.getAttribute("rateID")) ? "none" : ""%>;"><%=withdrawRedirect%><img src="images/icons/forward.png" width="15" height="15" /></button>
                                    <img id="icon<%=clientWbo.getAttribute("id")%>" src="images/icons/done.png" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; display: none;"/>
                                    <img id="loading<%=clientWbo.getAttribute("id")%>" src="images/icons/loading.gif" width="24" height="24" style="padding-top: 0px; padding-bottom: 5px; vertical-align: middle; display: none"/>
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