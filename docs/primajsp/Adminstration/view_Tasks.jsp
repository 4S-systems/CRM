<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.contractor.db_access.*"%>  
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
TaskTypeMgr taskTypeMgr = TaskTypeMgr.getInstance();
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
TradeMgr tradeMgr = TradeMgr.getInstance();
EmployeeTitleMgr employeeTitleMgr = EmployeeTitleMgr.getInstance();
WebBusinessObject task = (WebBusinessObject) request.getAttribute("Vtask");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

WebBusinessObject wboTrade = new WebBusinessObject();
WebBusinessObject wboTaskType = new WebBusinessObject();
WebBusinessObject wboEmpTitle = new WebBusinessObject();
WebBusinessObject wboCategoryName = new WebBusinessObject();

wboTrade = tradeMgr.getOnSingleKey(task.getAttribute("trade").toString());
wboTaskType = taskTypeMgr.getOnSingleKey(task.getAttribute("taskType").toString());
wboEmpTitle = employeeTitleMgr.getOnSingleKey(task.getAttribute("empTitle").toString());
//wboCategoryName = maintainableMgr.getOnSingleKey(task.getAttribute("parentUnit").toString());

//ArrayList arrTrade = new ArrayList();
//arrTrade.add("&#1578;&#1588;&#1581;&#1610;&#1605;");
//arrTrade.add("&#1578;&#1586;&#1610;&#1610;&#1578;");

String sTrade = new String("");
//if(new Integer((String) task.getAttribute("trade")).intValue() - 1 < arrTrade.size()){
//    sTrade = (String) arrTrade.get(new Integer((String) task.getAttribute("trade")).intValue() - 1);
//}

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String saving_status;
String code, code_name;
String title_1,title_2;
String cancel_button_label;
String save_button_label,Jops,EstimatedHours,Houre,tradeName,taskType,Category;
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    code="Maintenance Item Code";
    code_name="Maintenance Item Name";
    title_1="View Maintenance Item";
    title_2="All information are needed";
    cancel_button_label="Back To List ";
    save_button_label="Save ";
    langCode="Ar";
    Jops="Reqiured Jop";
    EstimatedHours="Expected Duration";
    Houre="  Hour";
    tradeName="Trade Name";
    taskType="Type Of Task";
    Category="Category";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    code="&#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583; ";
    code_name="&#1608;&#1589;&#1601; &#1575;&#1604;&#1576;&#1606;&#1583; ";
    title_1=" &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label="&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
    langCode="En";
    Jops="&#1575;&#1604;&#1605;&#1607;&#1606;&#1607; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1607; ";
    EstimatedHours="&#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1587;&#1575;&#1593;&#1575;&#1578;";
    Houre="   &#1587;&#1575;&#1593;&#1607;";
    tradeName="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
    taskType="&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    Category=" &#1575;&#1604;&#1589;&#1606;&#1601;";
}
%>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - view Failure Code</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function cancelForm()
    {    
    document.PROJECT_VIEW_FORM.action = "TaskServlet?op=tasks";
    document.PROJECT_VIEW_FORM.submit();  
    }
    
    
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="PROJECT_VIEW_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                aaaaaaaaaaaaaaa
            </DIV> 
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6">    <%=title_1%>                
                                </font>
                                
                            </td>
                        </tr>
                    </table>
                </legend>
                <br>
                <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <!--TR>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="Category">
                                            <p><b><%=Category%><font color="#FF0000">*</font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                                        <input DISABLED style="width:230px" name="categoryName" value="<%//=wboCategoryName.getAttribute("unitName")%>" ID="categoryName" >
                                        
                                    </TD>
                                </TR-->
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=code%><font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" style="width:230px" name="title" ID="title"  value="<%=task.getAttribute("title")%>" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b> <%=code_name%><font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input DISABLED style="width:230px" name="description" value="<%=task.getAttribute("name")%>" ID="description" >
                            <!--
                            <input disabled type="TEXT" name="description" ID="description:" size="33" value="<%//=failure.getAttribute("description")%>" maxlength="255">
                    -->
                        </TD>
                    </TR>
                    
                     <!--TR>
                                <TD STYLE="<%=style%>" class='td'>
                                    <LABEL FOR="str_Function_Desc">
                                        <p><b> <%=Jops%><font color="#FF0000">*</font></b>&nbsp;
                                    </LABEL>
                                </TD>
                                
                       <TD  STYLE="<%=style%>" class='td'>
                        <input DISABLED style="width:230px" name="empTitle" value="<%//=wboEmpTitle.getAttribute("name")%>" ID="empTitle" >
                    </TD>
                       </TR-->
                            
                            <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="assign_to">
                                <p><b><%=tradeName%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD  STYLE="<%=style%>" class='td'>
                         <input DISABLED style="width:230px" name="tradeName" value="<%=wboTrade.getAttribute("tradeName")%>" ID="tradeName" >
                    </TD>
                        </TR>
                        
                        
                            
                            <!--TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="assign_to">
                                <p><b><%=taskType%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD  STYLE="<%=style%>" class='td'>
                         <input DISABLED style="width:230px" name="taskType" value="<%//=wboTaskType.getAttribute("name")%>" ID="taskType" >
                    </TD>
                        </TR-->
                    
                    
                    <!--TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b> <%=EstimatedHours%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>"  class='td'>
                            <input disabled type="TEXT" name="executionHrs" ID="executionHrs" size="4" value="<%//=task.getAttribute("executionHrs")%>" maxlength="255"><font color="red"><%=Houre%>
                        </TD>
                        
                    </TR-->
                </TABLE>
                <br>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
