<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*,com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    
    
    <%
    
    String status = (String) request.getAttribute("status");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    Vector tools=new Vector();
    WebBusinessObject taskWbo=new WebBusinessObject();
    taskWbo=(WebBusinessObject)request.getAttribute("taskWbo");
    tools=(Vector)request.getAttribute("tools");
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String title_1;
    String cancel_button_label;
    String fStatus;
    String sStatus;
    String save_button_label;
    
    String search,toolName,searchTitle,searchLableName,searchLableCode,toolCode,delete,notes,searchByName,searchByCode;
    
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        title_1="Add Heavy Tools On Maintenance Item";
        cancel_button_label="Cancel ";
        save_button_label="Save ";
        langCode="Ar";
        
        sStatus="Maintenance Item Saved Successfully";
        fStatus="Fail To Save Maintenance Item ";
        
        search="Auto search";
        searchLableName="Write Tool Name or SubName";
        searchLableCode="Write Tool Code or SubCode";
        searchTitle="Seach About Tools By Name Or Code";
        toolName="Tool Name";
        toolCode="Tool Code";
        delete="Delete";
        notes="Notes";
        searchByName="Saerch By Name";
        searchByCode="Search By Code";
        
        
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        title_1="&#1571;&#1590;&#1575;&#1601;&#1607; &#1571;&#1583;&#1608;&#1575;&#1578; &#1579;&#1602;&#1610;&#1604;&#1607; &#1604;&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604;";
        langCode="En";
        
        fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
        sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
        
        search="&#1576;&#1581;&#1579; &#1584;&#1575;&#1578;&#1610;";
        searchLableName="&#1571;&#1603;&#1578;&#1576; &#1575;&#1587;&#1605; &#1575;&#1604;&#1571;&#1583;&#1575;&#1607; &#1575;&#1608; &#1580;&#1586;&#1569; &#1605;&#1606;&#1607;";
        searchLableCode="&#1571;&#1603;&#1578;&#1576; &#1603;&#1608;&#1583; &#1575;&#1604;&#1571;&#1583;&#1575;&#1607; &#1575;&#1608; &#1580;&#1586;&#1569; &#1605;&#1606;&#1607;";
        searchTitle="&#1576;&#1581;&#1579; &#1593;&#1606; &#1575;&#1604;&#1571;&#1583;&#1608;&#1575;&#1578; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605; &#1575;&#1608; &#1575;&#1604;&#1603;&#1608;&#1583;";
        toolName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1571;&#1583;&#1575;&#1607;";
        toolCode="&#1603;&#1608;&#1583; &#1575;&#1604;&#1571;&#1583;&#1575;&#1607;";
        delete="&#1581;&#1584;&#1601;";
        notes="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        searchByName="&#1576;&#1581;&#1579; &#1576;&#1575;&#1587;&#1605; &#1575;&#1604;&#1571;&#1583;&#1575;&#1607;";
        searchByCode="&#1576;&#1581;&#1579; &#1576;&#1603;&#1608;&#1583; &#1575;&#1604;&#1575;&#1583;&#1575;&#1607;";
        
    }
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Add Task Toos</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css\headers.css">        
        
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            
        function submitForm()
        {
        
             count=document.getElementById('nRows').value;
             if(count>0){
                checkNotes();
                document.ITEM_FORM.action = "<%=context%>/TaskServlet?op=saveTaskTools&toolType=heavy&taskId="+<%=taskWbo.getAttribute("id").toString()%>;
                document.ITEM_FORM.submit();  
             }else{
                var r=confirm("Are You Sure You need to delete all Tools")  
                if (r==true)
                {
                    checkNotes();
                    document.ITEM_FORM.action = "<%=context%>/TaskServlet?op=saveTaskTools&toolType=heavy&taskId="+<%=taskWbo.getAttribute("id").toString()%>;
                    document.ITEM_FORM.submit();  
                }else{
                    alert("You must add at least one Tool Fot This Task");
                }
             }
        }
        
     function cancelForm()
        {    
        document.ITEM_FORM.action = "main.jsp";
        document.ITEM_FORM.submit();  
        }
            
    var count = 0;

    function Delete() {
    
        var tbl = document.getElementById('listTable');
        var check=document.getElementsByName('check');
        
        count=document.getElementById('nRows').value;
        
        for(var i=0;i<count;i++){
            if(check[i].checked==true){
                
                tbl.deleteRow(i+1);
                i--;
                count--;
                
                document.getElementById('nRows').value=count;
                
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
    
    <script>
       <%--------------Popup window-------------------%> 
        function openWindowTools(url)
            {
                window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=500");
            }
        function getTools()
            {
                var formName = document.getElementById('ITEM_FORM').getAttribute("name");
                var name = document.getElementById('toolName').value
                var res = ""
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                count=document.getElementById('nRows').value;
                openWindowTools('TaskServlet?op=listTools&searchType=name&toolName='+res+'&formName='+formName+'&numRows='+count);
            }
        function getToolsByCode()
            {
                var formName = document.getElementById('ITEM_FORM').getAttribute("name");
                var name = document.getElementById('toolCode').value
                var res = ""
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                count=document.getElementById('nRows').value;
                openWindowTools('TaskServlet?op=listTools&searchType=code&toolCode='+res+'&formName='+formName+'&numRows='+count);
            }
        <%---------------------------------%> 
        
        function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                  document.getElementById(name).style.display = 'block';
            } else {
                   document.getElementById(name).style.display = 'none';
            }
        }
        
    </script>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="ITEM_FORM" METHOD="POST">
            <input type="hidden" name="nRows" id="nRows" value="<%=tools.size()%>">
            
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
            <table align="<%=align%>" border="0" width="80%">
                <tr>
                    <td width="50%" STYLE="border:0px;">
                        <div STYLE="width:80%;border:2px solid gray;color:white;" class="header" align="<%=align%>">
                            <div ONCLICK="JavaScript: changeMode('menu1');" class="header" STYLE="width:100%;color:white;cursor:hand;font-size:16;">
                                <b>
                                    <%=searchTitle%>
                                </b>
                                <img src="images/arrow_down.gif">
                            </div>
                            <div ALIGN="<%=align%>" STYLE="width:100%;color:white;display:none;text-align:right;border-top:2px solid gray;" ID="menu1">
                                <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                                    <tr>
                                        <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                            <B><%=searchLableName%></b>
                                            <input type="text" name="toolName" id="toolName">
                                        </td>
                                        <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                            <button onclick="JavaScript:getTools();" style="width:120"> <%=searchByName%> <IMG VALIGN="BOTTOM" SRC="images/search.gif"></button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                            <B><%=searchLableCode%></b>
                                            <input type="text" name="toolCode" id="toolCode">
                                        </td>
                                        <td CLASS="tRow" bgcolor="white" STYLE="text-align:center;">
                                            <button onclick="JavaScript:getToolsByCode();" style="width:120"> <%=searchByCode%> <IMG VALIGN="BOTTOM" SRC="images/search.gif"></button>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </td>
                </tr>
            </table>
            <br>
            
            
            <TABLE ID="listTable" ALIGN="<%=align%>"  DIR="<%=dir%>" border="0" width="80%">
                <TR>
                    <TD STYLE="text-align:center" CLASS="header">
                        <b><font color="white" size="4"><%=toolCode%></font></b>
                    </TD>
                    <TD STYLE="text-align:center" CLASS="header">
                        <b><font color="white" size="4"><%=toolName%></font></b>
                    </TD>
                    <TD STYLE="text-align:center" CLASS="header">
                        <b><font color="white" size="4"><%=notes%></font></b>
                    </TD>
                    <TD STYLE="text-align:center" class='header'>
                        <input type="button" value="<%=delete%>" onclick="JavaScript: Delete()">
                    </TD>
                </TR>
                
                <%
                String classStyle="tRow";
                WebBusinessObject taskToolWbo=new WebBusinessObject();
                for(int i=0;i<tools.size();i++){
                    taskToolWbo=new WebBusinessObject();
                    taskToolWbo=(WebBusinessObject)tools.get(i);
                    
                    if((i%2)==1){
                        classStyle="tRow";
                    }else{
                        classStyle="tRow2";
                    }
                %>
                
                <TR>
                    <TD STYLE="<%=style%>;font-wieght:bold;" CLASS="<%=classStyle%>" ID="toolNo">
                        <%=taskToolWbo.getAttribute("toolCode").toString()%>
                    </TD>
                    <TD STYLE="<%=style%>;font-wieght:bold;" CLASS="<%=classStyle%>" ID="tName">
                        <%=taskToolWbo.getAttribute("toolName").toString()%>
                    </TD>
                    <TD STYLE="text-align:center" CLASS="<%=classStyle%>">
                        <textarea name='notes' id='notes' cols='20' rows='2'><%=taskToolWbo.getAttribute("notes").toString()%></textarea>
                    </TD>
                    <TD STYLE="text-align:center" class='<%=classStyle%>'>
                        <input type="checkbox" name="check" id="check">
                        <input type="hidden" name="id" id="id" value="<%=taskToolWbo.getAttribute("toolId").toString()%>">
                    </TD>
                </TR>
                
                <%}%>
                
            </TABLE>
            
        </FORM>
    </BODY>
</HTML>     
