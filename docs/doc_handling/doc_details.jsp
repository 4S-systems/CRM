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
    
    
    WebBusinessObject VO = (WebBusinessObject) request.getAttribute("viewOrigin");
    String imagePath = (String) request.getAttribute("imagePath");
    String filter= (String) VO.getAttribute("filter");
    String filterValue= (String)VO.getAttribute("filterValue");
    
    String issueid = (String) request.getParameter("issueId");
    String projectname = (String) request.getAttribute("projectName");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    if (filter.equals("") || filterValue.equals("")) {
        backTarget=context+"/main.jsp";
    } else //if(filter.equalsIgnoreCase("PublishDocument")){
        //backTarget=context+"/ConfigurationServlet?op=PublishDocument&publishType="+filterValue;
        //}
        //else
    {
        backTarget=context+"/SearchServlet?op="+filter+"&filterValue="+filterValue;
    }
    
    Document childDoc = null;
    boolean bHasChild = false;
    
    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/BasicOps");
    DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
    ArrayList configType = docTypeMgr.getCashedTableAsArrayList();
    
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, sTitle, sCancel, sOk, sDocTitle, sDocType, sID, sTaskID, sDocDate, sDocAttachByName, sDocAttachByID, sAttachDate, sDesc;
    
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        sTitle="View Details";
        sCancel="Back";
        sOk="Ok";
        langCode="Ar";
        sDocTitle = "Document Title";
        sDocType = "Document Type";
        sID = "Document ID";
        sTaskID = "Task ID";
        sDocDate = "Document Date";
        sDocAttachByName = "Attached by name";
        sDocAttachByID = "Attached by ID";
        sAttachDate = "Attach Date";
        sDesc = "Description";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        sTitle="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
        sCancel="&#1593;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
        sOk="&#1605;&#1608;&#1575;&#1601;&#1602;";
        langCode="En";
        sDocTitle = tGuide.getMessage("doctitle");
        sDocType = tGuide.getMessage("configitemtype");
        sID = tGuide.getMessage("systemid");
        sTaskID = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
        sDocDate = tGuide.getMessage("docdate");
        sDocAttachByName = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1585;&#1601;&#1602;";
        sDocAttachByID = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1585;&#1601;&#1602;";
        sAttachDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1573;&#1585;&#1601;&#1575;&#1602;";
        sDesc = "&#1575;&#1604;&#1608;&#1589;&#1601;";
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
        
        function cancelForm()
        {    
            document.DOC_FORM.action = "<%=context%>/ImageReaderServlet?op=ListDoc&issueId=<%=issueid%>&fName=<%=filter%>&fValue=<%=filterValue%>";
            document.DOC_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
        <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
        <br><br>
        <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="center">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">
                                <%=sTitle%> 
                                <%
                                if(!doc.isImage()) {
        if(((String)doc.getAttribute("docType")).equals("doc")){
                                %>                 
                                <A HREF="<%=doc.getViewDocumentLink()%>">
                                    <img  name='docImage' alt='document image' src="images/<%=fileDescriptor.getAttribute("iconFile")%>" >
                                </A>  
                                <%
                                }
        if(childDoc != null){
            bHasChild = true;
                                %>
                                <A HREF="<%=context%>/ImageReaderServlet?op=ViewDocument&docType=doc&docId=<%=(String) childDoc.getAttribute("docID")%>&metaType=<%=(String) childDoc.getAttribute("metaType")%>">
                                    <img  name='docImage' alt='document image' src="images/<%=fileDescriptor.getAttribute("iconFile")%>" >
                                </A>
                                <%
                                }
                                }
                                %>
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            <Table ALIGN="center" DIR="<%=dir%>" >
                <tr>
                    <TD STYLE="tyext-align:right" class='td' nowrap>    
                        <FORM NAME="DOC_FORM" METHOD="POST">
                            
                            <TABLE ALIGN="center" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                                <TR>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b><%=sDocTitle%></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <input disabled type="TEXT" name="docTitle" ID="issueTitle" size="33" value="<%=doc.getAttribute("docTitle")%>" maxlength="100">
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b><%=sDocType%> </b>&nbsp;
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
                                            <p><b><%=sID%></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <input disabled type="TEXT" name="docId" ID="docId" size="33" value="<%=doc.getAttribute("docID")%>" maxlength="100">
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b><%=sTaskID%></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <input disabled type="TEXT" name="issueid" ID="issueid" size="33" value="<%=doc.getAttribute("issueid")%>" maxlength="100">
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
                                            <p><b><%=sDocDate%></b>&nbsp;
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
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="FACE_VALUE">
                                            <p><b><%=sDocAttachByName%></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <input disabled type="TEXT" name="createdBy" ID="createdBy" size="33" value="<%=doc.getAttribute("createdBy")%>" maxlength="30">
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
                                            <p><b><%=sDocAttachByID%></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <input disabled type="TEXT" name="createdBy" ID="groupName" size="33" value="<%=doc.getAttribute("createdById")%>" maxlength="30">
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <LABEL FOR="FACE_VALUE">
                                            <p><b><%=sAttachDate%></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>"class='td'>
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
                                            <p><b><%=sDesc%></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <DIV class="textview" STYLE="width:177pt" STYLE="<%=style%>">
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
                    <TD class='td'>
                        <img name='docImage' alt='document image' src='<%=imagePath%>' >
                    </TD>
                    <%
                    }
                    %>
                </tr>
            </table>
        </fieldset>
    </BODY>
</HTML>     
