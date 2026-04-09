
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.international.TouristGuide"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<HTML>
    <%
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String context = metaDataMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        ArrayList allSites = (ArrayList) request.getAttribute("allSites");
        
        String scheduleId = (String) request.getAttribute("scheduleId");
        String scheduleName = (String) request.getAttribute("scheduleName");
        String afterOrBefore = (String) request.getAttribute("afterOrBefore");

        // get current defaultLocationName
        String defaultLocationName = (String) request.getAttribute("defaultLocationName");

        //get session logged user and his trades
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

        // get current date
        Calendar cal = Calendar.getInstance();
        String jDateFormat = user.getAttribute("javaDateFormat").toString();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");
        String nowTime = sdf.format(cal.getTime());
        
        if (scheduleId == null) {
            scheduleId = "";
        }
        if (scheduleName == null) {
            scheduleName = "";
        }
        if (afterOrBefore == null) {
            afterOrBefore = "0";
        }

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, sTitle, sCancel, sOk, sScheduleName, exportReport, before, unitName, after, site, selectAll, calenderTip, beginDate, endDate;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            sTitle = "Deviations In Equipments Readings Report";
            sCancel = "Cancel";
            sOk = "Search";
            langCode = "Ar";
            sScheduleName = "Schedule Name";
            exportReport = "Export Report";
            before = "Before";
            unitName = "Unit Name";
            after = "After";
            site = "Site";
            selectAll = "All";
            calenderTip = "click inside text box to opn calender window";
            beginDate = "From Date";
            endDate = "To Date";

        } else {
            align = "right";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            sTitle = "تقرير الإنحرافات فى قراءة المعدات";
            sCancel = tGuide.getMessage("cancel");
            sOk = "&#1576;&#1581;&#1579;";
            langCode = "En";
            sScheduleName = "&#1575;&#1587;&#1600;&#1600;&#1605; &#1580;&#1600;&#1600;&#1583;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1600;&#1600;&#1575;&#1606;&#1577;";
            exportReport = "&#1573;&#1587;&#1578;&#1582;&#1600;&#1600;&#1585;&#1580; &#1575;&#1604;&#1578;&#1602;&#1600;&#1600;&#1585;&#1610;&#1585;";
            before = " &#1602;&#1576;&#1600;&#1600;&#1604;";
            unitName = "&#1571;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
            after = " &#1576;&#1593;&#1583;";
            site = "&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
            selectAll = "&#1603;&#1600;&#1600;&#1600;&#1604;";
            calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
            beginDate = "من تاريخ";
            endDate = "إلى تاريخ";

        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>

        <link rel="stylesheet" type="text/css" href="css/headers.css" />
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

        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <link rel="stylesheet" href="jquery-ui/demos/demos.css">
        <script type="text/javascript">
            
        $(document).ready(function() {
            $( "#toDate" ).datetimepicker({
                maxDate    : "+d",
                changeMonth: true,
                changeYear : true,
                timeFormat:'hh:mm',
                dateFormat : 'yy-mm-dd',
		beforeShow: function (textbox, instance) {
                    instance.dpDiv.css({
                        marginTop: '-334px',
                        marginLeft: (-textbox.offsetWidth + 30) + 'px'
                    });
		}

            });
         });

        </script>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            function submitForm() {
                if (!validateData("req", this.REPORT_FORM.unitName, "Please enter unit name")) {
                    this.REPORT_FORM.unitName.focus();

                } else {
                    document.REPORT_FORM.action = "<%=context%>/PDFReportsTreeServlet?op=deviationsInEquipmentsReadings";
                    openCustom('');
                    document.REPORT_FORM.target="window_chaild";
                    document.REPORT_FORM.submit();

                }

            }
        
            function getSchedule() {
                var formName = document.getElementById('REPORT_FORM').getAttribute("name");
                var scheduleName = document.getElementById('scheduleName').value;
                scheduleName = getASSCIChar(scheduleName);
                openWindowTasks('SelectiveServlet?op=listSchedules&scheduleName=' + scheduleName + '&scheduleOn=all&formName=' + formName);
            }

            function cancelForm() {
                document.REPORT_FORM.action = "<%=context%>/ReportsServletThree?op=operationReports";
                document.REPORT_FORM.submit();
            }
        
            function inputChange(id) {
                document.getElementById(id).value = "";
            }

            function openWindowTasks(url) {
                openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=800, height=400");
            }
        
            function getEquipments()
            {
                var formName = document.getElementById('REPORT_FORM').getAttribute("name");
                var name = document.getElementById('unitName').value
                var res = ""
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                openWindowTasks('SelectiveServlet?op=listEquipmentsBySite&unitName=' + res + '&siteArr=' + $("#site").val() +'&formName=' + formName);
            }
            
        </SCRIPT>
    </HEAD>
    <BODY>
        <FORM action="" id="REPORT_FORM"  NAME="REPORT_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;padding-left: 2.5%; padding-bottom: 10px">
                <button onclick="JavaScript: cancelForm();" class="button"><%=sCancel%></button>
                &ensp;
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <input type="button" id="btnExportReport" value="<%=exportReport%>" onclick="JavaScript: submitForm()" class="button">
                
            </DIV>
            <center>
                <FIELDSET class="set" style="width:95%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=sTitle%></font></TD>
                        </TR>
                    </TABLE>
                    <br>
                    <TABLE ID="tableSearch"  ALIGN="center" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="3" width="40%" style="height: 100%">
                        
                        <%--
                        <TR>
                            <TD CLASS="backgroundTable" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:15px; height: 40px; font-weight: bold" width="25%">
                                <b><%=sScheduleName%></b>
                            </TD>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="middle">
                                <input type="text" dir="<%=dir%>" value="" name="scheduleName" ID="scheduleName" size="30" onchange="JavaScript: inputChange('scheduleId');" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:12px; width: 88%; font-weight: bold">
                                <input type="hidden" name="scheduleId" ID="scheduleId" value="<%=scheduleId%>">
                                <input type="button" id="btnSearch" value="<%=sOk%>" style="text-align:center;font-size:14px;font-weight: bold;width: 9%" ONCLICK="JavaScript: getSchedule();">
                            </TD>
                        </TR>
                        --%>
                        <TR>
                            <TD CLASS="backgroundTable" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:15px; height: 40px; font-weight: bold" width="35%">
                                <b><font size=3 color="black"><%=site%></font></b>
                            </TD>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;padding:5px" valign="middle">
                                <input type="hidden" id="siteAll" value="no" name="siteAll" />
                                <select name="site" onchange="selectAllSites(this.id,'siteAll');" id="site" style="font-size:12px;font-weight:bold;width:100%; display: block; margin: 0px;" multiple size="5">
                                    <option value="selectAll" style="color:#989898;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                    <sw:WBOOptionList wboList="<%=allSites%>" displayAttribute="projectName" valueAttribute="projectID" scrollTo="<%=defaultLocationName%>" />
                                </select>
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="backgroundTable" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:15px; height: 40px; font-weight: bold" width="35%">
                                <b><%=unitName%></b>
                            </TD>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="middle">
                                <input type="text" dir="<%=dir%>" value="" name="unitName" ID="unitName" size="30" onchange="JavaScript: inputChange('unitId');" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:12px; width: 74%; font-weight: bold">
                                <input type="hidden" name="unitId" id="unitId" value="" />
                                <input type="button" id="unitSearch" value="<%=sOk%>" style="text-align:center;font-size:14px;font-weight: bold;width: 20%" ONCLICK="JavaScript: getEquipments();">
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="backgroundTable" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:15px; height: 40px; font-weight: bold" width="35%">
                                <b><%=sScheduleName%></b>
                            </TD>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="middle">
                                <input type="text" dir="<%=dir%>" value="" name="scheduleName" ID="scheduleName" size="30" onchange="JavaScript: inputChange('scheduleId');" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:12px; width: 74%; font-weight: bold">
                                <input type="hidden" name="scheduleId" ID="scheduleId" value="<%=scheduleId%>">
                                <input type="button" id="scheduleSearch" value="<%=sOk%>" style="text-align:center;font-size:14px;font-weight: bold;width: 20%" ONCLICK="JavaScript: getSchedule();">
                            </TD>
                        </TR>
                        <%--
                        <TR>
                            <TD CLASS="backgroundTable" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:15px; height: 40px; font-weight: bold" width="25%">
                                <b><font size=3 color="black"><%= beginDate%></font></b>
                            </TD>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="MIDDLE" >
                                <input readonly id="beginDate" name="beginDate" type="text" value="<%=nowTime%>" style="width:90%" /><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'black', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" />
                            </TD>
                        </TR>
                        --%>
                        <TR>
                            <TD CLASS="backgroundTable" STYLE="text-align:<%=align%>; padding-<%=align%>: 10px; color: black; font-size:15px; height: 40px; font-weight: bold" width="25%">
                                <b> <font size=3 color="black"><%= endDate%></font> </b>
                            </TD>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" valign="middle">
                                <input dir="ltr" readonly id="toDate" name="toDate" type="text" value="<%=nowTime%>" style="<%=style%>;width:90%" /><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'black', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" />
                            </TD>
                        </TR>
                        
                    </TABLE>
                    <br>
                </FIELDSET>
            </center>
        </FORM>
    </BODY>
</HTML>
