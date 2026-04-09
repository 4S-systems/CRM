<%@ page import="com.silkworm.common.*,com.docviewer.db_access.*,com.silkworm.util.DateAndTimeConstants,java.util.ArrayList,com.silkworm.common.swWebApplication"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.db_access.FileMgr,com.silkworm.business_objects.WebBusinessObject"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
  
<HTML>

    <%


        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String fileExtension = (String) request.getAttribute("fileExtension");
        String imAttStatus = (String) request.getAttribute("status");

        FileMgr fileMgr = FileMgr.getInstance();
        WebBusinessObject fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
        String iconFile = (String) fileDescriptor.getAttribute("iconFile");

        String fileMetaType = (String) fileDescriptor.getAttribute("metaType");


        TouristGuide tGuide = new TouristGuide("/com/docviewer/international/CreateForm");

        String[] allFiles = (String[]) request.getAttribute("allfiles");

        String unitScheduleID = (String) request.getAttribute("unitScheduleID");
        String docType = (String) request.getAttribute("docType");
        
        String op=null;

    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer- Create Document</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">


        function attachImage()
        {    
        document.IMG_FORM.action = "<%=context%>/InstWriterServlet?op=AttachImage&fileExtension=<%=fileExtension%>&unitScheduleID=<%=unitScheduleID%>&docType=<%=docType%>";
        document.IMG_FORM.submit();  
        }
    </SCRIPT>



    <BODY>
      
   

  

        <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            <TR VALIGN="MIDDLE">
                <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                    <%=tGuide.getMessage("archivedoc")%>
                    <IMG WIDTH="20" HEIGHT="20" SRC="images/<%=iconFile%>"
                </TD>

              
                <TD CLASS="tabletitle" STYLE="">
                    <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                </TD>
                <TD CLASS="tableright" colspan="3">
                    <A HREF="<%=context%>/ScheduleServlet?op=ScheduleList">                        
                    Cancel
                    <IMG SRC="images/leftarrow.gif">
                    <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">

                    <%
                        if(null!=allFiles && (allFiles.length!=0)) {
                int s = allFiles.length;
                int i = 0;
                for(i=0;i<s;i++) {

                    %>
                    <IMG   SRC="images/<%=iconFile%>">
                    <%=allFiles[i]%>
                              
                                
                    <%
                        }

                    %>
                                
                    <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">  
            
                    <%
                            }
                    %>

                    <A HREF="JavaScript: attachImage();">
                        <IMG SRC="images/attach.gif">
                        <%=tGuide.getMessage("attachimage")%>
                    </A>
                    <% //if(fileMetaType.equalsIgnoreCase("image"))
                        // {
                    %>                      
                    <!--          
                    <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                    <IMG SRC="images/don.gif">
                    <A HREF="<%=context%>/ImageWriterServlet?op=DoneAttach&fileExtension=<%=fileExtension%>">
                    <%=tGuide.getMessage("doneattaching")%>
                    </A>
                    -->
                    <%
                        //  }
                    %>                 
                     
                    
                </TD>
            </TR>
        </TABLE>

  
        <table> 
        <tr><td>
        </td></tr>
        <tr><td class="mes" align=center> </td></tr> </table>      
              
        <% if(null!=imAttStatus)
            {
        %>
        <table> 
        <tr><td>
        </td></tr>
        <tr><td class="mes" align=center>   <%=tGuide.getMessage("docstatus")%>  :<%=imAttStatus%> </td></tr> </table>
        <%
            }
        %>

        <FORM name="IMG_FORM" action="<%=context%>/ImageWriterServlet?op=SaveDoc" method="post" enctype="multipart/form-data">
        <TABLE name="SUB_TABLE" CELLPADDING="0" CELLSPACING="0" BORDER="0">

                 
        <TR COLSPAN="2" ALIGN="CENTER">
        <TD class='td'>
        <font color="#FF0000"> <b> <%=tGuide.getMessage("attachbefore")%> </b></font>
        <input type=HIDDEN name="docType" value="<%=docType%>" >
        <input type=HIDDEN name="unitScheduleID" value="<%=unitScheduleID%>" >
        </td>
                    
                      
        </tr>
                    
        <TR COLSPAN="2" ALIGN="CENTER">
        <TD class='td'>
        <LABEL FOR="FILE_CHOOSER">
            <p><b><%=tGuide.getMessage("selectimagefile")%>[<%=fileDescriptor.getAttribute("fileType")%>]</b>&nbsp;
        </LABEL>
        </td>
        <TD class='td'>
                        
        <input type="file" name="file1">
                           
        </td>
                    
                      
                      
        </tr>
        </table>
        </form>
                     

     
   

    </BODY>
</HTML>     
                    