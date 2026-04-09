<%-- 
    Document   : search_maint_on_cost_centers
    Created on : Jan 15, 2012, 10:36:17 AM
    Author     : khaled abdo
--%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.maintenance.common.ConfigFileMgr" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">

<html>
     <%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        // get all need data
        ArrayList allSites = (ArrayList) request.getAttribute("allSites");

        //get session logged user and his trades
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

        // get current defaultLocationName
        String defaultLocationName = (String) request.getAttribute("defaultLocationName");

        // get current date
        Calendar cal = Calendar.getInstance();
        String jDateFormat = user.getAttribute("javaDateFormat").toString();
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String nowTime = sdf.format(cal.getTime());

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;

        String item, beginDate, task, endDate, search, cancel, others, calenderTip, tradeName, nameEquip, mainType, site, divAlign,
                dir, lang, langCode, fromMaintTo, fMaintNum, tMaintNum, title, selectAll, select, back, laborDetailed, maintenance, emrgancy, notEmergancy, brand;

        String ASCLabel, DESCLabel, actualBeginDateLabel, actualEndDateLabel, textAlign, issueTitleLabel, currentStausLabel, orderByLabel, dateTypeLabel, moreOptionsLabel,pageTitle, doc;
        String compareDateMsg , beginDateMsg, endDateMsg;

        String defSite;
        String selectByCode, selectByName;
        String costNameField,costCenterLabel, costCenterMsg, costCenterEmpMsg;
        if (stat.equals("En")) {
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            laborDetailed = "With Labor Detail";
            dir = "LTR";
            divAlign = "left";
            task = "Task";
            item = "Item";
            beginDate = "From Actual Begin Date";
            endDate = "To Actual Begin Date";
            search = "Export Report";
            cancel = "Cancel";
            others = "Advanced Search";
            calenderTip = "click inside text box to opn calender window";
            tradeName = "Maintenance Type";
            nameEquip = "By Equipment";
            site = "Site";
            mainType = "By Main Type";
            brand = "By Brand";
            fMaintNum = "From";
            tMaintNum = "To";
            fromMaintTo = "From Maint Num To Maint Num";
            title = "Maintenance Cost Centers Report";
            selectAll = "All";
            select = "Select";
            back = "Back";
            maintenance = "Maintenance";
            emrgancy = "Emergency";
            notEmergancy = "Periodic";
            ASCLabel = "ASC";
            DESCLabel = "DESC";
            actualBeginDateLabel = "Begin Date";
            actualEndDateLabel = "End Date";
            issueTitleLabel = "Issue Title";
            currentStausLabel = "Current Status";
            orderByLabel = "Order By";
            dateTypeLabel = "Date Type";
            moreOptionsLabel = "More Options";
            pageTitle = "Report Code: M_COST_CENTERS_1";
            doc = "View Details";
            compareDateMsg = "End Actual End Date must be greater than or equal start actual Begin Date";
            endDateMsg = "End Actual End Date must be less than or equal today Date";
            beginDateMsg = "Strat Actual Begin Date must be less than or equal today Date";
            defSite = "Default Site";
            selectByCode = "Select By Code";
            selectByName = "Select By Name";
            costNameField = "LATIN_NAME";
            costCenterLabel = "Cost Center";
            costCenterMsg = "This Spare Part Already Distributed with the same Cost Center";
            costCenterEmpMsg = "Please Enter Cost Center";
        } else {
            lang = "   English    ";
            langCode = "En";
            laborDetailed = "&#1576;&#1600;&#1600; &#1578;&#1601;&#1589;&#1610;&#1604; &#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;";
            dir = "RTL";
            divAlign = "right";
            task = "&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577;";
            item = "&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
            beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
            endDate = "&#1573;&#1604;&#1610; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
            search = "&#1575;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
            cancel = tGuide.getMessage("cancel");
            calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
            others = "&#1576;&#1581;&#1600;&#1600;&#1579; &#1605;&#1600;&#1578;&#1600;&#1602;&#1600;&#1583;&#1605;";
            tradeName = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
            site = "&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
            mainType = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1606;&#1600;&#1600;&#1608;&#1593; &#1585;&#1574;&#1610;&#1600;&#1600;&#1587;&#1609;";
            brand = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1605;&#1600;&#1600;&#1600;&#1575;&#1585;&#1603;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1577;";
            nameEquip = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1605;&#1600;&#1600;&#1600;&#1600;&#1593;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1583;&#1577;";
            fMaintNum = "&#1605;&#1606;";
            tMaintNum = "&#1575;&#1604;&#1609;";
            fromMaintTo = "&#1605;&#1606; &#1585;&#1602;&#1605; &#1589;&#1610;&#1575;&#1606;&#1577; &#1575;&#1604;&#1609; &#1585;&#1602;&#1605; &#1589;&#1610;&#1575;&#1606;&#1577;";
            selectAll = "&#1603;&#1600;&#1600;&#1600;&#1604;";
            select = "&#1575;&#1582;&#1578;&#1610;&#1575;&#1585;";
            back = "&#1585;&#1580;&#1608;&#1593;";
            title = "تقرير الصيانة علي مراكز التكلفة";
            maintenance = "&#1589;&#1610;&#1575;&#1606;&#1577;";
            emrgancy = "&#1591;&#1575;&#1585;&#1574;&#1577;";
            notEmergancy = "&#1583;&#1608;&#1585;&#1610;&#1577;";
            ASCLabel = "&#1578;&#1589;&#1575;&#1593;&#1583;&#1610;";
            DESCLabel = "&#1578;&#1606;&#1575;&#1586;&#1604;&#1610;";
            actualBeginDateLabel = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
            actualEndDateLabel = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1573;&#1606;&#1578;&#1607;&#1575;&#1569; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;";
            issueTitleLabel = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1588;&#1603;&#1604;&#1577;";
            currentStausLabel = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
            orderByLabel = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1578;&#1585;&#1578;&#1610;&#1576;";
            dateTypeLabel = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
            moreOptionsLabel = "&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1571;&#1582;&#1585;&#1610;";
            pageTitle = "Report Code: M_COST_CENTERS_1";
            doc = "&#1593;&#1585;&#1590; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
            compareDateMsg = "  \u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0643\u0628\u0631 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A";
            endDateMsg = "\u0646\u0647\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
            beginDateMsg = "\u0628\u062F\u0627\u064A\u0629 \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0642\u0644 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u064A\u0648\u0645";
            defSite = "&#1575;&#1604;&#1605;&#1608;&#1602;&#1593; &#1575;&#1604;&#1573;&#1601;&#1578;&#1585;&#1575;&#1590;&#1610;";
            selectByCode = "بحث بالكود";
            selectByName = "بحث بالإسم";

            costNameField = "COSTNAME";
            costCenterLabel = "&#1605;&#1585;&#1603;&#1586; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577;";
            costCenterMsg = "\u0647\u0630\u0647 \u0627\u0644\u0645\u0639\u062F\u0629 \u062A\u0645 \u062A\u0648\u0632\u064A\u0639\u0647\u0627 \u0645\u0646 \u0642\u0628\u0644 \u0645\u0639 \u0646\u0641\u0633 \u0645\u0631\u0643\u0632 \u0627\u0644\u062A\u0643\u0644\u0641\u0629";
            costCenterEmpMsg = "\u0627\u0644\u0631\u062C\u0627\u0621 \u0625\u062F\u062E\u0627\u0644 \u0645\u0631\u0643\u0632 \u0627\u0644\u062A\u0648\u0632\u064A\u0639";
        }
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <meta HTTP-EQUIV="Expires" CONTENT="0">
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <link rel="stylesheet" type="text/css" href="css/tree_css.css" />
        <script type="text/javascript" src="js/getEquipmentsList.js"></script>
        <script type="text/javascript" src="js/epoch_classes.js"></script>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="js/silkworm_validate.js"></script>
        <script type="text/javascript" src="js/getEquipmentsList.js"></script>
        <script type="text/javascript" src="js/tree_docs_js.js"></script>

       <script LANGUAGE="JavaScript" TYPE="text/javascript">

        var dp_cal1 = null;
        var dp_cal2 = null;
        var chaild_window;
        var sitesValues = "";
        window.onload = function (){
            if(dp_cal1 == null && dp_cal2 == null) {
                dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
                dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
            }
        }
        function submitForm(){
            if(Date.parse(document.getElementById("beginDate").value) > Date.parse('<%=nowTime%>')){
                alert('<%=beginDateMsg%>');
                document.SEARCH_MAINTENANCE_FORM.beginDate.focus();
                return false;
            } else if(Date.parse(document.getElementById("endDate").value) > Date.parse('<%=nowTime%>')){
                alert('<%=endDateMsg%>');
                document.SEARCH_MAINTENANCE_FORM.endDate.focus();
                return false;
            } else if (!compareDate()){
                alert('<%=compareDateMsg%>');
                document.SEARCH_MAINTENANCE_FORM.endDate.focus();
                return false;
            } else if(document.getElementById('site').value == ""){
                alert("please select site");
                document.SEARCH_MAINTENANCE_FORM.maintype.focus();
                return false;
            }
            document.SEARCH_MAINTENANCE_FORM.action = "CostCentersServlet?op=resultMaintOnCostCenters";

            open_Window('');
            document.SEARCH_MAINTENANCE_FORM.target="window_chaild";
            document.SEARCH_MAINTENANCE_FORM.submit();
        }
        function open_Window(url)
        {
            var openedWindow = window.open(url,"window_chaild","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
            openedWindow.focus();

        }
    </script>
    </HEAD>
   <BODY STYLE="background-color:#E8E8E8">
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_centerwindow.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <script type="text/javascript" src="js/tip_followscroll.js"></script>
        <FORM NAME="SEARCH_MAINTENANCE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;padding-left: 5%; padding-bottom: 10px">
                <button  onclick="JavaScript: getFormDetails('TRNS_JO_LBR_AVG_COST');" class="button"> <%=doc%></button>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="width:90%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="border-color: #006699;">
                        <TR>
                            <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;background-color: #ffcc66;" width="100%" class="blueBorder blueHeaderTD"><font color="#006699" size="4"><%=title%></font></TD>
                        </TR>
                    </TABLE>
                    <div style="text-align: left;">
                    <table>
                        <tr>
                            <td style="text-align: left;border: none;">
                                <font color="#FF385C" size="3" style="font-weight: bold;">
                                    <a id="mainLink"><%=pageTitle%> <img onmouseover="Tip('<%=title%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'bold', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=title%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()" width="30" height="25"  src="images/qm01.jpg" /></a>
                                </font>
                            </td>
                        </tr>
                    </table>
                    </div>
                    <br>
                    <TABLE id="Others" ALIGN="center" DIR="<%=dir%>" WIDTH="90%" CELLSPACING=5 CELLPADDING=0 BORDER="0" style="display: block;">
                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><%=costCenterLabel%></font></b>
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <input type='hidden' name='costCode' id='costCode' value='allCostCenters' />
                                <input type='text' name='costName' id='costName' value='<%=selectAll%>' readonly/>
                                <button id='btnSearch' value='' onclick="return getDataInPopup('AssignedIssueServlet?op=listCostCenters&fieldName=<%=costNameField%>&fieldValue=&formName=SPARE_PARTS_FORM&selectionType=single&rowIndex=');" ><img src='images/refresh.png' alt='Search' title='Search' align='middle' width='24' height='24' /></button>
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="15%">
                                <b><font size=3 color="black"><%= beginDate%></font></b>
                            </TD>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" >
                                <input readonly id="beginDate" name="beginDate" type="text" value="<%=nowTime%>" style="width:90%" /><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'black', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" />
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" ROWSPAN="2" STYLE="text-align:center;padding:5px" WIDTH="17%">
                                <b><font size=3 color="black"><%=site%></font></b>
                            </TD>
                            <TD ROWSPAN="2"STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="33%">
                                <input type="hidden" id="siteAll" value="no" name="siteAll" />
                                <select name="site" onchange="selectAllSites(this.id,'siteAll');" id="site" size="5" style="font-size:12px;font-weight:bold;width:100%; height: 100%; margin: 0px; display: block;">
                                    <option value="selectAll" style="color:#989898;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                    <sw:WBOOptionList wboList="<%=allSites%>" displayAttribute="projectName" valueAttribute="projectID" scrollTo="<%=defaultLocationName%>" />
                                </select>
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;" WIDTH="15%">
                                <b> <font size=3 color="black"><%= endDate%></font> </b>
                            </TD>
                            <TD  style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="middle">
                                <input readonly id="endDate" name="endDate" type="text" value="<%=nowTime%>" style="width:90%" /><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'black', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" />
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <%--<TR>
                            <TD DIR="<%=dir%>" style="text-align:<%=divAlign%>;padding-<%=divAlign%> : 5%;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px"  valign="MIDDLE" COLSPAN="3" >
                                <%=maintenance%>
                                <font color="red">(</font>
                                <%=notEmergancy%><input type="radio" name="issueTitle" id="issueTitle" checked value="notEmergency" />
                                &ensp;
                                <%=emrgancy%><input type="radio" name="issueTitle" id="issueTitle" checked value="Emergency" />
                                &ensp;
                                <%=selectAll%><input type="radio" name="issueTitle" id="issueTitle" checked value="both" />
                                <font color="red">)</font>
                            </TD>
                            <TD style="text-align:<%=divAlign%>;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px"  valign="MIDDLE" colspan="2">
                                &nbsp;
                            </TD>
                        </TR>--%>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor=""  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD colspan="5" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor=""  valign="MIDDLE" WIDTH="2%">
                                <div id="dropDown">
                                    <div onclick="JavaScript: changeMode('showHideTable');" id="showHide" style="text-align:<%=divAlign%>;"><img id="showHideImg" src="images/317e0s5.gif" /><%=moreOptionsLabel%></div>
                                    <div id="showHideTable" style="display: none; padding-bottom:5px;">
                                        <table ALIGN="center" DIR="<%=dir%>" WIDTH="100%" CELLSPACING=0 CELLPADDING=0 BORDER="0">
                                            <tr>
                                                <TD BGCOLOR="#989898" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                                    <b><font size=3 color="white"><%=orderByLabel%></font></b>
                                                </TD>
                                                <TD colspan="2" DIR="<%=dir%>" style="text-align:<%=divAlign%>;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#F8F8F8"  valign="MIDDLE" >
                                                    <input type="radio" name="orderType" id="orderType" checked value="ASC" /><%=ASCLabel%><br />
                                                    <input type="radio" name="orderType" id="orderType" value="DESC" /><%=DESCLabel%>
                                                </TD>
                                                <TD BGCOLOR="#989898" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                                    <b><font size=3 color="white"><%=dateTypeLabel%></font></b>
                                                </TD>
                                                <TD  DIR="<%=dir%>" style="text-align:<%=divAlign%>;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#F8F8F8"  valign="MIDDLE" >
                                                    <input type="radio" name="dateType" id="dateType" checked value="actual_begin_date" /><%=actualBeginDateLabel%><br />
                                                    <input type="radio" name="dateType" id="dateType" value="actual_end_date" /><%=actualEndDateLabel%>
                                                </TD>
                                            </tr>
                                        </table>
                                    </div>
                                </div>

                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <TABLE ALIGN="center" DIR="<%=dir%>" WIDTH="90%" CELLSPACING=10 CELLPADDING=0 BORDER="0" style="display: block;">
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px"  valign="MIDDLE" >
                                <button onclick="JavaScript: submitForm();" class="button" STYLE="font-size:15px;font-weight:bold; width: 150px"><%=search%></button>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>

