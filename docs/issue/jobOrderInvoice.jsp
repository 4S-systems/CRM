<%-- 
    Document   : jobOrderInvoice
    Created on : Sep 11, 2017, 10:34:31 AM
    Author     : fatma
--%>

<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>

<%
    WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
    WebBusinessObject jobOrderWbo = (WebBusinessObject) request.getAttribute("jobOrderWbo");
    ArrayList<WebBusinessObject> busItmLst = (ArrayList<WebBusinessObject>) request.getAttribute("busItmLst");
    ArrayList<WebBusinessObject> MItmLst = (ArrayList<WebBusinessObject>) request.getAttribute("MItmLst");
    ArrayList<WebBusinessObject> sprPrtLst = (ArrayList<WebBusinessObject>) request.getAttribute("sprPrtLst");
    
    int bTotal=0; int mTotal=0; int spTotal=0; int totalPrice=0;
    
    String issueId = (String) request.getAttribute("issueId");
    String nowTime = (String) request.getAttribute("nowTime");
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
        <title> Job Order Invoice </title>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        
        <style>
            td.dataTD {
                background: #f1f1f1;
            }
            
            .table td{
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
            }
            
            * > *{
                 vertical-align : middle;
            }
        </style>
        
        <script type="text/javascript">
            function printInvoice(){
                var printContents = $("#invoiceDiv").html();
                
                var style = "<style> td.dataTD{background: #f1f1f1;} .table td{text-align:center; font-family:Georgia, \"Times New Roman\", Times, serif; font-size:14px; font-weight: bold; border: none;} * > *{vertical-align : middle;} </style>";
                
                var printWindow = window.open('', '', 'height=400, width=800');
                
                printWindow.document.write('<html> <head>');
                printWindow.document.write(style);
                printWindow.document.write('</head> <body>');
                printWindow.document.write(printContents);
                printWindow.document.write('</body> </html>');
                printWindow.print();
            }
        </script>
    </head>
    
    <body>
        <fieldset class="set" style="width: 80%">
            <legend align="center">
                <font color="blue" size="7">
                     <fmt:message key="orderInvoice" /> 
                </font>
            </legend>
                
            <div align="right" style="padding-right: 5%; padding-bottom: 5%;">
                <button class="button" style="text-align: center; width: 12%;" onclick="printInvoice();"> Print <img src="images/printer2.png" width="20" height="20"/> </button>
            </div>
                
            <div id="invoiceDiv">
                <table class="table" border="0px" style="width: 50%; float: left; padding-left: 10%; padding-bottom: 5%;" align="left">
                    <tr style="width: 80%;">
                        <td>
                            <image src="images/lamp-01_1x.jpg" style="width: 150PX; height: 180px; float: left;"/>
                        </td>
                    </tr>
                </table>

                <table class="table" border="0px" style="width: 50%; float: right; padding-right: 10%; padding-bottom: 5%;" align="left">
                    <tr style="width: 80%;">
                        <td class="td dataTD" style="width: 50%; text-align: left;">
                             <fmt:message key="sysDate" /> 
                        </td>

                        <td style="width: 50%; text-align: left; font-size: 11px;">
                             <%=nowTime%> 
                        </td>
                    </tr>

                    <tr style="width: 80%;">
                        <td class="td dataTD" style="width: 50%; text-align: left;">
                             Job Order No.  
                        </td>

                        <td style="width: 50%; text-align: left; font-size: 11px;">
                             <%=jobOrderWbo.getAttribute("businessID")%> 
                        </td>
                    </tr>

                    <tr style="width: 80%;">
                        <td class="td dataTD" style="width: 50%; text-align: left;">
                             <fmt:message key="creatorName" /> 
                        </td>

                        <td style="width: 50%; text-align: left; font-size: 11px;">
                             <%=jobOrderWbo.getAttribute("creatorName")%> 
                        </td>
                    </tr>

                    <tr style="width: 80%;">
                        <td class="td dataTD" style="width: 50%; text-align: left;">
                             <fmt:message key="creationTime"/> 
                        </td>

                        <td style="width: 50%; text-align: left; font-size: 12px;">
                            <%String[] cTime = jobOrderWbo.getAttribute("creationTime").toString().split(":");%>
                             <%=cTime[0]+":"+cTime[1]%> 
                        </td>
                    </tr>
                </table>
                    
                <table class="table" border="0px" style="width: 50%; padding-bottom: 5%; padding-right: 10%; float: right;">
                    <tr style="width: 80%; text-align: left;">
                        <td class="td dataTD" style="width: 50%; background: gray; font-size: 20px; text-align: left;" colspan="2">
                             <fmt:message key="billTo" /> 
                        </td>
                    </tr>
                    
                    <tr style="width: 80%;">
                        <td class="td dataTD" style="width: 50%; text-align: left;">
                             <fmt:message key="clientname" /> 
                        </td>

                        <td style="width: 50%; text-align: left; font-size: 11px;">
                             <%=clientWbo.getAttribute("name")%> 
                        </td>
                    </tr>

                    <tr style="width: 80%;">
                        <td class="td dataTD" style="width: 50%; text-align: left;">
                             <fmt:message key="address" /> 
                        </td>

                        <td style="width: 50%; text-align: left; font-size: 11px;">
                             <%=clientWbo.getAttribute("address") != null && !clientWbo.getAttribute("address").equals("UL") ? clientWbo.getAttribute("address") : ""%> 
                        </td>
                    </tr>

                    <tr style="width: 80%;">
                        <td class="td dataTD" style="width: 50%; text-align: left;">
                             <fmt:message key="mobile"/> 
                        </td>

                        <td style="width: 50%; text-align: left; font-size: 11px;">
                             <%=clientWbo.getAttribute("mobile") != null ? clientWbo.getAttribute("mobile") : ""%> 
                        </td>
                    </tr>

                    <tr style="width: 80%;">
                        <td class="td dataTD" style="width: 50%; text-align: left;">
                             <fmt:message key="phone"/> 
                        </td>

                        <td style="width: 50%; text-align: left; font-size: 11px;">
                             <%=clientWbo.getAttribute("phone") != null ? clientWbo.getAttribute("phone") : ""%> 
                        </td>
                    </tr>

                    <tr style="width: 80%;">
                        <td class="td dataTD" style="width: 50%; text-align: left;">
                             <fmt:message key="email"/> 
                        </td>

                        <td style="width: 50%; text-align: left; font-size: 11px;">
                             <%=clientWbo.getAttribute("email") != null ? clientWbo.getAttribute("email") : ""%> 
                        </td>
                    </tr>
                </table> 

                <table border="1" style="width: 90%; border-color: black;" align="center">
                    <tr style="width: 80%; background: #0099cc; border-width: 3;  border-color: black; font-weight: bold;">
                        <td style="text-align: center; width: 10%;">
                             <fmt:message key="itmCode"/> 
                        </td>

                        <td style="text-align: center; width: 31%;">
                             <fmt:message key="itmName"/> 
                        </td>
                        
                        <td style="text-align: center; width: 10%;">
                            <fmt:message key="itmRate"/>
                        </td>

                        <td style="text-align: center; width: 24%;">
                             <fmt:message key="numUnit"/> 
                        </td>

                        <td style="text-align: center; width: 17%;">
                             <fmt:message key="itmPrice"/> 
                        </td>
                    </tr>

                    <%
                        if(busItmLst != null && !busItmLst.isEmpty()){
                    %>
                            <tr style="width: 80%; background: #D5FFB4; border-width: 1; border-color: black;">
                                <td colspan="5" style="text-align: center; font-weight: bold;">
                                     <fmt:message key="actionItems"/> 
                                </td>
                            </tr>

                            <%
                                WebBusinessObject busItmWbo = new WebBusinessObject();
                                for(int index=0; index<busItmLst.size(); index++){
                                    busItmWbo = busItmLst.get(index);
                            %>
                                    <tr style="width: 80%; border-width: 3;  border-color: black;">
                                        <td style="text-align: center; width: 7%;">
                                             <%=busItmWbo.getAttribute("code")%> 
                                        </td>

                                        <td style="text-align: center; width: 28%;">
                                             <%=busItmWbo.getAttribute("prjName")%> 
                                        </td>
                                        
                                        <td style="text-align: center; width: 7%;">
                                             <%=busItmWbo.getAttribute("option3")%> 
                                        </td>

                                        <td style="text-align: center; width: 21%;">
                                             <%=busItmWbo.getAttribute("hourNum")%> Hour/s 
                                        </td>

                                        <td style="text-align: center; width: 14%;">
                                             <%=busItmWbo.getAttribute("total")%> 
                                        </td>
                                    </tr>

                    <%
                                bTotal += Integer.parseInt(busItmWbo.getAttribute("total").toString());
                            }
                        }
                    %>

                    <%
                        if(MItmLst != null && !MItmLst.isEmpty()){
                    %>
                            <tr style="width: 80%; background: #D5FFB4; border-width: 1;">
                                <td colspan="5" style="text-align: center; font-weight: bold;">
                                    <fmt:message key="mItems"/>
                                </td>
                            </tr>

                            <%
                                WebBusinessObject MItmWbo = new WebBusinessObject();
                                for(int index=0; index<MItmLst.size(); index++){
                                    MItmWbo = MItmLst.get(index);
                            %>
                                    <tr style="width: 80%; border-width: 1;">
                                        <td style="text-align: center; width: 7%;">
                                             <%=MItmWbo.getAttribute("code")%> 
                                        </td>

                                        <td style="text-align: center; width: 28%;">
                                             <%=MItmWbo.getAttribute("prjName")%> 
                                        </td>
                                        
                                        <td style="text-align: center; width: 7%;">
                                             <%=MItmWbo.getAttribute("option3")%> 
                                        </td>

                                        <td style="text-align: center; width: 21%;">
                                             <%=MItmWbo.getAttribute("hourNum")%> Unit/s 
                                        </td>

                                        <td style="text-align: center; width: 14%;">
                                             <%=MItmWbo.getAttribute("total")%> 
                                        </td>
                                    </tr>

                    <%
                                mTotal += Integer.parseInt(MItmWbo.getAttribute("total").toString());
                            }
                        }

                        if(sprPrtLst != null && !sprPrtLst.isEmpty()){
                    %>
                            <tr style="width: 80%; background: #D5FFB4; border-width: 1;">
                                <td colspan="5" style="text-align: center; font-weight: bold;">
                                    <fmt:message key="spareParts"/>
                                </td>
                            </tr>

                            <%
                                WebBusinessObject sprPrtWbo = new WebBusinessObject();
                                for(int index=0; index<sprPrtLst.size(); index++){
                                    sprPrtWbo = sprPrtLst.get(index);
                            %>
                                    <tr style="width: 80%; border-width: 1; border-color: black;">
                                        <td style="text-align: center; width: 7%;">
                                             <%=sprPrtWbo.getAttribute("code")%> 
                                        </td>

                                        <td style="text-align: center; width: 28%;">
                                             <%=sprPrtWbo.getAttribute("prjName")%> 
                                        </td>
                                        
                                        <td style="text-align: center; width: 7%;">
                                             <%=sprPrtWbo.getAttribute("option3")%> 
                                        </td>

                                        <td style="text-align: center; width: 21%;">
                                             <%=sprPrtWbo.getAttribute("hourNum")%> Piece 
                                        </td>

                                        <td style="text-align: center; width: 14%;">
                                             <%=sprPrtWbo.getAttribute("total")%> 
                                        </td>
                                    </tr>

                    <%
                                spTotal += Integer.parseInt(sprPrtWbo.getAttribute("total").toString());
                            }
                        }

                        totalPrice = bTotal + mTotal + spTotal;
                    %>
                </table>
                
                <table style="width: 100%; padding-bottom: 5%; padding-right: 5%; border-color: black; float: right;">
                    <tr style="width: 80%; border-width: 1;">
                        <td colspan="3" style="border: none;"></td>

                        <td style="background: #0099cc; text-align: left; width: 25%; font-weight: bold;">
                             <fmt:message key="bPrice"/> 
                        </td>

                        <td style="background: #D5FFB4; text-align: center; width: 17%;">
                             <%=bTotal%> 
                        </td>
                    </tr>
                    <tr style="width: 80%; border-width: 1;">
                        <td colspan="3" style="border: none;"></td>

                        <td style="background: #0099cc; text-align: left; width: 25%; font-weight: bold;">
                             <fmt:message key="mPrice"/> 
                        </td>

                        <td style="background: #D5FFB4; text-align: center; width: 17%;">
                             <%=mTotal%> 
                        </td>
                    </tr>
                    
                    <tr style="width: 80%; border-width: 1;">
                        <td colspan="3" style="border: none;"></td>

                        <td style="background: #0099cc; text-align: left; width: 25%; font-weight: bold;">
                             <fmt:message key="sprPrtCost"/> 
                        </td>

                        <td style="background: #D5FFB4; text-align: center; width: 17%;">
                             <%=spTotal%> 
                        </td>
                    </tr>
                    
                    <tr style="width: 80%; border-width: 1;">
                        <td colspan="3" style="border: none;"></td>

                        <td style="background: #0099cc; text-align: left; width: 25%; font-weight: bold;">
                             <fmt:message key="totalPrice"/> 
                        </td>

                        <td style="background: #D5FFB4; text-align: center; width: 17%;">
                             <%=totalPrice%> 
                        </td>
                    </tr>
                </table>
                        
                <div style="font-size: 13px;" align="center">
                     Make all checks payable to Your Corporation. If you have any questions concerning this invoice; Please contact with us. 
                </div>
            </div>
            
            <div align="right" style="padding: 5%;">
                <button class="button" style="text-align: center; width: 12%;" onclick="printInvoice();"> Print <img src="images/printer2.png" width="20" height="20"/> </button>
            </div>
        </fieldset>
    </body>
</html>
