<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <%
    String status = (String) request.getAttribute("Status");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    WebBusinessObject state = (WebBusinessObject) request.getAttribute("state");
    
    
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
        title_1="View equipment status";
        title_2="All information are needed";
        cancel_button_label="Back To List";
        save_button_label="Save ";
        langCode="Ar";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        
        store_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;";
        store_desc="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        
        title_1=" &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1606;&#1608;&#1593; &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
        langCode="En";
    }
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new Employee</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
     function cancelForm()
        {    
        document.STORE_FORM.action = "<%=context%>/EqStateTypeServlet?op=ListStates";
        document.STORE_FORM.submit();  
        }
    </SCRIPT>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="STORE_FORM" METHOD="POST">
            
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
                <br>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    <TR COLSPAN="2" ALIGN="CENTER">
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="storeNo">
                                <p><b><%=store_name%><font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="TEXT" style="width:230px" readonly name="stateName" ID="stateName" size="33" value="<%=state.getAttribute("name").toString()%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="storeName">
                                <p><b><%=store_desc%><font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>"class='td'>
                            <textarea readonly name="note" style="width:230px" ID="note" cols="27" rows="5" ><%=state.getAttribute("note").toString()%></textarea>
                        </TD>
                    </TR>
                </TABLE>
                <br>
            </FIELDSET>
        </FORM>
        
    </BODY>
</HTML>     
