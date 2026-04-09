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
    
    String itemID = (String) request.getAttribute("itemID");
    //         String projectname = (String) request.getAttribute("projectName");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    Document childDoc = null;
    boolean bHasChild = false;
    
    TouristGuide tGuide = new TouristGuide("/com/docviewer/international/BasicOps");
    DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
    ArrayList configType = docTypeMgr.getCashedTableAsArrayList();
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
String  doc_name, doc_type, code_num, spare_part_id, doc_date, created_by_name, create_by_id, creation_date, doc_desc;
//String view, edit, delete;
String save_button_label;
String parts_numb="&#1606;&#1578;&#1610;&#1580;&#1577; &#1575;&#1604;&#1593;&#1585;&#1590;";
String piece_word="&#1602;&#1591;&#1593;&#1577;";
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
   
    doc_name="Document title";
    doc_type="Document type";
    code_num="Code number";
    spare_part_id="Spare part ID";
    doc_date="Document date";
    created_by_name="Created by (Name)";
     create_by_id="Created by (ID)";
     creation_date="Creation date";
     doc_desc="Document description";
    
    title_1="Veiw details";
    title_2="All information are needed";
    cancel_button_label=" Return to menu ";
    save_button_label="Delete category";
    langCode="Ar";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    
    
    doc_name="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1608;&#1579;&#1610;&#1602;&#1607;";
    doc_type="&#1606;&#1608;&#1593; &#1575;&#1604;&#1608;&#1579;&#1610;&#1602;&#1607;";
    code_num="&#1575;&#1604;&#1585;&#1602;&#1605; &#1575;&#1604;&#1603;&#1608;&#1583;&#1610;";
    spare_part_id="&#1585;&#1602;&#1605; &#1602;&#1591;&#1593;&#1607; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
    doc_date="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1608;&#1579;&#1610;&#1602;&#1607;";
    created_by_name="&#1575;&#1606;&#1588;&#1574;&#1578; &#1576;&#1608;&#1575;&#1587;&#1591;&#1607; (&#1575;&#1604;&#1575;&#1587;&#1605;)";
     create_by_id="&#1575;&#1606;&#1588;&#1574;&#1578; &#1576;&#1608;&#1575;&#1587;&#1591;&#1607; (&#1575;&#1604;&#1585;&#1602;&#1605;)";
     creation_date="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1575;&#1606;&#1588;&#1575;&#1569;";
     doc_desc="&#1608;&#1589;&#1601; &#1575;&#1604;&#1608;&#1579;&#1610;&#1602;&#1607;";
     
    head_1="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
    head_2="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
    
    title_1=" &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label=" &#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607; ";
    save_button_label=" &#1581;&#1584;&#1601; &#1575;&#1604;&#1589;&#1606;&#1601;";
    langCode="En";
}
    
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - Document Details</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
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
        
 function changePage(url){
                window.navigate(url);
            }
        
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        
<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
    <button  onclick="JavaScript: changePage('<%=context%>/ItemDocReaderServlet?op=ListDoc&itemID=<%=itemID%>&categoryId=<%=request.getAttribute("categoryId").toString()%>&pIndex=<%=pIndex%>');" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
</DIV> 

<fieldset class="set" align="center">
<legend align="center">
    <table align="<%=align%>" dir=<%=dir%>>
        <tr>
            
            <td class="td">
                <font color="blue" size="6">    <%=title_1%>                
                </font>
                <%
                    if(!doc.isImage()) {
                    
                    %>
                    
                    <%
                    if(((String)doc.getAttribute("docType")).equals("doc")){
                        System.out.println("-----> it's document");
                    %>                 
                    <A HREF="<%=context%>/ItemDocReaderServlet?op=ViewDocument&docType=<%=doc.getDocumentType()%>&docID=<%=(String) doc.getAttribute("docID")%>&metaType=<%=(String) doc.getAttribute("metaType")%>">
                        <img  name='docImage' alt='document image' src="images/<%=fileDescriptor.getAttribute("iconFile")%>" >
                    </A>  
                    <%
                    } 
                    if(childDoc != null){
                        bHasChild = true;
                    %>
                    <A HREF="<%=context%>/ItemDocReaderServlet?op=ViewDocument&docType=doc&docId=<%=(String) childDoc.getAttribute("docID")%>&metaType=<%=(String) childDoc.getAttribute("metaType")%>">
                        <img  name='docImage' alt='document image' src="images/<%=fileDescriptor.getAttribute("iconFile")%>" >
                    </A>
                    <%
                    } 
                    
                    }
                    %>
            </td>
        </tr>
    </table>
</legend>

        
                    
                    
                
        <br><br>
        <Table align="<%=align%>" dir=<%=dir%>>
            
            <tr>
                <TD class='td' nowrap>    
                    <FORM NAME="DOC_FORM" METHOD="POST">
                        
                                                
                        <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                                                        
                            
                            <TR>
                                <TD STYLE="<%=style%>" class='td'>
                                    <LABEL FOR="ISSUE_TITLE">
                                        <p><b><%=doc_name%></b>&nbsp;
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
                                        <p><b><%=doc_type%> </b>&nbsp;
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
                                        <p><b><%=code_num%></b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD class='td'>
                                    <input disabled type="TEXT" name="docId" ID="docId" size="33" value="<%=doc.getAttribute("docID")%>" maxlength="100">
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
                                        <p><b><%=spare_part_id%></b>&nbsp;
                                    </LABEL>
                                </TD>
                                <TD STYLE="<%=style%>" class='td'>
                                    <input disabled type="TEXT" name="issueid" ID="issueid" size="33" value="<%=doc.getAttribute("itemID")%>" maxlength="100">
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
                                        <p><b><%=doc_date%></b>&nbsp;
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
                                        <p><b><%=created_by_name%>  </b>&nbsp;
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
                                        <p><b><%=create_by_id%></b>&nbsp;
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
                                        <p><b><%=creation_date%> </b>&nbsp;
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
                                        <p><b><%=doc_desc%></b>&nbsp;
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
                <TD STYLE="<%=style%>" class='td'>
                    <img WIDTH="600" HEIGHT="800" name='docImage' alt='document image' src='<%=imagePath%>' >
                </TD>
                <%
                }
                %>
            </tr>
        </table>
        <br><br><br>
    </BODY>
</HTML>     
