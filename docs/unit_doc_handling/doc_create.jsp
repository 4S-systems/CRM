<%@ page import="com.silkworm.common.*,com.docviewer.db_access.*,com.silkworm.util.DateAndTimeConstants,java.util.ArrayList,com.silkworm.common.swWebApplication"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.db_access.FileMgr,com.silkworm.business_objects.WebBusinessObject"%>
<%@ page import="com.docviewer.db_access.DocTypeMgr,java.util.*,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<HTML>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
String context = metaMgr.getContext();

String mode = "enabled";
WebBusinessObject folder = (WebBusinessObject) request.getAttribute("folder");
WebBusinessObject document = (WebBusinessObject) request.getAttribute("document");

String fileExtension = (String) request.getAttribute("fileExtension");

String docTitle = (String) request.getAttribute("docTitle");
String docID = (String) request.getAttribute("docID");
String imagePath = (String) request.getAttribute("imagePath");


FileMgr fileMgr = FileMgr.getInstance();
WebBusinessObject fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
String iconFile = (String) fileDescriptor.getAttribute("iconFile");
TouristGuide tGuide = new TouristGuide("/com/docviewer/international/CreateForm");
String attachedFile = (String) request.getAttribute("attachedfile");

String equipmentID = (String) request.getAttribute("equipmentID");
String docType = (String) request.getAttribute("docType");

ArrayList configType = docTypeMgr.getCashedTableAsBusObjects();

// get current date
Calendar cal = Calendar.getInstance();
WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowDate=sdf.format(cal.getTime());
String scheduleID = (String) request.getAttribute("scheduleID");


String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,tit,save,cancel,TT,SNA,tit1,RU,EMP,FTIT,FTYP,FDA,desc;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    tit="Attaching File";
    tit1="Delete Employee";
    save="Save";
    cancel="Back To List";
    TT="Select File Type ";
    SNA="Site Name";
    RU="Waiting Business Rule";
    EMP="Employee Name";
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
    tit="  &#1573;&#1585;&#1601;&#1575;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
    tit1="&#1581;&#1584;&#1601;   &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;";
    save=" &#1578;&#1587;&#1580;&#1610;&#1604;";
    cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    TT="&#1573;&#1582;&#1578;&#1575;&#1585; &#1605;&#1604;&#1601;";
    SNA="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    RU="&#1605;&#1606;&#1578;&#1592;&#1585; &#1602;&#1575;&#1593;&#1583;&#1577; &#1593;&#1605;&#1604;";
    EMP="&#1573;&#1587;&#1605; &#1575;&#1604;&#1608;&#1592;&#1601;";
    FTIT="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    FTYP="&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    FDA="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    desc="&#1575;&#1604;&#1608;&#1589;&#1601;";
    
}
String type= (String) request.getAttribute("type");
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
        document.DOC_FORM.action = "<%=context%>/UnitDocWriterServlet?op=SaveDoc&equipmentID=<%=equipmentID%>&docType=<%=docType%>";
        document.DOC_FORM.submit();  
        }
        
        
          function cancelForm()
        {    
        document.DOC_FORM.action = "<%=context%>/UnitDocReaderServlet?op=ViewImages&equipmentID=<%=equipmentID%>";
        document.DOC_FORM.submit();  
        }
                   var dp_cal1; 
        window.onload = function () {
            dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('docDate'));
        }

</SCRIPT>


<script src='ChangeLang.js' type='text/javascript'></script>
<LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">

<BODY>


<DIV align="left" STYLE="color:blue;">
    <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
    <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
    <button    onclick="submitForm()" class="button"><%=save%>   <IMG SRC="images/save.gif">  </button>
</DIV> 
<br><br>
<fieldset align=center class="set">
<legend align="center">
    
    <table dir=" <%=dir%>" align="<%=align%>">
        <tr>
            
            <td class="td">
                <font color="blue" size="6"><%=tit%>  <IMG WIDTH="20" HEIGHT="20" SRC="images/<%=iconFile%>">
                </font>
            </td>
        </tr>
    </table>
</legend >


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




<br><br>
<FORM NAME="DOC_FORM" METHOD="POST">
    <input type="hidden" name="type" id="type" value="<%=type%>"/>

<table align="<%=align%>" dir="<%=dir%>">
    <td class="td" valign="top" >	
        
        
        <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
            <input type=HIDDEN name="docType" value="<%=docType%>">
            <input type=HIDDEN name="equipmentID" value="<%=equipmentID%>">
            <input type=hidden name="docID" value="<%=docID%>" >          
            <input type=HIDDEN name="fileExtension" value="<%=fileExtension%>" > 
            <TR>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="ISSUE_TITLE">
                        <p><b><%=FTIT%></b>&nbsp;
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
                        <p><b><%=FTYP%></b>&nbsp;
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
                        <p><b><%=FDA%></b>&nbsp;
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
                    <input name="docDate" id="docDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" >
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
                        <p><b><%=desc%></b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>"  class='td'>
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



</fieldset>

</BODY>
</HTML>     
