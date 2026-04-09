<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>  
<%@page pageEncoding="UTF-8" %>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();


    WebBusinessObject location_type = (WebBusinessObject) request.getAttribute("location_type");
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode, tit, save, cancel, TT, SNA, SNO, DESC;
    String typeName = null;
    String location_type_ar_desc_label = null;
    String location_type_en_desc_label = null;
    if (stat.equals("En")) {

        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        tit = "View location type data ";
        save = "Delete";
        cancel = "Back To List";
        TT = "Task Title ";
        SNA = "Site Name";
        SNO = "Site No.";
        DESC = "Description";
        typeName = "enDesc";
        location_type_ar_desc_label = "Arabic description";
        location_type_en_desc_label = "English description";
    } else {

        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        tit = " عرض بيانات نوع الموقع";
        save = " &#1573;&#1581;&#1584;&#1601;";
        cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        TT = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        SNA = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        SNO = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        DESC = "&#1575;&#1604;&#1608;&#1589;&#1601;";
        typeName = "arDesc";
        location_type_ar_desc_label = "الوصف العربي ";
        location_type_en_desc_label = "الوصف الأجنبي ";
    }
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
        <TITLE>Document Viewer - add new LOCATION TYPE</TITLE>
        <script language="javascript" type="text/javascript" >
        
            function cancelForm()
            {    
                document.LOCATION_TYPE_VIEW_FORM.action = "<%=context%>/ProjectServlet?op=listLocationType";
                document.LOCATION_TYPE_VIEW_FORM.submit();  
            }
        </script>
    </HEAD>
    <BODY>
    <center>
        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
        </DIV> 
        <br />
        <fieldset class="set" style="border-color: #006699; width: 90%">
            <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <TR>
                    <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"> <%=tit%> </FONT><BR></TD>
                </TR>
            </TABLE>
            <FORM NAME="LOCATION_TYPE_VIEW_FORM" METHOD="POST">

                <table ALIGN="<%=align%>" DIR="<%=dir%>" >
                    <TR>
                        <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=SNO%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable">
                            <input disabled type="TEXT" STYLE="width:230px" name="typeCode" ID="typeCode" size="33" value="<%=location_type.getAttribute("typeCode")%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <LABEL FOR="str_arDesc">
                                <p><b> <%=location_type_ar_desc_label%> </b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable">
                            <input type="TEXT" dir="<%=dir%>" name="arDesc" ID="arDesc" size="32" value="<%=location_type.getAttribute("arDesc")%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=location_type_en_desc_label%> </b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD colspan="3" class="blueBorder backgroundTable" >
                            <input type="TEXT" dir="<%=dir%>" name="enDesc" ID="enDesc" size="32" value="<%=location_type.getAttribute("enDesc")%>" maxlength="255">
                        </TD>
                    </TR>
                </TABLE>
                <br />
                <br />
            </FORM>
    </center>
</BODY>
</HTML>     
