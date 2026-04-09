<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,java.text.DecimalFormat"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr,com.maintenance.db_access.*"%>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
MaintainableMgr unitMgr = MaintainableMgr.getInstance();
MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
ScheduleMgr scheduleMgr=ScheduleMgr.getInstance();

String sType = new String("");
if(request.getParameter("type") != null){
    sType = "&type=" + request.getParameter("type");
}

TradeMgr tradeMgr = TradeMgr.getInstance();

String context = metaMgr.getContext();
String id = (String) request.getAttribute("equipmentCat");

WebBusinessObject unitWbo = null;
WebBusinessObject schedule = (WebBusinessObject) request.getAttribute("schedule");

WebBusinessObject tradeWbo = tradeMgr.getOnSingleKey((String) schedule.getAttribute("workTrade"));
String ScheduleID=(String)request.getAttribute("scheduleId");
String Config="";
String MaintItem=context+"/ScheduleServlet?op=find&scheduleId="+ScheduleID+"&ToBakeTo=View&fromView=true";
if(schedule.getAttribute("scheduledOn").toString().equalsIgnoreCase("Cat")){
    unitWbo = (WebBusinessObject) unitMgr.getOnSingleKey(schedule.getAttribute("equipmentCatID").toString());
    Config=context+"/ScheduleServlet?op=ConfigureTimelySchedule&scheduleId="+ScheduleID+"&fromView=true&scheduleTitle="+schedule.getAttribute("maintenanceTitle")+"&scr=listAllSchdual&categoryId="+id;
    
} else {
    unitWbo = (WebBusinessObject) unitMgr.getOnSingleKey(schedule.getAttribute("equipmentID").toString());
    Config=context+"/ScheduleServlet?op=ConfigureTimelySchedule&scheduleId="+ScheduleID+"&scheduleTitle="+schedule.getAttribute("maintenanceTitle")+"&fromView=true&scr=ListAllEquipmentSchedules&equipmentID="+(String)schedule.getAttribute("equipmentID");
}

String frequencyType = (String) schedule.getAttribute("frequencyType");
String type = new String("");
if(frequencyType.equals("1")){
    type = new String("Day");
} else if(frequencyType.equals("2")){
    type = new String("Week");
} else if(frequencyType.equals("3")){
    type = new String("Month");
} else if(frequencyType.equals("4")){
    type = new String("Year");
} else {
    type = new String("Hour");
}

ScheduleDocMgr scheduleDocMgr = ScheduleDocMgr.getInstance();

Vector  itemList = (Vector) request.getAttribute("data");
String[] itemTitle ={"Code","Name","Count","Note"};
int flipper = 0;

WebBusinessObject wbo;
String bgColor = null;

String attName = null;
String[] itemAtt = {"itemId","itemQuantity", "note"};
String attValue = null;
String cellBgColor = new String("#FF00FF");

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,indGuid,active,nonActive,addPart,AddItem,updatePart,updateItem,vLabor,title,vConf,frequency,taskView,viewOP,status,plusOp,backtolist,frequencyType1,cancel,dur,EqCat,des,notCon,viewDe,totCost,trade,eqp,name,textAlign,viewParts,sMaintenanceItemCode, sMaintenanceItemName, sEstimatedTime, sRequiredTask, TaskDesc, sPriority, sAttachDoc, sDocList, sNoFilesAttched;
if(stat.equals("En")){
    indGuid=" Indicators guide ";
    textAlign="left";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    title="Schedule Title";
    frequency="Frequency";
    frequencyType1="Frequency Type";
    dur="Duration";
    trade="Schedule Trade";
    EqCat="Equipment Category";
    eqp="Equipment";
    des="Description";
    cancel="Cancel";
    viewOP=" Viewing Operations";
    plusOp= "Addition Operations";
    status="Status";
    notCon="No Spare Parts for this schedule";
    viewDe="View Schedule Details";
    totCost="Total Schedule Cost";
    taskView="Task Shedule ";
    backtolist="Back To List";
    viewParts="Designed Spare Parts";
    vConf="View Configuration";
    vLabor="View Labor";
    addPart="Add Spare Parts";
    AddItem="Add Maintenance Items";
    updatePart="Update Spare Parts";
    updateItem="Update Maintenance Items";
    active = "Schedule has Spare Parts";
    nonActive = "Schedule has no Spare Parts";
    sMaintenanceItemCode="Maintenance Item Code";
    sMaintenanceItemName="Maintenance Item  Name";
    sEstimatedTime="Estimated Time";
    sRequiredTask="Required Task";
    sPriority="priority";
    TaskDesc="Description";
    sAttachDoc = "Attaching File";
    sNoFilesAttched="No Attached Files";
    sDocList = "View Attached Files";
}else{
    textAlign="right";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    indGuid= "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    title=" &#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
    frequency=" &#1610;&#1603;&#1585;&#1585; &#1603;&#1604;";
    frequencyType1=" &#1606;&#1608;&#1593; &#1575;&#1604;&#1578;&#1603;&#1585;&#1575;&#1585;";
    dur="&#1575;&#1604;&#1605;&#1583;&#1607;";
    trade="&#1606;&#1608;&#1593; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
    EqCat="&#1589;&#1606;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    eqp="&#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    des="&#1575;&#1604;&#1608;&#1589;&#1601;";
    status="&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
    viewOP="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
    plusOp="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1573;&#1590;&#1575;&#1601;&#1577;";
    viewOP="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
    notCon="&#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1604;&#1580;&#1583;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    viewDe=" &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
    totCost="&#1573;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1607;";
    taskView="&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
    String[] itemTitleAr ={"&#1575;&#1604;&#1603;&#1608;&#1583;","&#1575;&#1604;&#1573;&#1587;&#1605;","&#1575;&#1604;&#1603;&#1605;&#1610;&#1607;","&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;"};
    itemTitle=itemTitleAr;
    backtolist="&#1575;&#1604;&#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607;";
    viewParts="&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1605;&#1582;&#1591;&#1591; &#1604;&#1607;&#1575;";
    vConf="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
    vLabor="&#1593;&#1585;&#1590; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    
    addPart="&#1578;&#1593;&#1610;&#1610;&#1606; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    AddItem="&#1573;&#1590;&#1575;&#1601;&#1607; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1607;";
    updatePart="&#1578;&#1593;&#1583;&#1610;&#1604; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1605;&#1590;&#1575;&#1601;&#1607;";
    updateItem="&#1578;&#1593;&#1583;&#1610;&#1604; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607; &#1575;&#1604;&#1605;&#1590;&#1575;&#1601;&#1607;";
    
    active = "&#1580;&#1583;&#1608;&#1604; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    nonActive = "&#1580;&#1583;&#1608;&#1604; &#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    sMaintenanceItemCode="&#1603;&#1608;&#1583; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    sMaintenanceItemName="&#1573;&#1587;&#1605; &#1575;&#1604;&#1576;&#1606;&#1583;";
    sEstimatedTime="&#1575;&#1604;&#1587;&#1575;&#1593;&#1575;&#1578; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;&#1607;";
    sRequiredTask="&#1575;&#1604;&#1605;&#1607;&#1606;&#1607; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    sPriority="&#1583;&#1585;&#1580;&#1607;";
    TaskDesc="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
    sAttachDoc = "&#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
    sDocList = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
    sNoFilesAttched="&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
}
%>
<style type="text/css"> 
    <!-- 
.tabs {position:relative; left: 5; top: 3; border:1px solid #194367; height: 50px; width: 650; margin: 0; padding: 0; background:#C0D9DE; overflow:hidden; } 
.tabs li {display:inline} 
.tabs a:hover, .tabs a.tab-active {background:#fff;} 
.tabs a { height: 27px; font:11px verdana, helvetica, sans-serif;font-weight:bold; 
       position:relative; padding:6px 10px 10px 10px; margin: 0px -4px 0px 0px; color:#2B4353;text-decoration:none; } 
.tab-container { background: #fff; border:0px solid #194367; height:320px; width:500px} 
.tab-panes { margin: 3px; border:1px solid #194367; height:320px} 
div.content { padding: 5px; } 
    // --> 
</style>
<script language="JavaScript1.3"> 
var panes = new Array(); 

function setupPanes(containerId, defaultTabId) { 
     // go through the DOM, find each tab-container 
     // set up the panes array with named panes 
     panes[containerId] = new Array(); 
     var maxHeight = 0; var maxWidth = 0; 
     var container = document.getElementById(containerId); 
     var paneContainer = container.getElementsByTagName("div")[0]; 
     var paneList = paneContainer.childNodes; 
     for (var i=0; i < paneList.length; i++ ) { 
       var pane = paneList[i]; 
       if (pane.nodeType != 1) continue; 
       panes[containerId][pane.id] = pane; 
       pane.style.display = "none"; 
    } 
     document.getElementById(defaultTabId).onclick(); 
} 

function showPane(paneId, activeTab) { 
     // make tab active class 
     // hide other panes (siblings) 
     // make pane visible 

     for (var con in panes) { 
       activeTab.blur(); 
       activeTab.className = "tab-active"; 
       if (panes[con][paneId] != null) { // tab and pane are members of this container 
         var pane = document.getElementById(paneId); 
         pane.style.display = "block"; 
         var container = document.getElementById(con); 
         var tabs = container.getElementsByTagName("ul")[0]; 
         var tabList = tabs.getElementsByTagName("a") 
         for (var i=0; i < tabList.length; i++ ) { 
           var tab = tabList[i]; 
           if (tab != activeTab) tab.className = "tab-disabled"; 
         } 
         for (var i in panes[con]) { 
           var pane = panes[con][i]; 
           if (pane == undefined) continue; 
           if (pane.id == paneId) continue; 
           pane.style.display = "none" 
         } 
       } 
     } 
       return false; 
} 
</script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function BackToList(){
       <%if(request.getParameter("source").equalsIgnoreCase("eqp")){%>
       window.navigate("<%=context%>//ScheduleServlet?op=ListAllEquipmentSchedules&equipmentID=<%=id%>");
       <%} else {%>
       window.navigate("<%=context%>//ScheduleServlet?op=ListAllSchedules&equipmentCat=<%=request.getParameter("equipmentCat")%>"+"<%=sType%>");
       <%}%>
       
    }
    
    function changeMode(name){
        if(document.getElementById(name).style.display == 'none'){
            document.getElementById(name).style.display = 'block';
        } else {
            document.getElementById(name).style.display = 'none';
        }
    }
      function changePage(url){
                window.navigate(url);
            }
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>

<HTML>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>View Task Details</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
</HEAD>

<BODY onload='setupPanes("container1", "tab1");'>
<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: BackToList();" class="button"> <%=backtolist%> <IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>            
</DIV> 
<br>

<TABLE BORDER="0" CELLSPACING="2" WIDTH="100%" CELLPADDING="2" ALIGN="center" >
<TR>

<TD STYLE="border:0px" width="33%"  VALIGN="top">
    <div STYLE="width:100%;border:2px solid gray;background-color:#808000;color:white;" bgcolor="#F3F3F3" align="center">
        <div ONCLICK="JavaScript: changeMode('menu3');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
            <b>
                <%=indGuid%>
            </b>
            <img src="images/arrow_down.gif">
        </div>
        <div ALIGN="center" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;text-align:right;border-top:2px solid gray;" ID="menu3">
            <table align="center" border="0" dir="rtl" width="100%" cellspacing="3">
                <tr>
                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700"><IMG SRC="images/active.jpg" ALT="<%=active%>" ALIGN="center"><B><%=active%></B></td>
                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700"><IMG SRC="images/nonactive.jpg" ALT="<%=nonActive%>" ALIGN="center"><B><%=nonActive%></B></td>
                    
                </tr>
                <tr>
                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700"><IMG SRC="images/config.jpg" ALT="<%=active%>" ALIGN="center"><B><%=active%></B></td>
                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700"><IMG SRC="images/nonconfig.gif" ALT="<%=nonActive%>" ALIGN="center"><B><%=nonActive%></B></td>
                    
                </tr>
                <%--  ////////////////////////////////////--%>
                <tr>
                    <TD style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700"> <% if(scheduleMgr.getActiveSchedule(ScheduleID)) {  %> <IMG SRC="images/active.jpg"  ALT="Active Schedule by Equipment"> <B><%=active%> <%} else {  %> <IMG SRC="images/nonactive.jpg"  ALT="Non Active Schedule"> <B><%=nonActive%> </B><%  }  %> </TD> 
                    <TD style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700"> <% if(scheduleMgr.getConfigSchedule(ScheduleID)) {   %> <IMG SRC="images/config.jpg"  ALT="Configure Schedule by Equipment"> <% } else {  %>  <IMG SRC="images/nonconfig.jpg"  ALT="Non Configure Schedule"> <%  }  %>  </td> 
                </tr>
            </table>
        </div>
    </div>
</td>

<TD STYLE="border:0px" WIDTH="33%" VALIGN="top">
    <DIV STYLE="width:100%;border:2px solid gray;background-color:#808000;color:white;">
        <DIV ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
            <B><%=viewOP%></B> <img src="images/arrow_down.gif">
        </DIV>
        
        <DIV ALIGN="right" STYLE="width:100%;background-color:#FFFFCC;color:black;display:none;text-align:right;" ID="menu1">
            <table border="0" cellpadding="0" cellspacing="3" width="100%" bgcolor="#FFFFCC">
                <tr>
                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>//ScheduleServlet?op=viewConfg&periodicID=<%=ScheduleID%>');">
                        <B><%=vConf%></B>
                    </td>
                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>//ScheduleServlet?op=viewLabor&SID=<%=ScheduleID%>')">
                        <B><%=vLabor%></B>
                    </td>
                    <%
                    if(scheduleDocMgr.hasDocuments(ScheduleID)){
                    %>
                    <%if(request.getParameter("source").equalsIgnoreCase("eqp")){%>
                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/ScheduleDocReaderServlet?op=ListDoc&scheduleID=<%=ScheduleID%>&equipmentID=<%=id%>');">
                    <%} else {%>
                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/ScheduleDocReaderServlet?op=ListDoc&scheduleID=<%=ScheduleID%>&equipmentCat=<%=request.getParameter("equipmentCat")%><%=sType%>');">
                        <%}%>
                        <B><%=sDocList%></B>
                    </td>
                    <%
                    } else {
                    %>
                    <td style="border:1px solid black;color:white;" width="33%" bgcolor="#B7B700">
                        <B><%=sNoFilesAttched%></B>
                    </td>
                    <%
                    }
                    %>
                </tr>
            </table>
        </DIV>
    </DIV>
</TD>
<TD STYLE="border:0px" width="34%"  VALIGN="top">
    <DIV STYLE="width:100%;border:2px solid gray;background-color:#808000;color:white;">
    <DIV ONCLICK="JavaScript: changeMode('menu4');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
        <B><%=plusOp%></B> <img src="images/arrow_down.gif">
    </DIV>
    
    <DIV ALIGN="<%=align%>" STYLE="width:100%;background-color:#FFFFCC;color:black;display:none;text-align:right;" ID="menu4">
    <table border="0" cellpadding="0"  width="100%" cellspacing="3"  bgcolor="#FFFFCC">
    <tr>
        <% ConfigureMainTypeMgr mgr=ConfigureMainTypeMgr.getInstance();
        if(mgr.getOnArbitraryKey(ScheduleID,"key1").size()>0){%>
        
        <TD style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=Config%>');">
            <b><font color="white"> <%=updatePart%>   </font></b>
        </TD>
        <%}else{%>
        <TD style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=Config%>');">
            <b><font color="white"> <%=addPart%>   </font></b>
        </TD>
        <%}%>
        <%
        ScheduleTasksMgr scheduleTaskMGR=ScheduleTasksMgr.getInstance();
        System.out.println("55555555555: "+ScheduleID);
        if(scheduleTaskMGR.HasItem(ScheduleID)){%>
    <TD style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=MaintItem%>');"> <b> <font color="white"><%=updateItem%> </b></font></td>
        <%}else{%>
        <TD style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=MaintItem%>');">
            <b> <font color="white"><%=AddItem%></font>   </b>
        </TD>
        <%}%>
        <%if(request.getParameter("source").equalsIgnoreCase("eqp")){%>
        <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/ScheduleDocWriterServlet?op=SelectFile&scheduleID=<%=ScheduleID%>&equipmentID=<%=id%>');">
        <%} else {%>
        <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/ScheduleDocWriterServlet?op=SelectFile&scheduleID=<%=ScheduleID%>&equipmentCat=<%=request.getParameter("equipmentCat")%><%=sType%>');">
            <%}%>
            <B><%=sAttachDoc%></B>
        </td>
    </tr>
    </table>
    </div>
    </div>
</td>
</TR>
</TABLE>

<br>
<table align="<%=align%>" dir="<%=dir%>" border="0" width="100%">
    
    <tr>
        
        
        
    </tr>
</table>

<fieldset align="<%=align%>" class="set">
    <legend align="center">
        <table dir="rtl" align="center">
            <tr>
                <td class="td">
                    <font color="blue" size="6"> <%=viewDe%> </font>
                </td>
            </tr>
        </table>
    </legend>
    <br>
    <div class="tab-container" id="container1" style="width:100%;"> 
        <ul class="tabs"> 
            <li style="border-right: 1px solid #194367;" > 
                <a href="#" onClick="return showPane('pane1', this)" id="tab1">&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;<BR>Details</a> 
            </li> 
            <li> 
                <a href="#" onClick="return showPane('pane2', this)" id="tab2">&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;<BR>Spare Parts</a> 
            </li> 
            <!--li style="border-left: 1px solid #194367;"> 
                <a href="#" onClick="return showPane('pane3', this)" id="tab3">&#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;<BR>Workers</a> 
            </li-->
            <li style="border-left: 1px solid #194367;"> 
                <a href="#" onClick="return showPane('pane4', this)" id="tab4">&#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;<BR>Documents</a> 
            </li>
        </ul>
        <div class="tab-panes"> 
            <div class="content" id="pane1" style="text-align:center;">
                <BR><BR>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" WIDTH="600">
                    <TR>
                        <TD CLASS="cell" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16" COLSPAN="3">
                            <B><%=taskView%></B>                   
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:<%=textAlign%>;color:white;font-size:14" WIDTH="150"><B><%=title%></B></TD>
                        <TD CLASS="cell" COLSPAN="2" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=schedule.getAttribute("maintenanceTitle")%></TD>
                    </TR>
                    
                    <TR>
                        <%if(schedule.getAttribute("scheduledOn").toString().equalsIgnoreCase("Cat")){
                        name = EqCat;
                        } else {
                        name = eqp;
                        }%>
                        <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:<%=textAlign%>;color:white;font-size:14" WIDTH="150"><B><%=name%></B></TD>
                        <TD CLASS="cell" COLSPAN="2" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=unitWbo.getAttribute("unitName")%></TD>
                    </TR>
                    
                    <TR>
                        <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:<%=textAlign%>;color:white;font-size:14" WIDTH="150"><B><%=frequency%></B></TD>
                        <TD CLASS="cell" COLSPAN="2" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14" ><%=schedule.getAttribute("frequency")%>&nbsp;&nbsp;&nbsp;<FONT color=red><%=type%></FONT></TD>
                    </TR>
                    
                    <TR>
                        <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:<%=textAlign%>;color:white;font-size:14" WIDTH="150"><B><%=dur%></B></TD>
                        <TD CLASS="cell" COLSPAN="2" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=schedule.getAttribute("duration")%>&nbsp;&nbsp;&nbsp;<FONT color=red>Hours</FONT></TD>
                    </TR>
                    
                    <TR>
                        <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:<%=textAlign%>;color:white;font-size:14" WIDTH="150"><B><%=trade%></B></TD>
                        <TD CLASS="cell" COLSPAN="2" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=tradeWbo.getAttribute("tradeName")%></TD>
                    </TR>
                    
                    <TR>
                        <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:<%=textAlign%>;color:white;font-size:14" WIDTH="150"><B><%=des%></B></TD>
                        <TD CLASS="cell" COLSPAN="2" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><%=schedule.getAttribute("description")%></TD>
                    </TR>
                    
                    <%-- /*************************
        <tr>
            
            <td CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:<%=textAlign%>;color:white;font-size:14" WIDTH="150">
                <b>  <%=indGuid%></b>
            </td>
            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14">
                <%
                if(scheduleMgr.getActiveSchedule(ScheduleID)) {
                %>
                <IMG SRC="images/active.jpg"  ALT="Active Schedule by Equipment"> 
                <%
                } else {
                %> 
                <IMG SRC="images/nonactive.jpg"  ALT="Non Active Schedule">
                <% 
                }
                %>
            </TD> 
            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14">
                <%
                if(scheduleMgr.getConfigSchedule(ScheduleID)) {
                %>
                <IMG SRC="images/config.jpg"  ALT="Configure Schedule by Equipment"> 
                <%
                } else {
                %> 
                <IMG SRC="images/nonconfig.jpg"  ALT="Non Configure Schedule">
                <% 
                }
                %>
                
            </td>
            
        </tr>
    
       ***************************--%>
                </TABLE>
                <br>
            </div> 
            <div class="content" id="pane2">
                <BR><BR>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" WIDTH="600">
                    <TR>
                        <TD CLASS="cell" bgcolor="darkgoldenrod" STYLE="text-align:center;color:white;font-size:16" COLSPAN="4">
                            <B><%=viewParts%></B>                   
                        </TD>
                    </TR>
                    
                    <%
                    if(itemList.size()<=0){
                    %>
                    <TR>
                        <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14" COLSPAN="4">
                            <font color="red"><%=notCon%></font>                   
                        </TD>
                    </TR>
                    <%
                    } else {
                    %>
                    <TR>
                        <%
                        for(int i=0; i < itemTitle.length; i++){
                        %>
                        <%if(i==1){%>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250"><B><%=itemTitle[i]%></B></TD>
                        <% } else if(i==2){%>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="50"><B><%=itemTitle[i]%></B></TD>
                        <%} else {%>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="150"><B><%=itemTitle[i]%></B></TD>
                        <%
                        }
                        }
                        %>
                    </TR>
                    <%
                    }
                    %>
                    
                    <%
                    Enumeration e = itemList.elements();
                    
                    while(e.hasMoreElements()) {
                        wbo = (WebBusinessObject) e.nextElement();
                    %>
                    <TR bgcolor="#FFE391">
                        <%
                        attName = itemAtt[0];
                        attValue = (String) wbo.getAttribute(attName);
                        %>
                        <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14">
                            <%=maintenanceItemMgr.getOnSingleKey(attValue).getAttribute("itemCode").toString()%>
                        </TD>
                        <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14">
                            <%=maintenanceItemMgr.getOnSingleKey(attValue).getAttribute("itemDscrptn").toString()%>
                        </TD>
                        <%
                        attName = itemAtt[1];
                        attValue = (String) wbo.getAttribute(attName);
                        %>
                        <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14">
                            <%=attValue%>
                        </TD>
                        <%
                        attName = itemAtt[2];
                        attValue = (String) wbo.getAttribute(attName);
                        %>
                        <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14">
                            <%=attValue%>
                        </TD>
                    </TR>
                    <%
                    }
                    %>
                </TABLE>
            </div> 
            <div class="content" id="pane3">
                <BR><BR>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>"  border="0"   ID="listTable">
                    
                    <TR>
                        
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250"  > <b><%=sMaintenanceItemCode%></b></TD>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250" ><b><%=sMaintenanceItemName%> </b></TD>        
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250" ><b><%=sRequiredTask%> </b></TD>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250" ><b><%=sEstimatedTime%> </b></TD>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250" ><b><%=TaskDesc%> </b></TD>
                        <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250" ><b><%=sPriority%> </b></TD>
                        
                        
                        
                        <%
                        ScheduleTasksMgr scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                        TaskMgr taskMgr=TaskMgr.getInstance();
                        Vector items= scheduleTasksMgr.getOnArbitraryKey(ScheduleID,"key1");
                        
                        %>
                        <td>
                            <input type="hidden" name="con" id="con" value="<%=items.size()%>">
                        </td>
                    </TR>
                    <%
                    for(int i=0;i<items.size();i++){
                            WebBusinessObject web=( WebBusinessObject)items.get(i);
                            
                            WebBusinessObject web2=taskMgr.getOnSingleKey((String)web.getAttribute("codeTask"));
                            WebBusinessObject web3= tradeMgr.getOnSingleKey((String)web2.getAttribute("trade"));
                    %>
                    <tr>
                        
                        <td  CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14"><%=(String)web2.getAttribute("title")%></td>
                        <td  CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14"><%=(String)web2.getAttribute("name")%></td>
                        
                        <td  CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14"><%=(String)web3.getAttribute("tradeName")%></td>
                        <td  CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14"><%=(String)web2.getAttribute("executionHrs")%></td>
                        <td  CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14"><%=(String)web.getAttribute("desc")%></td>
                        <td  CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14"><%=(String)web.getAttribute("priority")%></td>
                        
                    </tr>
                    <%}%>
                    
                </TABLE>
            </div>
            <div class="content" id="pane4">
                <jsp:include page="/docs/schedule_doc_handling/tab_docs_list.jsp" flush="true" />
            </div>
        </div> 
    </div>
    
    
    <br>
</fieldset>
</BODY>
</html>
