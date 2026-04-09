<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.DistributedItemsMgr,com.silkworm.db_access.*"%>
<%@ page import="com.maintenance.db_access.ActiveStoreMgr,com.maintenance.db_access.BranchErpMgr,com.maintenance.db_access.ItemFormMgr,com.maintenance.db_access.StoresErpMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>User Data</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/blueStyle.css"/>  
    </HEAD>

    <style type="text/css">
        .tableBorder {
            border-style:solid;
            border-width:5px;
            border-color:#E8E8E8;
            background-color:#E8E8E8;
        }

    </style>


    <%
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
    WebBusinessObject managerWbo = (WebBusinessObject) request.getAttribute("managerWbo");
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String lang,langCode,PL,sCancel;
    String sUsername,sGroupName,sBranchName,sStoreName,setupStoreNote;
    String sEmail,sManagerName,sTrade,sSearchType,sSelectAll,sGrantUser,sNoGrants, noAssignedUserStores,style,sUserEnterName;
    if(stat.equals("En")){
        style = "Left";
        align="center";
        dir="LTR";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        PL="User Data";
        sCancel="Cancel";
        sUsername ="User name";
        sGroupName ="Managerial Group";
        sBranchName="Branches";
        sStoreName="Stores";
        setupStoreNote = "Should be prepared store for the program";
        sEmail = "Email Address";
        sManagerName = "Manager";
        sTrade="Technical managment";
        sSearchType="Search by";
        sSelectAll = "All";
        sGrantUser = "Grants user";
        sNoGrants ="User has not grants";
        noAssignedUserStores = "No stores were assigned to this user";
        sUserEnterName="Enter Name";
    }else{
        style = "Right";
        align="center";
        dir="RTL";
        lang="English";
        langCode="En";
        PL="&#1593;&#1585;&#1590; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
        sCancel = tGuide.getMessage("cancel");
        sUsername ="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
        sGroupName ="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1610;&#1577;";
        sBranchName="الفروع";
        sStoreName="&#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
        setupStoreNote="&#1610;&#1580;&#1576; &#1573;&#1593;&#1583;&#1575;&#1583; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606; &#1604;&#1604;&#1576;&#1585;&#1606;&#1575;&#1605;&#1580;";
        sEmail = "&#1575;&#1604;&#1576;&#1585;&#1610;&#1583; &#1575;&#1604;&#1573;&#1604;&#1603;&#1578;&#1585;&#1608;&#1606;&#1610;";
        sManagerName = "المدير";
        sTrade ="&#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
        sSearchType= "&#1575;&#1604;&#1576;&#1581;&#1579; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;";
        sSelectAll ="&#1575;&#1604;&#1603;&#1604;";
        sGrantUser = "&#1589;&#1604;&#1575;&#1581;&#1610;&#1575;&#1578; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
        sNoGrants ="&#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605; &#1604;&#1610;&#1587; &#1604;&#1583;&#1610;&#1607; &#1589;&#1604;&#1575;&#1581;&#1610;&#1575;&#1578;";
        noAssignedUserStores = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1578;&#1593;&#1610;&#1610;&#1606; &#1605;&#1582;&#1575;&#1586;&#1606; &#1604;&#1607;&#1584;&#1575; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
        sUserEnterName ="&#1575;&#1587;&#1605; &#1575;&#1604;&#1583;&#1582;&#1608;&#1604;";

        }
    
    // for main branch
    BranchErpMgr branchErpMgr= BranchErpMgr.getInstance();
    WebBusinessObject branchDataWbo = new WebBusinessObject();
    branchDataWbo = branchErpMgr.getOnSingleKey("00");

    String userStoresStr = (String) request.getAttribute("userStoresStr");
    StringTokenizer userStores = new StringTokenizer(userStoresStr, "\n");
    int userStoresCount = userStores.countTokens();
    
    String userProjectsStr = (String) request.getAttribute("userProjectsStr");
    StringTokenizer userProjects = new StringTokenizer(userProjectsStr, "\n");
    int userProjectsCount = userProjects.countTokens();

    List filterList=(ArrayList) request.getAttribute("filterList");
    GrantsMgr grantsMgr = GrantsMgr.getInstance();
    WebBusinessObject grantWbo = new WebBusinessObject();
    ArrayList grants = (ArrayList)securityUser.getUserAction();
    %>
    
    <script language="javascript" type="text/javascript">
        function reloadAE(nextMode){
      
       var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
            if (window.XMLHttpRequest)
            { 
                req = new XMLHttpRequest(); 
            } 
               else if (window.ActiveXObject)
            { 
                req = new ActiveXObject("Microsoft.XMLHTTP"); 
            } 
            req.open("Post",url,true); 
            req.onreadystatechange =  callbackFillreload;
            req.send(null);
      
      }

       function callbackFillreload(){
         if (req.readyState==4)
            { 
               if (req.status == 200)
                { 
                     window.location.reload();
                }
            }
       }
       
           function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
        
            function cancelForm()
        {    
            document.part_form.action = "<%=context%>/ReportsServlet?op=searchItems";
            document.part_form.submit();  
        }
    
       
          
    </script>
    
    <body>
        <FORM action=""  NAME="part_form" METHOD="POST">
            <DIV align="left" STYLE="color:blue;padding-left: 2.5%">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button  onclick="JavaScript: window.close();" class="button"><%=sCancel%></button>
            </DIV>
            <br>
            <center>
                <FIELDSET class="set" style="width:95%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=PL%></font></TD>
                        </TR>
                    </TABLE>
                    <br>
                    <table dir="<%=dir%>" class="tableBorder td" CELLPADDING="0" CELLSPACING="5" BORDER="0" ALIGN="CENTER" width="93%">

                        <TR>
                             <TD class="blueBorder blueHeaderTD" style="<%=style%>">
                                <LABEL FOR="str_Function_Name">
                                    <p><b><%= sUserEnterName%>:</b>&nbsp;
                                </LABEL>
                            </TD>
                                 <% if(securityUser.getFullName() != null && !securityUser.getFullName().equals("")) { %>
                             <TD class='td' STYLE="<%=style%>">
                                <input style="width: 100%;color: black;font-weight: bold" readonly type="TEXT" name="userName" ID="userName" size="33" value="<%=securityUser.getFullName()%>" maxlength="255">
                            </TD>
                              <%
                                   } else {
                                %>
                                  <TD class='td' STYLE="<%=style%>">
                                <input style="width: 100%;color: black;font-weight: bold" readonly type="TEXT" name="userName" ID="userName" size="33" value="-----" maxlength="255">
                            </TD>
                             <%
                                   }  
                                %>

                        </TR>
                        <TR>
                            <TD class="blueBorder blueHeaderTD" style="<%=style%>">
                                <LABEL FOR="str_Function_Name">
                                    <p><b><%= sUsername%>:</b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD class='td' STYLE="<%=style%>">
                                <input style="width: 100%;color: black;font-weight: bold" readonly type="TEXT" name="userName" ID="userName" size="33" value="<%=securityUser.getUserName()%>" maxlength="255">
                            </TD>
                        </TR>

                        <TR>
                            <TD class="blueBorder blueHeaderTD" style="<%=style%>">
                                <LABEL FOR="str_Function_Name">
                                    <p><b><%=sGroupName%>:</b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD class='td' STYLE="<%=style%>">
                                <input style="width: 100%;color: black;font-weight: bold" readonly type="TEXT" name="groupName" ID="groupName" size="33" value="<%=securityUser.getUserGroupName()%>" maxlength="255">
                            </TD>
                        </TR>

                        <TR>
                                <TD class='blueBorder blueHeaderTD' style="<%=style%>">
                                    <LABEL FOR="str_Function_Name">
                                        <p><b><%=sEmail%>:</b>&nbsp;
                                    </LABEL>
                                </TD>

                                <% if(securityUser.getUserMail() != null && !securityUser.getUserMail().equals("")) { %>

                                <TD class='td' STYLE="<%=style%>">
                                    <input style="width: 100%;color: black;font-weight: bold" readonly type="TEXT" name="email" ID="email" value="<%=securityUser.getUserMail()%>" maxlength="255">
                                </TD>
                                <%
                                   } else {
                                %>
                                 <TD class='td' STYLE="<%=style%>">
                                    <input disabled style="width: 100%;color: black;font-weight: bold" type="TEXT" name="email" ID="email" size="33" maxlength="255">
                                </TD>
                                <%
                                   }
                                %>
                            </TR>
                            <%
                                if (managerWbo != null && managerWbo.getAttribute("fullName") != null) {
                            %>
                            <TR>
                                <TD class="blueBorder blueHeaderTD" style="<%=style%>">
                                    <LABEL FOR="str_Function_Name">
                                        <p><b><%=sManagerName%>:</b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD class='td' STYLE="<%=style%>">
                                    <input style="width: 100%;color: black;font-weight: bold" readonly type="TEXT" name="managerName" ID="managerName" size="33" value="<%=managerWbo.getAttribute("fullName")%>" maxlength="255">
                                </TD>
                            </TR>
                            <%
                                }
                            %>
                            <%--
                            <%
                            ProjectMgr projectMgr = ProjectMgr.getInstance();
                            String getUserSiteId = securityUser.getSiteId();
                            WebBusinessObject getUserSiteInfo = projectMgr.getOnSingleKey(getUserSiteId);
                            WebBusinessObject getMainSite = new WebBusinessObject();
                            if(getUserSiteInfo.getAttribute("mainProjId").equals("0")){
                            %>
                            <TD class='td' STYLE="<%=style%>">
                                <input style="width: 100%;color: black;font-weight: bold" readonly type="TEXT" name="site" ID="site" size="33" value="<%=securityUser.getSiteName()%>" maxlength="255">
                            </TD>
                            <%}else{
                                getMainSite = projectMgr.getOnSingleKey((String)getUserSiteInfo.getAttribute("mainProjId"));
                                String allSite = "";
                                if(stat.equals("Ar")){
                                allSite =getUserSiteInfo.getAttribute("projectName").toString()+", الرئيسى : "+getMainSite.getAttribute("projectName").toString();
                                }else{
                                    allSite =getUserSiteInfo.getAttribute("projectName").toString()+" , Main Site :"+getMainSite.getAttribute("projectName").toString();
                                    }
                                %>
                                 <TD class='td' STYLE="<%=style%>">
                                <input style="width: 100%;color: black;font-weight: bold" readonly type="TEXT" name="site" ID="site" size="33" value="<%=allSite%>" maxlength="255">
                            </TD>
                            <%}%>

                        </TR>
                            --%>
                            <TR style="display: none;">
                            <TD class="blueBorder blueHeaderTD" style="<%=style%>">
                                <LABEL FOR="str_Function_Name">
                                    <p><b><%=sTrade%>:</b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD class='td' STYLE="<%=style%>">
                                <input style="width: 100%;color: black;font-weight: bold" readonly type="TEXT" name="trade" ID="trade" size="33" value="<%=securityUser.getUserTradeName()%>" maxlength="255">
                            </TD>
                        </TR>
                        <%--
                        <TR>
                                <TD class='blueBorder blueHeaderTD' style="<%=style%>">
                                    <LABEL FOR="str_Function_Name">
                                        <p><b><%=sSearchType%>:</b>&nbsp;
                                    </LABEL>
                                </TD>
                                <%
                                        List queryList = new ArrayList();
                                        for(int i=0;i<filterList.size();i++){

                                            queryList=(ArrayList)filterList.get(i);
                                        %>
                                        <% if(queryList.get(3).toString().equals(securityUser.getSearchBy())){ %>
                                            <%if(stat.equals("En")){ %>

                                            <TD class='td' STYLE="<%=style%>">
                                                <input style="width: 100%;color: black;font-weight: bold" readonly type="TEXT" name="searchType" ID="searchType" size="33" value="<%=queryList.get(2).toString()%>" maxlength="255">
                                            </TD>

                                            <%}else{%>

                                            <TD class='td' STYLE="<%=style%>">
                                                <input style="width: 100%;color: black;font-weight: bold" readonly type="TEXT" name="searchType" ID="searchType" size="33" value="<%=queryList.get(1).toString()%>" maxlength="255">
                                            </TD>

                                            <%}%>
                                        <% } %>
                                        <% } %>
                                         <% if(securityUser.getSearchBy().equals("all")){ %>

                                         <TD class='td' STYLE="<%=style%>">
                                                <input style="width: 100%;color: black;font-weight: bold" readonly type="TEXT" name="searchType" ID="searchType" size="33" value="<%=sSelectAll%>" maxlength="255">
                                            </TD>

                                        <% } %>
                            </TR>
                        --%>
                         <TR>
                                <TD class='blueBorder blueHeaderTD' style="<%=style%>">
                                    <LABEL FOR="str_Function_Name">
                                        <p><b><%=sBranchName%>:</b>&nbsp;
                                    </LABEL>
                                </TD>

                                <% if(userProjectsCount> 0) { %>

                                <TD class='td' STYLE="<%=style%>">
                                    <textarea style="width: 100%;color: black;font-weight: bold;color: black;font-weight: bold" readonly name="branchName" ID="branchName" rows="<%=++userProjectsCount%>" cols="26"><%=userProjectsStr%></textarea>
                                </TD>
                                <%
                                   } else {
                                %>
                                 <TD class='td' STYLE="<%=style%>">
                                    <input style="width: 100%;color: black;font-weight: bold" readonly type="TEXT" name="branchName" ID="branchName" size="33" value="<%=setupStoreNote%>" maxlength="255">
                                </TD>
                                <%
                                   }
                                %>
                            </TR>

<!--                            <TR>
                                <TD class='blueBorder blueHeaderTD' style="<%=style%>">
                                    <LABEL FOR="str_Function_Name">
                                        <p><b><%=sStoreName%>:</b>&nbsp;
                                    </LABEL>
                                </TD>

                                <% if(userStoresCount> 0) { %>

                                <TD class='td' STYLE="<%=style%>">
                                    <textarea style="width: 100%;color: black;font-weight: bold;color: black;font-weight: bold" readonly name="storeName" ID="storeName" rows="<%=++userStoresCount%>" cols="26"><%=userStoresStr%></textarea>
                                </TD>
                                <%
                                   } else {
                                %>
                                <TD class='td' STYLE="<%=style%>">
                                    <input style="width: 100%;color: black;font-weight: bold;color: black;font-weight: bold" readonly type="TEXT" name="storeName" ID="storeName" size="33" value="<%=noAssignedUserStores%>" maxlength="255">
                                </TD>
                                <%
                                   }
                                %>
                            </TR>-->

<!--                            <TR>
                                <TD class='blueBorder blueHeaderTD' style="<%=style%>">
                                    <LABEL FOR="str_Function_Name">
                                        <p><b><%=sGrantUser%>:</b>&nbsp;
                                    </LABEL>
                                </TD>

                                <% if(grants.size()>0){

                                String grantString = "";
                                for(int i=0;i<grants.size();i++){

                                WebBusinessObject grantsWbo = (WebBusinessObject) grants.get(i);
                                grantWbo =(WebBusinessObject) grantsMgr.getOnSingleKey(grantsWbo.getAttribute("grantId").toString());

                                 if ((i+1)== grants.size()){
                                    grantString += (String) grantWbo.getAttribute("grantName");
                                 } else {
                                    grantString += grantWbo.getAttribute("grantName") + " - ";
                                 }
                              } %>

                                <TD class='td' STYLE="<%=style%>">
                                    <input style="width: 100%;color: black;font-weight: bold" readonly type="TEXT" name="grant" ID="grant" size="33" value="<%=grantString%>" maxlength="255">
                                </TD>
                                <%
                                   } else {
                                %>
                                 <TD class='td' STYLE="<%=style%>">
                                    <input style="width: 100%;color: black;font-weight: bold" readonly type="TEXT" name="grant" ID="grant" size="33" value="<%=sNoGrants%>" maxlength="255">
                                </TD>
                                <%
                                   }
                                %>
                            </TR>-->

                    </table>

                    <br>
                </FIELDSET>
            </center>
        </FORM>
    </body>
</html>
