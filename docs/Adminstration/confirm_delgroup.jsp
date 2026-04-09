<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    WebBusinessObject group = (WebBusinessObject) request.getAttribute("group");
    
    String groupName = null;
    if(null!=group) {
        groupName = (String) group.getAttribute("groupName");
    }
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String sTitle,title_2;
    String sGroupName,sGroupDesc;
    String cancel_button_label;
    String save_button_label, sPadding, sMenu, sSelect;
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        sGroupName="Group Name";
        sGroupDesc="Group Description";
        sTitle="Delete Group - Are You Sure?";
        title_2="All information are needed";
        cancel_button_label="Back to List";
        save_button_label="Delete";
        langCode="Ar";
        sPadding = "left";
        sMenu = "Menu";
        sSelect = "Select";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        
        
        sGroupName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
        sGroupDesc="&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
        sTitle="&#1581;&#1584;&#1601; &#1605;&#1580;&#1605;&#1608;&#1593;&#1577; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
        save_button_label="&#1573;&#1581;&#1584;&#1601;";
        langCode="En";
        sPadding = "right";
        sMenu = "&#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
        sSelect = "&#1575;&#1582;&#1578;&#1575;&#1585;";
    }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - Delete Group</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script src='ChangeLang.js' type='text/javascript'></script>
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

   function submitForm()
   {    
      document.ISSUE_FORM.action = "<%=context%>/GroupServlet?op=Delete&groupName=<%=groupName%>";
      document.ISSUE_FORM.submit();  
   }
   
   function cancelForm()
   {    
       document.ISSUE_FORM.action = "<%=context%>/GroupServlet?op=ListAll";
       document.ISSUE_FORM.submit();  
   }

    </SCRIPT>
    
    <BODY>
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/del.gif"></button>
            </DIV>
            <fieldset class="set" align="center">
                <legend align="center">
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6">    <%=sTitle%>                
                                </font>
                                
                            </td>
                        </tr>
                    </table>
                </legend>
                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    
                </table>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="ISSUE_TITLE">
                                <p><b><%=sGroupName%><font color="#FF0000"> </font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <input disabled type="TEXT" name="groupName" value="<%=groupName%>" ID="<%=groupName%>" size="33"  maxlength="50">
                        </TD>
                    </TR>
                    <input  type="HIDDEN" name="groupID" value="<%=(String) group.getAttribute("groupID")%>">
                </TABLE>
                <BR><BR>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
