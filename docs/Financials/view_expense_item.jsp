<%-- 
    Document   : view_expense_item
    Created on : Apr 29, 2018, 11:32:37 AM
    Author     : fatma
--%>

<%@page import="java.util.ArrayList"%>
<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page import="com.financials.db_access.ExpenseItemRelativeMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.international.TouristGuide"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        List units = request.getAttribute("units") != null ? (List) request.getAttribute("units") : null;
        String status = request.getAttribute("status") != null ? (String) request.getAttribute("status") : "";
        
        String stat = (String) request.getSession().getAttribute("currentMode");
        String fStatus, sStatus, align, dir, xdir, style, Ar_Name, EN_Name, code, measure_unit, driver_transaction, journey_transaction, 
                client_transaction, agent_transaction, title, factorType, sMaintenance, sOthers, select, item_type, sDebit,
                sCredit;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            xdir = "RTL";
            Ar_Name = "Arabic Name";
            EN_Name = "English Name";
            style = "style=\"text-align:left\"";
            code = "Code";
            sStatus = "Expense Item Saved Successfully";
            fStatus = "Fail To Save This Expense Item";
            measure_unit = "Measurement Unit";
            driver_transaction = "Transaction Driver";
            journey_transaction = "Transaction Journey";
            client_transaction = "Transaction Client";
            agent_transaction = "Transaction Agent";
            title="Cost Item ";
            factorType = "Add Transaction";
            sMaintenance="Maintenance";
            sOthers="Others";
            select="Select";
            item_type="Item Type";
            sDebit="Debit";
            sCredit="Credit";
        } else {
            align = "right";
            xdir = "LTR";
            dir = "RTL";
            style = "style=\"text-align:Right\"";
            Ar_Name = "الاسم العربى";
            EN_Name = "الاسم الانجليزى";
            code = "الكود";
            fStatus = " لم يتم التسجيل ";
            sStatus = " تم التسجيل بنجاح ";
            measure_unit = "وحدة القياس";
            client_transaction = "معامله العميل";
            journey_transaction = "معاملة الرحله" ;
            driver_transaction = "معاملة السائق" ;
            agent_transaction = "معاملة المتعهد";
            title="بند التكلفة";
            factorType = "اضافة معامله";
            sMaintenance="صيانة";
            sOthers="أخرى";
            select="أختر";
            item_type="نوع البند";
            sDebit="مدين";
            sCredit="دائن";
        }
        
        LiteWebBusinessObject costItemWbo = request.getAttribute("costItemWbo") != null ? (LiteWebBusinessObject) request.getAttribute("costItemWbo") : null;
    %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/autosuggest.css">
        <LINK rel="stylesheet" type="text/css" href="css/datechooser.css">
        <LINK rel="stylesheet" type="text/css" href="css/select-free.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/ajaxtabs.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <LINK rel="stylesheet" type="text/css" href="css/epoch_styles.css"/>
    </head>
    
    <body>
        <form id="cost_item_form" name="cost_item_form" method="post" >
            <fieldset class="set" align="center" style="width: 90%;">
                <legend>
                    <FONT color='#F3D596' SIZE="5">
                         <%=title%> 
                    </FONT>
                </legend>

                <%  if (null != status) {
                        if (status.equalsIgnoreCase("Success")) {
                %>  
                            <table style="width: 50%; margin: auto auto;" >
                                <tr>                    
                                    <td class="td" style="text-align: center;">
                                        <font size=4 color="black">
                                             <%=sStatus%> 
                                        </font> 
                                    </td>                    
                                </tr>
                            </table>
                <%
                    } else if (status.equalsIgnoreCase("Fail")) {
                %>
                            <table style="width: 50%; margin: auto auto;" >
                                <tr>                    
                                    <td class="td" style="text-align: center;">
                                        <font size=4 color="red" >
                                             <%=fStatus%> 
                                        </font> 
                                    </td>                    
                                </tr>
                            </table>
                <%}
                    }
                %>

                <div style="width: 90%; margin-left: auto; margin-right: auto;">
                    <table  border="0" dir="<%=xdir%>" style="width: 90%;">
                        <tr>
                            <td style="border: none; width: 50%;" <%=style%> align="<%=align%>">
                                <span id="sprytextfield1" dir="<%=dir%>">
                                    <label for="code" style="display: none;"></label>
                                    
                                    <input readonly type="text" name="code" id="code" value="<%=costItemWbo.getAttribute("code")%>" style="width: 90%;"/>
                                    
                                    <span class="textfieldRequiredMsg" style="display: none;">
                                        <div id="ars">
                                             A value is required. 
                                        </div>
                                    </span>
                                    
                                    <span class="textfieldInvalidFormatMsg" style="display: none;">
                                         Invalid format. 
                                    </span>
                                    
                                    <span class="textfieldMaxValueMsg" style="display: none;">
                                         The entered value is greater than the maximum allowed. 
                                    </span>
                                </span>
                            </td>
                            
                            <td  CLASS="silver_odd_main" style="border: none; text-align: center; width: 50%;">
                                 <%=code%> 
                            </td>
                        </tr>
                        
                        <tr>
                            <td style="border: none; width: 50%;"<%=style%> align="<%=align%>">
                                <span id="sprytextfield1" dir="<%=dir%>">
                                    <label for="arName"></label>
                                    
                                    <input readonly type="text" name="Ar_Name" id="Ar_Name" value="<%=costItemWbo.getAttribute("arName")%>"  style="width: 90%;"/>
                                    
                                    <span class="textfieldRequiredMsg" style="display: none;">
                                        <div id="ars">
                                             A value is required. 
                                        </div>
                                    </span>
                                    
                                    <span class="textfieldInvalidFormatMsg" style="display: none;">
                                         Invalid format. 
                                    </span>
                                    
                                    <span class="textfieldMaxValueMsg" style="display: none;">
                                         The entered value is greater than the maximum allowed. 
                                    </span>
                                </span>
                            </td>
                            
                            <td  CLASS="silver_odd_main" style="border: none; text-align: center; width: 50%;">
                                 <%=Ar_Name%> 
                            </td>
                        </tr>
                        
                        <tr>
                            <td  style="border: none; width: 50%;" <%=style%>  align="<%=align%>">
                                <span id="sprytextfield2" dir="<%=dir%>">
                                    <label for="enName"></label>
                                    
                                    <input readonly type="text" name="EN_Name" id="EN_Name" value="<%=costItemWbo.getAttribute("enName")%>" style="width: 90%;"/>
                                    
                                    <span class="textfieldRequiredMsg" id="ens" style="display: none;">
                                         A value is required. 
                                    </span>
                                    
                                    <span class="textfieldInvalidFormatMsg" style="display: none;">
                                         Invalid format. 
                                    </span>
                                    
                                    <span class="textfieldMaxValueMsg" style="display: none;">
                                         The entered value is greater than the maximum allowed. 
                                    </span>
                                </span> 
                            </td>
                            
                            <td  CLASS="silver_odd_main" style="border: none; text-align: center; width: 50%;">
                                 <%=EN_Name%> 
                            </td>
                        </tr>
                        
                        <input type="hidden" id="trans_type" name="trans_type" value="0"/>

                        <tr>
                            <td style="border: none; width: 50%;" <%=style%> align="<%=align%>"><span id="sprytextfield1" dir="<%=dir%>">
                                <span id="spryselect1">
                                    <label for="measure_unit"></label>

                                    <select disabled id="measure_unit" name="measure_unit" size="1"  onselect="test(this)" style="width: 90%;">
                                        <option value="">---</option>
                                        <%
                                            if (costItemWbo.getAttribute("measureUnit")!=null && !costItemWbo.getAttribute("measureUnit").equals("")) {
                                                for (int i = 0; i < units.size(); i++) {
                                                    LiteWebBusinessObject wbo = units.get(i) != null ? (LiteWebBusinessObject) units.get(i) : null;
                                        %>
                                                    <option value="<%=wbo.getAttribute("ID")%>" <%if(costItemWbo!=null &&!costItemWbo.equals("") && costItemWbo.getAttribute("measureUnit").toString().equals(wbo.getAttribute("ID").toString())){%>selected<%}%>>
                                                        <%=wbo.getAttribute("arDesc")%>
                                                    </option>
                                        <%
                                                }
                                            }else{
                                                for (int i = 0; i < units.size(); i++) {
                                                    LiteWebBusinessObject wbo = units.get(i) != null ? (LiteWebBusinessObject) units.get(i) : null;
                                        %>
                                                    <option value="<%=wbo.getAttribute("ID")%>"><%=wbo.getAttribute("arDesc")%></option>
                                        <%
                                                }
                                            }
                                        %>
                                    </select>
                                    <span class="selectRequiredMsg" style="display: none;">
                                         Please select an item. 
                                    </span>
                                </span>
                            </td>
                            
                            <td  CLASS="silver_odd_main" style="border: none; text-align: center; width: 50%;">
                                 <%=measure_unit%> 
                            </td>
                        </tr>
                        
                        <input type="hidden" name="unit_price" id="unit_price" value="0"/>
                        
                        <input type="hidden" id="accountType" name="accountType" value="0">
                        
                        <tr>
                            <td style="border: none; width: 50%;"<%=style%> align="<%=align%>"><span id="sprytextfield1" dir="<%=dir%>">
                                <span id="spryselect1">
                                    <label for="trans_type"></label>
                                    
                                    <select disabled id="itemType" name="itemType" size="1" style="width: 90%;">
                                        <option value="maint" <%if(costItemWbo.getAttribute("calcType").toString().equals("maint")){%>selected<%}%>><%=sMaintenance%></option>
                                        <option value="other" <%if(costItemWbo.getAttribute("calcType").toString().equals("other")){%>selected<%}%>><%=sOthers%></option>
                                    </select>
                                    
                                    <span class="selectRequiredMsg" style="display: none;">
                                         Please select an item. 
                                    </span>
                                </span>
                            </td>
                            
                            <td  CLASS="silver_odd_main" style="border: none; text-align: center; width: 50%;">
                                 <%=item_type%> 
                            </td>
                        </tr>
                    </table>
                </div>
                
                <div style="display: none;">
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD dir="<%=dir%>" style="text-align: center ; border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <font color="#F3D596" size="4">
                                     <%=factorType%> 
                                </font>
                            </TD>
                        </TR>
                    </TABLE>

                    <TABLE id="Others" BGCOLOR="#E8E8E8" ALIGN="center" DIR="<%=dir%>" WIDTH="100%" CELLSPACING=5 CELLPADDING=0 BORDER="0" style="display: block;">
                        <% 
                            ExpenseItemRelativeMgr expenseItemRelativeMgr = ExpenseItemRelativeMgr.getInstance(); 
                            ArrayList<LiteWebBusinessObject> fDriverOfCostItemV = new ArrayList<LiteWebBusinessObject>(expenseItemRelativeMgr.getOnArbitraryDoubleKey(costItemWbo.getAttribute("id").toString(), "key1","driver","key2"));
                            ArrayList<LiteWebBusinessObject> fJourneyOfCostItemV = new ArrayList<LiteWebBusinessObject>(expenseItemRelativeMgr.getOnArbitraryDoubleKey(costItemWbo.getAttribute("id").toString(), "key1","journey","key2"));
                            ArrayList<LiteWebBusinessObject> fClientOfCostItemV = new ArrayList<LiteWebBusinessObject>(expenseItemRelativeMgr.getOnArbitraryDoubleKey(costItemWbo.getAttribute("id").toString(), "key1","client","key2")); 
                            ArrayList<LiteWebBusinessObject> fAgentOfCostItemV = new ArrayList<LiteWebBusinessObject>(expenseItemRelativeMgr.getOnArbitraryDoubleKey(costItemWbo.getAttribute("id").toString(), "key1","agent","key2")); 
                            LiteWebBusinessObject dWbo=null,jWbo=null,cWbo=null,aWbo = null;
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
                            <TD class="backgroundHeader" STYLE="border-left-WIDTH: 1px; text-align: center; padding: 5px;" WIDTH="13%">
                                <b>
                                    <font size=3 color="black" style="font-weight: bold">
                                         <%=driver_transaction%> 
                                    </font>
                                </b>
                            </TD>

                            <TD style="<%=style%>; height: 40px;" class="blueBorder backgroundTable">
                                <select disabled style="width: 200px; font-size: 15px; font-weight: bold;"id="driver" name="driver">
                                    <option value="-1"><%=select%></option>
                                    <option value="Debit" <%if (dWbo!=null && dWbo.getAttribute("acountMood").toString().equals("Debit")){%>selected<%}%>><%=sDebit%></option>
                                    <option value="Credit" <%if (dWbo!=null && dWbo.getAttribute("acountMood").toString().equals("Credit")){%>selected<%}%>><%=sCredit%></option>
                                </select>
                            </TD>

                            <TD style="text-align: center; border-bottom-width: 0px; border-left-width: 0px; border-right-width: 0px; border-top-width: 0px;" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="2" >

                            </TD>

                            <TD class="backgroundHeader" STYLE="border-left-WIDTH: 1px; text-align: center; padding: 5px;" WIDTH="13%">
                                <b>
                                    <font size=3 color="black" style="font-weight: bold">
                                         <%=journey_transaction%> 
                                    </font>
                                </b>
                            </TD>

                            <TD style="<%=style%>;height: 40px;" class="blueBorder backgroundTable">
                                <select disabled style="width: 200px; font-size: 15px; font-weight: bold;"id="journey" name="journey">
                                    <option value="-1"><%=select%></option>
                                    <option value="Debit" <%if (jWbo!=null && jWbo.getAttribute("acountMood").toString().equals("Debit")){%>selected<%}%>><%=sDebit%></option>
                                    <option value="Credit" <%if (jWbo!=null && jWbo.getAttribute("acountMood").toString().equals("Credit")){%>selected<%}%>><%=sCredit%></option>
                                </select>
                            </TD>
                        </tr>

                        <tr>
                            <TD class="backgroundHeader" STYLE="border-left-WIDTH: 1px; text-align: center; padding: 5px;" WIDTH="13%">
                                <b>
                                    <font size=3 color="black" style="font-weight: bold;">
                                         <%=client_transaction%> 
                                    </font>
                                </b>
                            </TD>

                            <TD style="<%=style%>; height: 40px;" class="blueBorder backgroundTable">
                                <select disabled style="width: 200px; font-size: 15px; font-weight: bold;"id="client" name="client">
                                    <option value="-1"><%=select%></option>
                                    <option value="Debit" <%if (cWbo!=null && cWbo.getAttribute("acountMood").toString().equals("Debit")){%>selected<%}%>><%=sDebit%></option>
                                    <option value="Credit" <%if (cWbo!=null && cWbo.getAttribute("acountMood").toString().equals("Credit")){%>selected<%}%>><%=sCredit%></option>
                                </select>
                            </TD>

                            <TD style="text-align: center; border-bottom-width: 0px; border-left-width: 0px; border-right-width: 0px; border-top-width: 0px;" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="2" >

                            </TD>

                            <TD class="backgroundHeader" STYLE="border-left-WIDTH: 1px; text-align: center; padding: 5px;" WIDTH="13%">
                                <b>
                                    <font size=3 color="black" style="font-weight: bold;">
                                         <%=agent_transaction%> 
                                    </font>
                                </b>
                            </TD>

                            <TD style="<%=style%>;height: 40px;" class="blueBorder backgroundTable">
                                <select disabled style="width: 200px; font-size: 15px; font-weight: bold;"id="agent" name="agent">
                                    <option value="-1"><%=select%></option>
                                    <option value="Debit" <%if (aWbo!=null && aWbo.getAttribute("acountMood").toString().equals("Debit")){%>selected<%}%>><%=sDebit%></option>
                                    <option value="Credit" <%if (aWbo!=null && aWbo.getAttribute("acountMood").toString().equals("Credit")){%>selected<%}%>><%=sCredit%></option>
                                </select>
                            </TD>
                        </tr>
                    </table>
                </div>
            </fieldset>
        </form>
    </body>
</html>