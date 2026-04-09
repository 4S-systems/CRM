<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>

    <%
                String unitID = (String) request.getAttribute("unitID");
                String unitName = (String) request.getAttribute("unitName");

                ProjectMgr projectMgr = ProjectMgr.getInstance();

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
                if (stat.equals("En")) {

                    saving_status = "Saving status";
                    align = "center";
                    dir = "LTR";
                    style = "text-align:left";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    unit_desc = "Descritption";
                    unit_name = "Unit name";
                    title_1 = "Delete Measurement - Are You Sure? ";
                    title_2 = "All information are needed";
                    cancel_button_label = "Back to List ";
                    save_button_label = "Delete ";
                    langCode = "Ar";
                } else {

                    saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
                    align = "center";
                    dir = "RTL";
                    style = "text-align:Right";
                    lang = "English";
                    unit_desc = "&#1575;&#1604;&#1608;&#1589;&#1601; ";
                    unit_name = "&#1573;&#1587;&#1605; &#1608;&#1581;&#1583;&#1577; &#1575;&#1604;&#1602;&#1610;&#1575;&#1587;";
                    title_1 = "حذف القياس - هل أنت متأكد؟ ";
                    title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
                    cancel_button_label = tGuide.getMessage("backtolist");
                    save_button_label = "&#1573;&#1581;&#1584;&#1601;";
                    langCode = "En";
                }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">

        <HEAD>
            <TITLE>Document Viewer - Confirm Deletion</TITLE>
            <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        </HEAD>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

            function submitForm()
            {
                document.PROJECT_DEL_FORM.action = "<%=context%>/MeasurementsServlet?op=deleteMeasurement&unitID=<%=unitID%>&unitName=<%=unitName%>";
                document.PROJECT_DEL_FORM.submit();
            }
            function cancelForm()
            {
                document.PROJECT_DEL_FORM.action = "<%=context%>/MeasurementsServlet?op=ListMeasurements";
                document.PROJECT_DEL_FORM.submit();
            }
        </SCRIPT>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <BODY>



            <FORM NAME="PROJECT_DEL_FORM" METHOD="POST">

                <DIV align="left" STYLE="color:blue;">
                    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                    <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                    <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/del.gif"></button>
                </DIV>
                <fieldset class="set" style="border-color: #006699; width: 95%">
                    <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><Font color='white' SIZE="+1"><%=title_1%></Font>
                            </td>
                        </tr>
                    </table>
                    <br /><br />
                    <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="4" CELLSPACING="0" BORDER="0">

                        <TR>
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="str_unitName">
                                    <p><b><%=unit_name%> <font color="#FF0000"></font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>" class='td'>
                                <input disabled type="TEXT" name="unitName" value="<%=unitName%>" ID="<%=unitName%>" size="33"  maxlength="50">
                            </TD>
                        </TR>

                        <input  type="HIDDEN" name="unitID" value="<%=unitID%>">

                    </TABLE>
                    <br /><br />
                </fieldset>
            </FORM>
        </BODY>
</HTML>     
