<%-- 
    Document   : client_details_Order
    Created on : Aug 14, 2017, 10:45:31 AM
    Author     : fatma
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="java.lang.String"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>

<%
    WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    String issueId = request.getAttribute("issueId") != null ? (String) request.getAttribute("issueId") : null;
    
    WebBusinessObject jobOrderWbo = (WebBusinessObject) request.getAttribute("jobOrderWbo");
    WebBusinessObject eqpInfoWbo = (WebBusinessObject) request.getAttribute("eqpInfoWbo");
    ArrayList<WebBusinessObject> busItmLst = request.getAttribute("busItmLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("busItmLst") : null;
    ArrayList<WebBusinessObject> MItmLst = request.getAttribute("MItmLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("MItmLst") : null;
    ArrayList<WebBusinessObject> sprPrtLst = request.getAttribute("sprPrtLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("sprPrtLst") : null;
%>

<html>
    <c:set var="loc" value="en"/>
    
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Client.client"  />
    
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        
        <style>
            
            table label {
                float: <fmt:message key="align" />;
                text-align: center;
            }
            
            tr:nth-child(odd) td.dataTD {
                background: #f1f1f1;
            }
            
            tr:nth-child(even) td.dataTD {
                background: #FFF;
            }
            
            .table td{
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
            }
            
            .titleTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color:#b9d2ef;
            }
            
            .dataTD {
                float: <fmt:message key="align" />;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }
        </style>  
    </head>
    
    <body>
        <fieldset class="set" style="width: 80%">
            <legend align="center">
                <font color="blue" size="6">
                     <fmt:message key="jobOrderProcessing" /> 
                </font>
            </legend>
                
            <form>
                <table border="0px" class="table" style="width: 80%; text-align: right; margin-bottom: 10px !important; margin-left: auto; margin-right: auto; direction: <fmt:message key="align"/>;" >
                    <tr>
                        <td class="td" style="text-align: center;">
                            <a target="blabck" href="<%=context%>/IssueServlet?op=addSpareParts&issueId=<%=issueId%>&busID=<%=jobOrderWbo.getAttribute("busID")%>" onclick=""  title="<fmt:message key="spareParts"/>" style="padding: 5px;">
                                <image style="height:50px;" src="images/icons/material.png"/>
                            </a>

                            <a target="blabck" href="" onclick="" title="<fmt:message key="workers"/>" style="padding: 5px;">
                                <image style="height:50px;" src="images/icons/visit_icon.png"/>
                            </a>

                            <a target="blabck" href="<%=context%>/IssueServlet?op=addMaintenanceItems&issueId=<%=issueId%>&busID=<%=jobOrderWbo.getAttribute("busID")%>" onclick=""  title="<fmt:message key="mItems"/>" style="padding: 5px;">
                                <image style="height:50px;" src="images/icons/project.png"/>
                            </a>

                            <a target="blabck" href="<%=context%>/IssueServlet?op=addBusinessItems&issueId=<%=issueId%>&busID=<%=jobOrderWbo.getAttribute("busID")%>" onclick="" title="<fmt:message key="actionItems"/>" style="padding: 5px;">
                                <image style="height:50px;" src="images/icons/mantainsWork.png"/>
                            </a>

                            <a target="blanck" href="<%=context%>/AppointmentServlet?op=listJobOrders&pg=2&clientID=<%=clientWbo.getAttribute("id")%>" onclick="" title="<fmt:message key="viewMyOrder"/>" style="padding: 5px;">
                                <image style="height:50px;" src="images/icons/gear_red.png"/>
                            </a>

                            <a target="blanck" href="<%=context%>/IssueServlet?op=jobOrderInvoice&issueId=<%=issueId%>&clientID=<%=clientWbo.getAttribute("id")%>" onclick="" title="<fmt:message key="orderInvoice"/>" style="padding: 5px;">
                                <image style="height:50px;" src="images/icons/icon-claims.png"/>
                            </a>
                        </td>
                    </tr>
                </table>

                <table style="width: 80%;">
                    <tr style="width: 80%;">
                        <td class="td titleTD" style="width: 25%; background-color: #339FFF;">
                             <fmt:message key="details" /> 
                        </td>
                    </tr>

                    <tr style="width: 80%;">
                        <td class="td titleTD" style="width: 25%;">
                             <fmt:message key="clientname" /> 
                        </td>

                        <td class="td dataTD" style="width: 100%;">
                             <%=clientWbo.getAttribute("name")%> 
                        </td>

                        <td class="td titleTD" style="width: 25%;">
                            <fmt:message key="clientid" />
                        </td>

                        <td class="td dataTD" style="width: 100%;">
                             <%=clientWbo.getAttribute("clientNO")%> 
                        </td>
                    </tr>

                    <tr style="width: 80%;">
                        <td class="td titleTD" style="width: 25%;">
                            <fmt:message key="phone"/>
                        </td>

                        <td class="td dataTD" style="width: 100%;">
                             <%=clientWbo.getAttribute("phone") != null ? clientWbo.getAttribute("phone") : ""%> 
                        </td>

                        <td class="td titleTD" style="width: 25%;">
                            <fmt:message key="mobile"/>
                        </td>

                        <td class="td dataTD" style="width: 100%;">
                             <%=clientWbo.getAttribute("mobile") != null ? clientWbo.getAttribute("mobile") : ""%> 
                        </td>
                    </tr>

                    <tr style="width: 80%;">
                        <td class="td titleTD" style="width: 25%;">
                            <fmt:message key="email"/>
                        </td>

                        <td class="td dataTD" style="width: 100%;">
                             <%=clientWbo.getAttribute("email") != null ? clientWbo.getAttribute("email") : ""%> 
                        </td>

                        <td class="td titleTD" style="width: 25%;">
                            <fmt:message key="address" />
                        </td>

                        <td class="td dataTD" style="width: 100%;">
                             <%=clientWbo.getAttribute("address") != null && !clientWbo.getAttribute("address").equals("UL") ? clientWbo.getAttribute("address") : ""%> 
                        </td>
                    </tr>
                </table>

                <table style="width: 80%;">
                    <tr style="width: 80%;">
                        <td class="td titleTD" style="width: 25%; background-color: #00CF7B;">
                             <fmt:message key="jobOrderDetails" /> 
                        </td>
                    </tr>

                    <tr style="width: 80%;">
                        <td class="td titleTD" style="width: 25%; background-color: #9CFDD6;">
                             <img src="images/icons/Numbers.png" height="18" width="18" /> <fmt:message key="orderID" /> 
                        </td>

                        <td class="td dataTD" style="width: 100%;">
                             <%=jobOrderWbo.getAttribute("busID")%> 
                             <input type="hidden" id="busID" name="busID" value="<%=jobOrderWbo.getAttribute("busID")%>">
                        </td>

                        <td class="td titleTD" style="width: 25%; background-color: #9CFDD6;">
                            <fmt:message key="orderstatus" />
                        </td>

                        <td class="td dataTD" style="width: 100%;">
                             <%=jobOrderWbo.getAttribute("status")%> 
                        </td>
                    </tr>

                    <tr style="width: 80%;">
                        <td class="td titleTD" style="width: 25%; background-color: #9CFDD6;">
                            <fmt:message key="creatorName"/>
                        </td>

                        <td class="td dataTD" style="width: 100%;">
                             <%=jobOrderWbo.getAttribute("creatorName")%> 
                        </td>

                        <td class="td titleTD" style="width: 25%; background-color: #9CFDD6;">
                            <fmt:message key="creationTime"/>
                        </td>

                        <td class="td dataTD" style="width: 100%;">
                            <%String[] cTime = jobOrderWbo.getAttribute("creationTime").toString().split(":");%>
                             <%=cTime[0]+":"+cTime[1]%> 
                        </td>
                    </tr>

                    <tr style="width: 80%;">
                        <td class="td titleTD" style="width: 25%; background-color: #9CFDD6;">
                            <fmt:message key="owner"/>
                        </td>

                        <td class="td dataTD" style="width: 100%;">
                             <%=jobOrderWbo.getAttribute("oUsr")%> 
                        </td>
                    </tr>

                    <tr style="width: 80%;">
                        <td class="td titleTD" style="width: 25%; background-color: #9CFDD6;">
                            Equipment Title
                        </td>

                        <td class="td dataTD" style="width: 100%;">
                             <%=eqpInfoWbo.getAttribute("eqpName")%> 
                        </td>
                        <%if(eqpInfoWbo.getAttribute("eqpInfo") != null && !(eqpInfoWbo.getAttribute("eqpInfo").toString()).equals("")){%>
                      <tr style="width: 80%;">
                        <td class="td titleTD" style="width: 25%; background-color: #9CFDD6;">
                            Floor no.
                        </td><%

                                String[] parts= ((String)eqpInfoWbo.getAttribute("eqpInfo")).split(":");
                                String[] floor = parts[1].split("R");   //floor[0]
                                String[] room = parts[2].split("M");   //room[0]    modle=parts[3]
                                %>

                        <td class="td dataTD" style="width: 100%;">
                            <div style="padding-top: 6px;"><%=floor[0]%></div> 
                        </td>
                         <td class="td titleTD" style="width: 25%; background-color: #9CFDD6;">
                            Room no.
                        </td>

                        <td class="td dataTD" style="width: 100%;">
                            <div style="padding-top: 6px;"><%=room[0]%></div>
                        </td>
                    </tr>
                    <%}%>

                </table>

                <table style="width: 80%;">
                    <tr style="width: 80%;">
                        <td class="td titleTD" style="width: 25%; background-color: #E2E600;" colspan="2">
                             <fmt:message key="orderItms" /> 
                        </td>
                    </tr>

                    <%
                        if((busItmLst != null && !busItmLst.isEmpty()) || (MItmLst != null && !MItmLst.isEmpty()) || (sprPrtLst != null && !sprPrtLst.isEmpty())){
                    %>
                            <tr style="width: 80%;">
                                <td class="td titleTD" style="width: 7%; background-color: #FDFF9A;">
                                     <fmt:message key="itmCode" /> 
                                </td>

                                <td class="td titleTD" style="width: 28%; background-color: #FDFF9A;">
                                    <fmt:message key="itmName" />
                                </td>

                                <td class="td titleTD" style="width: 14%; background-color: #FDFF9A;">
                                    <fmt:message key="creatorName"/>
                                </td>

                                <td class="td titleTD" style="width: 14%; background-color: #FDFF9A;">
                                    <fmt:message key="creationTime"/>
                                </td>

                                <td class="td titleTD" style="width: 7%; background-color: #FDFF9A;">
                                    <fmt:message key="itmRate"/>
                                </td>

                                <td class="td titleTD" style="width: 14%; background-color: #FDFF9A;">
                                    <fmt:message key="numUnit"/>
                                </td>

                                <td class="td titleTD" style="width: 14%; background-color: #FDFF9A;">
                                    <fmt:message key="itmPrice"/>
                                </td>
                            </tr>

                    <% 
                            WebBusinessObject busItmWbo = new WebBusinessObject();
                            for(int index=0; index<busItmLst.size(); index++){
                                busItmWbo = busItmLst.get(index);
                    %>
                                <tr style="background: #f1f1f1;">
                                    <td style="width: 7%;">
                                         <%=busItmWbo.getAttribute("code")%> 
                                    </td>

                                    <td style="width: 28%;">
                                         <%=busItmWbo.getAttribute("prjName")%> 
                                    </td>

                                    <td style="width: 14%;">
                                         <%=busItmWbo.getAttribute("creatorName")%> 
                                    </td>

                                    <td style="width: 14%;">
                                        <%cTime = busItmWbo.getAttribute("creationTime").toString().split(":");%>
                                         <%=cTime[0]+":"+cTime[1]%> 
                                    </td>

                                    <td style="width: 7%;">
                                         <%=busItmWbo.getAttribute("option3")%> 
                                    </td>

                                    <td style="width: 14%;">
                                         <%=busItmWbo.getAttribute("hourNum")%> Hour/s 
                                    </td>

                                    <td style="width: 14%;">
                                         <%=busItmWbo.getAttribute("total")%> 
                                    </td>
                                </tr>
                        <% 
                            }

                            WebBusinessObject MItmWbo = new WebBusinessObject();
                            for(int index=0; index<MItmLst.size(); index++){
                                MItmWbo = MItmLst.get(index);
                        %>
                                <tr style="background: #f1f1f1;">
                                    <td style="width: 7%;">
                                         <%=MItmWbo.getAttribute("code")%> 
                                    </td>

                                    <td style="width: 28%;">
                                         <%=MItmWbo.getAttribute("prjName")%> 
                                    </td>

                                    <td style="width: 14%;">
                                         <%=MItmWbo.getAttribute("creatorName")%> 
                                    </td>

                                    <td style="width: 14%;">
                                        <%cTime = MItmWbo.getAttribute("creationTime").toString().split(":");%>
                                         <%=cTime[0]+":"+cTime[1]%> 
                                    </td>

                                    <td style="width: 7%;">
                                         <%=MItmWbo.getAttribute("option3")%> 
                                    </td>

                                    <td style="width: 14%;">
                                         <%=MItmWbo.getAttribute("hourNum")%> Unit/s 
                                    </td>

                                    <td style="width: 14%;">
                                         <%=MItmWbo.getAttribute("total")%> 
                                    </td>
                                </tr>
                        <%  
                            }
                            WebBusinessObject sprPrtWbo = new WebBusinessObject();
                            for(int index=0; index<sprPrtLst.size(); index++){
                                sprPrtWbo = sprPrtLst.get(index);
                        %>
                                <tr style="background: #f1f1f1;">
                                    <td style="width: 7%;">
                                         <%=sprPrtWbo.getAttribute("code")%> 
                                    </td>

                                    <td style="width: 28%;">
                                         <%=sprPrtWbo.getAttribute("prjName")%> 
                                    </td>

                                    <td style="width: 14%;">
                                         <%=sprPrtWbo.getAttribute("creatorName")%> 
                                    </td>

                                    <td style="width: 14%;">
                                        <%cTime = sprPrtWbo.getAttribute("creationTime").toString().split(":");%>
                                         <%=cTime[0]+":"+cTime[1]%> 
                                    </td>

                                    <td style="width: 7%;">
                                         <%=sprPrtWbo.getAttribute("option3")%> 
                                    </td>

                                    <td style="width: 14%;">
                                         <%=sprPrtWbo.getAttribute("hourNum")%> Piece 
                                    </td>

                                    <td style="width: 14%;">
                                         <%=sprPrtWbo.getAttribute("total")%> 
                                    </td>
                                </tr>
                    <%
                            }
                        } else { 
                    %>
                        <tr style="background: #f1f1f1;">
                            <td colspan="7">
                                 No Items For This Order 
                            </td>
                        </tr>
                    <%
                        }
                    %>
                </table>
            </form>
        </fieldset>
    </body>
</html>