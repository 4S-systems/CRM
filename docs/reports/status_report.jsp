<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.engine.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory,java.lang.Integer"%>
<%@ page import="com.maintenance.common.ConfigFileMgr" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%
System.out.println("in JSP ---------");
AppConstants appCons = new AppConstants();
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
ConfigFileMgr configFileMgr = new ConfigFileMgr();
String context = metaMgr.getContext();
String filterName = (String) request.getParameter("fName");
String filterValue = (String) request.getParameter("fValue");
System.out.println(" filterName IN JSP --------------------------------------- " +filterName);
System.out.println(" filterValue IN JSP --------------------------------------- "+filterValue);
String[] issueStatusAtt = appCons.getIssueStatusAtt();
String[] issueStatusTitle = {"Status Name ", "Begin Date ", "Duration Time","Notes "};

String[] issueAtt  = {"id","issueType","projectName","urgencyId","currentStatus","beginDeviation","endDeviation","estimatedDeviation"};
String[] issueTitle = {"Schedule Id.", " Machine" ,"Site ","Urgency ","Status","Begin Date ","End Date ","Estimated Finish Time "};

int s = issueStatusAtt.length;
System.out.println("The value you need of s is "+s);
int t = issueAtt.length - 4;
int iTotal = 0;
String attName = null;
String attValue = null;
boolean bCheck = false;
String[] sTemp = {"","",""};


String projectname = (String) request.getAttribute("projectName");
Vector  issueStatusList = (Vector) request.getAttribute("data");
System.out.println("Vector Count = "+issueStatusList.size());
Vector issueDetail = (Vector) request.getAttribute("detail");
System.out.println("~~~~~~~~~~~~~~~~~~~~~~Vector Count = "+issueDetail.size());



WebBusinessObject wbo = (WebBusinessObject) issueDetail.get(0);

Enumeration e = issueDetail.elements();

issueDetail = null;
WebBusinessObject siteName = null;
WebBusinessObject urgencyName = null;
ProjectMgr projectMgr = ProjectMgr.getInstance();
UrgencyMgr urgencyMgr = UrgencyMgr.getInstance();

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;

String lang,langCode,back,viewTaskDate,Schedule_History,Schedule_Information,DFV,inCAseOfNull,noDesc;
if(stat.equals("En")){
    inCAseOfNull="No Feedback";
    align="center";
    dir="LTR";
    style="text-align:center";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    back="Back";
    viewTaskDate="View Job Order Dates";
    Schedule_History="Schedule History";
    Schedule_Information="Schedule Information";
    DFV="Deviation From Set Dates ";
    noDesc = "No Desc";
}else{
    
    inCAseOfNull="&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    back="&#1593;&#1608;&#1583;&#1577;";    
    String[] issueTitleAr = {"&#1585;&#1602;&#1605;&nbsp; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;"," &#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;", " &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;"," &#1583;&#1585;&#1580;&#1577; &#1575;&#1604;&#1571;&#1607;&#1605;&#1610;&#1577;"," &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;"," &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577;"," &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1577;"," &#1608;&#1602;&#1578; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;"};
    issueTitle=issueTitleAr;
    String[] issueStatusTitleAr = {"&#1573;&#1587;&#1605; &#1575;&#1604;&#1581;&#1575;&#1604;&#1577;", " &#1608;&#1602;&#1578; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577;", "&#1575;&#1604;&#1605;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1594;&#1585;&#1602;&#1577;"," &#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;"};
    issueStatusTitle=issueStatusTitleAr;
    viewTaskDate=" &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
    Schedule_History=" &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
    Schedule_Information="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1593;&#1606; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
    DFV="&#1575;&#1604;&#1601;&#1585;&#1602; &#1576;&#1610;&#1606; &#1575;&#1604;&#1578;&#1608;&#1575;&#1585;&#1610;&#1582;";
    noDesc = "&#1604;&#1575;&#1578;&#1608;&#1580;&#1583; &#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
}
%>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">   
 function cancelForm(url)
        {    
        window.navigate(url);
        }
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>
<LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">

<HTML>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Tracker- List Schedules</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <BODY>
        
        <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <input type="button" value="<%=back%>" onclick="cancelForm('<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=wbo.getAttribute("id")%>&mainTitle=<%=wbo.getAttribute("issueTitle")%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>')" class="button">
        </DIV> 
        
        <fieldset align="center" class="set" >
            <legend align="<%=align%>">
                
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">   <%=viewTaskDate%>
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend >
            
            <br><br>
            
            <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="800" CELLPADDING="0" CELLSPACING="0" STYLE="border-center-WIDTH:1px;">
               <!-- <th style="<%=style%>" class="td"><Font COLOR="red"> <H3><%=Schedule_Information%></H3></FONT></th>-->
                <TR h>
                    <% for(int i = 1;i<t - 1;i++) {
                    %>
                    <TD bgcolor="#D8D8D8">
                        <center><B><font size="5" style="font-weight:bold"><%=issueTitle[i]%></B></font> </center>
                    </TD>
                    <%
                    }
                    %>
                    
                </TR>
                <TR>
                    <%while(e.hasMoreElements()) {
                    wbo = (WebBusinessObject) e.nextElement();
                    %>
                    <% for(int i = 1;i<t - 1;i++) {
                    %>
                    <% if (i == 2) {
                    attValue = (String) wbo.getAttribute(issueAtt[i]);
                    siteName = (WebBusinessObject) projectMgr.getOnSingleKey(attValue);
                    attValue = siteName.getAttribute("projectName").toString();
                    %>
                    <TD BGCOLOR="#F8F8F8">
                        <b> <font size="2" style="font-weight:bold"> <%=attValue%>  </font>  </b>
                        
                    </TD>
                    <%} else { %>
                    <TD BGCOLOR="#F8F8F8">
                        <b>  <font size="2" style="font-weight:bold">  <%=wbo.getAttribute(issueAtt[i])%></font> </b>
                    </TD>
                    
                    <%
                    }}
                    
                    
                    
                    
                    attValue = (String) wbo.getAttribute(issueAtt[t]);
                    if(attValue.equalsIgnoreCase("Resolved") || attValue.equalsIgnoreCase("Finished")) {
                    bCheck = true;
                    //t++;
                    for(int j = 0; j < 3; j++) {
                    sTemp[j] = (String) wbo.getAttribute(issueAtt[t + j + 1]);
                    }
                    }
                    %>
                    
                    <%
                    }
                    %>
                </TR>
            </TABLE>
            <br><br>
            <TABLE  ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="800" CELLPADDING="0" CELLSPACING="0" STYLE="border-center-WIDTH:1px;">
               <!-- <th  style="<%=style%>" class="td"> <BR><Font COLOR="red"><H3><%=Schedule_History%></H3></FONT><th>-->
                <TR>
                    <% for(int i = 0;i<s;i++) {
                    %>
                    <TD bgcolor="#808000">
                        <center> <font color="white" size="5" style="font-weight:bold"> <B><%=issueStatusTitle[i]%></B></font></center>
                    </TD>
                    <%
                    }
                    %>
                </TR>
                <%
                e = issueStatusList.elements();
                issueStatusList = null;
                while(e.hasMoreElements()) 
                {
                wbo = (WebBusinessObject) e.nextElement();
                %>
                <TR>
                    <% for(int i = 0;i<s;i++) 
                    {
                    attValue = (String) wbo.getAttribute(issueStatusAtt[i]);
                    if(i == 0){
                        Hashtable tableStatus = configFileMgr.getJobOrderStatus(attValue);
                         if(stat.equals("En")){
                             attValue = tableStatus.get("DescEn").toString();
                         }else{
                            attValue = tableStatus.get("DescAr").toString();
                         }
                    %>
                     <TD STYLE="text-align:center" width="300" BGCOLOR="#F8F8F8">
                       <font size="2" style="font-weight:bold"> <b>  <%=attValue%> <b> </font>     
                    </TD>
                    <%    
                    }else if(attValue != null && attValue.equalsIgnoreCase("2010-31-12 00:00:00 am"))
                    {
                    attValue = "Open";
                    %>
                    <TD STYLE="text-align:center" width="300" BGCOLOR="#F8F8F8">

                        <b> <font size="2" style="font-weight:bold"> <%=attValue%></font> <b>

                    </TD>
                    <%
                    }else if(i == 2){
                        attValue = DateAndTimeControl.getDelayTime((String) wbo.getAttribute(issueStatusAtt[1]), (String) wbo.getAttribute(issueStatusAtt[2]), stat);
                    %>
                    <TD STYLE="text-align:center" width="300" BGCOLOR="#F8F8F8">

                        <b> <font size="2" style="font-weight:bold"> <%=attValue%></font> <b>

                    </TD>
                    <%
                    }
                    else if(attValue == null)
                    {
                      attValue=inCAseOfNull;
                      %>
                      <TD STYLE="text-align:center" width="300" BGCOLOR="#F8F8F8">

                        <b><font size="2" style="font-weight:bold"> <%=noDesc%></font> <b>

                    </TD>
                      <%
                    }else if(attValue.equals(" ")){
                    %>
                    <TD STYLE="text-align:center" width="300" BGCOLOR="#F8F8F8">

                        <b><font size="2" style="font-weight:bold"> <%=noDesc%></font> <b>

                    </TD>
                    <%
                    }
                    else if(i == 3 || i==1)
                    {
                    %>
                    <TD STYLE="text-align:center" width="300" BGCOLOR="#F8F8F8">
                        
                        <b><font size="2" style="font-weight:bold"> <%=attValue%></font> <b>
                        
                    </TD>
                    <%
                    }
                    }
                    %>
                </TR>
                <%
                }
                %>
                <TR>
                    <!--
            <TD colspan="4" align="right">
                <B>Total :</B>
            </TD>
            <TD>
                    <B><%//=iTotal%></B>
            </TD>
            -->
                </TR>
            </TABLE>
            <br><br><br>
           <%-- <%
            if(bCheck) {
            %>
            
            <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="800" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                <th class="td" style="<%=style%>"> <Font COLOR="Blue"><H5><%=DFV%></H5></FONT></th>
                <TR>
                    <% for(int i = t + 1; i < t + 4; i++) {
                    %>
                    <TD  bgcolor="#C8D8F8"><B><%=issueTitle[i]%></B></TD>
                    <%
                    }
                    %>
                </TR>
                <TR><%for(int i = 0; i < 3; i++)
                    {
                    %>
                    
                    <TD><%=sTemp[i]%></TD>
                    <%
                    }
                    %>
                </TR>
            </TABLE>
            <%
            }
            %> --%>
            <br><br>
        </fieldset>
    </body>
</html>