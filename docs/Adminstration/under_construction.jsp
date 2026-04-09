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
    
    String saving_status,sWaiting,title_1;
    String cancel_button_label;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        sWaiting="This Operation Under Construction";
        title_1="Under Construction";
        cancel_button_label="Ok";
        langCode="Ar";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        title_1="&#1578;&#1581;&#1578; &#1575;&#1604;&#1573;&#1606;&#1588;&#1575;&#1569;";
        cancel_button_label="&#1605;&#1608;&#1575;&#1601;&#1602;";
        langCode="En";
        sWaiting="&#1607;&#1584;&#1607; &#1575;&#1604;&#1582;&#1575;&#1589;&#1610;&#1577; &#1578;&#1581;&#1578; &#1575;&#1604;&#1573;&#1606;&#1588;&#1575;&#1569;";
    }
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE></TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <script language="javascript" type='text/javascript'>
           function cancelForm()
        {    
        document.ITEM_FORM.action = "<%=context%>/main.jsp";
        document.ITEM_FORM.submit();  
        }
    </script>
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    <BODY>
        
        <FORM NAME="ITEM_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm()" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                
            </DIV> 
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="<%=align%>">
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6"><%=title_1%>                
                                </font>
                                
                            </td>
                        </tr>
                    </table>
                </legend>
                <br>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                
                <table align="<%=align%>" dir="<%=dir%>" ><tr><td style="<%=style%>"class="td">
                            <b><FONT COLOR="red" SIZE="4"> <%=sWaiting%></font></b>
                </td></tr></table>
                <br>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
