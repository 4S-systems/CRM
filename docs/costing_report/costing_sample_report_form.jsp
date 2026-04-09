<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.maintenance.common.ConfigFileMgr" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<HTML>
    <%
                TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                String context = metaMgr.getContext();

//get session logged user and his trades
                WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

// get current date
                Calendar cal = Calendar.getInstance();
                String jDateFormat = user.getAttribute("javaDateFormat").toString();
                SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
                String nowTime = sdf.format(cal.getTime());

                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;

                String lang, langCode, dir, back, align, beginDate, unit, endDate, search, cancel, calenderTip,
                        emrgancy, notEmergancy, title, select, both, orderingJobOrder, acs, desc;

                if (stat.equals("En")) {
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    langCode = "Ar";
                    back = "Back";
                    align = "left";
                    dir = "LTR";
                    unit = "Unit";
                    beginDate = "From Date";
                    endDate = "To Date";
                    search = "Export Report";
                    cancel = "Cancel";
                    calenderTip = "click inside text box to opn calender window";
                    emrgancy = "Maintenance of Emergency";
                    notEmergancy = "Periodic Maintenance";
                    title = "Costing Report";
                    select = "Select";
                    both = "Both";
                    orderingJobOrder = "Ordering Job Order";
                    acs = "Ascending";
                    desc = "Descending";
                } else {
                    lang = "English";
                    langCode = "En";
                    back = "&#1585;&#1580;&#1608;&#1593;";
                    align = "right";
                    dir = "RTL";
                    unit = "&#1605;&#1593;&#1583;&#1577;";
                    beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
                    endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
                    search = "&#1575;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
                    calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
                    cancel = tGuide.getMessage("cancel");
                    emrgancy = "&#1589;&#1610;&#1575;&#1606;&#1577; &#1591;&#1575;&#1585;&#1574;&#1577;";
                    notEmergancy = "&#1589;&#1610;&#1575;&#1606;&#1577; &#1583;&#1608;&#1585;&#1610;&#1577;";
                    select = "&#1575;&#1582;&#1578;&#1610;&#1575;&#1585;";
                    title = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1600;&#1600;&#1578;&#1600;&#1600;&#1603;&#1600;&#1600;&#1604;&#1600;&#1600;&#1601;&#1600;&#1600;&#1577;";
                    both = "&#1575;&#1604;&#1600;&#1600;&#1603;&#1600;&#1600;&#1604;";
                    orderingJobOrder = "&#1578;&#1600;&#1585;&#1578;&#1600;&#1610;&#1600;&#1576; &#1571;&#1608;&#1575;&#1605;&#1600;&#1585; &#1575;&#1604;&#1600;&#1588;&#1600;&#1594;&#1600;&#1604;";
                    acs = "&#1578;&#1589;&#1575;&#1593;&#1583;&#1609;";
                    desc = "&#1578;&#1606;&#1575;&#1586;&#1604;&#1609;";
                }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
        <script type='text/javascript' src='js/ChangeLang.js'></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_centerwindow.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <script type="text/javascript" src="js/tip_followscroll.js"></script>
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        var dp_cal1,dp_cal12,sitesValues = "";
        window.onload = function () {
            dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
            dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
        }

        function submitForm()
        {
            var beginDate = document.getElementById('beginDate').value;
            var endDate = document.getElementById('endDate').value;
            var unitId = document.getElementById('unitId').value;
            var unitName = document.getElementById('unitName').value;
            var issueTitle = getValueRadioButton('issueTitle');
            var orderBy = getValueRadioButton('orderBy');
            if (!compareDate()){
                alert('End Date must be greater than or equal Begin Date');
                return;
            }
            var url = "<%=context%>/PDFReportServlet?op=SampleCostingReports&beginDate=" + beginDate + "&endDate=" + endDate + "&unitId=" + unitId + "&unitName=" + unitName + "&issueTitle=" + issueTitle + "&orderBy=" + orderBy;
            openWindow(url);
        }

        function getValueRadioButton(id) {
            var redios = document.getElementsByName(id);
            for(var i = 0; i < redios.length; i++) {
                if(redios[i].checked) {
                    return redios[i].value;
                    break;
                }
            }
            return "";
        }

        function cancelForm()
        {
            document.REPORT_COSTING_FORM.action = "<%=context%>/main.jsp;";
            document.REPORT_COSTING_FORM.submit();
        }

        function back() {
            document.REPORT_COSTING_FORM.action = "<%=context%>/<%=request.getParameter("filterName")%>?op=<%=request.getParameter("filterValue")%>";
            document.REPORT_COSTING_FORM.submit();
        }

        function compareDate() {
            return Date.parse(document.getElementById("endDate").value) >= Date.parse(document.getElementById("beginDate").value);
        }

        function textChange(textBox){
            document.getElementById(textBox).value = "";
        }

        function getUnit() {
            var formName = document.getElementById('REPORT_COSTING_FORM').getAttribute("name");
            var name = document.getElementById('unitName').value;
            var res = getASSCIChar(name);
            openWindow('SelectiveServlet?op=listEquipmentsAndViewEquipment&unitName='+res+'&formName='+formName);
        }

        function openWindow(url)
        {
            window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
        }

        function trim(str) {
            return str.replace(/^\s+|\s+$/g,"");
        }


    </SCRIPT>

    <style type="css/text" >
        .backStyle{
            border-bottom-width:0px;
            border-left-width:0px;
            border-right-width:0px;
            border-top-width:0px
        }
    </style>
    <BODY STYLE="background-color:#E4E4E4">
        <FORM action=""  NAME="REPORT_COSTING_FORM" METHOD="POST">
            <DIV DIR="LTR" style="padding-left:50px;padding-right:50px" >
                <input type="button" style="font-size:15px;color:white;font-weight:bold"  value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button onclick="JavaScript:back();" class="button" style="font-size:15px;color:white;font-weight:bold"><%=back%></button>
            </DIV>
            <br>
            <CENTER>
                <fieldset class="set" style="border-color:teal">
                    <legend align="center" >
                        <table dir="rtl" align="center">
                            <tr>
                                <td class="td">
                                    <font color="blue" style="font-weight:bold;font-size:22px"><%=title%></font>
                                </td>
                            </tr>
                        </table>
                    </legend>
                    <TABLE ALIGN="center" DIR="<%=dir%>" WIDTH="83%" CELLSPACING=0 CELLPADDING=0 BORDER="0">
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD BGCOLOR="#989898" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="blue"><%=unit%></font></b>
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4"  valign="MIDDLE" >
                                <input type="text" name="unitName" id="unitName" onchange="JavaScript:textChange('unitId')" style="width:180px;text-align:center" />
                                <input class="button" type="button" name="search" id="search" value="<%=select%>" onclick="JavaScript:getUnit();" STYLE="font-size:15;color:white;font-weight:bold;width:60px" />
                                <input type="hidden" name="unitId" id="unitId" />
                            </TD>
                            <TD  BGCOLOR="#989898" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="15%">
                                <b><font size=3 color="blue"><%=beginDate%></font></b>
                            </TD>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4"  valign="MIDDLE" >
                                <input readonly id="beginDate" name="beginDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" >
                            </TD>
                        </TR>
                        <TR>
                            <TD colspan="3" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD BGCOLOR="#989898"  STYLE="border-left-WIDTH:1px;text-align:center;" WIDTH="15%">
                                <b> <font size=3 color="blue"><%= endDate%></font> </b>
                            </TD>
                            <td  bgcolor="#E4E4E4"  style="text-align:center;padding:5px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="middle">
                                <input readonly id="endDate" name="endDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" >
                            </td>
                        </TR>

                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>

                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4"  valign="MIDDLE">
                                &ensp;
                            </TD>
                            <TD DIR="<%=dir%>" style="text-align:<%=align%>;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4" COLSPAN="3" >
                                <%=notEmergancy%><input type="radio" name="issueTitle" id="issueTitle" value="notEmergency" />
                                &ensp;
                                <%=emrgancy%><input type="radio" name="issueTitle" id="issueTitle" value="Emergency" />
                                &ensp;
                                <%=both%><input type="radio" name="issueTitle" id="issueTitle" checked value="both" />
                            </TD>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4"  valign="MIDDLE">
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4"  valign="MIDDLE" >
                                &ensp;
                            </TD>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4"  valign="MIDDLE" colspan="2">
                                <hr style="width: 100%;color: black;border-color: black" />
                            </TD>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4"  valign="MIDDLE" colspan="2">
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4"  valign="MIDDLE" >
                                &ensp;
                            </TD>
                            <TD CLASS="backStyle" style="text-align:<%=align%>;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4"  valign="MIDDLE" colspan="2">
                                <%=orderingJobOrder%>
                                &ensp;
                                <%=acs%><input type="radio" name="orderBy" id="ordering" value="asc" />
                                &ensp;
                                <%=desc%><input type="radio" name="orderBy" id="ordering" value="desc" checked />
                            </TD>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4"  valign="MIDDLE" colspan="2">
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4"  valign="MIDDLE" COLSPAN="3" >
                                &ensp;
                            </TD>
                            <TD STYLE="text-align:center" CLASS="td" colspan="2" bgcolor="#E4E4E4">
                                <br>
                                <button class="button"  onclick="JavaScript: submitForm();" STYLE="font-size:15px;color:white;font-weight:bold;width: 120px">   <%=search%><IMG HEIGHT="15" SRC="images/search.gif"> </button>
                                &ensp;
                                <button class="button"  onclick="JavaScript: back();" STYLE="font-size:15px;color:white;font-weight:bold;width: 120px"> <%=cancel%>  <IMG HEIGHT="15" SRC="images/cancel.gif"></button>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E4E4E4"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <br>
                </fieldset>
            </CENTER>
        </FORM>
    </BODY>
</HTML>
