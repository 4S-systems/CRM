<%@ page import="com.silkworm.common.*,com.docviewer.db_access.*,com.silkworm.util.DateAndTimeConstants,java.util.ArrayList,com.silkworm.common.swWebApplication"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.db_access.FileMgr,com.silkworm.business_objects.WebBusinessObject"%>
<%@ page import="com.docviewer.db_access.DocTypeMgr,java.util.*,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>

<HTML>
    
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
    ImageMgr imageMgr = ImageMgr.getInstance();
    String context = metaMgr.getContext();
    
    String mode = "enabled";
    WebBusinessObject folder = (WebBusinessObject) request.getAttribute("folder");
    WebBusinessObject document = (WebBusinessObject) request.getAttribute("document");
    
    String fileExtension = (String) request.getAttribute("fileExtension");
    
    String docTitle = (String) request.getAttribute("docTitle");
    String docID = (String) request.getAttribute("docID");
    
    //String folderName = (String) folder.getAttribute("docTitle");
    // String folderID = (String) folder.getAttribute("docID");
    
    String imagePath = (String) request.getAttribute("imagePath");
    
    
    FileMgr fileMgr = FileMgr.getInstance();
    WebBusinessObject fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
    String iconFile = (String) fileDescriptor.getAttribute("iconFile");
    
    
    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/CreateForm");
    
    // String[] allFiles = (String[]) request.getAttribute("allfiles");
    String attachedFile = (String) request.getAttribute("attachedfile");
    
    String issueid = (String) request.getAttribute("issueId");
    String docType = (String) request.getAttribute("docType");
    
    ArrayList configType = docTypeMgr.getCashedTableAsBusObjects();
    
    String filterName = (String) request.getParameter("fName");
    String filterValue = (String) request.getParameter("filterValue");
    
    String projectname = (String) request.getParameter("projectName");
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
    String lang, langCode, sTitle, sCancel, sOk, sDocTitle, sDocType, sDocDate, sDesc;
    
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        sTitle="Attaching Document";
        sCancel="Back";
        sOk="Save";
        langCode="Ar";
        sDocTitle = "Document Title";
        sDocType = "Document Type";
        sDocDate = "Document Date";
        sDesc = "Description";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        sTitle="&#1573;&#1585;&#1601;&#1575;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
        sCancel="&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
        sOk="&#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
        langCode="En";
        sDocTitle = tGuide.getMessage("doctitle");
        sDocType = tGuide.getMessage("configitemtype");
        sDocDate = tGuide.getMessage("docdate");
        sDesc = tGuide.getMessage("docdesc");
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
            document.DOC_FORM.action = "<%=context%>/ImageWriterServlet?op=SaveDoc&issueId=<%=issueid%>&docType=<%=docType%>&fName=<%=filterName%>&filterValue=<%=filterValue%>&projectName=<%=projectname%>";
            document.DOC_FORM.submit();  
        }
        function cancelForm()
        {    
            document.DOC_FORM.action = "<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueid%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
            document.DOC_FORM.submit();  
        }
        var dp_cal1;      
     window.onload = function () {
        dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('docDate'));
      };
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    
    <BODY>
        <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
        <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
        <button  onclick="JavaScript:  submitForm();" class="button"><%=sOk%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
        <br>
        <FORM NAME="DOC_FORM" METHOD="POST">
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
                
                <table align="center" dir="<%=dir%>" >
                    <TR>
                        <td class="td" valign="top" >	
                            
                            <TABLE align="center" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                                <input type=HIDDEN name="docType" value="<%=docType%>">
                                <input type=HIDDEN name="issueId" value="<%=issueid%>">
                                <input type=HIDDEN name="docID" value="<%=docID%>" >          
                                <input type=HIDDEN name="fileExtension" value="<%=fileExtension%>" > 
                                <TR>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b><%=sDocTitle%>:</b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>                            
                                        <input <%=mode%> type="TEXT" name="docTitle" ID="docTitle" style="width:170pt" value="" maxlength="50">
                                    </TD>
                                </TR>
                                <TR>
                                    <TD class='td'>
                                        &nbsp;
                                    </TD>
                                </TR>
                                <TR>
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b><%=sDocType%>:</b>&nbsp;
                                        </LABEL>
                                    </TD>                                              
                                    <TD STYLE="<%=style%>" class='td'>
                                        <SELECT name="configType" STYLE="width:170pt">
                                            <sw:WBOOptionList wboList="<%=configType%>" valueAttribute="typeID" displayAttribute="typeName" scrollTo = ""/>
                                            
                                        </SELECT>  
                                    </TD>
                                </TR>
                                
                                
                                <TR>
                                    <TD class='td'>
                                        &nbsp;
                                    </TD>
                                </TR>
                                <%
                                String url = request.getRequestURL().toString();
                                String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                                Calendar c = Calendar.getInstance();
                                %>
                                <TR>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b><%=sDocDate%>:</b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <!--SELECT <%=mode%> name="year" size=1 STYLE="width:45pt">
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getYearList()%>' scrollTo="<!%=TimeServices.getCurrentYear()%>"/>

                                </SELECT>
                                        <SELECT <%=mode%> name="day" size=1 STYLE="width:45pt">
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getNumberSequenceListList(31)%>' scrollTo="<!%=TimeServices.getCurrentDay()%>"/>
                                </SELECT>
                 
                                        <SELECT <%=mode%> name="month" size=1 STYLE="width:75pt">
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getMonthsList()%>' scrollTo="<!%=TimeServices.getCurrentMonth()%>"/>
                                </SELECT-->
                                        <input id="docDate" name="docDate" type="text" value="<%=nowDate%>"><img src="images/showcalendar.gif" > 
                                    </td>
                                    
                                </TR>
                                
                                <TR>
                                    <TD class='td'>
                                        &nbsp;
                                    </TD>
                                </TR>
                                
                                <TR>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="str_Function_Desc" >
                                            <p><b><%=sDesc%>:</b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <TEXTAREA <%=mode%> rows="5" name="description" STYLE="width:170pt"></TEXTAREA>
                                    </TD>
                                    
                                </TR>
                                
                            </TABLE>
                            
                            
                            
                            
                        </TD>
                        
                        
                        <%
                        if(null!=imagePath) {
                        
                        %>
                        
                        <td STYLE="<%=style%>" class="td">
                            <table>
                                <tr>
                                    
                                    <img WIDTH="400" HEIGHT="300" name='docImage' alt='document image' src='<%=imagePath%><%=attachedFile%>' >  
                                </tr>
                                
                                
                            </table>   
                        </td>
                        
                        <%
                        
                        }
                        %>
                        
                    </tr>
                    
                </table>
                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                </TABLE>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
