<%-- 
    Document   : paymentPlanLst
    Created on : Jul 6, 2017, 1:54:26 PM
    Author     : fatma-PC
--%>

<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
        
    ArrayList<WebBusinessObject> planLst = (ArrayList<WebBusinessObject>) request.getAttribute("planLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("planLst") : null;
    ArrayList<WebBusinessObject> unitLst = (ArrayList<WebBusinessObject>) request.getAttribute("unitLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("unitLst") : null;
    
    String clientID = (String) request.getAttribute("clientID") != null ? (String) request.getAttribute("clientID") : null;
%>

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
        
        <script type="text/javascript">
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
            });
            
            function deletePlan(planID, clientID){
                var url = "<%=context%>/UnitServlet?op=cancelPlan&planID=" + planID + "&clientID=" + clientID;
                window.location.href = url;
            }
            
            function requestApproval(planID, clientID){
                var url = "<%=context%>/UnitServlet?op=requestApproval&planID=" + planID + "&clientID=" + clientID;
                window.location.href = url;
            }
        </script>
    </head>
    
    <body>
        <div style="width: 70%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
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
                                <fmt:message key="CreatedBy" />
                            </B>
                        </th>
                        
                        <th style="width: 24%;">
                            <B>
                                <fmt:message key="CreationTime" />
                            </B>
                        </th>
                        
                        <th style="width: 5%;"><B></B></th>
                        
                        <th style="width: 5%;"><B></B></th>
                        
                        <th style="width: 5%;"><B></B></th>
                        
                        <th style="width: 5%;"><B></B></th>
                        
                        <th style="width: 5%;"><B></B></th>
                    </tr>
                </thead>
                <tbody>
                    <% int counter = 1;
                    for (WebBusinessObject planWbo : planLst) { 
                        String color = null;
                        if(planWbo.getAttribute("statusTit") != null && planWbo.getAttribute("statusTit").equals("Approved")){
                           color = "green"; 
                        } else if(planWbo.getAttribute("statusTit") != null && planWbo.getAttribute("statusTit").equals("Approval Requested")){
                           color = "blue"; 
                        } else if(planWbo.getAttribute("statusTit") != null && planWbo.getAttribute("statusTit").equals("Rejected")){
                           color = "red"; 
                        } else if(planWbo.getAttribute("statusTit") != null && planWbo.getAttribute("statusTit").equals("Proposed")){
                           color = "yellowgreen"; 
                        } else if(planWbo.getAttribute("statusTit") != null && planWbo.getAttribute("statusTit").equals("Canceled")){
                           color = "grey"; 
                        }
                    %>
                        <tr>
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
                                <font style="color:<%=color%>"/>
                                <%=planWbo.getAttribute("statusTit")%>
                            </td>
                            
                            <td style="width: 24%;">
                                <%=planWbo.getAttribute("createdBy")%>
                            </td>
                            
                            <td style="width: 24%;">
                                <%=planWbo.getAttribute("creationTime").toString().split(" ")[0]%>
                            </td>
                            
                            <td style="width: 5%;">
                                <a title=" View Plan " href="<%=context%>/UnitServlet?op=showPaymentPlan&planID=<%=planWbo.getAttribute("ID")%>&clientID=<%=clientID%>"> View </a>
                            </td>
                            
                            <td style="width: 5%;">
                                <a title=" View Plan PDF " href="<%=context%>/UnitServlet?op=showPaymentPlanPDF&planID=<%=planWbo.getAttribute("ID")%>"><img style="margin: 3px" src="images/icons/pdf.png" width="24" height="24"/></a>
                            </td>
                            
                            <td style="width: 5%;">
                                <!--<a onclick="deletePlan('<%=planWbo.getAttribute("ID")%>', '<%=clientID%>');" title=" Cancel Plan "> <img src="images/icons/clear.png" width="20" height="20"/></a>-->
                                <input type="button" value="Cancel" onclick="deletePlan('<%=planWbo.getAttribute("ID")%>', '<%=clientID%>');" <%=planWbo.getAttribute("statusTit") != null && (planWbo.getAttribute("statusTit").equals("Canceled") || planWbo.getAttribute("statusTit").equals("Approved")) ? "disabled" : "" %>/>
                            </td>
                            
                            <td style="width: 5%;">
                                <input type="button" value="Request Approval" onclick="requestApproval('<%=planWbo.getAttribute("ID")%>', '<%=clientID%>');" <%=planWbo.getAttribute("statusTit") != null && (planWbo.getAttribute("statusTit").equals("Canceled") || planWbo.getAttribute("statusTit").equals("Approval Requested") || planWbo.getAttribute("statusTit").equals("Approved")) ? "disabled" : "" %>/>
                            </td>
                            
                            <td style="width: 5%;">
                                <a title=" Email This Offer "><img src="images/complain-drag.png" width="20" height="20"/> </a>
                            </td>
                        </tr>
                    <%counter++;}%>
                </tbody>
            </table>
        </div>
    </body>
</html>
