<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<html>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Create New Schedule</title>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link REL="stylesheet" TYPE="text/css" HREF="css/headers.css">
        <script src='js/silkworm_validate.js' type='text/javascript'></script>
        <script src='js/ChangeLang.js' type='text/javascript'></script>
        <style type="test/css" >
            .blueBorder blueHeaderTD{
                font-size:16px;
            }
        </style>
    </head>
    
    <%
    DateAndTimeControl dateAndTimeControl = new DateAndTimeControl();
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String status = (String) request.getAttribute("Status");
    String message;
    String issueId = request.getParameter("issueId");
    String filterName = request.getParameter("filterName");
    String filterValue = request.getParameter("filterValue");
    
    ArrayList arrTrade = new ArrayList();
    arrTrade.add("&#1578;&#1588;&#1581;&#1610;&#1605;");
    arrTrade.add("&#1578;&#1586;&#1610;&#1610;&#1578;");
    
    TaskExecutionMgr taskExecutionMgr = TaskExecutionMgr.getInstance();
    
    String sTrade = new String("");
    
    Vector vecIssueTasks = (Vector) request.getAttribute("vecIssueTasks");
    TaskMgr taskMgr = TaskMgr.getInstance();
    ArrayList<WebBusinessObject> arrWorkers = (ArrayList<WebBusinessObject>) request.getAttribute("arrWorkers");
    
    ArrayList hoursAL = new ArrayList();
    String hour = null;
    for(float i=0; i<10; i+=0.5){
        hour=new Float(i).toString();
        hoursAL.add(hour);
    }
    
    hoursAL.remove(0);
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode, sBackToList,save,sItemCode,sItemName,sEstimatedTime,sRequiredTask,sMessage,sMessage2,sDelete,title;
    String sWorkerName, sActualHours,addLabour,smunits,shour,totalCost,cost;
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        sBackToList = "Cancel";
        save = "    Save   ";
        sItemCode="Maintenance Item Code";
        sItemName="Maintenance Item  Name";
        sEstimatedTime="Estimated Time";
        sRequiredTask="Required Task";
        sMessage="Data Had Been Saved Successfully";
        sMessage2="Saving Failed ";
        sDelete="delete";
        title="Add Workers";
        sWorkerName = "Worker Name";
        sActualHours = "Actual Time";
        addLabour="Add Another Labour";
        smunits = "Minutes";
        shour = "Hours";
        totalCost = "Total Cost";
        cost = "Cost";
    }else{
        align="center";
        dir="RTL";
        style="text-align:right";
        lang="   English    ";
        langCode="En";
        sBackToList = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        save = "&#1587;&#1580;&#1604;";
        sItemCode="&#1603;&#1608;&#1583; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        sItemName="&#1573;&#1587;&#1605; &#1575;&#1604;&#1576;&#1606;&#1583;";
        sEstimatedTime="&#1575;&#1604;&#1608;&#1602;&#1578; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
        sRequiredTask="&#1575;&#1604;&#1605;&#1607;&#1606;&#1607; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        sMessage="&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
        sMessage2="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        sDelete="&#1581;&#1584;&#1601;";
        title="&#1573;&#1590;&#1575;&#1601;&#1607; &#1593;&#1605;&#1575;&#1604;&#1577;";
        sWorkerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1575;&#1605;&#1604;";
        sActualHours = "&#1575;&#1604;&#1608;&#1602;&#1578; &#1575;&#1604;&#1601;&#1593;&#1604;&#1609;";
        addLabour="&#1575;&#1590;&#1575;&#1601;&#1607; &#1593;&#1575;&#1605;&#1604; &#1575;&#1582;&#1585;";
        smunits = "&#1583;&#1602;&#1575;&#1574;&#1602;";
        shour = "&#1587;&#1575;&#1593;&#1575;&#1578;";
        totalCost = "&#1575;&#1604;&#1600;&#1578;&#1600;&#1603;&#1600;&#1604;&#1600;&#1601;&#1600;&#1577; &#1575;&#1604;&#1600;&#1603;&#1600;&#1604;&#1600;&#1610;&#1600;&#1577;";
        cost = "&#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577;";
    }
    %>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    var count=<%=vecIssueTasks.size()%>;

    window.onload = function() {
        var length = document.getElementsByName('check').length;
        for(var i = 0; i < length; i++) {
            calculateCost(i);
        }
    }
        
    function submitForm() {
        if(validForm()) {
            document.SCHDULE_FORM.action = "<%=context%>/IssueServlet?op=SaveWorkers&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
            document.SCHDULE_FORM.submit();
        }
    }

    function validForm(){//actualMinutes actualHours
        var length = document.getElementsByName('check').length;
        var actualMinutes;
        var actualHours;
        for(var i = 0; i < length; i++){
            actualHours = document.getElementsByName('actualHours' + i);
            actualMinutes = document.getElementsByName('actualMinutes' + i);
            if(actualHours.length != undefined) {
                for(var j = 0; j < actualHours.length; j++) {
                    if((actualHours[j].value == "" && actualMinutes[j].value == "")) {
                        alert("Invalid Hours or Minutes");
                        actualHours[j].focus();
                        return false;
                    } else {
                        var hh = new Number(actualHours[j].value);
                        var mm = new Number(actualMinutes[j].value);

                        var total = hh + mm;
                        if(total == 0) {
                            alert("Must Enter Actual Time");
                            actualHours[j].focus();
                            return false;
                        }
                    }
                }
            }
        }
        return true;
    }
      
    function cancelForm() {
        document.SCHDULE_FORM.action = "<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.SCHDULE_FORM.submit();
    }
        
    function Delete() {
        var table = document.getElementById('listTable');
        var check=document.getElementsByName('check');
        for(var i = 0; i<check.length; i++){
            if(check[i].checked){
                table.deleteRow(i + 2);
                i--;
            }
        }

        calculateTotalCost();
     }
     
    function addNewLabor(){
        rows=document.getElementsByName("addLabour");
        for (i=0;i<rows.length;++ i) {
          if (rows[i].checked) {
                rows[i].checked=false;
                addNew(rows[i].value);
            }
          }
          reset();
    }
    
    function addNew(index){
            var x = document.getElementById('listTable').insertRow();
            count++;
            
            var C1 = x.insertCell(0);
            var C2 = x.insertCell(1);
            var C3 = x.insertCell(2);
            var C4 = x.insertCell(3);
            var C5 = x.insertCell(4);
            var C6 = x.insertCell(5);
            var C7 = x.insertCell(6);
            var C8 = x.insertCell(7);
            var C9 = x.insertCell(8);
            
            var className="blueBorder blueBodyTD";
            
            C1.borderWidth = "1px";
            C2.borderWidth = "1px";
            C3.borderWidth = "1px";
            C4.borderWidth = "1px";
            C5.borderWidth = "1px";
            C6.borderWidth = "1px";
            C7.borderWidth = "1px";
            C8.borderWidth = "1px";
            C9.borderWidth = "1px";
            
            C1.className=className;
            C2.className=className;
            C3.className=className;
            C4.className=className;
            C5.className=className;
            C6.className=className;
            C7.className=className;
            C8.className=className;
            C9.className=className;
            
            C1.innerHTML = document.getElementById('title'+index).innerHTML;
            C2.innerHTML = document.getElementById('name'+index).innerHTML;
            C3.innerHTML = document.getElementById('tradeName'+index).innerHTML;
            C4.innerHTML = document.getElementById('worker'+index).innerHTML;
            C5.innerHTML = document.getElementById('actualMi'+index).innerHTML;
            C6.innerHTML = document.getElementById('actualHr'+index).innerHTML;
            C7.innerHTML = document.getElementById('cost'+index).innerHTML;
            C8.innerHTML = document.getElementById('delCheck'+index).innerHTML;
            C9.innerHTML = document.getElementById('addCheck'+index).innerHTML;
            
            rows[i].checked=false;
            
            calculateTotalCost();
    }
    
    function reset(){
        rows=document.getElementsByName("addLabour");
        for (i=0;i<rows.length;++ i)
          {
            rows[i].checked=false;
          }
    }
     
    function changeHR() {
            
        document.SCHDULE_FORM.action = "<%=context%>/ScheduleServlet?op=readWorkerbyHR&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.SCHDULE_FORM.submit();
    }

    function changeMaintenance() {
        document.SCHDULE_FORM.action = "<%=context%>/ScheduleServlet?op=AddWorkersForm&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.SCHDULE_FORM.submit();
    }

    function checkDuplication()
    {
        var tasks=document.getElementsByName('tasks');
        var workers=document.getElementsByName('workers');alert(workers.length)
        var count = 0;
       
        var first;
        var second;
        
        for(i=0;i<tasks.length;i++) {
          first = document.getElementById('workers'+i).value+"-"+tasks[i].value;
                
            for(j=0;j<tasks.length;j++) {alert("i : " + i + "\nj : " + j)
                second = document.getElementById('workers'+j).value+"-"+tasks[j].value;
            alert("First : " + first + "\nSecond : " + second)
                if(first == second && i!=j) {
                    count++;
                    alert("Found 2 Employee added to same task");
                }
            }
        }
        if(count > 0) {
            return false;
        }
        return true;
    }

    function calculateCost(index) {
        var costs = document.getElementsByName('costEmp' + index);
        var employeeId = document.getElementsByName('workers' + index);
        var actualMinutes = document.getElementsByName('actualMinutes' + index);
        var actualHours = document.getElementsByName('actualHours' + index);
        
        var houreSalary;
        var intHourSalary;
        var intActualMinutes;
        var intActualHours;

        var totalTimeByMintues;
        var cost;
        var tempCost;

        if(employeeId != undefined) {
            for(var i = 0; i < employeeId.length; i++) {
                houreSalary = document.getElementById(employeeId[i].value).value;
                intHourSalary = new Number(houreSalary);
                intActualMinutes = new Number(actualMinutes[i].value);
                intActualHours = new Number(actualHours[i].value);

                totalTimeByMintues = (intActualHours * 60) + intActualMinutes;
                cost = (totalTimeByMintues /60) * intHourSalary;
                tempCost = 0.0;

                if(cost >= 0) {
                    tempCost = cost;
                }

                costs[i].value = roundNumber(tempCost, 2);
            }
        }

        calculateTotalCost();
    }

    function calculateTotalCost() {
        var costs = document.getElementsByName('costEmp');
        var totalCost = 0;
        var cost;
        for(var i = 0; i < costs.length; i++) {
            cost = new Number(costs[i].value);
            if(cost >= 0) {
                totalCost = totalCost + cost;
            }
        }
        document.getElementById('totalCost').value = roundNumber(totalCost, 2);
    }

    function subtractToTotalCost(amount) {
        if(amount >= 0) {
            var totalCost = new Number(document.getElementById('totalCost').value);
            totalCost = totalCost - amount;
            if(totalCost >= 0) {
                document.getElementById('totalCost').value = totalCost;
            } else {
                document.getElementById('totalCost').value = "0.00";
            }
        }
    }
</SCRIPT>
    <style type="text/css">
        .grayStyle {
            color: blue;
            font-size: 16px;
            font-weight: bold;
            background-color: #9b9b9b;
        }
    </style>
    
    <BODY>
        <FORM action=""  NAME="SCHDULE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=sBackToList%> <IMG alt="Cancel" HEIGHT="15" SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save%> <IMG alt="Save"  HEIGHT="15" SRC="images/save.gif"></button>
            </DIV>
            <br>
            <center>
                <fieldset align="center" class="set" style="border-color: #006699;width: 95%">
                    <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"><%=title%></FONT><BR></td>
                        </tr>
                    </table>
                <% 
                if(null!=status) {
                    if(status.equalsIgnoreCase("ok")){
                        message  = sMessage ;
                    } else {
                        message = sMessage2 ;
                    }
                %>
                <table ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="600" >
                    <TR BGCOLOR="FBE9FE">
                        <TD STYLE="text-align:center" colspan="5" class="td">
                            <B><FONT FACE="tahoma" color='blue'><%=message%></FONT></B>
                        </TD>
                    </TR>
                </table>
                <%
                }
                %>
                <br>
                <TABLE class="blueBorder" ALIGN="<%=align%>" DIR="<%=dir%>" cellpadding="0" cellspacing="0" WIDTH=98%  ID="listTable">
                    <TR>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="10%" rowspan="2" style="height: 10px;"> <b><%=sItemCode%></b></TD>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="20%" rowspan="2" style="height: 18px;"><b><%=sItemName%> </b></TD>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="15%" rowspan="2" style="height: 15px;"><b><%=sRequiredTask%> </b></TD>
                        <%--TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="15%" colspan="2" style="height: 15px;"><b><%=sEstimatedTime%> </b></TD--%>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="10%" rowspan="2" style="height: 17px;"><b><%=sWorkerName%> </b></TD>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="18%" colspan="2" style="height: 15px;"><b><%=sActualHours%> </b></TD>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="12%" rowspan="2" style="height: 15px;"><b><%=cost%> </b></TD>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="5%" rowspan="2" style="height: 15px;">
                            <input type="button" value="<%=sDelete%> " onclick="JavaScript: Delete()">
                        </TD>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="10%" rowspan="2" style="height: 15px;">
                            <input type="button" value="<%=addLabour%>" onclick="JavaScript: addNewLabor()">
                        </TD>  
                    </TR>
                    <TR>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="5%" style="height: 15px;">
                            <b><%=smunits%></b>
                        </TD>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="10%" style="height: 15px;">
                            <b><%=shour%></b>
                        </TD>
                    </TR>
                    <%
                    HashMap<String, String> actual, estmaited;
                    int actualMinutes, estemtMinutes;
                    String sActualMinuts, sActualHour;
                    EmployeeMgr empBasicMgr = EmployeeMgr.getInstance();
                    int count=0;
                    for(int i =0; i < vecIssueTasks.size(); i++){
                        WebBusinessObject wboIssueTask = (WebBusinessObject) vecIssueTasks.get(i);
                        WebBusinessObject wboTask = taskMgr.getOnSingleKey((String) wboIssueTask.getAttribute("codeTask"));
                        Vector vecTaskExecution = taskExecutionMgr.getOnArbitraryKey((String) wboIssueTask.getAttribute("taskID"), "key1");
                        String sPlannedHours = new String("");
                        String sWorker = new String("");

                        ///////////////////////////////////////////
                        estemtMinutes = 0; actualMinutes = 0;
                        sActualMinuts = "0"; sActualHour = "";;
                        if(wboTask.getAttribute("executionHrs") != null) {
                            try {
                                estemtMinutes = Integer.valueOf((String) wboTask.getAttribute("executionHrs")).intValue();
                                estmaited = dateAndTimeControl.getDetailsHourMinute(estemtMinutes);
                            } catch(NumberFormatException ex) { }
                        }
                        ///////////////////////////////////////////

                        if(vecTaskExecution.size() > 0) {
                            for (int y =0; y < vecTaskExecution.size(); y++) {
                            WebBusinessObject wboTemp = (WebBusinessObject) vecTaskExecution.get(y);
                            sPlannedHours = (String) wboTemp.getAttribute("actualHours");
                            sWorker = (String) empBasicMgr.getOnSingleKey((String) wboTemp.getAttribute("laborID")).getAttribute("empName");

                            ///////////////////////////////////////////
                            if(sPlannedHours != null) {
                                try {
                                    actualMinutes = Integer.valueOf(sPlannedHours).intValue();
                                    actual = dateAndTimeControl.getDetailsHourMinute(actualMinutes);
                                    sActualMinuts = actual.get("minute");
                                    sActualHour = actual.get("hours");
                                } catch(NumberFormatException ex) { }
                            }
                            ///////////////////////////////////////////
                    %>
                    <TR>
                        <%
                        TradeMgr tradeMgr = TradeMgr.getInstance();
                        %>

                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="title<%=i%>">
                            <input type="hidden" id="tasks" name="tasks" value="<%=wboTask.getAttribute("title")%>">
                            <%=(String)wboTask.getAttribute("title")%>
                        </TD>
                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="name<%=i%>">
                            <%=(String)wboTask.getAttribute("name")%>
                        </TD>
                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="tradeName<%=i%>">
                            <%
                            WebBusinessObject wboTrade = tradeMgr.getOnSingleKey((String) wboTask.getAttribute("trade"));
                            sTrade = (String) wboTrade.getAttribute("tradeName");
                            %>
                            <%=sTrade%>
                        </TD>
                        <%--TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="executionHr<%=i%>">
                            <%=sEstemtMinutes%>
                        </TD>
                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="executionMi<%=i%>">
                            <%=sEstemetHour%>
                        </TD--%>

                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="worker<%=i%>">
                            <input type="hidden" name="taskID" id="taskID<%=count%>" value="<%=wboIssueTask.getAttribute("taskID")%>">
                            <input type="hidden" name="plannedHours" value="<%=wboTask.getAttribute("executionHrs")%>">

                            <SELECT name="worker" STYLE="width:160px;font-weight: bold;font-size: 12px" ID="workers<%=i%>" onchange="JavaScript:calculateCost('<%=i%>');">
                                <sw:WBOOptionList wboList="<%=arrWorkers%>" displayAttribute="empName" valueAttribute="empId" scrollTo="<%=sWorker%>" />
                            </SELECT>
                        </TD>

                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="actualMi<%=i%>">
                            <select name="actualMinutes" id="actualMinutes<%=i%>" onchange="JavaScript:calculateCost('<%=i%>');">
                                <option value="0" <%if(sActualMinuts.equals("0")) { %>selected<% } %>>0</option>
                                <option value="15" <%if(sActualMinuts.equals("15")) { %>selected<% } %>>15</option>
                                <option value="30" <%if(sActualMinuts.equals("30")) { %>selected<% } %>>30</option>
                                <option value="45" <%if(sActualMinuts.equals("45")) { %>selected<% } %>>45</option>
                            </select>
                        </TD>
                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="actualHr<%=i%>">
                            <input type="text" name="actualHours" id="actualHours<%=i%>" size="6" value="<%=sActualHour%>" onblur="JavaScript:IsNumericInt(this.id);" onchange="JavaScript:calculateCost('<%=i%>');" />
                        </TD>

                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="cost<%=i%>">
                            <input type="text" name="costEmp" id="costEmp<%=i%>" size="6" value="" readonly style="width: 100%" />
                        </TD>

                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="delCheck<%=i%>">
                            <input type='checkbox' name='check' ID='check'>
                        </TD>
                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="addCheck<%=i%>">
                            <input type='checkbox' name='addLabour' ID='addLabour' value="<%=i%>">
                        </TD>
                    </TR>
                    <%count++;%>
                    <%} %>
                    <% }else {%>
                    <TR>
                        <%
                        TradeMgr tradeMgr = TradeMgr.getInstance();
                        %>

                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="title<%=i%>">
                            <input type="hidden" id="tasks" name="tasks" value="<%=wboTask.getAttribute("title")%>">
                            <%=(String)wboTask.getAttribute("title")%>
                        </TD>
                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="name<%=i%>">
                            <%=(String)wboTask.getAttribute("name")%>
                        </TD>
                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="tradeName<%=i%>">
                            <%
                                WebBusinessObject wboTrade = tradeMgr.getOnSingleKey((String) wboTask.getAttribute("trade"));
                                sTrade = (String) wboTrade.getAttribute("tradeName");
                            %>
                            <%=sTrade%>
                        </TD>
                        <%--TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="executionHr<%=i%>">
                            <%=sEstemtMinutes%>
                        </TD>
                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="executionMi<%=i%>">
                            <%=sEstemetHour%>
                        </TD--%>

                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="worker<%=i%>">
                            <input type="hidden" name="taskID" id="taskID<%=count%>" value="<%=wboIssueTask.getAttribute("taskID")%>">
                            <input type="hidden" name="plannedHours" value="<%=wboTask.getAttribute("executionHrs")%>">
                            <SELECT name="worker" STYLE="width:160px;font-weight: bold;font-size: 12px" ID="workers<%=i%>" onchange="JavaScript:calculateCost('<%=i%>');">
                                <sw:WBOOptionList wboList="<%=arrWorkers%>" displayAttribute="empName" valueAttribute="empId" scrollTo="<%=sWorker%>" />
                            </SELECT>
                        </TD>

                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="actualMi<%=i%>">
                            <select name="actualMinutes" id="actualMinutes<%=i%>" onchange="JavaScript:calculateCost('<%=i%>');">
                                <option value="0" <%if(sActualMinuts.equals("0")) { %>selected<% } %>>0</option>
                                <option value="15" <%if(sActualMinuts.equals("15")) { %>selected<% } %>>15</option>
                                <option value="30" <%if(sActualMinuts.equals("30")) { %>selected<% } %>>30</option>
                                <option value="45" <%if(sActualMinuts.equals("45")) { %>selected<% } %>>45</option>
                            </select>
                        </TD>
                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="actualHr<%=i%>">
                            <input type="text" name="actualHours" id="actualHours<%=i%>" size="6" value="<%=sActualHour%>" onblur="JavaScript:IsNumericInt(this.id);" onchange="JavaScript:calculateCost('<%=i%>');" />
                        </TD>

                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="cost<%=i%>">
                            <input type="text" name="costEmp" id="costEmp<%=i%>" size="6" value="" readonly style="width: 100%" />
                        </TD>

                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="delCheck<%=i%>">
                            <input type='checkbox' name='check' ID='check'>
                        </TD>
                        <TD CLASS="blueBorder blueBodyTD" STYLE="text-align:center;" ID="addCheck<%=i%>">
                            <input type='checkbox' name='addLabour' ID='addLabour' value="<%=i%>">
                        </TD>
                    </TR>
                    <%count++;%>
                    <% } %>
                    <%
                    }
                    %>
                </TABLE>
                <br>
                <TABLE class="blueBorder" ALIGN="<%=align%>" DIR="<%=dir%>" cellpadding="0" cellspacing="0" WIDTH=55%  ID="listTable">
                    <TR>
                        <TD CLASS="blueBorder blueHeaderTD" WIDTH="50%" style="height: 30px;font-size: 18px"> <b><%=totalCost%></b></TD>
                        <TD CLASS="blueBorder blueHeaderTD grayStyle" WIDTH="50%" style="height: 30px">
                            <input type="text" name="totalCost" id="totalCost" size="6" value="" readonly style="width: 60%;text-align: center;font-size: 14px;font-weight: bold" />
                        </TD>
                    </TR>
                </TABLE>
                <br>
                <!-- Hidden Input to hour salary employee -->
                <%
                WebBusinessObject wbo;
                for(int j = 0; j < arrWorkers.size(); j++) {
                    wbo = arrWorkers.get(j);
                %>
                    <input type="hidden" id="<%=wbo.getAttribute("empId")%>" value="<%=wbo.getAttribute("houreSalary")%>" />
                <% } %>
                </fieldset>
            </center>
        </FORM>
    </BODY>
</html>