<%@page import="com.docviewer.db_access.DocTypeMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants,com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@page pageEncoding="UTF-8" %>

<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String issueId = (String) request.getAttribute("issueId");
    String status = (String) request.getAttribute("status");
    DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
    ArrayList configType = docTypeMgr.getCashedTableAsBusObjects();
    WebBusinessObject issue = (WebBusinessObject) request.getAttribute("issue");

    WebBusinessObject docType = docTypeMgr.getOnSingleKey("1401523812151");

    String context = metaMgr.getContext();

    // get current date and Time
    Calendar cal = Calendar.getInstance();
    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
    String jDateFormat = "yyyy/MM/dd HH:mm";//loggedUser.getAttribute("javaDateFormat").toString();
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowDate = sdf.format(cal.getTime());

    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode, cancel, save, Titel, sTitel, attach;
    String FTYP, FDA, desc, followUpNo, defaultTitle, attachedMessage, fileSizeLarge;
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
        save = "Create";
        attach = "Attach file";
        FTYP = "Document Type";
        FDA = "Document date";
        desc = "Description";
        followUpNo = "Follow-Up No";
        defaultTitle = "attached file";
        attachedMessage = "File attached successfully";
        fileSizeLarge = "File Size is Larger than 5 MB";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cancel = tGuide.getMessage("cancel");
        Titel = "إرفاق طلب تسليم";
        sTitel = " &#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
        save = " &#1587;&#1580;&#1604; &#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1607; ";
        save = " &#1587;&#1580;&#1604;";
        attach = "&#1573;&#1585;&#1601;&#1575;&#1602; &#1605;&#1587;&#1578;&#1606;&#1583;";
        FTYP = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
        FDA = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
        desc = "&#1575;&#1604;&#1608;&#1589;&#1601;";
        followUpNo = "\u0631\u0642\u0645 \u0627\u0644\u0645\u062a\u0627\u0628\u0639\u0629";
        defaultTitle = "طلب تسليم";
        attachedMessage = "تم ارسال طلب التسليم الى ادارة الجودة";
        fileSizeLarge = "أقصي مساحة للملف المرفق 5 ميجا";
    }
%>

<script src='silkworm_validate.js' type='text/javascript'></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
//    var dp_cal1;
//    window.onload = function() {
//        dp_cal1 = new Epoch('epoch_popup', 'popup', document.getElementById('documentDate'));
//    };

    function submitForm() {
        if (document.getElementById('documentDate').value == "") {
            alert("Please, enter Date.");
            document.getElementById('documentDate').focus();
            return;
        } else if (document.getElementById('description').value == "") {
            alert("Please fill needed fields.");
            return;
        } else {
            document.EXTERNAL_ORDER_FORM.action = "<%=context%>/IssueServlet?op=saveOrderRequestsForm&issueId=<%=issueId%>";
            document.EXTERNAL_ORDER_FORM.submit();
        }
    }

    function cancelForm() {
        close();
    }

    function changePic() {
        var fileName = document.getElementById("file1").value;
        var arrfileName = fileName.split(".");
        document.getElementById("fileExtension").value = arrfileName[1];
        document.getElementById("docType").value = arrfileName[1];

        if (fileName.length > 0) {

            if (fileName.indexOf("doc") > -1 || fileName.indexOf("DOC") > -1) {
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            } else if (fileName.indexOf("docx") > -1 || fileName.indexOf("DOCX") > -1) {
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            } else if (fileName.indexOf("xls") > -1 || fileName.indexOf("XLS") > -1) {
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            } else if (fileName.indexOf("xlsx") > -1 || fileName.indexOf("XLSX") > -1) {
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            } else if (fileName.indexOf("ppt") > -1 || fileName.indexOf("PPT") > -1) {
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            } else if (fileName.indexOf("pptx") > -1 || fileName.indexOf("PPTX") > -1) {
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            } else if (fileName.indexOf("pdf") > -1 || fileName.indexOf("PDF") > -1) {
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            } else if (fileName.indexOf("htm") > -1 || fileName.indexOf("HTM") > -1) {
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            } else if (fileName.indexOf("txt") > -1 || fileName.indexOf("TXT") > -1) {
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            } else if (fileName.indexOf("ppt") > -1 || fileName.indexOf("PPT") > -1) {
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            } else if (fileName.indexOf("mpp") > -1 || fileName.indexOf("MPP") > -1) {
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            } else if (fileName.indexOf("vsd") > -1 || fileName.indexOf("VSD") > -1) {
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';     
            } else if (fileName.indexOf("vsd") > -1 || fileName.indexOf("VSD") > -1) {
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            } else if (fileName.indexOf("jpg") > -1 || fileName.indexOf("JPG") > -1) {
                document.getElementById("imageName").value = fileName;
                //                document.getElementById("file1").value = '';
            } else if (fileName.indexOf("eml") > -1 || fileName.indexOf("EML") > -1) {
                document.getElementById("imageName").value = fileName;
                //document.getElementById("file1").value = '';
            } else if (fileName.indexOf("rar") > -1 || fileName.indexOf("RAR") > -1) {
                document.getElementById("imageName").value = fileName;
                // document.getElementById("file1").value = '';     
            } else {
                alert("Invalid File type");
                document.getElementById("file1").focus();
                //getNoImage();
                document.getElementById("imageName").value = "";
            }
        } else {
            //getNoImage();
            document.getElementById("imageName").value = "";
        }
    }
</SCRIPT>

<style>  
    .titlebar {
        background-image: url(images/title_bar.png);
        background-position-x: 50%;
        background-position-y: 50%;
        background-size: initial;
        background-repeat-x: repeat;
        background-repeat-y: no-repeat;
        background-attachment: initial;
        background-origin: initial;
        background-clip: initial;
        background-color: rgb(204, 204, 204);
    }
</style>

<script src='js/ChangeLang.js' type='text/javascript'></script>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Attached file</TITLE>
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/autosuggest.css">
        <LINK rel="stylesheet" type="text/css" href="css/datechooser.css">
        <LINK rel="stylesheet" type="text/css" href="css/select-free.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/ajaxtabs.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <script type="text/javascript" src="jquery-ui/jquery.tools.min.js.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script>
            $(function() {
                $("#documentDate").datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd",
                    showSecond: false,
                    timeFormat: "hh:mm"
                });
            });
        </script>
    </HEAD>

    <BODY>
        <FORM action=""  NAME="EXTERNAL_ORDER_FORM" METHOD="POST" ENCTYPE="multipart/form-data">
            <input type="hidden" name="type" id="type" value="project"/>
            <input type=HIDDEN name="docType" id="docType" value="">
            <input type=HIDDEN name="fileExtension" id="fileExtension" value="" >
            <input type=HIDDEN name="businessId" id="businessId" value="<%=issue.getAttribute("businessID")%>" >
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
                <%
                    String fileAttached = (String) request.getAttribute("fileAttached");%>
                <button  onclick="JavaScript: cancelForm();" class="button"> <%=cancel%> <IMG alt="" SRC="images/cancel.gif"></button>
                <button  onclick="JavaScript: submitForm();" class="button"><%=save%> <IMG alt="" HEIGHT="15" SRC="images/save.gif"></button>
            </DIV>
            <br>
            <center>
                <fieldset class="set" style="width:95%;border-color: #006699;" >
                    <% if (fileAttached == null) { %>
                    <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td width="100%" class="titlebar">
                                <font color="#005599" size="4"><%=Titel%></font>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <% } %>
                    <% if (fileAttached != null && fileAttached.equalsIgnoreCase("ok")) {%>
                    <div align="center" style="color: blue" width="50%">
                        <table border="0" cellpadding="0" cellspacing="0" width="350px">
                            <tr>
                                <td style="border: 0 solid; text-align: center; font-size: large;" class="excelentCell formInputTag">
                                    <%=attachedMessage%>
                                </td>
                            </tr>
                        </table>
                        <br /><br />
                    </div>
                    <% } else {
                        if (fileAttached != null && fileAttached.equalsIgnoreCase("no")) {
                        %>
                        <div align="center" style="color: blue" width="50%">
                            <p dir="<%=dir%>" align="divAlign" style="font-weight: bold;font-size: 12px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><%=fileSizeLarge%></b></p>
                        </div>
                        <%
                            }
                        if (null != status && status.equalsIgnoreCase("ok")) {%>  
                    <div align="center" style="color: blue" width="50%">
                        <table border="0" cellpadding="0" cellspacing="0" width="350px">
                            <tr>
                                <td style="border: 0 solid; text-align: center">
                                    <font color="red" size="3"><%=issue.getAttribute("businessID")%></font>
                                    /
                                    <font color="blue" size="3" ><%=issue.getAttribute("businessIDbyDate")%></font>
                                </td>
                                <td style="border: 0 solid; text-align: center" class="excelentCell formInputTag">
                                    <p dir="<%=dir%>" align="divAlign" style="width:100%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><font size=3 color="black"><%=followUpNo%></font></b></p>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <% } else if (null != status && status.equalsIgnoreCase("no")) {%>
                    <div align="center" style="color: blue" width="50%">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><font size=3 color="red" >save not complete</font></b></p>
                    </div>
                    <% } %>
                    <% } %>
                    <br>
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                        <TR>
                            <TD class="td" width="50%">
                                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                                    <TR>
                                        <TD nowrap STYLE="<%=style%>;font-size: 15px" class="td"><b><%=sTitel%></b></TD>
                                        <TD STYLE="<%=style%>" class='td'>
                                            <input  type="text" name="documentTitle" id="documentTitle" size="25" value="<%=defaultTitle%>" maxlength="255" style="width:230px">
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD nowrap  STYLE="<%=style%>;font-size: 15px" class="td"><b><%=FTYP%></b></TD>
                                        <TD STYLE="<%=style%>" class='td'>
                                            <SELECT name="configType" style="width:230px" readonly="true">
                                                <sw:WBOOptionList wboList="<%=configType%>" valueAttribute="typeID" displayAttribute="typeName" scrollTo = '<%=(String) docType.getAttribute("typeName")%>'/>
                                            </SELECT>
                                        </TD>
                                    </TR>

                                    <TR>
                                        <TD nowrap STYLE="<%=style%>;font-size: 15px" class="td"><b><%=FDA%></b></TD>
                                        <td STYLE="<%=style%>"  class="calender">
                                            <input id="documentDate" name="documentDate" type="text" value="<%=nowDate%>">
                                        </td>
                                    </TR>


                                    <TR>
                                        <TD nowrap STYLE="<%=style%>" class="td"><FONT FACE="tahoma"><b><%=desc%><font color="#FF0000">*</font>&nbsp;</b></font></TD>
                                        <TD STYLE="<%=style%>"class='td' COLSPAN="3">
                                            <TEXTAREA rows="5" style="width:230px" name="description" id="description" cols="80"><%=defaultTitle%></TEXTAREA>
                                        </TD>
                                    </TR>

                                    <TR>
                                        <TD nowrap STYLE="<%=style%>;font-size: 15px" class="td"><b><%=attach%></b></TD>
                                        <TD STYLE="<%=style%>"class='td' COLSPAN="3">
                                            <input type="file" name="file1" style="height: 25px" id="file1" onchange="JavaScript: changePic();">
                                            <input type="hidden" name="imageName" id="imageName" value="">
                                        </TD>
                                    </TR>

                                    <TR>
                                        <TD class="td"></TD>
                                    </TR>
                                </TABLE>
                            </TD>
                            <TD class="td" width="5%">
                                &ensp;
                            </TD>
                        </TR>
                    </TABLE>
                </fieldset>
            </center>
            <input type="hidden" id="subject" name="subject" value="طلب تسليم مستخلص" />
            <input type="hidden" id="comment" name="comment" value="طلب تسليم مستخلص" />
            <input type="hidden" id="ticketType" name="ticketType" value="6" />
        </FORM>
    </BODY>
</HTML>