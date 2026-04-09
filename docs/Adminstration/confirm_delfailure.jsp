<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    String failureId = (String) request.getAttribute("failureId");
    String failureTitle = (String) request.getAttribute("failureTitle");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    FailureCodeMgr failureCodeMgr=FailureCodeMgr.getInstance();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String failure_title, failre_desc;
    String title_1,title_2;
    String cancel_button_label;
    String save_button_label;
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        failure_title="Title";
        failre_desc="Description";
        title_1="Delete Failure Code - Are You Sure?";
        title_2="All information are needed";
        cancel_button_label="Back To List ";
        save_button_label="Delete ";
        langCode="Ar";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        failure_title="&#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
        failre_desc="&#1575;&#1604;&#1608;&#1589;&#1601; ";
        
        title_1="&#1581;&#1584;&#1601; &#1603;&#1608;&#1583; &#1575;&#1604;&#1593;&#1591;&#1604; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
        save_button_label="&#1573;&#1581;&#1584;&#1601;";
        langCode="En";
    }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - Confirm Deletion</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

   function submitForm()
   {    
      document.TECH_DEL_FORM.action = "<%=context%>/FailureCodeServlet?op=Delete&failureId=<%=failureId%>&failureTitle=<%=failureTitle%>";
      document.TECH_DEL_FORM.submit();  
   }
   
     function cancelForm()
        {    
        document.TECH_DEL_FORM.action = "<%=context%>//FailureCodeServlet?op=ListFailureCode";
        document.TECH_DEL_FORM.submit();  
        }
  
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    <BODY>
        <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/del.gif"></button>
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
            
            <FORM NAME="TECH_DEL_FORM" METHOD="POST">
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=failure_title%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>"class='td'>
                            <input disabled type="TEXT" name="title" value="<%=failureTitle%>" ID="<%=failureTitle%>" size="33"  maxlength="50">
                        </TD>
                    </TR>
                    
                    <input  type="HIDDEN" name="failureId" value="<%=failureId%>">
                    
                </TABLE>
            </FORM>
            <br>
        </FIELDSET>
    </BODY>
</HTML>     
