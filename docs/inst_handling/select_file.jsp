<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.international.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.docviewer.db_access.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants,com.silkworm.db_access.FileMgr"%>
<%@ page import="com.silkworm.common.TimeServices"%>


<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <%
    String fileExtension = (String) request.getAttribute("fileExtension");
    ImageMgr imageMgr = ImageMgr.getInstance();
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    WebBusinessObject webIssue = (WebBusinessObject) request.getAttribute("webIssue");
    
    ArrayList ArchiveFile = new ArrayList();
    ArchiveFile.add("Word file");
    ArchiveFile.add("Exel File");
    ArchiveFile.add("PowerPoint file");
    ArchiveFile.add("AdobAcrobat File");
    ArchiveFile.add("Html File");
    ArchiveFile.add("Text File");
    ArchiveFile.add("OutLook File");
    ArchiveFile.add("MSP File");
    ArchiveFile.add("Visio File");
    ArchiveFile.add("WinAce File");
    ArchiveFile.add("IMG File");
    
    String status = (String) request.getAttribute("Status");
    
    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/CreateForm");
    
    String unitScheduleID = (String) request.getAttribute("unitScheduleID");
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new issue</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
       function submitForm()
   {    
      document.ISSUE_FORM.action = "<%=context%>/InstWriterServlet?op=GetDocForm&unitScheduleID=<%=unitScheduleID%>";
      document.ISSUE_FORM.submit();  
   }
    </SCRIPT>
    
    <BODY>
        <left>     
        
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            
            
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                        SELECT A FILE
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                        
                        <A HREF="<%=context%>/ScheduleServlet?op=ScheduleList">                        
                            Cancel
                            <IMG SRC="images/leftarrow.gif">
                        </A>
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        
                        
                        <A HREF="JavaScript: submitForm();">
                            <IMG SRC="images/don.gif">
                            <%=tGuide.getMessage("confirm")%>
                            
                        </A>
                    </td>
                </TR>
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                    <input type=HIDDEN name="unitScheduleID" value="<%=unitScheduleID%>" >
                    <input type=HIDDEN name="fileExtension" value="<%=fileExtension%>" >
                </TR>
            </TABLE>
            
            
            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b><font color="#FF0000">*</font>Select a File:</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <SELECT name="DocType">
                            <sw:OptionList optionList='<%=ArchiveFile%>' scrollTo = ""/>
                            
                        </SELECT>
                    </TD>
                    
                    
                    <TD class='td'>
                    </TD>
                </TR>
                
            </TABLE>  
        </FORM>
    </BODY>
</HTML>     
