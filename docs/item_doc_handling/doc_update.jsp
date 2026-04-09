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
docTypeMgr.cashData();
ArrayList configType = docTypeMgr.getCashedTableAsBusObjects();
// get current date
Calendar cal = Calendar.getInstance();
WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowDate=sdf.format(cal.getTime());

String itemID = (String) request.getAttribute("itemID");
String categoryId = request.getParameter("categoryId").toString();
String pIndex = request.getParameter("pIndex");



String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String head_1,head_2;
String saving_status;
String title_1,title_2;
//String head_1,head_2,field_1_1;
String cancel_button_label;
String  doc_name, doc_type, doc_date, doc_desc;
//String view, edit, delete;
String save_button_label;
String parts_numb="&#1606;&#1578;&#1610;&#1580;&#1577; &#1575;&#1604;&#1593;&#1585;&#1590;";
String piece_word="&#1602;&#1591;&#1593;&#1577;";
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    
    doc_name="Document title";
    doc_type="Document type";
    doc_date="Document date";
    doc_desc="Document description";
    
    title_1="Update document";
    title_2="All information are needed";
    cancel_button_label=" Return to menu ";
    save_button_label="Update ";
    langCode="Ar";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    
    
    doc_name="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1608;&#1579;&#1610;&#1602;&#1607;";
    doc_type="&#1606;&#1608;&#1593; &#1575;&#1604;&#1608;&#1579;&#1610;&#1602;&#1607;";
    doc_date="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1608;&#1579;&#1610;&#1602;&#1607;";
    doc_desc="&#1608;&#1589;&#1601; &#1575;&#1604;&#1608;&#1579;&#1610;&#1602;&#1607;";
    
    head_1="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
    head_2="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
    
    title_1=" &#1578;&#1581;&#1583;&#1610;&#1579; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label=" &#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607; ";
    save_button_label=" &#1578;&#1581;&#1583;&#1610;&#1579;";
    langCode="En";
}

%>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>Document Viewer- Create Document</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
    <script type="text/javascript" src="js/epoch_classes.js"></script>
</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.DOC_FORM.action = "<%=context%>/ItemDocWriterServlet?op=Update&categoryId=<%=categoryId%>&itemID=<%=itemID%>&pIndex=<%=pIndex%>";
        document.DOC_FORM.submit();  
        }
        
        
 function changePage(url){
                window.navigate(url);
            }
            
        var docDate; 
        window.onload = function () {
            docDate  = new Epoch('epoch_popup','popup',document.getElementById('docDate'));

        }

</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>
<BODY>



<left>
<%    if(null!=status) {

%>

<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: changePage('<%=context%>/ItemDocReaderServlet?op=ListDoc&itemID=<%=itemID%>&categoryId=<%=categoryId%>&pIndex=<%=pIndex%>');" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
    
</DIV> 

<fieldset class="set" align="center">
<legend align="center">
    <table align="<%=align%>" dir=<%=dir%>>
        <tr>
            
            <td class="td">
                <font color="blue" size="6">    <%=title_1%>                
                </font>
                
            </td>
            
        </tr>
    </table>
</legend>
<br><br>
<table align="<%=align%>" dir=<%=dir%> >
    <tr>
    </td><td  class="td" align=right> <b> <font size=4 > <%=saving_status%> : <%=status%> </font> 
</td></tr></table>
<br>
<TABLE>
    <TR>
        <TD class='td'>
            &nbsp;
        </TD>
    </TR>
</TABLE>
<%
} else {
%>

<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: changePage('<%=context%>/ItemDocReaderServlet?op=ListDoc&itemID=<%=itemID%>&categoryId=<%=categoryId%>&pIndex=<%=pIndex%>');" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
    <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
</DIV> 

<fieldset class="set" align="center">
<legend align="center">
    <table align="<%=align%>" dir=<%=dir%>>
        <tr>
            
            <td class="td">
                <font color="blue" size="6">    <%=title_1%>                
                </font>
                <IMG WIDTH="20" HEIGHT="20" SRC="images/<%=iconFile%>">
            </td>
            
        </tr>
    </table>
</legend>
<br><br>
<FORM NAME="DOC_FORM" METHOD="POST">                       
    <table align="<%=align%>" dir=<%=dir%>>
        <tr>
            <td style="<%=style%>" class="td" valign="top" >
                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <input type=HIDDEN name="folderID" value="<%//=folderID%>" >
                    <TR>
                        <TD style="<%=style%>"class='td'>
                            <LABEL FOR="ISSUE_TITLE">
                                <p><b><%=doc_name%> </b>&nbsp;
                            </LABEL>
                        </TD>                                              
                        <TD style="<%=style%>" class='td'>
                            <input type="TEXT" name="docTitle" ID="docTitle" size="39" value="<%=docTitle%>" maxlength="50">
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
                                <p><b><%=doc_type%> </b>&nbsp;
                            </LABEL>
                        </TD>                                              
                        <TD style="<%=style%>" class='td'>
                            <SELECT name="configType" STYLE="width:170pt">
                                <sw:WBOOptionList wboList="<%=configType%>" displayAttribute="typeName" valueAttribute="typeID" scrollTo = "<%=doc.getAttribute("configItemType").toString()%>"/>
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
                                <p><b><%=doc_date%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <%
                        String url = request.getRequestURL().toString();
                        String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                        Calendar c = Calendar.getInstance();
                        TimeServices.setDate((String) doc.getAttribute("docDate"));
                        c.setTimeInMillis(TimeServices.getDate());
                        %>
                        <TD style="<%=style%>" class='td'>
                            <!--SELECT name="month" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getMonthsList()%>' scrollTo="<!%=TimeServices.getCurrentMonth()%>"/>
                                    </SELECT>
                                    <SELECT name="day" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getNumberSequenceListList(31)%>' scrollTo="<!%=TimeServices.getCurrentDay()%>"/>
                                    </SELECT>
                                    <SELECT name="year" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getYearList()%>' scrollTo="<!%=TimeServices.getCurrentYear()%>"/>
                                    </SELECT-->
                            <input name="docDate" id="docDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" >
                        </td>
                    </TR>
                    
                    <!--
                            <TR>
                            <TD class='td'>
                            <LABEL FOR="FACE_VALUE">
                    <p><b><%//=tGuide.getMessage("version")%>:</b>&nbsp;
                            </LABEL>
                            </TD>
                            <TD class='td'>
                    <input type="TEXT" name="version" ID="version" size="10" value="<%//=(String) doc.getAttribute("versionNumber")%>" maxlength="10">
                            </TD>
                            </TR>
                            <TR>
                            <TD class='td'>
                            &nbsp;
                            </TD>
                            </TR>
                            <TR>
                            <TD class='td'>
                            <LABEL FOR="FACE_VALUE">
                    <p><b><%//=tGuide.getMessage("modifiedby")%>:</b>&nbsp;
                            </LABEL>
                            </TD>
                            <TD class='td'>
                    <input type="TEXT" name="modifiedBy" ID="modifiedBy" size="10" value="<%//=(String) doc.getAttribute("modifiedBy")%>" maxlength="10">
                            </TD>
                            </TR>
                            <TR>
                            <TD class='td'>
                            &nbsp;
                            </TD>
                            </TR>
                            <TR>
                            <TD class='td'>
                            <LABEL FOR="FACE_VALUE">
                    <p><b><%//=tGuide.getMessage("reviewedby")%>:</b>&nbsp;
                            </LABEL>
                            </TD>
                            <TD class='td'>
                    <input type="TEXT" name="reviewedBy" ID="reviewedBy" size="10" value="<%//=(String) doc.getAttribute("reviewedBy")%>" maxlength="10">
                            </TD>
                            </TR>
                            <TR>
                            <TD class='td'>
                            &nbsp;
                            </TD>
                            </TR>
                            <TR>
                            <TD class='td'>
                            <LABEL FOR="FACE_VALUE">
                    <p><b><%//=tGuide.getMessage("approvedby")%>:</b>&nbsp;
                            </LABEL>
                            </TD>
                            <TD class='td'>
                    <input type="TEXT" name="approvedBy" ID="approvedBy" size="10" value="<%//=(String) doc.getAttribute("approvedBy")%>" maxlength="10">
                            </TD>
                            </TR>
                            <TR>
                            <TD class='td'>
                            &nbsp;
                            </TD>
                            </TR>
                            <TR>
                            <TD class='td'>
                            <LABEL FOR="release_date">
                    <p><b><%//=tGuide.getMessage("releasedate")%>:</b>&nbsp;
                            </LABEL>
                            </TD>
                    //<%//TimeServices.//setDate((String) // doc.getAttribute("releaseDate"));%>
                            <TD class='td'>
                            <SELECT name="beginMonth" size=1>
                           
                            </SELECT>
                            <SELECT name="beginDay" size=1>
                              
                            </SELECT>
                            <SELECT name="beginYear" size=1>
                               

                            </SELECT>
                            </td>
                            </TR>
                            -->
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    <TR>
                        <TD style="<%=style%>"class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=doc_desc%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD style="<%=style%>"class='td'>
                            <TEXTAREA rows="5" name="description" cols="41"><%=doc.getAttribute("description").toString()%></TEXTAREA>
                        </TD>
                    </TR>
                </TABLE>	
            </td>
        </tr>
    </table>
    <input type="hidden" name="docID" value="<%=(String) doc.getAttribute("docID")%>">
    <input type="hidden" name="itemID" value="<%=itemID%>">
</FORM>
<%
TimeServices.setDate(lToday);
}
%>
<br><br><br>
</BODY>
</HTML>     
