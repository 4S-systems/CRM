<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>


    <%
    
    String status = (String) request.getAttribute("Status");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
   
    
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>DebugTracker-add new Operation Category</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        { 
      
       
        document.ITEM_FORM.action = "<%=context%>/OperationCatServlet?op=SaveOperation";
        document.ITEM_FORM.submit();  
        }
      
        
       function checkEmail(email) {
        if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){
            return (true)
        }
            return (false)
    }
       
        function IsNumeric(sText)
    {
        var ValidChars = "0123456789.";
        var IsNumber=true;
        var Char;

 
        for (i = 0; i < sText.length && IsNumber == true; i++) 
        { 
            Char = sText.charAt(i); 
            if (ValidChars.indexOf(Char) == -1) 
            {
                IsNumber = false;
            }
        }
        return IsNumber;

    }
    
    function clearValue(no){
        document.getElementById('Quantity' + no).value = '0';
        total();
    }
    </SCRIPT>
   
    <BODY>
        <left>
        <FORM NAME="ITEM_FORM" METHOD="POST">
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="left-WIDTH: 1;text-align:left;">
                        Add New Operation Category
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                        <A HREF="main.jsp">
                            <%=tGuide.getMessage("cancel")%>
                        </A>
                        <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif">
                        <IMG VALIGN="BOTTOM" HEIGHT="15" WIDTH="1" SRC="images/line.gif">
                        <IMG SRC="images/save.gif">                        
                        <A HREF="JavaScript: submitForm();">
                            Save Operation
                        </A>
                    </TD>
                </TR>
            </TABLE>
            <%    if(null!=status)
     {

            %>

            <table> 
                <tr><td>
                </td></tr>
                <tr><td  align=center>  <H4> Operation Category Save Status : <%=status%></td></tr></H4>
            </table>
            <%
            }
            %>
            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>
                <TR COLSPAN="2" ALIGN="CENTER">
                    <TD class='td'>
                        <FONT color='red' size='+1'><%=tGuide.getMessage("allfieldsrequired")%></FONT> 
                    </TD>
                </TR>
                   <!--
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Place_Name">
                            <p><b>Category Name <font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="categoryName" ID="categoryName" size="33" value="" maxlength="255">
                    </TD>
                </TR>
                -->
                <TR>
                    <TD class='td'>
                        <LABEL FOR="catCode">
                            <p><b>Category Code:<font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="catCode" ID="catCode" size="33" value="" maxlength="255">
                    </TD>
                </TR>
                <TR>
                    <TD class='td'>
                        <LABEL FOR="catName">
                            <p><b>Category Name:<font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="catName" ID="catName" size="33" value="" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                    <TD class='td'>
                        <LABEL FOR="relatedTo">
                            <p><b>relatedTo :<font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input type="TEXT" name="relatedTo" ID="relatedTo" size="33" value="" maxlength="255">
                    </TD>
                </TR>
                    
                <TR>
                    <TD class='td'>
                        <LABEL FOR="Note">
                            <p><b>Note:<font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <TEXTAREA type="TEXT" name="Note" ID="Note" size="33" value="" maxlength="255"></textarea>
                    </TD>
                    
                </TR>
               
                
                
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
                    