<%-- 
    Document   : specialDistribute
    Created on : Jun 20, 2017, 1:41:39 PM
    Author     : java3
--%>

<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="com.silkworm.common.UserMgr"%>
<%@page import="com.maintenance.common.UserDepartmentConfigMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<!DOCTYPE html>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    List<WebBusinessObject> clients = (List<WebBusinessObject>) request.getAttribute("clients");
     
                WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
                ArrayList<WebBusinessObject> departments2 = new ArrayList<WebBusinessObject>();
                UserDepartmentConfigMgr userDepartmentConfigMgr = UserDepartmentConfigMgr.getInstance();
                String selectedDepartment2 = request.getParameter("departmentID");
                try {
                    ArrayList<WebBusinessObject> userDepartments = new ArrayList<WebBusinessObject>(userDepartmentConfigMgr.getOnArbitraryKeyOracle((String) loggedUser.getAttribute("userId"), "key2"));
                    for (WebBusinessObject userDepartmentWbo : userDepartments) {
                        if (ProjectMgr.getInstance().getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")) != null) {
                            departments2.add(ProjectMgr.getInstance().getOnSingleKey((String) userDepartmentWbo.getAttribute("department_id")));
                        }
                    }
                    if (departments2.isEmpty()) {
                        WebBusinessObject wboTemp = new WebBusinessObject();
                        wboTemp.setAttribute("projectName", "لا يوجد");
                        wboTemp.setAttribute("projectID", "none");
                        departments2.add(wboTemp);
                        ArrayList list = new ArrayList<>();
                    } else {
                        if (selectedDepartment2 == null) {
                            selectedDepartment2 = "all";
                        }
                    }
                } catch (Exception ex) {
                    
                }
                List<WebBusinessObject> employeeList2 = new ArrayList<WebBusinessObject>();
                if (selectedDepartment2 != null && selectedDepartment2.equals("all")) {
                    for (WebBusinessObject departmentWbo2 : departments2) {
                        if (departmentWbo2 != null) {
                            employeeList2.addAll(UserMgr.getInstance().getEmployeeByDepartmentId((String) departmentWbo2.getAttribute("projectID"), null, null));
                        }
                    }
                } else {
                    employeeList2 = UserMgr.getInstance().getEmployeeByDepartmentId(selectedDepartment2, null, null);
                }
    List<WebBusinessObject> usersList = (List<WebBusinessObject>) employeeList2;
    List<WebBusinessObject> distributionsList = (List<WebBusinessObject>) request.getAttribute("distributionsList");
    List<WebBusinessObject> salesEmployees = (List<WebBusinessObject>) request.getAttribute("salesEmployees");
    List<WebBusinessObject> campaignsList = (List<WebBusinessObject>) request.getAttribute("campaignsList");
    ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
    ArrayList<WebBusinessObject> requestTypes = (ArrayList<WebBusinessObject>) request.getAttribute("requestTypes");
    List<String> usersIDsList = (List<String>) request.getAttribute("usersIDsList");
    String beginDate = "";
    String mgr = ProjectMgr.getInstance().getByKeyColumnValue("key5",(String) loggedUser.getAttribute("userId"), "key5");
    String mgrGroup = ProjectMgr.getInstance().getByKeyColumnValue("key5",(String) loggedUser.getAttribute("userId"), "key3");
    if (request.getAttribute("beginDate") != null) {
        beginDate = (String) request.getAttribute("beginDate");
    }
    String endDate = "";
    if (request.getAttribute("endDate") != null) {
        endDate = (String) request.getAttribute("endDate");
    }
    String description = "";
    if (request.getAttribute("description") != null) {
        description = (String) request.getAttribute("description");
    }
    String createdBy = "";
    if (request.getAttribute("createdBy") != null) {
        createdBy = (String) request.getAttribute("createdBy");
    }
    String campaignID = "";
    if (request.getAttribute("campaignID") != null) {
        campaignID = (String) request.getAttribute("campaignID");
    }
    String clientType = "";
    if (request.getAttribute("clientType") != null) {
        clientType = (String) request.getAttribute("clientType");
    }
    String phoneNo = "";
    if (request.getAttribute("phoneNo") != null) {
        phoneNo = (String) request.getAttribute("phoneNo");
    }
    String projectID = "";
    if (request.getAttribute("projectID") != null) {
        projectID = (String) request.getAttribute("projectID");
    }
    String status = (String) request.getAttribute("status");
    
    String stat = (String) request.getSession().getAttribute("currentMode");
    String align, dir, style,Requesttype,search,Distributecampaigncustomers,all,cam,clientname,clientstatus,InternationalNumber,Phone,Email,EntryDate,fromdate, todate, mobilecLIENT, Managment, Resource, Project, ClientType;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            Distributecampaigncustomers = "Distribute Sales Maneger & Team Leader";
            search = "search";
            Requesttype = "Request Type";
            cam = "Campaign";
            all = "All";
            fromdate = "From Date";
            todate = "To Date";
            mobilecLIENT = "Mobile";
            Managment = "Managment";
            Resource = "Resource";
            Project = "Project";
            ClientType = "Client Type";
            clientname = "Client Name";
            clientstatus = "Client Status";
            InternationalNumber ="International Number";
            Phone = "Phone";
            Email = "Email";
            EntryDate = "Entry Date";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            cam = "الحمله";
            Requesttype = "نوع الطلب";
            all = "الكل";
            fromdate = "من تاريخ";
            todate = "الى تاريخ";
            mobilecLIENT = "موبايل";
            Managment = "الاداره";
            Resource = "المصدر";
            Project = "المشروع";
            ClientType = "نوع العميل";
            clientname = "اسم العميل";
            clientstatus = "حاله العميل";
            InternationalNumber ="الرقم الدولى";
            Phone = "التليفون";
            Email = "الايميل";
            EntryDate = "تاريخ الادخال";
            Distributecampaigncustomers = "توزيع عملاء الحملة";
            search = "بحث";
            
        }
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">

        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        
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
            function selectAll(obj) {
                $("input[name='customerId']").prop('checked', $(obj).is(':checked'));
            }
            $(function() {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
            $(document).ready(function () {
                $("#createdBy").select2();
                
                $("#campaignID").select2();
                
                $("#usrID").select2();
                
                $("#employeeId").select2();
                
                $("#clientsssss").dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10], [10]],
                    "order": [[ 8, "asc" ]],
                    "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(8, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
                                        '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: lightgray;" colspan="3">المصدر</td><td class="blueBorder blueBodyTD" style="font-size: 16px;" colspan="4">'
                                        + group + '</td><td class="blueBorder blueBodyTD" colspan="3"></td></tr>'
                                        );
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
            });

            function distribution(mode) {
                if (!validateData("req", document.UNHANDLED_CLIENT_FORM.requestType, "من فضلك اختار نوع الطلب...")) {
                    $("#requestType").focus();
                } else {
                    $("#manualBTN").attr("disabled", "true");
                    $("#autoBtn").attr("disabled", "true");
                    //var employeeId = document.getElementById('employeeId').value;
                    var loggedOnly = $("#loggedOnly").is(":checked");
                    document.UNHANDLED_CLIENT_FORM.action = "<%=context%>/AutoPilotModeServlet?op=distributeLeadCustomers&mode=" + mode + "&fromURL=specialDistribute" + "&loggedOnly=" + loggedOnly
                    + "&requestType=" + $("#requestType").val();
                    document.UNHANDLED_CLIENT_FORM.submit();
                }
            }

            function salesEmployeeBox() {
                if (document.getElementById('salesEmployee').checked === true) {
                    document.getElementById('salesEmployeeId').style.display = "block";
                    document.getElementById('employeeId').style.display = "none";
                } else {
                    document.getElementById('salesEmployeeId').style.display = "none";
                    document.getElementById('employeeId').style.display = "block";
                }
            }
            
            function getProjects(obj) {
                $.ajax({
                    type: "post",
                    url: '<%=context%>/CampaignServlet?op=getProjectsAjax',
                    data: {
                        campaignID: $(obj).val()
                    },
                    success: function (dataStr) {
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
            function openWindow(url) {
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=700, height=600");
            }
            function updateClientInformation(clientID) {
                var url = "<%=context%>/ClientServlet?op=getUpdateClientForm&clientId=" + clientID;
                openWindow(url);
            }
        </script>
    </head>
    <body>
        <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 10px;border-radius: 5px;">
            <form name="SEARCH_CLIENT_FORM" action="<%=context%>/ClientServlet?op=specialDistribute" method="POST">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4"><%=Distributecampaigncustomers%></font>
                        </td>
                    </tr>
                </table>
                
                <br/>
                
                <%
                    if ("saved".equalsIgnoreCase(status)) {
                %>
                    <table>
                        <tr>
                            <td class="td"> 
                                <b>
                                    <font size="4" style="color: green;">
                                    تم الحفظ بنجاح
                                    </font>
                                </b>
                            </td>
                        </tr>
                    </table>
                <%
                    }
                %>
                
                <table ALIGN="center" DIR="RTL" WIDTH="75%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="22%">
                            <b><font size=3 color="white"><%=fromdate%></b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="22%">
                            <b> <font size=3 color="white"><%=todate%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="22%">
                            <b><font size=3 color="white">Hash Tag</b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="22%">
                            <b><font size=3 color="white"><%=mobilecLIENT%></b>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="beginDate" name="beginDate" type="text" value="<%=beginDate%>">
                            
                            <br/><br/>
                        </td>
                        
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="endDate" name="endDate" type="text" value="<%=endDate%>" >
                            
                            <br/><br/>
                        </td>
                        
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <input id="description" name="description" type="text" value="<%=description%>" />
                            
                            <br/><br/>
                        </td>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE" colspan="2">
                            <input id="phoneNo" name="phoneNo" type="text" value="<%=phoneNo%>" />
                            <br/><br/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=Resource%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=cam%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=Project%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                            <b><font size=3 color="white"><%=ClientType%></b>
                        </td>
                        
                        <td STYLE="text-align:center" bgcolor="#dedede" rowspan="2">  
                            <button type="submit" onclick="JavaScript: search();" class="button" STYLE="color: #27272A;font-size:15px;margin-top: 20px;font-weight:bold; width: 100%; ">بحث
                                <IMG HEIGHT="15" SRC="images/search.gif" >
                            </button>
                        </td>
                    </tr>
                    
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" id="createdBy" name="createdBy" >
                                <%if(mgrGroup.equals("MSLSU14") || mgrGroup.equals("MSLSU23") || mgrGroup.equals("MSLSU56")){%>
                                <option value="<%=mgr%>"><%=(String) loggedUser.getAttribute("userName")%></option>
                                <%}%>
                                
                                <sw:WBOOptionList wboList='<%=usersList%>' displayAttribute="fullName" valueAttribute="userId" scrollToValue="<%=createdBy%>"/>
                            
                            </select>
                            
                            <br/><br/>
                        </td>
                        
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" id="campaignID" name="campaignID" 
                                    onchange="JavaScript: getProjects(this);">
                                <option value="">الكل</option>
                                <sw:WBOOptionList wboList='<%=campaignsList%>' displayAttribute="campaignTitle" valueAttribute="id" scrollToValue="<%=campaignID%>"/>
                            </select>
                            
                            <br/><br/>
                        </td>
                        
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" id="projectID" name="projectID" >
                                <option value="">الكل</option>
                                <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                            </select>
                            <br/><br/>
                        </td>
                        
                        <td style="text-align:center" bgcolor="#dedede" valign="MIDDLE">
                            <select style="font-size: 14px;font-weight: bold; width: 170px;" name="clientType" >
                                <option value="">الكل</option>
                                <option value="11" <%="11".equals(clientType) ? "selected" : ""%>>Customer</option>
                                <option value="12" <%="12".equals(clientType) ? "selected" : ""%> selected>Lead</option>
                            </select>
                            <br/><br/>
                        </td>
                    </tr>
                </table>
            </form>
            
            <br/>
            
            <form name="UNHANDLED_CLIENT_FORM" method="POST">
                <%if (!clients.isEmpty()) {%>
                    <table ALIGN="center" DIR="RTL" bgcolor="#dedede" WIDTH="85%" CELLSPACING=2 CELLPADDING=1>
                        <tr>
                        <td style="font-size:18px; text-align: right" WIDTH="30%">
                            <button id="autoBtn" type="button" onclick="JavaScript: distribution('auto');" value="" style="margin-left: 5%; text-align: center; width: 150px; font-size: 16px; color: blue; font-weight: bold; display: none;">
                                    Auto-Pilot
                                    <img src="images/icons/plane_icon.png" height="24" width="24" alt="distribute client" style="vertical-align: middle" />
                                </button>
                            <input type="checkbox" id="loggedOnly" value="1" style="display: none;"/> <span style="display: none;">Logged Only</span>
                            </td>
                        <td style="font-size:18px; text-align: right" WIDTH="20%">
                            <select name="requestType" id="requestType" style="width: 200px; font-size: 18px;">
                                <option value="" style="color: blue;">نوع الطلب</option>
                                <sw:WBOOptionList wboList="<%=requestTypes%>" displayAttribute="projectName" valueAttribute="projectName" />
                            </select>
                        </td>
                            <td style="font-size:14px; text-align: left; border-left-width: 0px" WIDTH="20%">
                                <button id="manualBTN" type="button" onclick="JavaScript: distribution('manual');" value="" style="margin-left: 5%; text-align: center; width: 150px; font-size: 16px; color: blue; font-weight: bold;">
                                    Manual
                                    <img src="images/icons/manual_pilot.png" height="24" width="24" alt="distribute client" style="vertical-align: middle" />
                                </button>
                            </td>
                            <td style="font-size:16px; color: blue; text-align: right; border-right-width: 0px; border-left-width: 0px" WIDTH="20%">
                                <select name="employeeId" id="employeeId" style="font-size: 14px;font-weight: bold; width: 99%; height: 25px" multiple>
                                    <%
                                    if(mgr.equals((String) loggedUser.getAttribute("userId")) && (mgrGroup.equals("MSLSU14") || mgrGroup.equals("MSLSU23") || mgrGroup.equals("MSLSU56")) ){
                                        for (WebBusinessObject userWbo : usersList) {
                                    %>
                                    <option value="<%=userWbo.getAttribute("userId")%>" style="<%=usersIDsList.contains(userWbo.getAttribute("userId")) ? "color: red; font-weight: bold;" : ""%>"><%=userWbo.getAttribute("fullName")%></option>
                                    <%
                                        }} else{
                                    for (WebBusinessObject userWbo : distributionsList) {
                                    %>
                                    <option value="<%=userWbo.getAttribute("userId")%>" style="<%=usersIDsList.contains(userWbo.getAttribute("userId")) ? "color: red; font-weight: bold;" : ""%>"><%=userWbo.getAttribute("fullName")%></option>
                                    <%
                                        }}
                                    %>
                                </select>
                            </td>
                        </tr>
                    </table>
                    
                    <br>
                    <br>
                <%}%>
                
                <div style="width: 99%;margin-right: auto;margin-left: auto;" id="showClients">
                    <TABLE style="display" id="clientsssss" ALIGN="center" dir="rtl" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4;">
                        <thead>                
                            <tr>
                                <th STYLE="text-align:center; color:white; font-size:14px">
                                    <input type="checkbox" name="checkAll" onchange="selectAll(this);"/>
                                </th>
                                <th STYLE="text-align:center; font-size:14px"><b>م</b></th>
                                <th STYLE="text-align:center; font-size:14px"><b>إسم العميل</b></th>
                                <th STYLE="text-align:center; font-size:14px"><b>حالة العميل</b></th>
                                <th STYLE="text-align:center; font-size:14px"><b>رقم الموبايل</b></th>
                                <th STYLE="text-align:center; font-size:14px"><b>الرقم الدولي</b></th>
                                <th STYLE="text-align:center; font-size:14px"><b>رقم التليفون</b></th>
                                <th STYLE="text-align:center; font-size:14px"><b>البريد الإلكترونى</b></th>
                                <th STYLE="text-align:center; font-size:14px"><b>المصدر</b></th>
                                <th STYLE="text-align:center; font-size:14px"><b>تاريخ الأدخال</b></th>
                            </tr>
                        </thead>
                        <tbody>
                            <%  int counter = 0;
                                String clazz = "";
                                String creationTime = "";
                                boolean isMobileValid;
                                String mobile;
                                for (WebBusinessObject wbo : clients) {
                                    counter++;
                                    if(wbo.getAttribute("creationTime") != null) {
                                        creationTime = ((String) wbo.getAttribute("creationTime"));
                                        creationTime = creationTime.substring(0, 16);
                                    }
                                    isMobileValid = false;
                                    mobile = (String) wbo.getAttribute("mobile");
                                    if (mobile != null && mobile.length() == 11) {
                                        try {
                                            if (Long.parseLong(mobile) > 0) {
                                                isMobileValid = true;
                                            }
                                        } catch (NumberFormatException nfe) {

                                        }
                                    }
                            %>
                            <tr class="<%=clazz%>" style="cursor: pointer; background-color: <%=isMobileValid ? "" : "#fed8d6"%>;" onMouseOver="this.className = ''" onMouseOut="this.className = '<%=clazz%>'">
                                <TD STYLE="text-align: center; width: 5%" nowrap>
                                    <DIV>                   
                                        <input type="checkbox" name="customerId" value="<%=(String) wbo.getAttribute("id")%>" />
                                    </DIV>
                                </TD>
                                <TD STYLE="text-align: center; width: 5%" nowrap>
                                    <DIV>                   
                                        <b><%=counter%></b>
                                    </DIV>
                                </TD>
                                <TD STYLE="text-align: center" nowrap>
                                    <DIV>                           
                                        <b><%=wbo.getAttribute("name")%></b>
                                        <%
                                            if (!isMobileValid) {
                                        %>
                                        <img src="images/user_male_edit.png" style="width: 20px; float: left;" title="تعديل بيانات العميل"
                                             onclick="JavaScript: updateClientInformation('<%=wbo.getAttribute("id")%>');"/>
                                        <%
                                            }
                                        %>
                                    </DIV>
                                </TD>
                                <TD STYLE="text-align: center" nowrap>
                                    <DIV>                  
                                        <b style="color: <%="lead".equals(wbo.getAttribute("statusNameEn")) ? "red" : "black"%>;"><%=wbo.getAttribute("statusNameEn")%></b>
                                    </DIV>
                                </TD>
                                <TD STYLE="text-align: center" nowrap>
                                    <DIV>                   
                                        <b><%=(wbo.getAttribute("mobile") != null && !"UL".equals(wbo.getAttribute("mobile")) ? wbo.getAttribute("mobile") : "")%></b>
                                    </DIV>
                                </TD>
                                <TD STYLE="text-align: center" nowrap>
                                    <DIV>                   
                                        <b><%=(wbo.getAttribute("interPhone") != null && !"UL".equals(wbo.getAttribute("interPhone")) ? wbo.getAttribute("interPhone") : "")%></b>
                                    </DIV>
                                </TD>
                                <TD STYLE="text-align: center" nowrap>
                                    <DIV>                   
                                        <b><%=(wbo.getAttribute("phone") != null && !"UL".equals(wbo.getAttribute("phone")) ? wbo.getAttribute("phone") : "")%></b>
                                    </DIV>
                                </TD>
                                <TD STYLE="text-align: center">
                                    <DIV>                   
                                        <b><%=(wbo.getAttribute("email") != null) ? wbo.getAttribute("email") : ""%></b>
                                    </DIV>
                                </TD>
                                <TD STYLE="text-align: center" nowrap>
                                    <DIV>                           
                                        <b><%=wbo.getAttribute("createdByName") != null ? wbo.getAttribute("createdByName") : ""%></b>
                                    </DIV>
                                </TD>
                                <TD STYLE="text-align: center" nowrap>
                                    <DIV>                           
                                        <b><%=creationTime%></b>
                                    </DIV>
                                </TD>
                            </tr>
                            <%}%>
                        </tbody>
                    </table>
                </div>
                
                <br/>
                <br/>
            </form>
        </fieldset>
    </body>
</html>