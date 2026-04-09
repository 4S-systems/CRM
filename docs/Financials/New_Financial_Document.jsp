<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.Calendar"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    Calendar calendar = Calendar.getInstance();

    String context = metaMgr.getContext();

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
    String now = sdf.format(calendar.getTime());

    ArrayList purposeArrayList = (ArrayList) request.getAttribute("purposeArrayList");
    ArrayList CostCenterList = (ArrayList) request.getAttribute("CostCenterList");
    ArrayList sourceDestinationLst = (ArrayList) request.getAttribute("sourceDestinationLst");

    ArrayList clientsList = (ArrayList) request.getAttribute("clientsList");

    String status = (String) request.getAttribute("status");
    String option1 = null;
    for (int i = 0; i < purposeArrayList.size(); i++) {
        WebBusinessObject wbo = (WebBusinessObject) purposeArrayList.get(i);
        option1 += "<Option value='" + wbo.getAttribute("projectID").toString() + "'>" + wbo.getAttribute("projectName").toString() + "</option>";
    }

    String option2 = null;
    for (int i = 0; i < CostCenterList.size(); i++) {
        WebBusinessObject wbo = (WebBusinessObject) CostCenterList.get(i);
        option2 += "<Option value='" + wbo.getAttribute("projectID").toString() + "'>" + wbo.getAttribute("projectName").toString() + "</option>";
    }
%>
<html>
    <head>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/custom_popup/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript">
            $(function () {
                $("#documentDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd",
                    buttonImageOnly: true,
                    buttonText: "Select date"
                });
            });

            function getSourceList(obj, listType) {
                var kindId = $(obj).val();

                $("#" + listType).removeAttr("disabled");
                $("#" + listType).html("");

                $.ajax({
                    type: "post",
                    url: "<%=context%>/FinancialServlet?op=getKindsList",
                    data: {
                        kindId: kindId
                    },
                    success: function (jsonString) {
                        var data = $.parseJSON(jsonString);
                        var rowData;

                        if (data != null && data.length > 0) {
                            var len = data.length;
                            for (var i = 0; i < len; i++) {
                                rowData = data[i];
                                if (kindId != null && (kindId === "FIN_CNTRCT" || kindId === "FIN_CLNT")) {
                                    $("#" + listType).html($("#" + listType).html() + "<option value='" + rowData.id + "'>" + rowData.name + "</option>");
                                } else if (kindId === "FIN_EMP") {
                                    $("#" + listType).html($("#" + listType).html() + "<option value='" + rowData.empId + "'>" + rowData.empName + "</option>");
                                } else {
                                    $("#" + listType).html($("#" + listType).html() + "<option value='" + rowData.projectID + "'>" + rowData.projectName + "</option>");
                                }

                            }
                        } else {
                            $("#" + listType).attr("disabled", "disabled");
                            $("#" + listType).html("<option>لايوجد</option>");
                        }
                    }
                });
            }
            
            function submit() {
                if (!validateData("req", document.FINANCIAL_DOC_FORM.documentNumber, "من فضلك ادخل رقم المستند...")) {
                    $("#documentNumber").focus();
                } else if (!validateData("req", document.FINANCIAL_DOC_FORM.documentTitle, "من فضلك ادخل اسم المستند  ..")) {
                    $("#documentTitle").focus();
                } else if (!validateData("req", document.FINANCIAL_DOC_FORM.docValue, "من فضلك ادخل القيمة  ..")) {
                    $("#transValue").focus();
                } else {
                    document.FINANCIAL_DOC_FORM.action = "<%=context%>/FinancialServlet?op=saveFinDocument&documentNumber=" + $("#documentNumber").val() + "&documentDate=" + $("#documentDate").val() + "&documentTitle=" + $("#documentTitle").val() + "&source=" + $("#source").val() + "&destination=" + $("#destination").val() + "&docValue=" + $("#docValue").val() + "&DocType=" + $("#DocType").val() + "&notes=" + $("#notes").val();
                    document.FINANCIAL_DOC_FORM.submit();
                }
            }
        </script>
    </head>

    <body>
        <fieldset class="set" style="width:90%;border-color: #006699">
            <div align="left" style="color:blue; margin-left: 2.5%">
                <button type="button" onclick="JavaScript: submit()" style="float: left; margin-right: 10px; margin-bottom: 5px; width: 200px; height: 30px; font-size: 16px">حفظ&ensp;<img src="images/icons/accept.png" alt="" height="18" width="18"/></button>
            </div>

            <br/>
            <table align="center" width="90%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td class="titlebar" style="text-align: center">
                        <font color="#005599" size="4">وثيقة مالية جديدة</font>&nbsp;<img width="40" height="40" src="images/finical-rebort.png" style="vertical-align: middle;"/> 
                    </td>
                </tr>
            </table>

            <br>

            <form name="FINANCIAL_DOC_FORM" method="post">
                <%if (status != null && status.equals("ok")) {%>
                <br>
                <table align="center" dir="ltr" WIDTH="90%">
                    <tr>
                        <td class="backgroundHeader">
                            <font size="3" color="blue">تم الحفظ بنجاح</font>
                        </td>
                    </tr>
                </table>
                <%} else if (status != null && status.equals("no")) {%>
                <table align="center" dir="ltr" WIDTH="90%">
                    <tr>
                        <td class="backgroundHeader">
                            <font size="3" color="red">لم يتم الحفظ بنجاح</font>
                        </td>
                    </tr>
                </table>
                <%}%>

                <table dir="RTL" cellpadding="0" cellspacing="0" style="border-width: 0">
                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>رقم المستند</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: right;">
                                <input id="documentNumber" name="documentNumber" type="number" style="width: 150px;height: 30px" />                 
                            </div>  
                        </td>  
                    </tr>

                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>عنوان المستند</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td" colspan="3">
                            <div style="text-align: right;float: right;">
                                <input id="documentTitle" name="documentTitle" type="text" style="width: 450px;height: 30px" />                 
                            </div>  
                        </td>  
                    </tr>

                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>تاريخ الاستحقاق</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: right;">
                                <input id="documentDate" readonly name="documentDate" type="text" style="width: 150px;height: 30px" value="<%=now%>" /> 
                            </div>  
                        </td>  
                    </tr>

                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>نوع المستند المالي</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: right;">
                                <select style="width: 150px;height:30px; font-weight: bold; font-size: 13px" id="DocType" name="DocType">
                                    <option value="شيك">شيك</option>
                                    <option value="ايصال امانة">ايصال امانة</option>
                                    <option value="كمبيالة">كمبيالة</option>
                                </select>
                            </div>  
                        </td>

                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>المبلغ المستحق</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: right;">
                                <input id="docValue" name="docValue" type="number" style="width: 150px;height: 30px" />                
                            </div>  
                        </td>  
                    </tr>

                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>المصدر</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: right;">
                                <select style="width: 150px;height: 30px; font-weight: bold; font-size: 13px;" id="sourceKind" name="sourceKind" onchange="getSourceList(this, 'source')">
                                    <option></option>
                                    <sw:WBOOptionList displayAttribute="arDesc" valueAttribute="typeCode" wboList="<%=sourceDestinationLst%>"/>
                                </select>  
                            </div>  
                        </td>  

                        <td class="td" colspan="2">
                            <div style="text-align: right;float: right;">
                                <select style="width: 322px;height: 30px; font-weight: bold; font-size: 13px;" id="source" name="source">
                                    <option></option>
                                </select>
                            </div>  
                        </td>  
                    </tr>
                    
                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>مورد الى</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: right;">
                                <select style="width: 150px;height: 30px; font-weight: bold; font-size: 13px;" id="destinationKind" name="destinationKind" onchange="getSourceList(this, 'destination')">
                                    <option></option>
                                    <sw:WBOOptionList displayAttribute="arDesc" valueAttribute="typeCode" wboList="<%=sourceDestinationLst%>"/>
                                </select>  
                            </div>  
                        </td>  

                        <td class="td" colspan="2">
                            <div style="text-align: right;float: right;">
                                <select style="width: 322px;height: 30px; font-weight: bold; font-size: 13px;" id="destination" name="destination">
                                </select>
                            </div>  
                        </td>  
                    </tr>
                    
                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>ملاحظات</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td" colspan="3">
                            <textarea id="notes" name="notes" style="width: 477px;" rows="2"></textarea>
                        </td>  
                        <td class="td">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </form>
        </fieldset>
    </body>
</html>
