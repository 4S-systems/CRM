<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

AppConstants appCons = new AppConstants();
String[] issueAtt = appCons.getIssueAttributes();
int s = issueAtt.length;

Vector issueList = (Vector) request.getAttribute("issues");
WebBusinessObject wbo = null;
int flipper = 0;
String bgColor = null;

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
}

%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new issue</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    <!-- Begin hiding Javascript
     function submitForm()
      {
    
      document.ISSUE_LISTING_FORM.action = "/Tracker/IssueServlet?op=ListTimeBound";
      document.ISSUE_LISTING_FORM.submit();  
   }
      
-->
    </script>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    
    <BODY>
        <left>
        
        <FORM NAME="ISSUE_LISTING_FORM" METHOD="POST">
            
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>"
                       onclick="reloadAE('<%=langCode%>')" STYLE="background:#cc6699;font-size:15;color:white;font-weight:bold; ">
            </DIV> 
            <TABLE  stylel="position:absolute;top:400px;left:30px;border-right-WIDTH:1px"  WIDTH="600" CELLPADDING="0" CELLSPACING="0" dir="<%=dir%>">
                
                
                
                <TR>
                    <TD CLASS="SP_line2">
                        Month
                    </TD>
                    <TD CLASS="SP_line2">
                        Day
                    </TD>
                    <TD CLASS="SP_line2" STYLE="border-right-WIDTH:1;">
                        Year
                    </TD>
                </TR>
                <tr>
                    <TD CLASS="SP_line1">
                        
                        <SELECT name="startMonth" size=1>
                            <sw:OptionList optionList='<%= DateAndTimeConstants.getMonthsList()%>' scrollTo="<%=TimeServices.getCurrentMonth()%>"/>
                        </SELECT>
                    </td>
                    <TD CLASS="SP_line1">
                        <SELECT name="startDay" size=1 >
                            <sw:OptionList optionList='<%= DateAndTimeConstants.getNumberSequenceListList(31)%>' scrollTo="<%=TimeServices.getYesterday()%>"/>/>
                        </SELECT>
                    </td>
                    <TD CLASS="SP_line1">
                        <SELECT name="startYear" size=1>
                            <sw:OptionList optionList='<%= DateAndTimeConstants.getYearList()%>' scrollTo="<%=TimeServices.getCurrentYear()%>"/>
                        </SELECT>
                    </td>
                </tr>
                
                
                <TR>
                    <TR>
                        <TD COLSPAN="12" STYLE="border-top:none;border-bottom:none;border-right-WIDTH:1;HEIGHT:8;">
                            &nbsp;
                        </TD>
                    </TR>
                    
                    
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;<%=style%>;">
                        Issue Listing
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    
                    <TD CLASS="tableright" colspan="3">
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <A HREF="<%=context%>/main.jsp">
                            Cancel
                        </A>
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <A HREF="JavaScript: submitForm();">
                            Save Changes
                        </A>
                    </TD>
                    
                </TR>
            </TABLE>
            
            
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" dir="<%=dir%>">
                
                
                <%
                
                Enumeration e = issueList.elements();
                String status = null;
                
                while(e.hasMoreElements()) {
                    wbo = (WebBusinessObject) e.nextElement();
                    flipper++;
                    if((flipper%2) == 1) {
                        bgColor="#c8d8f8";
                    } else {
                        bgColor="white";
                    }
                %>
                
                <TR bgcolor="<%=bgColor%>">
                    <%
                    for(int i = 0;i<s;i++) {
                    %>
                    <TD nowrap align="<%=align%>" CLASS="cell" STYLE="padding-left:40;text-align:left;">
                        <DIV ID="links">
                            <b> <%=wbo.getAttribute(issueAtt[i])%> </b>
                        </DIV>
                    </TD>
                    <%
                    }
                    %>
                    <TD nowrap CLASS="cell" STYLE="padding-left:40;<%=style%>;">
                        <DIV ID="links">
                            <A HREF="<%=context%>/main.jsp">
                                View Details
                            </A>
                        </DIV>
                    </TD>
                    <%
                    status = (String) wbo.getAttribute("currentStatus");
                    if(status.equals("SCHEDULE")) {
                    
                    %>
                    <TD  nowrap CLASS="cell" style="border-left">
                        delete <INPUT TYPE="CHECKBOX" NAME="delete" value ="<%=wbo.getObjectKey()%>" ID="walid" CHECKED >
                        </TD>
                </TR>
                
                
                <%
                    }
                }
                
                %>
            </TABLE>
            
            
        </FORM>
    </body>
</html>