<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    HttpSession s = request.getSession();

    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
    ArrayList<WebBusinessObject> emails = (ArrayList<WebBusinessObject>) request.getAttribute("emails");

    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String[] tableHeader = new String[6];

    String message = null;
    String lang, langCode, title, Show, mainData, EquipmentRow, selectMain, link1, link2, link3, link4, link5, M1, M2, Dupname, unit;
    String open, add, deleteProjectLabel, geographicLoc, updateProject, attachedImage, unitCategoryId = "";
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1410;    ";
        langCode = "Ar";
        title = "Equipment Tree";
        Show = "Show Tree";
        unit = "unit";
        EquipmentRow = "Equipment Categories";
        selectMain = "Select Main Type";
        link1 = "Equipment Details";
        link2 = "Last Job Order";
        link3 = "Schedules";
        link4 = "Equipment Plan";
        link5 = "Related Parts";
        tableHeader[0] = "id";
        tableHeader[1] = "username";
        tableHeader[2] = "email";
        tableHeader[3] = "full name";
        M1 = "The Saving Successed";
        M2 = "The Saving Successed Faild";
        Dupname = "Name is Duplicated Change it";
        open = "Main Information ";
        add = "New sub Project";
        deleteProjectLabel = "Delete Project";
        geographicLoc = "Geographic Location";
        updateProject = "Update Location";
        attachedImage = "Attached image";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        title = "المنتجات";
        unit = "&#1573;&#1587;&#1405; &#1575;&#1404;&#1408;&#1581;&#1583;&#1577;";
        Show = "&#1576;&#1581;&#1579;";
        EquipmentRow = " &#1575;&#1404;&#1406;&#1408;&#1593; &#1575;&#1404;&#1575;&#1587;&#1575;&#1587;&#1410;";
        selectMain = "&#1571;&#1582;&#1578;&#1585; &#1406;&#1408;&#1593; &#1585;&#1574;&#1410;&#1587;&#1410;";
        link1 = "&#1578;&#1401;&#1575;&#1589;&#1410;&#1404; &#1575;&#1404;&#1405;&#1593;&#1583;&#1407;";
        link2 = "&#1593;&#1585;&#1590; &#1571;&#1582;&#1585; &#1571;&#1405;&#1585; &#1588;&#1594;&#1404;";
        link3 = "&#1575;&#1404;&#1580;&#1583;&#1575;&#1408;&#1404;";
        link4 = "&#1575;&#1404;&#1582;&#1591;&#1407;";
        link5 = "&#1402;&#1591;&#1593; &#1575;&#1404;&#1594;&#1410;&#1575;&#1585;";
        M1 = "&#1578;&#1405; &#1575;&#1404;&#1578;&#1587;&#1580;&#1410;&#1404; &#1576;&#1406;&#1580;&#1575;&#1581; ";
        tableHeader[0] = "كود الوحدة";
        tableHeader[1] = "م-الوحدة";
        tableHeader[2] = "وصف الوحدة";
        tableHeader[3] = "م-الحديقة";
        tableHeader[4] = "الحالة";
        tableHeader[5] = "";
        open = "المعلومات الأساسية";
        add = "موقع فرعي جديد";
        deleteProjectLabel = "حذف الموقع";
        geographicLoc = "الموقع الجغرافى";
        updateProject = "تحديث الموقع";
        attachedImage = "الصور المرفقة";
        M2 = "&#1404;&#1405; &#1410;&#1578;&#1405; &#1575;&#1404;&#1578;&#1587;&#1580;&#1410;&#1404;";
        Dupname = "&#1407;&#1584;&#1575; &#1575;&#1404;&#1575;&#1587;&#1405; &#1587;&#1580;&#1404; &#1405;&#1406; &#1402;&#1576;&#1404; &#1410;&#1580;&#1576; &#1578;&#1587;&#1580;&#1410;&#1404; &#1575;&#1587;&#1405; &#1570;&#1582;&#1585;";
    }

    ArrayList treeMenu = metaMgr.getTreeMenu();
    if (treeMenu.get(0) == null) {
        System.out.println("jkdshfljksahdfjklshdlkjfsdh kjlg");

    }
%>
<html>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <link rel="StyleSheet" href="treemenu/css/dtree.css" type="text/css" />
        <link rel="stylesheet" type="text/css" href="treemenu/page_style.css" />
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="treemenu/script/contextmenu.js"></script>
        <script type="text/javascript" src="treemenu/script/dtree.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/autosuggest.css">
        <LINK rel="stylesheet" type="text/css" href="css/datechooser.css">
        <LINK rel="stylesheet" type="text/css" href="css/select-free.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/ajaxtabs.css"/>
        <LINK rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <LINK rel="stylesheet" type="text/css" href="css/epoch_styles.css"/>
        <script type="text/javascript" src="jquery-ui/jquery.tools.min.js.js"></script>
        <script type="text/javascript">
            function sendMailss()
            {
                var fileName = document.getElementById("file1").value;

                if ($('#subject').val() === "") {
                    alert("You haven't email subject!");
                    return false;
                }

                if ($('#message').val() === "") {
                    alert("You haven't email body!");
                    return false;
                }
                
                if ($('#toMails:checkbox:checked').length === 0) {
                    alert("You haven't email address!");
                    return false;
                }

                if (fileName.length > 0)
                {
                    var fileExtPos = fileName.lastIndexOf('.');
                    var fileTitlePos = fileName.lastIndexOf('\\');
                    var fileExt = fileName.substr(fileExtPos + 1);
                    var fileTitle = fileName.substring(fileTitlePos + 1, fileExtPos);

                    document.getElementById("fileExtension").value = fileExt;
                    document.getElementById("docTitle").value = fileTitle;

                    document.emailForm.action = "<%=context%>/EmailServlet?op=sendSpeicalEmail&fileExtension=" + fileExt;
                    document.emailForm.submit();
                } else {
                    alert('No File Selected');
                    return false;
                }
            }
            
            function toggle(source) {
                if (source.checked) {
                    $(':checkbox').each(function () {
                        this.checked = true;
                    });
                } else {
                    $(':checkbox').each(function () {
                        this.checked = false;
                    });
                }
            }
        </script>

        <style type="text/css">
            .titlebar {
                height: 30px;
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
            #row:hover{
                cursor: pointer;
                background-color: #D3E3EB !important;
            }
        </style>
        <style >
            a{
                color:blue;
                background-color: transparent;
                text-decoration: none;
                font-size:12px;
                font-weight:bold;
            }
            #frame{
                background-color: #dfdfdf;
                margin: auto;
            }
            #open, #email, #save,#delete,#insert{
                font-size: 12px;
                font-weight: bold;
            }
            .save {
                /*                margin-right: 100px;*/
                width:20px;
                height:20px;
                background-image:url(images/icons/check1.png);
                background-repeat: no-repeat;
                cursor: pointer;


            }
            .close {
                float: right;
                clear: both;
                width:24px;
                height:24px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/close.png);

            }
            .popup_content{ 

                border: none;

                direction:rtl;
                padding:0px;
                margin-top: 10px;
                /*border: 1px solid tomato;*/
                /*background-color: #dfdfdf;*/
                margin-bottom: 5px;

                font:Verdana, Geneva, sans-serif;
                font-size:18px;
                font-weight:bold;
                /*display: none;*/
            }
            .login {
                /*display: none;*/
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                /*        width:30%;*/
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;
                background: #7abcff; /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                /*background: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiA/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDEgMSIgcHJlc2VydmVBc3BlY3RSYXRpbz0ibm9uZSI+CiAgPGxpbmVhckdyYWRpZW50IGlkPSJncmFkLXVjZ2ctZ2VuZXJhdGVkIiBncmFkaWVudFVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgeDE9IjAlIiB5MT0iMCUiIHgyPSIwJSIgeTI9IjEwMCUiPgogICAgPHN0b3Agb2Zmc2V0PSIwJSIgc3RvcC1jb2xvcj0iIzdhYmNmZiIgc3RvcC1vcGFjaXR5PSIxIi8+CiAgICA8c3RvcCBvZmZzZXQ9IjEwMCUiIHN0b3AtY29sb3I9IiM0MDk2ZWUiIHN0b3Atb3BhY2l0eT0iMSIvPgogIDwvbGluZWFyR3JhZGllbnQ+CiAgPHJlY3QgeD0iMCIgeT0iMCIgd2lkdGg9IjEiIGhlaWdodD0iMSIgZmlsbD0idXJsKCNncmFkLXVjZ2ctZ2VuZXJhdGVkKSIgLz4KPC9zdmc+);*/
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
        </style>
    </head>

    <body>
        <div id="sms_content" class="popup_content" >
            <%
                String status = (String) request.getAttribute("status");
                if (status.equals("ok")) {
            %>
            <div style="margin-left: auto;margin-right: auto;color: green;">تم الإرسال بنجاح</div>
            <%}%>
            <%
                if (status.equals("error")) {
            %>
            <div style="margin-left: auto;margin-right: auto;color: red;">لم يتم الإرسال</div>
            <%}%>
        </div>

        <div class="login" style="width: 70%;;margin: auto auto;text-align: center">
            <form method="post"  name="emailForm" enctype="multipart/form-data" >
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <img width="35" height="35" src="images/icons/HappyFirstBD.jpg" style="vertical-align: middle;" /> &nbsp;<font color="#005599" size="4">Speacial Happay Event</font>
                        </td>
                    </tr>
                </table>

                <br>

                <table  class="table" style="width: 100%;border: none;margin-left: auto;margin-right: auto;" cellpadding="5" cellspacing="4">
                    <tr>
                        <td  style="color:#000080; font-size: 14px;font-weight: bold;width: 10%;border: none">موضوع الرسالة</td>
                        <td style="text-align:right;border: none">
                            <input type="text" size="60" maxlength="60" id="subject" name="subject" style="width: 250px;"/>
                        </td>
                    </tr>

                    <tr>
                        <td  style="color:#000080; font-size: 14px;font-weight: bold;width: 10%;border: none">محتوى الرسالة</td>
                        <td style="border: none; text-align:right;">
                            <textarea placeholder="محتوى الرسالة" rows="3" cols="50" name="message" id="message" style="color: #27272A;border: none"> Happy Birth Day</textarea>
                        </td>
                    </tr>

                    <%
                        if (emails.size() > 0 && emails != null) {

                    %>
                    <tr>
                        <td style="color:#000080; font-size: 14px;font-weight: bold;width: 10%;border: none">إلى</td>
                        <td style="border: none; text-align:right;">
                            <table class="display"  id="indextable" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                                        <INPUT type="checkbox" id="toggleAll" name="toggleAll" onclick="toggle(this)"/>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px; width: 50px">
                                        كود العميل
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                                        اسم العميل
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                                        تاريخ الميلاد
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;">
                                        العنوان البريدي
                                    </td>
                                </tr>

                                <%                                    for (int i = 0; i < emails.size(); i++) {
                                        WebBusinessObject wbo = (WebBusinessObject) emails.get(i);
                                %>
                                <tr>
                                    <td>
                                        <input type="checkbox" id="toMails" name="toMails" value="<%=wbo.getAttribute("ClientEmail")%>">
                                    </td>
                                    <TD  CLASS="cell">
                                        <%=wbo.getAttribute("ClientNo")%>
                                    </TD>
                                    <TD  CLASS="cell">
                                        <%=wbo.getAttribute("ClientName")%>
                                    </TD>
                                    <TD  CLASS="cell">
                                        <%=wbo.getAttribute("ClientBirthDate")%>
                                    </TD>
                                    <TD  CLASS="cell">
                                        <%=wbo.getAttribute("ClientEmail")%>
                                    </TD>
                                    <%
                                        }
                                    %>
                                </tr>  
                            </table>
                            <%
                                }
                            %>
                        </td> 
                    </tr>
                    <tr>
                        <td  style="color:#000080; font-size: 14px;font-weight: bold;width: 10%;border: none">المرفقات</td>
                        <td style="<%=style%>" class="td">
                            <input type="file" name="file1"  id="file1" onchange="JavaScript: changePic();">
                            <input type="hidden" name="fileName" id="fileName" value="">
                            <input type="hidden" name="docType" value="">
                            <input type="hidden" name="docTitle" value="Employee File" id="docTitle">
                            <input type="hidden" name="description" value="Employee File">
                            <input type="hidden" name="faceValue" value="0">
                            <input type="hidden" name="fileExtension" value="" id="fileExtension">
                            <%
                                Calendar c = Calendar.getInstance();
                                Integer iMonth = new Integer(c.get(c.MONTH));
                                int month = iMonth.intValue() + 1;
                                iMonth = new Integer(month);
                            %>
                            <input type="hidden" name="docDate" value="<%=iMonth.toString() + "/" + c.get(c.DATE) + "/" + c.get(c.YEAR)%>">
                            <input type="hidden" name="configType" value="1">
                        </td>
                    </tr>

                    <tr >
                        <td colspan="2" style="border: none" > 
                            <input type="hidden" id="clientId" name="clientId"/>
                            <input type="button" value="إرســــــــــــــال" onclick="sendMailss()" />
                        </td>
                    </tr>
                </table>

            </form>
    </body>
</html>
