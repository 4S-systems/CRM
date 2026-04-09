<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.contractor.db_access.MaintainableMgr,com.maintenance.db_access.UnitDocMgr, com.tracker.db_access.*, com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>Equipments List</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
</HEAD>
<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
ProjectMgr projectMgr = ProjectMgr.getInstance();
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
UnitDocMgr unitDocMgr = UnitDocMgr.getInstance();

String context = metaMgr.getContext();

String[] projectAttributes = {"unitName"};
String[] projectListTitles = {"Equipment Name ", "Site Name ", "Acqusition Date ", "Current Status ", "Current Status Since ", "Change Status ", "Status History "};

int s = projectAttributes.length;
int t = s + 6;
int iTotal = 0;
int flipper = 0;

String attName = null;
String attValue = null;
String cellBgColor = null;
String bgColor = null;

boolean active;

Vector  projectsList = (Vector) request.getAttribute("data");

WebBusinessObject wbo = null;
EquipmentStatusMgr equipmentStatusMgr = EquipmentStatusMgr.getInstance();
EqStateTypeMgr eqStateTypeMgr = EqStateTypeMgr.getInstance();

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,activat,unactivat,Basic,Indicators,Quick,numTask,noFound,Change_Status,Status_History
        ;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    
    
    activat=" Active Equipment ";
    unactivat=" Non Active Equipment ";
    
    numTask="Number of Task";
    
    Quick="Quick Summary";
    Basic="Basic Oprations";
    Indicators="Indicators Guide";
    noFound="Not Exist";
    Change_Status="Change Status";
    Status_History="Status History";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    
    activat=" &#1605;&#1593;&#1583;&#1607; &#1578;&#1593;&#1605;&#1604; ";
    
    
    unactivat="  &#1605;&#1593;&#1583;&#1607; &#1604;&#1575; &#1578;&#1593;&#1605;&#1604; ";
    numTask="&#1593;&#1583;&#1583; &#1575;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604;";
    
    Quick="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
    Basic="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
    Indicators="&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    String[] projectListTitlesAr = {" &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;", " &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;", " &#1578;&#1575;&#1585;&#1610;&#1582; &#1583;&#1582;&#1608;&#1604; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;", " &#1575;&#1604;&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1607;", " &#1575;&#1604;&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1581;&#1604;&#1610;&#1577; &#1605;&#1606;&#1584;", " &#1594;&#1610;&#1585; &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;", " &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;"};
    projectListTitles=projectListTitlesAr;
    noFound=" &#1604;&#1575;&#1610;&#1608;&#1580;&#1583;";
    Change_Status="&#1594;&#1610;&#1585; &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;";
    Status_History=" &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;";
    
    
}
%>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function submitForm(equipID){
            if(confirm('Are you sure delete this equipment') == true){
                this.EQUIPMENT_DELETE.action = "<%=context%>/EquipmentServlet?op=DeleteEquipment&equipmentID="+equipID;
                this.EQUIPMENT_DELETE.submit();
            }
        }
          function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>
<LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
<BODY>
    
    <table align="<%=align%>" width="50%">
        <tr><td class="td">
        <div    STYLE="border:2px solid gray;background-color:#808000;color:white;" bgcolor="#F3F3F3" align="center">
        <div  ONCLICK="JavaScript: changeMode('menu1');" STYLE="background-color:#808000;color:white;cursor:hand;font-size:14;">
            <b>
                <%=Indicators%>
            </b>
            <img src="images/arrow_down.gif">
        </div>
        
        <div  STYLE="background-color:#FFFFCC;color:white;display:none;<%=style%>;border-top:2px solid gray;" ID="menu1">
        <table width="100%" border="0" DIR="<%=dir%>" >
            <tr>
                <td  CLASS="cell" bgcolor="#F3F3F3" style="<%=style%>"  dir="<%=dir%>"><IMG SRC="images/active.jpg"  ALT="Configured Schedule" ><FONT COLOR="red" >&nbsp; <%=activat%></font></td>
                <td CLASS="cell" bgcolor="#F3F3F3" style="<%=style%>" dir="<%=dir%>"><IMG SRC="images/nonactive.jpg"  ALT="Un configure Schedule" ><FONT COLOR="red" > &nbsp; <%=unactivat%>   </font></td>
        </tr</table>                              
    </table>
    </div>
    </div>
    </td></tr></table>
    
    <DIV align="left" STYLE="color:blue;">
        <input type="button" value="<%=lang%>"
               onclick="reloadAE('<%=langCode%>')" class="button">
    </DIV> 
    
    <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
        <TR>
            <TD class='td'>
                &nbsp;
            </TD>
        </TR>
    </table>
    
    
    <BR><br><br>
    
    <FORM NAME="EQUIPMENT_DELETE" METHOD="POST">
        <TABLE ALIGN="RIGHT" DIR="rtl" stylel="position:absolute;left:30px;border-right-WIDTH:1px"  WIDTH="200" CELLPADDING="0" CELLSPACING="0">
            <TR>
                <TD nowrap COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:right;">
                    <IMG WIDTH="20" HEIGHT="20" SRC="images/pinion.gif">
                    &#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; 
                </TD>
                
            </TR>
        </TABLE>
        <br><br>
        
        <TABLE ALIGN="RIGHT" DIR="RTL" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            <TR>
                
                <TD CLASS="td" COLSPAN="5" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
                    <B><%=Quick%></B>
                </TD>
                <TD CLASS="td" COLSPAN="2" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:16">
                    <B><%=Basic%></B>
                </TD>
                <TD CLASS="td" COLSPAN="1" bgcolor="#CC9900" STYLE="text-align:center;color:white;font-size:16">
                    <B><%=Indicators%></B>
                </TD>
                
            </TR>
            <TR CLASS="head">
                <%
                for(int i = 0;i<t;i++) {
    String col="#9B9B00";
    if(i>4)
        col="#7EBB00";
    if(i>6)
        col="#FFBF00";
                
                
                %>                
                <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12" nowrap BGCOLOR="<%=col%>">
                    <%=projectListTitles[i]%>
                </TD>
                <%
                }
                %>
                <TD nowrap CLASS="firstname" WIDTH="20" STYLE="border-top-WIDTH:0; font-size:12" nowrap>
                    &nbsp;
                    </TD>
            </TR>
            <%
            Enumeration e = projectsList.elements();
            while(e.hasMoreElements()) {
                iTotal++;
                wbo = (WebBusinessObject) e.nextElement();
                String equipmentID = (String) wbo.getAttribute("id");
                SupplierEquipmentMgr supplierEquipmentMgr = SupplierEquipmentMgr.getInstance();
                Vector vecSupplier = supplierEquipmentMgr.getOnArbitraryKey(equipmentID, "key");
                WebBusinessObject wboSupplier = null;
                if(vecSupplier.size() > 0){
                    wboSupplier = (WebBusinessObject) vecSupplier.elementAt(0);
                }
                flipper++;
                if((flipper%2) == 1) {
                    bgColor="#c8d8f8";
                } else {
                    bgColor="white";
                }
                
                if(maintainableMgr.hasSchedules(wbo.getAttribute("id").toString()) || maintainableMgr.equipmentHasChild(wbo.getAttribute("id").toString())){
                    active = true;
                } else {
                    active = false;
                }
            %>
            <TR bgcolor="<%=bgColor%>">
                <%
                for(int i = 0;i<s;i++) {
                    attName = projectAttributes[i];
                    attValue = (String) wbo.getAttribute(attName);
                %>
                <TD  nowrap  CLASS="cell" BGCOLOR="#DDDD00">
                    <DIV >
                        <b> <%=attValue%> </b>
                    </DIV>
                </TD>
                
                <TD  nowrap  CLASS="cell" BGCOLOR="#DDDD00">
                    <DIV >
                        <%
                        WebBusinessObject projectWbo = (WebBusinessObject) projectMgr.getOnSingleKey((String) wbo.getAttribute("site"));
                        %>
                        <b> 
                            <%=projectWbo.getAttribute("projectName").toString()%>
                        </b>
                    </DIV>
                </TD>
                <%
                }
                WebBusinessObject statusWbo = equipmentStatusMgr.getLastStatus((String) wbo.getAttribute("id"));
                %>
                <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;" BGCOLOR="#DDDD00">
                    <DIV ID="links">
                        <%
                        if(wboSupplier != null){
                        %>
                        <%=(String) wboSupplier.getAttribute("purchaseDate")%>
                        <%
                        } else {
                        %>
                        <%=noFound%>
                        <%
                        }
                        %>
                    </DIV>
                </TD>
                <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;" BGCOLOR="#DDDD00">
                    <DIV ID="links">
                        <%
                        int currentStatus = 2;
                        if(statusWbo != null){
                            String stateID = (String) statusWbo.getAttribute("stateID");
                            currentStatus = new Integer(stateID).intValue();
                            WebBusinessObject tempWbo = eqStateTypeMgr.getOnSingleKey(stateID);
                        %>
                        <%=(String) tempWbo.getAttribute("name")%>
                        <%
                        } else {
                        %>
                        <%=noFound%>
                        <%
                        }
                        %>
                    </DIV>
                </TD>
                <TD nowrap CLASS="cell" STYLE="padding-left:10;text-align:left;" BGCOLOR="#DDDD00">
                    <DIV ID="links">
                        <%
                        if(statusWbo != null){
                        %>
                        <%=(String) statusWbo.getAttribute("beginDate")%>
                        <%
                        } else {
                        %>
                        <%=noFound%>
                        <%
                        }
                        %>
                    </DIV>
                </TD>
                <TD nowrap DIR="LTR" CLASS="cell" STYLE="padding-left:10;text-align:left;" BGCOLOR="#D7FF82">
                    <DIV ID="links">
                        <A HREF="<%=context%>/EqStateTypeServlet?op=ChangeStatusForm&equipmentID=<%=wbo.getAttribute("id")%>&currentStatus=<%=currentStatus%>">
                            <%=Change_Status%>
                        </A>
                    </DIV>
                </TD>
                <TD nowrap DIR="LTR" CLASS="cell" STYLE="padding-left:10;text-align:left;" BGCOLOR="#D7FF82">
                    <DIV ID="links">
                        <A HREF="<%=context%>/EqStateTypeServlet?op=ViewStatusHistory&equipmentID=<%=wbo.getAttribute("id")%>">
                            <%=Status_History%>
                        </A>
                    </DIV>
                </TD>
                <TD WIDTH="20px" nowrap CLASS="cell" BGCOLOR="#FFE391">
                    <%
                    if(active) {
                    %>
                    <IMG SRC="images/active.jpg"  ALT="Active Equipment">
                    <%
                    } else {
                    %> 
                    <IMG SRC="images/nonactive.jpg"  ALT="Non Active Equipment">
                    <% } %>
                </TD>
            </TR>
            <%
            }
            %>
            <TR>
                <TD CLASS="total" COLSPAN="4" STYLE="text-align:right;padding-right:5;border-right-width:1;" BGCOLOR="#808080">
                    &#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;
                </TD>
                
                <TD CLASS="total" colspan="4" STYLE="text-align:left;padding-left:5;" BGCOLOR="#808080">
                    <DIV NAME="" ID="">
                        <%=iTotal%>
                    </DIV>
                </TD>
            </TR>
        </TABLE>
    </FORM>
</BODY>
</html>
