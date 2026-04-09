<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String msg=(String) request.getAttribute("message");
String context = metaMgr.getContext();
TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
WebBusinessObject docTypeObj = (WebBusinessObject) request.getAttribute("docTypeObj");

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
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    doc_title="Document type name";
    doc_desc="Description";
    title_1="Update document type";
    title_2="All information are needed";
    cancel_button_label="Back To List ";
    save_button_label="Save ";
    langCode="Ar";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    
    doc_title="&#1573;&#1587;&#1605; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    doc_desc="&#1575;&#1604;&#1608;&#1589;&#1601; ";
    
    title_1="&#1578;&#1581;&#1583;&#1610;&#1579; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label="&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
    langCode="En";
}
%>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Edit Document Type</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

   function submitForm()
   {
   
    if (!validateData("req", this.FUNCTION_FORM.Name, "Please, enter Document Type Name.") || !validateData("minlength=3", this.FUNCTION_FORM.Name, "Please, enter a valid Document Type Name.")){
        this.FUNCTION_FORM.Name.focus();
    } else if (!validateData("req", this.FUNCTION_FORM.docDesc, "Please, enter Document Type Description.")){
        this.FUNCTION_FORM.docDesc.focus();
    } else{
      document.FUNCTION_FORM.action = "<%=context%>/BusinessDocServlet?op=Submit";
      document.FUNCTION_FORM.submit();  
   }
   }
     function cancelForm()
        {    
        document.FUNCTION_FORM.action = "<%=context%>/BusinessDocServlet?op=ListDocClass";
        document.FUNCTION_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    <BODY BACKGROUND="images/fold.jpg" style="background-repeat: no-repeat;background-position: center">
        
        <FORM NAME="FUNCTION_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
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
            if(null!=msg) {
            
            %>
            
            
            <table align="<%=align%>" dir=<%=dir%>>
                <tr>
                    
                    <td class="td">
                        <font size=4 color="red"><%=saving_status%>: <%=tGuide.getMessage("updateok")%></font> 
                    </td>
                    
            </tr> </table>
            
            <%
            
            }
            
            %>
            
             <table align="<%=align%>" dir=<%=dir%>>
                <tr>
                    
                    <td class="td">
                        <font size=4 color="red"><%=title_2%></font> 
                    </td>
                    
            </tr> </table>
            
            <br>
            <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b><%=doc_title%> </b><font color="#FF0000">*</font>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input type="TEXT" name="docType" STYLE="width:230px" ID="Name" size="33" value="<%=docTypeObj.getAttribute("typeName")%>" maxlength="255">
                        <input type="HIDDEN" name="docTypeID" ID="docTypeID" size="33" value="<%=docTypeObj.getAttribute("typeID")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>"class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b><%=doc_desc%></b><font color="#FF0000">*</font>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <TEXTAREA size="33" rows="5" STYLE="width:230px" name="docDesc" ID="docDesc"><%=docTypeObj.getAttribute("desc")%> </TEXTAREA>
                        
                    </TD>
                </TR>
                
            </TABLE>
        </FORM>
        </fieldset>
        
    </BODY>
</HTML>     
