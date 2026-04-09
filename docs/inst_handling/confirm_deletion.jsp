<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*, java.util.*,com.silkworm.common.*,com.docviewer.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
  
<HTML>

    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String instId = (String) request.getAttribute("instId");
    WebBusinessObject VO = (WebBusinessObject) request.getAttribute("viewOrigin");
    // String docTitle = (String) request.getAttribute("docTitle");
    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/CreateForm");
    TouristGuide tGuide1 = new TouristGuide("/com/docviewer/international/BasicOps");
    Document doc = (Document)request.getAttribute("doc");
    String instTitle = (String) doc.getAttribute("instTitle");
    
    String unitScheduleID = (String) request.getAttribute("unitScheduleID");
    String filterName = (String) request.getAttribute("fName");
    String filterBack = (String) request.getAttribute("filterBack");
    String filterValue = (String) request.getAttribute("filterValue");
 
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - Confirm Deletion</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/InstReaderServlet?op=Delete&instId=<%=instId%>&filterBack=<%=filterBack%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>&unitScheduleID=<%=unitScheduleID%>";
        document.ISSUE_FORM.submit();  
        }

    </SCRIPT>

    <BODY>
      
     
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
         
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                        <%=tGuide.getMessage("deletedocument-areusure?")%>
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                  
                        <A HREF="<%=context%>/ScheduleServlet?op=ScheduleList">
                            <%=tGuide1.getMessage("backtolist")%>
                        </A>
                        <IMG VALIGN="BOTTOM"   SRC="images/arrow_left_red.gif">
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <A HREF="JavaScript: submitForm();">
                            <IMG SRC="images/del.gif">
                            <%=tGuide.getMessage("delete")%>
                        </A>
                  
                    </TD>
                </TR>
            </TABLE>

            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
            <TR>
                <TD class='td'>
                    &nbsp;
                </TD>
            </TR>

            </table

            <TABLE ALIGN="LEFT" CELLPADDING="0" CELLSPACING="0" BORDER="0">
            
              
            
                <TR>
                    <TD class='td'>
                        <LABEL FOR="ISSUE_TITLE">
                            <p><b> <%=tGuide.getMessage("doctitle")%><font color="#FF0000"> </font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input disabled type="TEXT" name="instTitle" value="<%=instTitle%>" ID="<%=instTitle%>" size="33"  maxlength="50">
                    </TD>
                </TR>

                <input  type="HIDDEN" name="instId" value="<%=instId%>">
        
          
          
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
                    