<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <%
    String status = (String) request.getAttribute("Status");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String tool_name, tool_code, crew_typcalDuration, tool_description,Dupname;
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
        
        
        tool_name="Tool Name";
        tool_code="Tool Code";
        tool_description="Tool Description";
        
        title_1="Adding a new Tool";
        title_2="All information are needed";
        cancel_button_label="Cancel ";
        save_button_label="Save ";
        langCode="Ar";
        Dupname = "Name is Duplicated Chane it";
        sStatus="Tool Saved Successfully";
        fStatus="Fail To Save This Tool";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        tool_name="&#1575;&#1587;&#1605; &#1575;&#1604;&#1575;&#1583;&#1575;&#1607;";
        tool_code="&#1603;&#1608;&#1583; &#1575;&#1604;&#1575;&#1583;&#1575;&#1607;";
        tool_description="&#1608;&#1589;&#1601; &#1575;&#1604;&#1575;&#1583;&#1575;&#1607;";
        
        
        title_1="&#1571;&#1583;&#1575;&#1607; &#1582;&#1601;&#1610;&#1601;&#1607; &#1580;&#1583;&#1610;&#1583;&#1607;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
        langCode="En";
        Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
        fStatus="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        sStatus="&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
    }
    String doubleName = (String) request.getAttribute("name");
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
  

    <HEAD>
        <TITLE>Add New Tool</TITLE>

        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <style type="text/css">
            #toolsData{
                border: 3px ridge #777788 ;
                background:#E8E8E8;
                -moz-border-radius: 15px; 
                -webkit-border-radius: 15px; 
                border-radius: 20px;
           }
        </style>

    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {
            if (!validateData("req", this.TOOL_FORM.toolName, "Please, enter Tool Name.") || !validateData("minlength=3", this.TOOL_FORM.toolName, "Please, enter a valid Tool Name.")){
                this.TOOL_FORM.toolName.focus();
            } else if (!validateData("req", this.TOOL_FORM.toolCode, "Please, enter Tool Code.") || !validateData("minlength=3", this.TOOL_FORM.toolCode, "Please, enter a valid Tool Code at least 3 charachetrs.")){
                this.TOOL_FORM.toolCode.focus();
            } else if (!validateData("req", this.TOOL_FORM.toolNotes, "Please, enter Tool Description.")){
                this.TOOL_FORM.toolNotes.focus();
            } else{
                document.TOOL_FORM.action = "<%=context%>/TaskServlet?op=saveTools";
                document.TOOL_FORM.submit();  
            }
        }
       
        
        
    
     function cancelForm()
        {    
        document.TOOL_FORM.action = "main.jsp";
        document.TOOL_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="TOOL_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 
            <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">    <%=title_1%>                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            
            <%
            if(null!=doubleName) {
            
            %>
            
            <table dir="<%=dir%>" align="<%=align%>">
                <tr>
                    <td class="td">
                        <font size=4 > <%=Dupname%> </font> 
                    </td>
                    
            </tr> </table>
            <%
            
            }
            
            %>
            
            <%
            if(null!=status) {
        
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
            
            <TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR COLSPAN="2" ALIGN="<%=align%>">
                    <TD STYLE="<%=style%>" class='td'>
                        <FONT color='red' size='+1'><%=title_2%></FONT> 
                    </TD>
                    
                </TR>
            </TABLE>
            <br><br>
            <TABLE id="toolsData"dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="6" BORDER="0">
                      
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="toolName">
                            <p><b><%=tool_name%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"class='td'>
                        <input type="TEXT" style="width:230px" name="toolName" ID="toolName" size="33" value="" maxlength="255">
                    </TD>
                </TR>

                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="toolCode">
                            <p><b><%=tool_code%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"class='td'>
                        <input type="TEXT" style="width:230px" name="toolCode" ID="toolCode" size="33" value="" maxlength="255">
                    </TD>
                </TR>                
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="toolNotes">
                            <p><b><%=tool_description%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <TEXTAREA type="TEXT" style="width:230px" name="toolNotes" ID="toolNotes" ROWS="4" COLS="25" size="33" value="" maxlength="255"></textarea>
                    </TD>
                </TR>
            </TABLE>
            <br>
        </FORM>
    </BODY>
</HTML>     
