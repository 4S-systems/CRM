<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList,com.docviewer.db_access.DocTypeMgr,com.silkworm.common.MetaDataMgr,com.docviewer.business_objects.Document,com.silkworm.db_access.FileMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <%
        response.addHeader("Pragma", "No-cache");
        response.addHeader("Cache-Control", "no-cache");
        response.addDateHeader("Expires", 1);
        
        WebBusinessObject fileDescriptor = null;

        Document doc = (Document) request.getAttribute("docObject");
        FileMgr fileMgr = FileMgr.getInstance();
        String imagePath = (String) request.getAttribute("imagePath");
        fileDescriptor = fileMgr.getObjectFromCash((String) doc.getAttribute("documentType"));
        String issueId = (String) request.getAttribute("issueId");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        
        DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
        String configTypeValue = "";
        if(doc.getAttribute("configItemType") != null){
            WebBusinessObject wboTemp = docTypeMgr.getOnSingleKey((String) doc.getAttribute("configItemType"));
            if(wboTemp != null){
                configTypeValue = (String) wboTemp.getAttribute("typeName");
            }
        }
        ArrayList configType = docTypeMgr.getCashedTableAsBusObjects();

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, cancel, description, sTitle, documentType, documentTitle, save;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            cancel = "Back To List";
            description = "Description";
            sTitle = "Edit Document";
            documentType = "Docuement Type";
            documentTitle = "Title";
            save = "Save";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
            description = "&#1575;&#1604;&#1608;&#1589;&#1601;";
            sTitle = "\u062a\u0639\u062f\u064a\u0644 \u0628\u064a\u0627\u0646\u0627\u062a \u0645\u0633\u062a\u0646\u062f";
            documentType = "\u0646\u0648\u0639 \u0627\u0644\u0645\u0633\u062a\u0646\u062f";
            documentTitle = "\u0627\u0644\u0639\u0646\u0648\u0627\u0646";
            save = "\u062d\u0641\u0638";
        }

    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css"/>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css"/>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css"/>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css"/>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/autosuggest.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/datechooser.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/select-free.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/ajaxtabs.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <LINK rel="stylesheet" type="text/css" href="css/epoch_styles.css"/>
        <script type="text/javascript" src="jquery-ui/jquery.tools.min.js.js"></script>
        <script type="text/javascript" src="js/epoch_classes.js"></script>
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {
            document.DOC_FORM.action = "<%=context%>/IssueDocServlet?op=UpdateDocument&docID=<%=doc.getAttribute("documentID")%>&issueId=<%=issueId%>";
            document.DOC_FORM.submit();
        }
        function cancelForm()
        {
            document.DOC_FORM.action = "<%=context%>/IssueDocServlet?op=ListAttachedDocs&issueId=<%=issueId%>";
            document.DOC_FORM.submit();
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>

    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    <BODY>
        <FORM NAME="DOC_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
                <button onclick="JavaScript: submitForm();" class="button"><%=save%><IMG alt="" HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 

            <br><br>
            <fieldset class="set" style="width:95%;border-color: #006699;" >
                <legend align="center">
                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                <%=sTitle%>
                                </font>
                            </td>
                        </tr>
                    </table>

                </legend >
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD class="td" width="50%">
                            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                                <TR>
                                    <TD nowrap STYLE="<%=style%>;font-size: 15px" class="td"><b><%=documentTitle%><font color="#FF0000">*</font>&nbsp;</b></TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <input  type="text" name="documentTitle" id="documentTitle" size="25" value="<%=doc.getAttribute("documentTitle")%>" maxlength="255" style="width:230px">
                                    </TD>
                                </TR>
                                <TR>
                                    <TD nowrap  STYLE="<%=style%>;font-size: 15px" class="td"><b><%=documentType%><font color="#FF0000">*</font>&nbsp;</b></TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <SELECT name="configType" style="width:230px" readonly="true">
                                            <sw:WBOOptionList wboList="<%=configType%>" valueAttribute="typeID" displayAttribute="typeName" scrollTo='<%=configTypeValue%>'/>
                                        </SELECT>
                                    </TD>
                                </TR>
                                <TR>
                                    <TD nowrap STYLE="<%=style%>" class="td"><b><%=description%><font color="#FF0000">*</font>&nbsp;</b></TD>
                                    <TD STYLE="<%=style%>"class='td' COLSPAN="3">
                                        <TEXTAREA rows="5" style="width:230px" name="description" id="description" cols="80"><%=doc.getAttribute("description")%></TEXTAREA>
                                    </TD>
                                </TR>
                            </TABLE>
                        </TD>
                        <TD STYLE="text-align:right" class='td'>
                            <%
                                if (((String) fileDescriptor.getAttribute("metaType")).equalsIgnoreCase("image")) {

                            %>
                            <img WIDTH="400" HEIGHT="400" name='docImage' alt='document image' src='<%=imagePath%>' >
                            <%
                            } else {
                            %>

                            <A HREF="<%=context%>/IssueDocServlet?op=ViewDocument&docType=<%=doc.getAttribute("documentType")%>&docID=<%=(String) doc.getAttribute("documentID")%>&metaType=<%=(String) doc.getAttribute("metaType")%>&docName=<%=(String) doc.getAttribute("documentTitle")%>">
                                <img  name='docImage' alt='document image' src="images/Icon-Document.png" style="width: 250px;">
                            </A>

                            <%
                                }
                            %>
                    </TD>
                    </TR>
                </TABLE>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
