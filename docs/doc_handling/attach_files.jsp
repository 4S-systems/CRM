<%@ page import="com.silkworm.common.*,com.docviewer.db_access.*,com.silkworm.util.DateAndTimeConstants,java.util.ArrayList,com.silkworm.common.swWebApplication"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.db_access.FileMgr,com.silkworm.business_objects.WebBusinessObject"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<HTML>

    <%


        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String fileExtension = (String) request.getAttribute("fileExtension");

        String filterName = (String) request.getParameter("fName");
        String filterValue = (String) request.getParameter("filterValue");
        String projectname = (String) request.getParameter("projectName");

        // WebBusinessObject folder = (WebBusinessObject) request.getAttribute("folder");

        // String folderName = (String) folder.getAttribute("docTitle");
        // String folderID = (String) folder.getAttribute("docID");
        // System.out.println("0000000 Folder ID 000000 "+folderID+" 0000000000000 Folder Name 000000000000 "+folderName);
        String imAttStatus = (String) request.getAttribute("status");

        FileMgr fileMgr = FileMgr.getInstance();
        WebBusinessObject fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
        String iconFile = (String) fileDescriptor.getAttribute("iconFile");

        String fileMetaType = (String) fileDescriptor.getAttribute("metaType");


        TouristGuide tGuide = new TouristGuide("/com/docviewer/international/CreateForm");

        String[] allFiles = (String[]) request.getAttribute("allfiles");

        String issueid = (String) request.getAttribute("issueId");
        String docType = (String) request.getAttribute("docType");

        String op = null;

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, sTitle, docty, sCancel, sOk, sSelect, sAttach, sAttachingStatus;
        String fStatus;
        String sStatus;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            docty = "Document type must be";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            sTitle = "Attach Document";
            sCancel = "Back";
            sOk = "Attach";
            langCode = "Ar";
            sSelect = "Select Document Type";
            sAttach = "Attach document before filling data";
            sAttachingStatus = "Attaching Status";
            sStatus = "File Attached Successfully";
            fStatus = "Fail To Attach This File";

        } else {
            align = "center";
            dir = "RTL";
            docty = "نوع المستند لابد ان يكون";
            style = "text-align:Right";
            lang = "English";
            sTitle = "&#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
            sCancel = "&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
            sOk = "&#1573;&#1585;&#1601;&#1602; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
            langCode = "En";
            sSelect = "&#1573;&#1582;&#1578;&#1575;&#1585; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
            sAttach = "&#1573;&#1585;&#1601;&#1602; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583; &#1602;&#1576;&#1604; &#1605;&#1604;&#1574; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578;";
            sAttachingStatus = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1573;&#1585;&#1601;&#1575;&#1602;";

            sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1585;&#1601;&#1600;&#1575;&#1602; &#1575;&#1604;&#1600;&#1605;&#1600;&#1604;&#1600;&#1601; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
            fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1605; &#1575;&#1604;&#1575;&#1585;&#1601;&#1600;&#1575;&#1602;";
        }

    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer- Create Document</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function attachImage()
        {    if(checktype()){
                document.IMG_FORM.action = "<%=context%>/ImageWriterServlet?op=AttachImage&fileExtension=<%=fileExtension%>&issueId=<%=issueid%>&docType=<%=docType%>&fName=<%=filterName%>&filterValue=<%=filterValue%>&projectName=<%=projectname%>";
                document.IMG_FORM.submit();  }
        }
        function cancelForm()
        {    
            var filter='<%=filterName%>';
            if(filter.match("searchbyid"))
            {
                document.IMG_FORM.action  = "<%=context%>/SearchServlet?op=SearchJobOrderTab&issueID=<%=issueid%>";
                document.IMG_FORM.submit();  
            }else{
                document.IMG_FORM.action = "<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueid%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
                document.IMG_FORM.submit();  
            }
        }
        function getFileExtension(filename)
        {
            var ext = /^.+\.([^.]+)$/.exec(filename);
            return ext == null ? "" : ext[1];
        }
        function checktype(){
            var file=document.getElementById("docTypeid").value;
            var file1=document.getElementById("file1").value;     
            if(getFileExtension(file1)!=file){             
                document.getElementById("s").innerHTML="<%=docty%>"+"<br>"+file;
                return false;
            }
            return true;
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>

        <FORM name="IMG_FORM" action="<%=context%>/ImageWriterServlet?op=SaveDoc" method="post" enctype="multipart/form-data">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            <button  onclick="JavaScript: attachImage();" class="button"><%=sOk%><IMG HEIGHT="15" SRC="images/attach.gif"></button>
            <br><br>   
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                <%=sTitle%> <IMG WIDTH="20" HEIGHT="20" SRC="images/<%=iconFile%>">
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <center><font size=4 color="red" ><div id="s"></div></font></center>
                    <% if (null != imAttStatus) {
                            if (imAttStatus.equalsIgnoreCase("ok")) {
                    %>  
                <tr>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="black"><%=sStatus%></font> 
                        </td>                    
                    </tr> </table>
                </tr>
                <%
                } else {%>
                <tr>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="red" ><%=fStatus%></font> 
                        </td>                    
                    </tr> </table>
                </tr>
                <%}
                    }
                %>
                <TABLE ALIGN="CENTER" DIR="<%=dir%>" name="SUB_TABLE" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR COLSPAN="2" ALIGN="CENTER">
                        <TD class='td'>
                           
                            <input type=HIDDEN name="docType"id="docTypeid" value="<%=docType%>" >
                            <input type=HIDDEN name="issueId" value="<%=issueid%>" >
                        </td>
                    </tr>
                    <TR COLSPAN="2" ALIGN="CENTER">
                        <TD class='td'>
                            <LABEL FOR="FILE_CHOOSER">
                                <p><b><%=sSelect%> [<%=fileDescriptor.getAttribute("fileType")%>]</b>&nbsp;
                            </LABEL>
                        </td>
                        <TD class='td'>
                            <input type="file" id="file1" name="file1">
                        </td>
                    </tr>
                    <tr>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </tr>
                </table>
            </fieldset>
        </form>
    </BODY>
</HTML>     
