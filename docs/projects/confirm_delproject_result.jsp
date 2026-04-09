<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<HTML>

    <%
       

        ProjectMgr projectMgr = ProjectMgr.getInstance();

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
        String status = request.getAttribute("status").toString();

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, tit, save, cancel, TT, SNA, success, fail;
        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            tit = "Delete Site - Result Message ";
            save = "Delete";
            cancel = "Back To List";
            TT = "Task Title ";
            SNA = "Site Name";
            success = "Project has been deleted (Please check equipments which on this sites)";
            fail = "Project has't been deleted";

        } else {

            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            tit = "حذف الموقع - رسالة التأكيد ";
            save = " &#1573;&#1581;&#1584;&#1601;";
            cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
            TT = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
            SNA = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
            success = " تم حذف الموقع بنجاح - الرجاء فحص المعدات الموجودة علي هذه المواقع";
            fail = "لم يتم حذف الموقع ";
        }
        String msg = "";
        if (status.equalsIgnoreCase("ok")) {
            msg = success;
        } else {
            msg = fail;
        }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">

        <HEAD>
            <TITLE>Document Viewer - Confirm Deletion</TITLE>
            <link rel="stylesheet" type="text/css" href="css/CSS.css" />
            <link rel="stylesheet" type="text/css" href="css/Button.css" />
            <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
            <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        </HEAD>
        <BODY>
            <FORM NAME="PROJECT_DEL_FORM" METHOD="POST">
                <br />
                <center>
                    <fieldset class="set" style="border-color: #006699; width: 90%">
                        <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                            <TR>
                                <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"> <%=tit%> </FONT><BR></TD>
                            </TR>
                        </TABLE>
                        <br />
                        <TABLE ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">

                            <TR>
                                <TD class='td'>
                                    <LABEL FOR="str_Function_Name">
                                        <p><b><%=msg%></b>&nbsp;
                                    </LABEL>
                                </TD>
                            </TR>
                        </TABLE>
                        <br><br>
                    </fieldset>
                </center>
            </FORM>

        </BODY>
</HTML>     
