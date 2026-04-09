<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>

    <%
    String docId = (String) request.getAttribute("docId");
    String parentID = (String) request.getAttribute("parentID");
    
    String docTitle = (String) request.getAttribute("docTitle");
    // WebBusinessObject sepObj=(WebBusinessObject)request.getAttribute("sepObj");
    
    // docType.printSelf();
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");

    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - Confirm Delete Separator</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/AccntItemServlet?op=ConfirmDelete&docId=<%=docId%>&parentID=<%=parentID%>";
        document.ISSUE_FORM.submit();  
        }

    </SCRIPT>

    <BODY>
        <left>
     
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
         
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                        <%=tGuide.getMessage("delteaccount")%> -  <%=tGuide.getMessage("areyousure")%>
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                  
                        <A HREF="<%=context%>/AccntItemServlet?op=ListAccntItems&folderID=<%=parentID%>">
                            <%=tGuide.getMessage("backtolist")%>
                        </A>
                        <IMG VALIGN="BOTTOM"   SRC="images/arrow_left_red.gif">
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <A HREF="JavaScript: submitForm();">
                            <%=tGuide.getMessage("delteaccount")%>
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
                            <p><b><font color="#FF0000"><%=tGuide.getMessage("sptrwarning")%> </font></b>&nbsp;
                        </LABEL>
                    </TD>
                </TR>
              
            
                <TR>
                    <TD class='td'>
                        <LABEL FOR="ISSUE_TITLE">
                            <p><b><%=tGuide.getMessage("accounttitle")%>:<font color="#FF0000"> </font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input disabled type="TEXT" name="separatorName" value="<%=docTitle%>" ID="" size="33"  maxlength="50">
                    </TD>
                </TR>

                <input  type="HIDDEN" name="docID" value="<%=docId%>">
            
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
                    