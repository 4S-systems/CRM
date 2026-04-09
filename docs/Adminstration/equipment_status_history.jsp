<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.engine.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory,java.lang.Integer, com.maintenance.db_access.EqStateTypeMgr,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
EqStateTypeMgr eqStateTypeMgr = EqStateTypeMgr.getInstance();

String context = metaMgr.getContext();

String[] statusAtt = {"stateID", "beginDate", "endDate", "note"};
String[] statusTitle = {"Status ", "Begain Date", "End Date ", "Notes "};

String equipmentID = (String) request.getAttribute("equipmentID");
Vector  statusList = (Vector) request.getAttribute("data");
WebBusinessObject eqWbo = maintainableMgr.getOnSingleKey(equipmentID);

int s = statusAtt.length;
int iTotal = 0;

String attName = null;
String attValue = null;

WebBusinessObject wbo = null;

String cMode = (String) request.getSession().getAttribute("currentMode");
String stat = cMode;
String align = null;
String cellAlign = null;
String dir = null;
String style = null;
String lang, langCode, viewEqDate, back, basicData, eqpName, currentState;

if(stat.equals("En")){
    align = "center";
    dir = "LTR";
    style = "text-align:left";
    lang="&#1593;&#1585;&#1576;&#1610;";
    langCode = "Ar";
    cellAlign = "left";
    
    viewEqDate = "View Equipment Status Date";
    back = "Back";
    basicData = "Basic Data";
    eqpName = "Equipment Name";
    currentState = "Current State";
}else{
    align = "center";
    dir = "RTL";
    style = "text-align:Right";
    lang = "English";
    langCode = "En";
    cellAlign = "right";
    
    viewEqDate = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1578;&#1575;&#1585;&#1610;&#1582; &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    String[] statusTitleAr = {"&#1575;&#1604;&#1581;&#1575;&#1604;&#1607;", " &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607;", " &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1607;", " &#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;"};
    statusTitle = statusTitleAr;
    back = "&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
    basicData = "&#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1585;&#1574;&#1610;&#1587;&#1610;&#1577;";
    eqpName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    currentState = "&#1581;&#1575;&#1604;&#1577; &#1593;&#1605;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577; &#1575;&#1604;&#1570;&#1606;";
}
%>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
 function cancelForm(url){    
     window.location=url;
 }
</script>
<script src='ChangeLang.js' type='text/javascript'></script>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <Body>
        <CENTER>
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button onclick="cancelForm('<%=context%>/UnitDocReaderServlet?op=ViewImages&equipmentID=<%=equipmentID%>')" class="button"><%=back%><IMG SRC="images/leftarrow.gif"> </button> 
            </DIV>
            <br>
            
            <fieldset align="center" class="set" >
                <legend align="center">
                    <table dir="rtl" align="center">
                        <tr>
                            <td class="td" align="center" style="text-align:center">
                                <font color="blue" size="6"><%=viewEqDate%></font>                               
                            </td>
                        </tr>
                    </table>
                </legend>
                <br>
                
                <table border="0" ALIGN="<%=align%>" dir="<%=dir%>" width="500">
                    <tr>
                        <td colspan="2" bgcolor="cornflowerblue">
                            <font color="#FFFFFF" size="5"><b><%=basicData%></b></font>
                        </td>
                    </tr>
                    
                    <tr>
                        <td width="150" bgcolor="#CCCCCC" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=eqpName%></font></b></td>
                        <td style="border-right-width:1px"><b><font size="3" color="red"><%=(String) eqWbo.getAttribute("unitName")%></font></b></td>
                    </tr>
                    
                    <%
                    String eqpCurrentStatus = null;
                    if(eqWbo.getAttribute("equipmentStatus").toString().equalsIgnoreCase("1")){
                        eqpCurrentStatus = "Working";
                    } else {
                        eqpCurrentStatus = "Out of work";
                    }
                    %>
                    
                    <tr>
                        <td width="150" bgcolor="#CCCCCC" style="text-align:<%=cellAlign%>; padding-<%=cellAlign%>:10"><b><font size="3" color="black"><%=currentState%></font></b></td>
                        <td style="border-right-width:1px"><b><font size="3" color="red"><%=eqpCurrentStatus%></font></b></td>
                    </tr>
                </table>
                <br>
                
                <TABLE ALIGN="CENTER" dir="<%=dir%>" WIDTH="800" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                    <TR ALIGN="<%=align%>">
                        <TD CLASS="td" bgcolor="#006699" STYLE="border-WIDTH:0; font-size:16;color:white;text-align:center;">
                            <B>#</B>
                        </TD>
                        <% for(int i = 0;i<s;i++) {
                        %>
                        <TD CLASS="td" bgcolor="#006699" STYLE="border-WIDTH:0; font-size:16;color:white;text-align:center;">
                            <B><%=statusTitle[i]%></B>
                        </TD>
                        <%
                        }
                        %>
                    </TR>
                    
                    <%
                    int counter = 0;
                    Enumeration e = statusList.elements();
                    statusList = null;
                    
                    while(e.hasMoreElements()) {
                        wbo = (WebBusinessObject) e.nextElement();
                    %>
                    <TR ALIGN="<%=align%>">
                        <TD CLASS="cell" STYLE="font-size:14;text-align:<%=align%>;border-right-width:1px">
                            <B><%=counter+1%></B>
                        </TD>
                        <%
                        for(int i = 0;i<s;i++) {
                            String date = null;
                            String time = null;
                            
                            attValue = (String) wbo.getAttribute(statusAtt[i]);
                            
                            if(i == 0){
                                WebBusinessObject temp = eqStateTypeMgr.getOnSingleKey(attValue);
                                attValue = (String) temp.getAttribute("name");
                            }
                            
                            if(attValue == null ){
                                attValue = "---";
                            }
                            
                            if((i==1 || i==2) && attValue.equalsIgnoreCase("---") == false){
                                date = attValue.substring(0,10);
                                time = attValue.substring(11, attValue.length()-2);
                            }
                        %>
                        <%if((i==1 || i==2) && attValue.equalsIgnoreCase("---") == false){%>
                        <TD CLASS="cell" STYLE="font-size:14;text-align:<%=align%>;border-right-width:1px">
                            <B><Font COLOR="red"><%=date%></FONT><%=time%></B>
                        </TD> 
                        <%} else {%>
                        <TD CLASS="cell" STYLE="font-size:14;text-align:<%=align%>;border-right-width:1px">
                            <B><%=attValue%></B>
                        </TD>
                        <%}%>
                        <%}%>
                    </TR>
                    <%
                    counter++;
                    }
                    %>
                </TABLE>
                <br>
            </fieldset>
        </CENTER>
    </BODY>
    
</HTML>
