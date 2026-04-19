<%-- 
    Document   : approvePaymentPlans
    Created on : Jul 25, 2018, 12:59:04 PM
    Author     : walid
--%>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Units.Units"  />
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>

        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            ArrayList<WebBusinessObject> planLst = (ArrayList<WebBusinessObject>) request.getAttribute("planLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("planLst") : null;
            ArrayList<WebBusinessObject> unitLst = (ArrayList<WebBusinessObject>) request.getAttribute("unitLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("unitLst") : null;
            Calendar cal = Calendar.getInstance();
            WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
            String jDateFormat = user.getAttribute("javaDateFormat").toString();
            SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
            
            String fromDate = (String) request.getAttribute("fromDate");
            String toDate = (String) request.getAttribute("toDate");
            
            String startDate = null;
            String toDateValue = null;
            if (fromDate != null && !fromDate.equals("")) {
                toDateValue = fromDate;
            } else {
                toDateValue = sdf.format(cal.getTime());
            }
            if (toDate != null && !toDate.equals("")) {
                startDate = toDate;
            } else {
                cal.add(Calendar.MONTH, -1);
                startDate = sdf.format(cal.getTime());
            }
            String requestTyp = (String) request.getAttribute("reqTyp");
            
            String stat = (String) request.getSession().getAttribute("currentMode");
            String dir, align, search, fromDatetit, toDatetit, ReqTyp;
            
            if (stat.equals("En")) {
                dir = "LTR";
                align = "center";
                search = "Search";
                fromDatetit = "From Date";
                toDatetit = "To Date";
                ReqTyp = "Request Status";
            } else {
                dir = "RTL";
                align = "center";
                search = "بحث";
                fromDatetit = "من تاريخ";
                toDatetit = "إلى تاريخ";
                ReqTyp = "حالة الطلب";
            }
        %>
        
        <script  type="text/javascript">
            $(document).ready(function () {
                $('#payPlans').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[5, 10, -1], [5, 10, "All"]],
                    iDisplayLength: 5,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
                
                $("#fromDate, #toDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
            
            function approveRequest(planID, clientID){
                var url = "<%=context%>/UnitServlet?op=approveRequest&planID=" + planID + "&clientID=" + clientID;
                window.location.href = url;
            }
            
            function rejectRequest(planID, clientID){
                var url = "<%=context%>/UnitServlet?op=rejectRequest&planID=" + planID + "&clientID=" + clientID;
                window.location.href = url;
            }
            
            function submitForm() {
                var fromD = $("#fromDate").val();
                var toD = $("#toDate").val();
                var reqTyp = $("#reqTyp option:selected").val();
                document.EmployeesLoads.action = "<%=context%>/UnitServlet?op=approvePaymentPlans&fromD="+fromD + "&toD=" + toD + "&reqTyp=" + reqTyp;
                document.EmployeesLoads.submit();
            }
        </script>
    </head>
    <body>
        <fieldset>
            <legend>
                <font style="color: blue;font-size: 17px; font-weight: bold"/> <fmt:message key="paymentP" />
            </legend>
            <form name="EmployeesLoads" method="post"> 
                <table ALIGN="center" DIR="RTL" WIDTH="60%" CELLSPACING=2 CELLPADDING=1 style="margin-bottom: 20px;">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                            <b><font size=3 color="white"><%=fromDatetit%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="40%">
                            <b> <font size=3 color="white"><%=toDatetit%></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" valign="middle">
                            <input id="fromDate" name="fromDate" type="text" readonly value="<%=startDate%>"/><img src="images/showcalendar.gif"/> 
                            <br/><br/>
                        </td>
                        <td bgcolor="#dedede" style="text-align:center" valign="middle">
                            <input id="toDate" name="toDate" type="text" readonly value="<%=toDateValue%>"/><img src="images/showcalendar.gif"/>
                            <br/><br/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%" colspan="2">
                            <b><font size=3 color="white"><%=ReqTyp%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" style="text-align:center" valign="middle" colspan="2">
                            <SELECT id="reqTyp" name="reqTyp" style="width: 50%">
                                <option value="Approval Requested" <%=requestTyp != null && requestTyp.equals("Approval Requested") ? "selected" : ""%>>Approval Requested</option>
                                <option value="Approved" <%=requestTyp != null && requestTyp.equals("Approved") ? "selected" : ""%>>Approved</option>
                                <option value="Rejected" <%=requestTyp != null && requestTyp.equals("Rejected") ? "selected" : ""%>>Rejected</option>
                            </SELECT>
                        </td>
                    </tr>

                    <tr>
                        <td STYLE="text-align:center" bgcolor="#dedede" rowspan="2" WIDTH="20%" colspan="2">
                            <button onclick="JavaScript: submitForm();" STYLE="color: #27272A;font-size:15px;font-weight:bold;height: 35px"><%=search%> <IMG HEIGHT="15" SRC="images/search.gif"/> </button>
                        </td>
                    </tr>
                </table>
                
                <div style="width: 90%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <TABLE ALIGN="center" dir='<fmt:message key="direction" />' id="payPlans" style="width:100%;">
                        <thead>
                            <tr>
                                <th style="width: 2%;"><B></B></th>

                                <th style="width: 24%;">
                                    <B>
                                        <fmt:message key="unit" />
                                    </B>
                                </th>

                                <th style="width: 24%;">
                                    <B>
                                        <fmt:message key="payPlan" />
                                    </B>
                                </th>

                                <th style="width: 24%;">
                                    <B>
                                        <fmt:message key="statusTit" />
                                    </B>
                                </th>

                                <th style="width: 24%;">
                                    <B>
                                        <fmt:message key="client" />
                                    </B>
                                </th>

                                <th style="width: 24%;">
                                    <B>
                                        <fmt:message key="employee" />
                                    </B>
                                </th>

                                <th style="width: 24%;">
                                    <B>
                                        <fmt:message key="creationTime" />
                                    </B>
                                </th>

                                <th style="width: 5%;"><B></B></th>

                                <th style="width: 5%;"><B></B></th>

                                <th style="width: 5%;"><B></B></th>

                                <th style="width: 5%;"><B></B></th>
                            </tr>
                        </thead>
                        <%
                            if(planLst !=null && planLst.size() != 0){
                        %>
                        <tbody>
                            <% int counter = 1;
                            for (WebBusinessObject planWbo : planLst) { 
                                String color = null;
                                if(planWbo.getAttribute("statusTit") != null && planWbo.getAttribute("statusTit").equals("Approved")){
                                   color = "DarkOliveGreen "; 
                                } else if(planWbo.getAttribute("statusTit") != null && planWbo.getAttribute("statusTit").equals("Approval Requested")){
                                   color = "CornflowerBlue"; 
                                } else if(planWbo.getAttribute("statusTit") != null && planWbo.getAttribute("statusTit").equals("Rejected")){
                                   color = "brown"; 
                                }
                            %>
                                <tr style="background-color: <%=color%>">
                                    <td style="width: 2%;">
                                        <%=counter%>
                                    </td>

                                    <% for (WebBusinessObject unitWbo : unitLst) {
                                        if(unitWbo.getAttribute("projectID").equals(planWbo.getAttribute("unitID"))) { %>
                                            <td style="width: 24%;">
                                                <%=unitWbo.getAttribute("projectName")%>
                                            </td>
                                    <% break; } } %>

                                    <td style="width: 24%;">
                                        <%=planWbo.getAttribute("planTitle")%>
                                    </td>

                                    <td style="width: 24%;">
                                        <font style=""/> <%=planWbo.getAttribute("statusTit")%>
                                    </td>

                                    <td style="width: 24%;">
                                        <%=planWbo.getAttribute("clientName")%>
                                    </td>

                                    <td style="width: 24%;">
                                        <%=planWbo.getAttribute("employeeName")%>
                                    </td>

                                    <td style="width: 24%;">
                                        <%=planWbo.getAttribute("CreationTime").toString().substring(0,10)%>
                                    </td>

                                    <td style="width: 5%;">
                                        <a title=" View Plan" style="color: black" href="<%=context%>/UnitServlet?op=showPaymentPlan&planID=<%=planWbo.getAttribute("ID")%>&clientID=<%=planWbo.getAttribute("clientID")%>"> View </a>
                                    </td>

                                    <td style="width: 5%;">
                                        <%
                                            if("Approved".equals(planWbo.getAttribute("statusTit"))) {
                                        %>
                                        <a title=" View Plan PDF " target="blank" href="<%=context%>/UnitServlet?op=showPaymentPlanPDF&planID=<%=planWbo.getAttribute("ID")%>"><img style="margin: 3px" src="images/icons/pdf.png" width="24" height="24"/></a>
                                        <%
                                            }
                                        %>
                                    </td>

                                    <td style="width: 5%;">
                                        <input type="button" value="Approve" onclick="approveRequest('<%=planWbo.getAttribute("ID")%>', '<%=planWbo.getAttribute("clientID")%>');" <%=planWbo.getAttribute("statusTit") != null && (planWbo.getAttribute("statusTit").equals("Approved") || planWbo.getAttribute("statusTit").equals("Rejected")) ? "disabled" : "" %>/>
                                    </td>

                                    <td style="width: 5%;">
                                        <input type="button" value="Reject" onclick="rejectRequest('<%=planWbo.getAttribute("ID")%>', '<%=planWbo.getAttribute("clientID")%>');" <%=planWbo.getAttribute("statusTit") != null && (planWbo.getAttribute("statusTit").equals("Approved") || planWbo.getAttribute("statusTit").equals("Rejected")) ? "disabled" : "" %>/>
                                    </td>
                                </tr>
                            <%counter++;}}%>
                        </tbody>
                    </table>
                </div>
            </form>
        </fieldset>
    </body>
</html>
