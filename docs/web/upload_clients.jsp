<%@page import="com.planning.db_access.SeasonMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String status = (String) request.getAttribute("status");
    ArrayList<WebBusinessObject> campaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList");
    ArrayList<WebBusinessObject> sourceList = (ArrayList<WebBusinessObject>) request.getAttribute("sourceList");
    ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
    String campaignID = (String) request.getAttribute("campaignID");
    String projectID = (String) request.getAttribute("projectID");
    String context = metaMgr.getContext();
    ArrayList<WebBusinessObject> seasonList = new ArrayList<>(SeasonMgr.getInstance().getOnArbitraryKeyOracle("1", "key2"));
    String stat = (String) request.getSession().getAttribute("currentMode");
    String align = null;
    String dir = null;
    String style = null;
    String save, title, attach, select;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        title = "Upload Clients from Excel";
        save = "Upload";
        attach = "Attach file";
        select = "Select";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        title = "Excel أدخال العملاء من ";
        save = " أدخال";
        attach = "أختيار الملف ";
        select = "أختر";
    }
%>
<html>
    <head>
        <script type="text/javascript" src="jquery-ui/jquery.tools.min.js.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script src='silkworm_validate.js' type='text/javascript'></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <link rel="stylesheet" href="css/chosen.css"/>
        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            function submitForm() {
                if (!validateData("req", document.UPLOAD_CLIENTS_FORM.campaignID, "Must Choose Campaign...")) {
                    $("#campaignID").focus();
                } else if (document.getElementById("uploadFile").value == '') {
                    alert("Must Choose File");
                } else {
                    document.UPLOAD_CLIENTS_FORM.action = "<%=context%>/ManageWebClientServlet?op=uploadClientsFromExcel&campaignID=" + $("#campaignID").val() + "&sourceID=" + $("#sourceID").val() + "&season=" + $("#season").val() + "&projectID=" + $("#projectID").val();
                    document.UPLOAD_CLIENTS_FORM.submit();
                }
            }

            function cancelForm() {
                close();
            }

            function changePic() {
                var fileName = document.getElementById("uploadFile").value;
                var arrfileName = fileName.split(".");
                document.getElementById("fileExtension").value = arrfileName[1];
                document.getElementById("docType").value = arrfileName[1];
                if (fileName.length > 0) {
                    if (fileName.indexOf("xlsx") > -1 || fileName.indexOf("XLSX") > -1 || fileName.indexOf("csv") > -1 || fileName.indexOf("CSV") > -1) {
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
            function getProjects(obj) {
                $.ajax({
                    type: "post",
                    url: '<%=context%>/CampaignServlet?op=getProjectsAjax',
                    data: {
                        campaignID: $(obj).val()
                    },
                    success: function (dataStr) {
                        var result = $.parseJSON(dataStr);
                        var options = [];
                        options.push("<option value=''>", "<%=select%>", "</option>");
                        try {
                            $.each(result, function () {
    //                            alert("(" + this.projectName + ")");
                                if (this.projectName) {
                                    options.push('<option value="', this.projectID, '">', this.projectName, '</option>');
                                }
                            });
                        } catch (err) {
                        }
                        $("#projectID").html(options.join(''));
                    }
                });
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
        <script src='js/ChangeLang.js' type='text/javascript'></script>
    </head>
    <body>
        <form NAME="UPLOAD_CLIENTS_FORM" METHOD="POST" ENCTYPE="multipart/form-data">
            <input type="hidden" name="type" id="type" value="project"/>
            <input type=HIDDEN name="docType" id="docType" value="">
            <input type=HIDDEN name="fileExtension" id="fileExtension" value="" >
            <div align="left" STYLE="color:blue;">
                <%
                    String fileAttached = (String) request.getAttribute("fileAttached");
                    if (fileAttached == null || !fileAttached.equalsIgnoreCase("ok")) {%>
                <button type="button" onclick="JavaScript: submitForm();" class="button"><%=save%> <IMG alt="" HEIGHT="15" SRC="images/save.gif"></button>
                    <% }%>
            </div>
            <br>
            <center>
                <fieldset class="set" style="width:95%;border-color: #006699;" >
                    <legend align="center">
                        <table dir=" <%=dir%>" align="<%=align%>">
                            <tr>
                                <td class="td">
                                    <font color="blue" size="6"><%=title%> 
                                    </font>
                                </td>
                            </tr>
                        </table>
                    </legend>
                    <%
                        if (null != status && status.equalsIgnoreCase("false")) {%>
                    <div align="center" style="color: blue" width="50%">
                        <p dir="<%=dir%>" align="divAlign" style="width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><font size=3 color="red" >Wrong Upload Data</font></b></p>
                    </div>
                    <% }
                        if (null != status && status.equalsIgnoreCase("true")) {%>
                    <div align="center" style="color: blue" width="50%">
                        <p dir="<%=dir%>" align="divAlign" style="width:20%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><font size=3 color="red" >Upload Success</font></b></p>
                    </div>
                    <%
                        }
                    %>
                    <br>
                    <table ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                        <tr>
                            <td class="td" width="50%">
                                <table ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                                    <tr>
                                        <td nowrap STYLE="<%=style%>;font-size: 15px" class="td"><b>Know Us </b></td>
                                        <td style="border: none;text-align: right">
                                            <select style="font-size: 14px;font-weight: bold; width: 300px;" id="season" name="season"
                                                    class="chosen-select-campaign">
                                                <option value="">Select</option>
                                                <sw:WBOOptionList wboList='<%=seasonList%>' displayAttribute="englishName" valueAttribute="id" scrollToValue="<%=campaignID%>"/>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap STYLE="<%=style%>;font-size: 15px" class="td"><b>Camaigne </b></td>
                                        <td style="border: none;text-align: right">
                                            <select style="font-size: 14px;font-weight: bold; width: 300px;" id="campaignID" name="campaignID"
                                                    class="chosen-select-campaign" onchange="JavaScript: getProjects(this);">
                                                <option value="">Select</option>
                                                <sw:WBOOptionList wboList='<%=campaignsList%>' displayAttribute="campaignTitle" valueAttribute="id" scrollToValue="<%=campaignID%>"/>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap STYLE="<%=style%>;font-size: 15px" class="td"><b>Source </b></td>
                                        <td style="border: none;text-align: right">
                                            <select style="font-size: 14px;font-weight: bold; width: 300px;" id="sourceID" name="sourceID"
                                                    class="chosen-select-campaign">
                                                <option value="">Select</option>
                                                <sw:WBOOptionList wboList='<%=sourceList%>' displayAttribute="englishname" valueAttribute="sourceID" scrollToValue="<%=campaignID%>"/>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap STYLE="<%=style%>;font-size: 15px" class="td"><b>Projects</b></td>
                                        <td style="border: none;text-align: right">
                                            <select style="font-size: 14px;font-weight: bold; width: 300px;" id="projectID" name="projectID" >
                                                <option value="">Select</option>
                                                <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap STYLE="<%=style%>;font-size: 15px" class="td"><b><%=attach%></b></td>
                                        <td STYLE="<%=style%>"class='td' COLSPAN="3">
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
                </fieldset>
            </center>
        </form>
        <script>
            var config = {
              '.chosen-select-campaign'           : {no_results_text:'No campaign found with this name!'}
            };
            for (var selector in config) {
              $(selector).chosen(config[selector]);
            }
        </script>
    </body>
</html>