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
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        task_name="Task name";
        task_desc="Description";
        
        title_1="View WorkFlow Task";
        cancel_button_label="Cancel ";
        save_button_label="Back To List";
        langCode="Ar";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        task_name="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; ";
        task_desc="&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        
        title_1="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
        save_button_label="&#1593;&#1608;&#1583;&#1607; ";
        langCode="En";
    }
    String doubleName = (String) request.getAttribute("name");
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
            document.TASK_FORM.action = "<%=context%>/WFTaskServlet?op=lisWFTasks";
            document.TASK_FORM.submit();  
        }
        
         function cancelForm()
        {    
            document.TASK_FORM.action = "main.jsp";
            document.TASK_FORM.submit();  
        }
            
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="TASK_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%></button>
            </DIV> 
            <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"><%=title_1%></font>
                            <br>
                            <font color="red" size="4"><%=wfTaskWbo.getAttribute("title").toString()%></font>
                        </td>
                    </tr>
                </table>
            </legend>
           <br>
            <TABLE dir="<%=dir%>" WIDTH="400" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                <TR>
                    <TD STYLE="<%=style%>;padding-right:20;height:35;" class='bar' WIDTH="30%">
                            <%=task_name%>
                    </TD>
                    <TD STYLE="<%=style%>;padding-right:15;" class='tRow2'  WIDTH="70%">
                        <b><%=wfTaskWbo.getAttribute("title").toString()%></b>
                    </TD>
                </TR>
                
                <TR>
                     <TD STYLE="<%=style%>;padding-right:20;height:35;" class='bar'  WIDTH="30%">
                            <%=task_desc%>
                    </TD>
                    <TD STYLE="<%=style%>;padding-right:15;" class='tRow2'  WIDTH="70%">
                        <b><%=wfTaskWbo.getAttribute("notes").toString()%></b>
                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
