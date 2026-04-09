<%@ page import="com.docviewer.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@ page import="com.contractor.db_access.MaintainableMgr, com.maintenance.db_access.*, com.tracker.db_access.*"%>  
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
FileMgr fileMgr = FileMgr.getInstance();
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
ProjectMgr projectMgr = ProjectMgr.getInstance();
SupplierMgr supplierMgr = SupplierMgr.getInstance();
DepartmentMgr deptMgr = DepartmentMgr.getInstance();
EmployeeMgr empMgr = EmployeeMgr.getInstance();
SupplierEquipmentMgr equipSupMgr = SupplierEquipmentMgr.getInstance();
EquipOperationMgr eqpOpMgr = EquipOperationMgr.getInstance();
AverageUnitMgr averageUnitMgr = AverageUnitMgr.getInstance();
ProductionLineMgr  productionLineMgr = ProductionLineMgr.getInstance();

String context = metaMgr.getContext();
String backTarget=null;

WebBusinessObject equipmentWBO = (WebBusinessObject) maintainableMgr.getOnSingleKey((String) request.getAttribute("equipID"));
WebBusinessObject wboTemp = maintainableMgr.getOnSingleKey(equipmentWBO.getAttribute("parentId").toString());
WebBusinessObject locationWBO = projectMgr.getOnSingleKey(equipmentWBO.getAttribute("site").toString());
WebBusinessObject deptWBO = deptMgr.getOnSingleKey(equipmentWBO.getAttribute("department").toString());
WebBusinessObject productionLineWBO = productionLineMgr.getOnSingleKey(equipmentWBO.getAttribute("productionLine").toString());

WebBusinessObject empWBO = empMgr.getOnSingleKey(equipmentWBO.getAttribute("empID").toString());
WebBusinessObject eqSupWBO = equipSupMgr.getOnSingleKey(equipmentWBO.getAttribute("id").toString());
WebBusinessObject supWBO = supplierMgr.getOnSingleKey((String) eqSupWBO.getAttribute("supplierID"));
WebBusinessObject contEmpWBO = empMgr.getOnSingleKey(eqSupWBO.getAttribute("contractEmp").toString());
Vector eqpOpVector = eqpOpMgr.getOnArbitraryKey(equipmentWBO.getAttribute("id").toString(), "key1");
WebBusinessObject eqpOpWbo = (WebBusinessObject) eqpOpVector.elementAt(0);

String unitName=equipmentWBO.getAttribute("unitName").toString();
request.setAttribute("unitName",unitName);

Vector data=new Vector();
data.add(equipmentWBO);

request.getSession().setAttribute("info", data);
response.addHeader("Pragma","No-cache");
response.addHeader("Cache-Control","no-cache");
response.addDateHeader("Expires",1);

Vector imagePath = (Vector) request.getAttribute("imagePath");

backTarget=context+"/main.jsp";

String dateAcquired = eqSupWBO.getAttribute("purchaseDate").toString();
String expiryDate = eqSupWBO.getAttribute("warrantyExpDate").toString();
EqChangesMgr eqChangesMgr = EqChangesMgr.getInstance();
Vector vecChanges = eqChangesMgr.getOnArbitraryKey(((String) equipmentWBO.getAttribute("id")), "key1");

String equipmentID = (String) request.getAttribute("equipID");
UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();
boolean active = maintainableMgr.hasSchedules(equipmentID);
EquipmentStatusMgr equipmentStatusMgr = EquipmentStatusMgr.getInstance();
WebBusinessObject tempWbo = equipmentStatusMgr.getLastStatus(equipmentID);
int currentStatus = 2;
if(tempWbo != null){
    String stateID = (String) tempWbo.getAttribute("stateID");
    currentStatus = new Integer(stateID).intValue();
}
String url=context+"/EquipmentServlet?op=ListEquipment";
if(session.getAttribute("CategoryID")!=null){
    url=context+"/EquipmentServlet?op=ViewUnits&categoryId="+(String)session.getAttribute("CategoryID");
}
String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,tit,save,cancel,TT,SNA,tit1,RU,EMP,STAT,NO,Reading,Excellent,Good,Poor,updateHours,listHours,updateKm,listKm,Emergency,sSupplier,sSupplierList;
String back="&#1575;&#1604;&#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607;";
if(stat.equals("En")){
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    tit="View File";
    tit1="Select File Type";
    save="Attach";
    cancel="Back To List";
    TT="Select File Type ";
    SNA="Site Name";
    RU="Waiting Business Rule";
    EMP="Employee Name";
    STAT="Attaching Status";
    NO="Attach File Before Filling Information";
    Excellent="Excellent";
    Good="Good";
    Poor="Poor";
    updateHours = "Update Equipment Hours";
    listHours = "List Equipment Hours";
    updateKm = "Update Equipment By Odometer";
    listKm = "List Equipment By Odometer";
    Emergency = "Emergency Order";
	sSupplier = "Add External Supplier";
    sSupplierList = "List External Supplier";
}else{
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    tit="  &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;  ";
    tit1="&#1573;&#1582;&#1578;&#1575;&#1585; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    save="&#1573;&#1585;&#1601;&#1602;";
    cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    TT="&#1573;&#1582;&#1578;&#1575;&#1585; &#1605;&#1604;&#1601;";
    SNA="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    RU="&#1605;&#1606;&#1578;&#1592;&#1585; &#1602;&#1575;&#1593;&#1583;&#1577; &#1593;&#1605;&#1604;";
    EMP="&#1573;&#1587;&#1605; &#1575;&#1604;&#1608;&#1592;&#1601;";
    STAT=" &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1573;&#1585;&#1601;&#1575;&#1602;";
    NO="&#1573;&#1585;&#1601;&#1602; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583; &#1602;&#1576;&#1604; &#1605;&#1604;&#1574; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578;";
    Excellent="&#1605;&#1605;&#1578;&#1575;&#1586;&#1607;";
    Good="&#1580;&#1610;&#1583;";
    Poor="&#1585;&#1583;&#1610;&#1574;&#1607;";
    updateHours="&#1578;&#1581;&#1583;&#1610;&#1579; &#1587;&#1575;&#1593;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    listHours = "&#1593;&#1585;&#1590; &#1587;&#1575;&#1593;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    updateKm = "&#1578;&#1581;&#1583;&#1610;&#1579; &#1603;&#1610;&#1604;&#1608; &#1605;&#1578;&#1585;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    listKm = "&#1593;&#1585;&#1590; &#1603;&#1610;&#1604;&#1608; &#1605;&#1578;&#1585;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    Emergency = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1575;&#1605;&#1585; &#1588;&#1594;&#1604; &#1591;&#1575;&#1585;&#1574;";
    sSupplier = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1605;&#1608;&#1585;&#1583; &#1582;&#1575;&#1585;&#1580;&#1610;";
    sSupplierList = "&#1593;&#1585;&#1590; &#1605;&#1608;&#1585;&#1583; &#1582;&#1575;&#1585;&#1580;&#1610;";
   
    }

	WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

	GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
	Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");

	ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
        }
%>

<SCRIPT language="JavaScript1.3">
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
</SCRIPT>

<style type="text/css"> 
    <!-- 
.tabs {position:relative; left: 5; top: 3; border:1px solid #194367; height: 60px; width: 850; margin: 0; padding: 0; background:#C0D9DE; overflow:hidden; } 
.tabs li {display:inline} 
.tabs a:hover, .tabs a.tab-active {background:#fff;} 
.tabs a { height: 40px; font:11px verdana, helvetica, sans-serif;font-weight:bold; 
       position:relative; padding:6px 10px 10px 10px; margin: 0px -4px 0px 0px; color:#2B4353;text-decoration:none; } 
.tab-container { background: #fff; border:0px solid #194367; height:320px; width:500px} 
.tab-panes { margin: 3px; border:1px solid #194367; height:320px} 
div.content { padding: 5px; }
</style>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Maintenance - View Equipment Details</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <BODY onload='setupPanes("container1", "tab1");'>
        <DIV align="left" STYLE="color:blue;">
            
            <button onclick="changePage('<%=url%>')" class="button"><%=back%> <img src="images/leftarrow.gif"></button>
            
        </DIV>
         
        
        
        <BR>
        
        <TABLE BORDER="0" CELLSPACING="2" CELLPADDING="2" ALIGN="right" WIDTH="100%">
            <TR>
                <TD STYLE="border:0px" WIDTH="30%" VALIGN="top">
                    <DIV STYLE="width:100%;border:2px solid gray;background-color:#808000;color:white;">
                        <DIV ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                            <B>&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; / Viewing Operations</B> <img src="images/arrow_down.gif">
                        </DIV>
                        
                        <DIV ALIGN="right" STYLE="width:100%;background-color:#FFFFCC;color:black;display:none;text-align:right;" ID="menu1">
                            <table border="0" cellpadding="0" cellspacing="3" width="100%" bgcolor="#FFFFCC">
                                <tr>
                                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/ScheduleServlet?op=ListEqpSchedules&amp;source=other&amp;equipment=<%=equipmentWBO.getAttribute("id").toString()%>');">
                                        <B>&#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;</B>
                                    </td>
                                    <%
                                    if(vecChanges.size() > 0){
                                    %>
                                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/EquipmentServlet?op=ListChanges&equipmentID=<%=equipmentID%>&action=view');">
                                        <B>&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1594;&#1610;&#1610;&#1585;&#1575;&#1578;</B>
                                    </td>
                                    <%
                                    } else {
                                    %>
                                    <td style="border:1px solid black;color:white;" width="33%" bgcolor="#B7B700" >
                                        <B>&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1578;&#1594;&#1610;&#1610;&#1585;&#1575;&#1578;</B>
                                    </td>
                                    <%
                                    }
                                    %>
                                    <%
                                    if(unitDocMgr.hasDocuments(equipmentID)){
                                    %>
                                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/UnitDocReaderServlet?op=ListDoc&equipmentID=<%=equipmentID%>');">
                                        <B>&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;</B>
                                    </td>
                                    <%
                                    } else {
                                    %>
                                    <td style="border:1px solid black;color:white;" width="33%" bgcolor="#B7B700">
                                        <B>&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1605;&#1585;&#1601;&#1602;&#1607;</B>
                                    </td>
                                    <%
                                    }
                                    %>
                                </tr>
                                
                                <tr>
                                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/EquipmentServlet?op=ListJobOrders&equipmentID=<%=equipmentID%>');">
                                        <B>&#1578;&#1575;&#1585;&#1610;&#1582; &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;</B>
                                    </td>
                                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/EqStateTypeServlet?op=ViewStatusHistory&equipmentID=<%=equipmentID%>');">
                                        <B>&#1578;&#1600;&#1600;&#1575;&#1585;&#1610;&#1600;&#1582; &#1575;&#1604;&#1581;&#1600;&#1600;&#1575;&#1604;&#1600;&#1600;&#1577;</B>
                                    </td>
                                    <%if(equipmentWBO.getAttribute("rateType").equals("fixed")){%>
                                    <td style="border:1px solid black;color:white;cursor:hand;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/AverageUnitServlet?op=ListAverageUnitForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>');"> 
                                        <B><%=listHours%></B>
                                    </td>
                                    <%} else {%>
                                    <td style="border:1px solid black;color:white;cursor:hand;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/AverageUnitServlet?op=ListAverageKelUnitForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>');"> 
                                        <B><%=listKm%></B>
                                    </td>
                                    <%}%>
                                </tr>
<tr>
                                    <td style="border:1px solid black;color:white;cursor:hand;" width="33%"   bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/EquipmentServlet?op=ListEquipmentSuppliers&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>')">
                                        <B><%=sSupplierList%></B>
                                    </td>
                                    <td style="border:1px solid black;color:white;" width="33%" bgcolor="#B7B700"> 
                                        <B>&nbsp;</B>
                                    </td>
                                    <td style="border:1px solid black;color:white;" width="33%" bgcolor="#B7B700"> 
                                        <B>&nbsp;</B>
                                    </td>
                                   
                                </tr>
                            </table>
                        </DIV>
                    </DIV>
                </TD>
                <TD STYLE="border:0px" WIDTH="30%" VALIGN="top">
                    <DIV STYLE="width:100%;border:2px solid gray;background-color:#808000;color:white;">
                        <DIV ONCLICK="JavaScript: changeMode('menu2');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                            <B>&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1573;&#1590;&#1575;&#1601;&#1577; / Addition Operations</B> <img src="images/arrow_down.gif">
                        </DIV>
                        
                        <DIV ALIGN="right" STYLE="width:100%;background-color:#FFFFCC;color:black;display:none;text-align:right;" ID="menu2">
                            <table border="0" cellpadding="0" cellspacing="3" width="100%" bgcolor="#FFFFCC">
                                <tr>
                                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/ScheduleServlet?op=BindSingleSchedUnit&equipmentID=<%=equipmentID%>');">
                                        <B>&#1585;&#1576;&#1591; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; &#1576;&#1580;&#1583;&#1608;&#1604; &#1589;&#1610;&#1575;&#1606;&#1577;</B>
                                    </td>
                                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/EquipmentServlet?op=GetChangeForm&equipmentID=<%=equipmentID%>');">
                                        <B>&#1578;&#1594;&#1610;&#1610;&#1585;&#1575;&#1578; &#1593;&#1604;&#1610; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</B>
                                    </td>
                                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/UnitDocWriterServlet?op=SelectFile&equipmentID=<%=equipmentID%>');">
                                        <B>&#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;</B>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td style="border:1px solid black;cursor:hand;color:white; display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>;" width="33%"   bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/UnitDocWriterServlet?op=excel&unitName=<%=equipmentWBO.getAttribute("unitName")%>')">
                                        <B> Excel <img src="<%=context%>/images/xlsicon.gif"></B>
                                    </td>
                                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/EqStateTypeServlet?op=ChangeStatusForm&equipmentID=<%=equipmentID%>&currentStatus=<%=currentStatus%>');">
                                        <B>&#1578;&#1594;&#1610;&#1610;&#1600;&#1585; &#1575;&#1604;&#1581;&#1600;&#1600;&#1575;&#1604;&#1600;&#1600;&#1577;</B>
                                    </td>
                                    <%if(equipmentWBO.getAttribute("rateType").equals("fixed")){%>
                                    <td style="border:1px solid black;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/AverageUnitServlet?op=UpdateAverageUnitForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>');"> 
                                        <B><%=updateHours%></B>
                                    </td>
                                    <%} else {%>
                                    <td style="border:1px solid black;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/AverageUnitServlet?op=UpdateAverageKelUnitForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>');"> 
                                        <B><%=updateKm%></B>
                                    </td>
                                    <%}%>
                                </tr>
                                <tr>
                                    <td style="border:1px solid black;cursor:hand;color:white;" width="33%" bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/IssueServlet?op=EmgByEquip&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>')">
                                        <B><%=Emergency%></B>
                                    </td>
                                    <td style="border:1px solid black;color:white;cursor:hand;" width="33%"   bgcolor="#B7B700" onclick="JavaScript: changePage('<%=context%>/EquipmentServlet?op=GetSupplierForm&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>')">
                                        <B><%=sSupplier%></B>
                                    </td>
                                    
                                    <td style="border:1px solid black;color:white;" width="33%" bgcolor="#B7B700"> 
                                        <B>&nbsp;</B>
                                    </td>
                                   
                                </tr>
                            </table>
                        </DIV>
                    </DIV>
                </TD>
                
                <TD STYLE="border:0px" WIDTH="30%" VALIGN="top">
                <DIV STYLE="width:100%;border:2px solid gray;background-color:#808000;color:white;">
                <DIV ONCLICK="JavaScript: changeMode('menu3');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                    <B>&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585; / Indicators Guide</B> <img src="images/arrow_down.gif">
                </DIV>
                
                <DIV STYLE="width:100%;background-color:#FFFFCC;color:black;display:none;" ID="menu3">
                    <table border="0" cellpadding="0" cellspacing="3" width="100%" bgcolor="#FFFFCC">
                        <tr>
                            <td style="border:1px solid black;color:white;text-align:right;" width="100%" bgcolor="#B7B700">
                                <%
                                if(tempWbo != null){
    if(tempWbo.getAttribute("stateID").equals("1")){
                                %>
                                <B>Working Equipment / &#1605;&#1593;&#1583;&#1607; &#1578;&#1593;&#1605;&#1604;</B> <img src="images/good.jpg" border="0"  alt="Poor Status">
                                <%
                                } else {
                                %>
                                <B>Out of Work Equipment / &#1605;&#1593;&#1583;&#1607; &#1604;&#1575;&#1578;&#1593;&#1605;&#1604;</B> <img src="images/ungood.jpg" border="0"  alt="Poor Status">
                                <%
                                }
                                } else {
                                %>
                                <B>Out of Work Equipment / &#1605;&#1593;&#1583;&#1607; &#1604;&#1575;&#1578;&#1593;&#1605;&#1604;</B> <img src="images/ungood.jpg" border="0"  alt="Poor Status">
                                <%
                                }
                                %>
                            </td>
                        </tr>
                        <tr>
                            <td style="border:1px solid black;color:white;text-align:right;" width="100%" bgcolor="#B7B700">
                                <%
                                String imgName = new String("");
                                String eqStatus = new String("");
                                if(equipmentWBO.getAttribute("status").equals("1")){
                                    imgName = "green.gif";
                                    eqStatus = "Excellent Status / &#1581;&#1575;&#1604;&#1577; &#1580;&#1610;&#1583;&#1577; &#1580;&#1583;&#1575;";
                                } else if(equipmentWBO.getAttribute("status").equals("2")){
                                    imgName = "yellow.gif";
                                    eqStatus = "Good Status / &#1581;&#1575;&#1604;&#1577; &#1580;&#1610;&#1583;&#1577;";
                                } else {
                                    imgName = "red.gif";
                                    eqStatus = "Poor Status / &#1581;&#1575;&#1604;&#1577; &#1585;&#1583;&#1610;&#1574;&#1577;";
                                }
                                %>
                                <B><%=eqStatus%></B> <img src="images/<%=imgName%>" border="0">
                            </td>
                        </tr>
                        <tr>
                            <td style="border:1px solid black;color:white;text-align:right;" width="100%" bgcolor="#B7B700">
                                <%
                                if(active){
                                %>
                                <B>Active Equipment / &#1605;&#1593;&#1583;&#1577; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604;</B> <IMG SRC="images/active.jpg" ALT="Active Equipment" ALIGN="center">
                                <%
                                } else {
                                %>
                                <B>Non Active Equipment / &#1605;&#1593;&#1583;&#1577; &#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604;</B> <IMG SRC="images/nonactive.jpg" ALT="Non Active Equipment" ALIGN="center">
                                <%
                                }
                                %>
                            </TD>
                        </TR>
                    </TABLE>
                </DIV>
            </TR>
        </TABLE>
        <br><br><br><br><br>
        
        <center>
        <fieldset align="center" class="set">
            <legend align="center">
                <table dir="rtl" align="center">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">
                                &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; / View Equipment
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            <div class="tab-container" id="container1" style="width:100%;text-align:left;"> 
                <ul class="tabs"> 
                    <li style="border-right: 1px solid #194367;" > 
                        <a href="#" onClick="return showPane('pane1', this)" id="tab1">&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;<BR>Details<img src="images/metal-Inform.gif" width="20px" alt="" /></a> 
                    </li> 
                    <li> 
                        <a href="#" onClick="return showPane('pane2', this)" id="tab2">&#1589;&#1610;&#1575;&#1606;&#1577; 6 &#1571;&#1588;&#1607;&#1585; &#1605;&#1587;&#1578;&#1602;&#1576;&#1604;&#1610;&#1607;<BR>Future 6 Months<br> Job Orders</a> 
                    </li> 
                    <li style="border-left: 1px solid #194367;"> 
                        <a href="#" onClick="return showPane('pane3', this)" id="tab3">&#1589;&#1610;&#1575;&#1606;&#1577; &#1570;&#1582;&#1585; 6 &#1571;&#1588;&#1607;&#1585;<BR>Last 6 Months<br> Job Orders</a> 
                    </li>
                    <li style="border-left: 1px solid #194367;"> 
                        <a href="#" onClick="return showPane('pane4', this)" id="tab4">&#1580;&#1583;&#1608;&#1575;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1593;&#1604;&#1609; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;<BR>Schedule Type</a> 
                    </li>
                    <li style="border-left: 1px solid #194367;"> 
                        <a href="#" onClick="return showPane('pane5', this)" id="tab5">&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1593;&#1604;&#1609; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;<BR>Task Type</a> 
                    </li>
                    <li style="border-left: 1px solid #194367;"> 
                        <a href="#" onClick="return showPane('pane6', this)" id="tab6">&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1593;&#1604;&#1609; &#1589;&#1606;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;<BR>Schedule Type<br>by Category</a> 
                    </li>
                    <li style="border-left: 1px solid #194367;"> 
                        <a href="#" onClick="return showPane('pane7', this)" id="tab7">&#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578; &#1575;&#1604;&#1605;&#1585;&#1601;&#1602;&#1577; &#1604;&#1604;&#1605;&#1593;&#1583;&#1577;<BR>Attached documents</a> 
                    </li>
                    
                </ul> 
                
                <div class="tab-panes"> 
                    <div class="content" id="pane1" style="text-align:center;">
                        <br>
                        <TABLE  WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                            <TR>
                                <TD CLASS="td">
                                    <TABLE  WIDTH="600" CELLPADDING="0" CELLSPACING="0">
                                        <TR>
                                            <TD CLASS="td" bgcolor="darkgoldenrod" STYLE="text-align:center;color:white;font-size:16" COLSPAN="3">
                                                <B>&#1602;&#1585;&#1575;&#1569;&#1607; &#1593;&#1583;&#1575;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; / Equipment Counter Reading</B>
                                            </TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="td" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14">
                                                <B>Total<br>&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;</B>
                                            </TD>
                                            <TD CLASS="td" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14">
                                                <B>Last Reading<br>&#1570;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;</B>
                                            </TD>
                                            <TD CLASS="td" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14">
                                                <B>Last Reading Date<br>&#1578;&#1575;&#1585;&#1610;&#1582; &#1570;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;</B>
                                            </TD>                   
                                        </TR>
                                        
                                        <TR>
                                            <%
                                            Vector items = averageUnitMgr.getOnArbitraryKey(equipmentID, "key1");
                                            if(items.size() > 0){
                                                for(int i = 0; i < items.size(); i++){
                                                    WebBusinessObject wbo = (WebBusinessObject) items.elementAt(i);
                                                    WebBusinessObject categoryName = (WebBusinessObject) maintainableMgr.getOnSingleKey(wbo.getAttribute("unitName").toString());
                                                    String unit = "";
                                                    if(equipmentWBO.getAttribute("rateType").equals("odometer")){
                                                        unit = "km";
                                                    } else {
                                                        unit = "hr";
                                                    }
                                            %>
                                            <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;"><%=wbo.getAttribute("acual_Reading").toString()%>&nbsp;<%=unit%></TD>
                                            <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;"><%=wbo.getAttribute("current_Reading").toString()%>&nbsp;<%=unit%></TD>
                                            <%
                                            Date d = Calendar.getInstance().getTime();
                                            String readingDate = (String) wbo.getAttribute("entry_Time");
                                            Long l = new Long(readingDate);
                                            long sl = l.longValue();
                                            d.setTime(sl);
                                            readingDate = d.toString();
                                            readingDate = readingDate.substring(0,10)+readingDate.substring(23,28);      
                                            %>
                                            <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;"><%=readingDate%></TD>
                                            <%
                                                }
                                            } else {
                                            %>
                                            <TD CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;" COLSPAN="3">No Reading for this equipment <br> &#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1602;&#1585;&#1575;&#1569;&#1577; &#1604;&#1607;&#1584;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;</TD>
                                            <%
                                            }
                                            %>
                                        </TR>
                                    </TABLE>
                                </TD>
                                <TD CLASS="td">
                                </TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="td">&nbsp;</TD>
                                <TD CLASS="td">&nbsp;</TD>
                            </TR>
                            
                            <TR>
                                <TD CLASS="td">
                                    <TABLE WIDTH="600" BORDER="0" CELLSPACING="0">
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                                <B>Basic Information / &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1610;&#1607;</B>   
                                            </TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Asset No / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1607;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("unitNo")%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B><%=tGuide.getMessage("equipmentname")%> / &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("unitName")%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Engine Number / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1581;&#1585;&#1603;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("engineNo")%></TD>
                                        </TR>
                                        
                                        <!--TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Auth. Employee / &#1575;&#1604;&#1605;&#1608;&#1592;&#1601; &#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%//=empWBO.getAttribute("empName")%></TD>
                                        </TR-->
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Location / &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=locationWBO.getAttribute("projectName")%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Department / &#1575;&#1604;&#1602;&#1587;&#1605;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=deptWBO.getAttribute("departmentName")%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Production Line / &#1582;&#1591; &#1575;&#1604;&#1573;&#1606;&#1578;&#1575;&#1580;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=productionLineWBO.getAttribute("code")%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Category / &#1575;&#1604;&#1589;&#1606;&#1601;</B></TD>
                                            <TD CLASS="cell" bgcolor="darkkhaki" STYLE="text-align:center;font-size:12"><B><%=wboTemp.getAttribute("unitName")%></B></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Status / &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;</B></TD>
                                            <%
                                            String status;
                                            if(equipmentWBO.getAttribute("status").toString().equalsIgnoreCase("Excellent")){
                                                status = Excellent;
                                            } else if(equipmentWBO.getAttribute("status").toString().equalsIgnoreCase("Good")){
                                                status = Good;
                                            } else {
                                                status = Poor;
                                            }
                                            %>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=status%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B><%=tGuide.getMessage("equipmentdescription")%> / &#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("desc")%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                                <B>Operation Data / &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1593;&#1605;&#1604;</B>   
                                            </TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Equipment Type / &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;</B></TD>
                                            <TD CLASS="cell" bgcolor="darkkhaki" STYLE="text-align:center;font-size:12"><B><%=equipmentWBO.getAttribute("rateType")%></B></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Operation Type / &#1606;&#1608;&#1593; &#1575;&#1604;&#1593;&#1605;&#1604;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=eqpOpWbo.getAttribute("operation_type")%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Average / &#1575;&#1604;&#1605;&#1578;&#1608;&#1587;&#1591;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=eqpOpWbo.getAttribute("average")%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                                <B>Manufacturing Data / &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1578;&#1589;&#1606;&#1610;&#1593;</B>   
                                            </TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Manufacturer / &#1575;&#1604;&#1605;&#1589;&#1606;&#1593;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("manufacturer")%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Model No / &#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1583;&#1610;&#1604;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("modelNo")%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Serial No / &#1575;&#1604;&#1587;&#1585;&#1610;&#1575;&#1604;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=equipmentWBO.getAttribute("serialNo")%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Notes / &#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=eqSupWBO.getAttribute("note")%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:14" COLSPAN="2">
                                               <B>Warranty Data / &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;</B>   
                                             </TD>
                                        </TR>
                                        
                                        <!--TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Supplier / &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%//=supWBO.getAttribute("name")%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Contractor  / &#1575;&#1604;&#1605;&#1578;&#1593;&#1575;&#1602;&#1583;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%//=contEmpWBO.getAttribute("empName")%></TD>
                                        </TR-->
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Dealing Method / &#1591;&#1576;&#1610;&#1593;&#1577; &#1575;&#1604;&#1578;&#1593;&#1575;&#1605;&#1604;</B></TD>
                                            <%if(eqSupWBO.getAttribute("warranty").equals("1")){%>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12">Contract / &#1578;&#1593;&#1575;&#1602;&#1583;</TD>
                                            <%} else {%>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12">Warranty / &#1590;&#1605;&#1575;&#1606;</TD>
                                            <%}%>
                                        </TR>
                                        
                                        <TR>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Purchase Date / &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1588;&#1585;&#1575;&#1569;</B></TD>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=dateAcquired.substring(0,10)%></TD>
                                        </TR>
                                        
                                        <TR>
                                            <%if(eqSupWBO.getAttribute("warranty").equals("1")){%>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Contract Date / &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1578;&#1593;&#1575;&#1602;&#1583;</B></TD>
                                            <%} else {%>
                                            <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:left;color:white;font-size:12" WIDTH="200"><B>Warranty Date / &#1578;&#1575;&#1585;&#1610;&#1582; &#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;</B></TD>
                                            <%}%>
                                            <TD CLASS="cell" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:12"><%=expiryDate.substring(0,10)%></TD>
                                        </TR>
                                    </TABLE>
                                </TD>
                                <TD CLASS="td3">
                                    <TABLE>
                                        <%
                                        if(imagePath.size() > 0){
                                        for(int i = 0; i < imagePath.size(); i++){
                                        %>
                                        <TR>
                                            <TD class='td3'>
                                                <img name='docImage' alt='document image' src='<%=imagePath.get(i).toString()%>'  width="250" height="200">
                                            </TD>
                                        </TR>
                                        <%
                                        }
                                        } else {
                                        %>
                                        <TR>
                                            <TD class='td'>
                                                <img name='docImage' alt='document image' src='images/no_image.jpg' border="2">
                                            </TD>
                                        </tr>
                                        <%
                                        }
                                        %>
                                    </Table>
                                </TD>
                            </TR>
                        </TABLE>
                        <br>
                    </div>
                    <div class="content" id="pane2">
                        <BR><BR>
                        <jsp:include page="/docs/equipment/future_maintenance.jsp" flush="true" />
                    </div>
                    <div class="content" id="pane3">
                        <BR><BR>
                        <jsp:include page="/docs/equipment/last_maintenance.jsp" flush="true" />
                    </div>
                    <div class="content" id="pane4">
                        <BR><BR>
                        <jsp:include page="/docs/schedule/List_all_eqp_schedules_by_tap.jsp" flush="true" />
                    </div>
                    <div class="content" id="pane5">
                        <BR><BR>
                        <jsp:include page="/docs/schedule/List_all_eqp_tasks_by_tap.jsp" flush="true" />
                    </div>
                    <div class="content" id="pane6">
                        <BR><BR>
                        <jsp:include page="/docs/schedule/List_all_eqpCat_tasks_by_tap.jsp" flush="true" />
                    </div>
                    <div class="content" id="pane7">
                        <BR><BR>
                        <jsp:include page="/docs/unit_doc_handling/docs_list_by_tap.jsp" flush="true" />
                    </div>
                    
                </div> 
            </div>
            <br>
        </fieldset>
    </BODY>
</HTML>     
