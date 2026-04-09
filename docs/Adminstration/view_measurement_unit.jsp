<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@page pageEncoding="UTF-8" %>

<HTML>


    <%
        String status = (String) request.getAttribute("Status");
        WebBusinessObject data = (WebBusinessObject) request.getAttribute("data");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode;

        String saving_status;
        String unit_name, unit_desc;
        String title_1, title_2;
        String cancel_button_label;
        String save_button_label;
        String submit_button_label, name_ar, name_en, unit_system, unitbase, viewData;
        if (stat.equals("En")) {

            saving_status = "Saving status";
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            unit_desc = "Descritption";
            unit_name = "Unit name";
            title_1 = "View unit";
            title_2 = "All information are needed";
            cancel_button_label = "Back To List ";
            save_button_label = "Save ";
            langCode = "Ar";

            name_ar = "Arabic Name ";
            name_en = "English Name ";
            unit_system = "Unit System ";
            unitbase = "Base Unit";
            viewData = "View Measurement Unit";
        } else {

            saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            unit_desc = "&#1575;&#1604;&#1608;&#1589;&#1601; ";
            unit_name = "&#1573;&#1587;&#1605; &#1608;&#1581;&#1583;&#1577; &#1575;&#1604;&#1602;&#1610;&#1575;&#1587;";
            title_1 = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1608;&#1581;&#1583;&#1577; &#1575;&#1604;&#1602;&#1610;&#1575;&#1587;";
            title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
            cancel_button_label = "عودة إلي القائمة ";
            save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
            langCode = "En";

            name_ar = "الإسم العربي ";
            name_en = "الإسم الإنجليزي  ";
            unit_system = " نظام الوحدة";
            unitbase = " الوحدة الرئيسية";
            viewData = "عرض وحدة القياس ";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>DebugTracker-add new function area</TITLE>
    </HEAD
    <BODY>
        <FORM NAME="PROJECT_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" onclick="JavaScript: cahangePage('<%=context%>/MeasurementUnitsServlet?op=ListMeasuerUnits');" class="button" value="<%=cancel_button_label%>" />
            </DIV>
            <fieldset class="set" style="border-color: #006699; width: 95%">
                <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><Font color='white' SIZE="+1"><%=title_1%></Font>
                        </td>
                    </tr>
                </table><br />
                <TABLE align="<%=align%>" DIR="<%=dir%>"  CELLPADDING="0" CELLSPACING="0" WIDTH="600">
                    <TR>
                        <TD CLASS="blueHeaderTD" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16" COLSPAN="2">
                            <B><%=viewData%></B>
                        </TD>
                    </TR>
                    <TR>
                        <TD CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:center;font-size:14" WIDTH="150"><B><%=unitbase%></B></TD>
                        <TD CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=data.getAttribute("Base").toString()%></TD>
                    </TR>
                    <TR>
                        <TD CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:center;font-size:14" WIDTH="150"><B><%=name_ar%></B></TD>
                        <TD CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=data.getAttribute("arabicUnitName").toString()%></TD>
                    </TR>
                    <TR>
                        <TD CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:center;font-size:14" WIDTH="150"><B><%=name_en%></B></TD>
                        <TD CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=data.getAttribute("englishUnitName").toString()%></TD>
                    </TR>
                    <TR>
                        <TD CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:center;font-size:14" WIDTH="150"><B><%=unit_system%></B></TD>
                        <TD CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=data.getAttribute("SYSTEM").toString()%></TD>
                    </TR>
                </TABLE>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
