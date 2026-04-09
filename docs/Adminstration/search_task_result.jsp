
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*,com.maintenance.db_access.EqChangesMgr,com.maintenance.servlets.*,java.text.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.contractor.db_access.MaintainableMgr,com.maintenance.db_access.*, com.tracker.db_access.*,com.maintenance.db_access.EquipmentStatusMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    
    <%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    int noOfLinks=0;
    int count=0;
    
    String searchType=(String)request.getAttribute("searchType");
    String popup = (String)request.getAttribute("popup");
    String tempcount=(String)request.getAttribute("count");
    String taskName = (String)request.getAttribute("taskName");
    String taskName1 = (String)request.getAttribute("taskName1");
    String taskCode1 = (String)request.getAttribute("taskCode");
    if(tempcount!=null)
        count=Integer.parseInt(tempcount);
    String tempLinks=(String)request.getAttribute("noOfLinks");
    if(tempLinks!=null)
        noOfLinks=Integer.parseInt(tempLinks);
    String fullUrl=(String)request.getAttribute("fullUrl");
    String url=(String)request.getAttribute("url");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    String[] projectAttributes = {"itemCode","itemDscrptn"};
    String[] projectListTitles = new String[4];
    
    int s = projectAttributes.length;
    int t = s;
    int iTotal = 0;
    int flipper = 0;
    
    String attName = null;
    String attValue = null;
    String cellBgColor = null;
    String bgColor = null;
    
    boolean active;
    
    Vector  tasks = (Vector) request.getAttribute("data");
    
    WebBusinessObject wboCategoryName = null;
    
    WebBusinessObject wbo = null;
    
    EqChangesMgr eqChangesMgr = EqChangesMgr.getInstance();
    String  categoryName = (String) request.getAttribute("categoryName");
    
    EquipmentStatusMgr equipmentStatusMgr = EquipmentStatusMgr.getInstance();
    String  formName = (String) request.getAttribute("formName");
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,cancel,tasksNum;
    
    String taskNameLable,taskCodeLable,listTasksTitle,selectTask,addTasks;
    
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        taskNameLable="Task Name";
        taskCodeLable="Task Code";
        listTasksTitle="List Spare Tasks";
        tasksNum="Number Of Tasks";
        selectTask="Select Task";
        addTasks="Add Tasks";
        
        
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        taskNameLable="&#1575;&#1587;&#1605; &#1575;&#1604;&#1576;&#1606;&#1583;";
        taskCodeLable="&#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583;";
        listTasksTitle="&#1593;&#1585;&#1590; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        tasksNum="&#1593;&#1583;&#1583; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607; &#1575;&#1604;&#1603;&#1604;&#1609;";
        selectTask="&#1571;&#1582;&#1578;&#1585; &#1575;&#1604;&#1576;&#1606;&#1583;";
        addTasks="&#1573;&#1590;&#1575;&#1601;&#1607; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        
    }
    %>
    
    <HEAD>
        <TITLE>Tasks List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/images.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/headers.css">
        
    </HEAD>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
       
        
      function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
       function cancelForm(url)
        {    
        window.navigate(url);
        }
        
         function getUnitTop(){
           var x =document.getElementById("selectIdTop").value;
           x = parseInt(x);
           var name =document.getElementById("taskName").value;
           var res = ""
           for (i=0;i < name.length; i++) {
                res += name.charCodeAt(i) + ',';
           }
           res = res.substr(0, res.length - 1);
           document.tasks_form.action = "<%=context%>/<%=fullUrl%>&count="+x+"&url=<%=url%>&taskName="+res+"&searchType=<%=searchType%>";
           document.tasks_form.submit();
       }
       
       function getUnitDown(){
           var x =document.getElementById("selectIdDown").value;
           x = parseInt(x);
           var name =document.getElementById("taskName").value;
           var res = ""
           for (i=0;i < name.length; i++) {
                res += name.charCodeAt(i) + ',';
           }
           res = res.substr(0, res.length - 1);
           document.tasks_form.action = "<%=context%>/<%=fullUrl%>&count="+x+"&url=<%=url%>&taskName="+res+"&searchType=<%=searchType%>";
           document.tasks_form.submit();
       }
        
        <%--------------Popup window-------------------%> 
        //function openWindowTaskData(url)
           // {
              //  window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=500, height=400");
            //}
        function getTaskData(id)
            {
                
                //var formName = document.getElementById(formName).value;
                
                var popup = '<%=popup%>';
                
                if('<%=searchType%>'=='code') { 
                    if(popup=="no"){
                        document.tasks_form.action = "<%=context%>/TaskServlet?op=getTaskDataNotPopup&taskId="+id+"&searchType=<%=searchType%>&taskCode=<%=taskCode1%>";
                    }else{
                        document.tasks_form.action = "<%=context%>/TaskServlet?op=getTaskData&taskId="+id+"&searchType=<%=searchType%>&taskCode=<%=taskCode1%>";
                    }
                   document.tasks_form.submit();
                }
                else if('<%=searchType%>'=='name') { 
                 if(popup=="no"){
                     document.tasks_form.action = "<%=context%>/TaskServlet?op=getTaskDataNotPopup&taskId="+id+"&searchType=<%=searchType%>&taskName=<%=taskName1%>";
                 }else{
                     document.tasks_form.action = "<%=context%>/TaskServlet?op=getTaskData&taskId="+id+"&searchType=<%=searchType%>&taskName=<%=taskName1%>";
                 }
                    document.tasks_form.submit();
                }
                 //////openWindowTaskData('TaskServlet?op=getTaskData&taskId='+id);
            }
        <%---------------------------------%> 
       
       
       
    </SCRIPT>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    
    <BODY>
        <FORM NAME="tasks_form" METHOD="POST">
            
            <fieldset align="center" class="set" >
            <legend align="center">
                <table dir="rtl" align="center">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">
                                <%=listTasksTitle%>
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            
            <br>
            <%if(noOfLinks>0){%>
            <table align="center">
                <tr>
                    <td class="td" >
                        <b><font size="2" color="red">page No:</font><font size="2" color="black"><%=count+1%></font><font size="2" color="red">from</font><font size="2" color="black"> <%=noOfLinks%></font></b>
                        <input type="hidden" name="taskName" id="taskName" value="<%=taskName%>">
                    </td>
                    <td class="td"  >
                        <select id="selectIdTop" onchange="javascript:getUnitTop();">
                            <%for(int i=0;i<noOfLinks;i++){%>
                            <option value="<%=i%>" <%if(i==count){%> selected <% } %> ><%=i+1%></option>
                            <% } %>
                        </select>
                    </td>
                </tr>
            </table>
            <BR>
            <%}%>
            
            <TABLE ALIGN="CENTER" dir="<%=dir%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-style:solid;border-width:2;border-color:black;border-right-WIDTH:2px;">
                
                <TR CLASS="header">
                    <TD nowrap CLASS="header" STYLE="border-WIDTH:0;<%=style%>;padding-right:50;font-size:16;color:white;height:30;" nowrap>
                        <B><%=taskNameLable%></B>
                    </TD>
                    <TD nowrap CLASS="header" STYLE="border-WIDTH:0;<%=style%>;padding-right:50;font-size:16;color:white;height:30;" nowrap>
                        <B><%=taskCodeLable%></B>
                    </TD>
                </TR>
                
                <%
                Enumeration e = tasks.elements();
                String taskCode="";
                String jobSize="";
                String trade="";
                String eqpName="";
                String hours="";
                String primeryId="";
                String classStyle="tRow2";
                while(e.hasMoreElements()) {
                    iTotal++;
                    wbo = (WebBusinessObject) e.nextElement();
                    taskCode = wbo.getAttribute("title").toString();
                    taskName = wbo.getAttribute("name").toString();
                    jobSize=wbo.getAttribute("repairtype").toString();
                    trade=wbo.getAttribute("trade").toString();
                    hours=wbo.getAttribute("executionHrs").toString();
                    primeryId=wbo.getAttribute("id").toString();
                    
                    flipper++;
                    if((flipper%2) == 1) {
                        classStyle="tRow2";
                    } else {
                        classStyle="tRow";
                    }
                %>
                
                <TR>
                    
                    <TD  STYLE="<%=style%>;padding-right:40;height:20;" nowrap  CLASS="<%=classStyle%>" BGCOLOR="#DDDD00">
                        <a href="javaScript:getTaskData('<%=primeryId%>');">
                        <b style="text-decoration: none"><font color="black" size="3"> <%=taskName%></font> </b> 
                        </a>
                    </TD>
                    
                    <TD  STYLE="<%=style%>;padding-right:40;height:20;" nowrap  CLASS="<%=classStyle%>" BGCOLOR="#DDDD00">
                        <a href="javaScript:getTaskData('<%=primeryId%>');">
                            <b style="text-decoration: none"><font color="black" size="3"> <%=taskCode%></font> </b> 
                        </a>
                    </TD>
                </tr>
                <% }%>
                <TR>
                    <TD CLASS="bar" BGCOLOR="#808080"  STYLE="text-align:center;padding-left:5;border-right-width:1;color:Black;font-size:16;">
                        <B><%=tasksNum%></B>
                    </TD>
                    
                    <TD CLASS="bar" BGCOLOR="#808080" COLSPAN="2" STYLE="text-align:center;padding-left:5;color:Black;font-size:16;">
                        <DIV NAME="" ID="">
                            <B><%=iTotal%></B>
                        </DIV>
                    </TD>
                </TR>
                
            </TABLE>
            <table align="center">
                
                <input type="hidden" name="url" value="<%=url%>" id="url" >
                <input type="hidden" name="formName" value="<%=formName%>" id="formName" >
                <%if(noOfLinks>0){%>
                <tr>
                    <td class="td" >
                        <b><font size="2" color="red">page No:</font><font size="2" color="black"><%=count+1%></font><font size="2" color="red">from</font><font size="2" color="black"> <%=noOfLinks%></font></b>
                    </td>
                    <td class="td"  >
                        <select id="selectIdDown" onchange="javascript:getUnitDown();">
                            <%for(int i=0;i<noOfLinks;i++){%>
                            <option value="<%=i%>" <%if(i==count){%> selected <% } %> ><%=i+1%></option>
                            <% } %>
                        </select>
                    </td>
                </tr>
                <%}%>
            </table>
            
        </FORM>
    </BODY>
</html>
