<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    String stateID = (String) request.getAttribute("stateID");
    String stateName = (String) request.getAttribute("stateName");
    
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
    String store_name, store_desc;
    String title_1,title_2;
    String cancel_button_label;
    String save_button_label;
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        store_name="Equiment state name";
        store_desc="Description";
        title_1="Delete Equipment State - Are You Sure ?";
        title_2="All information are needed";
        cancel_button_label="Cancel ";
        save_button_label="Delete ";
        langCode="Ar";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        
        store_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;";
        store_desc="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        
        title_1="   &#1581;&#1584;&#1601; &#1606;&#1608;&#1593; &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
        save_button_label="  &#1573;&#1581;&#1584;&#1601;";
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
      document.STATE_DEL_FORM.action = "<%=context%>/EqStateTypeServlet?op=DeleteState&stateID=<%=stateID%>&stateName=<%=stateName%>";
      document.STATE_DEL_FORM.submit();  
   }

  function cancelForm()
        {    
        document.STATE_DEL_FORM.action = "<%=context%>/EqStateTypeServlet?op=ListStates";
        document.STATE_DEL_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    <BODY>
        <FORM NAME="STATE_DEL_FORM" METHOD="POST">
            
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/del.gif"></button>
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
                <br>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="storeNo">
                                <p><b><%=store_name%><font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>"class='td'>
                            <input disabled type="TEXT" name="stateName" value="<%=stateName%>" ID="<%=stateName%>" size="33"  maxlength="50">
                        </TD>
                    </TR>
                    
                    <input  type="HIDDEN" name="stateID" value="<%=stateID%>">
                    
                </TABLE>
                <br>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
