<%@page import="com.SpareParts.db_access.ERPDistNamesMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.maintenance.db_access.*"%>

<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Departments List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ERPDistNamesMgr erpDestMgr = ERPDistNamesMgr.getInstance();
        String[] departmentAttributes = {"typeCode", "name"};
        String[] departmentListTitles = new String[4];

        int s = departmentAttributes.length;
        int t = s;
        int iTotal = 0;

        String attName = null;
        String attValue = null;
        String cellBgColor = null;



        Vector departmentsList = (Vector) request.getAttribute("data");
        String formName = (String) request.getAttribute("formName");

        WebBusinessObject wbo = null;
        int flipper = 0;
        String bgColor = null;

        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, tit, save, cancel, TT, IG, AS, QS, BO, CD, PN, NAS, classGroup;
        String setupStoreNote;
        String type = (String) request.getAttribute("type");
        String destTypeTitle=null;
        String PL=null;
        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            tit = "Delete Schedule - Are you Sure ?";
            save = "Delete";
            cancel = "Back To List";
            TT = "Task Title ";
            IG = "Indicators guide ";
            AS = "Active Site by Equipment";
            NAS = "Non Active Site";
            QS = "Quick Summary";
            BO = "Basic Operations";
            departmentListTitles[0] = "Code";
            departmentListTitles[1] = "Name";
            CD = "Can't Delete Site";
            PN = "Spare Parts  No.";
            
            classGroup="Gorups of items";
            setupStoreNote = "Should be prepared store for the program";
            if (type.equals("4")){
                PL = "Stores List";
            }else if(type.equals("6")){
                PL = "Department List";
            }

        } else {

            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            tit = " &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
            save = " &#1573;&#1581;&#1584;&#1601;";
            cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
            TT = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
            IG = "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
            AS = "&#1605;&#1608;&#1602;&#1593; &#1578;&#1593;&#1605;&#1604; &#1576;&#1607; &#1605;&#1593;&#1583;&#1575;&#1578;";
            NAS = "&#1605;&#1608;&#1602;&#1593; &#1604;&#1575; &#1578;&#1593;&#1605;&#1604; &#1576;&#1607; &#1605;&#1593;&#1583;&#1575;&#1578;";
            QS = "&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
            BO = "&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
            departmentListTitles[0] = "&#1575;&#1604;&#1603;&#1608;&#1583;";
            departmentListTitles[1] = "&#1575;&#1604;&#1575;&#1587;&#1605;";
            // departmentListTitles[2]="&#1578;&#1581;&#1585;&#1610;&#1585;";
            // departmentListTitles[3]="&#1581;&#1584;&#1601;";
            CD = " &#1604;&#1575; &#1578;&#1587;&#1578;&#1591;&#1610;&#1593; &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
            PN = "  &#1593;&#1583;&#1583; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
            PL = "&#1593;&#1585;&#1590; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
            classGroup="&#1605;&#1580;&#1605;&#1608;&#1593;&#1575;&#1578; &#1575;&#1604;&#1571;&#1589;&#1606;&#1575;&#1601;";
            setupStoreNote="&#1610;&#1580;&#1576; &#1573;&#1593;&#1583;&#1575;&#1583; &#1575;&#1604;&#1605;&#1582;&#1586;&#1606; &#1604;&#1604;&#1576;&#1585;&#1606;&#1575;&#1605;&#1580;";
            if (type.equals("4")){
                PL = "&#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1582;&#1575;&#1586;&#1606;";
            }else if(type.equals("6")){
                PL = "&#1593;&#1585;&#1590; &#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1575;&#1578;";
            }
        }

        int noOfLinks = 0;
        int count = 0;
        String tempcount = (String) request.getAttribute("count");
        String sparePart = (String) request.getAttribute("sparePart");

        if (tempcount != null) {
            count = Integer.parseInt(tempcount);
        }
        String tempLinks = (String) request.getAttribute("noOfLinks");
        if (tempLinks != null) {
            noOfLinks = Integer.parseInt(tempLinks);
        }
        String fullUrl = (String) request.getAttribute("fullUrl");
        String url = (String) request.getAttribute("url");

        ItemFormListMgr itemFormListMgr = ItemFormListMgr.getInstance();
       // ArrayList classOfGroup = (ArrayList) itemFormListMgr.getCashedTableAsBusObjects();
        StoresErpMgr storesErpMgr = StoresErpMgr.getInstance();
    BranchErpMgr branchErpMgr= BranchErpMgr.getInstance();
    ActiveStoreMgr activeStoreMgr = ActiveStoreMgr.getInstance();
    WebBusinessObject activeStoreWbo = new WebBusinessObject();
    Vector activeStoreVec = new Vector();
    activeStoreVec = activeStoreMgr.getActiveStore(session);
    String storeByBranch = null;
    if(activeStoreVec.size()>0) {
        activeStoreWbo = (WebBusinessObject)activeStoreVec.get(0);
       // request.getSession().setAttribute("branchCode", activeStoreWbo.getAttribute("branchCode").toString());
      //  request.getSession().setAttribute("storeCode", activeStoreWbo.getAttribute("storeCode").toString());
        storeByBranch =request.getSession().getAttribute("storeCode").toString();
    }
    
    Vector itemFormListVec = (Vector) itemFormListMgr.getOnArbitraryKeyOrdered(storeByBranch, "key1","key");
    ArrayList classOfGroup = new ArrayList();

  //  ArrayList classOfGroup = (ArrayList) itemFormListMgr.getCashedTableAsBusObjects();
    for(int x=0;x<itemFormListVec.size();x++){
       // classOfGroup = new ArrayList();
       classOfGroup.add(itemFormListVec.get(x));
       }

   // String sDesc = (String) request.getAttribute("sDesc");
    String sCode = (String) request.getAttribute("sCode");

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
    </script>
    <script type="text/javascript">
        function sendInfo(name,id){
            var id = id;
            var name = name;
            
            if(id =="null" || id =="" || name=="null" || name==""){
                window.opener.document.<%=formName%>.<%=sCode%>.value = "";
                window.close();
            } else {
                window.opener.document.<%=formName%>.<%=sCode%>.value = id;
                window.close();
            }
        }

        function getSparePartTop(){
          
            var type = document.getElementById("type").value;
            var count =document.getElementById("selectIdTop").value;
            count = parseInt(count);
           
            document.dest_form.action = "<%=context%>/<%=fullUrl%>&count="+count+"&type="+type+"&url=<%=url%>";

            document.dest_form.submit();
        }
        function getSparePartDown(){
            var type = document.getElementById("type").value;
            var count =document.getElementById("selectIdDown").value;
            count = parseInt(count);

            document.dest_form.action = "<%=context%>/<%=fullUrl%>&count="+count+"&type="+type+"&url=<%=url%>";
         
            document.dest_form.submit();
        }
    
    
    </script>
    <body>
        
        <form NAME="dest_form" METHOD="POST">
            <input type="hidden" name="type" id="type" value="<%=type%>"/>
            <fieldset align=center class="set">
                <legend align="center">

                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>

                            <td class="td">
                                <font color="blue" size="6"><%=PL%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend >
               <input type="text" id="dd" name="dd" value="<%=formName%>---<%=sCode%>">
               <br>
                <table align="center">

                    <% if (noOfLinks > 1) {%>
                    <tr>
                        <td class="td" >
                            <b><font size="2" color="red">Page No:</font><font size="2" color="black"> &nbsp; <%=count + 1%> &nbsp;</font><font size="2" color="red">of &nbsp;</font><font size="2" color="black"> &nbsp; <%=noOfLinks%> &nbsp;</font></b>
                        </td>
                        <td class="td"  >
                            <select id="selectIdTop" onchange="javascript:getSparePartTop();">
                                <%for (int i = 0; i < noOfLinks; i++) {%>
                                <option value="<%=i%>" <%if (i == count) {%> selected <% }%> ><%=i + 1%></option>
                                <% }%>
                            </select>
                        </td>
                    </tr>
                    <% }%>
                </table>
                <br>
               <table align="center">
                    <TR CLASS="head">

                        <%
        String columnColor = new String("");
        String columnWidth = new String("");
        String font = new String("");
        for (int i = 0; i < t; i++) {
            if (i == 0 || i == 1) {
                columnColor = "#9B9B00";
            } else {
                columnColor = "#7EBB00";
            }
            if (departmentListTitles[i].equalsIgnoreCase("")) {
                columnWidth = "1";
                columnColor = "black";
                font = "1";
            } else {
                columnWidth = "100";
                font = "12";
            }
                        %>
                        <TD CLASS="header" bgcolor="#999966" STYLE="text-align:center;color:white;font-size:16">
                            <B><%=departmentListTitles[i]%></B>
                        </TD>
                        <%
        }
                        %>

                    </TR>
                    <%

        Enumeration e = departmentsList.elements();
        WebBusinessObject itemWbo = new WebBusinessObject();

        while (e.hasMoreElements()) {
            
            wbo = (WebBusinessObject) e.nextElement();

            flipper++;
            if ((flipper % 2) == 1) {
                bgColor = "#c8d8f8";
            } else {
                bgColor = "white";
            }
                    %>


                  <TR bgcolor="<%=bgColor%>">
                        <%
                        iTotal++;
                        for (int i = 0; i < s; i++) {
                            
                            attName = departmentAttributes[i];
                            attValue = (String) wbo.getAttribute(attName);


                        %>


                        <TD  STYLE="<%=style%>"  nowrap WIDTH="200" BGCOLOR="#DDDD00"  CLASS="cell" >
                            <DIV >

                                <a  href="javascript:sendInfo('<%=wbo.getAttribute("name")%>', '<%=wbo.getAttribute("typeCode")%>');" > <b style="text-decoration: none"> <%=attValue%> </b> </a>
                            </DIV>
                        </TD>

                        <%
                        }
                        %>
                    </TR>
                   
                    <%

        }

                    %>
               </table>
                
                <table align="center">

                    <input type="hidden" name="url" value="<%=url%>" id="url" >
                    <input type="hidden" name="formName" value="<%=formName%>" id="formName" >
                    <input type="hidden" name="sCode" value="<%=sCode%>" id="sCode" >
                    <input type="hidden" name="name" value="<%=sparePart%>" id="name" >
                    <% if (noOfLinks > 1) {%>
                    <tr>
                        <td class="td" >
                            <b><font size="2" color="red">Page No:</font><font size="2" color="black"> &nbsp; <%=count + 1%> &nbsp;</font><font size="2" color="red">of &nbsp;</font><font size="2" color="black"> &nbsp; <%=noOfLinks%> &nbsp;</font></b>
                        </td>
                        <td class="td"  >
                            <select id="selectIdDown" onchange="javascript:getSparePartDown();">
                                <%for (int i = 0; i < noOfLinks; i++) {%>
                                <option value="<%=i%>" <%if (i == count) {%> selected <% }%> ><%=i + 1%></option>
                                <% }%>
                            </select>
                        </td>
                    </tr>
                    <% }%>
                </table>
               

            </fieldset>


        </form>
    </body>
</html>
