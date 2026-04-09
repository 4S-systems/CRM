<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>


    <%
        String status = (String) request.getAttribute("Status");

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");


        ArrayList locationTypesList = (ArrayList) request.getAttribute("locationTypesList");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode;

        String saving_status, Dupname;
        String project_code_label = null;
        String project_name_label = null;
        String project_desc_label = null;
        String futile_label = null;
        String location_type_label = null;
        String project_location_label = null;
        String title_1, title_2;
        String cancel_button_label;
        String save_button_label;
        String fStatus;
        String sStatus;
        String futileMsg = "";
        String isTrnsprtStn;
        String isMngmntStn;
        String typeName = null;

        ArrayList allSites = (ArrayList) request.getAttribute("allSites");
        String defaultLocationName = (String) request.getAttribute("defaultLocationName");

        String selectAll, main_project_name_label, searchTitle, byName, byCode;
        if (stat.equals("En")) {

            saving_status = "Saving status";
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            project_code_label = "Location name";
            project_name_label = "Location code";
            project_desc_label = "Location decription";
            futile_label = "Adding sub location ";
            location_type_label = "Loaction Type";

            project_name_label = "Location name";
            project_location_label = "Location number";
            project_desc_label = "Location decription";
            title_1 = "Add a new sub-site";
            title_2 = "All information are needed";
            cancel_button_label = "Cancel ";
            save_button_label = "Save ";
            langCode = "Ar";
            Dupname = "Name or code is Duplicated Change it";
            sStatus = "Site Saved Successfully";
            fStatus = "Fail To Save This Site";

            selectAll = "All";
            main_project_name_label = "Main Project";

            searchTitle = "Project From ERP";
            byName = "Name";
            byCode = "Code";
            typeName = "enDesc";
            futileMsg = "Can't add a sub locations ";
            isTrnsprtStn = "Is Transport Station";
            isMngmntStn = "Is Managment Station";
        } else {

            /*if(status.equalsIgnoreCase("ok"))
             status="";*/
            saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            project_code_label = "كود العنصر ";
            project_name_label = "إسم العنصر ";
            project_desc_label = "الوصف ";
            futile_label = "إضافة عناصر فرعية ";
            location_type_label = "نوع العنصر ";
            project_location_label = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
            title_1 = "إضافة عنصر فرعي جديد";
            title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
            cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569; ";
            save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
            langCode = "En";
            Dupname = "الإسم أو الكود مكرر الرجاء تغييره";
            fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
            sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";

            selectAll = "الكل";
            main_project_name_label = "العنصر الرئيسي";

            searchTitle = "من المخازن";

            byName = "بالإسم";
            byCode = "بالكود";
            typeName = "arDesc";
            futileMsg = "لا يمكن إضافة عناصر فرعية";
            isTrnsprtStn = "محطة نقل";
            isMngmntStn = "موقع إدارى";
        }

        String doubleName = (String) request.getAttribute("name");
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>DebugTracker-add new function area</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">

    </HEAD>
    <script src='silkworm_validate.js' type='text/javascript'></script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        window.onbeforeunload = function(){ return 'Reload?';}
        function submitForm()
        {
            if (!validateData("req", this.PROJECT_FORM.eqNO, "Please, enter Site Number.") || !validateData("alphanumeric", this.PROJECT_FORM.eqNO, "Please, enter a valid Number for Site Number.")){
                this.PROJECT_FORM.eqNO.focus();
            } else if (!validateData("req", this.PROJECT_FORM.project_name, "Please, enter Site Name.") || !validateData("minlength=3", this.PROJECT_FORM.project_name, "Please, enter a valid Site Name.")){
                this.PROJECT_FORM.project_name.focus();
            } else if (!validateData("req", this.PROJECT_FORM.project_desc, "Please, enter Site Description.")){
                this.PROJECT_FORM.project_desc.focus();
            } else{
                document.PROJECT_FORM.action = "<%=context%>/ProjectServlet?op=SaveNewLocation";
                document.PROJECT_FORM.submit();
            }
        }

        function IsNumeric(sText)
        {
            var ValidChars = "0123456789.";
            var IsNumber=true;
            var Char;


            for (i = 0; i < sText.length && IsNumber == true; i++)
            {
                Char = sText.charAt(i);
                if (ValidChars.indexOf(Char) == -1)
                {
                    IsNumber = false;
                }
            }
            return IsNumber;

        }

        function clearValue(no){
            document.getElementById('Quantity' + no).value = '0';
            total();
        }

        function cancelForm()
        {
            document.PROJECT_FORM.action = "main.jsp";
            document.PROJECT_FORM.submit();
        }

        function getFromERP(){

            /*if(document.getElementById("fromERP").checked==true){
                document.getElementById("eRPForm").style.display='inline';
                document.getElementById("site1").style.display='none';
            } else {
                document.getElementById('eRPForm').style.display='none';
                document.getElementById("site1").style.display='inline';
            }*/
            if ($('#fromERP').is(':checked') == true) {

                $('#eRPForm').show(100);
                $('#site1').hide(100);
            } else {
                $('#eRPForm').hide(100);
                $('#site1').show(100);
            }
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>

    <BODY>
        <FORM NAME="PROJECT_FORM" METHOD="POST" action="">
                <DIV align="left" STYLE="color:blue;">
                    <input type="button" value="<%=lang%>"onclick="reloadAE('<%=langCode%>')" class="button">
                    <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                    <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                </DIV>
                <br/>
                <CENTER>
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
                                    <LABEL FOR="str_Project_Name">
                                        <p><b> <%=main_project_name_label%> <font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD colspan="3" class="blueBorder backgroundTable" >
                                    <SELECT class="blackFont fontInput" style="width: 230px; font-size: 16px;" name="mainProjectId" id="mainProjectId">
                                        <sw:WBOOptionList wboList="<%=allSites%>" displayAttribute="projectName" scrollTo="<%=defaultLocationName%>" valueAttribute="projectID" />
                                    </select>
                                </TD>
                            </TR>
                            <TR>
                                <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                    <LABEL FOR="str_EQ_NO">
                                        <p><b><%=project_code_label%><font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD colspan="3" class="blueBorder backgroundTable" >
                                    <input type="TEXT" name="eqNO" dir="<%=dir%>" ID="eqNO" size="32" value="" maxlength="255">
                                </TD>
                            </TR>
                            <TR>
                                <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                    <LABEL FOR="str_Project_Name">
                                        <p><b> <%=project_name_label%> <font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD colspan="3" class="blueBorder backgroundTable">
                                    <input type="TEXT" dir="<%=dir%>" name="project_name" ID="project_name" size="32" value="" maxlength="255">
                                </TD>
                            </TR>
                            <TR>
                                <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                    <LABEL FOR="str_EQ_NO">
                                        <p><b><%=futile_label%><font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD colspan="3" class="blueBorder backgroundTable" >
                                    <input type="radio" checked="checked" name="futile" dir="<%=dir%>" ID="futile" size="32" value="1" maxlength="255"> يمكن
                                    <input type="radio" name="futile" dir="<%=dir%>" ID="futile" size="32" value="0" maxlength="255"> لايمكن
                                </TD>
                            </TR>
                            <TR>
                                <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                    <LABEL FOR="str_EQ_NO">
                                        <p><b><%=location_type_label%><font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD colspan="3" class="blueBorder backgroundTable" >
                                    <SELECT class="blackFont fontInput" style="width: 230px; font-size: 16px;" name="location_type" onchange="JavaScript: getBrand(this.value)">
                                        <sw:OptionsList listAsArrayList="<%=locationTypesList%>" displayAttribute = "<%=typeName%>" valueAttribute="typeCode"/>
                                    </SELECT>
                                </TD>
                            </TR>
                            <TR>
                                <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                    <LABEL FOR="str_Function_Desc">
                                        <p><b><%=project_desc_label%><font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD colspan="3" class="blueBorder backgroundTable" >
                                    <TEXTAREA rows="5" name="project_desc" dir="rtl" ID="project_desc" cols="26"></TEXTAREA>
                                </TD>
                            </TR>
<!--                            <TR>
                                <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                    <LABEL>
                                        <p><b><%=isMngmntStn%><font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD colspan="3" class="blueBorder backgroundTable" >
                                    <INPUT type="checkbox" id="isMngmntStn" name="isMngmntStn" checked="true" />
                                </TD>
                            </TR>
                            <TR>
                                <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                    <LABEL>
                                        <p><b><%=isTrnsprtStn%><font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD colspan="3" class="blueBorder backgroundTable" >
                                    <INPUT type="checkbox" id="isTrnsprtStn" name="isTrnsprtStn" checked="true" />
                                </TD>
                            </TR>-->
                        </table>
                        <br /><br /><br />
                    </fieldset>
                </CENTER>

            <%--<fieldset class="set" align="center">
                <legend align="center">
                    <table dir="rtl" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"> <%=title_1%> </font>
                            </td>
                        </tr>
                    </table>
                </legend>

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
                        <table align="<%=align%>" dir=<%=dir%>>
                            <tr>
                                <td class="td">
                                    <font size=4 color="red" ><%=fStatus%></font>
                                </td>
                            </tr>
                        </table>
                        </tr>
                    <%}}%>
                </table>
                <table align="<%=align%>" dir="<%=dir%>">
                    <TR COLSPAN="2" ALIGN="<%=align%>">
                        <TD STYLE="<%=style%>" class='td'>
                            <FONT color='red' size='+1'><%=title_2%></FONT>
                        </TD>
                    </TR>
                </table>
                <br>
                <table align="<%=align%>" dir="<%=dir%>">
                    <tr>
                        <TD colspan="4" style="<%=style%>; width: 400px;" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData"> <input type="checkbox" name="fromERP" value="fromERP" id="fromERP" onclick="Javascript:getFromERP();">&nbsp;&nbsp;<%=searchTitle%></TD>
                    </tr>
                    <TR style="display:none;" id="eRPForm" >
                        <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <LABEL FOR="str_Project_Name">
                                <p style="color: #ffffff;background-color: #999999"><b> <%=main_project_name_label%> <font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable" >
                            <select name="siteErp" id="siteErp" style="font-size:12px;font-weight:bold;height: 25px;margin: 0;width: 202px;">
                                <sw:WBOOptionList wboList="<%=allSites%>" displayAttribute="projectName" scrollTo="<%=defaultLocationName%>" valueAttribute="projectID" />
                            </select>
                        </TD>
                    </TR>
                    <TR id="site1">
                        <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <LABEL FOR="str_Project_Name">
                                <p><b> <%=main_project_name_label%> <font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable" >
                            <select name="site" id="site" style="font-size:12px;font-weight:bold;width:70%; height: 100%;  margin: 0px">
                                <sw:WBOOptionList wboList="<%=allSites%>" displayAttribute="projectName" scrollTo="<%=defaultLocationName%>" valueAttribute="projectID" />
                            </select>
                        </TD>
                    </TR>
                    <TR>
                        <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <LABEL FOR="str_Project_Name">
                                <p><b> <%=project_name_label%> <font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable">
                            <input type="TEXT" dir="<%=dir%>" name="project_name" ID="project_name" size="32" value="" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <LABEL FOR="str_EQ_NO">
                                <p><b><%=project_location_label%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable" >
                            <input type="TEXT" name="eqNO" dir="<%=dir%>" ID="eqNO" size="32" value="" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=project_desc_label%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable" >
                            <TEXTAREA rows="5" name="project_desc" dir="rtl" ID="project_desc" cols="26"></TEXTAREA>
                        </TD>
                    </TR>
                </table>
                <br><br><br>
            </fieldset>--%>
        </FORM>
    </BODY>
</HTML>
