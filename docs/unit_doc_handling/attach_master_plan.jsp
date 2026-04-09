<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.docviewer.db_access.DocTypeMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String projId = request.getParameter("projId");
    WebBusinessObject project = (WebBusinessObject) request.getAttribute("project");
    WebBusinessObject docTypeWbo = (WebBusinessObject) request.getAttribute("docTypeWbo");

    String context = metaMgr.getContext();
    String status = (String) request.getAttribute("Status");
    String message = "";

    // get current date and Time
    Calendar cal = Calendar.getInstance();
    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
    String jDateFormat = loggedUser.getAttribute("javaDateFormat").toString();
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowDate = sdf.format(cal.getTime());

    String type = (String) request.getAttribute("type");

    ArrayList listTrade = new ArrayList();
    listTrade.add("Mechanical");
    listTrade.add("Electrical");
    listTrade.add("Civil");
    listTrade.add("Instrument");

    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode, cancel, save, Titel, sTitel, M1, M2, attach;
    String FTYP, FDA, desc, backToList;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "&#1593;&#1585;&#1576;&#1610;";
        langCode = "Ar";

        cancel = "Cancel";
        save = "Create";
        Titel = "Attached file";
        sTitel = "Schedule Title ";
        M1 = "Success";
        M2 = "There Is a problem In Creation";
        save = "Create";
        attach = "Attach file";
        FTYP = "Document Type";
        FDA = "Document date";
        desc = "Description";
        backToList = "Back To List";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cancel = "إنهاء";
        Titel = "&#1573;&#1585;&#1601;&#1575;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583; &#1604;";
        M1 = "&#1578;&#1605; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1576;&#1606;&#1580;&#1575;&#1581; ";
        M2 = "&#1607;&#1606;&#1575;&#1603; &#1605;&#1588;&#1603;&#1604;&#1577; &#1601;&#1609; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        sTitel = " &#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
        save = " &#1587;&#1580;&#1604; &#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1607; ";
        save = " &#1587;&#1580;&#1604;";
        attach = "&#1573;&#1585;&#1601;&#1575;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
        FTYP = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
        FDA = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
        desc = "&#1575;&#1604;&#1608;&#1589;&#1601;";
        backToList = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    }
%>

<script src='silkworm_validate.js' type='text/javascript'></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    var dp_cal1;
    window.onload = function () {
        dp_cal1 = new Epoch('epoch_popup', 'popup', document.getElementById('docDate'));
    };
    function submitForm() {
        if (document.getElementById('docTitle').value == "") {
            alert("يجب أدخال عنوان");
            document.getElementById('docTitle').focus();
            return;
        } else if (document.getElementById('docDate').value == "") {
            alert("يجب أختيار التاريخ");
            document.getElementById('docDate').focus();
            return;
        } else if (document.getElementById('configType').value == "") {
            alert("يجب أدخال نوع مستند جديد 'Master Plan'");
            return;
        } else if (document.getElementById('description').value == "") {
            alert("يجب أدخال الوصف.");
            document.getElementById('description').focus();
            return;
        } else {
            document.EXTERNAL_ORDER_FORM.action = "<%=context%>/UnitDocWriterServlet?projId=<%=projId%>&op=saveMasterPlan";
            document.EXTERNAL_ORDER_FORM.submit();
        }
    }
    function cancelForm() {
        close();
    }
    function backForm(url)
    {
        document.EXTERNAL_ORDER_FORM.action = url;
        document.EXTERNAL_ORDER_FORM.submit();
    }

    function changePic() {
        var fileName = document.getElementById("file1").value;
        var arrfileName = fileName.split(".");
        document.getElementById("fileExtension").value = arrfileName[1];
        document.getElementById("docType").value = arrfileName[1];
        if (fileName.length > 0) {
            if (fileName.indexOf("jpg") > -1 || fileName.indexOf("JPG") > -1) {
                document.getElementById("imageName").value = fileName;
            } else if (fileName.indexOf("png") > -1 || fileName.indexOf("PNG") > -1) {
                document.getElementById("imageName").value = fileName;
            } else if (fileName.indexOf("gif") > -1 || fileName.indexOf("GIF") > -1) {
                document.getElementById("imageName").value = fileName;
            } else {
                alert("Invalid File type");
                document.getElementById("file1").focus();
                document.getElementById("imageName").value = "";
            }
        } else {
            document.getElementById("imageName").value = "";
        }
    }
</SCRIPT>
<html>
    <head>
        <script src='js/ChangeLang.js' type='text/javascript'></script>
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
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
    </head>
    <body>
        <form action="" name="EXTERNAL_ORDER_FORM" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="type" id="type" value="project"/>
            <input type="hidden" name="docType" id="docType" value="">
            <input type="hidden" name="fileExtension" id="fileExtension" value="" >
            <div align="left" style="color:blue;">
                <button onclick="JavaScript: cancelForm();" class="button"> <%=cancel%> <img alt="" SRC="images/cancel.gif"></button>
                <button type="button" onclick="JavaScript: submitForm();" class="button"><%=save%> <img alt="" HEIGHT="15" SRC="images/save.gif"></button>
            </div>
            <br/>
            <center>
                <fieldset class="set" style="width:95%;border-color: #006699;" >
                    <table class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=Titel%> <%=project.getAttribute("projectName")%></font></td>
                        </tr>
                    </table>
                    <br/>
                    <%
                        if (null != status) {
                    %>
                    <%
                        if (status.equalsIgnoreCase("ok")) {
                            message = M1;
                        } else {
                            message = M2;
                        }
                    %>
                    <table align="<%=align%>" dir="<%=dir%>" width="600" CELLPADDING="0" CELLSPACING="0" style="border-right-width:1px;">
                        <tr BGCOLOR="FBE9FE">
                            <td style="<%=style%>" class="td">
                                <b><font FACE="tahoma" color='blue'><%=message%></font></b>
                            </td>
                        </tr>
                    </table>
                    <br/><br/>
                    <% }%>
                    <br/>
                    <table align="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                        <tr>
                            <td class="td" width="50%">
                                <table align="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                                    <tr>
                                        <td nowrap style="<%=style%>;font-size: 15px" class="td"><b><%=sTitel%></b></td>
                                        <td style="<%=style%>" class='td'>
                                            <input  type="text" name="docTitle" id="docTitle" size="25" value="" maxlength="255" style="width:230px">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap style="<%=style%>;font-size: 15px" class="td"><b><%=FTYP%></b></td>
                                        <td style="<%=style%>" class='td'>
                                            <%=docTypeWbo != null ? docTypeWbo.getAttribute("typeName") : ""%>
                                            <input type="hidden" id="configType" name="configType" value="<%=docTypeWbo != null ? docTypeWbo.getAttribute("typeID") : ""%>" style="width:230px"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap style="<%=style%>;font-size: 15px" class="td"><b><%=FDA%></b></td>
                                        <td style="<%=style%>"  class="calender">
                                            <input id="docDate" name="docDate" type="text" value="<%=nowDate%>"><img alt="" src="images/showcalendar.gif" >
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap style="<%=style%>" class="td"><font FACE="tahoma"><b><%=desc%><font color="#FF0000">*</font>&nbsp;</b></font></td>
                                        <td style="<%=style%>"class='td' COLSPAN="3">
                                            <TEXTAREA rows="5" style="width:230px" name="description" id="description" cols="80"></TEXTAREA>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap style="<%=style%>;font-size: 15px" class="td"><b><%=attach%></b></td>
                                        <td style="<%=style%>"class='td' COLSPAN="3">
                                            <input type="file" name="file1" style="height: 25px" id="file1" onchange="JavaScript: changePic();">
                                            <input type="hidden" name="imageName" id="imageName" value="">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="td">
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td class="td" width="5%">
                                &ensp;
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </center>
        </form>
    </body>
</html>