<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr, com.maintenance.db_access.TradeMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Equipment Category List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            
            function viewScheduleData(url) {
                window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=500, height=450");
            }
            
            function changeMode(name){
                if(document.getElementById(name).style.display == 'none'){
                    document.getElementById(name).style.display = 'block';
                } else {
                    document.getElementById(name).style.display = 'none';
                }
            }

            function submitForm(catID, catName){
                if(confirm('Are you sure delete this main cetgory') == true){//deleteMainCategory
                    catName = getASSCIChar(catName);
                    this.CATEGORY_FORM.action = "EquipmentServlet?op=confirmDeleteMainCategory&categoryID=" + catID + "&categoryName=" + catName;
                    this.CATEGORY_FORM.submit();
                }
            }
            
            function cancelForm() {
                var url="ReportsServletThree?op=getScheduleDeserve";
                window.navigate(url);
           
            }
         
        </SCRIPT>
        <script src='ChangeLang.js' type='text/javascript'></script>
    </HEAD>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        Vector<WebBusinessObject> scheduleList = (Vector) request.getAttribute("data");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align, reverseAlign;
        String dir = null;
        String style = null;
        String newSearch, unitName, issueDate, lang, langCode, currentReading, issueCode, delete, notFoundData, ListTitle, Basic, tableNum, Quick, cancel, createNewMainCat, confirmDelete, scheduleTitle, repeatedEvery, scheduleType, duration, description, releaseDateDue;


        if (stat.equals("En")) {
            align = "center";
            reverseAlign = "right";
            dir = "LTR";
            style = "text-align:left; padding-left: 10px; ";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            issueCode = "Issue Code";
            delete = "Delete";
            Quick = "Quick Summary";
            Basic = "Basic Oprations";
            ListTitle = "Display Schedules";
            notFoundData = "No maintenance tables were found";
            tableNum = "Tables Count";
            cancel = "Weekly Diary";
            createNewMainCat = "New Main Category ...";
            confirmDelete = "Confirm Delete";
            scheduleTitle = "Schedule Title";
            repeatedEvery = "Repeated Every";
            scheduleType = "Schedule Type";
            duration = "Duration";
            description = "Description";
            releaseDateDue = "Release Date Due";
            currentReading = "Current Reading";
            unitName = "Unit Name";
            issueDate = "Issue Start Date";
            newSearch = "New Search";

        } else {
            align = "center";
            reverseAlign = "left";
            dir = "RTL";
            style = "text-align:Right; padding-right: 10px";
            lang = "English";
            langCode = "En";
            Quick = "&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
            Basic = "&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
            ListTitle = "&#1593;&#1585;&#1590; &#1575;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604;";
            notFoundData = "&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1580;&#1583;&#1575;&#1608;&#1604; &#1589;&#1610;&#1575;&#1606;&#1577; &#1608;&#1575;&#1580;&#1576;&#1577; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
            issueCode = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
            delete = "&#1581;&#1584;&#1601;";
            tableNum = "&#1593;&#1583;&#1583; &#1575;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604;";
            cancel = "&#1575;&#1604;&#1575;&#1580;&#1606;&#1583;&#1607; &#1575;&#1604;&#1575;&#1587;&#1576;&#1608;&#1593;&#1610;&#1607;";
            createNewMainCat = "&#1606;&#1600;&#1600;&#1600;&#1600;&#1608;&#1575;&#1593; &#1571;&#1587;&#1600;&#1600;&#1600;&#1600;&#1600;&#1575;&#1587;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1609; &#1580;&#1600;&#1600;&#1600;&#1600;&#1583;&#1610;&#1583; ...";
            confirmDelete = "&#1578;&#1571;&#1603;&#1610;&#1600;&#1600;&#1600;&#1600;&#1583; &#1575;&#1604;&#1581;&#1600;&#1600;&#1600;&#1600;&#1584;&#1601;";
            scheduleTitle = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
            repeatedEvery = "&#1610;&#1603;&#1585;&#1585; &#1603;&#1604;";
            scheduleType = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
            duration = "&#1575;&#1604;&#1605;&#1583;&#1577;";
            description = "&#1575;&#1604;&#1608;&#1589;&#1601;";
            releaseDateDue = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1573;&#1589;&#1583;&#1575;&#1585; &#1575;&#1604;&#1605;&#1587;&#1578;&#1581;&#1602;";
            currentReading = "&#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1577;";
            unitName = "&#1571;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
            issueDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1576;&#1583;&#1575;&#1610;&#1577; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
            newSearch = "&#1576;&#1581;&#1579; &#1580;&#1583;&#1610;&#1583;";
        }
    %>

    <BODY>
        <FORM action="" NAME="CATEGORY_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;padding-bottom: 10px; padding-top: 10px; padding-left: 5%">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button  onclick="JavaScript: cancelForm();" class="button"><%=newSearch%></button>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="border-color: #006699;width: 90%">
                    <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"><%=ListTitle%></FONT><BR></TD>
                        </TR>
                    </TABLE>
                    <BR>
                    <% if (!scheduleList.isEmpty()) {%>
                    <TABLE class="blueBorder" align="center" width="90%" DIR="<%=dir%>"  CELLPADDING="0" CELLSPACING="0">
                        <TR>
                            <TD nowrap CLASS="blueBorder backgroundTable" STYLE="font-size:14px;color:black; height: 25px">
                                <b><%=scheduleTitle%></b>
                            </TD>
                            <TD nowrap CLASS="blueBorder backgroundTable" STYLE="font-size:14px;color:black; height: 25px">
                                <b><%=unitName%></b>
                            </TD>
                            <TD nowrap CLASS="blueBorder backgroundTable" STYLE="font-size:14px;color:black; height: 25px">
                                <b><%=currentReading%></b>
                            </TD>
                            <TD nowrap CLASS="blueBorder backgroundTable" STYLE="font-size:14px;color:black; height: 25px">
                                <b><%=issueCode%></b>
                            </TD>
                            <TD nowrap CLASS="blueBorder backgroundTable" STYLE="font-size:14px;color:black; height: 25px">
                                <b><%=issueDate%></b>
                            </TD>
                        </TR>
                        <% for (WebBusinessObject wbo : scheduleList) {%>
                        <TR style="cursor: pointer;" onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">

                            <TD STYLE="<%=style%>" nowrap  CLASS="blueBorder" width="20%">
                                <A HREF="JavaScript:viewScheduleData('SelectiveServlet?op=viewScheduleData&scheduleId=<%=wbo.getAttribute("periodicId")%>');" style="color: black"><b><font size="2"><%=wbo.getAttribute("maintenanceTitle")%></font></b></A>
                            </TD>

                            <TD STYLE="<%=style%>" nowrap  CLASS="blueBorder" width="20%">
                                <b><font size="2"><%=wbo.getAttribute("unitName")%></font></b>
                            </TD>
                            
                            <TD STYLE="<%=style%>" nowrap  CLASS="blueBorder" width="20%">
                                <b><font size="2"><%=wbo.getAttribute("currentReading")%></font></b>
                            </TD>
                            
                            <TD STYLE="<%=style%>" nowrap  CLASS="blueBorder" width="20%">
                                <b><font size="2"><%=wbo.getAttribute("IssueCode")%></font></b>
                            </TD>

                            <TD STYLE="<%=style%>" nowrap  CLASS="blueBorder" width="20%">
                                <b><font size="2"><%=wbo.getAttribute("beginDate")%></font></b>
                            </TD>
                        </TR>
                        <% }%>
                        <TR>
                            <TD colspan="4" CLASS="blueBorder" BGCOLOR="#808080" STYLE="<%=style%>;color:white;font-size:14px;" >
                                <b><%=tableNum%></b>
                            </TD>
                            <TD CLASS="blueBorder" BGCOLOR="#808080" STYLE="<%=style%>;color:white;font-size:14px;" >
                                <b><%=scheduleList.size()%></b>
                            </TD>
                        </TR>
                    </TABLE>
                    <BR>
                    <% } else {%>
                    <TABLE class="blueBorder" align="center" width="90%" DIR="<%=dir%>"  CELLPADDING="0" CELLSPACING="0">
                        <TR>
                            <TD STYLE="text-align: center" nowrap  CLASS="backgroundTable" width="100%" colspan="4">
                                <b><font color="red" size="3"><%=notFoundData%></font></b>

                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <% }%>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>
