<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*,com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>


<%



MetaDataMgr metaMgr = MetaDataMgr.getInstance();
EquipMaintenanceTypeMgr equipMaintenanceTypeMgr = EquipMaintenanceTypeMgr.getInstance();
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
String context = metaMgr.getContext();
Vector items = new Vector();

DepartmentMgr  departmentMgr=DepartmentMgr.getInstance();


TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,Indicators_guide,noFound,Active_Schedule,noAct,Maintenance_Type,ViewTask ,edit,eq_Name,listMainType,
        view, delete,viewconfiged,cannotDel,IG,QS,BO,cntDelete,Add_Task,notConfig,Config,addTask,viewTasks,indicator,configed,unconfig,taskNum
        ;

if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    Indicators_guide="Indicators guide";
    Active_Schedule="Active Schedule";
    noAct="Non Active Schedule";
    ViewTask="View Tasks";
    cannotDel="You can't delete Maintenance Type";
    edit="Edit";
    view="View";
    delete="Delete";
    IG="Indicators guide ";
    
    BO="Basic Operations";
    QS="Quick Summary";
    viewconfiged="View Configured Tasks";
    cntDelete="You Can't Delete That Task" ;
    notConfig="Not Configured";
    Config="Configure";
    addTask="Add New Task";
    viewTasks=" List of Maintenance Type";
    taskNum="Tasks Number";
    indicator="Indicators guide";
    configed="Active Maintenance Type by Task ";
    unconfig="Non Active Maintenance Type ";
    eq_Name="Equipment Category Name:";
    listMainType="List of Maintenance Type";
    Maintenance_Type="Maintenance Type";
    Add_Task="Add Task";
    noFound="No Unit Found";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    cannotDel="&#1604;&#1575; &#1578;&#1587;&#1578;&#1591;&#1610;&#1593; &#1581;&#1584;&#1601; &#1606;&#1608;&#1593; &#1589;&#1610;&#1575;&#1606;&#1607;";
    Add_Task="&#1573;&#1590;&#1575;&#1601;&#1607; &#1605;&#1607;&#1605;&#1607;";
    noFound="&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1575;&#1580;&#1586;&#1575;&#1569;";
    Indicators_guide=" &#1575;&#1604;&#1605;&#1585;&#1588;&#1583;";
    Active_Schedule="&#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    noAct=" &#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    ViewTask="  &#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1607;&#1575;&#1605;";
    edit="&#1578;&#1581;&#1585;&#1610;&#1585;";
    view="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
    delete="&#1581;&#1584;&#1601;";
    
    IG="&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    
    QS="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
    BO="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
    Maintenance_Type="&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    addTask=" &#1571;&#1590;&#1601; &#1605;&#1607;&#1605;&#1607;";
    cntDelete=" &#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
    viewconfiged="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; &#1575;&#1604;&#1605;&#1585;&#1578;&#1576;&#1591;&#1607; &#1576;&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
    notConfig="&#1604;&#1605; &#1578;&#1585;&#1578;&#1576;&#1591; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    Config="&#1575;&#1585;&#1576;&#1591; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    viewTasks="&#1593;&#1585;&#1590; &#1575;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    taskNum="&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1607;&#1575;&#1605;";
    configed="&#1606;&#1608;&#1593; &#1589;&#1610;&#1575;&#1606;&#1607; &#1605;&#1601;&#1593;&#1604;";
    eq_Name="&#1575;&#1587;&#1605; &#1589;&#1606;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    indicator="&#1575;&#1604;&#1605;&#1585;&#1588;&#1583;&nbsp; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    listMainType="&#1593;&#1585;&#1590; &#1575;&#1589;&#1606;&#1575;&#1601; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    unconfig="&#1606;&#1608;&#1593; &#1589;&#1610;&#1575;&#1606;&#1607; &#1594;&#1610;&#1585; &#1605;&#1601;&#1593;&#1604;";
    
}

%>

<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>DebugTracker-add new Employee</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        { 
      
    if (this.ITEM_FORM.current_Reading.value ==""){
        alert ("Enter current reading");
        this.ITEM_FORM.current_Reading.focus(); 
    }else if (this.ITEM_FORM.description.value ==""){
        alert ("Enter description");
        this.ITEM_FORM.description.focus(); 
    } else if (!IsNumeric(this.ITEM_FORM.current_Reading.value)){
        alert ("Not a valid Number");
        this.ITEM_FORM.current_Reading.focus();    
   
    }else{
       
        document.ITEM_FORM.action = "<%=context%>/AverageUnitServlet?op=SaveAverageUnit";
        document.ITEM_FORM.submit();  
        }
       }
        
       function checkEmail(email) {
        if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){
            return (true)
        }
            return (false)
    }
       
        function IsNumeric(sText)
    {
        var ValidChars = "0123456789.";
        var IsNumber=true;
        var Char;

 
        for (i = 0; i < sText.length && IsNumber == true; i++) 
        { 
            Char = sText.charAt(i); 
            if (ValidChars.indexOf(Char) == -1) 
            {
                IsNumber = false;
            }
        }
        return IsNumber;

    }
    
    function clearValue(no){
        document.getElementById('Quantity' + no).value = '0';
        total();
    }
    
    function refreshData(){
        document.ITEM_FORM.action = "<%=context%>/EquipMaintenanceTypeServlet?op=ListMainType";
        document.ITEM_FORM.submit();	
        }
        
        function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        } 
</SCRIPT>
<LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">

<script src='ChangeLang.js' type='text/javascript'></script>
<BODY>

<DIV align="left" STYLE="color:blue;">
<input type="button" value="<%=lang%>"
       onclick="reloadAE('<%=langCode%>')" class="button">
<table align="<%=align%>"  border="0" DIR="<%=dir%>" width="100%">
    
    <td STYLE="border:0px;">
        <div STYLE="width:75%;border:2px solid gray;background-color:#808000;color:white;" bgcolor="#F3F3F3" align="center">
            <div ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                <b>
                    <%=indicator%>
                </b>
                <img src="images/arrow_down.gif">
            </div>
            
            <div ALIGN="center" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;<%=style%>;border-top:2px solid gray;" ID="menu1">
                <table align="center" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                    <tr>
                        <td CLASS="cell" bgcolor="#F3F3F3"><IMG SRC="images/active.jpg"  ALT="Configured Schedule" ALIGN="<%=align%>"><FONT COLOR="red" dir="ltr"><%=configed%></font></td>
                        <td CLASS="cell" bgcolor="#F3F3F3"><IMG SRC="images/nonactive.jpg"  ALT="Un configure Schedule"><FONT COLOR="red" dir="ltr"> <%=unconfig%>   </font></td>
                    </tr>
                    
                </table>
            </div>
        </div>
    </td>
    </tr>
</table>


<fieldset class="set" align="<%=align%>">
<legend align="<%=align%>">
    
    <table dir="<%=dir%>" align="<%=align%>">
        <tr>
            
            <td class="td">
                <font color="blue" size="6">    <%=listMainType%>
                </font>
                
            </td>
        </tr>
    </table>
</legend >


<left>
<FORM NAME="ITEM_FORM" METHOD="POST">
    <center> 
    
    <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="<%=dir%>">
        
        
        <TR >
            
            <TD class='td'>
                <LABEL FOR="empNO">
                    <p><b><%=eq_Name%></b>&nbsp;
                </LABEL>
            </TD>
            <%
            ArrayList arrayList = new ArrayList();
            maintainableMgr.cashData();
            arrayList = maintainableMgr.getCategoryAsBusObjects();
            %>
            
            <td class='td'>
                <%
                if(request.getParameter("categoryId") != null){
                WebBusinessObject wbo = maintainableMgr.getOnSingleKey(request.getParameter("categoryId"));
                %>
                <SELECT name="categoryId" onchange="refreshData();">
                    <sw:WBOOptionList wboList='<%=arrayList%>' displayAttribute = "unitName" valueAttribute="id" scrollTo="<%=wbo.getAttribute("unitName").toString()%>"/>
                    
                </SELECT>
                <%
                } else {
                %>
                <SELECT name="categoryId" onchange="refreshData();">
                    <sw:WBOOptionList wboList='<%=arrayList%>' displayAttribute = "unitName" valueAttribute="id"/>
                </SELECT>
                <%
                }
                %>
                
            </TD>
            
        </TR>
        
    </TABLE>
    
    <%
    if(request.getParameter("categoryId") != null){
                items = equipMaintenanceTypeMgr.getOnArbitraryKey(request.getParameter("categoryId"), "key1");
                
    } else if(arrayList != null){
                items = equipMaintenanceTypeMgr.getOnArbitraryKey(((WebBusinessObject) arrayList.get(0)).getAttribute("id").toString(), "key1");
                
    } else {
                items = null;
    }
            
            if(items != null){
    %>
    <BR>
    <p><b><%=listMainType%></b>
    <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" STYLE="border-right-WIDTH:1px;" dir="<%=dir%>">
        <TR>
            <TD CLASS="td" COLSPAN="1" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
                <B><%=QS%></B>
            </TD>
            <TD CLASS="td" COLSPAN="4" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:16">
                <B><%=BO%></B>
            </TD>
            <TD CLASS="td" COLSPAN="1" bgcolor="#CC9900" STYLE="text-align:center;color:white;font-size:16">
                <B><%=IG%> </b>
            </TD>
        </tr>
        
        <TR CLASS="head">
            <TD CLASS="firstname"  STYLE="border-top-WIDTH:0; font-size:12;color:white" bgcolor="#9B9B00">
                <%=Maintenance_Type%>
            </TD>
            
            <TD CLASS="firstname"  STYLE="border-top-WIDTH:0; font-size:12;color:white" bgcolor="#7EBB00">
                <%=view%>
            </TD>
            <TD CLASS="firstname"  STYLE="border-top-WIDTH:0; font-size:12;color:white" bgcolor="#7EBB00">
                <%=edit%>
            </TD>
            <TD CLASS="firstname"  STYLE="border-top-WIDTH:0; font-size:12;color:white" bgcolor="#7EBB00">
                <%=delete%>
            </TD>
            <TD CLASS="firstname"  STYLE="border-top-WIDTH:0; font-size:12;color:white" bgcolor="#7EBB00">
                <%=Add_Task%>
            </TD>
            <TD class='td' bgcolor="#FFBF00">
                &nbsp;
            </TD>
        </TR>
        <%
        for(int i = 0; i < items.size(); i++){
            WebBusinessObject wbo = (WebBusinessObject) items.elementAt(i);
        %>
        <TR>
            <TD  WIDTH="200" STYLE="<%=style%>;padding-left:20;"  nowrap  BGCOLOR="#DDDD00"  CLASS="cell">
                <%=wbo.getAttribute("typeName").toString()%>
            </TD>
            
            <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;" bgcolor="#D7FF82">
                <DIV ID="links">
                    <A HREF="<%=context%>/EquipMaintenanceTypeServlet?op=ViewMainType&typeId=<%=wbo.getAttribute("id")%>">
                        <%=view%>
                    </A>
                </DIV>
            </TD>
            
            <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;" bgcolor="#D7FF82">
                <DIV ID="links">
                    <A HREF="<%=context%>/EquipMaintenanceTypeServlet?op=GetUpdateMainType&typeId=<%=wbo.getAttribute("id")%>&categoryId=<%=wbo.getAttribute("equipCategoryId")%>">
                        <%=edit%>
                    </A>
                </DIV>
            </TD>
            <%
            if(equipMaintenanceTypeMgr.getActiveMainType(wbo.getAttribute("id").toString())) {
            %>
            
            <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;" bgcolor="#D7FF82">
                <DIV ID="links">
                    <FONT COLOR="red"><%=cannotDel%></FONT>
                    
                </DIV>
            </TD>
            <%
            } else {
            %> 
            <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;" bgcolor="#D7FF82">
                <DIV ID="links">
                    <A HREF="<%=context%>/EquipMaintenanceTypeServlet?op=DeleteMainType&typeId=<%=wbo.getAttribute("id")%>&MainType=<%=wbo.getAttribute("typeName")%>&categoryId=<%=wbo.getAttribute("equipCategoryId")%>">
                        <%=delete%>
                    </A>
                </DIV>
            </TD>
            <% } %>
            <TD nowrap CLASS="cell" STYLE="padding-left:10;<%=style%>;" bgcolor="#D7FF82">
                <DIV ID="links">
                    <A HREF="<%=context%>/ScheduleServlet?op=GetScheduleMainType&typeId=<%=wbo.getAttribute("id")%>&MainType=<%=wbo.getAttribute("typeName")%>&categoryId=<%=wbo.getAttribute("equipCategoryId")%>">
                        <%=addTask%>
                    </A>
                </DIV>
            </TD>
            <TD WIDTH="20px" nowrap CLASS="cell" bgcolor="#FFE391">
                <%
                if(equipMaintenanceTypeMgr.getActiveMainType(wbo.getAttribute("id").toString())) {
                %>
                <IMG SRC="images/active.jpg" ALT="Active Maintenance Type by Schedule" ALIGN="left"> 
                <%
                } else {
                %> 
                <IMG SRC="images/nonactive.jpg" ALT="Non Active Maintenance Type" ALIGN="left">
                <% 
                }
                %>
            </TD> 
        </TR>
        <%
        }
        %>
    </TABLE>
    <%
            } else {
    %>
    <BR><%=noFound%>
    <%
            }
    %>
</FORM>
</BODY>
</HTML>     
