<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>

<HTML>
    
    
    <%
    String status = (String) request.getAttribute("status");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    WebBusinessObject wfTaskWbo=new WebBusinessObject();
    wfTaskWbo=(WebBusinessObject)request.getAttribute("wfTaskWbo");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status,Dupname;
    String task_name, task_desc;
    String title_1,title_2;
    String cancel_button_label;
    String save_button_label;
    String fStatus;
    String sStatus;
    String back="";
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        task_name="Task name";
        task_desc="Description";
        
        title_1="Update WorkFlow Task";
        title_2="All information are needed";
        cancel_button_label="Cancel ";
        save_button_label="Save ";
        langCode="Ar";
        sStatus="Work Flow Task Saved Successfully";
        fStatus="Fail To Save This Work Flow Task";
        back="Back To List";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        task_name="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; ";
        task_desc="&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        
        title_1="&#1578;&#1581;&#1583;&#1610;&#1579; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
        langCode="En";
        fStatus="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        sStatus="&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
        back="&#1593;&#1608;&#1583;&#1607;";
    }
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>add new Work Flow Task</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
                <LINK REL="stylesheet" TYPE="text/css" HREF="css/headers.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        
            if (!validateData("req", this.TASK_FORM.wfTaskName, "Please, enter Work Flow Task Name.") || !validateData("minlength=3", this.TASK_FORM.wfTaskName, "Please, enter a valid Work Flow Task Name.")){
                this.TASK_FORM.wfTaskName.focus();
            } else if (!validateData("req", this.TASK_FORM.wfTaskDesc, "Please, enter Work Flow Task Description.")){
                this.TASK_FORM.wfTaskDesc.focus();
            } else{
                document.TASK_FORM.action = "<%=context%>/WFTaskServlet?op=updatewfTask&wfTaskId=<%=wfTaskWbo.getAttribute("id").toString()%>";
                document.TASK_FORM.submit();  
            }
        }
        
         function cancelForm()
        {    
            document.TASK_FORM.action = "main.jsp";
            document.TASK_FORM.submit();  
        }
        
        function backToList(){    
            document.TASK_FORM.action = "<%=context%>/WFTaskServlet?op=lisWFTasks";
            document.TASK_FORM.submit();  
        }
        
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="TASK_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript:  backToList();" class="button"><%=back%></button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                
            </DIV> 
            <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"><%=title_1%></font>
                            <br>
                            <font color="Red" size="4"><%=wfTaskWbo.getAttribute("title").toString()%></font>
                        </td>
                    </tr>
                </table>
            </legend>
            
            <table dir="<%=dir%>" align="<%=align%>"> 
                <%    if(null!=status) {
        if(status.equalsIgnoreCase("ok")){
                %>  
                <tr>
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>                    
                            <td class="td">
                                <font size=4 color="black"><%=sStatus%></font> 
                            </td>                    
                    </tr> </table>
                </tr>
                <%
                }else{%>
                <tr>
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>                    
                            <td class="td">
                                <font size=4 color="red" ><%=fStatus%></font> 
                            </td>                    
                    </tr> </table>
                </tr>
                <%}
                }
                %>
                
            </table>
            <br>
            <table align="<%=align%>" dir=<%=dir%>>
                <TR COLSPAN="2" ALIGN="<%=align%>">
                    <TD STYLE="<%=style%>" class='td'>
                        <FONT color='red' size='+1'><%=title_2%></FONT> 
                    </TD>
                </TR>
            </TABLE>
            <TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Place_Name">
                            <p><b><%=task_name%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input type="TEXT" name="wfTaskName" ID="wfTaskName" size="34" value="<%=wfTaskWbo.getAttribute("title").toString()%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="catDsc">
                            <p><b><%=task_desc%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <TEXTAREA rows="5" name="wfTaskDesc" ID="wfTaskDesc" cols="27"><%=wfTaskWbo.getAttribute("notes").toString()%></TEXTAREA>
                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
