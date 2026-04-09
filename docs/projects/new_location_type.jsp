<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>


    <%
        String status = (String) request.getAttribute("Status");

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode;

        String Dupname;
        String location_type_code_label = null;
        String location_type_ar_desc_label = null;
        String location_type_en_desc_label = null;
        String title_1, title_2;
        String cancel_button_label;
        String save_button_label;
        String fStatus;
        String sStatus;

        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            location_type_code_label = "Type Code";
            location_type_ar_desc_label = "Arabic description";
            location_type_en_desc_label = "English description";

            title_1 = "Adding a new location type";
            title_2 = "All information are needed";
            cancel_button_label = "Cancel ";
            save_button_label = "Save ";
            langCode = "Ar";
            Dupname = "Name is Duplicated Chane it";
            sStatus = "New location type has Saved Successfully";
            fStatus = "Fail To Save This location type";

        } else {

            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            location_type_code_label = "كود النوع ";
            location_type_ar_desc_label = "الوصف العربي ";
            location_type_en_desc_label = "الوصف الأجنبي ";
            title_1 = "إضافة نوع موقع جديد";
            title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
            cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569; ";
            save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
            langCode = "En";
            Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
            fStatus = "لم يتم حفظ نوع الموقع ";
            sStatus = "تم الحفظ بنجاح ";
        }

        String doubleName = (String) request.getAttribute("name");
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>DebugTracker-add new function area</TITLE>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            function submitForm()
            {//alert('entered');
                if (!validateData("req", this.new_location_type_Form.typeCode, "Please, enter Location Type Code.")){
                    this.new_location_type_Form.typeCode.focus();
                } else if (!validateData("req", this.new_location_type_Form.arDesc, "Please, enter Location Type Arabic Description.") || !validateData("minlength=3", this.new_location_type_Form.arDesc, "Location Type Arabic Description Must be greater than 3 letters.")){
                    this.new_location_type_Form.arDesc.focus();
                } else if (!validateData("req", this.new_location_type_Form.enDesc, "Please, enter Location Type English Description.") || !validateData("minlength=3", this.new_location_type_Form.enDesc, "Location Type English Description Must be greater than 3 letters.")){
                    this.new_location_type_Form.enDesc.focus();
                } else{
                   // alert('save');
                    document.new_location_type_Form.action = "<%=context%>/ProjectServlet?op=saveLocationType";//&backTo=projTree&backTo=projTree&"+form.serialize(),
                  //  alert('save action ');
                    document.new_location_type_Form.submit();
                }
            }
            function cancelForm()
            {
                document.new_location_type_Form.action = "<%=context%>/main.jsp"
                document.new_location_type_Form.submit();
            }
        </SCRIPT>
    </HEAD>

    <BODY>
    <CENTER>
        <FORM NAME="new_location_type_Form" id="new_location_type_Form" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>"onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV>
            <br />

            <fieldset class="set" style="border-color: #006699; width: 90%">
                <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <TR>
                        <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"> <%=title_1%> </FONT><BR></TD>
                    </TR>
                </TABLE> 
                <br />
                <%if (null != doubleName) {%>

                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font size=4 > <%=Dupname%> </font>
                        </td>
                    </tr>
                </table>
                <%}%>

                <table align="<%=align%>" dir="<%=dir%>">
                    <%
                        if (null != status) {
                            if (status.equalsIgnoreCase("ok")) {
                    %>
                    <tr>
                        <td>
                            <table align="<%=align%>" dir=<%=dir%>>
                                <tr>
                                    <td class="td">
                                        <font size=4 color="black"><%=sStatus%></font>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%} else {%>
                    <tr>
                        <td>
                            <table align="<%=align%>" dir=<%=dir%>>
                                <tr>
                                    <td class="td">
                                        <font size=4 color="red" ><%=fStatus%></font>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%}
                            }%>
                </table>
                <table align="<%=align%>" dir="<%=dir%>">
                    <TR COLSPAN="2" ALIGN="<%=align%>">
                        <TD STYLE="<%=style%>" class='td'>
                            <FONT color='red' size='+1'><%=title_2%></FONT>
                        </TD>
                    </TR>
                </table>
                <br />
                <table align="<%=align%>" dir="<%=dir%>">


                    <TR>
                        <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <LABEL FOR="str_EQ_NO">
                                <p><b><%=location_type_code_label%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable" >
                            <input type="TEXT" name="typeCode" dir="<%=dir%>" ID="typeCode" size="32" value="" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <LABEL FOR="str_arDesc">
                                <p><b> <%=location_type_ar_desc_label%> <font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable">
                            <input type="TEXT" dir="<%=dir%>" name="arDesc" ID="arDesc" size="32" value="" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=location_type_en_desc_label%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable" >
                            <input type="TEXT" dir="<%=dir%>" name="enDesc" ID="enDesc" size="32" value="" maxlength="255">
                        </TD>
                    </TR>
                </table>
                <br /><br />
            </fieldset>
        </FORM>
    </CENTER>
</BODY>
</HTML>