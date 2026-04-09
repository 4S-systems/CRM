<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.docviewer.db_access.DocTypeMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants,com.contractor.db_access.MaintainableMgr"%>
<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String status = (String) request.getAttribute("status");
    ArrayList<WebBusinessObject> inspectionsList = (ArrayList<WebBusinessObject>) request.getAttribute("inspectionsList");

    String context = metaMgr.getContext();
    Calendar cal = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowDate = sdf.format(cal.getTime());

    String stat = (String) request.getSession().getAttribute("currentMode");
    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode, cancel, save, sTitel;
    String FDA, desc, defaultTitle;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "&#1593;&#1585;&#1576;&#1610;";
        langCode = "Ar";
        cancel = "Cancel";
        save = "Create";
        sTitel = "Schedule Title ";
        save = "Create";
        FDA = "Document date";
        desc = "Description";
        defaultTitle = "attached file";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cancel = "إنهاء";
        sTitel = " &#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
        save = " &#1587;&#1580;&#1604; &#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1607; ";
        save = " &#1587;&#1580;&#1604;";
        FDA = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;";
        desc = "&#1575;&#1604;&#1608;&#1589;&#1601;";
        defaultTitle = "\u0645\u0633\u062a\u062e\u0644\u0635";
    }
%>


<html>
    <head>
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <link rel="stylesheet" TYPE="text/css" href="css/CSS.css"/>
        <link rel="stylesheet" TYPE="text/css" href="css/Button.css"/>
        <link rel="stylesheet" TYPE="text/css" href="css/autosuggest.css"/>
        <link rel="stylesheet" type="text/css" href="css/datechooser.css"/>
        <link rel="stylesheet" type="text/css" href="css/select-free.css"/>
        <link rel="stylesheet" type="text/css" href="css/ajaxtabs.css"/>
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" src="jquery-ui/jquery.tools.min.js.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script src='silkworm_validate.js' type='text/javascript'></script>
        <script src='js/ChangeLang.js' type='text/javascript'></script>
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
        <script>
            $(function () {
                $("#requestDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd",
                    minDate: 0
                });
            });
            function submitForm() {
                if (!validateData("req", document.QUALITY_INSPECTION_FORM.requestTitle, "أختر العمل المطلوب...")) {
                    $("requestTitle").focus();
                } else if (document.getElementById('comments').value === "") {
                    alert("أدخل الوصف");
                    $('#comments').focus();
                } else {
                    document.QUALITY_INSPECTION_FORM.action = "<%=context%>" + "/IssueServlet?op=createGeneralQuality";
                    document.QUALITY_INSPECTION_FORM.submit();
                    $("#submitButton").attr("disabled", true);
                }
            }
            function cancelForm() {
                close();
            }
            function changeDate(obj) {
                $("#entryDate").val($(obj).val() + " 00:00");
            }
        </script>
    </head>

    <body>
        <form name="QUALITY_INSPECTION_FORM" method="POST">
            <input type="hidden" name="clientId" value="2"/>
            <input type="hidden" id="entryDate" name="entryDate" value="<%=nowDate%> 00:00"/>
            <input type="hidden" name="call_status" value="none"/>
            <div align="left" style="color:blue;">           
                <%
                    String fileAttached = (String) request.getAttribute("fileAttached");
                    if (fileAttached == null || !fileAttached.equalsIgnoreCase("ok")) {
                %>
                <button  onclick="JavaScript: cancelForm();" class="button"> <%=cancel%> <IMG alt="" SRC="images/cancel.gif"></button>
                <button type="button" onclick="JavaScript: submitForm();" class="button" id="submitButton"><%=save%> <IMG alt="" HEIGHT="15" SRC="images/save.gif"></button>
                    <%
                        }
                    %>
            </div>
            <br>
            <center>
                <fieldset class="set" style="width:55%; border-color: #006699;" >
                    <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td width="100%" class="titlebar">
                                <font color="#005599" size="4">الجودة العامة</font>
                            </td>
                        </tr>
                    </table>
                    <%
                        if (null != status && status.equalsIgnoreCase("failed")) {
                    %>
                    <div align="center" style="color: blue" width="50%">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><font size=3 color="red" >لم يتم التسجيل</font></b></p>
                    </div>
                    <% } else if (null != status && status.equalsIgnoreCase("ok")) {%>
                    <div align="center" style="color: blue" width="50%">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><font size=3 color="green">تم التسجيل بنجاح</font></b></p>
                    </div>
                    <% }
                    %>
                    <br/>
                    <table align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td class="td" width="50%">
                                <table align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td class="backgroundTable" style="text-align: center; font-weight: bold; font-size: 14px;" nowrap>
                                            <b style="padding: 5px;">العمل المطلوب</b>
                                        </td>
                                        <td style="<%=style%>" class='td'>
                                            <select name="requestTitle" id="requestTitle" style="width:230px; font-size: 14px;">
                                                <option value="">أختر</option>
                                                <sw:WBOOptionList wboList="<%=inspectionsList%>" displayAttribute="projectName" valueAttribute="projectName"/>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="backgroundTable" style="text-align: center; font-weight: bold; font-size: 14px;" nowrap>
                                            <b style="padding: 5px;">بتاريخ</b>
                                        </td>
                                        <td style="<%=style%>" class="td">
                                            <input id="requestDate" name="requestDate" type="text" value="<%=nowDate%>" style="width: 230px;" readonly="true"
                                                   onchange="JavaScript: changeDate(this);"/>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td class="backgroundTable" style="text-align: center; font-weight: bold; font-size: 14px;" nowrap>
                                            <b style="padding: 5px;"><%=desc%>&nbsp;</b>
                                        </td>
                                        <td style="<%=style%>" class="td">
                                            <textarea rows="5" style="width:230px" name="comments" id="comments" cols="80"></textarea>
                                        </td>
                                    </tr>
                                </table>
                                <br/><br/>
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