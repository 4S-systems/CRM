<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.international.TouristGuide"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    //String status = (String) request.getAttribute("Status");
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    Calendar calendar = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String now = sdf.format(calendar.getTime());

    WebBusinessObject project = (WebBusinessObject) request.getAttribute("project");

    String projectId = request.getAttribute("projectId").toString();
    String projectIdChain = request.getAttribute("projectIdChain").toString();
    String projectRank = request.getAttribute("projectRank").toString();
    String projectType = request.getAttribute("projectType").toString();
    String creationType = request.getAttribute("creationType").toString();

    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode, tit, save, cancel;

    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   عربي    ";
        langCode = "Ar";
        tit = "New Account";
        save = "Save";
        cancel = "Back To List";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        tit = "حساب جديد";
        save = "حفظ ";
        cancel = " عودة";
    }

    String doubleName = (String) request.getAttribute("name");
    String type = "";
    try {
        type = request.getAttribute("type").toString();
    } catch (Exception ex) {
    }

%>

<html>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>New Account</TITLE>
        <link rel="stylesheet" type="text/css" href="css/CSS.css" />
        <link rel="stylesheet" type="text/css" href="css/Button.css" />
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">

        <script src='js/jsiframe.js' type='text/javascript'></script>
        <script src='js/silkworm_validate.js' type='text/javascript'></script>
        <script src='js/validator.js' type='text/javascript'></script>
        <script src="treemenu/script/jquery-1.2.6.min.js" type="text/javascript"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/custom_popup/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function () {
                $("#deliveryDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd",
                    buttonImageOnly: true,
                    buttonText: "Select date"
                });
            });

            function cancelForm()
            {
                document.ACCOUNT_FORM.action = "<%=context%>/ProjectServlet?op=ListProjects";
                document.ACCOUNT_FORM.submit();
            }

            function submitForm()
            {
                if (!validateData("req", document.ACCOUNT_FORM.accountName, "من فضلك ادخل اسم الحساب...")) {
                    $("#accountName").focus();
                
                } else if (!validateData("req", document.ACCOUNT_FORM.debit, "من فضلك ادخل الرصيد الافتتاحي مدين  ..")) {
                    $("#debit").focus();
                } else if (!validateData("req", document.ACCOUNT_FORM.creditor, "من فضلك ادخل الرصيد الافتتاحي دائن  ..")) {
                    $("#creditor").focus();
                } else {
                    var accountName = $("#accountName").val();
                    var finalDestination = $("#finalDestination").val();
                    var accountType = $("#accountType").val();
                    var costCenter = $("#costCenter").val();
                    var accountCurency = $("#accountCurency").val();
                    var projectIdChain = $("#projectIdChain").val();
                    var projectRank = $("#projectRank").val();
                    var projectType = $("#projectType").val();
                    var projectId = $("#projectId").val();
                    var creationType = $("#creationType").val();
                    var deliveryDate = $("#deliveryDate").val();
                    var debit = $("#debit").val();
                    var creditor = $("#creditor").val();
                    var eqNO = $("#eqNO").val();
                    var accountCode=$("#accountCode").val();
                    
                    //alert(debit);
                    //alert(creditor);

                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ProjectServlet?op=saveNewAccount",
                        data: {
                            projectId: projectId,
                            projectIdChain: projectIdChain,
                            projectRank: projectRank,
                            projectType: projectType,
                            accountName: accountName,
                            finalDestination: finalDestination,
                            accountType: accountType,
                            costCenter: costCenter,
                            accountCurency: accountCurency,
                            creationType: creationType,
                            deliveryDate: deliveryDate,
                            debit: debit,
                            creditor: creditor,
                            eqNO: eqNO,
                            accountCode:accountCode
                        },
                        success: function (msg) {
                            alert("تم الحفظ بنجاح");
                            parent.location.reload();
                        }
                    });
                }
            }


        </SCRIPT>
        
                <style>
            .ui-datepicker {
                width: 180px;
                font-size: small;
            }
        </style>
    </HEAD>

    <body>
        <DIV align="left" STYLE="color:blue;">
            <button onclick="cancelForm()"  hidden class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
            <button onclick="submitForm()" class="button"><%=save%>    <IMG SRC="images/save.gif"></button>
        </DIV> 

        <br/>

        <fieldset class="set" style="border-color: #006699; width: 99%">
            <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <TR>
                    <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"> <%=tit%> </FONT><BR></TD>
                </TR>
            </TABLE>

            <FORM NAME="ACCOUNT_FORM"  id="updateForm" METHOD="POST">
                <br/>

                <input type="hidden" value="<%=projectId%>" id="projectId"/>
                <input type="hidden" value="<%=projectIdChain%>" id="projectIdChain"/>
                <input type="hidden" value="<%=projectRank%>" id="projectRank"/>
                <input type="hidden" value="<%=projectType%>" id="projectType"/>
                <input type="hidden" value="<%=creationType%>" id="creationType"/>
                <select hidden="true" name="accountType" id="accountType" style="width: 150px;height: 30px">
                    <option value="1">مديـــــــن </option>
                    <option value="2">دائــــــــــن</option>
                </select>  
                <select  hidden="true" name="finalDestination" id="finalDestination" style="width: 150px;height: 30px">
                    <option value="1">الميزانية</option>
                    <option value="2">قائمة الدخل</option>
                    <option value="3">أخرى</option>
                </select>
                  <select hidden="true" name="accountCurency" id="accountCurency" style="width: 150px;height: 30px">
                    <option value="1">ريال سعودي</option>
                    <option value="2">دولار أمريكي</option>
                </select>
                 <select hidden="true" name="costCenter" id="costCenter" style="width: 150px;height: 30px">
                    <option value="1">غير مرتبط مع مراكز التكلفة</option>
                    <option value="2">يحتمل إدخال مركز تكلفــــة</option>
                    <option value="3">يجب إدخال مركز تكلفة مع الحساب</option>
                </select> 
                     <input hidden="true"  id="deliveryDate" readonly name="deliveryDate" type="text" style="width: 150px;" value="<%=now%>" />
                          <input  hidden="true" id="debit" name="debit" type="number" value="0" style="width: 110px;height: 30px" />                
                 <input hidden="true" id="creditor" name="creditor" type="number" style="width: 110px;height: 30px"  value="0" />                

              
                <table    style=" width:100%; border-width: 0;direction: <%=dir%>">
                    <tr style="direction: <%=dir%>">
                        <td class="td" style="direction: <%=dir%>">
                            <div style="text-align:center;width: 160px; display: inline-block" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>اسم الحساب</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td" colspan="1">
                            <div style="text-align: right;">
                                <input type="TEXT" name="accountName" dir="<%=dir%>" ID="accountName" size="19" value="<%=project.getAttribute("projectName") + " - "%>" maxlength="255" style="height: 30px">
                                <input type="hidden" name="eqNO" ID="eqNO" value="<%=project.getAttribute("eqNO")%>"/>
                            </div>
                        </td>
                        
                         
                    </tr>
                    <tr style="direction: <%=dir%>">
                         <td class="td" style="direction: <%=dir%>">
                            <div style="text-align:center;width: 160px; display: inline-block" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b> كود الحساب</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td" colspan="3">
                            <div style="text-align: right;">
                                <input type="TEXT" name="accountCode" dir="<%=dir%>" ID="accountCode" size="19" value="" maxlength="255" style="height: 30px">
                                <!--<input type="hidden" name="eqNO" ID="eqNO" value="<%=project.getAttribute("eqNO")%>"/>-->
                            </div>
                        </td>
                    </tr>
<!--
                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;m" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>نوع الحساب</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: left;margin-left: 24.5px">
                                <select name="accountType" id="accountType" style="width: 150px;height: 30px">
                                    <option value="1">مديـــــــن </option>
                                    <option value="2">دائــــــــــن</option>
                                </select>              
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>الترحيل النهائي إلى</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: left;margin-left: 24.5px">
                                <select name="finalDestination" id="finalDestination" style="width: 150px;height: 30px">
                                    <option value="1">الميزانية</option>
                                    <option value="2">قائمة الدخل</option>
                                    <option value="3">أخرى</option>
                                </select>              
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>عملة الحساب</b></p>
                                </LABEL>
                            </div>
                        </td>
                        <td class="td">
                            <div style="text-align: right;float: left;margin-left: 24.5px">
                                <select name="accountCurency" id="accountCurency" style="width: 150px;height: 30px">
                                    <option value="1">ريال سعودي</option>
                                    <option value="2">دولار أمريكي</option>
                                </select>              
                            </div>
                        </td>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>الارتباط مع مراكز التكلفة</b></p>
                                </LABEL>
                            </div>
                        </td>
                        <td class="td">
                            <div style="text-align: right;float: left;margin-left: 24.5px">
                                <select name="costCenter" id="costCenter" style="width: 150px;height: 30px">
                                    <option value="1">غير مرتبط مع مراكز التكلفة</option>
                                    <option value="2">يحتمل إدخال مركز تكلفــــة</option>
                                    <option value="3">يجب إدخال مركز تكلفة مع الحساب</option>
                                </select>              
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>تاريخ انشاء الحساب</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: left;margin-left: 24.5px">
                                <input id="deliveryDate" readonly name="deliveryDate" type="text" style="width: 150px;" value="<%=now%>" />
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td class="td">
                            <div style="text-align:center;width: 160px; display: inline-block;" class="selver2">
                                <LABEL FOR="str_EQ_NO">
                                    <p style="margin-top: 5px"><b>رصيد افتتاحي بعملة الحساب</b></p>
                                </LABEL>
                            </div>
                        </td>

                        <td class="td">
                            <div style="text-align: right;float: right;margin-left: 24.5px">
                                <font color="blue" size="4" ><b>مدين/</b></font>
                                <input id="debit" name="debit" type="number" style="width: 110px;height: 30px" />                
                            </div>
                        </td>

                        <td class="td" colspan="2">
                            <div style="text-align: right;float: right;margin-left: 24.5px">
                                <font color="blue" size="4" ><b>دائن/</b></font>
                                <input id="creditor" name="creditor" type="number" style="width: 110px;height: 30px" />                
                            </div>
                        </td>
                    </tr> -->  
                </table>
            </FORM>
        </fieldset>
    </body>
</html>