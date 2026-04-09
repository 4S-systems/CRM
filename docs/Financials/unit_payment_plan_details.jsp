<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.businessfw.hrs.financials.UnitPaymentDetails"%>
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
    ArrayList<UnitPaymentDetails> detailsList = (ArrayList<UnitPaymentDetails>) request.getAttribute("detailsList");
    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode, paymentDate, paymentAmount, paidAmount, type, remainder, reservation, downPayment, installment;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   عربي    ";
        langCode = "Ar";
        paymentDate = "In Date";
        paymentAmount = "Required to pay";
        paidAmount = "Amount";
        type = "Type";
        remainder = "Remainder";
        reservation = "Reservation";
        downPayment = "Down Payment";
        installment = "Installment";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        paymentDate = "في تاريخ";
        paymentAmount = "المطلوب دفعه";
        paidAmount = "المدفوع";
        type = "النوع";
        remainder = "الباقي";
        reservation = "دفعة الحجز";
        downPayment = "دفعة تعاقد";
        installment = "قسط";
    }
%>
<html>
    <head>
        <style>
        </style>
        <script language="JavaScript" type="text/javascript">
            $(function () {
                var table = $("#defaultPrice").DataTable({
                    "language": {
                        "url": "js/jquery/datatable/Arabic.json"
                    },
                    "destroy": true,
                    "stateSave": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]]
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
            <center>
                <div style="width: 100%; margin-left: auto; margin-right: auto;">
                    <table id="defaultPrice" class="display" id="pathPrice" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                        <thead>
                            <tr>
                                <th align="center" bgcolor="#FFCC99" class="silver_header"><%=paymentDate%></th>
                                <th align="center" bgcolor="#FFCC99" class="silver_header"><%=type%></th>
                                <th align="center" bgcolor="#FFCC99" class="silver_header"><%=paymentAmount%></th>
                                <th align="center" bgcolor="#FFCC99" class="silver_header"><%=paidAmount%></th>
                                <th align="center" bgcolor="#FFCC99" class="silver_header"><%=remainder%></th>
                                <th align="center" bgcolor="#FFCC99" class="silver_header">&nbsp;</th>
                            </tr> 
                        </thead>
                        <tbody>
                            <%
                                if (detailsList != null) {
                                    String color, paymentType, image = "";
                                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
                                    DecimalFormat df = new DecimalFormat("0.00");
                                    for (UnitPaymentDetails details : detailsList) {
                                        switch (details.getStatusName()) {
                                            case CRMConstants.PAYMENT_DETAILS_DONE:
                                                color = "#c0fead";
                                                image = "done.png";
                                                break;
                                            case CRMConstants.PAYMENT_DETAILS_PARTIAL:
                                                color = "#fff7bc";
                                                image = "partial.png";
                                                break;
                                            case CRMConstants.PAYMENT_DETAILS_PENDING:
                                                color = "white";
                                                image = "pending.png";
                                                break;
                                            case CRMConstants.PAYMENT_DETAILS_DELAYED:
                                            default:
                                                color = "#fda6a6";
                                                image = "stop.png";
                                                break;
                                        }
                                        switch (details.getPaymentType()) {
                                            case "reservarion":
                                                paymentType = reservation;
                                                break;
                                            case "downPayment":
                                                paymentType = downPayment;
                                                break;
                                            case "installment":
                                            default:
                                                paymentType = installment;
                                                break;
                                        }
                            %>
                            <tr id="row">
                                <td style="background-color: <%=color%>;">
                                    <%=sdf.format(details.getPaymentDate())%>
                                </td>
                                <td style="background-color: <%=color%>;">
                                    <%=paymentType%>
                                </td>
                                <td style="background-color: <%=color%>;">
                                    <%=df.format(details.getPaymentAmount())%>
                                </td>
                                <td style="background-color: <%=color%>;">
                                    <%=df.format(details.getPaidAmount())%>
                                </td>
                                <td style="background-color: <%=color%>;">
                                    <%=df.format(details.getPaymentAmount() - details.getPaidAmount())%>
                                </td>
                                <td>
                                    <img src="images/icons/<%=image%>" style="width: 25px;"/>
                                </td>
                            </tr>
                            <%
                                    }
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </center>
        </form>
    </body>
</html>