<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.tracker.common.AppConstants"%>

<HTML>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    // tGuide = new TouristGuide("/com/docviewer/international/DocOnlineMenu");
    
    String context= metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String store_number, store_name, store_location, store_manager, store_phone,CDS;
    String title_1,title_2;
    String cancel_button_label;
    String save_button_label,FI;
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        store_number="Store number";
        store_name="Store name";
        store_location="Store location";
        store_manager="Responsible manager";
        store_phone="Phone";
        
        
        title_1="Can't Delete";
        title_2="All information are needed";
        cancel_button_label="Back To List ";
        save_button_label="Delete ";
        langCode="Ar";
        CDS="Can't Delete Store ";
        FI="This Store Contains Spare parts";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        store_number="&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
        store_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
        store_location="&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        store_manager="&#1575;&#1604;&#1605;&#1583;&#1610;&#1585; &#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;";
        store_phone="&#1578;&#1604;&#1610;&#1601;&#1608;&#1606;";
        
        
        title_1="&#1604;&#1575;&#1610;&#1605;&#1603;&#1606; &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606; ";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        save_button_label="&#1573;&#1581;&#1584;&#1601; ";
        langCode="En";
        CDS="&#1604;&#1575;&#1610;&#1605;&#1603;&#1606; &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
        FI="&#1607;&#1584;&#1575; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606; &#1605;&#1608;&#1580;&#1608;&#1583; &#1576;&#1607; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Tracker- Privacy  Viloation</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
       function cancelForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/<%=(String)request.getAttribute("servlet")%>?op=<%=(String)request.getAttribute("list")%>";
        document.ISSUE_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    <BODY>
        
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
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
            
            <table align="<%=align%>" dir="<%=dir%>"><tr><td class="td" style="<%=style%>"> 
                        <B><FONT SIZE="4" color="red">  <%=CDS%>  '<%=(String)request.getAttribute("name")%>'</font></B>
                        <BR><BR>
                        <B>  <FONT SIZE="4"> <%=FI%></B>
            </td></tr></table>
        </FORM>
        </fieldset>
     
    </BODY>
</HTML>     
