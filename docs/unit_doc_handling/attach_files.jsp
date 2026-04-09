<%@ page import="com.silkworm.common.*,com.docviewer.db_access.*,com.silkworm.util.DateAndTimeConstants,java.util.ArrayList,com.silkworm.common.swWebApplication"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.db_access.FileMgr,com.silkworm.business_objects.WebBusinessObject"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>

<%


MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

String fileExtension = (String) request.getAttribute("fileExtension");
String imAttStatus = (String) request.getAttribute("status");

FileMgr fileMgr = FileMgr.getInstance();
WebBusinessObject fileDescriptor = fileMgr.getObjectFromCash(fileExtension);
String iconFile = (String) fileDescriptor.getAttribute("iconFile");

String fileMetaType = (String) fileDescriptor.getAttribute("metaType");


TouristGuide tGuide = new TouristGuide("/com/docviewer/international/CreateForm");

String[] allFiles = (String[]) request.getAttribute("allfiles");

String equipmentID = (String) request.getAttribute("equipmentID");
String docType = (String) request.getAttribute("docType");

String op=null;



String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,tit,save,cancel,TT,SNA,tit1,RU,EMP,STAT,NO,sStatus,fStatus;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    tit="Attach File";
    tit1="Select File Type";
    save="Attach";
    cancel="Back";
    TT="Select File Type ";
    SNA="Site Name";
    RU="Waiting Business Rule";
    EMP="Employee Name";
    STAT="Attaching Status";
    NO="Attach File Before Filling Information";
    sStatus="File Attached successfully";
    fStatus="Fail To Attach File";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    if(imAttStatus != null){
        if(imAttStatus.indexOf("Database error") >= 0){
            imAttStatus="&#1607;&#1606;&#1575;&#1603; &#1582;&#1591;&#1571; &#1601;&#1610; &#1602;&#1575;&#1593;&#1583;&#1607; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578;";
        } else if(imAttStatus.indexOf("Incorrect File Type") >= 0){
            imAttStatus= "&#1575;&#1604;&#1605;&#1604;&#1601; &#1604;&#1605; &#1610;&#1585;&#1601;&#1602;: &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1604;&#1601; &#1594;&#1610;&#1585; &#1589;&#1581;&#1610;&#1581;";
        }
    }
    tit="  &#1573;&#1585;&#1601;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583; ";
    tit1="&#1573;&#1582;&#1578;&#1575;&#1585; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    save="&#1573;&#1585;&#1601;&#1602;";
    cancel="&#1593;&#1608;&#1583;&#1577; ";
    TT="&#1573;&#1582;&#1578;&#1575;&#1585; &#1605;&#1604;&#1601;";
    SNA="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    RU="&#1605;&#1606;&#1578;&#1592;&#1585; &#1602;&#1575;&#1593;&#1583;&#1577; &#1593;&#1605;&#1604;";
    EMP="&#1573;&#1587;&#1605; &#1575;&#1604;&#1608;&#1592;&#1601;";
    STAT=" &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1573;&#1585;&#1601;&#1575;&#1602;";
    NO="&#1573;&#1585;&#1601;&#1602; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583; &#1602;&#1576;&#1604; &#1605;&#1604;&#1574; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578;";
    sStatus="&#1578;&#1605; &#1575;&#1604;&#1575;&#1585;&#1601;&#1575;&#1602; &#1576;&#1606;&#1580;&#1575;&#1581;";
    fStatus="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1575;&#1585;&#1601;&#1575;&#1602;";
}
String type = (String) request.getAttribute("type");
%>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>Document Viewer- Create Document</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

 function cancelForm()
        {    
        document.IMG_FORM.action = "<%=context%>/UnitDocReaderServlet?op=ViewImages&equipmentID=<%=equipmentID%>";
        document.IMG_FORM.submit();  
        }
        function attachImage()
        {    
        document.IMG_FORM.action = "<%=context%>/UnitDocWriterServlet?op=AttachImage&fileExtension=<%=fileExtension%>&equipmentID=<%=equipmentID%>&docType=<%=docType%>&type=<%=type%>";
        document.IMG_FORM.submit();  
        }
</SCRIPT>


<script src='ChangeLang.js' type='text/javascript'></script>

<LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">

<BODY>
    <DIV align="left" STYLE="color:blue;">
        <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
        <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
        <button    onclick="attachImage()" class="button"><%=save%>   <IMG SRC="images/attach.gif">  </button>
    </DIV> 
    <br><br>
    <fieldset align=center class="set">
    <legend align="center">
        
        <table dir=" <%=dir%>" align="<%=align%>">
            <tr>
                
                <td class="td">
                    <font color="blue" size="6"><%=tit%> <IMG WIDTH="20" HEIGHT="20" SRC="images/<%=iconFile%>">
                    </font>
                </td>
            </tr>
        </table>
    </legend >
    
    <%
    if(null!=allFiles && (allFiles.length!=0)) {
    int s = allFiles.length;
    int i = 0;
    for(i=0;i<s;i++) {
    
    %>
    <IMG   SRC="images/<%=iconFile%>">
    <%=allFiles[i]%>
    
    
    <%
    }
    
    %>
    
    <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">  
    
    <%
    }
    %>
    
    
    <% //if(fileMetaType.equalsIgnoreCase("image"))
    // {
    %>                      
    <!--          
                    <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                    <IMG SRC="images/don.gif">
    <A HREF="<%=context%>/ImageWriterServlet?op=DoneAttach&fileExtension=<%=fileExtension%>">
    <%=tGuide.getMessage("doneattaching")%>
                    </A>
                    -->
    <%
    //  }
    %>                 
    
    
    </TD>
    </TR>
    </TABLE>
    
    
    <table> 
        <tr><td>
        </td></tr>
    <tr><td class="mes" align=center> </td></tr> </table>      
    
    <% if(null!=imAttStatus) {
    if(imAttStatus.equalsIgnoreCase("ok")) {
    %>
    <table align="<%=align%>"> 
        
        <tr><td class="td" align=<%=align%>>  <font color="black" size="4"> <%=sStatus%>  </td>
            
    </tr> </table>
    <br>
    <%}else{%>
    <table align="<%=align%>"> 
        
        <tr><td class="td" align=<%=align%>>  <font color="red" size="4"> <%=fStatus%>  </td>
            
    </tr> </table>
    <br>
    <%
    }}
    %>
    
    <FORM name="IMG_FORM" action="<%=context%>/ImageWriterServlet?op=SaveDoc" method="post" enctype="multipart/form-data">
        
        <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" name="SUB_TABLE" CELLPADDING="0" CELLSPACING="0" BORDER="0">
            
            <TR COLSPAN="2" ALIGN="CENTER">
                <TD class='td'>
                    <font size="2" color="#FF0000"> <b> <%=NO%> </b></font>
                    <input type=HIDDEN name="docType" value="<%=docType%>" >
                    <input type=HIDDEN name="equipmentID" value="<%=equipmentID%>" >
                </td>
                
                
            </tr>
            
            <TR COLSPAN="2" ALIGN="<%=align%>">
                <TD class='td'>
                    <LABEL FOR="FILE_CHOOSER">
                        <p><b><%=tit1%> [<%=fileDescriptor.getAttribute("fileType")%>]</b>&nbsp;
                    </LABEL>
                </td>
                <TD class='td'>          
                    <input type="file" name="file1">       
                </td>
                
            </tr>
        </table>
    </form>
</BODY>
</HTML>     
