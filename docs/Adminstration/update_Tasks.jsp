<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.util.*,com.maintenance.db_access.*,com.tracker.db_access.*,com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>


<%

String status = (String) request.getAttribute("Status");
MetaDataMgr metaMgr = MetaDataMgr.getInstance();

TaskTypeMgr taskTypeMgr = TaskTypeMgr.getInstance();
TradeMgr tradeMgr = TradeMgr.getInstance();
EmployeeTitleMgr employeeTitleMgr = EmployeeTitleMgr.getInstance();
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
DateAndTimeControl dateAndTime = new DateAndTimeControl();
//ArrayList EmpTitleList = employeeTitleMgr.getCashedTableAsBusObjects();
// ArrayList tradeList = tradeMgr.getCashedTableAsBusObjects();
//ArrayList tasktypeList = taskTypeMgr.getCashedTableAsBusObjects();

String context = metaMgr.getContext();

ArrayList JobZiseList = new ArrayList();
String taskId = (String) request.getAttribute("taskId");

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
WebBusinessObject task = (WebBusinessObject) request.getAttribute("Utask");

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;

//ArrayList arrTrade = new ArrayList();
// arrTrade.add("&#1578;&#1588;&#1581;&#1610;&#1605;");
//arrTrade.add("&#1578;&#1586;&#1610;&#1610;&#1578;");

String sTrade = (String) task.getAttribute("trade");
String message= null;
String saving_status,Dupname;
String code, code_name;
String title_1,title_2;
String cancel_button_label;
String save_button_label,sstat,tCost,fstat,Jops,EstimatedHours,Houre,tradeName,taskType,Category,eng_Desc;
String sMinute,sHour,sDay;
if(stat.equals("En")){
    
    saving_status="Saving status";
    sstat="Saving successfully";
    
    fstat="saving failed";
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    code="Maintenance Item Code";
    code_name="Maintenance Item Name";
    title_1="Update Maintenance Item";
    Jops="Reqiured Jop";
    EstimatedHours="Expected Duration";
    Houre="  Minutes";
    title_2="All information are needed";
    cancel_button_label="Cancel ";
    save_button_label="Save ";
    langCode="Ar";
    Dupname = "Name is Duplicated Chane it";
    tradeName="Trade Name";
    taskType="Type Of Task";
    Category="Category";
    eng_Desc="English Description";
    sMinute = "Minute";
    sHour = "Hour";
    sDay = "Day";
    tCost = "Cost of Task for ( <font color=\"red\">Hour</font> )";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    
    lang="English";
    fstat="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    sstat= "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581; ";
    code="&#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583; ";
    code_name="&#1608;&#1589;&#1601; &#1575;&#1604;&#1576;&#1606;&#1583; ";
    title_1="&#1578;&#1581;&#1583;&#1610;&#1579; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577;";
    Jops="&#1575;&#1604;&#1605;&#1607;&#1606;&#1607; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1607; ";
    EstimatedHours="&#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1605;&#1583;&#1607;";
    Houre="   &#1583;&#1602;&#1600;&#1600;&#1600;&#1610;&#1600;&#1600;&#1600;&#1602;&#1600;&#1600;&#1600;&#1600;&#1607;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
    save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
    langCode="En";
    Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
    tradeName="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
    taskType="&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    Category=" &#1575;&#1604;&#1589;&#1606;&#1601;";
    eng_Desc="&#1575;&#1604;&#1608;&#1589;&#1601; &#1576;&#1575;&#1604;&#1575;&#1606;&#1580;&#1604;&#1610;&#1586;&#1609;";
    sMinute = "&#1583;&#1602;&#1610;&#1602;&#1577;";
    sHour = "&#1587;&#1575;&#1593;&#1577;";
    sDay = "&#1610;&#1608;&#1605;";
    tCost = "&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1576;&#1606;&#1583; &#1604;&#1604;&#1600;&#1600; ( <font color=\"red\">&#1587;&#1575;&#1593;&#1577;</font> )";
}
String doubleName = (String) request.getAttribute("name");
ArrayList hoursJob = new ArrayList();
String hour = null;
for(float i=0; i<60.5; i+=0.5){
    hour=new Float(i).toString();
    hoursJob.add(hour);
}
%>

<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>DebugTracker-update Failure Code</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

    var empty="";
    
        function submitForm()
        { 
            if (!validateData("req", this.ITEM_FORM.title, "Please, enter Code.") || !validateData("minlength=3", this.ITEM_FORM.title, "Please, enter a valid Code.")){
                this.ITEM_FORM.title.focus();
            } else if (!validateData("req", this.ITEM_FORM.name, "Please, enter Code Name.") || !validateData("minlength=3", this.ITEM_FORM.name, "Please, enter a valid Code Name.")){
                this.ITEM_FORM.name.focus();
            }else if(!checkDateTime()){
                    alert("Put time to maintenance item");
                    this.ITEM_FORM.minute.focus();
            } else if(!validateData("gt=0", this.ITEM_FORM.costHour, "Cost of Task for Hour must be > 0")) {
                this.ITEM_FORM.costHour.focus();
            }else {
                    document.ITEM_FORM.action = "<%=context%>/TaskServlet?op=update&taskId=<%=taskId%>";
                    document.ITEM_FORM.submit();  
            }
        }
        
       function checkEmail(email) {
        if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){
            return (true)
        }
            return (false)
    }
       
        function IsNumeric()
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
     function cancelForm()
        {    
        document.ITEM_FORM.action = "<%=context%>//TaskServlet?op=tasks";
        document.ITEM_FORM.submit();  
        }
        
        function checkTime()
        {
          checkMinsLabel = document.getElementById("executionHrs").value;
          if(parseInt(checkMinsLabel) <= 0 || checkMinsLabel.indexOf("-")>=0)
          {
          alert("Time must be positive and more than zero");
          document.getElementById("executionHrs").value='';
          }
        }

        function IsNumeric(id)
    {
        var ValidChars = "0123456789";
        var IsNumber=true;
        var Char;
        var valMinute;
        var valHour;
        sText=document.getElementById(id).value;

        for (i = 0; i < sText.length && IsNumber == true; i++)
        {
            Char = sText.charAt(i);

            if (ValidChars.indexOf(Char) == -1)
            {
                IsNumber = false;
                alert("Time must be positive integer and more than zero");
                document.getElementById(id).value='';
                document.getElementById(id).focus();
            }
        }

        valMinute=document.getElementById('minute').value;
        if(parseInt(valMinute) > 59)
            {
                IsNumber = false;
                alert("Minutes should be not more than 59");
                document.getElementById('minute').value='';
                document.getElementById('minute').focus();
            }
        valHour=document.getElementById('hour').value;
        if(parseInt(valHour) > 23)
            {
                IsNumber = false;
                alert("Hours should be not more than 23");
                document.getElementById('hour').value='';
                document.getElementById('hour').focus();
            }
        return IsNumber;

    }


   function checkDateTime()
    {
        var count=0;

        if (document.getElementById('minute').value != null && document.getElementById('minute').value != '' && document.getElementById('minute').value !='00' && document.getElementById('minute').value !='0')
            {
            count = count+1;
        }else if(document.getElementById('hour').value != null && document.getElementById('hour').value != '' && document.getElementById('hour').value !='00' && document.getElementById('hour').value !='0')
            {
            count = count+1;
        }else if(document.getElementById('day').value != null && document.getElementById('day').value != '' && document.getElementById('day').value !='00' && document.getElementById('day').value !='0')
        {
            count = count+1;
        }
        if(count>0){
            return true;
        }else{
            return false;
        }
    }
    
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>
<BODY>
<FORM NAME="ITEM_FORM" METHOD="POST">

<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
    <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
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
<%
if(null!=doubleName) {

%>

<table dir="<%=dir%>" align="<%=align%>">
    <tr>
        <td class="td">
            <font size=4 > <%=Dupname%> </font> 
        </td>
        
</tr> </table>
<%

}

%>   
<%
if(null!=status) {
    if(status.equalsIgnoreCase("ok")){
        message  = sstat;
    } else {
        message = fstat;
    }
%>
<table align="<%=align%>" dir=<%=dir%>>
    <tr>
        <td class="td">
            <font color="red" size=4 ><%=message%> </font> 
        </td>
        
</tr> </table>
<%

}

%>
<table align="<%=align%>" dir=<%=dir%>>
    <tr>
        <td class="td">
            <font color="red" size=4 ><%=title_2%></font> 
        </td>
        
</tr> </table>
<br><br>
<TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
    
    <input type="hidden" name="taskId" value="<%=task.getAttribute("id").toString()%>">
    
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="Category">
                <p><b><%=Category%><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>
        <TD  STYLE="<%=style%>" class='td'>
            <%
            ArrayList parentUnitList = new ArrayList();
            maintainableMgr.cashData();
            parentUnitList = maintainableMgr.getCategoryAsBusObjects();
            %>
            
            <%
            //if(request.getParameter("crewID") != null){
            WebBusinessObject wboCategoryName = maintainableMgr.getOnSingleKey(task.getAttribute("parentUnit").toString());
            String unitName = wboCategoryName.getAttribute("unitName").toString();
            %>
            <SELECT name="categoryName" id="categoryName" STYLE="width:230px">
                <sw:WBOOptionList wboList='<%=parentUnitList%>' displayAttribute = "unitName" valueAttribute="id" scrollTo="<%=unitName%>"/>
                
            </SELECT>
        </TD>
    </TR>
    
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_Function_Name">
                <p><b><%=code%><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>"class='td'>
            <input type="TEXT" style="width:230px" name="title" ID="title" size="33" value="<%=task.getAttribute("title")%>" maxlength="255">
        </TD>
    </TR>
    
    
    
    
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_Function_Desc">
                <p><b> <%=code_name%><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>"  class='td'>
            <input style="width:230px" name="name" ID="name" value="<%=task.getAttribute("name")%>" cols="25">
            <!--
            <input type="TEXT" name="description" ID="description" size="33" value="<%//=failure.getAttribute("description")%>" maxlength="255">
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
            <%
            ArrayList EmpTitleList = new ArrayList();
            employeeTitleMgr.cashData();
            EmpTitleList = employeeTitleMgr.getCashedTableAsBusObjects();
            %>
            
            <%
            //if(request.getParameter("crewID") != null){
            WebBusinessObject wboEmpTitle = employeeTitleMgr.getOnSingleKey(task.getAttribute("empTitle").toString());
            String  empTitleName = wboEmpTitle.getAttribute("name").toString();
            %>
            <SELECT name="empTitle" id="empTitle" STYLE="width:230px">
                <sw:WBOOptionList wboList='<%=EmpTitleList%>' displayAttribute = "name" valueAttribute="id" scrollTo="<%=empTitleName%>"/>
                
            </SELECT>
        </TD>
    </TR>
    
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="assign_to">
                <p><b><%=tradeName%><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>
        <TD  STYLE="<%=style%>" class='td'>
            <%
            ArrayList tradeList = new ArrayList();
            tradeMgr.cashData();
            tradeList = tradeMgr.getCashedTableAsBusObjects();
            %>
            
            <%
            //if(request.getParameter("crewID") != null){
            WebBusinessObject wboTrade = tradeMgr.getOnSingleKey(task.getAttribute("trade").toString());
            String  tradeOfTaskName = wboTrade.getAttribute("tradeName").toString();
            %>
            <SELECT name="tradeName" id="tradeName" STYLE="width:230px">
                <sw:WBOOptionList wboList='<%=tradeList%>' displayAttribute = "tradeName" valueAttribute="tradeId" scrollTo="<%=tradeOfTaskName%>"/>
                
            </SELECT>
        </TD>
    </TR>
    
    </TR>
    
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="assign_to">
                <p><b><%=taskType%><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>
        <TD  STYLE="<%=style%>" class='td'>
            <%
            ArrayList tasktypeList = new ArrayList();
            taskTypeMgr.cashData();
            tasktypeList = taskTypeMgr.getCashedTableAsBusObjects();
            %>
            
            <%
            //if(request.getParameter("crewID") != null){
            WebBusinessObject wboTasktype = taskTypeMgr.getOnSingleKey(task.getAttribute("taskType").toString());
            String   taskName = wboTasktype.getAttribute("name").toString();
            %>
            <SELECT name="taskType" id="taskType" STYLE="width:230px">
                <sw:WBOOptionList wboList='<%=tasktypeList%>' displayAttribute = "name" valueAttribute="id" scrollTo="<%=taskName%>"/>
                
            </SELECT>
        </TD>
    </TR>
    
    <TR>
        <TD STYLE="<%=style%>" class='td'>
            <LABEL FOR="str_Function_Desc">
                <p><b> <%=EstimatedHours%><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>"  class='td'>
            <table ALIGN="<%=align%>" DIR="<%=dir%>">
                            <tr>
                                <td style="border-right-width:1px;border-left-width:1px"><font color="red"><b><%=sMinute%></b></font></td>
                                <td ><font color="red"><b><%=sHour%></b></font></td>
                                <td style="border-right-width:1px;border-left-width:1px"><font color="red"><b><%=sDay%></b></font></td>
                            </tr>
                            <%
                                HashMap time = new HashMap();
                                String exeHours = task.getAttribute("executionHrs").toString();
                                Double execHr = 0.0;
                                int execIntHr = 0;
                                execHr = new Double(exeHours).doubleValue();
                                if(execHr<1){
                                    execHr =1.0;
                                    }
                                execIntHr = execHr.intValue();
                                time = dateAndTime.getDetailsDaysHourMinute(execIntHr);

                                String minute = (String) time.get("minute");
                                if(minute == null) minute = "";
                                %>
                            <tr>
                            <td width="5%" style="border-right-width:1px;border-left-width:1px">
                                <% if(new Integer(time.get("minute").toString()).intValue() > 0) { %>
                                <select style="width:40px;" name="minute" id="minute">
                                    <option value="00" <%if(minute.equals("00")) {%>selected<%}%> >00</option>
                                    <option value="15" <%if(minute.equals("15")) {%>selected<%}%> >15</option>
                                    <option value="30" <%if(minute.equals("30")) {%>selected<%}%> >30</option>
                                    <option value="45" <%if(minute.equals("45")) {%>selected<%}%> >45</option>
                                </select>
                                <% } else { %>
                                <select style="width:40px;" name="minute" id="minute">
                                    <option value="00" >00</option>
                                    <option value="15" >15</option>
                                    <option value="30" >30</option>
                                    <option value="45" >45</option>
                                </select>
                                <% } %>
                            </td>
                            <td width="5%">
                                <% if(new Integer(time.get("hours").toString()).intValue() > 0) { %>
                                <input style="width:20px;" type="text" name="hour" id="hour" maxlength="2" value="<%=time.get("hours").toString()%>" ONBLUR="IsNumeric(this.id);">
                                <% } else { %>
                                <input style="width:20px;" type="text" name="hour" id="hour" maxlength="2" ONBLUR="IsNumeric(this.id);">
                                <% } %>
                            </td>
                            <td width="5%" style="border-right-width:1px;border-left-width:1px">
                                <% if(new Integer(time.get("day").toString()).intValue() > 0) { %>
                                <input style="width:20px;" type="text" name="day" id="day" maxlength="2" value="<%=time.get("day").toString()%>" ONBLUR="IsNumeric(this.id);">
                                <% } else { %>
                                <input style="width:20px;" type="text" name="day" id="day" maxlength="2" ONBLUR="IsNumeric(this.id);">
                                <% } %>
                            </td>
                            </tr>

                        </table>
            
            
        </TD>
        
    </TR>

    <TR>

        <TD STYLE="<%=style%>" class="td">
            <LABEL FOR="str_Function_Desc">
                <p><b> <%=tCost%><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>
        <TD STYLE="<%=style%>" CLASS="td" >
            <%if(task.getAttribute("costHour")!=null){%>
                <input type="text" name="costHour" id="costHour" value="<%=(String)task.getAttribute("costHour")%>" maxlength="5" style="width:40px" ONBLUR="IsNumeric(this.id);">
            <%}else{%>
                <input type="text" name="costHour" id="costHour" maxlength="5" style="width:40px" ONBLUR="IsNumeric(this.id);">
            <%}%>
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
            <input type="text" name="engDesc" id="engDesc" size="33" value="<%=(String)task.getAttribute("engDesc")%>" maxlength="255">
            <%}else{%>
            <input type="text" name="engDesc" id="engDesc" size="33" value="No Description" maxlength="255">
            <%}%>
            
        </TD>
        
    </TR>
</TABLE>
<br>
</FIELDSET>
</FORM>
</BODY>
</HTML>     
