<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.TradeMgr"%>  
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

WebBusinessObject wbo = (WebBusinessObject) request.getAttribute("wbo");
String currentStatus = new String("");
if(wbo.getAttribute("currentStatus") != null){
    currentStatus = (String) wbo.getAttribute("currentStatus");
}

Vector vecPlannedTasks = (Vector) request.getAttribute("vecPlannedTasks");
Vector vecTasksHours = (Vector) request.getAttribute("vecTasksHours");

Hashtable hashtable = new Hashtable();
hashtable.put("1", "&#1578;&#1588;&#1581;&#1610;&#1605;");
hashtable.put("2", "&#1578;&#1586;&#1610;&#1610;&#1578;");

String bgColor, bgColor2;
double iConfigureTotal = 0;
double iQuantifiedTotal = 0;
double iActualTotal = 0;

TradeMgr tradeMgr = TradeMgr.getInstance();

bgColor="#FFFFCC";
bgColor2="#CCCC00";

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;

String align=null;
String dir=null;
String style=null;
String lang,langCode,ViewSpars,BackToList,schduled,finished,categlog,ToCost, sWorkerName,
        Begined,Finished,Canceled,Holded,Rejected,status,cost,count,price,sHour,sJob,onCreate,sTitle, sMaintenanceItem
        ;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    ViewSpars="View Spare Parts";
    BackToList = "Back to list";
    schduled="Scheduled";
    Begined="Begined";
    Finished="Finished";
    Canceled="Canceled";
    Holded="on Hold";
    Rejected="Rejected";
    status="Status";
    sJob="Job";
    sHour="Hour";
    price="Price";
    count="countity";
    cost="Cost";
    finished="Actual Workers";
    categlog="Planned Spare Parts";
    onCreate="Planned Workers";
    ToCost="Total Cost";
    sTitle="Workers Report";
    sMaintenanceItem = "Maintenance Item";
    sWorkerName = "Worker Name";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    ViewSpars=" &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
    BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    schduled="&#1605;&#1580;&#1583;&#1608;&#1604;&#1577;";
    Begined="&#1576;&#1583;&#1571;&#1578;";
    Finished="&#1573;&#1606;&#1578;&#1607;&#1578;";
    Canceled="&#1605;&#1604;&#1594;&#1575;&#1577;";
    Holded="&#1605;&#1608;&#1602;&#1608;&#1601;&#1577;";
    Rejected="&#1605;&#1585;&#1601;&#1608;&#1590;&#1577;";
    status="&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
    sJob="&#1575;&#1604;&#1605;&#1607;&#1606;&#1577;";
    sHour="&#1587;&#1575;&#1593;&#1577;";
    price="&#1587;&#1593;&#1585; &#1575;&#1604;&#1608;&#1581;&#1583;&#1577;";
    count="&#1575;&#1604;&#1603;&#1605;&#1610;&#1577;";
    cost="&#1573;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1587;&#1593;&#1585;";
    finished="&#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577; &#1575;&#1604;&#1581;&#1602;&#1610;&#1602;&#1610;&#1577;";
    categlog="&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1605;&#1582;&#1591;&#1591;&#1577;";
    onCreate="&#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577; &#1575;&#1604;&#1605;&#1582;&#1591;&#1591;&#1577;";
    ToCost="&#1573;&#1580;&#1605;&#1575;&#1604;&#1610;";
    sTitle="&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;";
    sMaintenanceItem = "&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    sWorkerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1575;&#1605;&#1604;";
}
%>
<HTML>
    
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new Project</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <BODY>
        <br><br><br>
        <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%">
            
            <tr>
                <TD CLASS="td" VALIGN="top">
                    <table ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%">
                        <TR>
                            <TD STYLE="border:1px solid black" width ="33%" VALIGN="top" COLSPAN="2">
                                <table border="0" ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%" cellpadding="0" cellspacing="1">
                                    <TR>
                                        <TD style="text-align:center" CLASS="head" bgcolor="#F3F3F3" width="33%" COLSPAN="6">
                                            <b><%=onCreate%></b>
                                        </TD>
                                    </TR>
                                    <TR bgcolor="#808080">
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=sMaintenanceItem%></b>
                                        </TD>
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=sJob%></b>
                                        </TD>
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=sHour%></b>
                                        </TD>
                                    </TR>
                                    <%
                                    for(int i = 0; i < vecPlannedTasks.size(); i++){
    WebBusinessObject wboPlanned = (WebBusinessObject) vecPlannedTasks.get(i);
    WebBusinessObject wboTrade = tradeMgr.getOnSingleKey((String) wboPlanned.getAttribute("trade"));
                                    %>
                                    <TR BGCOLOR="<%=bgColor%>">
                                        <TD STYLE="border:0px">
                                            <%=wboPlanned.getAttribute("name")%>
                                        </TD>
                                        <TD STYLE="border:0px">
                                            <%=wboTrade.getAttribute("tradeName")%>
                                        </TD>
                                        <TD STYLE="border:0px">
                                            <%=wboPlanned.getAttribute("executionHrs")%>
                                        </TD>
                                    </TR>
                                    <%
                                    }
                                    %>
                                </TABLE>
                            </TD>
                            <TD STYLE="border:1px solid black" width ="33%" VALIGN="top" COLSPAN="2">
                                <table border="0" ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%" cellpadding="0" cellspacing="1">
                                    <TR>
                                        <TD style="text-align:center" CLASS="head" bgcolor="#F3F3F3" width="33%" COLSPAN="6">
                                            <B><%=finished%></B>
                                        </TD>
                                    </TR>
                                    <TR bgcolor="#808080">
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=sJob%></b>
                                        </TD>
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=sWorkerName%></b>
                                        </TD>
                                        <TD STYLE="border:0px;color:white">
                                            <b><%=sHour%></b>
                                        </TD>
                                    </TR><%
                                    for(int i = 0; i < vecTasksHours.size(); i++){
    WebBusinessObject wboTasks = (WebBusinessObject) vecTasksHours.get(i);
    WebBusinessObject wboTrade = tradeMgr.getOnSingleKey((String) wboTasks.getAttribute("trade"));
                                    %>
                                    <TR BGCOLOR="<%=bgColor%>">
                                        <TD STYLE="border:0px">
                                            <%=wboTrade.getAttribute("tradeName")%>
                                        </TD>
                                        <TD STYLE="border:0px">
                                            <%=wboTasks.getAttribute("empName")%>
                                        </TD>
                                        <TD STYLE="border:0px">
                                            <%=wboTasks.getAttribute("actualHours")%>
                                        </TD>
                                    </TR>
                                    <%
                                    }
                                    %>
                                </TABLE>
                            </TD>
                        </TR>
                    </TABLE>
                </TD>
            </TR>
        </TABLE>
    </BODY>
</HTML>     
