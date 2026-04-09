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

        String unitScheduleID = (String) request.getAttribute("unitScheduleID");
         String projectname = (String) request.getAttribute("projectName");

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        
        Document childDoc = null;
        boolean bHasChild = false;

        TouristGuide tGuide = new TouristGuide("/com/docviewer/international/BasicOps");
        DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
        ArrayList configType = docTypeMgr.getCashedTableAsArrayList();
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
        
    </SCRIPT>

    <BODY>
        <left>          

        <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
            <TR VALIGN="MIDDLE">
                <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                    <%=tGuide.getMessage("viewdocumentdetails")%> 
                </TD>
                <TD CLASS="tabletitle" STYLE="">
                    <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                </TD>

   

                <TD CLASS="tableright" colspan="3">

                    

                    <IMG VALIGN="BOTTOM"   SRC="images/arrow_left_red.gif">
                    <A HREF="<%=context%>/ScheduleServlet?op=ScheduleList">
                        <%=tGuide.getMessage("backtolist")%>
                    </A>
                    <%
                        if(!doc.isImage()) {

                    %>

                    <%
                        if(((String)doc.getAttribute("docType")).equals("doc")){
                            System.out.println("-----> it's document");
                    %>                 
                    <A HREF="<%=context%>/InstReaderServlet?op=ViewDocument&docType=<%=doc.getDocumentType()%>&instId=<%=(String) doc.getAttribute("instID")%>&metaType=<%=(String) doc.getAttribute("metaType")%>">
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
                    <A HREF="<%=context%>/ImageReaderServlet?op=ViewDocument&docType=doc&docId=<%=(String) childDoc.getAttribute("docID")%>&metaType=<%=(String) childDoc.getAttribute("metaType")%>">
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
 
        <Table>

            <tr>
                <TD class='td' nowrap>    
                    <FORM NAME="DOC_FORM" METHOD="POST">
      
            
          
                        <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
            
          
            
                            <TR>
                                <TD class='td'>
                                    <LABEL FOR="ISSUE_TITLE">
                                        <p><b><%=tGuide.getMessage("doctitle")%>:</b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD class='td'>
                                    <input disabled type="TEXT" name="docTitle" ID="issueTitle" size="33" value="<%=doc.getAttribute("instTitle")%>" maxlength="100">
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
                                        <p><b><%=tGuide.getMessage("configitemtype")%>: </b>&nbsp;
                                    </LABEL>
                                </TD>                                              
                                <TD class='td'>
                                    <input disabled type="TEXT" name="configType" ID="configType" size="33" value="<%=doc.getAttribute("configItemType")%>" maxlength="100">
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
                                        <p><b><%=tGuide.getMessage("systemid")%>:</b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD class='td'>
                                    <input disabled type="TEXT" name="docId" ID="docId" size="33" value="<%=doc.getAttribute("instID")%>" maxlength="100">
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
                                        <p><b>Schedule ID:</b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD class='td'>
                                    <input disabled type="TEXT" name="issueid" ID="issueid" size="33" value="<%=doc.getAttribute("unitScheduleID")%>" maxlength="100">
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
                                        <p><b><%=tGuide.getMessage("docdate")%>:</b>&nbsp;
                                    </LABEL>
                                </TD>
          
                                <TD class='td'>
                                    <%
                                        if(bHasChild) {
                                    %>
                                    <input disabled type="TEXT" name="docDate" ID="docDate" size="33" value="<%=childDoc.getAttribute("instDate")%>" maxlength="100">
                                    <%
                                        } else {
                                    %>
                                    <input disabled type="TEXT" name="docDate" ID="docDate" size="33" value="<%=doc.getAttribute("instDate")%>" maxlength="100">
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
                                <TD class='td'>
                                    <LABEL FOR="FACE_VALUE">
                                        <p><b><%=tGuide.getMessage("createdby")%> Name: </b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD class='td'>
                                    <input disabled type="TEXT" name="createdBy" ID="createdBy" size="33" value="<%=doc.getAttribute("createdBy")%>" maxlength="30">
                                </TD>
                            </TR>
            
                            <TR>
                                <TD class='td'>
                                    &nbsp;
                                </TD>
                            </TR>

                            <TR>
                                <TD class='td'>
                                    <LABEL FOR="FACE_VALUE">
                                        <p><b><%=tGuide.getMessage("createdby")%> ID: </b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD class='td'>
                                    <input disabled type="TEXT" name="createdBy" ID="groupName" size="33" value="<%=doc.getAttribute("createdById")%>" maxlength="30">
                                </TD>
                            </TR>

                            <TR>
                                <TD class='td'>
                                    &nbsp;
                                </TD>
                            </TR>

                            <TR>
                                <TD class='td'>
                                    <LABEL FOR="FACE_VALUE">
                                        <p><b><%=tGuide.getMessage("creationdate")%>: </b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD class='td'>
                                    <input disabled type="TEXT" name="creationDate" ID="creationDate" size="33" value="<%=doc.getAttribute("creationTime")%>" maxlength="30">
                                </TD>
                            </TR

                            <TR>
                                <TD class='td'>
                                    &nbsp;
                                </TD>
                            </TR>
                    
                            <TR>
                                <TD class='td'>
                                    <LABEL FOR="str_Function_Desc">
                                        <p><b><%=tGuide.getMessage("documentdescription")%>:</b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD class='td'>
                                    <DIV class="textview" STYLE="width:177pt">
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
                    <img WIDTH="600" HEIGHT="800" name='docImage' alt='document image' src='<%=imagePath%>' >
                </TD>
                <%
                    }
                %>
            </tr>
        </table>
    </BODY>
</HTML>     
                    