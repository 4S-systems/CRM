<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.international.TouristGuide"%>

<%
String status = (String) request.getAttribute("status");
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
TouristGuide tGuideNo = new TouristGuide("/com/tracker/international/BasicOps");


String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String saving_status;
String doc_title, doc_desc;
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
    doc_title="Document type name";
    doc_desc="Description";
    title_1="New document type";
    title_2="All information are needed";
    cancel_button_label="Cancel ";
    save_button_label="Save ";
    langCode="Ar";
    sStatus="Document Type Saved Successfully";
    fStatus="Fail To Save Document Type This Name Already Exist";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    
    doc_title="&#1573;&#1587;&#1605; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    doc_desc="&#1575;&#1604;&#1608;&#1589;&#1601; ";
    
    title_1="&#1606;&#1608;&#1593; &#1605;&#1587;&#1578;&#1606;&#1583; &#1580;&#1583;&#1610;&#1583;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
    save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
    langCode="En";
    fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1575;&#1604;&#1575;&#1587;&#1600;&#1605; &#1605;&#1600;&#1608;&#1580;&#1600;&#1608;&#1583; &#1605;&#1600;&#1606; &#1602;&#1600;&#1576;&#1600;&#1604;";
    sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
}

%>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>New Account</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

   function submitForm()
   {    
   
   if (!validateData("req", this.FUNCTION_FORM.Name, "Please, enter Document Type Name.") || !validateData("minlength=3", this.FUNCTION_FORM.Name, "Please, enter a valid Document Type Name.")){
        this.FUNCTION_FORM.Name.focus();
    } else if (!validateData("req", this.FUNCTION_FORM.desc, "Please, enter Document Type Description.")){
        this.FUNCTION_FORM.desc.focus();
    } else{
      document.FUNCTION_FORM.action = "<%=context%>/BusinessDocServlet?op=SaveClass";
      document.FUNCTION_FORM.submit();  
   }
   }
   
   function cancelForm()
        {    
        document.FUNCTION_FORM.action = "main.jsp";
        document.FUNCTION_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY BACKGROUND="images/fold.jpg" style="background-repeat: no-repeat;background-position: center">
        
        <FORM  NAME="FUNCTION_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 
            <fieldset class="set" align="center">
            <legend align="center">
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">    <%=title_1%>                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            
            <%
            if(null!=status) {
    if(status.equalsIgnoreCase("ok")){
            %>            
            <table align="<%=align%>" dir=<%=dir%>>
                <tr>                    
                    <td class="td">
                        <font size=4 color="black"><%=sStatus%></font> 
                    </td>                    
            </tr> </table>
            <%
            }else{%>
            
            <table align="<%=align%>" dir=<%=dir%>>
                <tr>                    
                    <td class="td">
                        <font size=4 color="red" ><%=fStatus%></font> 
                    </td>                    
            </tr> </table>
            <%}
            }
            
            %>
            <table align="<%=align%>" dir=<%=dir%>>
                <TR COLSPAN="2" ALIGN="<%=align%>">
                    <TD STYLE="<%=style%>" class='td'>
                        <FONT color='red' size='+1'><%=title_2%></FONT> 
                    </TD>
                    
                </TR>
            </table>
            <br><br>
            
            <TABLE align="<%=align%>" dir=<%=dir%> CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b><%=doc_title%> </b><font color="#FF0000">*</font>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input type="TEXT" style="width:230px" name="docType" ID="Name" size="32" value="" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>"class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b><%=doc_desc%></b><font color="#FF0000">*</font>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>:" class='td'>
                        <TEXTAREA rows="5" style="width:230px" name="desc" ID="desc" cols="26"></TEXTAREA>
                    </TD>
                </TR>
                
            </TABLE>
        </FORM>
        
        
    </BODY>
</HTML>     
