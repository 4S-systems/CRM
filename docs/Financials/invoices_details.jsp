<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Map"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String stat = (String) request.getSession().getAttribute("currentMode");
    ArrayList<LiteWebBusinessObject> invoicesList = (ArrayList<LiteWebBusinessObject>) request.getAttribute("invoicesList");
    ArrayList<WebBusinessObject> transactionsList = (ArrayList<WebBusinessObject>) request.getAttribute("transactionsList");
    String align = null;
    String dir = null;
    String style = null;
    String inDate, invoiceNo, amount, transactionNo, invoices, transactions, total;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        inDate = "In Date";
        invoiceNo = "Code";
        amount = "Amount";
        transactionNo = "Transaction No.";
        invoices = "Claims";
        transactions = "Transactions";
        total = "Total";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        inDate = "في تاريخ";
        invoiceNo = "كود";
        amount = "المبلغ";
        transactionNo = "رقم الحركة";
        invoices = "المطالبات";
        transactions = "الحركات";
        total = "أجمالي";
    }
%>
<html>
    <head>
        <style>
        </style>
        <script language="JavaScript" type="text/javascript">
            $(function () {
                $("#invoices,#transactions").DataTable({
                    "language": {
                        "url": "js/jquery/datatable/Arabic.json"
                    },
                    "destroy": true,
                    "stateSave": true,
                    "aLengthMenu": [[5, 10, 25, -1], [5, 10, 25, "All"]]
                });
            });
            function submitForm() {
                if (!validateData("req", this.PRICE_FORM.gpsID, "Please, enter GPS ID.")) {
                    this.PRICE_FORM.gpsID.focus();
                } else {
                    document.PRICE_FORM.action = "<%=context%>/TrackingDeviceServlet?op=getNewForm";
                    document.PRICE_FORM.submit();
                }
            }
            function reloadAE(nextMode) {
                var url = "<%=context%>/ajaxGetItrmName?key=" + nextMode;
                if (window.XMLHttpRequest) {
                    req = new XMLHttpRequest();
                } else if (window.ActiveXObject) {
                    req = new ActiveXObject("Microsoft.XMLHTTP");
                }
                req.open("Post", url, true);
                req.onreadystatechange = callbackFillreload;
                req.send(null);
            }
            function cancelForm() {
                document.PRICE_FORM.action = "<%=context%>/main.jsp";
                document.PRICE_FORM.submit();
            }
        </script>
    </head>
    <body>
        <form name="PRICE_FORM" id="PRICE_FORM" method="post">
            <div style="width: 47%; margin-left: auto; margin-right: auto; float: right;">
                <table id="invoices" class="display" id="pathPrice" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <th colspan="3" style="font-size: 17px; font-weight: bolder;"><%=invoices%></th>
                        </tr>
                        <tr>
                            <th style="font-weight: bolder;"><%=inDate%></th>
                            <th style="font-weight: bolder;"><%=amount%></th>
                            <th style="font-weight: bolder;"><%=invoiceNo%></th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            DecimalFormat df = new DecimalFormat("0.000");
                            double invoiceTotal = 0;
                            if (invoicesList != null) {
                                for (LiteWebBusinessObject invoiceWbo : invoicesList) {
                                    invoiceTotal += "UL".equals(invoiceWbo.getAttribute("total")) ? 0 : (Double.parseDouble((String) invoiceWbo.getAttribute("total")));
                        %>
                        <tr id="row">
                            <td style="">
                                <%=((String) invoiceWbo.getAttribute("inDate")).substring(0, 10)%>
                            </td>
                            <td style="">
                                <%="UL".equals(invoiceWbo.getAttribute("total")) ? "0.000" : df.format(Double.parseDouble((String) invoiceWbo.getAttribute("total")))%>
                            </td>
                            <td style="">
                                <%=invoiceWbo.getAttribute("businessID")%>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                    <tfoot>
                        <tr>
                        
                            <th style="font-size: 14px; font-weight: bolder;"><%=total%></th>
                            <th style="font-size: 14px; font-weight: bolder;"><%=df.format(invoiceTotal)%></th>
                                <th>&nbsp;</th>
                        </tr>
                    </tfoot>
                </table>
            </div>
            <div style="width: 47%; margin-left: auto; margin-right: auto; float: left;">
                <table id="transactions" class="display" id="pathPrice" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                    <thead>
                        <tr>
                            <th align="center" bgcolor="#FFCC99" class="silver_header" colspan="3" style="font-size: 17px; font-weight: bolder;"><%=transactions%></th>
                        </tr>
                        <tr>
                            <th style="font-weight: bolder;"><%=inDate%></th>
                            <th style="font-weight: bolder;"><%=amount%></th>
                            <th style="font-weight: bolder;"><%=transactionNo%></th>
                        </tr> 
                    </thead>
                    <tbody>
                        <%
                            double transactionTotal = 0;
                            if (transactionsList != null) {
                                for (WebBusinessObject transactionWbo : transactionsList) {
                                    transactionTotal += Double.parseDouble((String) transactionWbo.getAttribute("transValue"));
                        %>
                        <tr id="row">
                            <td style="">
                                <%=((String) transactionWbo.getAttribute("documentDate")).substring(0, 10)%>
                            </td>
                           
                            <td style="">
                                <%=df.format(Double.parseDouble((String) transactionWbo.getAttribute("transValue")))%>
                            </td>
                             <td style="">
                                <%=transactionWbo.getAttribute("documentNo")%>
                            </td>
                        </tr>
                        <%
                                }
                            }
                        %>
                    </tbody>
                    <tfoot>
                        <tr>
                          
                            <th style="font-size: 14px; font-weight: bolder;"><%=total%></th>
                            <th style="font-size: 14px; font-weight: bolder;"><%=df.format(transactionTotal)%></th>
                              <th>&nbsp;</th>
                        </tr>
                    </tfoot>
                </table>
            </div>
        </form>
    </body>
</html>