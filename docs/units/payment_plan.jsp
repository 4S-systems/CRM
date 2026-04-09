<%-- 
    Document   : payment_plan
    Created on : Jun 29, 2017, 1:46:42 PM
    Author     : fatma-PC
--%>

<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Vector"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

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

        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <link rel="stylesheet" href="css/demo_table.css">   
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">

        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <%
            ArrayList<WebBusinessObject> sPayPlanLst = (ArrayList<WebBusinessObject>) request.getAttribute("sPayPlanLst") != null ? (ArrayList<WebBusinessObject>) request.getAttribute("sPayPlanLst") : null;

            WebBusinessObject unitWbo = (WebBusinessObject) request.getAttribute("unitWbo") != null ? (WebBusinessObject) request.getAttribute("unitWbo") : null;
            WebBusinessObject projectWbo = (WebBusinessObject) request.getAttribute("projectWbo") != null ? (WebBusinessObject) request.getAttribute("projectWbo") : null;
            WebBusinessObject unitPriceWbo = (WebBusinessObject) request.getAttribute("unitPriceWbo") != null ? (WebBusinessObject) request.getAttribute("unitPriceWbo") : null;
            WebBusinessObject datewbo = (WebBusinessObject) request.getAttribute("datewbo") != null ? (WebBusinessObject) request.getAttribute("datewbo") : null;
            Vector<WebBusinessObject> client = (Vector<WebBusinessObject>) request.getAttribute("client") != null ? (Vector<WebBusinessObject>) request.getAttribute("client") : null;

            String[] str;
            double amount = 0;
            DecimalFormat formatter = new DecimalFormat("#,###.00");

            WebBusinessObject grageWbo = (WebBusinessObject) request.getAttribute("grageWbo") != null ? (WebBusinessObject) request.getAttribute("grageWbo") : null;
            WebBusinessObject lockerWbo = (WebBusinessObject) request.getAttribute("lockerWbo") != null ? (WebBusinessObject) request.getAttribute("lockerWbo") : null;
            
            ArrayList<WebBusinessObject> PaymentPlamsLst = (ArrayList<WebBusinessObject>) request.getAttribute("PaymentPlamsLst");
            String typ = (String) request.getAttribute("typ");
        %>

        <script  type="text/javascript">
            var et = 'false';
            $(document).ready(function () {
                $("#resDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: 0,
                    dateFormat: "yy/mm/dd"
                });
                
                $("#sPlanID").select2();
                $("#disID").select2();
                
                $('#indextable').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                });
                $("#clientID").select2();

                $("#priceCellDis").val('<%=unitPriceWbo.getAttribute("option1")%>');
                
                
            });
            
            
           

            function showClientInfo() {
                if ($("#clientID").val() != "") {
                    document.selectClientForm.action = "UnitServlet?op=paymentPlan&getClient=yes&clientID=" + $("#clientID").val();
                    document.selectClientForm.submit();
                }
            }

            function countPrice() {
                var realPrice = $("#realPrice").val();
                var disID = $("#disID").val();
                console.log("realPrice "+realPrice);
                console.log("disID "+disID);
                var unitPriceDis = (realPrice - (realPrice * (disID / 100))).toFixed(2);
                $("#priceCellDis").val(unitPriceDis);
                //$("#priceCellDis").val(formatter( "#,##0.####", unitPriceDis ));
                $("#unitPriceDis").fadeIn();
                $("#resID").val("");
                $("#resPriceCell").val("");
                $("#downPayID").val("");
                $("#downPayPriceCell").val("");
                showInfo();
            }

            function calcResDown(type) {
                var resPrec, resPrice, price;
                if ($("#priceCellDis").val() == "") {
                    price = Number($("#realPrice").val());
                } else {
                    price = Number($("#priceCellDis").val());
                }

                resPrec = Number($("#" + type + "ID").val());
                if (type == "downPay") {
                    //resPriceCell
                    resPrice = ((price - Number($("#resPriceCell").val())) * (resPrec / 100)).toFixed(2);
                } else {
                    resPrice = ((price * (resPrec / 100))).toFixed(2);
                }

                $("#" + type + "PriceCell").val(resPrice);
            }

            function setDate(MonNum, MonNum2, dateType) {
                var monNumAtt = $("#" + MonNum).val();
                var monNumAtt2;
                if (MonNum2 == "") {
                    monNumAtt2 = "0";
                } else {
                    monNumAtt2 = $("#" + MonNum2).val();
                }

                if ($("#resDate").val() == "") {
                    alert(" <fmt:message key="warnningMsg"/> ");
                } else {
                    var splitStr = $("#resDate").val().split("/", 3);
                    var year = splitStr[0];
                    var month;
                    var monNumNum = Number(monNumAtt);
                    if (MonNum != null) {
                        if (monNumNum >= 0) {
                            month = (Number(splitStr[1]) + Number(monNumAtt) + Number(monNumAtt2));
                            if (month > 12) {
                                var x = Math.floor((month / 12));
                                year = Number(year) + Number(x);
                                month = month - (12 * Number(x));
                                if (month == 0) {
                                    month = 12;
                                    year = Number(year) - 1;
                                }
                            }
                        }
                    }

                    var day = splitStr[2];
                    if (Number(month) < 10 && month.toString().length < 2) {
                        month = "0" + month;
                    }
                    $("#" + dateType).attr("value", year + "/" + month + "/" + day);
                }
            }

            function openInstallment() {
                if ($("#insNumCheck").val() == "off") {
                    $("#insNumCheck").attr("value", "on");
                    $("#insNum").removeAttr("readonly");
                    $("#insPayIDSelect").fadeOut();
                } else if ($("#insNumCheck").val() == "on") {
                    $("#insNumCheck").attr("value", "off");
                    $("#insNum").attr("readonly", "readonly");
                    $("#insPayIDInput").hide();
                    $("#insPayIDSelect").fadeIn();
                }
            }

            function calculate() {
                if ($("#insDate").val() == null || $("#insDate").val() == "") {
                    alert(" Enter Frist Installment Date ");
                } else {
                    var insNum, insPres, price, insPay, insAmt, ins;
                    if ($("#insNumCheck").val() == "on") {
                        insNum = Number($("#insNum").val());
                        insPay = Number($("#insPayID").val());
                        if ($("#priceCellDis").val() == "") {
                            price = (Number($("#realPrice").val()) - Number($("#resPriceCell").val()) - Number($("#downPayPriceCell").val())).toFixed(2);
                        } else {
                            price = (Number($("#priceCellDis").val()) - Number($("#resPriceCell").val()) - Number($("#downPayPriceCell").val())).toFixed(2);
                        }

                        insAmt = ((insPay / insNum) * 100).toFixed(2);

                        $("#insPayIDInput").attr("value", insAmt + "%");
                        $("#insPayIDInput").fadeIn();
                        insPres = insAmt;
                    } else if ($("#insNumCheck").val() == "off") {
                        $("#insNum").val("");
                        insPay = Number($("#insPayID").val());

                        insPres = $("#insPayIDSelect").val();
                        if ($("#priceCellDis").val() == "") {
                            price = (Number($("#realPrice").val()) - Number($("#resPriceCell").val()) - Number($("#downPayPriceCell").val())).toFixed(2);
                        } else {
                            price = (Number($("#priceCellDis").val()) - Number($("#resPriceCell").val()) - Number($("#downPayPriceCell").val())).toFixed(2);//855000
                        }

                        insAmt = Math.ceil((insPay * (100 / insPres))); //7.00

                        $("#insNum").val(insAmt);
                        insNum = insAmt;
                    }

                    console.log(Math.floor(100 / insPres));

                    $("#insNumVal").val(Math.floor(100 / insPres));

                    if (Math.ceil(100 / insPres) > Math.floor(100 / insPres)) {
                        var temp = 0;
                        temp = (price * (insPres / 100));//855000*(16/100)=136800
                        ins = (temp + (price - (temp * Math.floor(100 / insPres))) / Math.floor(100 / insPres)).toFixed(2);
                        //136800+(855000-(136800*6))/6 = 142500
                    } else {
                        ins = (price * (insPres / 100)).toFixed(2);
                    }

                    $("#insPriceCell").val(ins);
                    var total = ((ins * Number($("#insNumVal").val())) + Number($("#resPriceCell").val()) + Number($("#downPayPriceCell").val())).toFixed(2);
                    $("#priceCellInsSys").val(total);
                }
            }

            function savePlan() {
                var insPriceCell = $("#insPriceCell").val();
                var priceCellInsSys = $("#priceCellInsSys").val();insNum
                var insNum = $("#insNum").val();
                var sPlanID = $("#sPlanID option:selected").val();
                if(sPlanID != null && sPlanID!= ""){
                    if(insPriceCell != null && insPriceCell!= "" && priceCellInsSys != null && priceCellInsSys != "" && insNum != null && insNum != ""){
                         var resID = $("#resID").val();
                        var downPayID = $("#downPayID").val();
                        var insPayID = $("#insPayID option:selected").val();
                        var insPayIDSelect = $("#insPayIDSelect").val();
                        var sPlanID = $("#sPlanID option:selected").val();
                        var typ = '<%=typ%>';

                        console.log(et);
                        document.selectClientForm.action = "UnitServlet?op=savePayPlan&resID="+resID+"&downPayID="+downPayID+"&insPayID="+insPayID+"&insPayIDSelect="+insPayIDSelect+"&sPlanID="+sPlanID+"&typ="+typ+ "&et=" + et;
                        document.selectClientForm.submit();


                    } else {
                       alert('<fmt:message key="msgalrt"/>');
                       event.preventDefault();
                    }
                } else {
                    alert('<fmt:message key="noPlanAlert"/>');
                       event.preventDefault();
                }
            }

            function addGarageLocker(process) {
                $("#priceCellDis").attr("value", "");
                $("#resPriceCell").val("");
                $("#downPayPriceCell").val("");
                $("#priceCellInsSys").val("");
                $("#insPriceCell").val("");
                var prc = Number($("#realPrice").val());
                if (process == "addGarage") {
                    prc = prc + Number($("#gragePrice").val());
                    $("#realPrice").attr("value", prc);
                    $("#grageInfo").attr("value", "Garage-" + $('#gragePrice').val());
                    $("#addGarageImg").hide();
                    $("#removeGarageImg").fadeIn();
                } else if (process == "removeGarage") {
                    prc = prc - Number($("#gragePrice").val());
                    $("#realPrice").attr("value", prc);
                    $("#grageInfo").attr("value", "");
                    $("#removeGarageImg").hide();
                    $("#addGarageImg").fadeIn();
                } else if (process == "addLocker") {
                    prc = prc + Number($("#lockerPrice").val());
                    $("#realPrice").attr("value", prc);
                    $("#lockerInfo").attr("value", "Locker-" + $('#lockerPrice').val());
                    $("#addLockerImg").hide();
                    $("#removeLockerImg").fadeIn();
                } else if (process == "removeLocker") {
                    prc = prc - Number($("#lockerPrice").val());
                    $("#realPrice").attr("value", prc);
                    $("#lockerInfo").attr("value", "");
                    $("#removeLockerImg").hide();
                    $("#addLockerImg").fadeIn();
                }
            }

            function showInfo() {
                $("#planID").val($("#sPlanID option:selected").text());
                $("#insDetailesDiv").hide();
                var sPlanID = $("#sPlanID").val();
                if (sPlanID != "") {
                    var resID, downPayID, downMonNum, insPayID, insPayIDSelect, insNumVal, insMonNum, resPriceCell,
                            downPayPriceCell, resIDMin, resIDMax, downPayIDMin, downPayIDMax, insPayIDSelectMax, insPayIDSelectMin;
            <%
                        for (int i = 0; i < sPayPlanLst.size(); i++) {
            %>
                    if (sPlanID == <%=sPayPlanLst.get(i).getAttribute("ID")%>) {
                        resID = <%=sPayPlanLst.get(i).getAttribute("rsrvAMT")%>;
                        downPayID = <%=sPayPlanLst.get(i).getAttribute("downAMT")%>;
                        downMonNum = <%=sPayPlanLst.get(i).getAttribute("downDate")%>;
                        insPayID = <%=sPayPlanLst.get(i).getAttribute("insSys")%>;
                        insPayIDSelect = <%=sPayPlanLst.get(i).getAttribute("insAMT")%>;
                        insNumVal = <%=sPayPlanLst.get(i).getAttribute("insNum")%>;
                        insMonNum = <%=sPayPlanLst.get(i).getAttribute("insMon")%>;
                        resIDMin = '<%=sPayPlanLst.get(i).getAttribute("rsrvAMTMin") != null ? sPayPlanLst.get(i).getAttribute("rsrvAMTMin") : "0"%>';
                        resIDMax = '<%=sPayPlanLst.get(i).getAttribute("rsrvAMTMax") != null ? sPayPlanLst.get(i).getAttribute("rsrvAMTMax") : "0"%>';
                        downPayIDMin = '<%=sPayPlanLst.get(i).getAttribute("downAMTMin") != null ? sPayPlanLst.get(i).getAttribute("downAMTMin") : "0"%>';
                        downPayIDMax = '<%=sPayPlanLst.get(i).getAttribute("downAMTMax") != null ? sPayPlanLst.get(i).getAttribute("downAMTMax") : "0"%>';
                        insPayIDSelectMin = '<%=sPayPlanLst.get(i).getAttribute("insAMTMin") != null ? sPayPlanLst.get(i).getAttribute("insAMTMin") : "0"%>';
                        insPayIDSelectMax = '<%=sPayPlanLst.get(i).getAttribute("insAMTMax") != null ? sPayPlanLst.get(i).getAttribute("insAMTMax") : "0"%>';
                    }
            <% }%>

                    //$('#resID option[value=' + resID + ']').prop('selected', true);
                    $("#sresID").val(resID);
                    $("#resID").val(resID);
                    $("#resIDMin").val(resIDMin);
                    $("#resIDMax").val(resIDMax);

                    //$('#downPayID option[value=' + downPayID + ']').prop('selected', true);
                    $("#sdownPayID").val(downPayID);
                    $("#downPayID").val(downPayID);
                    $("#downPayIDMin").val(downPayIDMin);
                    $("#downPayIDMax").val(downPayIDMax);

                    $("#downMonNum").attr("value", downMonNum);

                    $('#insPayID option[value=' + insPayID + ']').prop('selected', true);
                    $("#insPayID").attr("value", insPayID);

                    //$('#insPayIDSelect option[value=' + insPayIDSelect + ']').prop('selected', true);
                    $("#sinsPayIDSelect").val(insPayIDSelect);
                    $("#insPayIDSelect").val(insPayIDSelect);
                    $("#insPayIDSelectMin").val(insPayIDSelect);
                    $("#insPayIDSelectMax").val(insPayIDSelect);

                    $("#insNumVal").attr("value", insNumVal);

                    $("#insMonNum").attr("value", insMonNum);

                    calcResDown('res');
                    calcResDown('downPay');

                    /*resPriceCell = ((Number($("#priceCellDis").val())*(resID/100))).toFixed(2);
                     $("#resPriceCell").val(resPriceCell);
                     
                     downPayPriceCell = ((Number($("#priceCellDis").val())-Number($("#resPriceCell").val()))*(downPayID/100)).toFixed(2);
                     $("#downPayPriceCell").val(downPayPriceCell);*/

                    $("#insDetailesDiv").fadeIn();
                }
            }

            function getDates() {
                setDate('downMonNum', '', 'downDate');
                setDate('insMonNum', 'downMonNum', 'insDate');
            }
            
            function checkTolerance(fieldName){
                if(fieldName == "resID"){
                    et = "false";
                    var sresID = Number($("#sresID").val());
                    var resID = Number($("#resID").val());
                    var resIDMin = Number($("#resIDMin").val());
                    var resIDMax = Number($("#resIDMax").val());
                    //var resID = ((sresID-resIDTlrnc)/sresID)*100;
                    if((resID < resIDMin) || (resID > resIDMax)){
                        $("#resIDExcdMsg").fadeIn();
                        et = 'true';
                    }else {
                        $("#resIDExcdMsg").fadeOut();
                    }
                    calcResDown('res');
                } else if(fieldName == "downPayID"){
                    et = "false";
                    var sdownPayID = Number($("#sdownPayID").val());
                    var downPayID = Number($("#downPayID").val());
                    var downPayIDMin = Number($("#downPayIDMin").val());
                    var downPayIDMax = Number($("#downPayIDMax").val());
                    //var downPayID = ((sdownPayID-downPayIDTlrnc)/sdownPayID)*100;
                    if((downPayID <= downPayIDMin) || (downPayID >= downPayIDMax)){
                        $("#downPayIDExcdMsg").fadeIn();
                        et = 'true';
                    }else {
                        $("#downPayIDExcdMsg").fadeOut();
                    }
                    calcResDown('downPay');
                } else if(fieldName == "insPayIDSelect"){
                    et = "false";
                    var sinsPayIDSelect = Number($("#sinsPayIDSelect").val());
                    var insPayIDSelect = Number($("#insPayIDSelect").val());
                    var insPayIDSelectMin = Number($("#insPayIDSelectMin").val());
                    var insPayIDSelectMax = Number($("#insPayIDSelectMax").val());
                    //var insPayIDSelect = sinsPayIDSelect-(sinsPayIDSelect*insPayIDSelectTlrnc)/100;
                    if((insPayIDSelect < insPayIDSelectMin) || (insPayIDSelect > insPayIDSelectMax)){
                        $("#insPayIDSelectExcdMsg").fadeIn();
                        et = 'true';
                    }else {
                        $("#insPayIDSelectExcdMsg").fadeOut();
                    }
                }
            }
        </script>
        <style>
            td {border: none}
            table {border: none}
        </style>
    </head>

    <body>
        <form name="selectClientForm" method="POST">
            <input type="hidden" value="<%=unitWbo.getAttribute("projectID")%>" name="unitID" id="unitID">
            
            <fieldset class="set" style="border-color: #006699; width: 95%; margin-bottom: 10px;">
            <legend align="center">

                <table dir=" <fmt:message key="dir"/>">
                    <tr>

                        <td class="td">
                            <font color="blue" size="6"><fmt:message key="title"/>
                            </font>
                        </td>
                    </tr>
                </table>

            </legend >
        
            <br> 
            <div style="width: 100%;">
                <table id="indextable" ALIGN="center" dir="<fmt:message key="dir"/>" STYLE="width: 100%; text-align: center">
                    <thead>
                        <TR>
                            <TD><B><fmt:message key="planTit"/></B></TD>
                            <TD><B><fmt:message key="resVal"/></B></TD>
                            <TD><B><fmt:message key="firstPay"/></B></TD>
                            <TD><B><fmt:message key="fAfter"/></B></TD>
                            <TD><B><fmt:message key="paymentSys"/> </B></TD>
                            <TD><B><fmt:message key="fAfter"/></B></TD>
                            <TD><B><fmt:message key="installment"/> </B></TD>
                        </TR>  
                    </thead>
                    <tbody>

                        <%
                            if (null != PaymentPlamsLst) {

                                for(int i=0; i<PaymentPlamsLst.size(); i++) {
                                    WebBusinessObject doc = (WebBusinessObject) PaymentPlamsLst.get(i);
                        %>
                        <TR >
                            <TD >
                                <DIV ID="links">
                                    <B><%=doc.getAttribute("planTitle")%></B>
                                </DIV>
                            </TD>

                            <TD >
                                <DIV ID="links">
                                    <B><%=doc.getAttribute("rsrvAMT")%> %</B>
                                </DIV>
                            </TD>

                            <TD>
                                <DIV ID="links">
                                    <B><%=doc.getAttribute("downAMT")%> %</B>
                                </DIV>
                            </TD>
                            
                            <TD>
                                <DIV ID="links">
                                    <B><%=doc.getAttribute("downDate")%> <fmt:message key="month"/></B>
                                </DIV>
                            </TD>

                            <TD>
                                <DIV ID="links">
                                    <%
                                        String insSys = null ;
                                        if(doc.getAttribute("insSys") != null && doc.getAttribute("insSys").equals("1")){
                                            insSys = "Monthly";
                                        } else if(doc.getAttribute("insSys") != null && doc.getAttribute("insSys").equals("3")){
                                            insSys = "Quarterly";
                                        } else if(doc.getAttribute("insSys") != null && doc.getAttribute("insSys").equals("6")){
                                            insSys = "Biannual";
                                        } else if(doc.getAttribute("insSys") != null && doc.getAttribute("insSys").equals("12")){
                                            insSys = "Annual";
                                        }
                                    %>
                                    <B><%=insSys%></B>
                                </DIV>
                            </TD>
                            
                            <TD>
                                <DIV ID="links">
                                    <B><%=doc.getAttribute("insMon")%> <fmt:message key="month"/> </B>
                                </DIV>
                            </TD>
                            
                            <TD>
                                <DIV ID="links">
                                    <B><%=doc.getAttribute("insAMT")%> %</B>
                                </DIV>
                            </TD>
                        </TR>
                            <%}}%>
                    </tbody>
                </table>
            </div>
        </FIELDSET>
                
            <fieldset class="set" style="border-color: #006699; width: 95%; min-height: 400px;">
                <legend align="center">
                    <font color="blue" size="6"> 
                    <fmt:message key="payPlan"/>
                    </font>
                </legend>

                <div id="unitDetails">
                    <TABLE class="blueBorder" dir='<fmt:message key="direction"/>' align="center" width="95%" cellpadding="0" cellspacing="0" >
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <FONT color='white' SIZE="+1"> <fmt:message key="unitdetails"/> </FONT>

                                <BR/>
                            </TD>
                        </TR>
                    </TABLE>

                    <table  dir='<fmt:message key="direction" />' cellpadding="0" cellspacing="0" style="width: 95%;border: 0px;margin-top: 15px;">
                        <tr>
                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <b>
                                    <font size="2" color="black">
                                        <fmt:message key="project"/>
                                    </font>
                                </b>
                                </div>
                            </td>
                            <td style="width: 25%;">
                                <b>
                                    <font color="black" size="3">
                                    <%=projectWbo.getAttribute("projectName")%>
                                    </font>
                                </b>
                            </td>

                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b><font size="2" color="black">
                                        <fmt:message key="unitno" /> 
                                    </b>
                                </div>
                            </td>
                            <td style="width: 25%;">
                                <b>
                                    <font color="black" size="3" id="nameCell">
                                    <%=unitWbo.getAttribute("projectName")%>
                                    </font>
                                </b>
                            </td>
                        </tr>

                        <tr>
                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black">
                                        <fmt:message key="unitprice"/>
                                        </font>
                                    </b>
                                </div>
                            </td>
                            <td style="width: 25%;">
                                <b>
                                    <font color="black" size="3" id="priceCell">
                                    <% if (unitPriceWbo == null || unitPriceWbo.getAttribute("option1") == null) {%>
                                    ...
                                    <% } else {%>
                                    <input type="text" id="realPrice" value='<%=unitPriceWbo.getAttribute("option1")%>' style="border: none;" readonly>
                                    <% } %>
                                    </font>
                                </b>
                            </td>

                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black"> 
                                        <fmt:message key="unitarea"/>
                                        </font>
                                    </b>
                                </div>
                            </td>
                            <td style="width: 25%;">
                                <b>
                                    <font color="black" size="3" id="areaCell">
                                    <% if (unitPriceWbo == null || unitPriceWbo.getAttribute("maxPrice") == null) {%>
                                    ...
                                    <% } else {%>
                                    <%=unitPriceWbo.getAttribute("maxPrice")%>
                                    <% } %>
                                    </font>
                                </b>
                            </td>
                        </tr>
                    </table>
                </div>
                   
                <div id="clientDetails" style="display: none;">                
                    <TABLE class="blueBorder" dir='<fmt:message key="direction"/>' align="center" width="95%" cellpadding="0" cellspacing="0">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <FONT color='white' SIZE="+1"> <fmt:message key="clientDetails"/> </FONT>

                                <BR/>
                            </TD>
                        </TR>
                    </TABLE>

                    <table border="0" dir='<fmt:message key="direction" />' cellpadding="0" cellspacing="0" style="width: 95%;">
                        <tr>
                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black">
                                        <fmt:message key="clientName"/>
                                        </font>
                                    </b>
                                </div>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <% if (client != null || client.get(0).getAttribute("clientNO") != null || !client.get(0).getAttribute("clientNO").equals("UL")) {%>
                                    <input type="hidden" name="myClientID" id="myClientID" value="<%=client.get(0).getAttribute("id")%>">
                                    <% } %>
                                    <font color="black" size="3">
                                    <% if (client == null || client.get(0).getAttribute("name") == null || client.get(0).getAttribute("name").equals("UL")) {%>
                                    ...
                                    <% } else {%>
                                    <%=client.get(0).getAttribute("name")%>
                                    <% } %>
                                    </font>
                                </b>
                            </td>

                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black">
                                        <fmt:message key="clientJob"/>
                                        </font>
                                    </b>
                                </div>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <font color="black" size="3">
                                    <% if (client == null || client.get(0).getAttribute("job") == null || client.get(0).getAttribute("job").equals("UL")) {%>
                                    ...
                                    <% } else {%>
                                    <%=client.get(0).getAttribute("job")%>
                                    <% } %>
                                    </font>
                                </b>
                            </td>
                        </tr>

                        <tr>
                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black">
                                        <fmt:message key="clientAdd"/>
                                        </font>
                                    </b>
                                </div>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <font color="black" size="3">
                                    <% if (client == null || client.get(0).getAttribute("address") == null || client.get(0).getAttribute("address").equals("UL")) {%>
                                    ...
                                    <% } else {%>
                                    <%=client.get(0).getAttribute("address")%>
                                    <% } %>
                                    </font>
                                </b>
                            </td>

                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black">
                                        <fmt:message key="clientEmail"/>
                                        </font>
                                    </b>
                                </div>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <font color="black" size="3">
                                    <% if (client == null || client.get(0).getAttribute("email") == null || client.get(0).getAttribute("email").equals("UL")) {%>
                                    ...
                                    <% } else {%>
                                    <%=client.get(0).getAttribute("email")%>
                                    <% } %>
                                    </font>
                                </b>
                            </td>
                        </tr>

                        <tr>
                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black">
                                        <fmt:message key="clientPhone"/>
                                        </font>
                                    </b>
                                </div>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <font color="black" size="3">
                                    <% if (client == null || client.get(0).getAttribute("phone") == null || client.get(0).getAttribute("phone").equals("UL")) {%>
                                    ...
                                    <% } else {%>
                                    <%=client.get(0).getAttribute("phone")%>
                                    <% } %>
                                    </font>
                                </b>
                            </td>

                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black">
                                        <fmt:message key="clientMob"/>
                                        </font>
                                    </b>
                                </div>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <font color="black" size="3">
                                    <% if (client == null || client.get(0).getAttribute("mobile") == null || client.get(0).getAttribute("mobile").equals("UL")) {%>
                                    ...
                                    <% } else {%>
                                    <%=client.get(0).getAttribute("mobile")%>
                                    <% } %>
                                    </font>
                                </b>
                            </td>
                        </tr>

                        <tr>
                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black">
                                        <fmt:message key="clientNat"/>
                                        </font>
                                    </b>
                                </div>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <font color="black" size="3">
                                    <% if (client == null || client.get(0).getAttribute("nationality") == null || client.get(0).getAttribute("nationality").equals("UL")) {%>
                                    ...
                                    <% } else {%>
                                    <%=client.get(0).getAttribute("nationality")%>
                                    <% } %>
                                    </font>
                                </b>
                            </td>

                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black">
                                        <fmt:message key="clientIntNo"/>
                                        </font>
                                    </b>
                                </div>
                            </td>
                            <td style="width: 25%;" colspan="2">
                                <b>
                                    <font color="black" size="3">
                                    <% if (client == null || client.get(0).getAttribute("interPhone") == null || client.get(0).getAttribute("interPhone").equals("UL")) {%>
                                    ...
                                    <% } else {%>
                                    <%=client.get(0).getAttribute("interPhone")%>
                                    <% } %>
                                    </font>
                                </b>
                            </td>
                        </tr>
                    </table>
                </div>
                <TABLE class="blueBorder" dir='<fmt:message key="direction"/>' style="border: none;" align="center" width="95%" cellpadding="0" cellspacing="0">        
                    <% if (grageWbo != null && grageWbo.countAttribute() > 0) { %>
                    <tr style="border: none;">
                        <td bgcolor="#33ACFF" style="width: 17%; vertical-align: top; border: 0;">
                            <b>
                                <font size="2" color="black"> 
                                <fmt:message key="garage"/>
                                </font>
                            </b>
                        </td>

                        <td bgcolor="#CCCCCC" style="width: 17%; vertical-align: top; border: 0;">
                            <b>
                                <font size="2" color="black"> 
                                <fmt:message key="area"/>
                                </font>
                            </b>
                        </td>
                        <td style="width: 17%;" colspan="2">
                            <b>
                                <font color="black" size="3">
                                <% if (grageWbo.getAttribute("area") == null || grageWbo.getAttribute("area").equals("0")) {%>
                                ...
                                <% } else {%>
                                <%=grageWbo.getAttribute("area")%>
                                <% } %>
                                </font>
                            </b>
                        </td>

                        <td bgcolor="#CCCCCC" style="width: 17%; vertical-align: top; border: 0;">
                            <b>
                                <font size="2" color="black"> 
                                <fmt:message key="theprice"/>
                                </font>
                            </b>
                        </td>
                        <td style="width: 17%;" colspan="2">
                            <b>
                                <font color="black" size="3">
                                <% if (grageWbo.getAttribute("price") == null || grageWbo.getAttribute("price").equals("0")) {%>
                                ...
                                <% } else {%>
                                <input type="text" id="gragePrice" value='<%=grageWbo.getAttribute("price")%>' style="border: none;" readonly>
                                <% } %>
                                </font>
                            </b>
                            <input type="hidden" id="grageInfo" name="grageInfo" value='' style="border: none;" readonly>
                        </td>

                        <td style="width: 17%; vertical-align: top; border: none;">
                            <div>
                                <img id="addGarageImg" src="images/icons/add_item.png" width="30" title=" Add Garage " onclick="addGarageLocker('addGarage');" style="cursor: pointer;"/>
                                <img id="removeGarageImg" src="images/icons/delete_ready.png" width="30" title=" Remove Garage " onclick="addGarageLocker('removeGarage');" style="cursor: pointer; display: none;"/>
                            </div>
                        </td>
                    </tr>

                    <% }
                            if (lockerWbo != null && lockerWbo.countAttribute() > 0) { %>
                    <tr style="border: none;">
                        <td bgcolor="#33ACFF" style="width: 17%; vertical-align: top; border: 0;">
                            <b>
                                <font size="2" color="black"> 
                                <fmt:message key="locker"/>
                                </font>
                            </b>
                        </td>

                        <td bgcolor="#CCCCCC" style="width: 17%; vertical-align: top; border: 0;">
                            <b>
                                <font size="2" color="black"> 
                                <fmt:message key="area"/>
                                </font>
                            </b>
                        </td>
                        <td style="width: 17%;" colspan="2">
                            <b>
                                <font color="black" size="3">
                                <% if (lockerWbo.getAttribute("area") == null || lockerWbo.getAttribute("area").equals("0")) {%>
                                ...
                                <% } else {%>
                                <%=lockerWbo.getAttribute("area")%>
                                <% } %>
                                </font>
                            </b>
                        </td>

                        <td bgcolor="#CCCCCC" style="width: 17%; vertical-align: top; border: 0;">
                            <b>
                                <font size="2" color="black"> 
                                <fmt:message key="theprice"/>
                                </font>
                            </b>
                        </td>
                        <td style="width: 17%;" colspan="2">
                            <b>
                                <font color="black" size="3">
                                <% if (lockerWbo.getAttribute("price") == null || lockerWbo.getAttribute("price").equals("0")) {%>
                                ...
                                <% } else {%>
                                <input type="text" id="lockerPrice" value='<%=lockerWbo.getAttribute("price")%>' style="border: none;" readonly>
                                <% } %>
                                </font>
                            </b>
                            <input type="hidden" id="lockerInfo" name="lockerInfo" value='' style="border: none;" readonly>
                        </td>

                        <td style="width: 17%; vertical-align: top; border: none;">
                            <div>
                                <img id="addLockerImg" src="images/icons/add_item.png" width="30" title=" Add Locker " onclick="addGarageLocker('addLocker');" style="cursor: pointer;"/>
                                <img id="removeLockerImg" src="images/icons/delete_ready.png" width="30" title=" Remove Locker " onclick="addGarageLocker('removeLocker');" style="cursor: pointer; display: none;"/>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </table>

                <br><br><br><br><br>

                <div id="payPlan" style="display: block;"> 
                    <TABLE class="blueBorder" dir='<fmt:message key="direction"/>' align="center" width="95%" cellpadding="0" cellspacing="0">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <FONT color='white' SIZE="+1"> <fmt:message key="payPlanDetalis"/> </FONT>

                                <BR/>
                            </TD>
                        </TR>
                    </TABLE>
                                
                    <TABLE class="blueBorder" dir='<fmt:message key="direction"/>' width="95%" cellpadding="0" cellspacing="0" style="margin-top: 10px; margin-bottom: 10px; float: right;">        
                        <tr>
                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black"> 
                                            <fmt:message key="standPlan"/>
                                        </font>
                                    </b>
                                </div>
                            </td>

                            <% if (sPayPlanLst != null) {%>
                            <td style="width: 20%;float: right;">
                                <b>
                                    <select style="font-size: medium;font-weight: bold; width: 75%;" id="sPlanID" name="sPlanID" onchange="showInfo();">
                                        <option value=""> </option>
                                        <sw:WBOOptionList wboList='<%=sPayPlanLst%>' displayAttribute="planTitle" valueAttribute="ID"/>
                                    </select>
                                </b>
                            </td>
                            <% }%>
                        </tr>
                    </table>             

                    <TABLE class="blueBorder" dir='<fmt:message key="direction"/>' align="center" width="95%" cellpadding="0" cellspacing="0">
                        <TR>
                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black"> 
                                        <fmt:message key="planTitle"/>
                                        </font>
                                    </b>
                                </div>
                            </td>
                            <td style="width: 25%; border: 0;">
                                <b>
                                    <input type="text" id="planID" name="planID" style="font-size: medium; widows: 52%;" readonly/>
                                </b>
                            </td>

                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black">
                                        <fmt:message key="unitprice"/>
                                        </font>
                                    </b>
                                </div>
                            </td>
                            <td style="width: 25%;">
                                <b>
                                    <font color="black" size="3" id="priceCell">
                                    <% if (unitPriceWbo == null || unitPriceWbo.getAttribute("option1") == null) {%>
                                    ...
                                    <% } else {
                                        amount = Double.parseDouble(unitPriceWbo.getAttribute("option1").toString());
                                    %>
                                    <%=formatter.format(amount)%>
                                    <% } %>
                                    </font> 
                                </b>
                            </td>
                        </tr>

                        <TR>
                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black"> 
                                        <fmt:message key="discount"/>
                                        </font>
                                    </b>
                                </div>
                            </td>
                            <td style="width: 25%; text-align: center; border: 0;">
                                <b>
                                    <select id="disID" name="disID" style="font-size: medium; width:50%; "onchange="countPrice();">
                                        <option value="">   </option>
                                        <option value="0"> 0% </option>
                                        <option value="5"> 5% </option>
                                        <option value="10"> 10% </option>
                                    </select>
                                </b>
                            </td>


                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black">
                                        <fmt:message key="unitpriceD"/>
                                        </font>
                                    </b>
                                </div>
                            </td>
                            <td bgcolor="#fbfb9f" style="width: 25%;">
                                <b>
                                    <font color="black" size="3">
                                    <input type="text" id="priceCellDis" name="priceCellDis" style="border: none; background-color: #fbfb9f" readonly>
                                    </font>
                                </b>
                            </td>
                        </tr>
                    </table>

                    <br/><br/>

                    <div id="insDetailesDiv" name="insDetailesDiv" style="display: none;">
                        <font style="color:red;font-size: 20px;"/>
                        ----------------------------------------------------
                         <fmt:message key="resDetails"/>
                        ----------------------------------------------------
                        <br/><br/>
                        <TABLE class="blueBorder" dir='<fmt:message key="direction"/>' align="center" width="95%" cellpadding="0" cellspacing="0" >        
                            <tr>
                                <td style="width: 8%; vertical-align: top;">
                                    <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                        <b>
                                            <font size="2" color="black"> 
                                            <fmt:message key="reservation"/>
                                            </font>
                                        </b>
                                    </div>
                                </td>
                                <td style="width: 16%; border: 0;">
                                    <b>
                                        <input id="sresID" name="sresID" type="number" min="0" max="100" readonly style="width: 30%;">
                                        <input id="resIDMin" name="resIDMin" type="hidden" min="0" max="100" readonly>
                                        <input id="resIDMax" name="resIDMax" type="hidden" min="0" max="100" readonly>
                                        <input id="resID" name="resID" type="number" min="0" max="100" onchange="checkTolerance('resID')" style="width: 30%;">
                                        <%--input id="resID" name="resID" type="number" min="0" max="100" readonly style="width: 30%;" onchange="calcResDown('res');"--%>
                                    </b>
                                </td>
                                
                                <td style="width: 16%; border: 0;">
                                    <label id="resIDExcdMsg" style="display: none;">
                                        <font color="red">
                                            You Exceed The Tolerance 
                                    </label>
                                </td>

                                <td style="width: 8%; vertical-align: top;">
                                    <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                        <b>
                                            <font size="2" color="black">
                                            <fmt:message key="resDate"/>
                                            </font>
                                        </b>
                                    </div>
                                </td>
                                <td style="width: 16%; border: 0;">
                                    <input id="resDate" name="resDate" type="text" style="width: 90%; text-align: center;" onchange="getDates();"/>
                                </td>

                                <td style="width: 8%; vertical-align: top;">
                                    <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                        <b>
                                            <font size="2" color="black">
                                            <fmt:message key="reservation"/>
                                            </font>
                                        </b>
                                    </div>
                                </td>
                                <td bgcolor="#fbfb9f" style="width: 16%;" colspan="2">
                                    <b>
                                        <font color="black" size="3">
                                        <input id="resPriceCell" name="resPriceCell" style="border: none; background-color: #fbfb9f; text-align: center;" readonly>
                                        </font>
                                    </b>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 8%; vertical-align: top;">
                                    <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                        <b>
                                            <font size="2" color="black"> 
                                            <fmt:message key="downPay"/> 
                                            </font>
                                        </b>
                                    </div>
                                </td>
                                <td style="width: 16%; border: 0;">
                                    <b>
                                        <input id="sdownPayID" name="sdownPayID" type="number" min="0" max="100" readonly style="width: 30%;margin-right: 29px;">
                                        <input id="downPayIDMin" name="downPayIDMin" type="hidden" min="0" max="100" readonly>
                                        <input id="downPayIDMax" name="downPayIDMax" type="hidden" min="0" max="100" readonly>
                                        <input id="downPayID" name="downPayID" type="number" min="0" max="100" onchange="checkTolerance('downPayID')" style="width: 30%;">
                                        <%--input id="downPayID" name="downPayID" type="number" min="0" max="100" readonly style="width: 30%;" onchange="calcResDown('downPay')"--%>
                                    </b>
                                    <font size="2" color="black"> 
                                    <fmt:message key="after"/> 
                                    </font>
                                    <b>
                                        <input type="number" id="downMonNum" name="downMonNum" style="width: 25%;" min="1" onchange="setDate('downMonNum', '', 'downDate');" <%=typ != null && typ.equals("spp") ? "readonly" : ""%>>
                                    </b>
                                </td>
                                
                                <td style="width: 16%; border: 0;">
                                    <label id="downPayIDExcdMsg" style="display: none;">
                                        <font color="red">
                                            You Exceed The Tolerance 
                                    </label>
                                </td>

                                <td style="width: 8%; vertical-align: top;">
                                    <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                        <b>
                                            <font size="2" color="black"> 
                                            <fmt:message key="date"/>
                                            </font>
                                        </b>
                                    </div>
                                </td>
                                <td style="width: 16%; border: 0;">
                                    <input id="downDate" name="downDate" type="text" style="width: 90%; text-align: center;" onclick="setDate('downMonNum', '', 'downDate');" readonly/>
                                </td>

                                <td style="width: 8%; vertical-align: top;">
                                    <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                        <b>
                                            <font size="2" color="black">
                                            <fmt:message key="downPay"/>
                                            </font>
                                        </b>
                                    </div>
                                </td>
                                <td bgcolor="#fbfb9f" style="width: 16%;" colspan="2">
                                    <b>
                                        <font color="black" size="3">
                                        <input id="downPayPriceCell" name="downPayPriceCell" style="border: none; background-color: #fbfb9f; text-align: center;" readonly>
                                        </font>
                                    </b>
                                </td>
                            </tr>
                        </table>

                        <br/><br/>
                        <font style="color:red;font-size: 20px;"/>
                        ----------------------------------------------------
                         <fmt:message key="instDetails"/>
                        ----------------------------------------------------
                        <br/><br/>
                        <TABLE class="blueBorder" dir='<fmt:message key="direction"/>' align="center" width="95%" cellpadding="0" cellspacing="0">                        
                            <tr>
                                <td style="width: 8%; vertical-align: top;">
                                    <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                        <b>
                                            <font size="2" color="black"> 
                                            <fmt:message key="installmentsSystem"/>
                                            </font>
                                        </b>
                                    </div>
                                </td>
                                <td style="width: 16%; text-align: center; border: 0;">
                                    <b>
                                        <select id="insPayID" name="insPayID" style="font-size: medium;" <%=typ != null && typ.equals("spp") ? "disabled" : ""%>>
                                            <option value="1"> Monthly </option>
                                            <option value="3"> Quarterly </option>
                                            <option value="6"> Biannual </option>
                                            <option value="12"> Annual </option>
                                        </select>
                                    </b>
                                </td>

                                <td style="width: 8%; vertical-align: top;">
                                    <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                        <b>
                                            <font size="2" color="black"> 
                                            <fmt:message key="installments"/>
                                            </font>
                                        </b>
                                    </div>
                                </td>
                                <td style="width: 16%; text-align: center; border: 0;">
                                    <b>
                                        <input id="sinsPayIDSelect" name="sinsPayIDSelect" type="number" min="0" max="100" readonly style="width: 30%;">
                                        <input id="insPayIDSelectMin" name="insPayIDSelectMin" type="hidden" min="0" max="100" readonly>
                                        <input id="insPayIDSelectMax" name="insPayIDSelectMax" type="hidden" min="0" max="100" readonly>
                                        <input id="insPayIDSelect" name="insPayIDSelect" type="number" min="0" max="100" onchange="checkTolerance('insPayIDSelect')" style="width: 30%;">
                                        <%--input id="insPayIDSelect" name="insPayIDSelect" type="number" min="0" max="100" readonly style="width: 30%;"--%>

                                        <input id="insPayIDInput" name="insPayIDInput" style="text-align: center; border: none; display: none; width: 95%; height: 95%; background-color: #fbfb9f" readonly>
                                    </b>
                                </td>
                                
                                <td style="width: 16%; border: 0;">
                                    <label id="insPayIDSelectExcdMsg" style="display: none;">
                                        <font color="red">
                                            You Exceed The Tolerance 
                                    </label>
                                </td>

                                <td style="width: 8%; vertical-align: top;">
                                    <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                        <input type="checkbox" id="insNumCheck" name="insNumCheck" value="off" onchange="openInstallment();">

                                        <b>
                                            <font size="2" color="black"> 
                                            <fmt:message key="insNum"/>
                                            </font>
                                        </b>
                                    </div>
                                </td>
                                <td style="width: 16%; text-align: center; border: 0;">
                                    <b>
                                        <input type="number" id="insNum" name="insNum" style="width: 50%; text-align: center;" min="0" readonly="readonly" <%=typ != null && typ.equals("spp") ? "disabled" : ""%>> Month(s) 
                                        <input type="hidden" id="insNumVal" name="insNumVal">
                                    </b>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 8%; vertical-align: top;">
                                    <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                        <b>
                                            <font size="2" color="black"> 
                                            After 
                                            </font>
                                        </b>
                                    </div>
                                </td>
                                <td style="width: 12%; text-align: center; border: 0;">
                                    <b>
                                        <input type="number" id="insMonNum" name="insMonNum" style="width: 25%;" min="1" onchange="setDate('insMonNum', 'downMonNum', 'insDate');"> Month(s)
                                    </b>
                                </td>

                                <td style="width: 8%; vertical-align: top;">
                                    <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                        <b>
                                            <font size="2" color="black"> 
                                            <fmt:message key="fIDate"/>
                                            </font>
                                        </b>
                                    </div>
                                </td>
                                <td style="width: 12%; border: 0;">
                                    <input id="insDate" name="insDate" type="text" style="width: 90%; text-align: center;" onclick="setDate('insMonNum', 'downMonNum', 'insDate');" readonly/>
                                </td>
                            </tr>

                            <tr>
                                <td style="width: 8%; vertical-align: top;">
                                    <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                        <b>
                                            <font size="2" color="black">
                                            <fmt:message key="unitprice"/>
                                            </font>
                                        </b>
                                    </div>
                                </td>
                                <td bgcolor="#fbfb9f" style="width: 16%;">
                                    <b>
                                        <font color="black" size="3">
                                        <input id="priceCellInsSys" name="priceCellInsSys"style="border: none; background-color: #fbfb9f; text-align: center;" readonly>
                                        </font>
                                    </b>
                                </td>

                                <td style="width: 8%; vertical-align: top;">
                                    <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                        <b>
                                            <font size="2" color="black">
                                            <fmt:message key="insPrice"/>
                                            </font>
                                        </b>
                                    </div>
                                </td>
                                <td bgcolor="#fbfb9f" style="width: 16%;" colspan="2">
                                    <b>
                                        <font color="black" size="3">
                                        <input id="insPriceCell" name="insPriceCell" style="border: none; background-color: #fbfb9f; text-align: center;" readonly>
                                        </font>
                                    </b>
                                </td>

                                <td style="width: 16%; text-align: center; border: 0;">
                                    <b>
                                        <input class="button" type="button" onclick="calculate();" style="width: 90%; text-align: center;" value=" <fmt:message key="calc"/> " readonly>
                                    </b>
                                </td>
                            </tr>
                        </TABLE>
                    </div>

                    <button class="button" style="margin: 10px; text-align: center;" onclick="savePlan();"> <fmt:message key="gPaymentPlan"/>  <img src="images/ok_white.png" width="20" height="20"/></button>
                </div>
            </fieldset>
        </form>
    </body>
</html>