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
    
    String projId = (String) request.getAttribute("projId");
    //    String filterName = (String) request.getAttribute("fName");
    //    String filterBack = (String) request.getAttribute("filterBack");
    //    String filterValue = (String) request.getAttribute("filterValue");
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,tit,save,cancel,TT,SNA,tit1,RU,EMP;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        tit="Delete Document - Are you Sure ?";
        tit1="Documnet Name";
        save="Delete";
        cancel="Back To List";
        TT="Task Title ";
        SNA="Site Name";
        RU="Waiting Business Rule";
        EMP="Employee Name";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        tit="   &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
        tit1="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
        save=" &#1573;&#1581;&#1584;&#1601;";
        cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        TT="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        SNA="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        RU="&#1605;&#1606;&#1578;&#1592;&#1585; &#1602;&#1575;&#1593;&#1583;&#1577; &#1593;&#1605;&#1604;";
        EMP="&#1573;&#1587;&#1605; &#1575;&#1604;&#1608;&#1592;&#1601;";
    }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - Confirm Deletion</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/UnitDocReaderServlet?op=DeleteAttachFile&docID=<%=docID%>&projId=<%=projId%>";
        document.ISSUE_FORM.submit();  
        }
 function cancelForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/UnitDocReaderServlet?op=ListAttachedDocs&projId=<%=projId%>";
        document.ISSUE_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    <BODY>
        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
            <button    onclick="submitForm()" class="button"> &nbsp;&nbsp; <%=save%> &nbsp;&nbsp; 
            </button>
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
            
            <FORM NAME="ISSUE_FORM" METHOD="POST">
            
            
            <FORM  NAME="ISSUE_FORM" METHOD="POST">
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="ISSUE_TITLE">
                                <p><b> <%=tit1%><font color="#FF0000"> </font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="text-align:right" class='td'>
                            <input disabled type="TEXT" name="docTitle" value="<%=docTitle%>" ID="<%=docTitle%>" size="33"  maxlength="50">
                        </TD>
                    </TR>
                    
                    <input  type="HIDDEN" name="docID" value="<%=docID%>">
                    
                </TABLE>
            </FORM>
        </fieldset>
    </BODY>
</HTML>     
