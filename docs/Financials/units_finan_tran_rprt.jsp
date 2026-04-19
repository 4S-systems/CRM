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
                       
            String stat = (String) request.getSession().getAttribute("currentMode");
            String finanTrans, units, search, clients, vUnits,vClients, docNo, docCod, docDate,
                    TransTyp, transVal, debtor, creditor, unit, notes, source;
            if (stat.equals("En")) {
                finanTrans = "Units Financial Transaction";
                units = "Units";
                search = "Search";
                clients = "Clients";
                vUnits = "View Units";
                vClients = "View Clients";
                docNo = "Document No";
                docCod = "Document Code";
                docDate = "Document Date";
                TransTyp = "Transaction Type";
                transVal = "Transaction Value";
                debtor = "Debtor";
                creditor = "Creditor";
                unit = "Unit";
                notes = "Notes";
                source = "Created By";
                
            } else {
                finanTrans = "الحركات المحاسبية للوحدات";
                units = "الوحدات";
                search = "بحث";
                clients = "العملاء";
                vUnits = "عرض الوحدات";
                vClients = "عرض العملاء";
                docNo = "رقم المستند";
                docCod = "كود المستند";
                docDate = "تاريخ المستند";
                TransTyp = "نوع الحركة";
                transVal = "قيمة الحركة";
                debtor = "المدين";
                creditor = "دائن";
                unit = "الوحدة";
                notes = "ملاحظات";
                source = "المصدر";
            }
            
            ArrayList<WebBusinessObject> finanTransLst = (ArrayList<WebBusinessObject>) request.getAttribute("finanTransLst");
            String unitNm =(String) request.getAttribute("unit");
            String clientNm =(String) request.getAttribute("client");
        %>
        <script  type="text/javascript">
            
            $(document).ready(function () {
                $('#finanTrans').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[5, 10, -1], [5, 10, "All"]],
                    iDisplayLength: 5,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });
                
            function submitForm(){
                var unit = $("#unitID").val();
                var client = $("#clientID").val();
                console.log("unit "+ unit);
                if(unit != null && unit != "" && unit != " "){
                    document.finanTransaction.action = "<%=context%>/FinancialServlet?op=unitsFinancialTransactionRprt&unit="+unit + "&client=" + client;
                    document.finanTransaction.submit();
                } else {
                   alert("Please Select Unit");
                }
            }    
        </script>
    </head>
    <body>
        <fieldset>
            <legend>
                <font style="color: blue;font-size: 17px; font-weight: bold"/> <%=finanTrans%>
            </legend>
            <form name="finanTransaction" method="post"> 
                <table ALIGN="center" DIR="RTL" WIDTH="60%" CELLSPACING=2 CELLPADDING=1 style="margin-bottom: 20px;">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                            <b><font size=3 color="white"><%=units%></b>
                        </td>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                            <b><font size=3 color="white"><%=clients%></b>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="text" name="unitName" id="unitName" value="<%=unitNm!=null? unitNm : ""%>" readonly="readonly"/>
                            <input type="hidden" name="unitID" id="unitID" value=""/>
                            <input type="button" id="units" name="units"  style="text-align: center;" onclick="return getDataInPopup('ProjectServlet?op=getAllUnitsData')" value="<%=vUnits%>"/>    
                        </td>
                        <td>
                            <input type="text" name="clientName" id="clientName" value="<%=clientNm!=null? clientNm : ""%>" readonly="readonly"/>
                            <input type="hidden" name="clientID" id="clientID"/>
                            <input type="button" id="clients" name="clients"  style="text-align: center;" onclick="return getDataInPopup('ProjectServlet?op=getAllClients')" value="<%=vClients%>"/>    
                        </td>
                    </tr>

                    <tr>
                        <td STYLE="text-align:center" bgcolor="#dedede" rowspan="2" WIDTH="20%" colspan="2">
                            <button onclick="JavaScript: submitForm();" STYLE="color: #27272A;font-size:15px;font-weight:bold;height: 35px"><%=search%> <IMG HEIGHT="15" SRC="images/search.gif"/> </button>
                        </td>
                    </tr>
                </table>
                        
                <div style="width: 90%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <TABLE ALIGN="center" dir='<fmt:message key="direction" />' id="finanTrans" style="width:100%;">
                        <thead>
                            <tr>
                                <th style="width: 2%;">
                                    <B>
                                        <%=docNo%>
                                    </B>
                                </th>

                                <th style="width: 24%;">
                                    <B>
                                        <%=docCod%>
                                    </B>
                                </th>

                                <th style="width: 24%;">
                                    <B>
                                        <%=docDate%>
                                    </B>
                                </th>

                                <th style="width: 24%;">
                                    <B>
                                        <%=TransTyp%>
                                    </B>
                                </th>

                                <th style="width: 24%;">
                                    <B>
                                        <%=transVal%>
                                    </B>
                                </th>

                                <th style="width: 24%;">
                                    <B>
                                        <%=debtor%>
                                    </B>
                                </th>

                                <th style="width: 24%;">
                                    <B>
                                        <%=creditor%>
                                    </B>
                                </th>
                                
                                <th style="width: 24%;">
                                    <B>
                                        <%=unit%>
                                    </B>
                                </th>
                                
                                <th style="width: 24%;">
                                    <B>
                                        <%=notes%>
                                    </B>
                                </th>
                                
                                <th style="width: 24%;">
                                    <B>
                                        <%=source%>
                                    </B>
                                </th>
                            </tr>
                        </thead>
                        <%
                            if(finanTransLst !=null && finanTransLst.size() != 0){
                        %>
                        <tbody>
                            <% int counter = 1;
                                for (WebBusinessObject finanTransWbo : finanTransLst) {
                            %>
                            <tr>
                                <td style="width: 2%;">
                                    <%=finanTransWbo.getAttribute("documentNo")%>
                                </td>


                                <td>
                                    <%=finanTransWbo.getAttribute("documentCode")%>
                                </td>
                                <td>
                                    <%=finanTransWbo.getAttribute("documentDate").toString().substring(0,10)%>
                                </td>

                                <td>
                                    <%=finanTransWbo.getAttribute("TransTyp")%>
                                </td>

                                <td>
                                    <%=finanTransWbo.getAttribute("transValue")%>
                                </td>
                                
                                <td>
                                    <%=finanTransWbo.getAttribute("madeen")%>
                                </td>
                                
                                <td>
                                    <%=finanTransWbo.getAttribute("clientNm")%>
                                </td>
                                
                                <td>
                                    <%=finanTransWbo.getAttribute("UnitNm")%>
                                </td>
                                
                                <td>
                                    <%=finanTransWbo.getAttribute("note")%>
                                </td>
                                
                                <td>
                                    <%=finanTransWbo.getAttribute("createdByNm")%>
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
