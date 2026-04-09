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
String attachedFile = (String) request.getAttribute("attachedfile");

String unitScheduleID = (String) request.getAttribute("unitScheduleID");
String docType = (String) request.getAttribute("docType");

ArrayList configType = docTypeMgr.getCashedTableAsBusObjects();

// get current date
Calendar cal = Calendar.getInstance();
WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowDate=sdf.format(cal.getTime());
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
        document.DOC_FORM.action = "<%=context%>/InstWriterServlet?op=SaveDoc&unitScheduleID=<%=unitScheduleID%>&docType=<%=docType%>";
        document.DOC_FORM.submit();  
        }
        var dp_cal1; 
        window.onload = function () {
            dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('docDate'));

}

</SCRIPT>



<BODY>
<left>




<TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
    <TR VALIGN="MIDDLE">
        <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:right;">
            <%=tGuide.getMessage("archivedoc")%>
            <IMG WIDTH="20" HEIGHT="20" SRC="images/<%=iconFile%>"
             </TD>
        
        
        <TD CLASS="tabletitle" STYLE="">
            <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
        </TD>
        
        
        
        <TD CLASS="tableright" colspan="3">
            
            
            
            
            <A HREF="<%=context%>/ScheduleServlet?op=ScheduleList">
                <IMG SRC="images/cancel.gif">
                <%=tGuide.getMessage("cancel")%>
            </A>
            <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
            
            <%
            if(null!=attachedFile) {
            
            
            %>
            <A HREF="<%=context%>/ImageWriterServlet?op=DelImg&docTitle=<%=docTitle%>&docID=<%=docID%>&fileExtension=<%=fileExtension%>&fileName=<%=attachedFile%>">
                <IMG   SRC="images/delete.gif"  ALT="Delete Document"> 
            </A>
            
            <IMG   SRC="images/<%=iconFile%>">
            
            
            <%=attachedFile%>
            
            
            
            
            <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
            
            <%
            }
            %>
            <A HREF="JavaScript: submitForm();">
                <IMG SRC="images/save.gif">
                <%=tGuide.getMessage("savedoc")%>
            </A>          
            
        </TD>
    </TR>
</TABLE>


<FORM NAME="DOC_FORM" METHOD="POST">


<table>
    
    <td class="td" valign="top" >	
        
        
        <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
            <input type=HIDDEN name="docType" value="<%=docType%>">
            <input type=HIDDEN name="unitScheduleID" value="<%=unitScheduleID%>">
            <input type=HIDDEN name="docID" value="<%=docID%>" >          
            <input type=HIDDEN name="fileExtension" value="<%=fileExtension%>" > 
            <TR>
                <TD class='td'>
                    <LABEL FOR="ISSUE_TITLE">
                        <p><b><%=tGuide.getMessage("doctitle")%>:</b>&nbsp;
                    </LABEL>
                </TD>
                <TD class='td'>                            
                    <input <%=mode%> type="TEXT" name="docTitle" ID="docTitle" style="width:170pt" value="" maxlength="50">
                </TD>
            </TR>
            <TR>
                <TD class='td'>
                    &nbsp;
                </TD>
            </TR>
            <TR>
                
                <TD class='td'>
                    <LABEL FOR="ISSUE_TITLE">
                        <p><b><%=tGuide.getMessage("configitemtype")%>:</b>&nbsp;
                    </LABEL>
                </TD>                                              
                <TD class='td'>
                    <SELECT name="configType" STYLE="width:170pt">
                    <sw:WBOOptionList wboList="<%=configType%>" valueAttribute="typeID" displayAttribute="typeName" scrollTo = ""/>
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
                <TD class='td'>
                    <LABEL FOR="ISSUE_TITLE">
                        <p><b><%=tGuide.getMessage("docdate")%>:</b>&nbsp;
                    </LABEL>
                </TD>
                
                <TD class='td'>
                    <!--SELECT <%=mode%> name="year" size=1 STYLE="width:45pt">
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getYearList()%>' scrollTo="<!%=TimeServices.getCurrentYear()%>"/>

                                </SELECT>
                    <SELECT <%=mode%> name="day" size=1 STYLE="width:45pt">
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getNumberSequenceListList(31)%>' scrollTo="<!%=TimeServices.getCurrentDay()%>"/>
                                </SELECT>
                 
                    <SELECT <%=mode%> name="month" size=1 STYLE="width:75pt">
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getMonthsList()%>' scrollTo="<!%=TimeServices.getCurrentMonth()%>"/>
                                </SELECT-->
                    <input id="docDate" name="docDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" > 
                    
                </td>
                
            </TR>
            
            <TR>
                <TD class='td'>
                    &nbsp;
                </TD>
            </TR>
            
            <TR>
                <TD class='td'>
                    <LABEL FOR="str_Function_Desc" >
                        <p><b><%=tGuide.getMessage("docdesc")%>:</b>&nbsp;
                    </LABEL>
                </TD>
                <TD class='td'>
                    <TEXTAREA <%=mode%> rows="5" name="description" STYLE="width:170pt"></TEXTAREA>
                </TD>
                
            </TR>
            
        </TABLE>
        
        
        
        
    </TD>
    
    
    <%
    if(null!=imagePath) {
    
    %>
    
    <td class="td">
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



</FORM>


<TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
    <TR>
        <TD class='td'>
            &nbsp;
        </TD>
    </TR>
</TABLE>





</BODY>
</HTML>     
