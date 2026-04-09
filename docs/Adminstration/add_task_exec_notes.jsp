<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*,com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    
    
    <%
    
    String status = (String) request.getAttribute("status");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    Vector taskNotes=new Vector();
    WebBusinessObject taskWbo=new WebBusinessObject();
    
    taskWbo=(WebBusinessObject)request.getAttribute("taskWbo");
    taskNotes=(Vector)request.getAttribute("taskNotes");
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String cancel_button_label;
    String fStatus;
    String sStatus;
    String save_button_label;
    
    String add,delete,noteStr,fieldTitle,headTitle,addStr;
    
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        fieldTitle="Add Execution Notes On Task";
        cancel_button_label="Cancel ";
        save_button_label="Save ";
        langCode="Ar";
        
        sStatus="Task Execution Notes Saved Successfully";
        fStatus="Fail To Save Task Execution Notes ";
        
        add="Add New Note";
        addStr="Click On add boutton to add new Notes";
        delete="Delete Note";
        noteStr="Execution Notes";
        
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        fieldTitle="&#1573;&#1590;&#1575;&#1601;&#1607; &#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1578;&#1606;&#1601;&#1610;&#1584; &#1604;&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604;";
        langCode="En";
        
        fStatus="&#1604;&#1605; &#1610;&#1578;&#1605; &#1578;&#1587;&#1580;&#1610;&#1604; &#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
        sStatus="&#1578;&#1605; &#1578;&#1587;&#1580;&#1610;&#1604; &#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584; &#1576;&#1606;&#1580;&#1575;&#1581;";
        
        add="&#1571;&#1590;&#1601; &#1578;&#1608;&#1589;&#1610;&#1607; &#1580;&#1583;&#1610;&#1583;&#1607;";
        addStr="&#1573;&#1590;&#1594;&#1591; &#1593;&#1604;&#1610; &#1575;&#1604;&#1586;&#1585; &#1571;&#1590;&#1601; &#1604;&#1573;&#1590;&#1575;&#1601;&#1607; &#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1580;&#1583;&#1610;&#1583;&#1607;";
        delete="&#1581;&#1584;&#1601; &#1578;&#1608;&#1589;&#1610;&#1607;";
        noteStr="&#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
        
    }
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Add Task Execution Notes</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css\headers.css">        
        
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">   
        count=<%=taskNotes.size()%>;
        function addNotes(){

            count++;
            var className="tRow2";
            if((count%2)==1)
            {
                className="tRow2";
            }else{
                className="tRow";
            }
        
            var noteTable=document.getElementById("taskExecTable").insertRow();

            var C1=noteTable.insertCell(0);
            var C2=noteTable.insertCell(1);

            C1.borderWidth = "1px";
            C1.id = "noteTd";
            C1.bgColor = "#FFE391";
            C1.className=className;

            C2.borderWidth = "1px";
            C2.id = "deleteTd";
            C2.bgColor = "#FFE391";
            C2.className=className;

            C1.innerHTML = "<textarea name='notes' id='notes' cols='52' rows='2'> Write Execution Notes </textarea>";
            C2.innerHTML = "<input type='checkbox' name='check' ID='check'>";
        
            
        }
        
        </script>
        
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {
        
             if(count>0){
             
                checkNotes()
                document.ITEM_FORM.action = "<%=context%>/TaskServlet?op=saveTaskNotes&taskId="+<%=taskWbo.getAttribute("id").toString()%>;
                document.ITEM_FORM.submit();  

                }else{
                var r=confirm("Are You Sure You need to delete all Task Execution Notes");
                if (r==true)
                {
                    checkNotes()
                    document.ITEM_FORM.action = "<%=context%>/TaskServlet?op=saveTaskNotes&taskId="+<%=taskWbo.getAttribute("id").toString()%>;
                    document.ITEM_FORM.submit();
                }else{
                    alert("You must add at least one Task Execution Notes Fot This Task");
                }
             }
        }
        
     function cancelForm()
        {    
        document.ITEM_FORM.action = "main.jsp";
        document.ITEM_FORM.submit();  
        }
         
    function Delete() {
    
        var tbl = document.getElementById('taskExecTable');
        var check=document.getElementsByName('check');
        
        for(var i=0;i<count;i++){
            if(check[i].checked==true){
                
                tbl.deleteRow(i+1);
                i--;
                count--;

            }   
        }
    }
    
    
    
    
    function checkNotes(){
        var notesArr = document.getElementsByName('notes');
        
        for(i=0; i<notesArr.length; i++){
            if(notesArr[i].value =="" || notesArr[i].value =="null")
                notesArr[i].value = "No Notes";
        }
    }
                                  </SCRIPT>
        
    </HEAD>
    
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
                            <font color="blue" size="6"><%=fieldTitle%></font>                            
                        </td>
                    </tr>
                </table>
            </legend>
            
            <table align="<%=align%>" dir=<%=dir%>>
                <TR COLSPAN="2" ALIGN="<%=align%>">
                    <TD STYLE="<%=style%>" class='td'>
                        <FONT color='red' size='+1'><%=taskWbo.getAttribute("title").toString()%></FONT> 
                    </TD>
                    
                </TR>
            </table>
            <br>
            
            <%
            if(null!=status) {
        if(status.equalsIgnoreCase("ok")){
            %>  
            <table align="<%=align%>" dir=<%=dir%> width="400">
                <tr>                    
                    <td class="bar">
                        <center>
                            <font size="3" color="black" ><%=sStatus%></FONT> 
                        </center>
                    </td>                    
            </tr> </table>
            <br>
            <%
            }else{%>
            <table align="<%=align%>" dir=<%=dir%> width="400">
                <tr>                    
                    <td class="bar">
                        <center>
                            <font size="3" color="red" ><%=fStatus%></font> 
                        </center>
                    </td>                    
            </tr> </table>
            <br>
            <%}}%>
            
            <TABLE ALIGN="<%=align%>"  DIR="<%=dir%>" border="0" width="60%">
                <tr>
                    <TD STYLE="text-align:center" CLASS="tRow" HEIGHT="35">
                        <font color="black" size="3">
                            <%=addStr%>
                        </font>
                    </td>
                    <TD STYLE="text-align:center" CLASS="tRow" HEIGHT="35">
                        <input type="button" value="<%=add%>" onclick="JavaScript: addNotes()">
                    </TD>
                </tr>
            </table>
            
            <br>
            
            <TABLE ID="taskExecTable" ALIGN="<%=align%>"  DIR="<%=dir%>" border="0" width="60%">
                <TR>
                    <TD STYLE="text-align:center" CLASS="header">
                        <b><font color="white" size="4"><%=noteStr%></font></b>
                    </TD>
                    <TD STYLE="text-align:center" class='header'>
                        <input type="button" value="<%=delete%>" onclick="JavaScript: Delete()">
                    </TD>
                </TR>
                
                <%
                String classStyle="tRow";
                WebBusinessObject taskExecNotesWbo=new WebBusinessObject();
                for(int i=0;i<taskNotes.size();i++){
                    taskExecNotesWbo=new WebBusinessObject();
                    taskExecNotesWbo=(WebBusinessObject)taskNotes.get(i);
                    
                    if((i%2)==1){
                        classStyle="tRow";
                    }else{
                        classStyle="tRow2";
                    }
                %>
                
                <TR>
                    <TD STYLE="<%=style%>;font-wieght:bold;" CLASS="<%=classStyle%>" ID="toolNo">
                        <textarea name='notes' id='notes' cols='52' rows='2'><%=taskExecNotesWbo.getAttribute("notes").toString()%></textarea>
                    </TD>
                    <TD STYLE="text-align:center" class='<%=classStyle%>'>
                        <input type="checkbox" name="check" id="check">
                    </TD>
                </TR>
                
                <%}%>
            </TABLE>
            
        </FORM>
    </BODY>
</HTML>     
