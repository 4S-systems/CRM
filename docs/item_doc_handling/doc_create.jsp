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
String pIndex = request.getParameter("pIndex");

FileMgr fileMgr = FileMgr.getInstance();
WebBusinessObject fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
String iconFile = (String) fileDescriptor.getAttribute("iconFile");
TouristGuide tGuide = new TouristGuide("/com/docviewer/international/CreateForm");
String attachedFile = (String) request.getAttribute("attachedfile");

String itemID = (String) request.getAttribute("itemID");
String docType = (String) request.getAttribute("docType");

ArrayList configType = docTypeMgr.getCashedTableAsBusObjects();

// get current date
Calendar cal = Calendar.getInstance();
WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowDate=sdf.format(cal.getTime());


String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String saving_status,choose_file;
String title_1,title_2;
String choose_type;
//String cat_name, part_name, part_code, part_unit, store_name, part_price;
String doc_title, doc_type, doc_date, doc_desc;
String cancel_button_label, info;
String save_button_label;
if(stat.equals("En")){
    
    saving_status="Attaching status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    
    doc_title="Document title";
    doc_type="document type";
    doc_date="Document date";
    doc_desc="document description";
    
    
    
    
    
    info="Please attach a document before entering data";
    choose_type="Choose file type";
    title_1="Attach a document";
    choose_file="Choose file";
    cancel_button_label=" Return to menu ";
    save_button_label="Attach file";
    langCode="Ar";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1573;&#1585;&#1601;&#1575;&#1602;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    doc_title="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1608;&#1579;&#1610;&#1602;&#1607;";
    doc_type="&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    doc_date="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1608;&#1579;&#1610;&#1602;&#1607;";
    doc_desc="&#1608;&#1589;&#1601; &#1575;&#1604;&#1608;&#1579;&#1610;&#1602;&#1607;";
    
    
    
    
    lang="English";
    choose_type=" &#1573;&#1582;&#1578;&#1575;&#1585; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1604;&#1601;";
    info="&#1573;&#1585;&#1601;&#1602; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583; &#1602;&#1576;&#1604; &#1605;&#1604;&#1574; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; ";
    title_1=" &#1573;&#1585;&#1601;&#1575;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
    choose_file="&#1573;&#1582;&#1578;&#1575;&#1585; &#1575;&#1604;&#1605;&#1604;&#1601;";
    cancel_button_label=" &#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607; ";
    save_button_label="&#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
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
        document.DOC_FORM.action = "<%=context%>/ItemDocWriterServlet?op=SaveDoc&itemID=<%=itemID%>&docType=<%=docType%>&categoryId=<%=request.getAttribute("categoryId").toString()%>&pIndex=<%=pIndex%>";
        document.DOC_FORM.submit();  
        }
        
        var docDate; 
        window.onload = function () {
            docDate  = new Epoch('epoch_popup','popup',document.getElementById('docDate'));

        }

</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>


<BODY>
<left>

<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: changePage('<%=context%>/ItemsServlet?op=ShowItem&itemID=<%=itemID%>&categoryId=<%=request.getAttribute("categoryId").toString()%>&pIndex=<%=pIndex%>');" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
    <button  onclick="JavaScript: submitForm();" class="button"><%=save_button_label%><IMG SRC="images/attach.gif"></button>
</DIV> 
<fieldset class="set" align="center">
<legend align="center">
    <table dir="<%=dir%>" align="<%=align%>">
        <tr>
            
            <td class="td">
                <font color="blue" size="6">    <%=title_1%>                
                </font>
                
            </td>
        </tr>
    </table>
</legend>



<TABLE dir="<%=dir%>" align="<%=align%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
    
    
    
    <TR VALIGN="MIDDLE">
        
        <%
        if(null!=attachedFile) {
        
        
        %>
        <A HREF="<%=context%>/ImageWriterServlet?op=DelImg&docTitle=<%=docTitle%>&docID=<%=docID%>&fileExtension=<%=fileExtension%>&fileName=<%=attachedFile%>&categoryId=<%=request.getAttribute("categoryId").toString()%>&pIndex=<%=pIndex%>">
            <IMG   SRC="images/delete.gif"  ALT="Delete Document"> 
        </A>
        
        <IMG   SRC="images/<%=iconFile%>">
        
        
        <%=attachedFile%>
        
        
        
        <%
        }
        %>
        
        
    </TR>
</TABLE>
<br><br>

<FORM NAME="DOC_FORM" METHOD="POST">


<table dir="<%=dir%>" align="<%=align%>">
    
    <td class="td" valign="top" >	
        
        
        <TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
            <input type=HIDDEN name="docType" value="<%=docType%>">
            <input type=HIDDEN name="itemID" value="<%=itemID%>">
            <input type=HIDDEN name="docID" value="<%=docID%>" >          
            <input type=HIDDEN name="fileExtension" value="<%=fileExtension%>" > 
            <TR>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="ISSUE_TITLE">
                        <p><b><%=doc_title%></b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>"  class='td'>                            
                    <input <%=mode%> type="TEXT" name="docTitle" ID="docTitle" style="width:170pt" value="" maxlength="50">
                </TD>
            </TR>
            <TR>
                <TD class='td'>
                    &nbsp;
                </TD>
            </TR>
            <TR>
                
                <TD STYLE="<%=style%>"  class='td'>
                    <LABEL FOR="ISSUE_TITLE">
                        <p><b><%=doc_type%></b>&nbsp;
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
                <TD STYLE="<%=style%>"  class='td'>
                    <LABEL FOR="ISSUE_TITLE">
                        <p><b><%=doc_date%></b>&nbsp;
                    </LABEL>
                </TD>
                
                <TD STYLE="<%=style%>"  class='td'>
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
                <TD STYLE="<%=style%>"  class='td'>
                    <LABEL FOR="str_Function_Desc" >
                        <p><b><%=doc_desc%></b>&nbsp;
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
        <table dir="<%=dir%>" align="<%=align%>">
            <tr>
                
                <img WIDTH="400" align="right" HEIGHT="300" name='docImage' alt='document image' src='<%=imagePath%><%=attachedFile%>' >  
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
<br><br>




</BODY>
</HTML>     
