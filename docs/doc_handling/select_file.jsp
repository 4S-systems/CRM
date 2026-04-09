<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.international.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.docviewer.db_access.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants,com.silkworm.db_access.FileMgr"%>
<%@ page import="com.silkworm.common.TimeServices"%>


<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <%
    //newwwww
    //    String destServlet = (String) request.getAttribute("destServlet");
    //    String operation = (String) request.getAttribute("operation");
    String fileExtension = (String) request.getAttribute("fileExtension");
    ImageMgr imageMgr = ImageMgr.getInstance();
    
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    WebBusinessObject webIssue = (WebBusinessObject) request.getAttribute("webIssue");
    
    
    // ProjectMgr projectMgr = ProjectMgr.getInstance();
    //FunctionMgr functionMgr = FunctionMgr.getInstance();
    //IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();
    //UrgencyMgr urgencyMgr = UrgencyMgr.getInstance();
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
    
    String filterName = (String) request.getParameter("fName");
    String filterValue = (String) request.getParameter("fValue");
    String projectname = (String) request.getParameter("projectName");
    
    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/CreateForm");
    //  String filterName = (String) request.getAttribute("filterName");
    //  String filterValue = (String) request.getAttribute("filterValue");
    
    // long lToday = TimeServices.getDate();
    
    String issueid = (String) request.getAttribute("issueId");
    
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, sTitle, sCancel, sOk, sSelect;
    
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        sTitle="Select Document Type";
        sCancel="Back";
        sOk="Ok";
        langCode="Ar";
        sSelect = "Select Type";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        sTitle="&#1573;&#1582;&#1578;&#1575;&#1585; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1604;&#1601;";
        sCancel="&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
        sOk="&#1605;&#1608;&#1575;&#1601;&#1602;";
        langCode="En";
        sSelect = "&#1573;&#1582;&#1578;&#1575;&#1585; &#1605;&#1604;&#1601;";
    }
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
          document.ISSUE_FORM.action = "<%=context%>/ImageWriterServlet?op=GetDocForm&fName=<%=filterName%>&filterValue=<%=filterValue%>&issueId=<%=issueid%>&projectName=<%=projectname%>";
          document.ISSUE_FORM.submit();  
        }
        function cancelForm()
        {    
            document.ISSUE_FORM.action = "<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueid%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
            document.ISSUE_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            <button  onclick="JavaScript:  submitForm();" class="button"><%=sOk%><IMG HEIGHT="15" SRC="images/don.gif"></button>
            <br>
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
                <TABLE ALIGN="center" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="text-align:right" class='td'>
                            <LABEL FOR="str_Function_Name">
                                <p><b><font color="#FF0000">*</font><%=sSelect%>
                                </b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="text-align:right"  class='td'>
                            <SELECT name="DocType">
                                <sw:OptionList optionList='<%=ArchiveFile%>' scrollTo = ""/>
                                
                            </SELECT>
                        </TD>
                    </TR>
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                </TABLE>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
