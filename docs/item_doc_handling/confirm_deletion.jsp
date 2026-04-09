<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*, java.util.*,com.silkworm.common.*,com.docviewer.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String docID = (String) request.getAttribute("docID");
    //    WebBusinessObject VO = (WebBusinessObject) request.getAttribute("viewOrigin");
    // String docTitle = (String) request.getAttribute("docTitle");
    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/CreateForm");
    TouristGuide tGuide1 = new TouristGuide("/com/docviewer/international/BasicOps");
    Document doc = (Document)request.getAttribute("doc");
    String docTitle = (String) doc.getAttribute("docTitle");
    
    String itemID = (String) request.getAttribute("itemID");
    //    String filterName = (String) request.getAttribute("fName");
    //    String filterBack = (String) request.getAttribute("filterBack");
    //    String filterValue = (String) request.getAttribute("filterValue");
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
String  doc_name;
//String view, edit, delete;
String save_button_label;
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
   
    doc_name="Document title";
    
    
    title_1="Delete document";
    title_2="All information are needed";
    cancel_button_label=" Return to menu ";
    save_button_label="Delete";
    langCode="Ar";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    
    
    doc_name="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1608;&#1579;&#1610;&#1602;&#1607;";
     
    
    title_1=" &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label=" &#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607; ";
    save_button_label=" &#1581;&#1584;&#1601;";
    langCode="En";
}
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - Confirm Deletion</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/ItemDocReaderServlet?op=Delete&docID=<%=docID%>&itemID=<%=itemID%>&categoryId=<%=request.getAttribute("categoryId").toString()%>&pIndex=<%=pIndex%>";
        document.ISSUE_FORM.submit();  
        }

        
 function changePage(url){
                window.navigate(url);
            }

    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
                   
<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: changePage('<%=context%>/ItemDocReaderServlet?op=ListDoc&itemID=<%=itemID%>&categoryId=<%=request.getAttribute("categoryId").toString()%>&pIndex=<%=pIndex%>');" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
     <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
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

        <FORM NAME="ISSUE_FORM" METHOD="POST">
            
           
            <br><br>

               
            <TABLE align="<%=align%>" dir=<%=dir%> CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="ISSUE_TITLE">
                            <p><b> <%=doc_name%><font color="#FF0000"> </font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"  class='td'>
                        <input disabled type="TEXT" name="docTitle" value="<%=docTitle%>" ID="<%=docTitle%>" size="33"  maxlength="50">
                    </TD>
                </TR>
                
                <input  type="HIDDEN" name="docID" value="<%=docID%>">
                
                
                
            </TABLE>
            <br><br><br>
        </FORM>
    </BODY>
</HTML>     
