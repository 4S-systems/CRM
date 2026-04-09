<%-- 
    Document   : new_expense_item
    Created on : Apr 26, 2018, 10:02:54 AM
    Author     : fatma
--%>

<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.financials.db_access.ExpenseItemRelativeMgr"%>
<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    List units = request.getAttribute("units") != null ? (List) request.getAttribute("units") : null;
    String stat = (String) request.getSession().getAttribute("currentMode");
    String status = request.getAttribute("status") != null ? (String) request.getAttribute("status") : "";
    
    String fStatus, sStatus, align, dir, style, Ar_Name, EN_Name, code, trans_type, indrive_calc, lang, langCode, save, back, accountType,
            measure_unit, unit_price, driver_transaction, journey_transaction, client_transaction, agent_transaction, title, factorType,
            debit, credit, mandatory, optional, sMaintenance, sOthers, select, calc_type, percent, value, item_type, sPercentage,
            sDebit,sCredit,sRentalCar,sPocketMoney, sFuel, sTrip, salaryStr;
    
    if (stat.equals("En")) {
        align = "left";
        dir = "LTR";
        style = "style=\"text-align:left\"";
        
        lang = " العربية ";
        langCode = "Ar";
        
        Ar_Name = " Arabic Name ";
        EN_Name = " English Name ";
        save = " Save ";
        accountType = " Account Type ";
        back = " Cancel ";
        code = " Code ";
        trans_type = " Transaction Type ";
        indrive_calc = " In-Drive Calculations ";
        sStatus = " Expense Item Saved Successfully ";
        fStatus = " Fail To Save This Expense Item ";
        measure_unit = " Calculation Period ";
        unit_price = " Unit Price ";
        driver_transaction = " Driver ";
        journey_transaction = " Trip ";
        client_transaction = " Client ";
        agent_transaction = " Agent ";
        title = " salary slips ";
        factorType = " Add Transaction ";
        debit = " Debit ";
        credit = " Credit ";
        mandatory = " Mandatory ";
        optional = " Optional ";
        sMaintenance = " Maintenance ";
        sOthers = " Others ";
        select = " Select ";
        calc_type = " Calculator Type ";
        percent = " Percent ";
        value = " Value ";
        item_type = " Item Type ";
        sPercentage = " Percentage ";
        sDebit = " Debit ";
        sCredit = " Credit ";
        sRentalCar = " Rental Car ";
        sPocketMoney = " Pocket money ";
        sFuel = " Fuel ";
        sTrip = " Trip ";
        salaryStr = " Salary ";
    } else {
        align = "right";
        dir = "RTL";
        style = "style=\"text-align:Right\"";
        
        lang = "English";
        langCode = "En";
        
        Ar_Name = "الاسم العربى";
        EN_Name = "الاسم الانجليزى";
        accountType = "طبيعة الحساب";
        back = " Cancel ";
        code = "الكود";
        save = " تسجيل ";
        trans_type = "نوع المعاملة";
        indrive_calc = "مصاريف";
        fStatus = " لم يتم التسجيل ";
        sStatus = " تم التسجيل بنجاح ";
        measure_unit = "فترة الحساب";
        unit_price = "سعر الوحده";
        client_transaction = "العميل";
        journey_transaction = "الرحله" ;
        driver_transaction = "السائق" ;
        agent_transaction = "المتعهد";
        title=" مفردات المرتب";
        factorType = "اضافة معامله";
        debit="مدين";
        credit="دائن";
        mandatory="إلزامي";
        optional="أختياري";
        sMaintenance="صيانة";
        sOthers="أخرى";
        select="أختر";
        calc_type="طريقة الحساب";
        percent="نسبة";
        value="قيمة";
        item_type="نوع البند";
        sPercentage="النسبة";
        sDebit="مدين";
        sCredit="دائن";
        sRentalCar="إيجار سيارة";
        sPocketMoney="مصروف";
        sFuel = "وقود";
        sTrip = "رحلة";
        salaryStr = " مفردات مرتب ";
    }
    
    LiteWebBusinessObject costItemWbo = (LiteWebBusinessObject) request.getAttribute("costItemWbo");
%>
    
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title> New Expense Item </title>
    
        <script src="js/SpryValidationTextField.js" type="text/javascript"></script>
        <script src="js/SpryValidationTextarea.js" type="text/javascript"></script>    
        <script src="js/SpryValidationSelect.js" type="text/javascript"></script>

        <link href="css/SpryValidationTextField.css" rel="stylesheet" type="text/css" />
        <link href="css/SpryValidationTextarea.css" rel="stylesheet" type="text/css" />
        <link href="css/SpryValidationSelect.css" rel="stylesheet" type="text/css" />

        <script>
            function submitForm(){
                if (!validateData("req", this.cost_item_form.code, "Please enter code") || !validateData("alphanumeric", this.cost_item_form.code, "Please enter a valid alphanumeric code")) {
                    this.cost_item_form.code.focus();
                } else if (!validateData("req", this.cost_item_form.Ar_Name, "Please enter arabic name") || !validateData("minlength=3", this.cost_item_form.Ar_Name, "Please enter a valid arabic name more than 3 characters")) {
                    this.cost_item_form.arName.focus();
                } else if (!validateData("req", this.cost_item_form.EN_Name, "Please enter english name") || !validateData("minlength=3", this.cost_item_form.EN_Name, "Please enter a valid english name more than 3 characters")) {
                    this.cost_item_form.enName.focus();
                    //} else if(document.getElementById('driver').value =="-1" && document.getElementById('journey').value =="-1" 
                    //    && document.getElementById('client').value =="-1" && document.getElementById('agent').value =="-1" ){
                    //    alert("Select one factor at least.");
                    //   this.cost_item_form.driver.focus();
                } else {
                    document.cost_item_form.action = "<%=context%>/FinancialServlet?op=saveExpenseItem";
                    document.cost_item_form.submit();
                }
            }

            function checklang(lang) {
                var ar = document.getElementById('AR_Name').value;
                var en = document.getElementById('EN_Name').value;
                var arflag = false;
                var enflag = false;

                for (x = 0; x < 3; x++)
                    if (ar.charCodeAt(x) < 1523 && ar.charCodeAt(x) != 32)
                        arflag = true;
                for (x = 0; x < en.length; x++)
                    if (en.charCodeAt(x) > 1523)
                        enflag = true;

                if (arflag && lang == "ar") {
                    alert("يجب ان تدخل القيمة باللغة العربية")
                    document.getElementById('AR_Name').value = "";
                    document.getElementById('AR_Name').focus();
                }

                if (enflag && lang == "en") {
                    alert("يجب ان تدخل القيمة باللغة الانجليزية");
                    document.getElementById('EN_Name').value = "";
                    document.getElementById('EN_Name').focus();
                }
                return true;
            }

            function test(obj) {
                if ($("#measure_unit").val() == "##") {
                    $("#unit_price").attr("disabled", true);
                } else {
                    $("#unit_price").attr("disabled", false);
                }
            }

            function getValue(str) {
                if (document.getElementById(str).value != "-1") {
                    document.getElementById(str + "P").value = "100";
                }
            }

            function getNum(crt) {
                if (!IsNumeric(crt.value)) {
                    alert("put numeric letter.");
                    crt.value = "";
                    crt.focus();
                }
            }
        </script>
    </head>
    
    <body>
        <form id="cost_item_form" name="cost_item_form" method="post" >
            <%
                if(costItemWbo!=null && !costItemWbo.equals("")){
            %>
                    <input type="hidden" name="costItemId" id="costItemId" value="<%=costItemWbo.getAttribute("id") != null ? costItemWbo.getAttribute("id").toString() : ""%>" />
            <%
                }
            %>
            
            <fieldset class="set" align="center" style="width: 90%; margin: auto; padding: auto;">
                <legend>
                    <font SIZE="+1">
                         <%=title%> 
                    </font>
                </legend>
                            
                <%
                    if (null != status) {
                        if (status.equalsIgnoreCase("Success")) {
                %>  
                            <table style="width: 50%;margin: auto auto;" >
                                <tr>                    
                                    <td class="td" style="text-align: center">
                                        <font size=4 color="black">
                                             <%=sStatus%> 
                                        </font> 
                                    </td>                    
                                </tr>
                            </table>
                <%
                    } else if (status.equalsIgnoreCase("Fail")) {
                %>
                        <table style="width: 50%;margin: auto;" >
                            <tr>                    
                                <td class="td" style="text-align: center">
                                    <font size=4 color="red" >
                                         <%=fStatus%> 
                                    </font> 
                                </td>                    
                            </tr>
                        </table>
                <%
                        }
                    }
                %>

                <table  border="0" ALIGN="center" style="margin: auto; padding: auto;">
                    <tr>
                        <td style="vertical-align: top;">
                            <TABLE style="width: 500px;"  ALIGN="center" DIR="<%=dir%>">
                                <tr>
                                    <td CLASS="silver_odd_main" style="border: none;text-align: center;width: 30%;">
                                         <%=code%> 
                                    </td>

                                    <td style="border: none" <%=style%> align="<%=align%>">
                                        <span id="sprytextfield1" dir="<%=dir%>">
                                            <label for="code"></label>

                                            <% 
                                                if(costItemWbo!=null && !costItemWbo.equals("")){
                                            %> 
                                                    <input type="text" name="code" id="code" value="<%=costItemWbo.getAttribute("code") != null ? costItemWbo.getAttribute("code") : ""%>" style="width: 180px;"/>
                                            <%
                                                }else{
                                            %>
                                                    <input type="text" name="code" id="code" style="width: 180px;"/>
                                            <%
                                                }
                                            %>

                                            <span class="textfieldRequiredMsg" >
                                                <div id="ars">
                                                     A value is required. 
                                                </div>
                                            </span>

                                            <span class="textfieldInvalidFormatMsg">
                                                Invalid format.
                                            </span>

                                            <span class="textfieldMaxValueMsg">
                                                The entered value is greater than the maximum allowed.
                                            </span>
                                        </span>
                                    </td>
                                </tr>

                                <tr>
                                    <td  CLASS="silver_odd_main" style="border: none;text-align: center;width: 30%;">
                                         <%=Ar_Name%> 
                                    </td>

                                    <td style="border: none"<%=style%> align="<%=align%>">
                                        <span id="sprytextfield1" dir="<%=dir%>">
                                            <label for="arName"></label>

                                            <%
                                                if(costItemWbo!=null && !costItemWbo.equals("")){
                                            %> 
                                                    <input readonly type="text" name="Ar_Name" id="Ar_Name" onblur="checklang('ar');" value="<%=costItemWbo.getAttribute("arName") != null ? costItemWbo.getAttribute("arName") : ""%>" style="width: 180px;"/>
                                            <%
                                                }else{
                                            %>
                                                    <input type="text" name="Ar_Name" id="Ar_Name" onblur="checklang('ar');" style="width: 180px;"/>
                                            <%
                                                }
                                            %>

                                            <span class="textfieldRequiredMsg" >
                                                <div id="ars">
                                                    A value is required.
                                                </div>
                                            </span>

                                            <span class="textfieldInvalidFormatMsg">
                                                Invalid format.
                                            </span>

                                            <span class="textfieldMaxValueMsg">
                                                The entered value is greater than the maximum allowed.
                                            </span>
                                        </span>
                                    </td>
                                </tr>

                                <tr>
                                    <td  CLASS="silver_odd_main" style="border: none;text-align: center;width: 30%;">
                                         <%=EN_Name%> 
                                    </td>

                                    <td  style="border: none" <%=style%>  align="<%=align%>">
                                        <span id="sprytextfield2" dir="<%=dir%>">
                                            <label for="enName"></label>

                                            <%
                                                if(costItemWbo!=null && !costItemWbo.equals("")){
                                            %>
                                                    <input type="text" name="EN_Name" id="EN_Name" onblur="checklang('en');" value="<%=costItemWbo.getAttribute("enName") != null ? costItemWbo.getAttribute("enName") : ""%>" style="width: 180px;"/>
                                            <%
                                                }else{
                                            %>
                                                    <input type="text" name="EN_Name" id="EN_Name" onblur="checklang('en');" style="width: 180px;"/>
                                            <%
                                                }
                                            %>

                                            <span class="textfieldRequiredMsg" id="ens">
                                                A value is required.
                                            </span>

                                            <span class="textfieldInvalidFormatMsg">
                                                Invalid format.
                                            </span>

                                            <span class="textfieldMaxValueMsg">
                                                The entered value is greater than the maximum allowed.
                                            </span>
                                        </span> 
                                    </td>
                                </tr>

                                <tr>
                                    <td CLASS="silver_odd_main" style="border: none;text-align: center;width: 30%;"><%=trans_type%></td>
                                    <td style="border: none"<%=style%> align="<%=align%>">
                                        <span id="spryselect1">
                                            <label for="trans_type"></label>
                                            <select id="trans_type" name="trans_type" size="1" style="font-size: 15px;font-weight: bold; width: 180px;">
                                                <option value="Debit"><%=debit%></option>
                                                <option value="Credit"><%=credit%></option>
                                            </select>
                                            <span class="selectRequiredMsg">Please select an item.</span>
                                        </span>
                                    </td>
                                </tr>

                                <tr>
                                    <td  CLASS="silver_odd_main" style="border: none;text-align: center;width: 30%;">
                                         <%=calc_type%> 
                                    </td>

                                    <td style="border: none; <%=style%>;" align="<%=align%>">
                                        <span id="sprytextfield1" dir="<%=dir%>">
                                            <span id="spryselect1">
                                                <label for="trans_type"></label>

                                                <select id="calc_type" name="calc_type" size="1" style="font-size: 15px;font-weight: bold; width: 180px;">
                                                    <option value="0" <%if(costItemWbo!=null &&!costItemWbo.equals("") && costItemWbo.getAttribute("calcType").toString().equals("0")){%>selected<%}%>><%=percent%></option>
                                                    <option value="1" <%if(costItemWbo!=null &&!costItemWbo.equals("") && costItemWbo.getAttribute("calcType").toString().equals("1")){%>selected<%}%>><%=value%></option>
                                                </select>

                                                <span class="selectRequiredMsg">
                                                     Please select an item. 
                                                </span>
                                            </span>
                                        </td>
                                </tr>

            <!--                <tr>
                                    <td width="400" <%=style%> align="<%=align%>"><span id="sprytextfield1" dir="<%=dir%>">
                                        <span id="spryselect1">
                                            <label for="indrive_calc"></label>
                                            <select id="indrive_calc" name="indrive_calc" size="1">
                                                <option value="Yes">Yes</option>
                                                <option value="No">No</option>
                                            </select>
                                            <span class="selectRequiredMsg">Please select an item.</span></span></td>
                                    <td width="220" class="excelentCell"><%=indrive_calc%></td>
                                </tr>-->

                                <tr>
                                    <td  CLASS="silver_odd_main" style="border: none;text-align: center;width: 30%;">
                                         <%=measure_unit%> 
                                    </td>

                                    <td style="border: none" <%=style%> align="<%=align%>">
                                        <span id="sprytextfield1" dir="<%=dir%>">
                                            <span id="spryselect1">
                                                <label for="measure_unit"></label>

                                                <select id="measure_unit" name="measure_unit" size="1"  onselect="test(this)" style="font-size: 15px;font-weight: bold; width: 180px;">
                                                    <option value="">---</option>
                                                    <%
                                                        if (costItemWbo!=null && costItemWbo.getAttribute("measureUnit")!=null && !costItemWbo.getAttribute("measureUnit").equals("")) {
                                                            for (int i = 0; i < units.size(); i++) {
                                                                LiteWebBusinessObject wbo = (LiteWebBusinessObject) units.get(i);
                                                    %>
                                                                <option value="<%=wbo.getAttribute("ID")%>" <%if(costItemWbo!=null &&!costItemWbo.equals("") && costItemWbo.getAttribute("measureUnit").toString().equals(wbo.getAttribute("ID").toString())){%>selected<%}%>>
                                                                     <%=wbo.getAttribute("arDesc")%> 
                                                                </option>
                                                    <%
                                                            }
                                                        }else{
                                                            for (int i = 0; i < units.size(); i++) {
                                                                LiteWebBusinessObject wbo = (LiteWebBusinessObject) units.get(i);
                                                    %>
                                                                <option value="<%=wbo.getAttribute("ID")%>">
                                                                     <%=wbo.getAttribute("arDesc")%> 
                                                                </option>
                                                    <%
                                                            }
                                                        }
                                                    %>
                                                </select>

                                                <span class="selectRequiredMsg">
                                                     Please select an item. 
                                                </span>
                                            </span>
                                        </span>
                                    </td>
                                </tr>

                                <input type="hidden" name="unit_price" id="unit_price" value="0"/>

                                <!--tr>
                                    <td style="border: none" <%=style%> align="<%=align%>"><span id="sprytextfield1" dir="<%=dir%>">
                                            <label for="unit_price"></label>
                                            <input type="text" name="unit_price" id="unit_price"/>
                                            <span class="textfieldRequiredMsg" ><div id="ars">A value is required.</div></span><span class="textfieldInvalidFormatMsg">Invalid format.</span><span class="textfieldMaxValueMsg">The entered value is greater than the maximum allowed.</span></span>
                                    </td>
                                    <td  CLASS="silver_odd_main" style="border: none;text-align: center;width: 30%;"><%=unit_price%></td>
                                </tr-->

                                <tr>
                                    <td  CLASS="silver_odd_main" style="border: none;text-align: center;width: 30%;"><%=accountType%></td>
                                    <td style="border: none"<%=style%> align="<%=align%>">
                                        <span id="spryselect1">
                                            <label for="trans_type"></label>
                                            <select id="accountType" name="accountType" size="1" style="font-size: 15px;font-weight: bold; width: 180px;">
                                                <option value="optional"><%=optional%></option>
                                                <option value="mandatory"><%=mandatory%></option>
                                            </select>
                                            <span class="selectRequiredMsg">Please select an item.</span>
                                        </span>
                                    </td>
                                </tr> 

                                <tr>
                                    <td  CLASS="silver_odd_main" style="border: none;text-align: center;width: 30%;">
                                         <%=item_type%> 
                                    </td>

                                    <td style="border: none"<%=style%> align="<%=align%>"><span id="sprytextfield1" dir="<%=dir%>">
                                        <span id="spryselect1">
                                            <label for="trans_type"></label>

                                            <select id="itemType" name="itemType" size="1" style="font-size: 15px;font-weight: bold; width: 180px;">
                                                <option value="Salary" <%=costItemWbo!=null && "Salary".equals(costItemWbo.getAttribute("expenseItemType"))? "selected" : ""%>><%=salaryStr%></option>
                                            </select>

                                            <span class="selectRequiredMsg">
                                                 Please select an item. 
                                            </span>
                                        </span>
                                    </td>
                                </tr>
                            </table>
                        </td>
                        
                        <td style="vertical-align: top; display: none;">
                            <TABLE id="Others"  DIR="<%=dir%>" style="top: inherit;">
                                <TR>
                                    <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;" colspan="8" class="blueBorder blueHeaderTD">
                                        <font color="#F3D596" size="4">
                                             <%=factorType%>
                                        </font>
                                    </TD>
                                </TR>
                                
                                <%  
                                    ExpenseItemRelativeMgr expenseItemRelativeMgr = ExpenseItemRelativeMgr.getInstance();
                                    LiteWebBusinessObject dWbo=null,jWbo=null,cWbo=null,aWbo = null;
                                    Vector fDriverOfCostItemV= new Vector(),fJourneyOfCostItemV= new Vector(),fClientOfCostItemV = new Vector(),fAgentOfCostItemV = new Vector();
                                    if(costItemWbo!=null && !costItemWbo.equals("")){
                                        fDriverOfCostItemV = expenseItemRelativeMgr.getOnArbitraryDoubleKey(costItemWbo.getAttribute("id").toString(), "key1","driver","key2");
                                        fJourneyOfCostItemV = expenseItemRelativeMgr.getOnArbitraryDoubleKey(costItemWbo.getAttribute("id").toString(), "key1","journey","key2");
                                        fClientOfCostItemV = expenseItemRelativeMgr.getOnArbitraryDoubleKey(costItemWbo.getAttribute("id").toString(), "key1","client","key2"); 
                                        fAgentOfCostItemV = expenseItemRelativeMgr.getOnArbitraryDoubleKey(costItemWbo.getAttribute("id").toString(), "key1","agent","key2"); 
                                    }
                                    
                                    if(fDriverOfCostItemV!=null && fDriverOfCostItemV.size()>0){
                                        dWbo = (LiteWebBusinessObject) fDriverOfCostItemV.get(0);
                                    }
                                    
                                    if(fJourneyOfCostItemV!=null && fJourneyOfCostItemV.size()>0){
                                        jWbo = (LiteWebBusinessObject) fJourneyOfCostItemV.get(0);
                                    }
                                    
                                    if(fClientOfCostItemV!=null && fClientOfCostItemV.size()>0){
                                        cWbo = (LiteWebBusinessObject) fClientOfCostItemV.get(0);
                                    }
                                    
                                    if(fAgentOfCostItemV!=null && fAgentOfCostItemV.size()>0){
                                        aWbo = (LiteWebBusinessObject) fAgentOfCostItemV.get(0);
                                    }
                                %>
                                
                                <tr>
                                    <TD nowrap class="silver_odd_main" STYLE="border: none;text-align: center;" WIDTH="10%">
                                         <%=driver_transaction%> 
                                    </TD>
                                    
                                    <TD nowrap style="<%=style%>;height: 40px;"  WIDTH="10%">
                                        <select style="width:120px;font-size: 15px;font-weight: bold;"id="driver" name="driver" onchange="getValue('driver');">
                                            <option value="-1"><%=select%></option>
                                            <option value="Debit" <%if (dWbo!=null && dWbo.getAttribute("acountMood").toString().equals("Debit")){%>selected<%}%>><%=sDebit%></option>
                                            <option value="Credit" <%if (dWbo!=null && dWbo.getAttribute("acountMood").toString().equals("Credit")){%>selected<%}%>><%=sCredit%></option>
                                        </select>
                                    </TD>
                                    
                                    <TD nowrap class="silver_odd_main" STYLE="border: none;text-align: center;padding:5px; display: none;" WIDTH="10%">
                                         <%=sPercentage%> 
                                    </TD>
                                    
                                    <TD nowrap nowrap style="<%=style%>;height: 40px;width:50px; display: none;"  WIDTH="10%">
                                        <%
                                            if (dWbo!=null){
                                        %>
                                                <input type="hidden" id="driverP" name="driverP" value="<%=dWbo.getAttribute("percent").toString()%>" onblur="getNum(this);" size="6" maxlength="2" style="width: 50px;" />
                                                <input type="hidden" name="fDriverId" id="fDriverId" value="<%=dWbo.getAttribute("id").toString()%>"/>
                                        <%
                                            }else{
                                        %>
                                                <input type="hidden" id="driverP" name="driverP" value="0" onblur="getNum(this);" size="6" maxlength="2" style="width: 50px;" />
                                        <%
                                            }
                                        %>
                                    </TD>
                                </tr>
                                
                                <tr>
                                    <TD nowrap class="silver_odd_main" STYLE="border: none;text-align: center;padding:5px" WIDTH="10%">
                                         <%=journey_transaction%> 
                                    </TD>
                                    
                                    <TD nowrap style="<%=style%>;height: 40px;" >
                                        <select style="width:120px;font-size: 15px;font-weight: bold;"id="journey" name="journey" WIDTH="10%" onchange="getValue('journey');">
                                            <option value="-1"><%=select%></option>
                                            <option value="Debit" <%if (jWbo!=null && jWbo.getAttribute("acountMood").toString().equals("Debit")){%>selected<%}%>><%=sDebit%></option>
                                            <option value="Credit" <%if (jWbo!=null && jWbo.getAttribute("acountMood").toString().equals("Credit")){%>selected<%}%>><%=sCredit%></option>
                                        </select>
                                    </TD>
                                    
                                    <TD nowrap class="silver_odd_main" STYLE="border: none;text-align: center;padding:5px; display: none;" WIDTH="10%">
                                         <%=sPercentage%> 
                                    </TD>
                                    
                                    <TD nowrap style="<%=style%>;height: 40px;width:50px; display: none;">
                                        <%
                                            if (jWbo!=null){
                                        %>
                                                <input type="hidden" id="journeyP" name="journeyP" value="<%=jWbo.getAttribute("percent").toString()%>" onblur="getNum(this);" size="6" maxlength="2" style="width: 50px;" />
                                                <input type="hidden" name="fJourneyId" id="fDriverId" value="<%=jWbo.getAttribute("id").toString()%>"/>
                                        <%
                                            }else{
                                        %>
                                                <input type="hidden" id="journeyP" name="journeyP" value="0" onblur="getNum(this);" size="6" maxlength="2" style="width: 50px;" />
                                        <%
                                            }
                                        %>
                                    </TD>
                                </tr>

                                <tr>
                                    <TD nowrap class="silver_odd_main" STYLE="border: none;text-align: center;padding:5px" WIDTH="10%">
                                         <%=client_transaction%> 
                                    </TD>
                                    
                                    <TD nowrap style="<%=style%>;height: 40px;" >
                                        <select style="width:120px;font-size: 15px;font-weight: bold;"id="client" name="client" WIDTH="10%" onchange="getValue('client');">
                                            <option value="-1"><%=select%></option>
                                            <option value="Debit" <%if (cWbo!=null && cWbo.getAttribute("acountMood").toString().equals("Debit")){%>selected<%}%>><%=sDebit%></option>
                                            <option value="Credit" <%if (cWbo!=null && cWbo.getAttribute("acountMood").toString().equals("Credit")){%>selected<%}%>><%=sCredit%></option>
                                        </select>
                                    </TD>
                                    
                                    <TD nowrap class="silver_odd_main" STYLE="border: none;text-align: center;padding:5px; display: none;" WIDTH="10%">
                                         <%=sPercentage%> 
                                    </TD>
                                    
                                    <TD nowrap style="<%=style%>;height: 40px;width:50px; display: none;;" WIDTH="10%">
                                        <%
                                            if (cWbo!=null){
                                        %>
                                                <input type="hidden" id="clientP" name="clientP" value="<%=cWbo.getAttribute("percent").toString()%>" onblur="getNum(this);" size="6" maxlength="2" style="width: 50px;" />
                                                <input type="hidden" name="fClientId" id="fDriverId" value="<%=cWbo.getAttribute("id").toString()%>"/>
                                        <%
                                            }else{
                                        %>
                                                <input type="hidden" id="clientP" name="clientP" value="0" onblur="getNum(this);" size="6" maxlength="2" style="width: 50px;" />
                                        <%
                                            }
                                        %>
                                    </TD>
                                </tr>
                                
                                <tr>
                                    <TD nowrap class="silver_odd_main" STYLE="border: none;text-align: center;padding:5px" WIDTH="10%">
                                         <%=agent_transaction%> 
                                    </TD>
                                    
                                    <TD nowrap style="<%=style%>;height: 40px;"  WIDTH="10%">
                                        <select style="width:120px;font-size: 15px;font-weight: bold;"id="agent" name="agent" onchange="getValue('agent');">
                                            <option value="-1"><%=select%></option>
                                            <option value="Debit" <%if (aWbo!=null && aWbo.getAttribute("acountMood").toString().equals("Debit")){%>selected<%}%>><%=sDebit%></option>
                                            <option value="Credit" <%if (aWbo!=null && aWbo.getAttribute("acountMood").toString().equals("Credit")){%>selected<%}%>><%=sCredit%></option>
                                        </select>
                                    </TD>
                                    
                                    <TD nowrap class="silver_odd_main" STYLE="border: none;text-align: center;padding:5px; display: none;" WIDTH="10%">
                                         <%=sPercentage%> 
                                    </TD>
                                    
                                    <TD nowrap style="<%=style%>;height: 40px;width:50px; display: none;"  WIDTH="10%">
                                        <%
                                            if (aWbo!=null){
                                        %>
                                                <input type="hidden" id="agentP" name="agentP" value="<%=aWbo.getAttribute("percent").toString()%>" onblur="getNum(this);" size="6" maxlength="2" style="width: 50px;" />
                                                <input type="hidden" name="fAgentId" id="fDriverId" value="<%=aWbo.getAttribute("id").toString()%>"/>
                                        <%
                                            }else{
                                        %>
                                                <input type="hidden" id="agentP" name="agentP" value="0" onblur="getNum(this);" size="6" maxlength="2" style="width: 50px;" />
                                        <%
                                            }
                                        %>
                                    </TD>
                                </tr>
                                
                                <TR>
                                    <TD style="border: 0px;width: 30%;height: 10px;">
                                    </TD>
                                </TR>
                                
                                <TR >
                                    <TD style="border: 0px;width: 30%;">
                                    </TD>
                                </TR>
                                
                                <TR >
                                    <TD style="border: 0px;width: 30%;">
                                    </TD>
                                </TR>
                                
                                <TR >
                                    <TD style="border: 0px;width: 30%;">
                                    </TD>
                                </TR>
                                
                                <TR >
                                    <TD style="border: 0px;width: 30%;">
                                    </TD>
                                </TR>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <button type="button" align="center" onclick="submitForm();" class="button" style="width: 25%; margin: 2%;">
                                 <%=save%> 
                            </button>
                        </td>
                    </tr>
                </table>
            </fieldset> 
        </form>
    </body>
</html>