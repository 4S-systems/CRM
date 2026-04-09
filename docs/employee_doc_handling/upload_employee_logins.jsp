<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    ArrayList<LiteWebBusinessObject> list = (ArrayList<LiteWebBusinessObject>) request.getAttribute("list");
    String status = (String) request.getAttribute("status");
    String context = metaMgr.getContext();
    String stat = (String) request.getSession().getAttribute("currentMode");
    String align = null;
    String dir = null;
    String style = null;
    String save, title, attach;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        title = "Upload Employees Login from Excel";
        save = "Upload";
        attach = "Attach file";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        title = "Excel أدخال الحضور من ";
        save = " أدخال";
        attach = "أختيار الملف ";
    }
%>
<html>
    <head>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script src='js/ChangeLang.js' type='text/javascript'></script>
        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            $(document).ready(function () {
                $("#employees").css("display", "none");
                $('#employees').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });
            function submitForm() {
                if (document.getElementById("uploadFile").value === '') {
                    alert("يجب أختيار ملف");
                } else {
                    document.UPLOAD_LOGIN_FORM.action = "<%=context%>/EmployeeServlet?op=uploadEmployeeLogins";
                    document.UPLOAD_LOGIN_FORM.submit();
                }
            }

            function changePic() {
                var fileName = document.getElementById("uploadFile").value;
                var arrfileName = fileName.split(".");
                document.getElementById("fileExtension").value = arrfileName[1];
                document.getElementById("docType").value = arrfileName[1];
                if (fileName.length > 0) {
                    if (fileName.toLowerCase().indexOf("xlsx") > -1 || fileName.toLowerCase().indexOf("csv") > -1) {
                        document.getElementById("imageName").value = fileName;
                    } else {
                        alert("نوع الملف غير صحيح, المطلوب ملف من نوع xlsx أو من نوع csv");
                        document.getElementById("uploadFile").focus();
                        document.getElementById("uploadFile").value = "";
                        document.getElementById("imageName").value = "";
                    }
                } else {
                    document.getElementById("imageName").value = "";
                }
            }
        </script>
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
    </head>
    <body>
        <form name="UPLOAD_LOGIN_FORM" method="post" enctype="multipart/form-data">
            <input type="hidden" name="type" id="type" value="project" />
            <input type="hidden" name="docType" id="docType" value="" />
            <input type="hidden" name="fileExtension" id="fileExtension" value="" />
            <div align="left" style="color: blue;">
                <%
                    String fileAttached = (String) request.getAttribute("fileAttached");
                    if (fileAttached == null || !fileAttached.equalsIgnoreCase("ok")) {
                %>
                <button type="button" onclick="JavaScript: submitForm();" class="button">
                    <%=save%><img alt="" height="15" src="images/save.gif"/>
                </button>
                <%
                    }
                %>
            </div>
            <br/>
            <center>
                <fieldset class="set" style="width:95%;border-color: #006699;">
                    <legend align="center">
                        <table dir="<%=dir%>" align="<%=align%>">
                            <tr>
                                <td class="td">
                                    <font color="blue" size="6">
                                    <%=title%> 
                                    </font>
                                </td>
                            </tr>
                        </table>
                    </legend>
                    <%
                        if (null != status && status.equalsIgnoreCase("false")) {
                    %>
                    <div align="center" style="color: blue" width="50%">
                        <p dir="<%=dir%>" align="divAlign" style="width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><font size=3 color="red" >لم يتم اﻷدخال. حدث خطأ.</font></b></p>
                    </div>
                    <%
                        }
                        if (null != status && status.equalsIgnoreCase("true")) {
                    %>
                    <div align="center" style="color: blue" width="50%">
                        <p dir="<%=dir%>" align="divAlign" style="width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><font size=3 color="green" >تم أدخال البيانات بنجاح</font></b></p>
                    </div>
                    <%
                        }
                    %>
                    <br/>
                    <table align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0" border="0">
                        <tr>
                            <td class="td" width="50%">
                                <table align="<%=align%>" dir="<%=dir%>" cellpadding="0" cellspacing="0" border="0">
                                    <tr>
                                        <td nowrap style="<%=style%>;font-size: 15px" class="td"><b><%=attach%></b></td>
                                        <td style="<%=style%>"class='td' COLSPAN="3">
                                            <input type="file" name="uploadFile" style="height: 25px" id="uploadFile" onchange="JavaScript: changePic();">
                                            <input type="hidden" name="imageName" id="imageName" value="">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="td"></td>
                                    </tr>
                                </table>
                            </td>
                            <td class="td" width="5%">
                                &ensp;
                            </td>
                        </tr>
                    </table>
                    <br/><br/><br/>
                    <%
                        if (list != null) {
                    %>
                    <div style="width: 87%; margin-right: auto; margin-left: auto;" id="showClients">
                        <table align="<%=align%>" dir='<fmt:message key="direction"/>' width="100%" id="employees">
                            <thead>
                                <tr>
                                    <th style="color: #005599 !important; font-size: 14px; font-weight: bold;">No.</th>
                                    <th style="color: #005599 !important; font-size: 14px; font-weight: bold;">Name</th>
                                    <th style="color: #005599 !important; font-size: 14px; font-weight: bold;">Login Date/Time</th>
                                    <th style="color: #005599 !important; font-size: 14px; font-weight: bold;">Logout Date/Time</th>
                                    <th style="color: #005599 !important; font-size: 14px; font-weight: bold;">Timetable</th>
                                </tr>
                            <thead>
                            <tbody>  
                                <%
                                    for (LiteWebBusinessObject wbo : list) {
                                %>
                                <tr style="cursor: pointer" id="row">
                                    <td>
                                        <b>
                                            <%=wbo.getAttribute("employeeNo")%> 
                                        </b>
                                    </td>
                                    <td>
                                        <b>
                                            <%=wbo.getAttribute("employeeName")%> 
                                        </b>
                                    </td>
                                    <td>
                                        <b>
                                            <%=wbo.getAttribute("loginDate") != null && wbo.getAttribute("loginDate").toString().length() >= 16 ? wbo.getAttribute("loginDate").toString().substring(0, 16) : "---"%> 
                                        </b>
                                    </td>
                                    <td>
                                        <b>
                                            <%=wbo.getAttribute("logoutDate") != null && wbo.getAttribute("logoutDate").toString().length() >= 16 ? wbo.getAttribute("logoutDate").toString().substring(0, 16) : "---"%> 
                                        </b>
                                    </td>
                                    <td>
                                        <b>
                                            <%=wbo.getAttribute("timeTable")%> 
                                        </b>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                    <%
                        }
                    %>
                </fieldset>
            </center>
        </form>
    </body>
</html>