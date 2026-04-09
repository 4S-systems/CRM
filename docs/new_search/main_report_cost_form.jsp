<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <%

                int i = 0;
                String[] tabClass = {"", "", ""};
                String[] activeLink = {"", "", ""};
                int number = 0;
                String tab = (String) request.getSession().getAttribute("tabId");
                if (tab != null && !tab.equals("")) {
                    number = Integer.parseInt(tab);
                }
                if (number >= tabClass.length) {
                    number = 0;
                }

                String activeDiv = "tab_contents tab_contents_active";
                String nonActiveDiv = "tab_contents";
                String active = "active";

                if (tab != null && !tab.equals("")) {
                    for (i = 0; i < tabClass.length; i++) {
                        if (i == number) {
                            tabClass[i] = activeDiv;
                            activeLink[i] = active;
                        } else {
                            tabClass[i] = nonActiveDiv;
                            activeLink[i] = "";
                        }
                    }
                } else {
                    for (i = 0; i < tabClass.length; i++) {
                        if (i == 0) {
                            tabClass[i] = activeDiv;
                            activeLink[i] = active;
                        } else {
                            tabClass[i] = nonActiveDiv;
                            activeLink[i] = "";
                        }
                    }
                }
                TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;
                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                String context = metaMgr.getContext();
                String report;
                String dir;
                String lang, sCancel, langCode;
                String tabCostByAvg, jobOrdersWithLabor, tabJobOrdersWithLabor;
                String jobOrderWithAvgPrice, jobOrderWithAvgPriceTip, total, tabTotalCostByAvg, maintenanceOperationAnalysis, mainTypesReport, mainTypesReportTip;
                String maintOnCostCenters, maintOnCostCentersTip;

                if (stat.equals("En")) {
                    langCode = "Ar";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    sCancel = "Cancel";
                    dir = "left";
                    report = "Average Cost Reports";

                    tabCostByAvg = "Cost By Avrage Price";
                    jobOrdersWithLabor = "Job Orders Labor";
                    tabJobOrdersWithLabor = "View Job Orders With Labor";
                    jobOrderWithAvgPrice = "Internal Maintenance Cost";
                    jobOrderWithAvgPriceTip = "View Cost By Avrage Price Job Order";
                    maintenanceOperationAnalysis = "Maintenance Operation Analysis Report";
                    total = "Total Cost";
                    tabTotalCostByAvg = "Total Cost";
                    mainTypesReport = "Total Cost Report";
                    mainTypesReportTip = "Report For Total Cost ( Brand - Department - Unit - Production Line - Main Type ) ";

                    maintOnCostCenters = "Maint Report On Cost Centers";
                    maintOnCostCentersTip = "Maintenance Report On Cost Centers";


                } else {
                    langCode = "En";
                    sCancel = tGuide.getMessage("cancel");
                    lang = "English";
                    dir = "right";
                    report = "&#1578;&#1602;&#1575;&#1585;&#1610;&#1585; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577; &#1576;&#1575;&#1604;&#1605;&#1578;&#1608;&#1587;&#1591;";

                    tabCostByAvg = "&#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577; &#1576;&#1575;&#1604;&#1605;&#1578;&#1608;&#1587;&#1591;";
                    jobOrdersWithLabor = "&#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1576;&#1600;&#1600; &#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;";
                    tabJobOrdersWithLabor = "&#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577; &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1576;&#1600;&#1600; &#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;";

                    jobOrderWithAvgPrice = "تكلفة الصيانة الدخلية";
                    jobOrderWithAvgPriceTip = "&#1593;&#1585;&#1590; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577; &#1576;&#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1587;&#1593;&#1585; &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1576;&#1600;&#1600; &#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1571;&#1587;&#1593;&#1575;&#1585;";
                    maintenanceOperationAnalysis = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1578;&#1581;&#1604;&#1610;&#1604; &#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
                    total = "&#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1575;&#1580;&#1605;&#1575;&#1604;&#1610;&#1607;";
                    tabTotalCostByAvg = "&#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1575;&#1580;&#1605;&#1575;&#1604;&#1610;&#1607;";
                    mainTypesReport = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1573;&#1580;&#1605;&#1575;&#1604;&#1609;";
                    mainTypesReportTip = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1573;&#1580;&#1605;&#1575;&#1604;&#1609; &#1604;&#1600; &#1575;&#1604;&#1605;&#1575;&#1585;&#1603;&#1577; - &#1575;&#1604;&#1602;&#1587;&#1605; - &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; - &#1582;&#1591; &#1575;&#1604;&#1571;&#1606;&#1578;&#1575;&#1580; - &#1606;&#1608;&#1593; &#1585;&#1574;&#1610;&#1587;&#1610;";

                    maintOnCostCenters = "تقرير الصيانة علي مراكز التكلفة";
                    maintOnCostCentersTip = "تقرير الصيانة علي مراكز التكلفة";
         
                }


    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
        <script type="text/javascript" src="js/jquery-1.2.6.min.js"></script>

        <script type="text/javascript">
            function openWindow(url)
            {
                window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=yes, copyhistory=no, width=800, height=800");
            }



            function test(id){

                var url2 = "<%=context%>/ReportsServlet?op=setValueSession&tabId="+id;

                if (window.XMLHttpRequest) {
                    req = new XMLHttpRequest( );
                }
                else if (window.ActiveXObject) {
                    req = new ActiveXObject("Microsoft.XMLHTTP");
                }

                req.open("post",url2,true);
                req.send(null);
            }
            function reloadMainReport(nextMode)
            {
                document.ISSUE_FORM.action = "<%=context%>/ReportsServlet?op=getReloadPageByLang&key="+nextMode;
                document.ISSUE_FORM.submit();
            }

            function cancelForm()
            {
                document.ISSUE_FORM.action = "main.jsp";
                document.ISSUE_FORM.submit();
            }
        </script>

        <style type="text/css">
            /* create a button look for links */
            a#mainLink{
                background-color: #DFDFDF;
                border: solid 1px;
                border-color: #99f #039 #039 #99f;
                color:#000080;
                font-family: arial,sans-serif;
                font-size: 8pt;
                font-weight: bold;
                letter-spacing: 1px;
                padding: 3px;
                text-decoration: none;
                text-align: center;
                line-height: 1.5;
                width: 210;
                margin-right: 2px;
            }

            a#mainLink:hover
            {   background-color: #39c; color: white;}

        </style>

        <script type="text/javascript">
            // Load this script when page loads
            $(document).ready(function(){

                // Set up a listener so that when anything with a class of 'tab'
                // is clicked, this function is run.
                $('.tab').click(function () {

                    // Remove the 'active' class from the active tab.
                    $('#tabs_container > .tabs > li.active')
                    .removeClass('active');

                    // Add the 'active' class to the clicked tab.
                    $(this).parent().addClass('active');

                    // Remove the 'tab_contents_active' class from the visible tab contents.
                    $('#tabs_container > .tab_contents_container > div.tab_contents_active')
                    .removeClass('tab_contents_active');

                    // Add the 'tab_contents_active' class to the associated tab contents.
                    $(this.rel).addClass('tab_contents_active');

                });
            });
        </script>

        <style type="text/css">
            a:active {
                outline: none;
            }
            a:focus {
                -moz-outline-style: none;
            }
            #tabs_container {

                width: 400px;
                font-family: Arial, Helvetica, sans-serif;
                font-size: 15px;
            }
            #tabs_container ul.tabs {
                list-style: none;
                border-bottom: 1px solid #000000;
                height: 21px;
                margin: 0;
                width: 800px;
            }
            #tabs_container ul.tabs li {
                float: <%=dir%>;
            }
            #tabs_container ul.tabs li a {
                padding: 3px 10px;
                font-size:12px;
                font-weight:bold;
                display: block;
                border-left: 1px solid #000080;
                border-top: 1px solid #000080;
                border-right: 1px solid #000080;
                margin-right: 0px;
                text-decoration: none;
                background-color: #FFFACD;
            }
            #tabs_container ul.tabs li.active a {
                background-color: #FF9900;
                padding-top: 4px;
            }
            div.tab_contents_container {
                width: 800px;
                border: 1px solid #FFFFFF;
                border-top: none;
                padding: 10px;

            }
            div.tab_contents {

                display: none;
            }
            div.tab_contents_active {

                display: block;
            }
            div.clear {
                clear: both;
            }
            .fontStyle {
                font-weight: bold;
                font-size: 12px;
                color: black;
            }
        </style>

    </HEAD>
    <BODY>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>


        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <div style="padding-left: 10%">
                <input type="button" value="<%=lang%>" onclick="reloadMainReport('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%> 
                    <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"> </button> <br>
            </div>
            <br>
            <table align="center" width="80%">
                <tr><td class="td">
                        <fieldset style="border:solid 2px;;border-color:#000080;">
                            <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <tr>
                                    <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"><%=report%></FONT><BR></td>
                                </tr>
                            </table>
                            <br>
                            <br>
                            <!-- This is the box that all of the tabs and contents of
                            the tabs will reside -->
                            <div id="tabs_container" align="center">

                                <!-- These are the tabs -->
                                <ul class="tabs">
                                    <li class="<%=activeLink[0]%>"><a href="#" rel="#tab_0_contents" class="tab" onclick="javascript:test('0');"><%=tabCostByAvg%></a></li>
                                    <li class="<%=activeLink[1]%>"><a href="#" rel="#tab_1_contents" class="tab" onclick="javascript:test('1');"><%=tabTotalCostByAvg%></a></li>
                                    <li class="<%=activeLink[2]%>"><a href="#" rel="#tab_2_contents" class="tab" onclick="javascript:test('2');"><%=maintOnCostCenters%></a></li>
                                </ul>

                                <!-- This is used so the contents don't appear to the
                                     right of the tabs -->
                                <div class="clear" align="center"></div>

                                <!-- This is a div that hold all the tabbed contents -->
                                <div class="tab_contents_container" align="center">

                                    <!-- First Tab (Job Order)-->
                                    <div align="center" id="tab_0_contents" class="<%=tabClass[0]%>">
                                        <table dir="<%=dir%>">
                                            <tr>
                                                <td class="td">
                                                    <div align="center">
                                                        <a dir="<%=dir%>" id="mainLink" href="<%=context%>/ReportsServletThree?op=costJobOrderWithLabor&filterName=ReportsServletThree&filterValue=AvgCostReports" onmouseover="Tip('<%=tabJobOrdersWithLabor%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=jobOrdersWithLabor%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><font class="fontStyle"><%=jobOrdersWithLabor%></font></a>
                                                        <a id="mainLink" href="<%=context%>/ReportsServletThree?op=getCostByAvgJO&filterName=ReportsServletThree&filterValue=AvgCostReports" onmouseover="Tip('<%=jobOrderWithAvgPriceTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=jobOrderWithAvgPrice%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><font class="fontStyle"><%=jobOrderWithAvgPrice%></font></a>
                                                        <a id="mainLink" href="<%=context%>/ReportsServletThree?op=maintenanceTypesCost&filterName=ReportsServletThree&filterValue=AvgCostReports" onmouseover="Tip('<%=mainTypesReportTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=jobOrderWithAvgPrice%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><font class="fontStyle"><%=mainTypesReport%></font></a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>

                                    <!-- Second Tab -->
                                    <div align="center" id="tab_1_contents" class="<%=tabClass[1]%>">
                                        <table>
                                            <tr>
                                                <td class="td">
                                                    <div align="center">
                                                        <a id="mainLink" href="<%=context%>/PDFReportServlet?op=avgCostingFullReport&filterName=ReportsServletThree&filterValue=AvgCostReports" onmouseover="Tip('<%=jobOrderWithAvgPriceTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=jobOrderWithAvgPrice%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><font class="fontStyle"><%=total%></font></a>
                                                        <a id="mainLink" href="<%=context%>/PDFReportServlet?op=jobOperationAnalysis&filterName=ReportsServletThree&filterValue=AvgCostReports" onmouseover="Tip('<%=maintenanceOperationAnalysis%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=jobOrderWithAvgPrice%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><font class="fontStyle"><%=maintenanceOperationAnalysis%></font></a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>

                                    <div align="center" id="tab_2_contents" class="<%=tabClass[2]%>">
                                        <table dir="<%=dir%>">
                                            <tr>
                                                <td class="td">
                                                    <div align="center">
                                                        <a id="mainLink" href="<%=context%>/CostCentersServlet?op=searchMaintOnCostCenters" onmouseover="Tip('<%=jobOrderWithAvgPriceTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=jobOrderWithAvgPrice%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><font class="fontStyle"><%=maintOnCostCenters%></font></a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </FORM>
    </BODY>
</HTML>
