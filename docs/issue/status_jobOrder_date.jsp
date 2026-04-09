<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*,com.tracker.db_access.IssueMgr,java.text.*,java.util.Date"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Projects List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <%
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    String[] taskAttributes = {"title" ,"name"};
    String[] taskListTitles = {"&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;", "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;" ,"&#1581;&#1584;&#1601;"};
    
    int s = taskAttributes.length;
    int t = s+1;
    int iTotal = 0;
    
    String attName = null;
    String attValue = null;
    String cellBgColor = null;
    
    
    
    Vector  projectsList = (Vector) request.getAttribute("data");
    
    
    WebBusinessObject wbo = null;
    int flipper = 0;
    String bgColor = null;
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    String issueId = (String) request.getAttribute("issueId");
    String filterName= request.getParameter("filterName");
    String filterValue= request.getParameter("filterValue");
    
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String Massage =null;
    
    String lang, langCode, sTitle, sCancel, sQuickSummary, sBasicOperations, sMoreDetails, sTaskNo,sInfoDate,issueTitle1,issueTitle2,issueTitle3,issueTitle4,start,end,haveNotStart,haveNotEnd,msg1,msg2,msg3;
    String sameTime;
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        sTitle="Job Order Status Date";
        sCancel="Back";
        langCode="Ar";
        sQuickSummary="Quick Summary";
        sBasicOperations="Basic Oprations";
        sTaskNo = "Tasks Number";
        taskListTitles[0] = "Task Code";
        taskListTitles[1] = "Task Name";
        taskListTitles[2] = "Delete";
        sInfoDate = "Information Status Date";
        issueTitle1="Description";
        issueTitle2="Planning Date";
        issueTitle3="Actual Date";
        issueTitle4 = "Difference by Date";
        start="Start Job Date";
        end="End Job Date";
        haveNotStart="Haven't Start Job";
        haveNotEnd="Job order doesn?t finish";
        msg1="Early";
        msg2="Exactly";
        msg3="Delayed";

    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        sTitle="&#1578;&#1608;&#1575;&#1585;&#1610;&#1582; &#1581;&#1575;&#1604;&#1577; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        sCancel="&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
        langCode="En";
        sQuickSummary="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        sBasicOperations="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        sMoreDetails = "&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1571;&#1603;&#1579;&#1585;";
        sTaskNo = "&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1607;&#1575;&#1605;";
       sInfoDate="&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1578;&#1608;&#1575;&#1585;&#1610;&#1582; &#1581;&#1575;&#1604;&#1577; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        issueTitle1="&#1575;&#1604;&#1608;&#1589;&#1601;";
        issueTitle2="&#1575;&#1604;&#1605;&#1582;&#1591;&#1591;";
        issueTitle3="&#1575;&#1604;&#1581;&#1602;&#1610;&#1602;&#1610;";
        issueTitle4 = "&#1575;&#1604;&#1601;&#1585;&#1602; &#1576;&#1575;&#1604;&#1610;&#1608;&#1605;";
        start="&#1576;&#1583;&#1575;&#1610;&#1577; &#1575;&#1604;&#1593;&#1605;&#1604;";
       end = "&#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1593;&#1605;&#1604;";
        haveNotStart="&#1604;&#1605; &#1610;&#1576;&#1583;&#1571; &#1575;&#1604;&#1593;&#1605;&#1604; &#1576;&#1593;&#1583;";
        haveNotEnd="&#1575;&#1604;&#1593;&#1605;&#1604; &#1604;&#1605; &#1610;&#1606;&#1578;&#1607;&#1609; &#1576;&#1593;&#1583;";
        msg1="&#1578;&#1576;&#1603;&#1610;&#1585;";
        msg2="&#1576;&#1575;&#1604;&#1590;&#1576;&#1591;";
        msg3="&#1578;&#1571;&#1582;&#1610;&#1585;";
        }
DateFormat dateformater = new SimpleDateFormat("yyyy/MM/dd");
    %>
    <script type="text/javascript">
    function cancelForm()
    {    
        document.ISSUE_FORM.action = "<%=context%>/AssignedIssueServlet?op=viewdetails&issueId=<%=issueId%>&filterValue=<%=filterValue%>&filterName=<%=filterName%>";
        document.ISSUE_FORM.submit();  
    }
    </script>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <body>
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <%=sTitle%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <TABLE  ALIGN="CENTER" DIR="<%=dir%>"  WIDTH="450" CELLPADDING="0" CELLSPACING="0">
                    <TR>
                        <TD CLASS="td">
                            &nbsp;
                        </TD>
                    </TR>
                    <TR>
                        <TD CLASS="td" COLSPAN="4" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
                            <B><%=sInfoDate%></B>
                        </TD>
                        
                    </TR>
                    <TR CLASS="head">
                        
                        <TD nowrap CLASS="firstname" WIDTH="150" bgcolor="#9B9B00" STYLE="border-WIDTH:0;color:white;" nowrap>
                                <font size="2" ><%=issueTitle1%></font>
                            </TD>
                            <TD nowrap CLASS="firstname" WIDTH="150" bgcolor="#9B9B00" STYLE="border-WIDTH:0;color:white;" nowrap>
                                <font size="2" ><%=issueTitle2%></font>
                            </TD>
                            <TD nowrap CLASS="firstname" WIDTH="150" bgcolor="#9B9B00" STYLE="border-WIDTH:0;color:white;" nowrap>
                                <font size="2" > <%=issueTitle3%></font>
                            </TD>
                            <TD nowrap CLASS="firstname" WIDTH="150" bgcolor="#9B9B00" STYLE="border-WIDTH:0;color:white;" nowrap>
                                <font size="2" ><%=issueTitle4%></font>     
                            </TD>
                        
                    </TR>
                    <%
                    Enumeration e = projectsList.elements();
                    while(e.hasMoreElements()) {
                        iTotal++;
                        wbo = (WebBusinessObject) e.nextElement();
                         
                      
                    %>
                    <TR>
                        <TD  BGCOLOR="#DDDD00" STYLE="<%=style%>" nowrap  CLASS="cell" >
                            <DIV >
                                <b><font size="2" color="blue"> <%=start%></font> </b>
                            </DIV>
                        </TD>
                        
                        <TD  BGCOLOR="#DDDD00" STYLE="<%=style%>" nowrap  CLASS="cell" >
                            <DIV >
                                <b><font size="2" color="red"> <%= wbo.getAttribute("expectedBeginDate")%></font> </b>
                            </DIV>
                        </TD>
                        <% if(null!=wbo.getAttribute("actualBeginDate")){ 
                            String expectedBeginDate = (String)wbo.getAttribute("expectedBeginDate");
			    String actualBeginDate = (String)wbo.getAttribute("actualBeginDate");
                            String expBeginDate[] = expectedBeginDate.split("-");
                            String actBeginDate[] = actualBeginDate.split("-");
                            %>
                        <TD  BGCOLOR="#DDDD00" STYLE="<%=style%>" nowrap  CLASS="cell" >
                            <DIV >
                                <b> <font size="2" color="red"><%= wbo.getAttribute("actualBeginDate")%></font> </b>
                            </DIV>
                        </TD>
                    <% 
                       
                       Date dateEXBDate = dateformater.parse(expBeginDate[0]+"/"+expBeginDate[1]+"/"+expBeginDate[2]);
                        long expBdate= dateEXBDate.getTime();
                        
                        Date dateActDate = dateformater.parse(actBeginDate[0]+"/"+actBeginDate[1]+"/"+actBeginDate[2]);
                        long expActualdate=dateActDate.getTime();
                        long DiffBDate = expActualdate - expBdate;
                        DiffBDate = (((DiffBDate / 1000) / 60) / 60) / 24;
                        %>
                        <% if(expActualdate>expBdate){
                            Massage=msg3;
                        }else if(expActualdate<expBdate){
                            Massage=msg1;
                        }else if(expActualdate==expBdate){
                            Massage=msg2;
                            }
                        %>
                        <TD  BGCOLOR="#DDDD00" STYLE="<%=style%>" nowrap  CLASS="cell" >
                            <DIV >
                                <% if(DiffBDate == 0) {%>
                                <b><font size="2" color="blue"><%=Massage%></font></b>
                                <% } else { %>
                                <b><font size="2" color="red"> <%=DiffBDate%></font> <font size="2" color="blue"><%=Massage%></font></b>
                                <% } %>
                            </DIV>
                        </TD>
                        <% } else { %>
                        <TD  BGCOLOR="#DDDD00" STYLE="<%=style%>" nowrap  CLASS="cell" >
                            <DIV >
                                <b><font size="2" color="red"> <%=haveNotStart%></font> </b>
                            </DIV>
                        </TD>
                        <TD  BGCOLOR="#DDDD00" STYLE="<%=style%>" nowrap  CLASS="cell" >
                            <DIV >
                                <b><font size="2" color="red"><%=haveNotStart%></font></b>
                            </DIV>
                        </TD>
                        <% } %>
                        
                        <%
                        }
                        %>
                        
                    </TR>
                           
                    <%
                    Enumeration ele = projectsList.elements();
                    while(ele.hasMoreElements()) {
                        iTotal++;
                        wbo = (WebBusinessObject) ele.nextElement();
                        

                      
                    %>
                    <TR>
                        <TD  BGCOLOR="#DDDD00" STYLE="<%=style%>" nowrap  CLASS="cell" >
                            <DIV >
                                <b><font size="2" color="blue"> <%=end%></font> </b>
                            </DIV>
                        </TD>
                        
                        <TD  BGCOLOR="#DDDD00" STYLE="<%=style%>" nowrap  CLASS="cell" >
                            <DIV >
                                <b><font size="2" color="red"> <%= wbo.getAttribute("expectedEndDate")%> </font></b>
                            </DIV>
                        </TD>
                        <% if(null!=wbo.getAttribute("actualEndDate")){
                         String expectedEndDate = (String)wbo.getAttribute("expectedEndDate");
			 String actualEndDate = (String)wbo.getAttribute("actualEndDate");
                            String expEndDate[] = expectedEndDate.split("-");
                            String actEndDate[] = actualEndDate.split("-");
                            %>
                        <TD  BGCOLOR="#DDDD00" STYLE="<%=style%>" nowrap  CLASS="cell" >
                            <DIV >
                                <b><font size="2" color="red"> <%= wbo.getAttribute("actualEndDate")%></font> </b>
                            </DIV>
                        </TD>
                        <% 
                        Date dateEXEndDate = dateformater.parse(expEndDate[0]+"/"+expEndDate[1]+"/"+expEndDate[2]);
                        long expEdate= dateEXEndDate.getTime();
                        Date dateActEndDate = dateformater.parse(actEndDate[0]+"/"+actEndDate[1]+"/"+actEndDate[2]);
                        long expActualdate=dateActEndDate.getTime();
                        long DiffEndDate = expActualdate - expEdate;
                        DiffEndDate = (((DiffEndDate / 1000) / 60) / 60) / 24;
                        %>
                        <% if(expActualdate>expEdate){
                            Massage=msg3;
                        }else if(expActualdate<expEdate){
                            Massage=msg1;
                        }else if(expActualdate==expEdate){
                            Massage=msg2;
                            }
                        %>
                        <TD  BGCOLOR="#DDDD00" STYLE="<%=style%>" nowrap  CLASS="cell" >
                            <DIV >
                                <b><font size="2" color="red"> <%=DiffEndDate%></font><font size="2" color="blue"><%=Massage%></font></b>
                            </DIV>
                        </TD>
                        <% } else { %>
                        <TD  BGCOLOR="#DDDD00" STYLE="<%=style%>" nowrap  CLASS="cell" >
                            <DIV >
                                <b><font size="2" color="red"> <%=haveNotEnd%></font> </b>
                            </DIV>
                        </TD>
                        <TD  BGCOLOR="#DDDD00" STYLE="<%=style%>" nowrap  CLASS="cell" >
                            <DIV >
                                <b><font size="2" color="red"><%=haveNotEnd%></font></b>
                            </DIV>
                        </TD>
                        <% } %>
                        <%
                        }
                        %>
                        
                    </TR>
                    
                    <TR>
                        <TD CLASS="td">
                            &nbsp;
                        </TD>
                    </TR>
                </table>
            </fieldset>
        </form>
    </body>
</html>
