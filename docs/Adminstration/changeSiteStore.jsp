<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.maintenance.common.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <%
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    /************* Get Request Data ***************/
    
    String noStore=(String)request.getAttribute("noStore");
    
    Store defultStore=(Store)request.getAttribute("defultStore");
    Vector storesVec=(Vector)request.getAttribute("stores");
    String projectId=(String)request.getAttribute("projectId");
    ProjectMgr projectMgr=ProjectMgr.getInstance();
    WebBusinessObject siteWbo=projectMgr.getOnSingleKey(projectId);
    
    String status = (String) request.getAttribute("Status");
    
    /************* End Of request Data ************/
    WebBusinessObject userWbo=(WebBusinessObject)session.getAttribute("loggedUser");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String siteName,storeName,success,fail,noStores;
    String title_1,title_2;
    String cancel_button_label;
    String save_button_label;
    String fStatus;
    String sStatus;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        success="Store Change Successfully";
        fail="Fail To Change Store";
        storeName="Store Name";
        siteName="Site Name";
        noStores="This Option For Multi Site and Multi Stores Companies";
        
        title_1="Change Current Store";
        title_2="Current Store Id ";
        cancel_button_label="Cancel ";
        save_button_label="Save ";
        langCode="Ar";
        
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        siteName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        storeName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        success="&#1578;&#1605; &#1578;&#1594;&#1610;&#1610;&#1585; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606; &#1576;&#1606;&#1580;&#1575;&#1581;";
        fail="&#1604;&#1605; &#1610;&#1578;&#1605; &#1578;&#1594;&#1610;&#1610;&#1585; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606;";
        noStores="&#1607;&#1584;&#1607; &#1575;&#1604;&#1582;&#1575;&#1589;&#1610;&#1607; &#1604;&#1604;&#1588;&#1585;&#1603;&#1575;&#1578; &#1584;&#1575;&#1578; &#1575;&#1604;&#1605;&#1608;&#1575;&#1602;&#1593; &#1608;&#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606; &#1575;&#1604;&#1605;&#1578;&#1593;&#1583;&#1583;&#1607;";
        
        title_1="&#1578;&#1594;&#1610;&#1610;&#1585; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606; &#1575;&#1604;&#1581;&#1575;&#1604;&#1609;";
        title_2="&#1575;&#1604;&#1605;&#1582;&#1586;&#1606; &#1575;&#1604;&#1581;&#1575;&#1604;&#1609; &#1607;&#1608;";
        
        cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
        langCode="En";
    }
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Change Current Store</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {
            document.SITE_STORE_FORM.action = "<%=context%>/StoreServlet?op=changeSiteStore";
            document.SITE_STORE_FORM.submit();  
        }
       
    function cancelForm()
        {    
        document.SITE_STORE_FORM.action = "main.jsp";
        document.SITE_STORE_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="SITE_STORE_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <%if(noStore.equalsIgnoreCase("no")){%>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                <%}%>
            </DIV> 
            <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">    <%=title_1%>                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            
            <%if(noStore.equalsIgnoreCase("no")){%>
            
            <%
            if(null!=status) {
                
                if(status.equalsIgnoreCase("ok")){
            %>  
            <tr>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="black"><%=success%></font> 
                        </td>                    
                </tr> </table>
            </tr>
            <%
                }else{%>
            <tr>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="red" ><%=fail%></font> 
                        </td>                    
                </tr> </table>
            </tr>
            <%}
            }
            
            %>
            
            <TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR COLSPAN="2" ALIGN="<%=align%>">
                    <TD STYLE="<%=style%>" class='td'>
                        <FONT color='blue' size='+2'><%=title_2%></FONT><FONT color='red' size='+2'><%=defultStore.name%></FONT> 
                    </TD>
                    
                </TR>
            </TABLE>
            <br><br>
            <TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="crewName">
                            <p><b><%=siteName%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"class='td'>
                        <input type="TEXT" style="width:230px" name="siteName" readonly ID="siteName" size="25" value="<%=(String)siteWbo.getAttribute("projectName")%>" maxlength="255">
                        <input type="hidden" name="projectId" ID="projectId" value="<%=projectId%>">
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <p><b><%=storeName%></b>&nbsp;
                    </TD>
                    <TD STYLE="<%=style%>"class='td'>
                        <select name="storeId" id="storeId" style="width:230">
                            <%
                            Store store;
                            for(int i=0;i<storesVec.size();i++){
                                store=(Store)storesVec.get(i);
                                if(store.id.equalsIgnoreCase(defultStore.id)){%>
                            <option value="<%=store.id%>!#<%=store.name%>" selected><%=store.name%>
                                                                   <%}else{%>
                                                                   <option value="<%=store.id%>!#<%=store.name%>"><%=store.name%>
                            <%}
                            }%>
                        </select>
                    </TD>
                </TR>
                
            </TABLE>
            <br>
            <%}else{%>
            <TABLE dir="<%=dir%>" align="CENTER" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR ALIGN="CENTER">
                    <TD STYLE="<%=style%>" class='td'>
                        <FONT color='red' size='+3'><%=noStores%></FONT> 
                    </TD>
                </TR>
            </TABLE>
            <%}%>
        </FORM>
    </BODY>
</HTML>     
