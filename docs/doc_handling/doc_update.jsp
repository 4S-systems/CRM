<%@ page import="com.silkworm.common.*,com.docviewer.db_access.*,com.silkworm.util.DateAndTimeConstants,java.util.ArrayList,com.silkworm.common.swWebApplication"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.db_access.FileMgr,com.silkworm.business_objects.WebBusinessObject"%>
<%@ page import="com.docviewer.db_access.DocTypeMgr"%>
<%@ page import="com.docviewer.db_access.ImageMgr"%>
<%@ page import="com.docviewer.business_objects.Document,java.util.*,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>

<HTML>
    
    <%
    System.out.println("in the jsp");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    // DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
    ImageMgr imageMgr = ImageMgr.getInstance();
    FileMgr fileMgr = FileMgr.getInstance();
    String fileExtension = null;
    String docTitle =null;
    //String folderName = null;
    WebBusinessObject fileDescriptor = null;
    String iconFile = null;
    String context = metaMgr.getContext();
    Document doc = (Document) request.getAttribute("docObject");
    ImageMgr imgMgr = ImageMgr.getInstance();
    String filterName= (String) request.getAttribute("filterName");
    String filterValue= (String) request.getAttribute("filterValue");
    //ArrayList sptrs = null;
    if(doc != null) {
        fileExtension = (String) doc.getAttribute("docType");
        docTitle = doc.getAttribute("docTitle").toString();
        if(docTitle.indexOf("-") >= 0) {
            docTitle = docTitle.substring(docTitle.indexOf("-") + 1);
        }
        //folderName = (String) doc.getAttribute("account");
        fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
        iconFile = (String) fileDescriptor.getAttribute("iconFile");
        // Document sptrDoc = (Document) imageMgr.getOnSingleKey(doc.getAttribute("parentID").toString());
        //String folderID = (String) sptrDoc.getAttribute("parentID");
        // sptrs = imgMgr.getCntrDocsChildren(folderID);
    }
    String status = (String) request.getAttribute("Status");
    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/CreateForm");
    // ArrayList docType = docTypeMgr.getCashedTableAsArrayList();
    long lToday = TimeServices.getDate();
    DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
    
    // ArrayList configType = docTypeMgr.getCashedTableAsArrayList();
    ArrayList configType = docTypeMgr.getCashedTableAsBusObjects();
    
    // get current date and Time
    Calendar cal = Calendar.getInstance();
    WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
    String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowDate=sdf.format(cal.getTime());
    
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, sTitle, sCancel, sOk, sDocTitle, sDocType, sDocDate, sDesc, sUpdateStatus;
    
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        sTitle="Update Document";
        sCancel="Back";
        sOk="Update";
        langCode="Ar";
        sDocTitle = "Document Title";
        sDocType = "Document Type";
        sDocDate = "Document Date";
        sDesc = "Description";
        sUpdateStatus = "Saving Status";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        sTitle="&#1578;&#1581;&#1583;&#1610;&#1579; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
        sCancel="&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
        sOk="&#1587;&#1580;&#1604; &#1575;&#1604;&#1578;&#1581;&#1583;&#1610;&#1579;";
        langCode="En";
        sDocTitle = tGuide.getMessage("doctitle");
        sDocType = tGuide.getMessage("configitemtype");
        sDocDate = tGuide.getMessage("docdate");
        sDesc = "&#1575;&#1604;&#1608;&#1589;&#1601;";
        sUpdateStatus = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer- Create Document</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.DOC_FORM.action = "<%=context%>/ImageWriterServlet?op=Update&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.DOC_FORM.submit();  
        }
        
        function cancelForm()
        {    
            document.DOC_FORM.action = "<%=context%>/ImageReaderServlet?op=ListDoc&issueId=<%=doc.getAttribute("issueid")%>&fName=<%=filterName%>&fValue=<%=filterValue%>";
            document.DOC_FORM.submit();  
        }
        
         var dp_cal1;      
     window.onload = function () {
        dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('docDate'));
      };

    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM NAME="DOC_FORM" METHOD="POST"> 
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            
            <%    if(null!=status) {
            
            %>
            <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
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
                <table dir="<%=dir%>" align="center" >
                    <tr>
                        <td class="td">
                            <IMG VALIGN="BOTTOM" HEIGHT="20"  SRC="images/aro.JPG">
                        </td><td class="td">
                            <b><FONT size=4 ><%=sUpdateStatus%> : <%=status%></font></b>
                </td></tr></table>
                
                <TABLE>
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                </TABLE>
            </FIELDSET>
            <%
            } else {
            %>
            <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            <button  onclick="JavaScript:  submitForm();" class="button"><%=sOk%><IMG HEIGHT="15" SRC="images/save.gif"></button>
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
                <table align="center" dir="<%=dir%>">
                    <tr>
                        <td style="<%=style%>" class="td" valign="top" >
                            <TABLE ALIGN="center" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                                <input type=HIDDEN name="folderID" value="<%//=folderID%>" >
                                <TR>
                                    <TD style="<%=style%>" class='td'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b><%=sDocTitle%>: </b>&nbsp;
                                        </LABEL>
                                    </TD>                                              
                                    <TD style="<%=style%>" class='td'>
                                        <input type="TEXT" style="width:230px" name="docTitle" ID="docTitle" size="33" value="<%=docTitle%>" maxlength="50">
                                    </TD>
                                </TR>
                                
                                
                                <TR>
                                    <TD class='td'>
                                        &nbsp;
                                    </TD>
                                </TR>
                                <TR>
                                    
                                    <TD style="<%=style%>" class='td'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b><%=sDocType%>: </b>&nbsp;
                                        </LABEL>
                                    </TD>                                              
                                    <TD style="<%=style%>" class='td'>
                                        <% String configTypeinList = (String) doc.getAttribute("configItemType");%>
                                        <SELECT name="configType" style="width:230px">
                                            <sw:WBOOptionList wboList="<%=configType%>" displayAttribute="typeName" valueAttribute="typeID" scrollTo = "<%=configTypeinList%>"/>
                                        </SELECT>  
                                    </TD>
                                </TR>
                                
                                
                                <TR>
                                    <TD class='td'>
                                        &nbsp;
                                    </TD>
                                </TR>
                                <TR>
                                    <TD style="<%=style%>" class='td'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b><%=sDocDate%>:</b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD style="<%=style%>" class='td'>
                                        <input id="docDate" name="docDate" type="text" value="<%=nowDate%>"><img src="images/showcalendar.gif" > 
                                    </td>
                                </TR>
                                <TR>
                                    <TD class='td'>
                                        &nbsp;
                                    </TD>
                                </TR>
                                <TR>
                                    <TD style="<%=style%>" class='td'>
                                        <LABEL FOR="str_Function_Desc">
                                            <p><b><%=sDesc%>:</b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD style="<%=style%>" class='td'>
                                        <TEXTAREA rows="5" style="width:230px" name="description" cols="25"><%=doc.getAttribute("description").toString()%></TEXTAREA>
                                    </TD>
                                </TR>
                            </TABLE>	
                        </td>
                    </tr>
                </table>
                <input type="hidden" name="docID" value="<%=(String) doc.getAttribute("docID")%>">
            </fieldset>
        </FORM>
        <%
        TimeServices.setDate(lToday);
            }
        %>
    </BODY>
</HTML>     
