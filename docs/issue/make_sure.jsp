<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    String issueTitle = (String) request.getAttribute("issueTitle");
  
    String issueId = (String) request.getAttribute("issueId");
    // AssignedIssueState ais = (AssignedIssueState) request.getAttribute("state");
    
    String filterName = (String) request.getAttribute("filterName");
    String filterValue = (String) request.getAttribute("filterValue");
    %>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    // tGuide = new TouristGuide("/com/docviewer/international/DocOnlineMenu");
    
    String context= metaMgr.getContext();
    
    String projectname = (String) request.getParameter("projectName");
    String addToURL="";
    if(request.getAttribute("case")!=null){
        addToURL="&title="+(String)request.getAttribute("title")+"&unitName="+(String)request.getAttribute("unitName");
        filterName="StatusProjctListTitle";        
    }
    String CancelForm="op="+filterName+"&filterValue="+filterValue+"&projectName="+projectname;
    CancelForm+=addToURL;
    CancelForm=CancelForm.replace(' ','+');
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,tit,save,cancel,TT,desc;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        tit="Delete Schedule - Are you Sure ?";
        save="Delete";
        cancel="Back To List";
        TT="Task Title ";
        desc="Description";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        tit=" &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
        save=" &#1573;&#1581;&#1584;&#1601;";
        cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        TT="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        desc="&#1575;&#1604;&#1608;&#1589;&#1601;";
        }
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new Schedule</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

   function submitForm()
   {    
      document.ISSUE_FORM.action = "<%=context%>/IssueServlet?op=delete&projectName=<%=projectname%>";
      document.ISSUE_FORM.submit();  
   }
   
     function cancelForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/SearchServlet?<%=CancelForm%>";
        document.ISSUE_FORM.submit();  
        }
        
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
    </SCRIPT>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    <BODY>
        
        
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            
            <%
            if(request.getAttribute("case")!=null){
            %>
            <INPUT TYPE="HIDDEN" NAME="case" VALUE="<%=(String)request.getAttribute("case")%>">
            <INPUT TYPE="HIDDEN" NAME="title" VALUE="<%=(String)request.getAttribute("title")%>">
            <INPUT TYPE="HIDDEN" NAME="unitName" VALUE="<%=(String)request.getAttribute("unitName")%>">
            <%
            
            }
            %>
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
                <button    onclick="submitForm()" class="button"><%=save%>    <IMG SRC="images/save.gif"></button>
            </DIV> 
            <br><br>
            <fieldset align=center class="set">
                <legend align="center">
                    
                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6"><%=tit%> 
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend >
                
            <br><br>
                <TABLE ALIGN="<%=align%>"   CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="<%=dir%>">
                
                <TR>
                   
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="ISSUE_TITLE">
                            <p><b><%=TT%> <font color="#FF0000"> </font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"  class='td'>
                        <input disabled type="TEXT" name="issueTitle" value="<%=issueTitle%>" ID="<%=issueTitle%>" size="33"  maxlength="50">
                    </TD>
                    
                   
                </TR>
                
                <input  type="HIDDEN" name="issueId" value="<%=issueId%>">
               <input type=HIDDEN name="filterName" value="<%=filterName%>">
            <input type=HIDDEN name="filterValue" value="<%=filterValue%>">
            
            </TABLE>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
