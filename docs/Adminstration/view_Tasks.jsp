<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.util.*,com.maintenance.db_access.*,com.contractor.db_access.*"%>
<%@page pageEncoding="UTF-8" %>
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
TaskTypeMgr taskTypeMgr = TaskTypeMgr.getInstance();
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
TradeMgr tradeMgr = TradeMgr.getInstance();
EmployeeTitleMgr employeeTitleMgr = EmployeeTitleMgr.getInstance();
WebBusinessObject task = (WebBusinessObject) request.getAttribute("Vtask");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

String taskId = (String)task.getAttribute("id");
String flag = (String)request.getAttribute("flag");

WebBusinessObject wboTrade = new WebBusinessObject();

WebBusinessObject wboTaskType = new WebBusinessObject();
WebBusinessObject wboEmpTitle = new WebBusinessObject();
WebBusinessObject wboCategoryName = new WebBusinessObject();
DateAndTimeControl dateAndTime = new DateAndTimeControl();

wboTrade = tradeMgr.getOnSingleKey(task.getAttribute("trade").toString());
wboTaskType = taskTypeMgr.getOnSingleKey(task.getAttribute("taskType").toString());
wboEmpTitle = employeeTitleMgr.getOnSingleKey(task.getAttribute("empTitle").toString());
wboCategoryName = maintainableMgr.getOnSingleKey(task.getAttribute("parentUnit").toString());

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
String save_button_label,Jops,EstimatedHours,Houre,tradeName,taskType,tCost,totalCost,Category,eng_Desc;
String sMinute,sHour,sDay,Approval_button,totalPartsCost,allCost,notAvailableStr;

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
    Houre="  Minutes ";
    tradeName="Trade Name";
    taskType="Type Of Task";
    Category="Category";
    eng_Desc="English Description";
    sMinute = "Minute";
    sHour = "Hour";
    sDay = "Day";
    tCost = "Cost of Task for Hour";
    totalCost = "Total Cost";
    Approval_button="Item Approval";
    totalPartsCost="Total Parts Cost";
    allCost="Total Cost";
    notAvailableStr = "Not Available";
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
    EstimatedHours="&#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1605;&#1583;&#1607;";
    Houre="   &#1583;&#1602;&#1600;&#1600;&#1600;&#1610;&#1600;&#1600;&#1600;&#1602;&#1600;&#1600;&#1600;&#1600;&#1607;";
    tradeName="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
    taskType="&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    Category=" &#1575;&#1604;&#1589;&#1606;&#1601;";
    eng_Desc="&#1575;&#1604;&#1608;&#1589;&#1601; &#1576;&#1575;&#1604;&#1575;&#1606;&#1580;&#1604;&#1610;&#1586;&#1609;";
    sMinute = "&#1583;&#1602;&#1610;&#1602;&#1577;";
    sHour = "&#1587;&#1575;&#1593;&#1577;";
    sDay = "&#1610;&#1608;&#1605;";
    tCost = "&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1576;&#1606;&#1583; &#1604;&#1604;&#1600;&#1587;&#1575;&#1593;&#1577;";
    totalCost = "\u062A\u0643\u0644\u0641\u0629 \u0627\u0644\u0639\u0645\u0627\u0644\u0647";
    Approval_button="&#1605;&#1591;&#1575;&#1576;&#1602;&#1577; &#1575;&#1604;&#1576;&#1606;&#1583;";
    totalPartsCost="\u0627\u062C\u0645\u0627\u0644\u064A \u0627\u0644\u062A\u0643\u0644\u0641\u0647 \u0644\u0642\u0637\u0639 \u0627\u0644\u063A\u064A\u0627\u0631";
    allCost="\u0627\u0644\u062A\u0643\u0644\u0641\u0647 \u0627\u0644\u0643\u0644\u064A\u0647";
    notAvailableStr = "غير متاح";
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
     function ApprovalForm()
    {    
    document.PROJECT_VIEW_FORM.action ="<%=context%>/GenericApprovalStatusServlet?op=ItemAppovalForm&taskId="+<%=taskId%>;
    document.PROJECT_VIEW_FORM.submit();  
    }
    
    
    
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>
<BODY>

<FORM NAME="PROJECT_VIEW_FORM" METHOD="POST">

<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
    
    <button  onclick="JavaScript: ApprovalForm();" class="button"><%=Approval_button%>
    
        </button>
</DIV> 
<fieldset class="set" align="center">
<legend align="center">
    <table dir="<%=dir%>" align="center">
        <tr>
            
            <td class="td">
                <font color="blue" size="6">    <%=title_1%>                
                </font>
                <%if(flag == "true"){%>
        <IMG SRC="images/yes.jpg">     
        <%}%>
            </td>
        </tr>
    </table>
</legend>
<br>
<TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="Category">
                <p><b><%=Category%><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" class='td'  WIDTH="33">
            <input readonly style="width:230px" name="categoryName" value="<%=wboCategoryName.getAttribute("unitName")%>" ID="categoryName" >
            
        </TD>
    </TR>
    
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_Function_Name">
                <p><b><%=code%><font color="#FF0000"></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" class='td'>
            <input readonly type="TEXT" style="width:230px" name="title" ID="title"  value="<%=task.getAttribute("title")%>" maxlength="255">
        </TD>
    </TR>
    
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_Function_Desc">
                <p><b> <%=code_name%><font color="#FF0000"></font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" class='td'>
            <input readonly style="width:230px" name="description" value="<%=task.getAttribute("name")%>" ID="description" >
            <!--
            <input readonly type="TEXT" name="description" ID="description:" size="33" value="<%//=failure.getAttribute("description")%>" maxlength="255">
                    -->
        </TD>
    </TR>
    
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_Function_Desc">
                <p><b> <%=Jops%><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>
        
        <TD  STYLE="<%=style%>" class='td'>
            <input readonly style="width:230px" name="empTitle" value="<%=(wboEmpTitle == null) ? notAvailableStr : wboEmpTitle.getAttribute("name")%>" ID="empTitle" >
        </TD>
    </TR>
    
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="assign_to">
                <p><b><%=tradeName%><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>
        <TD  STYLE="<%=style%>" class='td'>
            <input readonly style="width:230px" name="tradeName" value="<%=wboTrade.getAttribute("tradeName")%>" ID="tradeName" >
        </TD>
    </TR>

    
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="assign_to">
                <p><b><%=taskType%><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>
        <TD  STYLE="<%=style%>" class='td'>
            <input readonly style="width:230px" name="taskType" value="<%=wboTaskType.getAttribute("name")%>" ID="taskType" >
        </TD>
    </TR>
    
    
   
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_Function_Desc">
                <p><b> <%=tCost%><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>"  class='td'>
            <%
            if(task.getAttribute("costHour")!=null){%>
            <input type="text" name="costHour" id="costHour" readonly size="33" value="<%=(String)task.getAttribute("costHour")%>" maxlength="255">
            <%}else{%>
            <input type="text" name="costHour" id="costHour" readonly size="33" value="No Description" maxlength="255">
            <%}%>

        </TD>

    </TR>

    <TR>
     
        
          <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_Function_Desc">
                <p><b> <%=EstimatedHours%><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>
        <td>
            <table DIR="<%=dir%>">
                            <tr>
                                <td style="border-right-width:1px;border-left-width:1px"><font color="red"><b><%=sMinute%></b></font></td>
                                <td ><font color="red"><b><%=sHour%></b></font></td>
                                <td style="border-right-width:1px;border-left-width:1px"><font color="red"><b><%=sDay%></b></font></td>
                            </tr>
                            <%
                                    
                                int day =0;
                                int minute=0;
                                int hour =0;
                                String exeHours = task.getAttribute("executionHrs").toString();
                                double doubl = Double.parseDouble(exeHours);
                                int exehour = (int) doubl;
                                day = (exehour/ 60)/24;
                                hour =( exehour - day*24*60)/60;
                                minute = exehour - day*24*60 - hour*60;
                            %>
                            <tr>
                                <td style="border-right-width:1px;border-left-width:1px">
                                    <% if (minute> 0) {%>
                                      <input readonly style="width:40px" name="minute" value="<%=minute%>" ID="minute" >
                                      
                                    <% } else {%>
                                    <input readonly style="width:40px" name="minute" value="<%=""%>" ID="minute" >
                                    <% }%>
                                </td>
                                <td >
                                    <% if ( hour> 0) {%>
                                    <input readonly style="width:40px" name="hour" value="<%=hour%>" ID="hour" >
                                    <% } else {%>
                                    <input readonly style="width:40px" name="hour" value="<%=""%>" ID="hour" >
                                    <% }%>
                                </td>
                                <td  style="border-right-width:1px;border-left-width:1px">
                                    <% if (day > 0) {%>
                                   <input readonly style="width:40px" name="day" value="<%=day%>" ID="day" >
                                    <% } else {%>
                                    <input readonly style="width:40px" name="day" value="<%=""%>" ID="day" >
                                    <% }%>
                                </td>
                            </tr>
                          
                        </table>
        </td>
        
        
    </TR>
    
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_Function_Desc">
                <p><b> <%=totalCost%></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>"  class='td' >
            <%
                float totCost = 0.0f;
                String costhour = task.getAttribute("costHour").toString();
                String executionHrs = (String) task.getAttribute("executionHrs");
                if(costhour != null){
                    double doub = Double.parseDouble(executionHrs);
                    int execMinutes = (int)doub;
                    float costHour = Float.parseFloat(costhour);
                    float execHours = ((float)execMinutes) / 60;
                    totCost = execHours * costHour;
                }
            %>
            <input type="text" name="totCost" id="totCost" readonly size="10" value="<%=totCost%>" maxlength="255" STYLE="background-color: yellow;">

        </TD>

    </TR>

    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_Function_Desc">
                <p><b> <%=totalPartsCost%></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>"  class='td'>
            <input type="text" name="totalPartsCost" id="totalPartsCost" readonly size="10" value="<%=(task.getAttribute("totalPartsCost") != null) ? (String) task.getAttribute("totalPartsCost") : "0.0" %>" maxlength="255" STYLE="background-color: yellow;">
        </TD>
    </TR>
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_Function_Desc">
                <p><b> <%=allCost%></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>"  class='td'>
             <%
                float tcost = 0.0f;
                float allTotCost=0.0f;
                String costhr = task.getAttribute("costHour").toString();
                String execHrs = (String) task.getAttribute("executionHrs");
                String totPartsCost=(String)task.getAttribute("totalPartsCost");
                float totParts = 0.0f;
                
                if(totPartsCost != null) {
                    totParts= Float.parseFloat(totPartsCost);
                            
                }
                
                if(costhr != null){
                    double doub = Double.parseDouble(execHrs);
                    int execMinutes = (int)doub;
                    float costHour = Float.parseFloat(costhr);
                    float execHours = ((float)execMinutes) / 60;
                    tcost = execHours * costHour;
                    allTotCost=tcost+totParts;
                }
            %>
            <input type="text"  name="totalPartsCost" id="totalPartsCost" readonly size="10" value="<%=allTotCost%>" maxlength="255" STYLE="background-color: gray; font-size: 14px; ">
        </TD>
    </TR>
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_Function_Desc">
                <p><b> <%=eng_Desc%><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>"  class='td'>
            <%
            if(task.getAttribute("engDesc")!=null){%>
            <input type="text" name="engDesc" id="engDesc" readonly size="33" value="<%=(String)task.getAttribute("engDesc")%>" maxlength="255">
            <%}else{%>
            <input type="text" name="engDesc" id="engDesc" readonly size="33" value="No Description" maxlength="255">
            <%}%>
            
        </TD>
        
    </TR>
    
     
</TABLE>
<br>
</FIELDSET>
</FORM>
</BODY>
</HTML>     
