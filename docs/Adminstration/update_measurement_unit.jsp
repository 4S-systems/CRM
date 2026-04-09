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

                String saving_status, Dupname;
                String unit_name, unit_desc;
                String title_1, title_2;
                String cancel_button_label, M1, M2, message = "";
                String submit_button_label, name_ar, name_en, unit_system, unitbase;
                if (stat.equals("En")) {

                    saving_status = "Saving status";
                    align = "center";
                    dir = "LTR";
                    style = "text-align:left";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    title_1 = "New Measurement Unit";
                    title_2 = "All information are needed";
                    cancel_button_label = "Cancel ";
                    submit_button_label = "Update ";
                    langCode = "Ar";
                    Dupname = "Name is Duplicated Chane it";

                    name_ar = "Arabic Name ";
                    name_en = "English Name ";
                    unit_system = "Unit System ";
                    unitbase = "Base Unit";

                    M1 = "The Saving Successed";
                    M2 = "The Saving Faild";
                } else {

                    saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
                    align = "center";
                    dir = "RTL";
                    style = "text-align:Right";
                    lang = "English";
                    title_1 = "&#1608;&#1581;&#1583;&#1577; &#1602;&#1610;&#1575;&#1587; &#1580;&#1583;&#1610;&#1583;&#1607;";
                    title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
                    cancel_button_label = "عودة إلي القائمة ";
                    submit_button_label = "تحديث ";
                    langCode = "En";
                    Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";

                    name_ar = "الإسم العربي ";
                    name_en = "الإسم الإنجليزي  ";
                    unit_system = " نظام الوحدة";
                    unitbase = " الوحدة الرئيسية";

                    M1 = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581; ";
                    M2 = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
                }
                String doubleName = (String) request.getAttribute("name");
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>DebugTracker-add new function area</TITLE>
        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            function submitForm() {
                if (!validateData("req", document.MeasuermentUnit_form.unitbase, "Please, enter measuerment unit Base.") ){
                    document.MeasuermentUnit_form.unitbase.focus();
                } else if (!validateData("req", document.MeasuermentUnit_form.arabicname, "Please, enter measuerment unit arabic name.") ){
                    document.MeasuermentUnit_form.arabicname.focus();
                } else if (!validateData("req", document.MeasuermentUnit_form.englishname, "Please, enter measuerment unit english name.") ){
                    document.MeasuermentUnit_form.englishname.focus();
                } else if (!validateData("req", document.MeasuermentUnit_form.unitsystem, "Please, enter measuerment unit system.") ){
                    document.MeasuermentUnit_form.unitsystem.focus();
                } else {
                    document.MeasuermentUnit_form.action = "<%=context%>/MeasurementUnitsServlet?op=saveUpdateUnit";
                    document.MeasuermentUnit_form.submit();
                }
            }
        </script>
    </HEAD>
    <body>
        <form NAME="MeasuermentUnit_form" action="" METHOD="POST">

            <DIV align="left" STYLE="color:blue;">
                <input type="button" onclick="JavaScript: cahangePage('<%=context%>/MeasurementUnitsServlet?op=ListMeasuerUnits');" class="button" value="<%=cancel_button_label%>" />
                <input type="button" onclick="JavaScript:  submitForm();" class="button"value="<%=submit_button_label%>" />
            </DIV>
            <fieldset class="set" style="border-color: #006699; width: 95%">
                <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><Font color='white' SIZE="+1"><%=title_1%></Font>
                        </td>
                    </tr>
                </table>
                <%if (null != status) {%>
                <%
                    if (status.equalsIgnoreCase("ok")) {
                        message = M1;
                    } else {
                        message = M2;
                    }
                %>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>
                        <td class="td">
                            <font size=4 ><%=message%></font>
                        </td>
                    </tr>
                </table>
                <%}%>
                <%if (null != doubleName) {%>
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font size=4 > <%=Dupname%> </font>
                        </td>
                    </tr>
                </table>
                <%}%>
                <table align="<%=align%>" dir=<%=dir%>>
                    <TR ALIGN="<%=align%>">
                        <TD STYLE="<%=style%>" class='td'>
                            <FONT color='red' size='+1'><%=title_2%></FONT>
                        </TD>
                    </TR>
                </table>
                <br /><br />
                <table style="margin-bottom: 20px; margin-top: 20px" ALIGN="center"  dir="<%=dir%>" border="0" width="50%" cellpadding="4" cellspacing="2" >
                    <tr onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <td title="<%=unitbase%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag" nowrap><%=unitbase%></td>
                        <td style="<%=style%>" class="td2 blackFont fontInput" id="CellData">
                            <input class="blackFont fontInput" type="TEXT" name="unitbase" ID="unitbase" size="33" value="<%=data.getAttribute("Base").toString()%>"  maxlength="20">
                            <input type="hidden" name="id" ID="id" value="<%=data.getAttribute("id").toString()%>"  />
                        </td>
                    </tr>
                    <tr onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <td title="<%=name_ar%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag" nowrap><%=name_ar%></td>
                        <td style="<%=style%>" class="td2 blackFont fontInput" id="CellData">
                            <input class="blackFont fontInput" type="TEXT" name="arabicname" ID="arabicname" size="33" value="<%=data.getAttribute("arabicUnitName").toString()%>"  maxlength="20">
                        </td>
                    </tr>
                    <tr onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <td  title="<%=name_en%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag" nowrap><%=name_en%></td>
                        <td style="<%=style%>" class="td2 blackFont fontInput" id="CellData">
                            <input class="blackFont fontInput" type="TEXT" name="englishname" ID="englishname" size="33" value="<%=data.getAttribute("englishUnitName").toString()%>"  maxlength="20">
                        </td>
                    </tr>
                    <tr onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <td title="<%=unit_system%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag" nowrap><%=unit_system%></td>
                        <td style="<%=style%>" class="td2 blackFont fontInput" id="CellData">
                            <input class="blackFont fontInput" type="TEXT" name="unitsystem" ID="unitsystem" size="33" value="<%=data.getAttribute("SYSTEM").toString()%>"  maxlength="20">
                        </td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </body>
</html>
