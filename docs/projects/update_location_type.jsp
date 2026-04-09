<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<%


    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String status = (String) request.getAttribute("status");

    WebBusinessObject location_type = (WebBusinessObject) request.getAttribute("location_type");

    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode, tit, save, cancel, TT, SNA, SNO, DESC, STAT, Dupname;
    String fStatus;
    String sStatus;

    String location_type_code_label = null;
    String location_type_ar_desc_label = null;
    String location_type_en_desc_label = null;
    String futile_label = null;
    String location_type_label = null;

    String typeName = null;
    if (stat.equals("En")) {

        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        tit = "Update Project";
        save = "Save";
        cancel = "Back To List";
        TT = "Task Title ";
        SNA = "Site Name";
        SNO = "Site No.";
        DESC = "Description";
        STAT = "Update Status";
        Dupname = "Name is Duplicated Chane it";
        sStatus = "Site Updated Successfully";
        fStatus = "Fail To Update This Site";
        typeName = "enDesc";
        location_type_code_label = "Location code";
        location_type_ar_desc_label = "Arabic decription";
        location_type_en_desc_label = "English decription";

    } else {

        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        tit = "    &#1578;&#1581;&#1583;&#1610;&#1579; &#1605;&#1608;&#1602;&#1593; &#1605;&#1608;&#1580;&#1608;&#1583; ";
        save = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
        cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        TT = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        SNA = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        SNO = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        DESC = "&#1575;&#1604;&#1608;&#1589;&#1601;";
        STAT = " &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
        fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
        sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";


        location_type_code_label = "كود النوع ";
        location_type_ar_desc_label = "الوصف العربي ";
        location_type_en_desc_label = "الوصف الأجنبي ";
    }

    String doubleName = (String) request.getAttribute("name");
    String type = "";
    try {
        type = request.getAttribute("type").toString();
    } catch (Exception ex) {
    }

%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new location_type</TITLE>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            function submitForm()
            {
                if (!validateData("req", document.location_type_update_FORM.typeCode, "Please, enter Location Type Code.")){
                    document.location_type_update_FORM.typeCode.focus();
                } else if (!validateData("req", document.location_type_update_FORM.arDesc, "Please, enter Location Type Arabic Description.") || !validateData("minlength=3", document.location_type_update_FORM.arDesc, "Location Type Arabic Description Must be greater than 3 letters.")){
                    document.location_type_update_FORM.arDesc.focus();
                } else if (!validateData("req", document.location_type_update_FORM.enDesc, "Please, enter Location Type English Description.") || !validateData("minlength=3", document.location_type_update_FORM.enDesc, "Location Type English Description Must be greater than 3 letters.")){
                    document.location_type_update_FORM.enDesc.focus();
                } else{
                    document.location_type_update_FORM.action = "<%=context%>/ProjectServlet?op=updateLocationType";
                    document.location_type_update_FORM.submit();
                }
            }
    
            function cancelForm()
            {    
                document.location_type_update_FORM.action = "<%=context%>/ProjectServlet?op=listLocationType";
                document.location_type_update_FORM.submit();  
            }
        </SCRIPT>
    </HEAD>

    <BODY>
    <center>
        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
            <button    onclick="submitForm()" class="button"><%=save%>    <IMG SRC="images/save.gif"></button>
        </DIV> 
        <br />
        <fieldset class="set" style="border-color: #006699; width: 90%">
            <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <TR>
                    <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"> <%=tit%> </FONT><BR></TD>
                </TR>
            </TABLE>
            <br />
            <FORM NAME="location_type_update_FORM" id="updateForm" METHOD="POST">
                <%
                    if (null != doubleName) {

                %>

                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font size=4 > <%=Dupname%> </font> 
                        </td>

                    </tr> </table>
                    <%

                        }

                    %>    
                    <%
                        if (null != status) {
                            if (status.equalsIgnoreCase("ok")) {
                    %>  
                <tr>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="black"><%=sStatus%></font> 
                        </td>                    
                    </tr> </table>
                </tr>
                <%
                } else {%>
                <tr>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="red" ><%=fStatus%></font> 
                        </td>                    
                    </tr> </table>
                </tr>
                <%}
                    }

                %>
                <br />
                <table align="<%=align%>" dir="<%=dir%>">


                    <TR>
                        <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <LABEL FOR="str_EQ_NO">
                                <p><b><%=location_type_code_label%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable" >
                            <input type="TEXT" name="typeCode" dir="<%=dir%>" ID="typeCode" size="32" value="<%=location_type.getAttribute("typeCode")%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <LABEL FOR="str_arDesc">
                                <p><b> <%=location_type_ar_desc_label%> <font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable">
                            <input type="TEXT" dir="<%=dir%>" name="arDesc" ID="arDesc" size="32" value="<%=location_type.getAttribute("arDesc")%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=location_type_en_desc_label%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable" >
                            <input type="TEXT" dir="<%=dir%>" name="enDesc" ID="enDesc" size="32" value="<%=location_type.getAttribute("enDesc")%>" maxlength="255">
                        </TD>
                    </TR>
                </table>
                <br /><br />
                <input type="hidden" name="id" ID="id" value="<%=location_type.getAttribute("id")%>">
            </FORM>
            <br>
        </fieldset>
    </center>
</BODY>
</HTML>     