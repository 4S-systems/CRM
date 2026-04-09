<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*,com.maintenance.db_access.EqChangesMgr,com.maintenance.servlets.*,java.text.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.contractor.db_access.MaintainableMgr,com.maintenance.db_access.*, com.tracker.db_access.*,com.maintenance.db_access.EquipmentStatusMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">


<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
ProjectMgr siteMgr = ProjectMgr.getInstance();
String context = metaMgr.getContext();
int noOfLinks=0;
int count=0;
String tempcount=(String)request.getAttribute("count");
String unitName = (String)request.getAttribute("unitName");
if(tempcount!=null)
    count=Integer.parseInt(tempcount);
String tempLinks=(String)request.getAttribute("noOfLinks");
if(tempLinks!=null)
    noOfLinks=Integer.parseInt(tempLinks);
String fullUrl=(String)request.getAttribute("fullUrl");
String url=(String)request.getAttribute("url");
String mainType = (String) request.getAttribute("type");
String strSites = (String) request.getAttribute("sites");

String[] projectAttributes = {"unitNo","unitName","site"};
String[] projectListTitles = new String[5];

int s = projectAttributes.length;
int t = s;
int iTotal = 0;
int flipper = 0;

String attName = null;
String attValue = null;
String bgColor = null;

Vector  projectsList = (Vector) request.getAttribute("data");

WebBusinessObject wbo = null;

String  formName = (String) request.getAttribute("formName");
String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String viewEq,eqNum,fieldsettitle="";

if(stat.equals("En")){
    align="center";
    dir="LTR";
    style="text-align:left";
    viewEq="List Equipment";
    eqNum="Equipment Number";
    projectListTitles[0]="Equipment Code";
    projectListTitles[1]="Equipment Name";
    projectListTitles[2]="Site";
    fieldsettitle="List Attchement Equipments ";

}else{
    align="center";
    dir="RTL";
    style="text-align:right";
    viewEq=" &#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
    String[] projectListTitlesAR = {"  &#1575;&#1587;&#1605; &#1575;&#1604;&#1575;&#1604;&#1600;&#1600;&#1600;&#1577;", " &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;", " &#1605;&#1588;&#1575;&#1607;&#1583;&#1577;", " &#1578;&#1581;&#1585;&#1610;&#1585;", " &#1581;&#1584;&#1601;"/*, "Attach File &#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;","View Files &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;", "Change &#1578;&#1594;&#1610;&#1610;&#1585;", "Show Changes &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1594;&#1610;&#1610;&#1585;&#1575;&#1578;"*/};
    projectListTitles[0]="&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    projectListTitles[1]="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    projectListTitles[2]="&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    eqNum="&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
    fieldsettitle="&#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1575;&#1604;&#1605;&#1604;&#1581;&#1602;&#1607;";
}
%>

<HEAD>
    <TITLE>Equipments List</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    <LINK REL="stylesheet" TYPE="text/css" HREF="css/images.css">

</HEAD>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">


        function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
            function cancelForm(url)
        {
        window.navigate(url);
        }
</SCRIPT>
<script type="text/javascript">
      function sendInfo(id,name){
        var id = id;
        var name = name;
        if(id =="null" || id =="" || name=="null" || name==""){
        window.opener.document.<%=formName%>.unitId.value = "";
        window.opener.document.<%=formName%>.unitName.value = "";
        window.close();
        } else {
        window.opener.document.<%=formName%>.unitId.value = id;
        window.opener.document.<%=formName%>.unitName.value = name;
        window.close();
        }
      }

       function getUnitTop(){
           var count =document.getElementById("selectIdTop").value;
           var name =document.getElementById("name").value;
           count = parseInt(count);
           var res = ""
                for (i=0;i < name.length; i++) {
                res += name.charCodeAt(i) + ',';
                    }
                res = res.substr(0, res.length - 1);
            document.equip_form.action = "<%=context%>/<%=fullUrl%>&count="+count+"&unitName="+res+"&url=<%=url%>";
            document.equip_form.submit();
            }
       function getUnitDown(){
           var count =document.getElementById("selectIdDown").value;
           var name =document.getElementById("name").value;
           count = parseInt(count);
           var res = ""
                for (i=0;i < name.length; i++) {
                res += name.charCodeAt(i) + ',';
                    }
                res = res.substr(0, res.length - 1);
            document.equip_form.action = "<%=context%>/<%=fullUrl%>&count="+count+"&unitName="+res+"&url=<%=url%>";
            document.equip_form.submit();
            }
    </script>
<script src='ChangeLang.js' type='text/javascript'></script>
<LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">

<BODY>
  <FORM NAME="equip_form" METHOD="POST">
<script type="text/javascript" src="js/wz_tooltip.js"></script>
<script type="text/javascript" src="js/tip_balloon.js"></script>
    <fieldset align="center" class="set" >
    <legend align="center">
        <table dir="rtl" align="center">
            <tr>
                <td class="td">
                    <%if(url!=null){
                    if(url.contains("ListAttachedEquipment")){
                    %>
                    <font color="blue" size="6"><%=fieldsettitle%>
                    </font>
                    <%}else{%>
                    <font color="blue" size="6"><%=viewEq%>
                    </font>
                    <%}}else{%>
                    <font color="blue" size="6"><%=viewEq%>
                    </font>
                    <%}%>
                </td>
            </tr>
        </table>
    </legend>
            <% if(noOfLinks>1){ %>
            <table align="center">
            <tr>
               <td class="td" >
               <b><font size="2" color="red">Page No:</font><font size="2" color="black">&nbsp;<%=count+1%>&nbsp;</font><font size="2" color="red">of&nbsp;</font><font size="2" color="black"> <%=noOfLinks%></font></b>
               </td>
            <td class="td"  >
               <select id="selectIdTop" onchange="javascript:getUnitTop();">
                   <%for(int i=0;i<noOfLinks;i++){%>
                   <option value="<%=i%>" <%if(i==count){%> selected <% } %> ><%=i+1%></option>
                   <% } %>
               </select>
           </td>
        </tr>
        </table>
        <% }%>
    
    <TABLE ALIGN="CENTER" dir="<%=dir%>" WIDTH="80%" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
        <TR CLASS="head">
            <TD nowrap WIDTH="3%" CLASS="firstname" bgcolor="#989898" STYLE="border-WIDTH:0; font-size:16;color:white;padding-left:3px;padding-right:3px;text-align:center" >
                <B>#</B>
            </TD>
            <%
            String columnWidth = new String("");
            String font = new String("");
            for(int i = 0;i<t;i++) {
                if(projectListTitles[i].equalsIgnoreCase("")){
                    columnWidth = "1";
                    font = "1";
                } else {
                    columnWidth = "100";
                    font = "19";
                }
            %>
            <TD nowrap CLASS="firstname" bgcolor="#989898" STYLE="border-WIDTH:0; font-size:<%=font%>;color:white;padding-left:20px;padding-right:20px;padding-bottom:5px;padding-top:5px;<%=style%>">
                <B><%=projectListTitles[i]%></B>
            </TD>
            <%
            }
            %>

        </TR>
        <%
        int index = count * 10;
        Enumeration e = projectsList.elements();
        String siteId,siteName;
        WebBusinessObject siteWbo;
        while(e.hasMoreElements()) {
            iTotal++;
            index++;
            wbo = (WebBusinessObject) e.nextElement();
            siteId = (String) wbo.getAttribute(projectAttributes[2]);
            siteWbo = siteMgr.getOnSingleKey(siteId);
            siteName = (String) siteWbo.getAttribute("projectName");
            flipper++;
            if((flipper%2) == 1) {
                bgColor="#F0F0F0";
            } else {
                bgColor="white";
            }
        %>

            <TR bgcolor="<%=bgColor%>">
            <TD WIDTH="3%" CLASS="firstname" bgcolor="#989898" STYLE="border-WIDTH:0; font-size:16;color:white;padding-left:3px;padding-right:3px;text-align:center">
                <B><%=index%></B>
            </TD>
            <TD WIDTH="11%" STYLE="<%=style%>;border-bottom:black 1px solid"  BGCOLOR="#F0F0F0">
                <DIV >
                    <a  href="javascript:sendInfo('<%=wbo.getAttribute("id").toString()%>', '<%=wbo.getAttribute("unitName").toString()%>');" > <b style="text-decoration: none;color:black;padding-left:20px;padding-right:20px;"> <%=(String) wbo.getAttribute(projectAttributes[0])%> </b> </a>
                </DIV>
            </TD>
            <TD WIDTH="75%" STYLE="<%=style%>;border-bottom:black 1px solid"  BGCOLOR="#F0F0F0" nowrap>
                <DIV >
                    <a  href="javascript:sendInfo('<%=wbo.getAttribute("id").toString()%>', '<%=wbo.getAttribute("unitName").toString()%>');" > <b style="text-decoration: none;color:black;padding-left:20px;padding-right:20px;"> <%=(String) wbo.getAttribute(projectAttributes[1])%> </b> </a>
                </DIV>
            </TD>
            <TD NOWRAP WIDTH="11%" STYLE="<%=style%>;border-bottom:black 1px solid;border-left:black 1px solid"  BGCOLOR="#F0F0F0">
                <%=siteName%> </b>
            </TD>
        </TR>
        <% }%>
        <TR>
            <TD nowrap CLASS="cell" BGCOLOR="#989898" COLSPAN="3" STYLE="text-align:center;padding-right:5;border-right-width:1;color:white;font-size:16;padding-left:20px;padding-right:20px">
                       <B><%=eqNum%></B>
            </TD>

           <TD nowrap CLASS="cell" BGCOLOR="#989898" colspan="1" STYLE="text-align:center;padding-left:5;;color:white;font-size:16;padding-left:20px;padding-right:20px">
                         <DIV NAME="" ID="">
                    <B><%=iTotal%></B>
                </DIV>
            </TD>
        </TR>

    </TABLE>
    <br>    
        <input type="hidden" name="url" value="<%=url%>" id="url" >
        <input type="hidden" name="formName" value="<%=formName%>" id="formName" >
        <input type="hidden" name="name" value="<%=unitName%>" id="name">
        <input type="hidden" name="type" value="<%=mainType%>" id="type" >
        <input type="hidden" name="sites" value="<%=strSites%>" id="sites">
            
            <% if(noOfLinks>1){ %>
            <table align="center">
            <tr>
               <td class="td" >
               <b><font size="2" color="red">Page No:</font><font size="2" color="black">&nbsp;<%=count+1%>&nbsp;</font><font size="2" color="red">of&nbsp;</font><font size="2" color="black"> <%=noOfLinks%></font></b>
               </td>
            <td class="td"  >
               <select id="selectIdDown" onchange="javascript:getUnitDown();">
                   <%for(int i=0;i<noOfLinks;i++){%>
                   <option value="<%=i%>" <%if(i==count){%> selected <% } %> ><%=i+1%></option>
                   <% } %>
               </select>
           </td>
        </tr>
        </table>
        <% }%>
    
    </fieldset>
</FORM>
</BODY>
</html>
