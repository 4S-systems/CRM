<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@ page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");

        ArrayList<LiteWebBusinessObject> salaryItems = (ArrayList<LiteWebBusinessObject>) request.getAttribute("salaryItems");
        String empID = (String) request.getAttribute("empID");

        String dir, saveFailMsg, sTitle, saveSuccessMsg, debit, credit, value, percent;
        if (stat.equals("En")) {
            dir = "LTR";
            sTitle = "Employee Salary Config";
            debit = "Debit";
            credit = "Credit";
            value = "Value";
            percent = "Percent";
        } else {
            dir = "RTL";
            sTitle = "تعيين مفردات المرتب";
            debit = "مدين";
            credit = "دائن";
            value = "قيمة";
            percent = "نسبة";
        }
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script src="js/silkworm_validate.js" type="text/javascript"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <SCRIPT LANGUAGE="JavaScript" SRC="js/validator.js" TYPE="text/javascript" />
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" src="js/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript">
            function cancelForm() {
                try {
                    opener.getClientInfo('');
                } catch (err) {
                }
                self.close();
            }

            function closePopup(obj) {
                $(obj).parent().parent().bPopup().close();
            }

            function saveSalaryItems() {
                if (validateForm()) {
                    var counter = $("#numberOfSalaryItems").val();

                    var salaryItemIdArr = [];
                    var salaryItemValue = [];
                    var salaryPersent = [];
                    var salaryType = [];

                    for (var i = 0; i < counter; i++) {
                        salaryItemIdArr.push($("#salaryItemID" + i).val());
                        salaryItemValue.push($("#itemValue" + i).val());
                        salaryPersent.push($("#IsPersent" + i).val());
                        salaryType.push($("#itemType" + i).val());
                    }

                    $.ajax({
                        url: "<%=context%>/EmployeeServlet?op=saveEmpSalaryConfig",
                        data: {
                            empID: <%=empID%>,
                            salaryItemIdArr: salaryItemIdArr.join(),
                            salaryItemValue: salaryItemValue.join(),
                            salaryPersent: salaryPersent.join(),
                            salaryType: salaryType.join()
                        },
                        success: function () {
                            location.reload();
                            alert("تم حفظ مفردات المرتب ");
                        }
                    });
                }
            }
        </script>
        <style>
            .titleTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color:#b9d2ef;
            }
            .dataTD {
                text-align:right;
                border: none;
                font-weight: bold;
                font-size: 16px;
                color: black;
            }
            tr:nth-child(even) td.dataTD {
                background: #FFF
            }
            tr:nth-child(odd) td.dataTD {
                background: #f1f1f1
            }
            .closeBtn{
                width:145px;
                height:31px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/close2.png);
            }
            #moMsg,#telMsg,#naMsg,#mailMsg{
                font-size: 14px;
                display: none;
                color: red;
                margin: 0px;
            }
            div.ui-datepicker{
                font-size:10px;
            }
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;
                background: #7abcff; /* Old browsers */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
        </style>
    </head>
    <BODY>
        <form name="SALARY_ITEMS_FORM" method="post" enctype="multipart/form-data">
            <table id="salaryItems" class="excelentCell" dir="rtl" width="100%" CELLPADDING="0" CELLSPACING="0" style="margin-left: 5px; margin-bottom: 5px; vertical-align: middle">
                <thead>
                    <tr>
                        <td class="blueBorder blueHeaderTD" width="10%"> كود المرتب </td>
                        <td class="blueBorder blueHeaderTD" width="30%"> بند المرتب </td>
                        <td class="blueBorder blueHeaderTD" width="20%"> قيمة البند </td>
                        <td class="blueBorder blueHeaderTD" width="20%"> نسبة / قيمة </td>
                        <td class="blueBorder blueHeaderTD" width="20%"> نوع البند </td>
                    </tr>
                </thead>

                <tbody>
                    <%
                        for (int i = 0; i < salaryItems.size(); i++) {
                            LiteWebBusinessObject salayWbo = (LiteWebBusinessObject) salaryItems.get(i);
                    %>
                    <tr id="row">
                        <td style="text-align: center" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                            <b>
                                <font size="2" color="#000080" style="text-align: center;">
                                    <%=salayWbo.getAttribute("code")%> 
                                    <input type="hidden" id="salaryItemID<%=i%>" name="salaryItemID" value="<%=salayWbo.getAttribute("id")%>" />
                                </font>
                            </b>
                        </td>

                        <td style="text-align: center" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                            <b>
                                <font size="2" color="#000080" style="text-align: center;">
                                    <%=salayWbo.getAttribute("arName")%> 
                                </font>
                            </b>
                        </td>

                        <td style="text-align: center" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                            <b>
                                <font size="2" color="#000080" style="text-align: center;">
                                    <input type="number" style="width:100%; border-color: <%="mandatory".equals(salayWbo.getAttribute("expenseItemAccountType")) ? "red" : ""%>;" name="itemValue<%=i%>" ID="itemValue<%=i%>" size="33"  maxlength="10" class="empNumber" min="0" step="any"
                                           value="<%=salayWbo.getAttribute("value") != null ? salayWbo.getAttribute("value") : "0"%>" /> 
                                </font>
                            </b>
                        </td>

                        <td style="text-align: center" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                            <b>
                                <font size="2" color="#000080" style="text-align: center;">
                                    <%="0".equals(salayWbo.getAttribute("calcType")) ? percent : value%>
                                </font>
                                <input type="hidden" id="IsPersent<%=i%>" name="IsPersent<%=i%>" value="<%="0".equals(salayWbo.getAttribute("calcType")) ? "persentage" : "value"%>"/>
                            </b>
                        </td>

                        <td style="text-align: center" bgcolor="#DDDD00" nowrap="" class="silver_even_main">
                            <b>
                                <font size="2" color="#000080" style="text-align: center;">
                                    <%="Debit".equals(salayWbo.getAttribute("transType")) ? debit : credit%>
                                </font>
                                <input type="hidden" id="itemType<%=i%>" name="itemType<%=i%>" value="<%="Debit".equals(salayWbo.getAttribute("transType")) ? "debit" : "credit"%>"/>
                            </b>
                        </td>
                    </tr>
                    <%}%>
                </tbody>
            </table>

            <div style="text-align: center;margin-left: auto;margin-right: auto;" > <input type="button" value="حفظ" onclick="saveSalaryItems()" id="save" class="login-submit"/></div>
            <input type="hidden" id="numberOfSalaryItems" name="numberOfSalaryItems" value="<%=salaryItems.size()%>" />
        </form>
        <script>
            function validateForm() {
            <%
                for (int i = 0; i < salaryItems.size(); i++) {
                    LiteWebBusinessObject salaryWbo = (LiteWebBusinessObject) salaryItems.get(i);
                    if ("mandatory".equals(salaryWbo.getAttribute("expenseItemAccountType"))) {
            %>
                if ($("#itemValue<%=i%>").val() === '' || parseInt($("#itemValue<%=i%>").val()) === 0) {
                    $("#itemValue<%=i%>").focus();
                    alert("Value is required");
                    return false;
                }
            <%
            } else {
            %>
                if ($("#itemValue<%=i%>").val() === '') {
                    $("#itemValue<%=i%>").val("0");
                }
            <%
                    }
                }
            %>
                return true;
            }
        </script>
    </BODY>
</html>