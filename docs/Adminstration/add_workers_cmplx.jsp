<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.tracker.db_access.*,com.silkworm.common.bus_admin.*, java.util.*"%>
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
    </head>
    
    <%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    MaintainableMgr unitMgr  = MaintainableMgr.getInstance();
    TradeMgr tradeMgr=TradeMgr.getInstance();
    String context = metaMgr.getContext();
    String status = (String) request.getAttribute("Status");
    String message;
    String issueId = request.getParameter("issueId");
    IssueMgr issueMgr=IssueMgr.getInstance();
    WebBusinessObject issueWbo=issueMgr.getOnSingleKey(issueId);
    
    ArrayList arrTrade = new ArrayList();
    arrTrade.add("&#1578;&#1588;&#1581;&#1610;&#1605;");
    arrTrade.add("&#1578;&#1586;&#1610;&#1610;&#1578;");
    
    TaskExecutionMgr taskExecutionMgr = TaskExecutionMgr.getInstance();
    
    String sTrade = new String("");
    
    Vector complexIssues = (Vector) request.getAttribute("complexIssues");
    ArrayList arrWorkers = (ArrayList) request.getAttribute("arrWorkers");
    
    
    TaskMgr taskMgr = TaskMgr.getInstance();
    ArrayList hoursAL = new ArrayList();
    String hour = null;
    for(float i=0; i<10; i+=0.5){
        hour=new Float(i).toString();
        hoursAL.add(hour);
    }
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String attachedEq,head;
    String lang,langCode, sBackToList,save, sAddCode,sAddName,saving,index,sItemName,sEstimatedTime,sRequiredTask,sMessage,sMessage2,tit,add,sDelete,title,scr,search,hrCheck,hrCheckMaint;
    String sWorkerName, sActualHours, sInvalidHours,headOrNot;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        sBackToList = "Cancel";
        save = "    Save   ";
        index="Maintenance Type Index";
        sRequiredTask="Required Task";
        sMessage="Data Had Been Saved Successfully";
        sMessage2="Saving Failed ";
        tit="Maintenance Item ";
        add="Add";
        sDelete="delete";
        title="Add Workers";
        scr="images/arrow1.swf";
        sWorkerName = "Worker Name";
        sActualHours = "Actual Hours";
        sInvalidHours = "Invalid Hours";
        hrCheck="Do you want employee name from HR program?";
        hrCheckMaint="Do you want employee name from Maintenance program?";
        attachedEq="Attached Equipment";
        head="Main Equipment";
        headOrNot="Main / Attached Equipment";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:right";
        lang="   English    ";
        langCode="En";
        sAddCode="&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1585;&#1602;&#1605;";
        sAddName="&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;";
        sBackToList = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        save = "&#1587;&#1580;&#1604;";
        index="&#1603;&#1608;&#1583; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        sRequiredTask="&#1575;&#1604;&#1605;&#1607;&#1606;&#1607; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        sMessage="&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
        sMessage2="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        tit="&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        add="&#1571;&#1590;&#1601;";
        sDelete="&#1581;&#1584;&#1601;";
        title="&#1573;&#1590;&#1575;&#1601;&#1607; &#1593;&#1605;&#1575;&#1604;&#1577;";
        scr="images/arrow2.swf";
        search="&#1576;&#1581;&#1579; &#1584;&#1575;&#1578;&#1610;";
        sWorkerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1575;&#1605;&#1604;";
        sActualHours = "&#1575;&#1604;&#1587;&#1575;&#1593;&#1575;&#1578; &#1575;&#1604;&#1581;&#1602;&#1610;&#1602;&#1610;&#1577;";
        sInvalidHours = "&#1593;&#1583;&#1583; &#1575;&#1604;&#1587;&#1575;&#1593;&#1575;&#1578; &#1594;&#1610;&#1585; &#1589;&#1581;&#1610;&#1581;";
        hrCheck="&#1607;&#1604; &#1578;&#1585;&#1610;&#1583; &#1575;&#1604;&#1593;&#1575;&#1605;&#1604;&#1610;&#1606; &#1605;&#1606; &#1576;&#1585;&#1606;&#1575;&#1605;&#1580; &#1575;&#1604;&#1605;&#1608;&#1575;&#1585;&#1583; &#1575;&#1604;&#1576;&#1588;&#1585;&#1610;&#1577;";
        hrCheckMaint="&#1607;&#1604; &#1578;&#1585;&#1610;&#1583; &#1575;&#1604;&#1593;&#1575;&#1605;&#1604;&#1610;&#1606; &#1605;&#1606; &#1576;&#1585;&#1606;&#1575;&#1605;&#1580; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        head="&#1585;&#1571;&#1587;";
        attachedEq="&#1605;&#1604;&#1581;&#1602;";
        headOrNot="&#1575;&#1604;&#1585;&#1571;&#1587; / &#1575;&#1604;&#1605;&#1604;&#1581;&#1602;";
    }
    
    
    
    %>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        
    function submitForm(){
        if(validForm()){
            document.SCHDULE_FORM.action = "<%=context%>/CompexIssueServlet?op=SaveWorkers&issueId=<%=issueId%>";
//            document.SCHDULE_FORM.submit();
        } else {
            alert('Invalid Hours');
        }
    }
    
    function validForm(){
        var arrActualHours = document.getElementsByName('actualHours');
        for(var i = 0; i < arrActualHours.length; i++){
            if(arrActualHours[i].value == "" || !IsNumeric(arrActualHours[i].value)){
                arrActualHours[i].focus();
                return false;
            }
        }
        return true;
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
    
      function reloadAE(nextMode){
      
       var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
            if (window.XMLHttpRequest)
            { 
                req = new XMLHttpRequest(); 
            } 
               else if (window.ActiveXObject)
            { 
                req = new ActiveXObject("Microsoft.XMLHTTP"); 
            } 
            req.open("Post",url,true); 
            req.onreadystatechange =  callbackFillreload;
            req.send(null);
      
      }
      
              function cancelForm()
        {    
        document.SCHDULE_FORM.action = "<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>";
        document.SCHDULE_FORM.submit();  
        }
        
        function Delete() {
            var table = document.getElementById('listTable');
            var check=document.getElementsByName('check');
            for(var i=table.rows.length - 1;i>=1;i--){
                if(check[i - 1].checked==true){
                    table.deleteRow(i);
                }
            }
        }
        function changeHR() {
            
        document.SCHDULE_FORM.action = "<%=context%>/ScheduleServlet?op=readWorkerbyHR&issueId=<%=issueId%>";
        document.SCHDULE_FORM.submit();
                    
               
            
        }
        function changeMaintenance() {
            
        document.SCHDULE_FORM.action = "<%=context%>/ScheduleServlet?op=AddWorkersForm&issueId=<%=issueId%>";
        document.SCHDULE_FORM.submit();
                    
               
            
        }
        
        
    </SCRIPT>
    <script src='silkworm_validate.js' type='text/javascript'></script>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM NAME="SCHDULE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=sBackToList%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 
            
            <fieldset >
            <legend align="center">
                
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">  <%=title%>
                            </font>
                        </td>
                    </tr>
                    
                </table>
            </legend >
            
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
            <br><br><br>
            
            <TABLE ALIGN="<%=align%>" DIR="<%=dir%>"  border="0" WIDTH=80%  ID="listTable">
                
                <TR>
                    <TD CLASS="head" WIDTH="20%"> <b><%=index%></b></TD>
                    <TD CLASS="head" WIDTH="20%"><b><%=sRequiredTask%></b></TD>        
                    <TD CLASS="head" WIDTH="20%"><b><%=headOrNot%> </b></TD>
                    <TD CLASS="head" WIDTH="20%"><b><%=sWorkerName%> </b></TD>
                    <TD CLASS="head" WIDTH="10%"><b><%=sActualHours%> </b></TD>
                    <TD CLASS="head" WIDTH="10%"><input type="button" class="cell" value="<%=sDelete%> " onclick="JavaScript: Delete()"></TD>
                </TR>
                <%
                // EmpBasicMgr empBasicMgr = EmpBasicMgr.getInstance();
                EmployeeMgr empBasicMgr = EmployeeMgr.getInstance();
                for(int i =0; i < complexIssues.size(); i++){
                    
                    WebBusinessObject cmplxIssueWbo = (WebBusinessObject) complexIssues.get(i);
                    WebBusinessObject wboTrade = tradeMgr.getOnSingleKey((String) cmplxIssueWbo.getAttribute("tradeId"));
                %>
                <TR bgcolor="#ffffcf">
                    
                    <TD CLASS="td" STYLE="text-align:center;">
                        <%=cmplxIssueWbo.getAttribute("index").toString()%>        
                    </td>
                    
                    <TD CLASS="td" STYLE="text-align:center;">
                        <%=(String) wboTrade.getAttribute("tradeName")%>
                    </td>
                    
                    <TD CLASS="td" STYLE="text-align:center;">
                        <%if(cmplxIssueWbo.getAttribute("attachedOn").toString().equals("1")){
                        %>
                        <%=head%>
                        <%}else{%>
                        <%=attachedEq%>
                        <%}%>
                    </td>
                    
                    <input type="hidden" name="cIssueId" id="cIssueId" value="<%=cmplxIssueWbo.getAttribute("id").toString()%>">
                    
                    <TD CLASS="td" STYLE="text-align:center;">
                        <SELECT name="worker" STYLE="width:200px">
                            <sw:WBOOptionList wboList="<%=arrWorkers%>" displayAttribute="empName" valueAttribute="empId" />
                        </SELECT>
                    </TD>
                    <TD CLASS="td" STYLE="text-align:center;">
                        <select name="actualHours" id="actualHours">
                            <sw:OptionList optionList='<%=hoursAL%>' scrollTo = "" />
                        </select>
                        <!--input id="actualHours" name="actualHours" type="text" style="width:50px;" value="<%//=sPlannedHours%>"-->
                    </TD>
                    <TD CLASS="td" STYLE="text-align:center;">
                        <input type='checkbox' name='check' ID='check'>
                    </TD>
                </TR>
                <%
                }
                %>
            </TABLE>
        </FORM>
    </BODY>
</html>