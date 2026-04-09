<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.common.Tools"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@page import="com.maintenance.common.ResultDataReportBean" %>
<HTML>
    <%
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String context = metaDataMgr.getContext();

        Vector<WebBusinessObject> computeDiffrenceReading = (Vector) request.getAttribute("data");
        String scheduleId = (String) request.getAttribute("scheduleId");
        String scheduleName = (String) request.getAttribute("scheduleName");
        String searchAll = (String) request.getAttribute("searchAll");
        int deserveBefore = (Integer) request.getAttribute("deserveBefore");

        String status = (String) request.getAttribute("status");
        if (status == null) {
            status = "";
        }

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, sTitle, sCurrentReading, sCancel, schName, eqpName, lastIssue, num, sDate, sCounterReading, basicOperation, sFreq, notFountIssue, executeIssue, cancelIssue, fStatus, sStatus, totalSchedule;
        String notStart, notFoundReading;
        String catName,jobOrderNo,jobOrderDate,diffReading,lastReadingMachine,readingJobMachine,
                schFrequency,lateJobOrder,travelDist,site,sUpdatingDate,sReadingJobOrder;
        String prvReading,schTitle,whichCloser,dueJobOrder,noBranch;
        if (stat.equals("En")) {
            align = "right";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            sTitle = "Report - Reading of Machine Without Job order";
            sCancel = "Back";
            langCode = "Ar";
            schName = "Schedule Name";
            eqpName = "Equipment Name";
            lastIssue = "Last Issue For This Schedule";
            num = "Number";
            sDate = "Date";
            sCounterReading = "Counter Reading";
            basicOperation = "Baisc Operation";
            sFreq = "Frequency (<font color=\"red\">Km</font>)";
            notFountIssue = "Not Found Job Orders For This Schedule";
            executeIssue = "Execute Issue";
            cancelIssue = "Cancel Issue";
            fStatus = "Not Execution";
            sStatus = "Cancel Complete";
            totalSchedule = "Number Schedule(s) Deserv";
            sCurrentReading = "Current Reading";
            notStart = "Not Satrt yet";
            notFoundReading = "Not Found Reading";
            catName="Main Category";
            jobOrderNo="Last Job Order No.";
            jobOrderDate="Job Order Date";
            diffReading="Difference of Reading";
            lastReadingMachine="Last Reading of Machine";
            readingJobMachine=" Reading Machine of job order";
            schFrequency="Schedule Frequency";
            lateJobOrder="Late job order";
            travelDist="Total distance of travel ";
            site="Site";
            sUpdatingDate="Updating Date";
            prvReading="Previous Reading";
            sReadingJobOrder="Reading of job order";
            schTitle="schedule";
            whichCloser="schedule by";
            dueJobOrder = "Due Job Order";
            noBranch="Site is not available";
        } else {
            align = "left";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            sTitle = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1602;&#1585;&#1575;&#1569;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1576;&#1583;&#1608;&#1606; &#1575;&#1605;&#1585; &#1588;&#1594;&#1604;";
            sCancel = "&#1585;&#1580;&#1600;&#1600;&#1600;&#1600;&#1600;&#1608;&#1593;";
            langCode = "En";
            schName = "&#1575;&#1604;&#1580;&#1600;&#1600;&#1600;&#1600;&#1583;&#1608;&#1604;";
            eqpName = "&#1575;&#1604;&#1605;&#1593;&#1600;&#1600;&#1600;&#1600;&#1583;&#1577;";
            lastIssue = "&#1575;&#1582;&#1585; &#1575;&#1605;&#1585; &#1588;&#1594;&#1604; &#1604;&#1607;&#1584;&#1575; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
            num = "&#1585;&#1602;&#1605;&#1600;&#1600;&#1600;&#1600;&#1600;&#1607;";
            sDate = "&#1578;&#1575;&#1585;&#1610;&#1582;&#1600;&#1600;&#1600;&#1600;&#1607;";
            sCounterReading = "&#1602;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1593;&#1600;&#1583;&#1575;&#1583;";
            basicOperation = "&#1593;&#1605;&#1604;&#1610;&#1600;&#1600;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1600;&#1600;&#1577;";
            sFreq = "&#1578;&#1603;&#1585;&#1575;&#1585; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604; <br>(<font color=\"blue\">&#1571;&#1610;&#1607;&#1605;&#1575; &#1571;&#1602;&#1585;&#1576;</font>) (<font color=\"red\">&#1603;&#1605;</font>)";
            notFountIssue = "&#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1571;&#1608;&#1575;&#1605;&#1585; &#1588;&#1594;&#1604; &#1604;&#1607;&#1584;&#1575; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
            executeIssue = "&#1573;&#1587;&#1578;&#1582;&#1600;&#1600;&#1600;&#1600;&#1585;&#1580;";
            cancelIssue = "&#1573;&#1604;&#1594;&#1600;&#1600;&#1600;&#1600;&#1575;&#1569;";
            fStatus = "&#1604;&#1605; &#1610;&#1578;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1605; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1584;";
            sStatus = "&#1578;&#1605; &#1575;&#1604;&#1573;&#1604;&#1594;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1575;&#1569;";
            totalSchedule = "&#1575;&#1604;&#1580;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1583;&#1575;&#1608;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1581;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1602;&#1607;";
            sCurrentReading = "&#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1577;";
            notStart = "&#1604;&#1605; &#1610;&#1576;&#1583;&#1575;&#1569;";
            notFoundReading = "&#1604;&#1575;&#1578;&#1608;&#1580;&#1583; &#1602;&#1585;&#1575;&#1569;&#1577;";
            catName="&#1575;&#1604;&#1606;&#1608;&#1593; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1609;";
            jobOrderNo="&#1585;&#1602;&#1605; &#1571;&#1582;&#1585; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
            jobOrderDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
            diffReading="&#1601;&#1585;&#1602; &#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1575;&#1578;";
            lastReadingMachine="&#1602;&#1585;&#1575;&#1569;&#1577; &#1571;&#1582;&#1585; &#1578;&#1581;&#1583;&#1610;&#1579; &#1604;&#1604;&#1605;&#1593;&#1583;&#1577;";
            readingJobMachine="&#1602;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; &#1593;&#1606;&#1583; &#1578;&#1601;&#1593;&#1610;&#1604; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
            schFrequency="&#1578;&#1603;&#1585;&#1575;&#1585; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1576;&#1593;&#1583;";
            lateJobOrder="&#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1581;&#1602;&#1577;";
            travelDist="&#1605;&#1580;&#1605;&#1608;&#1593; &#1605;&#1587;&#1575;&#1601;&#1575;&#1578; &#1575;&#1604;&#1585;&#1581;&#1604;&#1575;&#1578;";
            site="&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
            sUpdatingDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1578;&#1581;&#1583;&#1610;&#1579;";
            prvReading="&#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1587;&#1575;&#1576;&#1602;&#1577;";
            sReadingJobOrder="&#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1577; &#1593;&#1606;&#1583; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
            schTitle="&#1580;&#1583;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
            whichCloser="&#1571;&#1610;&#1607;&#1605;&#1575; &#1571;&#1602;&#1585;&#1576;";
            dueJobOrder = "&#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1581;&#1602;&#1577;";
            noBranch="&#1575;&#1604;&#1605;&#1608;&#1602;&#1593; &#1594;&#1610;&#1585; &#1605;&#1578;&#1575;&#1581;";
        }
      List viewList = new ArrayList();
      viewList =(List) request.getAttribute("viewList");
      
              
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="css/headers.css" />
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            function cancelForm() {
                document.ISSUE_FORM.action = "<%=context%>/ReportsServletThree?op=getschedualByReadingReport&otherReports=yes";
                document.ISSUE_FORM.submit();
            }
        </script>
        <style type="text/css" >
            .backgroundColor {
                background-color: #E8E8E8;
            }
        </style>
    </HEAD>
    <BODY>
        <FORM action=""  NAME="ISSUE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;padding-left: 0%; padding-bottom: 10px">
                <button onclick="JavaScript: cancelForm();" class="button"><%=sCancel%></button>
                &ensp;
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            </DIV>
            <center>
                <FIELDSET class="set" style="width:100%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="border-color: #006699;">
                        <TR>
                            <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=sTitle%></font></TD>
                        </TR>
                    </TABLE>
                    <% if (!status.equalsIgnoreCase("")) {%>
                    <TABLE align="center" cellpadding="0" cellspacing="0" width="99.5%" style="margin-top: 10px">
                        <TR>
                            <TD class="blueBorder backgroundTable" style="color: red; font-size: 16px; font-weight: bold; text-align: center">
                                <% if (status.equalsIgnoreCase("ok")) {%>
                                <b><font color="blue"><%=sStatus%></font></b>
                                    <% } else {%>
                                <b><%=fStatus%></b>
                                <% }%>
                            </TD>
                        </TR>
                    </TABLE>
                    <% }%>
                    <% if (!viewList.isEmpty()) {%>
                    <TABLE class="blueBorder" ALIGN="center" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="99.5%" style="margin-top: 10px">
                        
                        <TR>
                            <!--TD CLASS="blueBorder backgroundHeader blueHeaderTD" style="font-size: 14px" width="10%">
                                <b><%=eqpName%></b>
                            </TD-->
                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" style="font-size: 14px" width="10%">
                                <b><%=catName%></b>
                            </TD>
                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" style="font-size: 14px" width="10%">
                                <b><%=site%></b>
                            </TD>
                            <!--TD CLASS="blueBorder backgroundHeader blueHeaderTD" style="font-size: 14px;" width="10%">
                                <b><%//=jobOrderNo%></b>
                            </TD-->
                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" style="font-size: 14px;" width="10%">
                                <b><%=sCurrentReading%></b>
                            </TD>
                            <!--TD CLASS="blueBorder backgroundHeader blueHeaderTD" style="font-size: 12px;" width="10%">
                                <b><%//=sReadingJobOrder%></b>
                            </TD-->
                            <!--TD CLASS="blueBorder backgroundHeader blueHeaderTD" style="font-size: 14px" width="10%">
                                <b><%//=diffReading%></b>
                            </TD-->
                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" style="font-size: 14px" width="10%">
                                <b><%=sUpdatingDate%></b>
                            </TD>
                            <!--TD CLASS="blueBorder backgroundHeader blueHeaderTD" style="font-size: 14px" width="10%">
                                <b><%//=prvReading%></b>
                            </TD-->
                            <!--TD CLASS="blueBorder backgroundHeader blueHeaderTD" style="font-size: 14px" width="10%">
                                <b><%//=sUpdatingDate%></b>
                            </TD-->
                            <!--TD CLASS="blueBorder backgroundHeader blueHeaderTD" style="font-size: 12px" width="10%">
                                <b><%//=jobOrderDate%></b>
                            </TD-->
                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" style="font-size: 12px;" width="10%">
                                <b><%=schTitle%></b>
                            </TD>
                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" style="font-size: 12px;" width="10%">
                                <b><%=whichCloser%></b>
                            </TD>
                            <TD CLASS="blueBorder backgroundHeader blueHeaderTD" style="font-size: 12px;" width="10%">
                                <b><%=dueJobOrder%></b>
                            </TD>
                        </TR>
                        
                        <%
                            String unitId="";
                            for (int i=0;i<viewList.size();i++) {
                                  ResultDataReportBean obj = (ResultDataReportBean) viewList.get(i);  
                                 if(!obj.getUnitId().equals(unitId)){
                                 %>
                             <TR>
                                 <TD colspan="11" CLASS="blueBorder backgroundHeader blueHeaderTD" style="font-size: 14px" width="10%">
                                    <b><%=obj.getUnitName()%></b>
                                </TD>
                             </TR>
                                 
                             
                             <TR style="cursor: pointer">
                            <!--TD class="blueBorder blueBodyTD">
                                <b><%//=obj.getUnitName()%></b>
                            </TD-->
                            <TD class="blueBorder blueBodyTD">
                                <b><%=obj.getMainCatName()%></b>
                            </TD>
                            <TD class="blueBorder blueBodyTD">
                                <% if(obj.getBranchName()!=null && !obj.getBranchName().equals("")){ %>
                                <b><%=obj.getBranchName()%></b>
                                <% } else { %>
                                <b><%=noBranch%></b>
                                <% } %>
                            </TD>
                            <!--TD class="blueBorder blueBodyTD">
                                <b><%//=obj.getJobOrderNo()%></b>
                            </TD-->
                            <TD class="blueBorder blueBodyTD" style="background-color:#7cdea7;">
                                <b><%=obj.getCurrReading()%></b>
                            </TD>
                            <!--TD class="blueBorder blueBodyTD" style="background-color:#7cdea7;">
                                <b><%//=obj.getReadingJobOrder()%></b>
                            </TD-->
                            <!--TD class="blueBorder blueBodyTD" style="background-color:#7cdea7;">
                                <b><%//=obj.getCurrReading()-obj.getReadingJobOrder()%></b>
                            </TD-->
                            <TD class="blueBorder blueBodyTD">
                                <% SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                    String sEntryTime = sdf.format(obj.getCurrentReadingDate());
                                    %>
                                <b><%=sEntryTime%></b>
                            </TD>
                            <!--TD class="blueBorder blueBodyTD">
                                <b><%//=obj.getPrvReading()%></b>
                            </TD-->
                            <!--TD class="blueBorder blueBodyTD">
                                <%  sdf = new SimpleDateFormat("yyyy-MM-dd");
                                    String sPrvTime = sdf.format(obj.getPrvReadingDate());
                                    %>
                                <b><%//=sPrvTime%></b>
                            </TD-->
                            
                            
                            <!--TD class="blueBorder blueBodyTD">
                                <b><%//=obj.getJobOrderDate()%></b>
                            </TD-->
                            
                            <TD class="blueBorder blueBodyTD">
                                <b><%=obj.getSchTitle()%></b>
                            </TD>
                            <TD class="blueBorder blueBodyTD">
                                <% if(!obj.getSchTitle().equals("Emergency")) { %>
                                <b><%=obj.getWhichCloser()%></b>
                                <% } else { %>
                                <b>---</b>
                                <% } %>
                            </TD>
                            <TD class="blueBorder blueBodyTD" style="background-color:#f9e375;">
                                <% Double countJob=0.0; %>
                                <% if(obj.getWhichCloser()!=0.0){
                                 countJob = new Double((obj.getCurrReading())).doubleValue()/new Double(obj.getWhichCloser()).doubleValue();
                                if(countJob<1.0 && (countJob >0.85 || countJob ==0.85 )){ %>
                                <b>1</b>
                                <% } else if(countJob ==1 || countJob >1) {
                                    %>
                                    <b><%=(int)(countJob).intValue()%></b>
                                <% } else if(countJob==0.0 || countJob <0.85){ %>
                                    <b>0</b>
                                    <% } %>
                                <% } else {%>
                                <b>---</b>
                                <%}%>
                            </TD>
                        </TR>
                           <% unitId = obj.getUnitId().toString();
                                }else{
                                unitId = obj.getUnitId().toString();
                        %>
                       <TR style="cursor: pointer">
                            <!--TD class="blueBorder blueBodyTD">
                                <b><%//=obj.getUnitName()%></b>
                            </TD-->
                            <TD class="blueBorder blueBodyTD">
                                <b><%=obj.getMainCatName()%></b>
                            </TD>
                            <TD class="blueBorder blueBodyTD">
                                <% if(obj.getBranchName()!=null && !obj.getBranchName().equals("")){ %>
                                <b><%=obj.getBranchName()%></b>
                                <% } else { %>
                                <b><%=noBranch%></b>
                                <% } %>
                            </TD>
                            <!--TD class="blueBorder blueBodyTD">
                                <b><%//=obj.getJobOrderNo()%></b>
                            </TD-->
                            <TD class="blueBorder blueBodyTD" style="background-color:#7cdea7;">
                                <b><%=obj.getCurrReading()%></b>
                            </TD>
                            <!--TD class="blueBorder blueBodyTD" style="background-color:#7cdea7;">
                                <b><%//=obj.getReadingJobOrder()%></b>
                            </TD-->
                            <!--TD class="blueBorder blueBodyTD" style="background-color:#7cdea7;">
                                <b><%//=obj.getCurrReading()-obj.getReadingJobOrder()%></b>
                            </TD-->
                            <TD class="blueBorder blueBodyTD">
                                <% SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                    String sEntryTime = sdf.format(obj.getCurrentReadingDate());
                                    %>
                                <b><%=sEntryTime%></b>
                            </TD>
                            <!--TD class="blueBorder blueBodyTD">
                                <b><%//=obj.getPrvReading()%></b>
                            </TD-->
                            <!--TD class="blueBorder blueBodyTD">
                                <%  sdf = new SimpleDateFormat("yyyy-MM-dd");
                                    String sPrvTime = sdf.format(obj.getPrvReadingDate());
                                    %>
                                <b><%//=sPrvTime%></b>
                            </TD-->


                            <!--TD class="blueBorder blueBodyTD">
                                <b><%//=obj.getJobOrderDate()%></b>
                            </TD-->

                            <TD class="blueBorder blueBodyTD">
                                <b><%=obj.getSchTitle()%></b>
                            </TD>
                            <TD class="blueBorder blueBodyTD">
                                <% if(!obj.getSchTitle().equals("Emergency")) { %>
                                <b><%=obj.getWhichCloser()%></b>
                                <% } else { %>
                                <b>---</b>
                                <% } %>
                            </TD>
                            <TD class="blueBorder blueBodyTD" style="background-color:#f9e375;">
                                <% Double countJob=0.0; %>
                                <% if(obj.getWhichCloser()!=0.0){
                                 countJob = new Double((obj.getCurrReading())).doubleValue()/new Double(obj.getWhichCloser()).doubleValue();
                                 if(countJob<1.0 && (countJob >0.85 || countJob ==0.85 )){ %>
                                <b>1</b>
                                <% } else if(countJob ==1 || countJob >1) {
                                    %>
                                    <b><%=(int)(countJob).intValue()%></b>
                                <% } else if(countJob==0.0 || countJob <0.85){ %>
                                    <b>0</b>
                                    <% } %>
                                <% } else {%>
                                <b>---</b>
                                <%}%>
                            </TD>
                        </TR>
                        <% } %>
                        <%}%>
                    </TABLE>
                    
                    <% }%>
                    <br>
                </FIELDSET>
            </center>
            
            
        </FORM>
    </BODY>
</HTML>