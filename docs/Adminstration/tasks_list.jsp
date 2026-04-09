<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*,com.maintenance.db_access.EqChangesMgr,com.maintenance.servlets.*,java.text.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.contractor.db_access.MaintainableMgr,com.maintenance.db_access.*, com.tracker.db_access.*,com.maintenance.db_access.EquipmentStatusMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    
    <%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    DateAndTimeControl dateAndTime = new DateAndTimeControl();
    int noOfLinks=0;
    int count=0;
    String tempcount=(String)request.getAttribute("count");
    String taskName = (String)request.getAttribute("taskName");
    String isCode = (String)request.getAttribute("isCode");
    if(tempcount!=null)
        count=Integer.parseInt(tempcount);
    String tempLinks=(String)request.getAttribute("noOfLinks");
    if(tempLinks!=null)
        noOfLinks=Integer.parseInt(tempLinks);
    String fullUrl=(String)request.getAttribute("fullUrl");
    String url=(String)request.getAttribute("url");
    
    /**********************************/
    String temp=request.getAttribute("numRows").toString();
    int numRows=Integer.parseInt(temp);
    /**********************************/
    
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
    </SCRIPT>
    <script type="text/javascript">
      var numRows=<%=numRows%>;

      function addTasks(){
          
            var tasksCheckBox=document.getElementsByName('task');
            
            for (m=0;m<tasksCheckBox.length;m++)
              {
              if (tasksCheckBox[m].checked)
                {
                    var codeName=tasksCheckBox[m].value.split("!#");
                    sendInfo(codeName[0],codeName[1],codeName[2],codeName[3],codeName[4],codeName[5],codeName[6]);
                }
              }
            window.close();  
      }
      
      
      function sendInfo(taskId,name,trade,eqpName,size,hours,primeryId){
       
        if(isExecutedFound(taskId)){
            alert(" that item is exist already in executed tasks table");
            return;
        }        
      
        if(isFound(taskId)){
            alert(" that item is exist already in the table");
            return;
        }        
        
        var className="tRow";
        if((numRows%2)==1)
        {
            className="tRow";
        }else{
            className="tRow2";
        }        
        
        var x = window.opener.document.getElementById('listTable').insertRow();
        
        var C1 = x.insertCell(0);
        var C2 = x.insertCell(1);
        var C3 = x.insertCell(2);
        var C4 = x.insertCell(3);
        var C5 = x.insertCell(4);
        var C6 = x.insertCell(5);
        var C7 = x.insertCell(6);
        //var C8 = x.insertCell(7);
        
        C1.borderWidth = "3px";
        C1.borderColor="white";
        C1.id = "codeTask";
        C1.bgColor = "powderblue";
        C1.className=className;
        
        C2.borderWidth = "1px";
        C2.id = "descEn";
        C2.bgColor = "powderblue";
        C2.className=className;
        
        C3.borderWidth = "1px";
        C3.id = "trade";
        C3.bgColor = "powderblue";
        C3.className=className;
                
       // C4.borderWidth = "1px";
       // C4.id = "eqType";
       // C4.bgColor = "powderblue";
       // C4.className=className;
        
//        C4.borderWidth = "1px";
//        C4.id = "jobSize";
//        C4.bgColor = "powderblue";
//        C4.className=className;
        
        C4.borderWidth = "1px";
        C4.id = "EHours";
        C4.bgColor = "powderblue";
        C4.className=className;
        
        C5.borderWidth = "1px";
        C5.bgColor = "powderblue";
        C5.className=className;
       
        C6.borderWidth = "1px";
        C6.bgColor = "powderblue";
        C6.className=className;
  
        C5.innerHTML = "<textarea name='desc' ID='desc' cols='20' rows='2'></textarea>";
        C6.innerHTML = "<input type='checkbox' name='check' ID='check'>"+"<input type='hidden' name='id' ID='id'>";

        var pr=window.opener.document.getElementsByName('codeTask');
        var nam=window.opener.document.getElementsByName('descEn');
        var idCells=window.opener.document.getElementsByName('id');
        var hoursCells=window.opener.document.getElementsByName('EHours'); 
        var jop=window.opener.document.getElementsByName('trade');
//        var jopS=window.opener.document.getElementsByName('jobSize');
       // var EQT=window.opener.document.getElementsByName('eqType');
        
        nam[numRows].innerHTML = name;
        pr[numRows].innerHTML = taskId;
        idCells[numRows].value=primeryId;
       // EQT[numRows].innerHTML=eqpName;
//        jopS[numRows].innerHTML=size;
        hoursCells[numRows].innerHTML=hours;
        jop[numRows].innerHTML=trade;
        
        numRows++;

        window.opener.document.getElementById('nRows').value=numRows;

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
           if(true==<%=isCode%>) {              
                document.tasks_form.action = "<%=context%>/<%=fullUrl%>&count="+x+"&url=<%=url%>&taskCode="+res+"&numRows="+numRows;
           }else{
                document.tasks_form.action = "<%=context%>/<%=fullUrl%>&count="+x+"&url=<%=url%>&taskName="+res+"&numRows="+numRows;
                }
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
           if(true==<%=isCode%>) {              
               document.tasks_form.action = "<%=context%>/<%=fullUrl%>&count="+x+"&url=<%=url%>&taskCode="+res+"&numRows="+numRows;
           }else {
               document.tasks_form.action = "<%=context%>/<%=fullUrl%>&count="+x+"&url=<%=url%>&taskName="+res+"&numRows="+numRows;
           }
           document.tasks_form.submit();
       }
       
      function isFound(x){
        var code=window.opener.document.getElementsByName('codeTask');
        var temp1="";
        var temp2="";
        
        for(var i=0;i<numRows;i++){
            var t=code[i].innerHTML;
            t=t.replace(" ","");
            var z=x.replace(" ","");
            
            temp1="";
            temp2="";
            for(n=0;n<t.length;n++){
                temp1+=t.charAt(n).charCodeAt();
            }
            for(c=0;c<z.length;c++){
                temp2+=z.charAt(c).charCodeAt();
            }
            
            if(temp1==temp2) 
                return true;
            }
        
        return false;
    }
    
    function isExecutedFound(x){
        var code=window.opener.document.getElementsByName('executedCodeTask');

        for(i=0;i<window.opener.document.getElementById('executedCon').value;i++){
            if(x == (code[i].innerHTML).replace(" ", "")){
                return true;
            }
        }
        
        return false;
    }
    
       
                                     </script>
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
                <tr>
                    <td>
                        <input type="button" onclick="addTasks()" value="Add Tasks">
                    </td>
                </tr>                
            </table>
            <TABLE ALIGN="CENTER" dir="<%=dir%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-style:solid;border-width:2;border-color:black;border-right-WIDTH:2px;">
                
                <TR CLASS="header">
                    <TD nowrap CLASS="header" STYLE="border-WIDTH:0;<%=style%>;padding-right:50;font-size:16;color:white;height:30;" nowrap>
                        <B><%=selectTask%></B>
                    </TD>
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
                    eqpName=wbo.getAttribute("eqpName").toString();
                    String exeHours = wbo.getAttribute("executionHrs").toString();
                    Double execHr = 0.0;
                    int execIntHr = 0;
                    execHr = new Double(exeHours).doubleValue();
                    if(execHr<1){
                        execHr =1.0;
                           }
                    execIntHr = execHr.intValue();
                    hours= dateAndTime.getDaysHourMinute(execIntHr);
                    //hours=wbo.getAttribute("executionHrs").toString();
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
                        <input type="checkbox" name="task" id="task" value="<%=taskCode%>!#<%=taskName%>!#<%=trade%>!#<%=eqpName%>!#<%=jobSize%>!#<%=hours%>!#<%=primeryId%>">
                    </TD>
                    
                    <TD  STYLE="<%=style%>;padding-right:40;height:20;" nowrap  CLASS="<%=classStyle%>" BGCOLOR="#DDDD00">
                        <b style="text-decoration: none"><font color="black" size="3"> <%=taskName%></font> </b> 
                    </TD>
                    
                    <TD  STYLE="<%=style%>;padding-right:40;height:20;" nowrap  CLASS="<%=classStyle%>" BGCOLOR="#DDDD00">
                        <b style="text-decoration: none"><font color="black" size="3"> <%=taskCode%></font> </b> 
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
