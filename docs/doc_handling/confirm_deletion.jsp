<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*, java.util.*,com.silkworm.common.*,com.docviewer.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String docId = (String) request.getAttribute("docId");
    WebBusinessObject VO = (WebBusinessObject) request.getAttribute("viewOrigin");
    // String docTitle = (String) request.getAttribute("docTitle");
    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/CreateForm");
    TouristGuide tGuide1 = new TouristGuide("/com/docviewer/international/BasicOps");
    Document doc = (Document)request.getAttribute("doc");
    String docTitle = (String) doc.getAttribute("docTitle");
    
    String issueid = (String) request.getAttribute("issueid");
    String filterName = (String) request.getAttribute("fName");
    String filterBack = (String) request.getAttribute("filterBack");
    String filterValue = (String) request.getAttribute("filterValue");
    
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, sTitle, sCancel, sOk, sDocTitle;
    
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        sTitle="Delete Document - Are you sure?";
        sCancel="Back";
        sOk="Delete";
        langCode="Ar";
        sDocTitle = "Document Title";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        sTitle="&#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
        sCancel="&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
        sOk="&#1573;&#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
        langCode="En";
        sDocTitle = tGuide.getMessage("doctitle");
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
            document.ISSUE_FORM.action = "<%=context%>/ImageReaderServlet?op=Delete&docId=<%=docId%>&filterBack=<%=filterBack%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>&issueid=<%=issueid%>";
            document.ISSUE_FORM.submit();  
        }

        function cancelForm()
        {    
            document.ISSUE_FORM.action = "<%=context%>/ImageReaderServlet?op=ListDoc&filterBack=<%=filterBack%>&fName=<%=filterName%>&fValue=<%=filterValue%>&issueId=<%=issueid%>";
            document.ISSUE_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
            <button  onclick="JavaScript:  submitForm();" class="button"><%=sOk%><IMG HEIGHT="15" SRC="images/del.gif"></button>
            
            <br><br>
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <%=sTitle%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <TABLE ALIGN="center"  DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD class="td">
                            &nbsp;
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="text-align:right" class='td'>
                            <LABEL FOR="ISSUE_TITLE">
                                <p><b> <%=sDocTitle%><font color="#FF0000"> </font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="text-align:right" class='td'>
                            <input disabled type="TEXT" name="docTitle" value="<%=docTitle%>" ID="<%=docTitle%>" size="33"  maxlength="50">
                        </TD>
                    </TR>
                    
                    <input  type="HIDDEN" name="docId" value="<%=docId%>">
                    <TR>
                        <TD class="td">
                            &nbsp;
                        </TD>
                    </TR>
                </TABLE>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
