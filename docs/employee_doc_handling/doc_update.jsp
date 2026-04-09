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

// get current date and Time
Calendar cal = Calendar.getInstance();
WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowDate=sdf.format(cal.getTime());

String empID = (String) request.getAttribute("empID");


String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String message=null;
String style=null;
String lang,langCode,tit,save,cancel,m1,m2,TT,SNA,tit1,RU,EMP,STAT,NO,FTIT, FTYP,FDA,desc;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    tit="Update File";
    tit1="Select File Type";
    save="Save";
    cancel="Cancel";
    TT="Select File Type ";
    SNA="Site Name";
    RU="Waiting Business Rule";
    EMP="Employee Name";
    STAT="Updating Status";
    NO="Attach File Before Filling Information";
    m1 = "The Saving Successed";
    m2 = "The Saving Faild";
    FTIT="Document Title";
    FTYP="Document Type";
    FDA="Document date";
    desc="Description";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    tit=" &#1578;&#1581;&#1583;&#1610;&#1579; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    tit1="&#1573;&#1582;&#1578;&#1575;&#1585; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    save=" &#1587;&#1580;&#1604;";
    cancel=" &#1573;&#1606;&#1607;&#1575;&#1569; ";
    TT="&#1573;&#1582;&#1578;&#1575;&#1585; &#1605;&#1604;&#1601;";
    SNA="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    RU="&#1605;&#1606;&#1578;&#1592;&#1585; &#1602;&#1575;&#1593;&#1583;&#1577; &#1593;&#1605;&#1604;";
    EMP="&#1573;&#1587;&#1605; &#1575;&#1604;&#1608;&#1592;&#1601;";
    m1 = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581; ";
    m2= "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    
    STAT=" &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    NO="&#1573;&#1585;&#1601;&#1602; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583; &#1602;&#1576;&#1604; &#1605;&#1604;&#1574; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578;";
    FTIT="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    FTYP="&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    FDA="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    desc="&#1575;&#1604;&#1608;&#1589;&#1601;";
    
}
%>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>Document Viewer- Create Document</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
    <script type="text/javascript" src="js/epoch_classes.js"></script>
</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.DOC_FORM.action = "<%=context%>/EmployeeDocWriterServlet?op=Update";
        document.DOC_FORM.submit();  
        }
        
          function cancelForm()
        {    
        document.DOC_FORM.action = "<%=context%>/EmployeeDocReaderServlet?op=ListDoc&empID=<%=empID%>";
        document.DOC_FORM.submit();  
        }
        
function reloadAE(nextMode){
      
       var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
            if (window.XMLHttpRequest)
            { 
                req = new XMLHttpRequest(); 
            } 
               else if (window.ActiveXObject)
            { 
                req = new ActiveXObject("Microsoft.XMLHTTP"); 
            } 
            req.open("Post",url,true); 
            req.onreadystatechange =  callbackFillreload;
            req.send(null);
      
      }

       function callbackFillreload(){
         if (req.readyState==4)
            { 
               if (req.status == 200)
                { 
                     window.location.reload();
                }
            }
       }
       
         var dp_cal1;      
            window.onload = function () {
            dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('docDate'));
      };

</SCRIPT>

<BODY>
    
    <FORM NAME="DOC_FORM" METHOD="POST">  
        
        <%    if(null!=status) {
    if (status.equalsIgnoreCase("ok")){
        message=m1;
    }else{
        message=m2;
    }
        
        %>
        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            <button    onclick="cancelForm()" class="button"><%=cancel%>  <IMG SRC="images/cancel.gif"></button>
            
        </DIV> 
        <br><br>
        <fieldset align=center class="set">
            <legend align="center">
                
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"><%=tit%>  
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
            <table dir="<%=dir%>" align="<%=align%>" >
                <tr>
                    <td class="td">
                        <b><FONT COLOR="red" size=4 ><%=message%> </font></b>
            </td></tr></table>
            <br>
        </fieldset>
        <%
        } else {
        %>
        
        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            <button    onclick="cancelForm()" class="button"><%=cancel%>  <IMG SRC="images/cancel.gif"></button>
            <button    onclick="submitForm()" class="button"><%=save%>   <IMG SRC="images/save.gif">  </button>
        </DIV> 
        <br><br>
        <fieldset align=center class="set">
        <legend align="center">
            
            <table dir=" <%=dir%>" align="<%=align%>">
                <tr>
                    
                    <td class="td">
                        <font color="blue" size="6"><%=tit%> <IMG WIDTH="20" HEIGHT="20" SRC="images/<%=iconFile%>" 
                                                                  </font>
                    </td>
                </tr>
            </table>
        </legend >
        
        
        <table align="<%=align%>" dir="<%=dir%>">
            <tr>
                <td style="<%=style%>" class="td" valign="top" >
                    <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                        <input type=HIDDEN name="folderID" value="<%//=folderID%>" >
                        <TR>
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="ISSUE_TITLE">
                                    <p><b><%=FTIT%></b>&nbsp;
                                </LABEL>
                            </TD>                                            
                            <TD style="<%=style%>"class='td'>
                                <input type="TEXT" STYLE="width:230px" name="docTitle" ID="docTitle" size="39" value="<%=docTitle%>" maxlength="50">
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
                                    <p><b><%=FTYP%></b>&nbsp;
                                </LABEL>
                            </TD>                                              
                            <TD style="<%=style%>"class='td'>
                                <% 
                                    String  configItemType = doc.getAttribute("configItemType").toString();
                                %>
                                <SELECT name="configType" STYLE="width:230px">
                                    <sw:WBOOptionList wboList="<%=configType%>" displayAttribute="typeName" valueAttribute="typeID" scrollTo = "<%=configItemType%>"/>
                                </SELECT>  
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
                                    <p><b><%=FDA%></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD style="<%=style%>"class='td'>
                                <!--SELECT name="month" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getMonthsList()%>' scrollTo="<!%=TimeServices.getCurrentMonth()%>"/>
                                    </SELECT>
                                    <SELECT name="day" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getNumberSequenceListList(31)%>' scrollTo="<!%=TimeServices.getCurrentDay()%>"/>
                                    </SELECT>
                                    <SELECT name="year" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getYearList()%>' scrollTo="<!%=TimeServices.getCurrentYear()%>"/>
                                    </SELECT-->
                                <input id="docDate" name="docDate" type="text" value="<%=nowDate%>"><img src="images/showcalendar.gif" > 
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
                            <TD STYLE="<%=style%>" class='td'>
                                <LABEL FOR="str_Function_Desc" >
                                    <p><b><%=desc%></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD style="<%=style%>"class='td'>
                                <TEXTAREA rows="5" STYLE="width:230px" name="description" cols="41"><%=doc.getAttribute("description").toString()%></TEXTAREA>
                            </TD>
                        </TR>
                    </TABLE>	
                </td>
            </tr>
        </table>
        <input type="hidden" name="docID" value="<%=(String) doc.getAttribute("docID")%>">
        <input type="hidden" name="empID" value="<%=empID%>">
    </FORM>
    </FIELDSET>
    <%
    TimeServices.setDate(lToday);
    
        }
    %>
    
</BODY>
</HTML>     
