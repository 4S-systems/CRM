<%-- 
    Document   : installments_plan
    Created on : Jul 4, 2017, 11:20:52 AM
    Author     : fatma-PC
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    WebBusinessObject unitWbo = (WebBusinessObject) request.getAttribute("unitWbo") != null ? (WebBusinessObject) request.getAttribute("unitWbo") : null;
    WebBusinessObject projectWbo = (WebBusinessObject) request.getAttribute("projectWbo") != null ? (WebBusinessObject) request.getAttribute("projectWbo") : null;
    WebBusinessObject unitPriceWbo = (WebBusinessObject) request.getAttribute("unitPriceWbo") != null ? (WebBusinessObject) request.getAttribute("unitPriceWbo") : null;
    WebBusinessObject datewbo = (WebBusinessObject) request.getAttribute("datewbo") != null ? (WebBusinessObject) request.getAttribute("datewbo") : null;

    Vector<WebBusinessObject> client = (Vector<WebBusinessObject>) request.getAttribute("client") != null ? (Vector<WebBusinessObject>) request.getAttribute("client") : null;

    String resPrice = (String) request.getAttribute("resPriceCell") != null ? (String) request.getAttribute("resPriceCell") : null;
    String resDate = (String) request.getAttribute("resDate") != null ? (String) request.getAttribute("resDate") : null;

    String downPayPrice = (String) request.getAttribute("downPayPriceCell") != null ? (String) request.getAttribute("downPayPriceCell") : null;
    String downDate = (String) request.getAttribute("downDate") != null ? (String) request.getAttribute("downDate") : null;

    ArrayList<WebBusinessObject> insPlanLst = (ArrayList<WebBusinessObject>) request.getAttribute("insPlanLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("insPlanLst") : null;

    String finalUnitPrice = (String) request.getAttribute("priceCellInsSys") != null ? (String) request.getAttribute("priceCellInsSys") : null;
    
    String[] str;
    double amount = 0;
    DecimalFormat formatter = new DecimalFormat("#,###.00");
    
    String garage = (String) request.getAttribute("garage") != null ? (String) request.getAttribute("garage") : null;
    String garagePrice = (String) request.getAttribute("garagePrice") != null ? (String) request.getAttribute("garagePrice") : null;
    String locker = (String) request.getAttribute("locker") != null ? (String) request.getAttribute("locker") : null;
    String lockerPrice = (String) request.getAttribute("lockerPrice") != null ? (String) request.getAttribute("lockerPrice") : null;
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
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        
        <script  type="text/javascript">
            function archivePlan(){
                var unitID = $("#unitID").val();
                var myClientID = $("#myClientID").val();
                var url = "<%=context%>/UnitServlet?op=paymentPlan&getClient=yes&unitID=" + unitID + "&clientID=" + myClientID;
                window.location.href = url;
            }
            
            function printPlan(){
                $("#topDiv").css("display", "");
                $("#bottomDiv").css("display", "");
                var printContents = document.getElementById("paymentDiv").innerHTML;
                var originalContents = document.body.innerHTML;
                document.body.innerHTML = printContents;
                window.print();
                document.body.innerHTML = originalContents;
            }
        </script>
    </head>
    
    <body>
        <fieldset class="set" style="border-color: #006699; width: 80%; min-height: 400px;">
            <legend align="center">
                <font color="blue" size="6"> 
                    <fmt:message key="payPlan"/>
                </font>
            </legend>
            
            <div id="paymentDiv" dir='<fmt:message key="direction" />' align="center">
                
                <br><br><br>
                
                <div id="clientDetails" dir='<fmt:message key="direction" />' align="right" style="padding-right: 10%;">
                    <b> <FONT color='black' SIZE="3"> عرض مقدم للسيد : <%=client.get(0).getAttribute("name")%></FONT> </b>
                </div>
                    
                <br><br><br>
                    
                <div id="clientDetails" dir='<fmt:message key="direction" />' align="center">                
                    <TABLE class="blueBorder" dir='<fmt:message key="direction"/>' align="center" width="80%" cellpadding="0" cellspacing="0">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <FONT color='white' SIZE="3"> <fmt:message key="clientDetails"/> </FONT>

                                <BR/>
                            </TD>
                        </TR>
                    </TABLE>

                    <table border="0" dir='<fmt:message key="direction" />' align="center" cellpadding="0" cellspacing="0" style="width: 80%;">
                        <tr>
                            <td bgcolor="#CCCCCC" style="width: 8%; vertical-align: top;">
                                <b>
                                    <font size="2" color="black">
                                        <fmt:message key="clientName"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <input type="hidden" name="myClientID" id="myClientID" value="<%=client.get(0).getAttribute("id")%>">
                                    <font color="black" size="3">
                                        <% if(client == null || client.get(0).getAttribute("name") == null || client.get(0).getAttribute("name").equals("UL")){%>
                                            ...
                                        <% } else { %>
                                            <%=client.get(0).getAttribute("name")%>
                                        <% } %>
                                    </font>
                                </b>
                            </td>

                            <td bgcolor="#CCCCCC" style="width: 8%; vertical-align: top;">
                                <b>
                                    <font size="2" color="black">
                                        <fmt:message key="clientJob"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <font color="black" size="3">
                                        <% if(client == null || client.get(0).getAttribute("job") == null || client.get(0).getAttribute("job").equals("UL")){%>
                                            ...
                                        <% } else { %>
                                            <%=client.get(0).getAttribute("job")%>
                                        <% } %>
                                    </font>
                                </b>
                            </td>
                        </tr>

                        <tr>
                            <td bgcolor="#CCCCCC" style="width: 8%; vertical-align: top;">
                                <b>
                                    <font size="2" color="black">
                                        <fmt:message key="clientAdd"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <font color="black" size="3">
                                        <% if(client == null || client.get(0).getAttribute("address") == null || client.get(0).getAttribute("address").equals("UL")){%>
                                            ...
                                        <% } else { %>
                                            <%=client.get(0).getAttribute("address")%>
                                        <% } %>
                                    </font>
                                </b>
                            </td>

                            <td bgcolor="#CCCCCC" style="width: 8%; vertical-align: top;">
                                <b>
                                    <font size="2" color="black">
                                        <fmt:message key="clientEmail"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <font color="black" size="3">
                                        <% if(client == null || client.get(0).getAttribute("email") == null || client.get(0).getAttribute("email").equals("UL")){%>
                                            ...
                                        <% } else { %>
                                            <%=client.get(0).getAttribute("email")%>
                                        <% } %>
                                    </font>
                                </b>
                            </td>
                        </tr>

                        <tr>
                            <td bgcolor="#CCCCCC" style="width: 8%; vertical-align: top;">
                                <b>
                                    <font size="2" color="black">
                                        <fmt:message key="clientPhone"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <font color="black" size="3">
                                        <% if(client == null || client.get(0).getAttribute("phone") == null || client.get(0).getAttribute("phone").equals("UL")){%>
                                            ...
                                        <% } else { %>
                                            <%=client.get(0).getAttribute("phone")%>
                                        <% } %>
                                    </font>
                                </b>
                            </td>

                            <td bgcolor="#CCCCCC" style="width: 8%; vertical-align: top;">
                                <b>
                                    <font size="2" color="black">
                                        <fmt:message key="clientMob"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <font color="black" size="3">
                                        <% if(client == null || client.get(0).getAttribute("mobile") == null || client.get(0).getAttribute("mobile").equals("UL")){%>
                                            ...
                                        <% } else { %>
                                            <%=client.get(0).getAttribute("mobile")%>
                                        <% } %>
                                    </font>
                                </b>
                            </td>
                        </tr>

                        <tr>
                            <td bgcolor="#CCCCCC" style="width: 8%; vertical-align: top;">
                                <b>
                                    <font size="2" color="black">
                                        <fmt:message key="clientNat"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <font color="black" size="3">
                                        <% if(client == null || client.get(0).getAttribute("nationality") == null || client.get(0).getAttribute("nationality").equals("UL")){%>
                                            ...
                                        <% } else { %>
                                            <%=client.get(0).getAttribute("nationality")%>
                                        <% } %>
                                    </font>
                                </b>
                            </td>

                            <td bgcolor="#CCCCCC" style="width: 8%; vertical-align: top;">
                                <b>
                                    <font size="2" color="black">
                                        <fmt:message key="clientIntNo"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <font color="black" size="3">
                                    <% if(client == null || client.get(0).getAttribute("interPhone") == null || client.get(0).getAttribute("interPhone").equals("UL")){%>
                                            ...
                                        <% } else { %>
                                            <%=client.get(0).getAttribute("interPhone")%>
                                        <% } %>
                                    </font>
                                </b>
                            </td>
                        </tr>
                    </table>
                </div>
                
                <br><br><br>
                
                <div id="unitDetails" dir='<fmt:message key="direction" />' align="center">
                    <TABLE class="blueBorder" dir='<fmt:message key="direction"/>' align="center" width="80%" cellpadding="0" cellspacing="0">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <FONT color='white' SIZE="+1"> <fmt:message key="unitdetails"/> </FONT>

                                <BR/>
                            </TD>
                        </TR>
                    </TABLE>

                    <table border="0" dir='<fmt:message key="direction" />' align="center" cellpadding="0" cellspacing="0" style="width: 80%;">
                        <tr>
                            <td bgcolor="#CCCCCC" style="width: 8%; vertical-align: top;">
                                <b>
                                    <font size="2" color="black">
                                        <fmt:message key="project"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <font color="black" size="3">
                                        <input type="hidden" name="unitID" id="unitID" value="<%=unitWbo.getAttribute("projectID")%>">
                                        <%=projectWbo.getAttribute("projectName")%>
                                    </font>
                                </b>
                            </td>

                            <td style="width: 8%; vertical-align: top;" bgcolor="#CCCCCC">
                                <b><font size="2" color="black">
                                    <fmt:message key="unitno" /> 
                                </b>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <font color="black" size="3" id="nameCell">
                                        <%=unitWbo.getAttribute("projectName")%>
                                    </font>
                                </b>
                            </td>
                        </tr>

                        <tr>
                            <td bgcolor="#CCCCCC" style="width: 8%; vertical-align: top;">
                                <b>
                                    <font size="2" color="black"> 
                                        <fmt:message key="delDate"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 25%;">
                                <b>
                                    <font color="black" size="3" id="areaCell">
                                        <% if(datewbo == null){%>
                                            ...
                                        <% } else { %>
                                            <% str = datewbo.getAttribute("unitDate").toString().split(" ");%>
                                            <%=str[0]%>
                                        <% } %>
                                    </font>
                                </b>
                            </td>

                            <td bgcolor="#CCCCCC" style="width: 8%; vertical-align: top;">
                                <b>
                                    <font size="2" color="black">
                                        <fmt:message key="unitprice"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 25%;">
                                <b>
                                    <font color="black" size="3" id="priceCell">
                                        <% if(finalUnitPrice == null){%>
                                            ...
                                        <% } else {
                                            amount = Double.parseDouble(finalUnitPrice);%>
                                            <%=formatter.format(amount)%>
                                        <% } %>
                                    </font>
                                </b>
                            </td>

                            <td bgcolor="#CCCCCC" style="width: 8%; vertical-align: top;">
                                <b>
                                    <font size="2" color="black"> 
                                        <fmt:message key="unitarea"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 25%;">
                                <b>
                                    <font color="black" size="3" id="areaCell">
                                        <% if(unitPriceWbo == null || unitPriceWbo.getAttribute("maxPrice") == null){%>
                                            ...
                                        <% } else { %>
                                            <%=unitPriceWbo.getAttribute("maxPrice")%>
                                        <% } %>
                                    </font>
                                </b>
                            </td>
                        </tr>
                    </table>
                </div>

                <br><br><br>
                
                <TABLE class="blueBorder" dir='<fmt:message key="direction"/>' style="border: none;" align="center" width="80%" cellpadding="0" cellspacing="0">        
                    <% if(garage != null  && !garage.equals("")) { %>
                        <tr style="border: none;">
                            <td bgcolor="#33ACFF" style="width: 33%; vertical-align: top; border: 0;">
                                <b>
                                    <font size="2" color="black"> 
                                        <fmt:message key="garage"/>
                                    </font>
                                </b>
                            </td>
                            
                            <td bgcolor="#CCCCCC" style="width: 33%; vertical-align: top; border: 0;">
                                <b>
                                    <font size="2" color="black"> 
                                        <fmt:message key="theprice"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 33%;" colspan="2">
                                <b>
                                    <font color="black" size="3">
                                    <% if(garagePrice == null || garagePrice.equals("")){%>
                                            ...
                                        <% } else { %>
                                            <input type="text" id="gragePrice" value='<%=garagePrice%>' style="border: none;" readonly>
                                        <% } %>
                                    </font>
                                </b>
                            </td>
                        </tr>
                        
                        <% } if(locker != null && !locker.equals("")) { %>
                            <tr style="border: none;">
                                <td bgcolor="#33ACFF" style="width: 33%; vertical-align: top; border: 0;">
                                    <b>
                                        <font size="2" color="black"> 
                                            <fmt:message key="locker"/>
                                        </font>
                                    </b>
                                </td>

                                <td bgcolor="#CCCCCC" style="width: 33%; vertical-align: top; border: 0;">
                                    <b>
                                        <font size="2" color="black"> 
                                            <fmt:message key="theprice"/>
                                        </font>
                                    </b>
                                </td>
                                <td style="width: 33%;" colspan="2">
                                    <b>
                                        <font color="black" size="3">
                                        <% if(lockerPrice == null || lockerPrice.equals("")){%>
                                                ...
                                            <% } else { %>
                                                <input type="text" id="lockerPrice" value='<%=lockerPrice%>' style="border: none;" readonly>
                                            <% } %>
                                        </font>
                                    </b>
                                </td>
                            </tr>
                        <% } %>
                    </table>
                                    
                <br><br><br><br><br>
                
                <div id="paymentDetails" dir='<fmt:message key="direction" />' align="center">
                    <TABLE class="blueBorder" dir='<fmt:message key="direction" />' align="center" align="center" width="80%" cellpadding="0" cellspacing="0">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <FONT color='white' SIZE="+1"> <fmt:message key="paymentDetalis"/> </FONT>

                                <BR/>
                            </TD>
                        </TR>
                    </TABLE>

   
                    <table border="0" dir='<fmt:message key="direction" />' align="center" cellpadding="0" cellspacing="0" style="width: 80%;">
                        <tr>
                            <td bgcolor="#CCCCCC" style="width: 25%; vertical-align: top;">
                                <b>
                                    <font size="2" color="black">
                                        <fmt:message key="reservation"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 25%;">
                                <b>
                                    <font color="black" size="3">
                                    <%if(resPrice != null){ 
                                        amount = Double.parseDouble(resPrice);%>
                                        <%=formatter.format(amount)%>
                                    <% } else { %>
                                            ...
                                    <% } %>
                                    </font>
                                </b>
                            </td>

                            <td bgcolor="#CCCCCC" style="width: 25%; vertical-align: top;">
                                <b>
                                    <font size="2" color="black">
                                        <fmt:message key="date"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 25%;">
                                <b>
                                    <font color="black" size="3">
                                    <% if(resDate != null){ %>
                                        <% str = resDate.toString().split(" ");%>
                                        <%=str[0]%>
                                    <% } else { %>
                                        ...
                                    <% } %>
                                    </font>
                                </b>
                            </td>
                        </tr>
                    </table>

                    <br><br><br>   
                    
                    <table border="0" dir='<fmt:message key="direction" />' align="center" cellpadding="0" cellspacing="0" style="width: 80%;">
                        <tr>
                            <td bgcolor="#CCCCCC" style="width: 25%; vertical-align: top;">
                                <b>
                                    <font size="2" color="black">
                                        <fmt:message key="downPay"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 25%;">
                                <b>
                                    <font color="black" size="3">
                                        <%if(downPayPrice != null){
                                            amount = Double.parseDouble(downPayPrice);%>
                                            <%=formatter.format(amount)%>
                                        <% } else { %>
                                            ...
                                        <% } %>
                                    </font>
                                </b>
                            </td>

                            <td bgcolor="#CCCCCC" style="width: 25%; vertical-align: top;">
                                <b>
                                    <font size="2" color="black">
                                        <fmt:message key="date"/>
                                    </font>
                                </b>
                            </td>
                            <td style="width: 25%;">
                                <b>
                                    <font color="black" size="3">
                                    <% if(downDate != null && !downDate.equals("null")){ %>
                                        <% str = downDate.toString().split(" ");%>
                                        <%=str[0]%>
                                    <% } else { %>
                                        ...
                                    <% } %>
                                    </font>
                                </b>
                            </td>
                        </tr>
                    </table>           

                    <br><br><br>

                    <% if(insPlanLst != null){ %>
                        <input type="hidden" name="planID" id="planID" value="<%=insPlanLst.get(1).getAttribute("planID")%>"> 
                            <%int count=0; for(int i=0; i<insPlanLst.size() ; i++) { 
                                if(insPlanLst.get(i).getAttribute("payType").equals("installment")) { %>   
                                <table border="0" dir='<fmt:message key="direction" />' align="center" cellpadding="0" cellspacing="0" style="width: 80%;">
                                    <tr>
                                        <%if(count == 0) { count++;%>
                                            <td bgcolor="#CCCCCC" style="width: 25%; vertical-align: top;">
                                                <b>
                                                    <font size="2" color="black">
                                                        <fmt:message key="insPrice"/>
                                                    </font>
                                                </b>
                                            </td>
                                            <td style="width: 25%;">
                                                <b>
                                                    <font color="black" size="3">
                                                        <% if(insPlanLst.get(i).getAttribute("insAMT") == null || insPlanLst.get(i).getAttribute("insAMT").equals("UL")){%>
                                                            ...
                                                        <% } else {
                                                            amount = Double.parseDouble(insPlanLst.get(i).getAttribute("insAMT").toString());%>
                                                            <%=formatter.format(amount)%>
                                                        <% } %>
                                                    </font>
                                                </b>
                                            </td>
                                        <% } else { %>
                                            <td style="width: 25%; vertical-align: top; border: none;">
                                            </td>

                                            <td style="width: 25%; border: none;">
                                            </td>
                                            <% } %>

                                        <td bgcolor="#CCCCCC" style="width: 25%; vertical-align: top;">
                                            <b>
                                                <font size="2" color="black">
                                                    <fmt:message key="date"/>
                                                </font>
                                            </b>
                                        </td>
                                        <td style="width: 25%;" >
                                            <b>
                                                <font color="black" size="3">
                                                    <% if(insPlanLst.get(i).getAttribute("insDate") == null || insPlanLst.get(i).getAttribute("insDate").equals("UL")){%>
                                                        ...
                                                    <% } else { %>
                                                        <% str = insPlanLst.get(i).getAttribute("insDate").toString().split(" ");%>
                                                        <%=str[0]%>
                                                    <% } %>
                                                </font>
                                            </b>
                                        </td>

                                    </tr>
                                </table>
                        <%  } } }%>
                    </div>
                </div>
                    
                <br><br><br>
                    
                <button class="button" style="margin: 10px; text-align: center;" onclick="archivePlan();"> <img src="images/icons/back.png" width="20" height="20"/> Back </button>
                <button class="button" style="margin: 10px; text-align: center;"> Email This Offer <img src="images/complain-drag.png" width="20" height="20"/> </button>
                <button class="button" style="margin: 10px; text-align: center;" onclick="printPlan();"> Print This Offer <img src="images/printer2.png" width="20" height="20"/> </button>
                
        </fieldset>
    </body>
</html>