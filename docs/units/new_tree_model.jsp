<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.docviewer.db_access.DocTypeMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String projId = request.getParameter("projId");
    WebBusinessObject project = (WebBusinessObject) request.getAttribute("project");
    DocTypeMgr docTypeMgr = DocTypeMgr.getInstance();
    ArrayList configType = docTypeMgr.getCashedTableAsBusObjects();
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

    String stat = (String) request.getSession().getAttribute("currentMode");
    String align = null;
    String dir = null;
    String style = null;
    String cancel, save, Titel, sTitel, M1, M2, attach, finishing, normal, meduim, high,
            totalArea, netArea, rooms, kitchens, bathroom, balcony, garage, storage,
            elevator, club;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        cancel = "Cancel";
        save = "Create";
        Titel = "New Model for Project ";
        sTitel = "Name";
        M1 = "Saved Successfuly";
        M2 = "There Is a problem In Saving";
        save = "Save";
        attach = "Attach file";
        finishing = "Finishing Type";
        normal = "Normal";
        meduim = "Meduim";
        high = "High";
        totalArea = "Total Area";
        netArea = "Net Area";
        rooms = "Romms No.";
        kitchens = "Kitchens";
        bathroom = "Bathroom No.";
        balcony = "Balcony No.";
        garage = "Garage";
        storage = "Storage";
        elevator = "Elevator";
        club = "Club";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        cancel = "إنهاء";
        Titel = "أنشاء نموذج سكني للمشروع ";
        M1 = "تم الحفظ بنجاح";
        M2 = "خطأ بالحفظ";
        sTitel = "الاسم";
        save = " سجل";
        attach = "إرفاق مستند";
        finishing = "نوع التشطيب";
        normal = "عادي";
        meduim = "متوسط";
        high = "فاخر";
        totalArea = "المســــاحة الكلية";
        netArea = "المساحة الصافية";
        rooms = "الغــــــرف";
        kitchens = "مــــطابخ";
        bathroom = "حمــــامات";
        balcony = "بــلكونات";
        garage = "جـــــــراج";
        storage = "تخــــــــزين";
        elevator = "اســــــانسير";
        club = "نــــــــادى";
    }
%>
<html>
    <head>
        <script src='js/ChangeLang.js' type='text/javascript'></script>
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <link REL="stylesheet" type="text/css" HREF="css/CSS.css"/>
        <link REL="stylesheet" type="text/css" HREF="css/Button.css"/>
        <link REL="stylesheet" type="text/css" HREF="css/autosuggest.css"/>
        <link rel="stylesheet" type="text/css" href="css/datechooser.css"/>
        <link rel="stylesheet" type="text/css" href="css/select-free.css"/>
        <link rel="stylesheet" type="text/css" href="css/ajaxtabs.css"/>
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css"/>
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css"/>
        <script type="text/javascript" src="jquery-ui/jquery.tools.min.js.js"></script>
        <script type="text/javascript" src="js/epoch_classes.js"></script>
        <script src='silkworm_validate.js' type='text/javascript'></script>
        <script language="JavaScript" type="text/javascript">
            var dp_cal1;
            window.onload = function () {
                dp_cal1 = new Epoch('epoch_popup', 'popup', document.getElementById('docDate'));
            };
            function submitForm() {
                if (document.getElementById('docDate').value == "") {
                    alert("Please, enter Date.");
                    document.getElementById('docDate').focus();
                    return;
                } else if (document.getElementById('description').value == "") {
                    alert("Please fill needed fields.");
                    return;
                } else {
                    document.NEW_MODEL_FORM.action = "<%=context%>/UnitDocWriterServlet?projId=<%=projId%>&op=saveNewModel";
                    document.NEW_MODEL_FORM.submit();
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
                    } else if (fileName.indexOf("docx") > -1 || fileName.indexOf("DOCX") > -1) {
                        document.getElementById("imageName").value = fileName;
                    } else if (fileName.indexOf("xls") > -1 || fileName.indexOf("XLS") > -1) {
                        document.getElementById("imageName").value = fileName;
                    } else if (fileName.indexOf("xlsx") > -1 || fileName.indexOf("XLSX") > -1) {
                        document.getElementById("imageName").value = fileName;
                    } else if (fileName.indexOf("ppt") > -1 || fileName.indexOf("PPT") > -1) {
                        document.getElementById("imageName").value = fileName;
                    } else if (fileName.indexOf("pptx") > -1 || fileName.indexOf("PPTX") > -1) {
                        document.getElementById("imageName").value = fileName;
                    } else if (fileName.indexOf("pdf") > -1 || fileName.indexOf("PDF") > -1) {
                        document.getElementById("imageName").value = fileName;
                    } else if (fileName.indexOf("htm") > -1 || fileName.indexOf("HTM") > -1) {
                        document.getElementById("imageName").value = fileName;
                    } else if (fileName.indexOf("txt") > -1 || fileName.indexOf("TXT") > -1) {
                        document.getElementById("imageName").value = fileName;
                    } else if (fileName.indexOf("ppt") > -1 || fileName.indexOf("PPT") > -1) {
                        document.getElementById("imageName").value = fileName;
                    } else if (fileName.indexOf("mpp") > -1 || fileName.indexOf("MPP") > -1) {
                        document.getElementById("imageName").value = fileName;
                    } else if (fileName.indexOf("vsd") > -1 || fileName.indexOf("VSD") > -1) {
                        document.getElementById("imageName").value = fileName;
                    } else if (fileName.indexOf("vsd") > -1 || fileName.indexOf("VSD") > -1) {
                        document.getElementById("imageName").value = fileName;
                    } else if (fileName.indexOf("jpg") > -1 || fileName.indexOf("JPG") > -1) {
                        document.getElementById("imageName").value = fileName;
                    } else if (fileName.indexOf("eml") > -1 || fileName.indexOf("EML") > -1) {
                        document.getElementById("imageName").value = fileName;
                    } else if (fileName.indexOf("rar") > -1 || fileName.indexOf("RAR") > -1) {
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
            function isNumber(evt) {
                var iKeyCode = (evt.which) ? evt.which : evt.keyCode
                if (iKeyCode != 46 && iKeyCode > 31 && (iKeyCode < 48 || iKeyCode > 57)) {
                    alert("أرقام فقط");
                    return false;
                }
                return true;
            }
        </script>
    </head>
    <body>
        <form action="" name="NEW_MODEL_FORM" method="POST" enctype="multipart/form-data">
            <input type="hidden" name="type" id="type" value="project"/>
            <input type="hidden" name="docType" id="docType" value=""/>
            <input type="hidden" name="fileExtension" id="fileExtension" value=""/>
            <input type="hidden" name="configType" id="configType" value="1"/>
            <input type="hidden" name="docDate" id="docDate" value="<%=nowDate%>"/>
            <input type="hidden" name="description" id="description" value="Model Image"/>
            <input type="hidden" name="futile" ID="futile" value="0">
            <input type="hidden" name="location_type" ID="location_type" value="RES-MODEL">
            <div align="left" STYLE="color:blue;">
                <button  onclick="JavaScript: cancelForm();" class="button"> <%=cancel%> <IMG alt="" SRC="images/cancel.gif"></button>
                <button  onclick="JavaScript: submitForm();" class="button"><%=save%> <IMG alt="" HEIGHT="15" SRC="images/save.gif"></button>
            </div>
            <br>
            <center>
                <fieldset class="set" style="width:95%;border-color: #006699;" >
                    <table class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=Titel%> <%=project.getAttribute("projectName")%></font></td>
                        </tr>
                    </table>
                    <br>
                    <%
                        if (null != status) {
                            if (status.equalsIgnoreCase("ok")) {
                                message = M1;
                            } else {
                                message = M2;
                            }
                    %>
                    <table align="<%=align%>" dir="<%=dir%>" width="600" cellpadding="0" cellspacing="0" STYLE="border-right-width:1px;">
                        <tr bgcolor="FBE9FE">
                            <td STYLE="<%=style%>" class="td">
                                <b><font FACE="tahoma" color='blue'><%=message%></font></b>
                            </td>
                        </tr>
                    </table>
                    <br/><br/>
                    <% }%>
                    <br/>
                    <table align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td class="td" width="50%">
                                <table align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td nowrap STYLE="<%=style%>; font-size: 15px" class="td"><b><%=sTitel%></b></td>
                                        <td STYLE="<%=style%>" class='td'>
                                            <input type="text" name="title" id="title" size="25" value="" maxlength="255" style="width:230px">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap STYLE="<%=style%>; font-size: 15px" class="td"><b><%=finishing%></b></td>
                                        <td STYLE="<%=style%>" class='td'>
                                            <input type="radio" name="category" value="Normal" checked="true"><%=normal%></input>
                                            <input type="radio" name="category" value="Meduim"><%=meduim%></input>
                                            <input type="radio" name="category" value="high"><%=high%></input>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap STYLE="<%=style%>; font-size: 15px" class="td"><b><%=totalArea%></b></td>
                                        <td STYLE="<%=style%>" class='td'>
                                            <input type="number" style="width: 50px;" value="" maxlength="255" name="total_area" id="total_area" onkeypress="JavaScript: return isNumber(event);"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap STYLE="<%=style%>; font-size: 15px" class="td"><b><%=netArea%></b></td>
                                        <td STYLE="<%=style%>" class='td'>
                                            <input type="number" style="width: 50px;" value="" maxlength="255" name="net_area" id="net_area" onkeypress="JavaScript: return isNumber(event);"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap STYLE="<%=style%>; font-size: 15px" class="td"><b><%=rooms%></b></td>
                                        <td STYLE="<%=style%>" class='td'>
                                            <input type="number" style="width: 50px;" value="" maxlength="255" name="rooms_no" id="rooms_no" onkeypress="JavaScript: return isNumber(event);"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap STYLE="<%=style%>; font-size: 15px" class="td"><b><%=kitchens%></b></td>
                                        <td STYLE="<%=style%>" class='td'>
                                            <input type="number" style="width: 50px;" value="" maxlength="255" name="kitchens_no" id="kitchens_no" onkeypress="JavaScript: return isNumber(event);"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap STYLE="<%=style%>; font-size: 15px" class="td"><b><%=bathroom%></b></td>
                                        <td STYLE="<%=style%>" class='td'>
                                            <input type="number" style="width: 50px;" value="" maxlength="255" name="pathroom_no" id="pathroom_no" onkeypress="JavaScript: return isNumber(event);"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap STYLE="<%=style%>; font-size: 15px" class="td"><b><%=balcony%></b></td>
                                        <td STYLE="<%=style%>" class='td'>
                                            <input type="number" style="width: 50px;" value="" maxlength="255" name="balcony_no" id="balcony_no" onkeypress="JavaScript: return isNumber(event);"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap STYLE="<%=style%>; font-size: 15px" class="td">
                                            <b><%=garage%></b>
                                        </td>
                                        <td STYLE="<%=style%>" class='td'>
                                            <input type="checkbox" size="12" name="garage" id="garage"/>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <b><%=storage%></b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <input type="checkbox" size="12" name="storage" id="storage"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap STYLE="<%=style%>; font-size: 15px" class="td">
                                            <b><%=elevator%></b>
                                        </td>
                                        <td STYLE="<%=style%>" class='td'>
                                            <input type="checkbox" size="12" name="elevator" id="elevator"/>
                                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                            <b><%=club%></b>&Tab;&nbsp;&Tab;&nbsp;&Tab;&nbsp;&Tab;&nbsp;&Tab;
                                            <input type="checkbox" size="12" name="club" id="club"/>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap STYLE="<%=style%>; font-size: 15px" class="td"><b><%=attach%></b></td>
                                        <td STYLE="<%=style%>"class='td' COLSPAN="3">
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