<%@ page import="com.silkworm.business_objects.*,com.maintenance.db_access.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*,com.tracker.db_access.IssueMgr"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%> 

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
TaskMgr taskMgr = TaskMgr.getInstance();
IssueMgr issueMgr = IssueMgr.getInstance();


String context = metaMgr.getContext();

//Get request data
String issueId = (String)request.getAttribute("issueId");

ArrayList tasks = taskMgr.getTasksbyIssueId(issueId) ;
WebBusinessObject issueWbo = (WebBusinessObject)issueMgr.getOnSingleKey(issueId);

String filterName = (String) request.getAttribute("filterName");
String filterValue = (String) request.getAttribute("filterValue");

String issueNo = (String)request.getAttribute("jobNo");
Vector data = (Vector)request.getAttribute("comp");
String status = (String)request.getAttribute("status");
Boolean isChecked=false;

String stat= (String)request.getSession().getAttribute("currentMode");
String align = null;
String dir = null;
String style = null;
String cellAlign = null;
String message = null;
String lang, langCode, cancel, save, title, JOData, JONo, forEqp, task, complaint, entryTime,notes, add, delete, noComplaints, M, M2;

if(stat.equals("En")){
    align = "center";
    dir = "LTR";
    style = "text-align:left";
    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
    langCode = "Ar";
    cellAlign = "left";
    
    cancel = "Back";
    save = "Save";
    title = "Relate complaints to tasks";
    JOData = "Job Order Data";
    JONo = "Job Order Number";
    forEqp = "Equipment Name";
    task = "Task Name";
    complaint = "Complaint";
    entryTime = "Entry date";
    notes = "Recommendations";
    add = "Select";
    delete = "Delete Selection";
    noComplaints = "No complaints related to this job order";
    M = "Data Had Been Saved Successfully";
    M2 = "Saving Failed ";
}else{
    align = "center";
    dir = "RTL";
    style = "text-align:Right";
    lang = "English";
    langCode = "En";
    cellAlign = "right";
    
    cancel = "&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
    save = "&#1578;&#1587;&#1580;&#1610;&#1604;";
    title = "&#1593;&#1585;&#1590; &#1608;&#1578;&#1581;&#1604;&#1610;&#1604; &#1575;&#1604;&#1588;&#1603;&#1575;&#1608;&#1609;";
    JOData = "&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    JONo = "&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    forEqp = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    task = "&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    complaint = "&#1575;&#1604;&#1588;&#1603;&#1608;&#1609;";
    entryTime = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1583;&#1582;&#1608;&#1604; &#1575;&#1604;&#1588;&#1603;&#1608;&#1609;";
    notes = "&#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
    add = "&#1575;&#1582;&#1578;&#1585;";
    delete = "&#1581;&#1584;&#1601; &#1575;&#1604;&#1575;&#1582;&#1578;&#1610;&#1575;&#1585;";
    noComplaints = "&#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1588;&#1603;&#1575;&#1608;&#1609; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    M = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
    M2 = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
}
%>

<script type="text/javascript">
    function submitForm()
    {
        //var counter=document.getElementById('counter');
        var countValue=checkBox();
        var countResult=parseInt (countValue);

        if(countResult == 0)
            {
                alert('Attach at least one maintenance item ');
            }

        else
          {
                document.COMPLAINT_FORM.action = "<%=context%>/AssignedIssueServlet?op=composeCmpl&issueId=<%=issueId%>&maintTitle=<%=issueWbo.getAttribute("issueType").toString()%>&jobNo=<%=issueNo%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
                document.COMPLAINT_FORM.submit();
          }

    }
    
    function cancelForm(){    
        document.COMPLAINT_FORM.action = "<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.COMPLAINT_FORM.submit();  
    }
    
    function getcheck(i) {
       var task = document.getElementById("task");
       var taskName = task.options[task.selectedIndex].text;
       var taskId = task.options[task.selectedIndex].value;
        
       var tasksNamesArr = document.getElementsByName('taskName');
       var tasksIdsArr = document.getElementsByName('taskId');
       
       var check = document.getElementById("select"+i);
       var delCB = document.getElementById("del"+i);
       
       if(check.checked == true)
       {
           
           if(!checkTask(taskId))
           {
               check.checked = false;
               return;
           }
       
           tasksNamesArr[i].innerHTML = taskName;
           tasksIdsArr[i].value = taskId;

           delCB.checked = false;
           delCB.disabled = true;
       } else {
           check.checked = false;
           
           delCB.disabled = false;
       }
       
   }
   
   function delcheck(i) {
       var tasksNamesArr = document.getElementsByName('taskName');
       var tasksIdsArr = document.getElementsByName('taskId');
       
       var check = document.getElementById("del"+i);
       var selectCB = document.getElementById("select"+i);
       
       if(check.checked == true){
           tasksNamesArr[i].innerHTML = "---";
           tasksIdsArr[i].value = "---";

           selectCB.checked = false;
           selectCB.disabled = true;
       } else {
           check.checked = false;
           
           selectCB.disabled = false;
       }
   }
   
   function checkTask(taskId){
       var flag = true;
       var tasksIdsArr = document.getElementsByName('taskId');

       if(tasksIdsArr.length != 0){
           for(i=0; i<tasksIdsArr.length; i++)
           {
                
               if(tasksIdsArr[i].value == taskId )
               {
                   flag = false;
                   alert('This task was selected for another complaint');
                   return flag;
               }
           }
       }
       
       return flag;
   }

   function checkBox()
   {
       var count = 0;
       var nameValues=document.getElementsByName('taskId');

       for(i=0;i<nameValues.length;i++)
           {
               if(nameValues[i].value != "---")
                   {
                   count++;
                   break;
                   }
           }
        return count;

   }

   function deleteTask(issueiId){

    var url2 = "<%=context%>/AssignedIssueServlet?op=deleteTask&issueId="+issueiId;
    
    if (window.XMLHttpRequest) {
       req = new XMLHttpRequest( );
    }else if (window.ActiveXObject) {
       req = new ActiveXObject("Microsoft.XMLHTTP");
    }
   
   req.open("post",url2,true);
   req.send(null);
 }

</script>
<script src='ChangeLang.js' type='text/javascript'></script>

<HTML>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <BODY>
        <!--a href="<%=context%>/IssueServlet?op=itemComplainRelation&issueId=1327995554000&attachedEqFlag=notatt&equipmentID=1247124225879&issueTitle=Emergency&issueStatus=Assigned">test</a-->
        <FORM NAME="COMPLAINT_FORM" METHOD="POST">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="cancelForm();" class="button"><%=cancel%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            <%if(data.size()>0 && data != null){%>
            <button  onclick="JavaScript:  submitForm();" class="button" ><%=save%><IMG VALIGN="BOTTOM" SRC="images/save.gif"> </button>
            
            <%}%>
            <br>
            
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <%=title%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <br>
                
                <% 
                if(null!=status) {
                %>
                <%
                if(status.equalsIgnoreCase("ok"))
                {
                    message  = M ;
                } else {
                    message = M2 ;
                }
                %>   
                <table ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" width="400">
                    <TR BGCOLOR="#FFE391">
                        <TD STYLE="text-align:center;font-size:16" class="td" >
                            <B><FONT color='red'><%=message%></FONT></B>
                        </TD>
                    </TR>
                </table>
                <%
                }
                %>
                
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
                    <TR>
                        <TD CLASS="cell" bgcolor="#ccdddd" STYLE="text-align:center;font-size:16" WIDTH="200">
                            <b><%=task%></b>
                        </TD>
                        <TD CLASS="cell" STYLE="text-align:center;font-size:16;color:red;border-right-width:1px" WIDTH="200">
                            <SELECT name="task" STYLE="width:233;">
                             <sw:WBOOptionList wboList='<%=tasks%>' displayAttribute = "name" valueAttribute="id"/>
                            </SELECT>
                        </TD>
                    </TR>
                </TABLE>
                <br>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" STYLE="border-width:1px;border-color:white;" ID="listTable">
                    <TR>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;border-width:1px" WIDTH="20">
                            <B>#</B>
                        </TD>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;border-width:1px">
                            <B><%=complaint%></B>
                        </TD>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;border-width:1px" WIDTH="200">
                            <B><%=entryTime%></B>
                        </TD>
                        <TD COLSPAN="2" CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;border-width:1px" WIDTH="300">
                            <B><%=task%></B>
                        </TD>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;border-width:1px">
                            <B><%=notes%></B>
                        </TD>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;border-width:1px" WIDTH="75">
                            <B><%=add%></B>
                        </TD>
                        <TD CLASS="cell" bgcolor="#99bbbb" STYLE="text-align:center;font-size:16;border-width:1px" WIDTH="75">
                            <B><%=delete%></B>
                        </TD>
                    </TR>
                    
                    <%if(data.size()<=0 || data == null){%>
                    <TR>
                        <TD COLSPAN="8" bgcolor="white" STYLE="text-align:center;font-size:14; border-width:1px;color:red">
                            <B><%=noComplaints%></B>
                        </TD>
                    </TR>
                    <%
                    } else {
                    %>
                    <%
                    for(int i=0;i<data.size();i++){
                    %>
                    <%
                    WebBusinessObject wbo = (WebBusinessObject) data.elementAt(i);
                    %>
                    <TR>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px" ID='counter<%=i%>'>
                            <%=i+1%>
                        </TD>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px">
                            <textarea readonly cols="20" rows="2"><%=wbo.getAttribute("complaint").toString()%></textarea>
                            <input type="hidden" name="compId" id="compId" value='<%=wbo.getAttribute("complaintId").toString()%>'>
                        </TD>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px">
                            <%=wbo.getAttribute("creationTime").toString()%>
                        </TD>
                        
                        <%
                        if(!wbo.getAttribute("taskId").toString().equalsIgnoreCase("null")){
                        %>
                        <%
                        WebBusinessObject taskWbo = taskMgr.getOnSingleKey(wbo.getAttribute("taskId").toString());
                        %>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px" WIDTH="100" ID="taskName">
                            <%=taskWbo.getAttribute("name")%>
                        </TD>
                        <TD>
                            <input type="hidden" name="taskId" id="taskId" value="<%=taskWbo.getAttribute("id")%>">
                        </TD>
                        <%} else {%>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px" WIDTH="100" ID="taskName">
                            ---
                        </TD>
                        <TD>
                            <input type="hidden" name="taskId" id="taskId" value="---">
                        </TD>
                        <%}%>
                        <% 
                        Hashtable wboAtt = wbo.getContents();
                        if(wboAtt.size() <7) {
                        %>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px">
                            <textarea cols="20" rows="2" name="recommend" id="recommend">No Recommendation</textarea>
                        </TD>
                        <%} else {%>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px">
                            <textarea cols="20" rows="2" name="recommend" id="recommend"><%=wbo.getAttribute("recomend").toString()%></textarea>
                        </TD>
                        <%}%>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px">
                            <input type='checkbox' name='select<%=i%>' ID='select<%=i%>' value="<%=i%>" onclick="getcheck('<%=i%>')" >
                        </TD>
                        <TD bgcolor="lightblue" STYLE="text-align:center;font-size:14; border-width:1px">
                            <input type='checkbox' name='del<%=i%>' ID='del<%=i%>' value="<%=i%>" onclick="deleteTask('<%=issueId%>');delcheck('<%=i%>');" >
                        </TD>
                    </TR>
                    <%
                    }
                    }
                    %>
                </TABLE>
                <br>
            </fieldset>
        </FORM>
    </BODY>
</HTML>
