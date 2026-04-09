<%@ page import="com.docviewer.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    
    FileMgr fileMgr = FileMgr.getInstance();
    String backTarget=null;
    response.addHeader("Pragma","No-cache");
    response.addHeader("Cache-Control","no-cache");
    response.addDateHeader("Expires",1);
    Vector imagePath = (Vector) request.getAttribute("imagePath");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    backTarget=context+"/main.jsp";
    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/BasicOps");
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - Document Details</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.DOC_FORM.action = "<%=context%>/ImageWriterServlet?op=CheckDoc";
        document.DOC_FORM.submit();  
        }


        function attachImage()
        {    
        document.IMG_FORM.action = "<%=context%>/ImageWriterServlet?op=SaveDoc";
        document.IMG_FORM.submit();  
        }
        
    </SCRIPT>
    
    <BODY>
        
        
        <TABLE ALIGN="RIGHT" DIR="RTL" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            <TR VALIGN="MIDDLE">
                <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:right;">
&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1589;&#1608;&#1585;
                </TD>
                
                <TD STYLE="text-align:left" CLASS="tableright" colspan="3">
                    
                    
                    
                    <IMG VALIGN="BOTTOM"   SRC="images/arrow_left_red.gif">
                    <A HREF="JavaScript: history.back(0);"<%//=backTarget%>>
                        <%=tGuide.getMessage("backtolist")%>
                    </A>
                    
                    
                </TD>
                
            </TR>
            
        </table>
        <br><br>
            <table align="right" dir="rtl">
            <%
            for(int i = 0; i < imagePath.size(); i++){
            %>
            <TR>
                <TD class='td'>
                    <img name='docImage' align="right" alt='document image' src='<%=imagePath.get(i).toString()%>' >
                </TD>
            </tr>
            <%
            }
            %>
        </table>
    </BODY>
</HTML>     
