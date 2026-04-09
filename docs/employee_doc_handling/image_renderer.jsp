<%@ page import="com.docviewer.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>

<%

FileMgr fileMgr = FileMgr.getInstance();
//WebBusinessObject fileDescriptor = null;
String backTarget=null;
response.addHeader("Pragma","No-cache");
response.addHeader("Cache-Control","no-cache");
response.addDateHeader("Expires",1);

Document doc = (Document) request.getAttribute("docObject");
// fileDescriptor = fileMgr.getObjectFromCash(doc.getDocumentType());


// WebBusinessObject VO = (WebBusinessObject) request.getAttribute("viewOrigin");
String imagePath = (String) request.getAttribute("imagePath");
//String filter= (String) VO.getAttribute("filter");
//String filterValue= (String)VO.getAttribute("filterValue");

String issueid = (String) request.getAttribute("issueid");

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
//if (filter.equals("") || filterValue.equals("")) {
backTarget=context+"/main.jsp";
// } else //if(filter.equalsIgnoreCase("PublishDocument")){
//backTarget=context+"/ConfigurationServlet?op=PublishDocument&publishType="+filterValue;
//}
//else
//  {
//backTarget=context+"/SearchServlet?op="+filter+"&filterValue="+filterValue;
//  }

Document childDoc = null;
boolean bHasChild = false;

TouristGuide tGuide = new TouristGuide("/com/docviewer/international/BasicOps");
// DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
//ArrayList configType = docTypeMgr.getCashedTableAsArrayList();

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,tit,save,cancel,TT,SNA,tit1,RU,EMP,STAT,NO;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    tit="View File";
    tit1="Select File Type";
    save="Attach";
    cancel="Back To List";
    TT="Select File Type ";
    SNA="Site Name";
    RU="Waiting Business Rule";
    EMP="Employee Name";
    STAT="Attaching Status";
    NO="Attach File Before Filling Information";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    tit="  &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;  ";
    tit1="&#1573;&#1582;&#1578;&#1575;&#1585; &#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
    save="&#1573;&#1585;&#1601;&#1602;";
    cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    TT="&#1573;&#1582;&#1578;&#1575;&#1585; &#1605;&#1604;&#1601;";
    SNA="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    RU="&#1605;&#1606;&#1578;&#1592;&#1585; &#1602;&#1575;&#1593;&#1583;&#1577; &#1593;&#1605;&#1604;";
    EMP="&#1573;&#1587;&#1605; &#1575;&#1604;&#1608;&#1592;&#1601;";
    STAT=" &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1573;&#1585;&#1601;&#1575;&#1602;";
    NO="&#1573;&#1585;&#1601;&#1602; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583; &#1602;&#1576;&#1604; &#1605;&#1604;&#1574; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578;";
}
%>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>Document Viewer - Document Details</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
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
       function changePage(url)
       {
       window.navigate(url);
       }
      
</SCRIPT>

<BODY>
    
    <DIV align="left" STYLE="color:blue;">
        <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
        <button    onclick="changePage('<%=context%>/EmployeeServlet?op=ListEmployee')" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
        
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
        
        
        <table align="<%=align%>" dir="<%=dir%>">
        <TR>
            <TD class='td'>
                <img name='docImage' alt='document image' src='<%=imagePath%>' >
            </TD>
            <%
            // }
            %>
        </tr>
        
    </fieldset>
    </table>
</BODY>
</HTML>     
