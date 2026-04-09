<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.business_objects.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String issueTitle = (String) request.getAttribute("issueTitle");
    String issueId = (String) request.getAttribute("issueId");
    String issueType = (String) request.getAttribute("issueType");
    String issueState = (String) request.getAttribute("issueState");
    String filterName = (String) request.getParameter("filterName");
    String filterValue = (String) request.getParameter("filterValue");
    String projectname = (String) request.getAttribute("projectName");
    String safe=(String) request.getAttribute("safe");
    request.setAttribute("issueTitle", request.getAttribute("issueTitle"));
    request.setAttribute("issueId",request.getAttribute("issueId"));
    request.setAttribute("issueState",request.getAttribute("issueState"));
    request.setAttribute("filterName",request.getParameter("filterName"));
    request.setAttribute("filterValue",request.getParameter("filterValue"));
    request.setAttribute("projectName",request.getAttribute("projectName"));
    
    String Backurl=context+"/SearchServlet?op="+filterName+"&filterValue="+filterValue+"&projectName="+projectname;
    String goUrl=context+"/BookmarkServlet?op=save&filterName="+filterName+"&filterValue="+filterValue+"&projectName="+projectname;
    if(session.getAttribute("case")!=null){
        String blusUrl="&case=case39&unitName="+(String)session.getAttribute("unitName")+"&title="+(String)session.getAttribute("title");
        Backurl=context+"/SearchServlet?op=StatusProjctListTitle&filterValue="+filterValue+"&projectName="+projectname+blusUrl;
        goUrl+=blusUrl;
    }
    //AssignedIssueState ais = (AssignedIssueState) request.getAttribute("state");
    
    //String cvl = ais.getCentralViewLink();
    //System.out.println("View LINK is " + cvl);
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,bookmarkBrief,bookmarkDetails,BackToList,save,title;
    
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        BackToList = "Close ";
        save = "    Save   ";
        bookmarkBrief="Brief";
        bookmarkDetails="Details";
        title="Bookmark";
        
        
        
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:right";
        lang="   English    ";
        langCode="En";
        BackToList ="&#1573;&#1594;&#1604;&#1575;&#1602;";
        save = " &#1587;&#1580;&#1604;  ";
        bookmarkBrief="\u0645\u0644\u062e\u0635";
        bookmarkDetails="\u062a\u0641\u0627\u0635\u064a\u0644";
        title="&#1593;&#1604;&#1575;&#1605;&#1577; ";
        
    }
    
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new issue</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.ISSUE_FORM.action = "<%=goUrl%>";
        document.ISSUE_FORM.submit();  
        }
   

       function cancelForm(filter)
        {
            var searchtype=filter.substring(filter.indexOf(">")+1,filter.indexOf(":"));
            if(searchtype.match("begin")||searchtype.match("end")){
                   url= "<%=context%>/SearchServlet?op=getByoneDate&filterValue=" + filter;
                   window.navigate(url);
            }else   
            {
                window.navigate("<%=Backurl%>");
            }
           
          
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
       
       function goBack(){
           window.location.href = "<%=context%>/<%=filterName%>?op=<%=filterValue%>";
       }

    </SCRIPT>
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    <BODY>
        <input type="button" class="button"  value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" >
        <button  onclick="JavaScript: goBack();" class="button"><%=BackToList%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"> </button>
        <button  onclick="JavaScript:  submitForm();" class="button"><%=save%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <center>
                <fieldset class="set">
                    <legend align="center">
                        
                        <table dir=" <%=dir%>" align="<%=align%>">
                            <tr>
                                <td class="td">
                                    <font color="blue" size="6">  <%=title%>
                                    </font>
                                </td>
                            </tr>
                            
                        </table>
                    </legend >
                    <br>
                    <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                        <TR>
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="ISSUE_TITLE ">
                                    <p><b><%=bookmarkBrief%><font color="#FF0000">*</font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>" class='td'>
                                <input type="TEXT" name="issueTitle" value="" ID="issueTitle" size="34"  maxlength="50">
                            </TD>
                        </TR>
                        
                        
                        <TR>
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="str_Function_Desc">
                                    <p><b><%=bookmarkDetails%><font color="#FF0000">*</font></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD STYLE="<%=style%>" class='td'>
                                <TEXTAREA rows="5" name="bookmarkText" cols="27"></TEXTAREA>
                            </TD>
                        </TR>
                        <input type="hidden" name="issueType" value="<%=issueType%>" />
                        <input type=HIDDEN name="issueId" value="<%=issueId%>" >
                        <input type=HIDDEN name="issueTitle" value="<%=issueTitle%>" >
                        <input type=HIDDEN name="issueState" value="<%=issueState%>" >
                        <!--input type=HIDDEN name="viewOrigin" value="<%//=ais.getViewOrigin()%>" -->
                    </TABLE>
                    <BR>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>     
