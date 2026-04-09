<%@ page import="com.docviewer.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>

<%

FileMgr fileMgr = FileMgr.getInstance();
WebBusinessObject fileDescriptor = null;
String backTarget=null;
response.addHeader("Pragma","No-cache");
response.addHeader("Cache-Control","no-cache");
response.addDateHeader("Expires",1);

Document doc = (Document) request.getAttribute("docObject");
fileDescriptor = fileMgr.getObjectFromCash(doc.getDocumentType());


//        WebBusinessObject VO = (WebBusinessObject) request.getAttribute("viewOrigin");
String imagePath = (String) request.getAttribute("imagePath");
//        String filter= (String) VO.getAttribute("filter");
//        String filterValue= (String)VO.getAttribute("filterValue");

String scheduleID = (String) request.getAttribute("scheduleID");
//         String projectname = (String) request.getAttribute("projectName");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

Document childDoc = null;
boolean bHasChild = false;

TouristGuide tGuide = new TouristGuide("/com/docviewer/international/BasicOps");
DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
ArrayList configType = docTypeMgr.getCashedTableAsArrayList();


String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,tit,save,cancel,TT,SNA,tit1,RU,EMP,STAT,NO,DT,DTY,SYS,EMPN,DA,name,ID,UD,desc;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    tit="Document Details";
    tit1="Select File Type";
    save="Attach";
    cancel="Back To List";
    TT="Select File Type ";
    SNA="Site Name";
    RU="Waiting Business Rule";
    EMP="Equipment Name";
    STAT="Attaching Status";
    NO="Attach File Before Filling Information";
    DT="Document Title";
    DTY="Document Type";
    SYS="System Id";
    EMPN="Equipment No.";
    DA="Document Date ";
    name="Attcher Name ";
    ID="Attcher NO";
    UD="Uplodaing Date";
    desc="Description";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    tit="                     &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; ";
    tit1="&#1573;&#1582;&#1578;&#1575;&#1585; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    save="&#1573;&#1585;&#1601;&#1602;";
    cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    TT="&#1573;&#1582;&#1578;&#1575;&#1585; &#1605;&#1604;&#1601;";
    SNA="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    RU="&#1605;&#1606;&#1578;&#1592;&#1585; &#1602;&#1575;&#1593;&#1583;&#1577; &#1593;&#1605;&#1604;";
    EMP="&#1573;&#1587;&#1605; &#1575;&#1604;&#1608;&#1592;&#1601;";
    STAT=" &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1573;&#1585;&#1601;&#1575;&#1602;";
    NO="&#1573;&#1585;&#1601;&#1602; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583; &#1602;&#1576;&#1604; &#1605;&#1604;&#1574; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578;";
    DT=tGuide.getMessage("doctitle");
    DTY=tGuide.getMessage("configitemtype");
    SYS=tGuide.getMessage("systemid");
    EMPN="&#1585;&#1602;&#1605; &#1571;&#1604;&#1605;&#1575;&#1603;&#1610;&#1606;&#1607;";
    DA=tGuide.getMessage("docdate");
    name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1585;&#1601;&#1602;";
    ID="&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1585;&#1601;&#1602;";
    UD="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1573;&#1585;&#1601;&#1575;&#1602;";
    desc="&#1575;&#1604;&#1608;&#1589;&#1601;";
}

%>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>Document Viewer - Document Details</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.DOC_FORM.action = "<%=context%>/ImageWriterServlet?op=CheckDoc";
        document.DOC_FORM.submit();  
        }


        function attachImage()
        {    
        document.IMG_FORM.action = "<%=context%>/ImageWriterServlet?op=SaveDoc";
        document.IMG_FORM.submit();  
        }
         function cancelForm()
        {    
        <%
        String sType = new String("");
        if(request.getParameter("type") != null){
            sType = "&type=" + request.getParameter("type");
        }
        if(request.getParameter("equipmentCat") != null){
        %>
        document.DOC_FORM.action = "<%=context%>/ScheduleDocReaderServlet?op=ListDoc&scheduleID=<%=scheduleID%>&equipmentCat=<%=request.getParameter("equipmentCat")%>&source=\'cat\'<%=sType%>";
        <%
        } else {
        %>
        document.DOC_FORM.action = "<%=context%>/ScheduleDocReaderServlet?op=ListDoc&scheduleID=<%=scheduleID%>&equipmentID=<%=request.getParameter("equipmentID")%>&source=eqp";
        <%
        }
        %>
        document.DOC_FORM.submit();  
        } 
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>

<LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
<BODY>
<DIV align="left" STYLE="color:blue;">
    <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
    <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
    
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

<TABLE ALIGN="RIGHT" DIR="RTL" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
<TR VALIGN="MIDDLE">
    
    <%
    if(!doc.isImage()) {
    
    %>
    
    <%
    if(((String)doc.getAttribute("docType")).equals("doc")){
        System.out.println("-----> it's document");
    %>                 
    <A HREF="<%=context%>/ScheduleDocReaderServlet?op=ViewDocument&docType=<%=doc.getDocumentType()%>&docID=<%=(String) doc.getAttribute("docID")%>&metaType=<%=(String) doc.getAttribute("metaType")%>">
        <img  name='docImage' alt='document image' src="images/<%=fileDescriptor.getAttribute("iconFile")%>" >
    </A>  
    <%
    } //else if(((String)doc.getAttribute("docType")).equals("sptr")){
    // System.out.println("-----> it's NOT document");
    //System.out.println();
    //childDoc = doc.getViewDocumentLink((String) doc.getAttribute("docID"));
    if(childDoc != null){
        bHasChild = true;
    %>
    <A HREF="<%=context%>/ScheduleDocReaderServlet?op=ViewDocument&docType=doc&docId=<%=(String) childDoc.getAttribute("docID")%>&metaType=<%=(String) childDoc.getAttribute("metaType")%>">
        <img  name='docImage' alt='document image' src="images/<%=fileDescriptor.getAttribute("iconFile")%>" >
    </A>
    <%
    } else {
    %>
    <!--
    <img  name='docImage' alt='document image' src="images/<%=fileDescriptor.getAttribute("iconFile")%>" >
                    -->
    <%
    }
    // }
    //else{
    %>
    <!--
    <img  name='docImage' alt='document image' src="images/<%=fileDescriptor.getAttribute("iconFile")%>" >
                    -->
    <%//}
    }
    %>
    
    </TD>
</TR>
<TR>
    <TD class='td'>
        &nbsp;
    </TD>
</TR>
</TABLE>
<br><br><br> <Table ALIGN="<%=align%>" DIR="<%=dir%>">
    
    <tr>
        <TD class='td' nowrap>    
            <FORM NAME="DOC_FORM" METHOD="POST">
                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="ISSUE_TITLE">
                                <p><b><%=DT%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="docTitle" ID="issueTitle" size="33" value="<%=doc.getAttribute("docTitle")%>" maxlength="100">
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
                                <p><b><%=DTY%> </b>&nbsp;
                            </LABEL>
                        </TD>                                              
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="configType" ID="configType" size="33" value="<%=doc.getAttribute("configItemType")%>" maxlength="100">
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
                                <p><b><%=SYS%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="docId" ID="docId" size="33" value="<%=doc.getAttribute("docID")%>" maxlength="100">
                        </TD>
                    </TR>
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD STYLE="<%=style%>"class='td'>
                            <LABEL FOR="ISSUE_TITLE">
                                <p><b><%=EMPN%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="issueid" ID="issueid" size="33" value="<%=doc.getAttribute("empID")%>" maxlength="100">
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
                                <p><b><%=DA%></b>&nbsp;
                            </LABEL>
                        </TD>
                        
                        <TD STYLE="<%=style%>" class='td'>
                            <%
                            if(bHasChild) {
                            %>
                            <input disabled type="TEXT" name="docDate" ID="docDate" size="33" value="<%=childDoc.getAttribute("docDate")%>" maxlength="100">
                            <%
                            } else {
                            %>
                            <input disabled type="TEXT" name="docDate" ID="docDate" size="33" value="<%=doc.getAttribute("docDate")%>" maxlength="100">
                            <%
                            }
                            %>
                        </td>
                        
                    </TR>
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    
                    <!--TR>
                            <TD class='td'>
                            <LABEL FOR="FACE_VALUE">
                    <p><b><%//=tGuide.getMessage("facevalue")%>: </b>&nbsp;
                            </LABEL>
                            </TD>
                            <TD class='td'>
                    <input disabled type="TEXT" name="faceValue" ID="faceValue" size="10" value="<%//=doc.getAttribute("total")%>" maxlength="10">
                            </TD>
                            </TR>

                            <TR>
                            <TD class='td'>
                            &nbsp;
                            </TD>
                            </TR-->

                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="FACE_VALUE">
                                <p><b><%=name%> </b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="createdBy" ID="createdBy" size="33" value="<%=doc.getAttribute("createdByName")%>" maxlength="30">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="FACE_VALUE">
                                <p><b><%=ID%> </b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="createdBy" ID="groupName" size="33" value="<%=doc.getAttribute("createdBy")%>" maxlength="30">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="FACE_VALUE">
                                <p><b><%=UD%> </b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="creationDate" ID="creationDate" size="33" value="<%=doc.getAttribute("creationTime")%>" maxlength="30">
                        </TD>
                        </TR
                        
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=desc%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <DIV class="textview" STYLE="width=177pt">
                                <%=doc.getAttribute("description")%>
                            </div>
                            
                        </TD>
                    </TR>
                    
                </TABLE>
            </FORM>
            
        </td>
        <%
        if(doc.isImage()) {
        
        %>
        <TD STYLE="text-align:right" class='td'>
            <img WIDTH="400" HEIGHT="400" name='docImage' alt='document image' src='<%=imagePath%>' >
        </TD>
        <%
        }
        %>
    </tr>
</table>
</fieldset>
</BODY>
</HTML>     
