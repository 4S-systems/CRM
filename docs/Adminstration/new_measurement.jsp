<%@page import="java.util.Map.Entry"%>
<%@page import="com.maintenance.db_access.MeasurementUnitsMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<html>
    <%
                String status = (String) request.getAttribute("status");

                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                String context = metaMgr.getContext();
                TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");


                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;
                String align = null;
                String dir = null;
                String style = null;
                String lang, langCode;

                MeasurementUnitsMgr unitsMgr = MeasurementUnitsMgr.getInstance();
                ArrayList measurementUnits = unitsMgr.getAllAsArrayList();
                Map<String, String> frequencyAr = new HashMap<String, String>();
                Map<String, String> frequencyEn = new HashMap<String, String>();
                Map<String, String> frequency = new HashMap<String, String>();

                frequencyEn.put("mech", "Mechanic Equipment");
                frequencyEn.put("elct", "Electrical Equipment");
                frequencyEn.put("telc", "Telecommunication and Controls");
                frequencyEn.put("hous", "Housing units");
                frequencyEn.put("uehe", "Unit Environment and Health Engineering");

                frequencyAr.put("mech", "معدة ميكانيكية");
                frequencyAr.put("elct", "معدة كهربائية");
                frequencyAr.put("telc", "إتصالات وتحكم");
                frequencyAr.put("hous", "وحدة سكنية");
                frequencyAr.put("uehe", "وحدة بيئة هندسة صحية");

                String saving_status, Dupname;
                String title_1, title_2;
                String cancel_button_label, M1, M2, message = "";
                String save_button_label, arDescLable, enDescLable, codeLable, minAllowLable, maxAllowLable,
                        action_Taken_Before_AllowLable, action_Taken_Above_AllowLable, frequencyLable, measurementUnitLable;
                String displayName = "arabicUnitName";
                if (stat.equals("En")) {

                    saving_status = "Saving status";
                    align = "center";
                    dir = "LTR";
                    style = "text-align:left";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    title_1 = "New Measurement Unit";
                    title_2 = "All information are needed";
                    cancel_button_label = "Cancel ";
                    save_button_label = "Save ";
                    langCode = "Ar";
                    Dupname = "Name is Duplicated Chane it";

                    arDescLable = "Arabic Name ";
                    enDescLable = "English Name ";
                    codeLable = "Code ";
                    minAllowLable = "Min allow ";
                    maxAllowLable = "Max allow ";
                    action_Taken_Before_AllowLable = "Action taken before allow ";
                    action_Taken_Above_AllowLable = "Action taken above allow ";
                    frequencyLable = "Frequency ";
                    measurementUnitLable = "Measurement unit ";
                    /*
                     *
                     *
                    arDesc
                    enDesc
                    code
                    minAllow
                    maxAllowLable
                    action_Taken_Before_AllowLable
                    action_Taken_Above_AllowLable
                    frequencyLable
                    measurementUnitLable
                     * */
                    M1 = "The Saving Successed";
                    M2 = "The Saving Faild";

                    displayName = "englishUnitName";
                     frequency = frequencyEn;
                } else {

                    saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
                    align = "center";
                    dir = "RTL";
                    style = "text-align:Right";
                    lang = "English";
                    title_1 = "&#1608;&#1581;&#1583;&#1577; &#1602;&#1610;&#1575;&#1587; &#1580;&#1583;&#1610;&#1583;&#1607;";
                    title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
                    cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569; ";
                    save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
                    langCode = "En";
                    Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";

                    arDescLable = "الإسم العربي ";
                    enDescLable = "الإسم الإنجليزي  ";
                    codeLable = "الكود ";
                    minAllowLable = "الحد الأدني  ";
                    maxAllowLable = "الحد الأقصي  ";
                    action_Taken_Before_AllowLable = "رد الفعل في حالة تجاوز الحد الأدني المسموح  ";
                    action_Taken_Above_AllowLable = "رد الفعل في حالة تجاوز الحد الأقصي المسموح ";
                    frequencyLable = "Frequency ";
                    measurementUnitLable = "وحدة القياس ";

                    M1 = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581; ";
                    M2 = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
                    displayName = "arabicUnitName";
                    frequency = frequencyAr;
                }
                String doubleName = (String) request.getAttribute("name");
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>DebugTracker-add new function area</TITLE>
        <script LANGUAGE="JavaScript" TYPE="text/javascript">

            function submitForm()
            {

                if (!validateData("req", document.Measuerment_form.arDesc, "Please, enter measuerment unit arabic name.") ){
                    document.Measuerment_form.arDesc.focus();
                }else if (!validateData("req", document.Measuerment_form.enDesc, "Please, enter measuerment unit english name.") ){
                    document.Measuerment_form.enDesc.focus();
                }else if (!validateData("req", document.Measuerment_form.code, "Please, enter measuerment Code.") ){
                    document.Measuerment_form.code.focus();
                }else if (!validateData("req", document.Measuerment_form.frequency, "Please, enter measuerment frequency.") ){
                    document.Measuerment_form.frequency.focus();
                }else if (!validateData("req", document.Measuerment_form.measurementUnitId, "Please, enter measuerment unit.") ){
                    document.Measuerment_form.measurementUnitId.focus();
                }else if (!validateData("req", document.Measuerment_form.minAllow, "Please, enter measuerment min allow.") ){
                    document.Measuerment_form.minAllow.focus();
                }else if (!validateData("req", document.Measuerment_form.maxAllow, "Please, enter measuerment max allow.") ){
                    document.Measuerment_form.maxAllow.focus();
                }else if (!validateData("req", document.Measuerment_form.action_Taken_Before_Allow, "Please, enter measuerment action taken before allow.") ){
                    document.Measuerment_form.action_Taken_Before_Allow.focus();
                }else if (!validateData("req", document.Measuerment_form.action_Taken_Above_Allow, "Please, enter measuerment action taken above allow.") ){
                    document.Measuerment_form.action_Taken_Above_Allow.focus();
                }else
                {
                    
                    document.Measuerment_form.action = "<%=context%>/MeasurementsServlet?op=SaveMeasurement";
                    document.Measuerment_form.submit();
                }
            }

            function cancelForm() {
                document.Measurements_Form.action = "main.jsp";
                document.Measurements_Form.submit();
            }

        </script>
    </HEAD>
    <body>

        <form NAME="Measuerment_form" action="" METHOD="POST">

            <DIV align="left" STYLE="color:blue;">
                <input type="button" onclick="JavaScript: cancelForm();" class="button" value="<%=cancel_button_label%>" />
                <input type="button" onclick="JavaScript:  submitForm();" class="button"value="<%=save_button_label%>" />
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
                        <td title="<%=arDescLable%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag" nowrap><%=arDescLable%></td>
                        <td style="<%=style%>" class="td2 blackFont fontInput" id="CellData">
                            <input class="blackFont fontInput" type="TEXT" name="arDesc" ID="arDesc" size="33" value=""  maxlength="20">
                        </td>
                    </tr>
                    <tr onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <td  title="<%=enDescLable%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag" nowrap><%=enDescLable%></td>
                        <td style="<%=style%>" class="td2 blackFont fontInput" id="CellData">
                            <input class="blackFont fontInput" type="TEXT" name="enDesc" ID="enDesc" size="33" value=""  maxlength="20">
                        </td>
                    </tr>
                    <tr onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <td title="<%=codeLable%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag" nowrap><%=codeLable%></td>
                        <td style="<%=style%>" class="td2 blackFont fontInput" id="CellData">
                            <input class="blackFont fontInput" type="TEXT" name="code" ID="code" size="33" value=""  maxlength="20">
                        </td>
                    </tr>
                    <tr onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <td title="<%=frequencyLable%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag" nowrap><%=frequencyLable%></td>
                        <td style="<%=style%>" class="td2 blackFont fontInput" id="CellData">
                            <select style="width: 100%; height: 30px; font: 15px; font-weight: bold;" name="frequency" ID="frequency">
                                <%for (Entry<String, String> entry : frequency.entrySet()) {%>
                                <option value="<%=entry.getKey()%>"><%=entry.getValue()%></option>
                                <%}%>
                            </select>
                        </td>
                    </tr>
                    <tr onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <td title="<%=measurementUnitLable%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag" nowrap><%=measurementUnitLable%></td>
                        <td style="<%=style%>" class="td2 blackFont fontInput" id="CellData">
                            <select name="measurementUnitId" id="measurementUnitId" style="width: 100%; height: 30px; font: 15px; font-weight: bold;">
                                <sw:WBOOptionList wboList='<%=measurementUnits%>' scrollTo="" displayAttribute="<%=displayName%>" valueAttribute="id"/>
                            </select>
                        </td>
                    </tr>
                    <tr onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <td title="<%=minAllowLable%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag" nowrap><%=minAllowLable%></td>
                        <td style="<%=style%>" class="td2 blackFont fontInput" id="CellData">
                            <input class="blackFont fontInput" type="TEXT" name="minAllow" ID="minAllow" size="33" value=""  maxlength="20">
                        </td>
                    </tr>
                    <tr onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <td title="<%=maxAllowLable%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag" nowrap><%=maxAllowLable%></td>
                        <td style="<%=style%>" class="td2 blackFont fontInput" id="CellData">
                            <input class="blackFont fontInput" type="TEXT" name="maxAllow" ID="maxAllow" size="33" value=""  maxlength="20">
                        </td>
                    </tr>
                    <tr onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <td title="<%=action_Taken_Before_AllowLable%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag" nowrap><%=action_Taken_Before_AllowLable%></td>
                        <td style="<%=style%>" class="td2 blackFont fontInput" id="CellData">
                            <input class="blackFont fontInput" type="TEXT" name="action_Taken_Before_Allow" ID="action_Taken_Before_Allow" size="33" value=""  maxlength="20">
                        </td>
                    </tr>
                    <tr onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                        <td title="<%=action_Taken_Above_AllowLable%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag" nowrap><%=action_Taken_Above_AllowLable%></td>
                        <td style="<%=style%>" class="td2 blackFont fontInput" id="CellData">
                            <input class="blackFont fontInput" type="TEXT" name="action_Taken_Above_Allow" ID="action_Taken_Above_Allow" size="33" value=""  maxlength="20">
                        </td>
                    </tr>
                </table>
            </fieldset>
        </form>
    </body>
</html>
