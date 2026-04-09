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
                String cancel_button_label, M1, M2, message = "";
                String save_button_label, arDescLable, enDescLable, codeLable, minAllowLable, maxAllowLable,
                        action_Taken_Before_AllowLable, action_Taken_Above_AllowLable, frequencyLable, measurementUnitLable, viewData;
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

                    arDescLable = "Arabic Name ";
                    enDescLable = "English Name ";
                    codeLable = "Code ";
                    minAllowLable = "Min allow ";
                    maxAllowLable = "Max allow ";
                    action_Taken_Before_AllowLable = "Action taken before allow ";
                    action_Taken_Above_AllowLable = "Action taken above allow ";
                    frequencyLable = "Frequency ";
                    measurementUnitLable = "Measurement unit ";

                    viewData = "View Measurement";
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


                    arDescLable = "الإسم العربي ";
                    enDescLable = "الإسم الإنجليزي  ";
                    codeLable = "الكود ";
                    minAllowLable = "الحد الأدني  ";
                    maxAllowLable = "الحد الأقصي  ";
                    action_Taken_Before_AllowLable = "رد الفعل في حالة تجاوز الحد الأدني المسموح  ";
                    action_Taken_Above_AllowLable = "رد الفعل في حالة تجاوز الحد الأقصي المسموح ";
                    frequencyLable = "Frequency ";
                    measurementUnitLable = "وحدة القياس ";
                    ;
                    viewData = "عرض المقاييس ";
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
                <input type="button" onclick="JavaScript: cahangePage('<%=context%>/MeasurementsServlet?op=ListMeasurements');" class="button" value="<%=cancel_button_label%>" />
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
                        <TD CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:center;font-size:14" WIDTH="150"><B><%=codeLable%></B></TD>
                        <TD CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=data.getAttribute("code").toString()%></TD>
                    </TR>
                    <TR>
                        <TD CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:center;font-size:14" WIDTH="150"><B><%=arDescLable%></B></TD>
                        <TD CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=data.getAttribute("arDesc").toString()%></TD>
                    </TR>
                    <TR>
                        <TD CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:center;font-size:14" WIDTH="150"><B><%=enDescLable%></B></TD>
                        <TD CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=data.getAttribute("enDesc").toString()%></TD>
                    </TR>
                    <TR>
                        <TD CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:center;font-size:14" WIDTH="150"><B><%=frequencyLable%></B></TD>
                        <TD CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=data.getAttribute("frequency").toString()%></TD>
                    </TR>
                    <TR>
                        <TD CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:center;font-size:14" WIDTH="150"><B><%=measurementUnitLable%></B></TD>
                        <TD CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=data.getAttribute("measurementUnitId").toString()%></TD>
                    </TR>
                    <TR>
                        <TD CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:center;font-size:14" WIDTH="150"><B><%=minAllowLable%></B></TD>
                        <TD CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=data.getAttribute("minAllow").toString()%></TD>
                    </TR>
                    <TR>
                        <TD CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:center;font-size:14" WIDTH="150"><B><%=maxAllowLable%></B></TD>
                        <TD CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=data.getAttribute("maxAllow").toString()%></TD>
                    </TR>
                    <TR>
                        <TD CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:center;font-size:14" WIDTH="150"><B><%=action_Taken_Before_AllowLable%></B></TD>
                        <TD CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=data.getAttribute("action_Taken_Before_Allow").toString()%></TD>
                    </TR>
                    <TR>
                        <TD CLASS="silver_header" bgcolor="#9B9B00" STYLE="text-align:center;font-size:14" WIDTH="150"><B><%=action_Taken_Above_AllowLable%></B></TD>
                        <TD CLASS="silver_odd" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=data.getAttribute("action_Taken_Above_Allow").toString()%></TD>
                    </TR>
                </TABLE>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
