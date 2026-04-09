<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>

<%
String status = (String) request.getAttribute("status");
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
WebBusinessObject docTypeObj = (WebBusinessObject) request.getAttribute("docTypeObj");
docTypeObj.printSelf();


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
    title_1="View Document Type";
    title_2="All information are needed";
    cancel_button_label="Back To List ";
    save_button_label="Save";
    langCode="Ar";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    
    doc_title="&#1573;&#1587;&#1605; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    doc_desc="&#1575;&#1604;&#1608;&#1589;&#1601; ";
    
    title_1="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
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
        <TITLE>New Account</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
     function cancelForm()
        {    
        document.FUNCTION_FORM.action = "<%=context%>//BusinessDocServlet?op=ListDocClass";
        document.FUNCTION_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="FUNCTION_FORM" METHOD="POST">
        
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
               
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
                    
            <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                <TR>
                      <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b><%=doc_title%> </b><font color="#FF0000"></font>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input disabled type="TEXT" STYLE="width:230px" name="docType" ID="Name" size="33" value="<%=docTypeObj.getAttribute("typeName")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b><%=doc_desc%></b><font color="#FF0000"></font>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <DIV class="textview" STYLE="<%=style%>;width:230px">
                            <%=docTypeObj.getAttribute("desc")%>
                        </div>
                        
                    </TD>
                </TR>
                
            </TABLE>
        </FORM>
        </fieldset>
        
    </BODY>
</HTML>     
