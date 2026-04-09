<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*, com.tracker.db_access.*"%>
<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

//Define managers
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
LaborComplaintsMgr laborComplaintsMgr = LaborComplaintsMgr.getInstance();
IssueMgr issueMgr = IssueMgr.getInstance();
IssueTasksComplaintMgr issueTaskCompMgr = IssueTasksComplaintMgr.getInstance();

WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

String context = metaMgr.getContext();

//Get request data
String status = (String) request.getAttribute("Status");
String issueId = (String) request.getAttribute("issueId");
String filterName = request.getParameter("filterName");
String filterValue = request.getParameter("filterValue");
WebBusinessObject empWbo = (WebBusinessObject) request.getAttribute("currentEmpWbo");

//define variables
String message;

Vector compTaskVec = null;
Vector complaintsVec = new Vector();
complaintsVec = laborComplaintsMgr.getOnArbitraryKey(issueId, "key1");

WebBusinessObject issueWbo = issueMgr.getOnSingleKey(issueId);

String cMode = (String) request.getSession().getAttribute("currentMode");
String stat = cMode;
String align = null;
String dir = null;
String style = null;
String cellAlign = null;
String lang, langCode, BackToList, save, title, labor, addButton, delButton, no, complaint, relatedToTask, M, M2,
        JOData, JONo, forEqp;

if(stat.equals("En")){
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    cellAlign = "left";
    
    BackToList = "Back";
    save = "Save";
    title = "Add / Update Labor Complaints";
    labor="Labor Name";
    addButton = "Add New";
    delButton = "Delete";
    no = "#";
    complaint = "Complaint";
    relatedToTask = "Related to Task";
    M="Data Had Been Saved Successfully";
    M2="Saving Failed -- some complaints are related to tasks";
    JOData = "Job Order Data";
    JONo = "Job Order Number";
    forEqp = "Equipment Name";
}else{
    align="center";
    dir="RTL";
    style="text-align:right";
    lang="   English    ";
    langCode="En";
    cellAlign = "right";
    
    BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577;";
    save = " &#1575;&#1590;&#1575;&#1601;&#1577; ";
    title = "اضافة/تعديل الشكاوي";
    labor="&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1575;&#1605;&#1604;";
    addButton = "&#1575;&#1590;&#1575;&#1601;&#1577; &#1580;&#1583;&#1610;&#1583;";
    delButton = "&#1581;&#1584;&#1601;";
    no = "#";
    complaint = "الشكوي";
    relatedToTask = "&#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577;";
    M="&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
    M2="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; - &#1576;&#1593;&#1590; &#1575;&#1604;&#1588;&#1603;&#1575;&#1608;&#1609; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1576;&#1606;&#1608;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577;";
    JOData = "&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    JONo = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    forEqp = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
}
%>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function submitForm(){
        if(!checkComplaint()){
            return;
        } else {
            document.COMPLAINT_FORM.action = "<%=context%>/AssignedIssueServlet?op=addcomp&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
            document.COMPLAINT_FORM.submit();  
        }
        
    }
     
    function cancelForm(){    
        document.COMPLAINT_FORM.action = "<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.COMPLAINT_FORM.submit();  
    }
    
    var count = 0;
    function insRow(){
        count++;

        var x=document.getElementById('listTable').insertRow();

        var c1=x.insertCell(0);
        var c2=x.insertCell(1);
        var c3=x.insertCell(2);
        var c4=x.insertCell(3);
        
        c1.innerHTML = count;
        c1.borderWidth = "1px";
        
        c2.borderWidth = "1px";
        c2.borderColor = "white";
        c2.innerHTML = "<INPUT TYPE='hidden' name='compId' ID='compId' SIZE='45' value='new'>"+
                       "<INPUT TYPE='text' name='comp' ID='comp' SIZE='45' MAXLENGTH='200'>";

        c3.borderWidth = "1px";
        c3.borderColor = "white";
        test = removeSpaces(document.getElementById('currentEmpName').value);
        c3.innerHTML = "---"+
                        "<INPUT TYPE='hidden' name='related' ID='related' value='new'>"+
                       "<INPUT TYPE='hidden' name='empId' ID='empId' value="+document.getElementById('currentEmpId').value+">"+
                       "<INPUT TYPE='hidden' name='empName' ID='empName' value="+test+">";

        c4.borderWidth = "1px";
        c4.borderColor = "white";
        c4.innerHTML="<input type='checkbox' name='check' ID='check'>";
    }
    
    function Delete() {
        var tbl = document.getElementById('listTable');
        var check=document.getElementsByName('check');
        var ids = document.getElementsByName('compId');
         
        for(var i=0;i<count;i++){
            if(check[i].checked==true){
                var x = document.getElementById('hiddenTable').insertRow();
                
                var c1=x.insertCell(0);
                c1.innerHTML = "<INPUT TYPE='hidden' name='deletedId' ID='deletedId' value='"+ids[i].value+"'>";
            
                tbl.deleteRow(i+2);
                i--;
                count--;
            }
        }
    }
    
    window.onload = function (){
        count = document.getElementById("serial").value;
    }
    
    function removeSpaces(string) {
	var tstring = "";
	string = '' + string;
	splitstring = string.split(" ");
	for(i = 0; i < splitstring.length; i++){
	    tstring +=splitstring[i]+"_";
        }
	return tstring;
    }
    
    function checkComplaint(){
        flag = true;
        
        var complaintArr = document.getElementsByName('comp');

        if(complaintArr.length != 0){
            for(i=0; i<complaintArr.length; i++){
                if(complaintArr[i].value ==""){
                    alert('Please Enter Inspection');
                    flag = false;
                    return flag;
                }
            }
            
            return flag;
        } else {
            return flag;
        }
    }
</SCRIPT>

<html>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    
    <head>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="autosuggest.css" />
    </head>
    
    <BODY>
        <CENTER>
            <FORM NAME="COMPLAINT_FORM" METHOD="POST">
                <DIV align="left" STYLE="color:blue;">
                    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                    <button onclick="cancelForm();" class="button"><%=BackToList%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"> </button>
                    <button onclick="JavaScript: submitForm();" class="button"><%=save%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
                </DIV>
                <br>
                
                <fieldset class="set">
                    <legend align="center">
                        <table dir="<%=dir%>" align="<%=align%>">
                            <tr>
                                <td class="td">
                                    <font color="blue" size="6"><%=title%> </font>
                                </td>
                            </tr>
                        </table>
                    </legend>
                    <br>
                    
                    <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="400">
                        <TR>
                            <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16" COLSPAN="2">
                                <B><%=JOData%></B>                   
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="cell" bgcolor="#ccdddd" STYLE="text-align:center;font-size:16" WIDTH="200">
                                <b><%=JONo%></b>
                            </TD>
                            <TD CLASS="cell" STYLE="text-align:center;font-size:16;color:red;border-right-width:1px" WIDTH="200">
                                <b><%=issueWbo.getAttribute("businessID").toString().concat("/").concat(issueWbo.getAttribute("businessIDbyDate").toString())%></b>                              
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="cell" bgcolor="#ccdddd" STYLE="text-align:center;font-size:16" WIDTH="200">
                                <b><%=forEqp%></b>
                            </TD>
                            <TD CLASS="cell" STYLE="text-align:center;font-size:16;color:red;border-right-width:1px" WIDTH="200">
                                <b><%=issueWbo.getAttribute("issueType").toString()%></b>
                            </TD>
                        </TR>
                        <%--
                        <TR>
                            
                            <TD CLASS="cell" bgcolor="#ccdddd" STYLE="text-align:center;font-size:16" WIDTH="200">
                                <b><%=labor%></b>
                            </TD>
                            
                            <TD CLASS="cell" ID="empN" STYLE="text-align:center;font-size:16;color:red;border-right-width:1px" WIDTH="200">
                                <b><%=empWbo.getAttribute("driverName").toString()%></b>
                            </TD>
                        </TR>
                          --%>
                           <input type="hidden" name="currentEmpId" id="currentEmpId" value="<%=user.getAttribute("userId").toString()%>">
                                <input type="hidden" name="currentEmpName" id="currentEmpName" value="<%=user.getAttribute("userName").toString()%>">
                
                   </TABLE>
                    <br>
                    
                    <% 
                    if(null!=status) {
                    %>
                    <%
                    if(status.equalsIgnoreCase("ok")){
                        message  = M ;
                    } else {
                        message = M2 ;
                    }
                    %>   
                    <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="795">
                        <TR BGCOLOR="#FFE391">
                            <TD STYLE="text-align:center;font-size:16" class="td" >
                                <B><FONT color='red'><%=message%></FONT></B>
                            </TD>
                        </TR>
                    </TABLE>
                    <%
                    }
                    %>
                    
                    <TABLE ID="listTable" ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="800" STYLE="border-width:1px;border-color:white;">
                        <TR>
                            <TD COLSPAN="3" CLASS="cell" bgcolor="#99cccc" STYLE="text-align:center;font-size:16;border-width:1px">
                                <B><%=title%></B>
                            </TD>
                            <TD COLSPAN="2" CLASS="cell" bgcolor="#99cccc" STYLE="text-align:center;font-size:16;border-width:1px"> 
                                <input type="button" value="<%=addButton%>" style="width:100" ONCLICK="JavaScript:insRow();">
                                <input type="button" value="<%=delButton%>" style="width:100" onclick="JavaScript:Delete();">
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16" WIDTH="50">
                                <b><%=no%></b>
                            </TD>
                            
                            <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16" WIDTH="300">
                                <b><%=complaint%></b>
                            </TD>
                            
                            <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16" WIDTH="150">
                                <b><%=relatedToTask%></b>
                            </TD>
                            <%--
                            <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16" WIDTH="200">
                                <b><%=labor%></b>
                            </TD>
                            --%>
                            <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16" WIDTH="100">
                                <b><%=delButton%></b>
                            </TD>
                        </TR>
                        
                        <input type="hidden" name="serial" id="serial" value="<%=complaintsVec.size()%>">
                        <%
                        for(int i=0; i<complaintsVec.size(); i++){
                        %>
                        <%
                        WebBusinessObject compliantWbo = (WebBusinessObject) complaintsVec.elementAt(i);
                        %>
                        <TR>
                        <TD bgcolor="#ccdddd" STYLE="text-align:center;font-size:14; border-width:1px" WIDTH="50">
                            <%=i+1%>
                        </TD>
                        
                        <TD bgcolor="#ccdddd" STYLE="text-align:center;font-size:14; border-width:1px" WIDTH="300">
                            <textarea readonly cols="35" rows="2"><%=compliantWbo.getAttribute("delayReason").toString()%></textarea>
                            <input type="hidden" id="compId" name="compId" value="<%=compliantWbo.getAttribute("id").toString()%>">
                            <input type="hidden" name="comp" id="comp" value="<%=compliantWbo.getAttribute("delayReason").toString()%>">
                        </TD>
                        
                        <TD bgcolor="#ccdddd" STYLE="text-align:center;font-size:14; border-width:1px" WIDTH="150">
                            <%
                            compTaskVec = new Vector();
                            compTaskVec = issueTaskCompMgr.getOnArbitraryKey(compliantWbo.getAttribute("id").toString(), "key3");
                            if(compTaskVec.size()>0){
                            %>
                            yes 
                            <input type = "hidden" id = "related" name = "related" value = "yes">
                            <%    
                            } else { 
                            %>
                            <FONT COLOR="red">---</FONT>
                            <input type = "hidden" id = "related" name = "related" value = "no">
                            <%
                            }
                            %>                  
                            <input type="hidden" name="empId" id="empId" value="<%=compliantWbo.getAttribute("laborID").toString()%>">
                            <input type="hidden" name="empName" id="empName" value="<%=compliantWbo.getAttribute("laborName").toString()%>">
                        </TD>
                        <%--
                        <TD CLASS="cell" bgcolor="#ccdddd" STYLE="text-align:center;font-size:14; border-width:1px" WIDTH="200">
                            <%=compliantWbo.getAttribute("laborName").toString()%>
                            <input type="hidden" name="empId" id="empId" value="<%=compliantWbo.getAttribute("laborID").toString()%>">
                            <input type="hidden" name="empName" id="empName" value="<%=compliantWbo.getAttribute("laborName").toString()%>">
                        </TD>
                        --%>
                        <TD CLASS="cell" bgcolor="#ccdddd" STYLE="text-align:center;font-size:14; border-width:1px" WIDTH="100">
                            <input type='checkbox' name='check' ID='check'
                            <%if(compTaskVec.size()>0){%>
                             disabled
                            <%}%>
                            >
                        </TD>
                        <%
                        }
                        %>
                    </TABLE>      
                    <br>
                    
                    <table id="hiddenTable">
                        <tr>
                            <td>
                                
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </FORM>
        </CENTER>
    </BODY>
</html>