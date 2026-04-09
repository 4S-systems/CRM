<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.util.*,java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

UserMgr userMgr = UserMgr.getInstance();
CrewMissionMgr crewMgr = CrewMissionMgr.getInstance();
String issueId = (String) request.getAttribute(IssueConstants.ISSUEID);
String issueTitle = (String) request.getAttribute(IssueConstants.ISSUETITLE);

WebBusinessObject crewWbo = null;

AppConstants appCons = new AppConstants();

String[] itemAtt = {"note", "itemId","itemQuantity","itemPrice","totalCost"};//appCons.getItemScheduleAttributes();
String[] itemTitle = {"&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;", "&#1575;&#1604;&#1603;&#1605;&#1610;&#1577; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1577;","&#1575;&#1587;&#1600;&#1600;&#1600;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;","&#1585;&#1602;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;", "&#1605;"};//appCons.getItemScheduleHeaders();


Hashtable logos=new Hashtable();
logos=(Hashtable)session.getAttribute("logos");

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

Vector  itemList = (Vector) request.getAttribute("data");
int s = itemAtt.length;
int t = s;
int iTotal = 0;

String attName = null;
String attValue = null;
int flipper = 0;

WebBusinessObject wbo = IssueMgr.getInstance().getOnSingleKey(issueId);
if(wbo.getAttribute("techName") != null){
    crewWbo = crewMgr.getOnSingleKey(wbo.getAttribute("techName").toString());
}
WebBusinessObject wboTemp = UnitScheduleMgr.getInstance().getOnSingleKey(wbo.getAttribute("unitScheduleID").toString());

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat="En";
String align=null;
String dir=null;
String style=null;
String lang,langCode;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:right";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
}else{
    
    align="right";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
}

%>


<script src='ChangeLang.js' type='text/javascript'></script>

<html>
    <head>
        <META HTTP-EQUIV="Content-Type" CONTENT="text/html  charset=UTF-8">
        <TITLE></TITLE>
    </head>
    
    <body>
        
        
        
        
        <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="75%" dir="<%=dir%>">
            <TR>
                <TD>
                    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%"> 
                        <tr>
                            <td class="td" width="48%" colspan="2">
                                <img border="0" src="images/<%=logos.get("comLogo1").toString()%>" width="300" height="120" align="left">
                            </td>
                            <td class="td" width="50%" colspan="2">
                                <img border="0" src="images/<%=logos.get("comTitle").toString()%>" width="386" height="57">
                            </td>
                        </tr>
                        <TR>
                            <TD><IMG BORDER="0" SRC="<%=context%>/images/blanck.jpg"></TD>
                            <TD><IMG BORDER="0" SRC="<%=context%>/images/blanck.jpg"></TD>
                        </TR>
                    </TABLE>
                </TD>
            </TR>
            <TR>
                <TD>
                    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="100%" dir="<%=dir%>"> 
                        <TR>
                            <TD ALIGN="<%=align%>"><h3>&#1573;&#1584;&#1606;
                            &#1588;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1594;&#1600;&#1600;&#1604;</h3></TD>
                        </TR>
                        <TR>
                            <TD>&nbsp;</TD>
                        </TR>
                    </TABLE>
                </TD>
            </TR>
            <TR>
                <TD ALIGN="<%=align%>">
                    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" WIDTH="100%" dir="<%=dir%>"> 
                        <TR>
                            <TD COLSPAN="3" ALIGN="<%=align%>">
                                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2" dir="<%=dir%>">
                                    <TR>
                                        <TD VALIGN="TOP" ALIGN="<%=align%>">
                                            <%
                                            Calendar c = Calendar.getInstance();
                                            SimpleDateFormat f = new SimpleDateFormat("yyyy / MM / dd ");
                                            %>
                                            <%=f.format(c.getTime()).toString()%>
                                        </TD>
                                        <TD VALIGN="TOP" ALIGN="<%=align%>">
                                            &nbsp;
                                        </TD>
                                        <TD VALIGN="TOP" ALIGN="<%=align%>">
                                            <h4>&#1578;&#1575;&#1585;&#1610;&#1582;</h4>
                                        </TD>
                                    </TR>
                                </TABLE>
                            </TD>
                        </TR>
                        <TR>
                            <TD VALIGN="TOP" ALIGN="<%=align%>" WIDTH="75%"><%=wbo.getAttribute("projectName").toString()%></TD>
                            <TD><h4>:</h4></TD>
                            <TD ALIGN="<%=align%>" WIDTH="25%"><h4>(&#1575;&#1604;&#1608;&#1585;&#1588;&#1577;
                            (&#1580;&#1607;&#1577; &#1575;&#1604;&#1573;&#1589;&#1604;&#1575;&#1581;</h4></TD>
                        </TR>
                        
                        <TR>
                            <TD VALIGN="TOP" ALIGN="<%=align%>"><%=wboTemp.getAttribute("unitName").toString()%></TD>
                            <TD><h4>:</h4></TD>
                            <TD ALIGN="<%=align%>"><h4>&#1575;&#1587;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1605;
                            &#1575;&#1604;&#1605;&#1593;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1583;&#1577;</h4></TD>
                        </TR>
                        
                        <TR>
                            <TD VALIGN="TOP" ALIGN="<%=align%>"><%=wbo.getAttribute("issueDesc").toString()%></TD>
                            <TD><h4>:</h4></TD>
                            <TD ALIGN="<%=align%>"><h4>&#1576;&#1610;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1575;&#1606;
                            &#1575;&#1604;&#1593;&#1591;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1604;</h4></TD>
                        </TR>
                        
                        <%if(crewWbo != null){%>
                        <TR>
                            <TD VALIGN="TOP" ALIGN="<%=align%>"><%=crewWbo.getAttribute("crewName").toString()%></TD>
                            <TD><h4>:</h4></TD>
                            <TD ALIGN="<%=align%>"><h4>&#1601;&#1585;&#1610;&#1602; &#1575;&#1604;&#1593;&#1605;&#1604; &#1575;&#1604;&#1605;&#1603;&#1604;&#1601;</h4></TD>
                        </TR>
                        <%}%>
                    </TABLE>
                </TD>
            </TR>
            <TR>
                <TD ALIGN="<%=align%>">
                    &nbsp;
                </TD>
            </TR>
            <TR>
                <TD ALIGN="<%=align%>">
                    <center>
                        <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="<%=dir%>">
                            <TR>
                                <TD>
                                    <BR>
                                </TD>
                            </TR>
                            <TR>
                                <TD>
                                    <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="<%=dir%>">
                                        <TR ALIGN="<%=align%>">
                                            <TD>
                                                <B>&#1605;&#1602;&#1610;&#1575;&#1587; &#1602;&#1591;&#1593;
                                                    &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;
                                                &#1608;&#1575;&#1604;&#1582;&#1575;&#1605;&#1575;&#1578;</B>
                                            </TD>
                                        </TR>
                                        <TR ALIGN="<%=align%>">
                                            <TD>
                                                &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;
                                                &#1575;&#1604;&#1573;&#1589;&#1604;&#1575;&#1581;
                                            </TD>
                                        </TR>
                                    </TABLE>
                                </TD>
                            </TR>
                            <TR>
                                <TD>
                                    <BR>
                                </TD>
                            </TR>
                            <TR ALIGN="<%=align%>">
                                <TD>
                                    <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="1" dir="<%=dir%>">
                                        <TR align="<%=align%>">
                                            
                                            <%
                                            for(int i = 0;i<t;i++) {
                                            %>
                                            <TD>
                                                
                                                <%=itemTitle[i]%>
                                                
                                                
                                            </TD>
                                            <%
                                            }
                                            %>
                                        </TR>  
                                        
                                        <%
                                        
                                        Enumeration e = itemList.elements();
                                        String status = null;
                                        
                                        while(e.hasMoreElements()) {
                                            iTotal++;
                                            wbo = (WebBusinessObject) e.nextElement();
                                            attName = itemAtt[0];
                                            attValue = (String) wbo.getAttribute(attName);
                                        %>
                                        
                                        <TR>
                                            <TD width="40%" align="<%=align%>">
                                                &nbsp;<%=attValue%>
                                            </TD>
                                            <%
                                            for(int i = 2;i<s;i++) {
                                                attName = itemAtt[i];
                                                attValue = (String) wbo.getAttribute(attName);
                                                MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                                                if(i == 3) {
                                            
                                            %>
                                            <TD align="<%=align%>">
                                                <%=maintenanceItemMgr.getOnSingleKey(wbo.getAttribute(itemAtt[1]).toString()).getAttribute("itemDscrptn").toString()%>
                                            </TD>
                                            <%
                                                } else if(i==4){
                                            %>
                                            <TD align="<%=align%>">
                                                <%=maintenanceItemMgr.getOnSingleKey(wbo.getAttribute(itemAtt[1]).toString()).getAttribute("itemCode").toString()%>
                                            </TD>
                                            <%
                                                } else { %>
                                            <TD width="15%" align="<%=align%>">
                                                <DIV >
                                                    
                                                    <b><%=attValue%> </b>
                                                </DIV>
                                            </TD>
                                            <%
                                                }
                                            }
                                            %>
                                            <td align="<%=align%>" width="40">
                                                <%=iTotal%>
                                            </td>
                                            
                                        </TR>
                                        
                                        
                                        <%
                                        
                                        }
                                        
                                        %>
                                        
                                        
                                    </TABLE>
                                </TD>
                            </TR>
                            <TR>
                                <TD>
                                    <BR>
                                </TD>
                            </TR>
                            <TR ALIGN="<%=align%>">
                                <TD>
                                    <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="<%=dir%>">
                                        <TR>
                                            <TD COLSPAN="6">
                                                &nbsp;
                                            </TD>
                                        </TR>
                                        <TR>
                                            <TD COLSPAN="6">
                                                &nbsp;
                                            </TD>
                                        </TR>
                                        <TR ALIGN="<%=align%>">
                                            <TD COLSPAN="2" width="33%">
                                                &#1575;&#1604;&#1605;&#1583;&#1610;&#1585;
                                                &#1575;&#1604;&#1601;&#1606;&#1610;
                                            </TD>
                                            <TD COLSPAN="2" width="33%">
                                                &#1601;&#1606;&#1610;
                                                &#1575;&#1604;&#1608;&#1585;&#1588;&#1577;
                                            </TD>
                                            <TD COLSPAN="2" width="33%">
                                                &#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;
                                                &#1593;&#1606; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;
                                            </TD>
                                        </TR>
                                        <TR>
                                            <TD>
                                                &nbsp;
                                            </TD>
                                            <TD width="9%">
                                                :&#1575;&#1604;&#1575;&#1587;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1605;
                                            </TD>
                                            <TD>
                                                &nbsp;
                                            </TD>
                                            <TD width="9%">
                                                :&#1575;&#1604;&#1575;&#1587;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1605;
                                            </TD>
                                            <TD>
                                                &nbsp;
                                            </TD>
                                            <TD width="9%">
                                                :&#1575;&#1604;&#1575;&#1587;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1605;
                                            </TD>
                                        </TR>
                                        <TR>
                                            <TD>
                                                &nbsp;
                                            </TD>
                                            <TD width="9%">
                                                :&#1578;&#1608;&#1602;&#1610;&#1600;&#1600;&#1600;&#1600;&#1593;
                                            </TD>
                                            <TD>
                                                &nbsp;
                                            </TD>
                                            <TD width="9%">
                                                :&#1578;&#1608;&#1602;&#1610;&#1600;&#1600;&#1600;&#1600;&#1593;
                                            </TD>
                                            <TD>
                                                &nbsp;
                                            </TD>
                                            <TD width="9%">
                                                :&#1578;&#1608;&#1602;&#1610;&#1600;&#1600;&#1600;&#1600;&#1593;
                                            </TD>
                                        </TR>
                                        <TR>
                                            <TD COLSPAN="6">
                                                &nbsp;
                                            </TD>
                                        </TR>
                                        <TR>
                                            <TD COLSPAN="2" ALIGN="<%=align%>">
                                                &#1548;&#1548;&#1548;&#1548;&#1610;&#1593;&#1578;&#1605;&#1583;
                                            </TD>
                                            <TD COLSPAN="4">
                                                &nbsp;
                                            </TD>
                                        </TR>
                                        <TR>
                                            <TD COLSPAN="2">
                                                &nbsp;
                                            </TD>
                                            <TD COLSPAN="4">
                                                &nbsp;
                                            </TD>
                                        </TR>
                                        <TR>
                                            <TD COLSPAN="6">
                                                &nbsp;
                                            </TD>
                                        </TR>
                                    </TABLE>
                                </TD>
                            </TR>
                        </TABLE>
                    </center>
                </TD>
            </TR>
        </TABLE>
        
    </body>
</html>
