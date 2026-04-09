<%-- 
    Document   : search_for_client_byMob
    Created on : May 30, 2021, 11:03:22 PM
    Author     : mariam
--%>

<%@page import="com.silkworm.common.UserMgr"%>
<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Sales_Market.Sales_Market"  />
    <!DOCTYPE html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] clientsAttributes = {"clientName", "mobile", "interPhone", "clientCreationTime", "mct", "diffDays", "ratedBy", "rateName"};
        String[] clientsListTitles = new String[9];

        String[] unRClientsAttributes = {"clientName", "mobile", "interPhone", "clientCreationTime"};
        String[] unRClientsListTitles = new String[4];
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        ArrayList<WebBusinessObject> departments = (ArrayList<WebBusinessObject>) request.getAttribute("departments");
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "all";
        String employeeID = request.getAttribute("employeeID") != null ? (String) request.getAttribute("employeeID") : "";
        ArrayList<WebBusinessObject> employeeList = (ArrayList<WebBusinessObject>) request.getAttribute("employeeList");
        String clientMobile = request.getAttribute("clientMobile") != null ? (String) request.getAttribute("clientMobile") : "";
        String searchBy = request.getAttribute("searchBy")!= null ? (String) request.getAttribute("searchBy"): "mobile";

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign, department,employees,fromDate, toDate, display, campaign, all, employeeName, clsStr, unclsStr, typeOfRequest, ratedDate,
                unratedDate, dir, title,interMobile,mobile,interOrLocal;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            clientsListTitles[0] = "Client Name";
            clientsListTitles[1] = "Client Mobile";
            clientsListTitles[2] = "International No";
            clientsListTitles[3] = "Creation Time";
            clientsListTitles[4] = " First Classification Time";
            clientsListTitles[5] = "Difference Day(s)";
            clientsListTitles[6] = "Classified By";
            clientsListTitles[7] = "Classification";
            clientsListTitles[8] = "Department";

            unRClientsListTitles[0] = "Client Name";
            unRClientsListTitles[1] = "Client Mobile";
            unRClientsListTitles[2] = "International No";
            unRClientsListTitles[3] = "Creation Time";

            fromDate = "From Date";
            toDate = "To Date";
            display = "Display Report";
            campaign = "Campaign";
            all = "All";
            employeeName = "Employee";
            clsStr = " Rated Clients ";
            unclsStr = " Unrated Clients ";
            typeOfRequest = "Type of Request";
            title = " Search clients by mobile";
            department="Department";
            employees="employees";
            interMobile="International";
            mobile="Local Mobile";
            interOrLocal="Internationl or local";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            clientsListTitles[0] = "اسم العميل";
            clientsListTitles[1] = "الموبايل";
            clientsListTitles[2] = "الرقم الدولى";
            clientsListTitles[3] = "تاريخ التسجيل";
            clientsListTitles[4] = " تاريخ التصنيف الأول ";
            clientsListTitles[5] = "الفارق بالأيام";
            clientsListTitles[6] = "التصنيف بواسطة";
            clientsListTitles[7] = "التصنيف";
            clientsListTitles[8] = "الاداره";

            unRClientsListTitles[0] = "اسم العميل";
            unRClientsListTitles[1] = "الموبايل";
            unRClientsListTitles[2] = "الرقم الدولى";
            unRClientsListTitles[3] = "تاريخ التسجيل";

            fromDate = "من تاريخ";
            toDate = "إلي تاريخ";
            display = "أعرض التقرير";
            campaign = "الحملة";
            all = "الكل";
            employeeName = "الموظف";
            clsStr = " عملاء مصنفين ";
            unclsStr = " عملاء غير مصنفيين ";
            typeOfRequest = "نوع الطلب";
            ratedDate = " تاريخ التقييم";
            unratedDate = " تاريخ التسجيل";
            title = "بحث  إدارى";
            department="الادارة";
            employees="الموظفين";
            interMobile="موبيل دولى";
            mobile="موبيل محلى";
            interOrLocal="نوع الموبيل";
        }
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery.datetimepicker.js"/>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css"/>
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet"></link>
    </head>
    <STYLE>

        #clientsData_wrapper{
            width:80%;
            margin-left: 130px;
        }
        #filterTable td{
            padding:12px;
        }
        #filterTable tr td:nth-child(2){
            width:300px
        }
    </style>
    <script type="text/javascript" language="javascript">
        $(document).ready(function () {
           
        $("#departmentID").select2();
            
            if ('<%=departmentID%>' !=="all"){ 
                
                $("#departmentID").val('<%=departmentID%>').change();
            };
           
                
                $("#<%=searchBy%>").attr("checked","checked");
            
            $("#clientMobile").val('<%=clientMobile%>');
             
            // validateMobile($("#clientMobile"));
            $("#clientsData").dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true

            }).fadeIn(2000);
            
           
        });
        
        function validateMobile(obj){
            $("#alertText").show();
            var limit =$("input[name=searchBy]").val()==="mobile"? 11: 13;
            if (!validateData2("numeric", document.getElementById("clientMobile"))) {
                $("#validateImg").show();
                $("#validateImg").attr("src","images/msdropdown/wrong.png");
                $("#alertText").html("ليس رقم");
            }else if($(obj).val().length!==limit){
                $("#validateImg").show();
                $("#validateImg").attr("src","images/msdropdown/wrong.png");
                 $("#alertText").html("غير صالح");
                
            }else{
                $("#alertText").html(" ");
                $("#validateImg").show();
                $("#validateImg").attr("src","images/ok2.png");
                //$("#search").removeAttr("disabled");
            }
        }
        
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
//                            output.push('<option value="">' + '<%=all%>' + '</option>');
                            var createdBy = $("#employeeID");
                            $(createdBy).html("");
                            var info = $.parseJSON(jsonString);
                            for (var i = 0; i < info.length; i++) {
                                var item = info[i];
                                output.push('<option   value="' + item.userId + '">' + item.fullName + '</option>');
                            }
                            createdBy.html(output.join(''));
                            if (isReload) {
                                $("#employeeID").val('<%=employeeID%>');
                            }
                        } catch (err) {
                        }
                        $("#employeeID").select2();
                        $("#employeeID").val(info[0].userId);
                    }
                });
            }
    </script>


    <body>
        <fieldset align=center class="set" style="width: 95%">
            <legend align="center">
                        <font color="blue" size="6">
                             <%=title%>
                        </font>
                    </legend>
            <form name="CLASSIFICATION_FORM" action="<%=context%>/SearchServlet?op=getSearchForClientByMob" method="POST">
                <br/>
                <table class="blueBorder" align="center" dir="<%=dir%>" id="filterTable" cellpadding="0" cellspacing="0" width="580" style="border-width: 1px; border-color: white; display: block;" >
                    
                    <tr>
                        <td colspan="1" class="blueBorder blueHeaderTD" style="font-size:18px;"   width="48%">

                            <font style="font-size: 15px;">
                            <%=department%>
                            </font>
                        </td>

                        <td colspan="1" bgcolor="#dedede" valign="middle" id="nclssTrSlc">
                            <select id="departmentID" name="departmentID" style="font-size: 14px; font-weight: bold; width: 90%;" onchange="getEmployees(this, false);">
                                <% if (departments != null) {%>
                                <sw:WBOOptionList wboList="<%=departments%>" displayAttribute="projectName" valueAttribute="projectID"  />
                                <% } %>
                            </select>
                        </td>
                    </tr>
                    <tr style="display:none;">
                        <td colspan="1" class="blueBorder blueHeaderTD" style="font-size:18px;"   width="48%">

                            <font style="font-size: 15px;">
                            <%=employees%>
                            </font>
                        </td>

                        <td colspan="1" bgcolor="#dedede" valign="middle" id="nclssTrSlc">
                            <select name="employeeID" id="employeeID" style="width: 90%; font-size: 18px;">
                            </select>
                        </td>
                    </tr>
                    
                    <tr>
                        <td colspan="1" class="blueBorder blueHeaderTD" style="font-size:18px;"   width="48%">

                            <font style="font-size: 15px;">
                            الموبيل
                            </font>
                        </td>

                        <td colspan="1" bgcolor="#dedede" valign="middle" id="nclssTrSlc">
                            <INPUT id="mobile" name="searchBy" type="radio" value="mobile"/>
                            <font style="font-size: 15px;">
                            <%=mobile%>
                            </font>
                        <INPUT id="INTER_PHONE" name="searchBy" type="radio" value="INTER_PHONE"/>
                        
                            <font style="font-size: 15px;">
                            <%=interMobile%>
                            </font>
                            <span id="alertText" style="display:none;color: red;font-weight: bold;margin:0px">  </span>
                            <input type="text" id="clientMobile" name="clientMobile" style="width:90%;" onchange="javascript:validateMobile(this);"/>
                            <img style="display:none;vertical-align: middle;width:20px" id="validateImg" />
                                
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="border: 0px;">
                            <input id="search"  type="submit" value="بجث" class="button" style="width:20%;"/>
                        </td>
                    </tr>
                </table>
                </br>
                <% if (clientsList != null) {%>

                <table id="clientsData" style="width:100%" ALIGN="<%=xAlign%>" dir=<fmt:message key="direction"/>  >
                    <thead>
                        <tr>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;"> <fmt:message key="name"/></th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;"> <fmt:message key="mobile"/></th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="interMobile"/> </th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="createdBy"/> </th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="creationTime"/> </th>
                        </tr>                       
                    </thead>
                    <% for (WebBusinessObject wbo : clientsList) {%>
                    <tbody>
                        <tr  style="cursor: pointer" id="row">

                            <TD>
                                <%if (wbo.getAttribute("name") != null) {%>
                                <b>
                                    <%=wbo.getAttribute("name")%> 
                                    <a target="_blanck" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("id")%>">
                                        <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"
                                             onmouseover="JavaScript: changeCommentCounts('<%=wbo.getAttribute("id")%>', this);"/>
                                    </a>
                                    <a target="_blanck" href="<%=context%>/IssueServlet?op=newComplaint&type=call&clientId=<%=wbo.getAttribute("id")%>&clientType=30-40">
                                        <img src="images/icons/eHR.gif" width="30" style="float: left;" title="تفاصيل"
                                             onmouseover="JavaScript: changeCommentCounts('<%=wbo.getAttribute("id")%>', this);"/>
                                    </a>
                                </b>
                                <%if (securityUser.getUserId().equalsIgnoreCase((String) wbo.getAttribute("createdBy")) || securityUser.getUserId().equalsIgnoreCase((String) wbo.getAttribute("ownerUser"))) {%>
                                <img src="images/icons/done.png" width="20" style="float: left;" title="Owner"/>
                                <%}%>
                                <%}%>
                            </TD>
                            <TD>
                                <%if (wbo.getAttribute("mobile") != null) {%>
                                <b><%=wbo.getAttribute("mobile")%></b>
                                <%}%>
                            </TD>
                            <TD>
                                <%if (wbo.getAttribute("INTER_PHONE") != null) {%>
                                <b><%=wbo.getAttribute("INTER_PHONE")%></b>
                                <%}%>
                            </TD>
                            <TD>
                                <%if (wbo.getAttribute("created_by") != null) {
                                UserMgr userMgr=UserMgr.getInstance();
                                String userName=userMgr.getByKeyColumnValue("key", wbo.getAttribute("created_by").toString(), "key1");
                                %>
                                <b><%=userName%></b>
                                <%}%>
                            </TD>
                            <TD>
                                <%if (wbo.getAttribute("creation_time") != null) {%>
                                <b><%=wbo.getAttribute("creation_time").toString().split(" ")[0]%></b>
                                <%}%>
                            </TD>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>  

                </table>
                <%}%>
            </form>
        </fieldset>
    </body>
</html>
