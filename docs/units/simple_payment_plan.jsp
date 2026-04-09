
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    String save = (String) request.getAttribute("save") != null ? (String) request.getAttribute("save") : "";
    ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsLst");
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
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>

        <script  type="text/javascript">
            function openInstallment() {
                if ($("#insNumCheck").val() === "off") {
                    $("#insNumCheck").attr("value", "on");
                    $("#insNum").removeAttr("readonly");
                    $("#insPayIDSelect").fadeOut();
                } else if ($("#insNumCheck").val() === "on") {
                    $("#insNumCheck").attr("value", "off");
                    $("#insNum").attr("readonly", "readonly");
                    $("#insPayIDInput").hide();
                    $("#insPayIDSelect").fadeIn();
                }
            }

            function validate() {
                var flag = "";
                if ($("#planID").val() === " " || $("#planID").val() === "") {
                    flag = "planID";
                } else if ($("#resID").val() === " " || $("#resID").val() === "") {
                    flag = "resID";
                } else if ($("#downPayID").val() === " " || $("#downPayID").val() === "") {
                    flag = "downPayID";
                } else if ($("#downMonNum").val() === "") {
                    flag = "downMonNum";
                } else if ($("#insPayID").val() === " " || $("#insPayID").val() === "") {
                    flag = "insPayID";
                } else if ($("#insMonNum").val() === "") {
                    flag = "insMonNum";
                } else if ($("#insPayIDSelect").val() === "") {
                    flag = "insPayIDSelect";
                } else {
                    flag = "";
                }
                return flag;
            }

            function savePlan() {
                var flag = validate();
                if (flag === "") {
                    var insNum, insPres, insPay, insAmt;
                    if ($("#insNumCheck").val() === "on") {
                        insNum = Number($("#insNum").val());
                        insPay = Number($("#insPayID").val());
                        insAmt = ((insPay / insNum) * 100).toFixed(2);
                        $("#insPayIDInput").attr("value", insAmt + "%");
                        $("#insPayIDInput").fadeIn();
                        insPres = insAmt;
                    } else if ($("#insNumCheck").val() === "off") {
                        $("#insNum").val("");
                        insPay = Number($("#insPayID").val());
                        insPres = $("#insPayIDSelect").val();
                        insAmt = Math.ceil((insPay * (100 / insPres)));
                        $("#insNum").val(insAmt);
                        insNum = insAmt;
                    }
                    $("#insNumVal").val(Math.ceil(100 / insPres));
                    if ($("#projectID").val() === "" || $("#projectID").val() === null) {
                        alert("Please Select Project");
                    } else {
                        document.standardPlanForm.action = "UnitServlet?op=paymentPlanSystem&save=yes";
                        document.standardPlanForm.submit();
                    }
                } else {
                    $(".errorMsg").attr("type", "hidden");
                    $("#" + flag + "Msg").attr("type", "text");
                    alert(" Enter Requires Fields ");
                }
            }

            function zeroDate(selectVal, dateVal) {
                if ($("#" + selectVal).val() === "0") {
                    $("." + dateVal).hide();
                } else {
                    $("." + dateVal).show();
                }
            }

            function checkValue(fieldNm) {
                var min = Number($("#" + fieldNm + "Min").val());
                var max = Number($("#" + fieldNm + "Max").val());
                if (min < $("#" + fieldNm).val() && min > max && max !== 0 && max > $("#" + fieldNm).val()) {
                    $("#" + fieldNm + "Min").val("");
                    $("#" + fieldNm + "Max").val("");
                    alert(" Enter Valid Numbers in Min and Max ");
                    $("#" + fieldNm + "Min").focus();
                    $("#" + fieldNm + "Max").focus();
                }
            }
            
            function calculatInstallment() {
                var percent = 100.0;
                if($("#resID").val() !== '') {
                    percent -= parseFloat($("#resID").val());
                }
                if($("#downPayID").val() !== '') {
                    percent -= parseFloat($("#downPayID").val());
                }
                if($("#insPayIDSelect").val() !== '' && parseFloat($("#insPayIDSelect").val()) !== 0) {
                    percent /= parseFloat($("#insPayIDSelect").val());
                }
                $("#insPayIDSelectMin").val(percent.toFixed(2));
            }
        </script>
        <style>
            td {border: none}
            table {border: none}
        </style>
    </head>

    <body>
        <fieldset class="set" style="border-color: #006699; width: 90%; min-height: 400px;">
            <legend align="center">
                <font color="blue" size="6"> 
                <fmt:message key="payPlanSys"/>
                </font>
            </legend>

            <input type="text" id="saveMsg" style="padding: 20px; font-size: 20px; font-weight:bold; border: none; text-align: center; color: green; display: none;" readonly>
            <input type="text" id="noSaveMsg" style="padding: 20px; font-size: 20px; font-weight:bold; border: none; text-align: center; color: red; display: none;" readonly>

            <form name="standardPlanForm" method="POST">
                <div id="payPlan" style="display: block; width: 80%;"> 
                    <TABLE class="blueBorder" dir='<fmt:message key="direction"/>' align="center" width="90%" cellpadding="0" cellspacing="0">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <FONT color='white' SIZE="+1"> <fmt:message key="payPlanDetalis"/> </FONT>
                                <BR/>
                            </TD>
                        </TR>
                    </TABLE>

                    <TABLE class="blueBorder" dir='<fmt:message key="direction"/>' align="center" width="50%">
                        <TR>
                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black"> 
                                        <fmt:message key="project"/>
                                        </font>
                                    </b>
                                </div>
                            </td>

                            <td style="width: 49%; border: 0;">
                                <select name="projectID" id="projectID" style="width: 300px;">
                                    <option value="" > All Projects </option>
                                    <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute="projectName" valueAttribute="projectID"/>
                                </select>
                            </td>
                        </tr>

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

                            <td style="width: 49%; border: 0;">
                                <b>
                                    <input type="text" id="planID" name="planID" style="font-size: medium; width: 85%;">
                                    <input type="hidden" id="planIDMsg" class="errorMsg" value="*" style="font-weight: bolder; width: 5%; border: none; color: red;" readonly>
                                </b>
                            </td>
                        </tr>

                    </table>

                    <br/><br/>
                    <font style="color:red;font-size: 20px;"/>
                    ----------------------------------------------------
                    <fmt:message key="resDetails"/>
                    ----------------------------------------------------
                    <br/><br/>
                    <TABLE class="blueBorder" dir='<fmt:message key="direction"/>' align="center" width="90%" cellpadding="0" cellspacing="0">        
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

                            <td style="width: 12.5%; border: 0;">
                                <b>
                                    <select id="resID" name="resID" style="font-size: medium; width: 100px;"
                                            onchange="JavaScript: calculatInstallment();">
                                        <option value="">  </option>
                                        <option value="0"> 0% </option>
                                        <option value="5"> 5% </option>
                                        <option value="10"> 10% </option>
                                        <option value="15"> 15% </option>
                                        <option value="20"> 20% </option>
                                        <option value="25"> 25% </option>
                                    </select>
                                    <input type="hidden" id="resIDMsg" class="errorMsg" value="*" style="font-weight: bolder; width: 5%; border: none; color: red;" readonly>
                                </b>
                            </td>

                            <td style="width: 8%; vertical-align: top; display: none;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black"> 
                                        <fmt:message key="min"/>
                                        </font>
                                    </b>
                                </div>
                            </td>

                            <td style="width: 12.5%; border: 0; display: none;">
                                <b>
                                    <input type="hidden" min="0" id="resIDMin" name="resIDMin" style="width: 75%;" onchange="JavaScript: checkValue('resID');"> %
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

                            <td style="width: 12.5%; border: 0;">
                                <b>
                                    <select id="downPayID" name="downPayID" style="font-size: medium; width: 100px;" onchange="JavaScript: zeroDate('downPayID', 'downPayIDDiv'); calculatInstallment();">
                                        <option value="">  </option>
                                        <option value="0"> 0% </option>
                                        <option value="5"> 5% </option>
                                        <option value="10"> 10% </option>
                                        <option value="15"> 15% </option>
                                        <option value="20"> 20% </option>
                                        <option value="25"> 25% </option>
                                    </select>
                                    <input type="hidden" id="downPayIDMsg" class="errorMsg" value="*" style="font-weight: bolder; width: 5%; border: none; color: red;" readonly>
                                </b>
                            </td>

                            <td style="width: 8%; vertical-align: top; display: none;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black"> 
                                        <fmt:message key="min"/>
                                        </font>
                                    </b>
                                </div>
                            </td>

                            <td style="width: 12.5%; border: 0; display: none;">
                                <b>
                                    <input type="hidden" min="0" id="downPayIDMin" name="downPayIDMin" style="width: 75%;" onchange="JavaScript: checkValue('downPayID');"> %
                                </b>
                            </td>
                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black"> 
                                        <fmt:message key="after"/>
                                        </font>
                                    </b>
                                </div>
                            </td>

                            <td class="downPayIDDiv" style="width: 12.5%; border: 0;">
                                <input type="number" id="downMonNum" name="downMonNum" style="width: 50px;" min="1"> <fmt:message key="month"/> 
                                <input type="hidden" id="downMonNumMsg" class="errorMsg" value="*" style="font-weight: bolder; width: 5%; border: none; color: red;" readonly>
                            </td>
                        </tr>
                    </table>

                    <br/><br/>
                    <font style="color:red;font-size: 20px;"/>
                    ----------------------------------------------------
                    <fmt:message key="instDetails"/>
                    ----------------------------------------------------
                    <br/><br/>

                    <TABLE class="blueBorder" dir='<fmt:message key="direction"/>' align="center" width="90%" cellpadding="0" cellspacing="0">                        
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
                            <td style="width: 12.5%; text-align: center; border: 0;">
                                <b>
                                    <select id="insPayID" name="insPayID" style="font-size: medium; width: 100px;">
                                        <option value="">  </option>
                                        <option value="1"> Monthly </option>
                                        <option value="3"> Quarterly </option>
                                        <option value="6"> Biannual </option>
                                        <option value="12"> Annual </option>
                                    </select>
                                    <input type="hidden" id="insPayIDMsg" class="errorMsg" value="*" style="font-weight: bolder; width: 5%; border: none; color: red;" readonly>
                                </b>
                            </td>

                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black"> 
                                        <fmt:message key="after"/> 
                                        </font>
                                    </b>
                                </div>
                            </td>

                            <td class="insPayIDSelectDiv" style="width: 12.5%; text-align: <fmt:message key="textalign"/>; border: 0;" colspan="3">
                                <b>
                                    <input type="number" id="insMonNum" name="insMonNum" style=" width: 100px; float: right; margin-right: 1.5%;" min="1"/> &nbsp;<fmt:message key="month"/>
                                    <input type="hidden" id="insMonNumMsg" class="errorMsg" value="*" style="font-weight: bolder; width: 5%; border: none; color: red;" readonly>
                                </b>
                            </td>
                        </tr>

                        <tr>
                            <td style="width: 8%; vertical-align: top;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <b>
                                        <font size="2" color="black"> 
                                        <fmt:message key="installmentsNo"/>
                                        </font>
                                    </b>
                                </div>
                            </td>

                            <td style="width: 12.5%; text-align: center; border: 0;">
                                <b>
                                    <input type="number" id="insPayIDSelect" name="insPayIDSelect" style="font-size: medium;  width: 100px;" onchange="JavaScript: zeroDate('downPayID', 'downPayIDDiv'); calculatInstallment();" min='1' />
                                    <input type="hidden" id="insPayIDSelectMsg" class="errorMsg" value="*" style="font-weight: bolder; width: 5%; border: none; color: red;" readonly>
                                    <input id="insPayIDInput" name="insPayIDInput" style="text-align: center; border: none; display: none; width: 100%; height: 100%; background-color: #D6FF5C" readonly>
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

                            <td style="width: 12.5%; border: 0;">
                                <b>
                                    <input type="number" min="0" id="insPayIDSelectMin" name="insPayIDSelectMin" style="width: 100px;" onchange="JavaScript: checkValue('insPayIDSelect');" readonly> %
                                </b>
                            </td>
                            <td style="width: 8%; vertical-align: top; display: none;">
                                <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                    <input type="checkbox" id="insNumCheck" name="insNumCheck" value="off" onchange="JavaScript: openInstallment();" style="width: 25%;">

                                    <b>
                                        <font size="2" color="black"> 
                                        <fmt:message key="insNum"/>
                                        </font>
                                    </b>
                                </div>
                            </td>

                            <td style="width: 12.5%; text-align: center; border: 0; display: none;">
                                <b>
                                    <input type="number" id="insNum" name="insNum" style="width: 50px; text-align: center;" min="0" readonly="readonly"> <fmt:message key="month"/>
                                    <input type="hidden" id="insNumVal" name="insNumVal">
                                </b>
                            </td>
                        </tr>
                    </TABLE>

                    <input type="button" class="button" style="margin: 10px; text-align: center; width: 25%;" onclick="JavaScript: savePlan();" value=" <fmt:message key="genplan"/> "/>
                </div>
            </form>
        </fieldset>
    </body>
</html>