<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE html>
<html>
    <head>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            ArrayList<WebBusinessObject> unitsList = (ArrayList<WebBusinessObject>) request.getAttribute("unitsList");
            ArrayList<WebBusinessObject> projectsList = (ArrayList<WebBusinessObject>) request.getAttribute("projectsList");
            String projectID = request.getAttribute("projectID") != null ? (String) request.getAttribute("projectID") : "";
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css" />
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/custom_popup/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript">
            $(document).ready(function () {
                $("table[name='units']").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                });
            });
            function submitForm() {
                if (!validateData("req", document.STAGES_FORM.projectID, " اختار المشروع...")) {
                    $("#projectID").focus();
                } else {
                    document.STAGES_FORM.submit();
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
        <fieldset class="set" style="width: 95%; border-color: #006699">
            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td class="titlebar" style="text-align: center">
                        <font color="#005599" size="4">مراحل المشاريع</font>
                    </td>
                </tr>
            </table>
            <br/>
            <form name="STAGES_FORM" id="STAGES_FORM" style="width: 70%;">
                <table cellspacing="0" width="30%" dir="rtl">
                    <tr>
                        <td style="text-align: center; padding-right: 5px; border: none;" class="titlebar">
                            <font color="#005599" size="3">المشروع </font>
                        </td>
                    </tr>
                    <tr>
                        <td style="border: none; text-align: center;">
                            <select style="font-size: 14px;font-weight: bold; width: 180px;" id="projectID" name="projectID" 
                                    onchange="JavaScript: submitForm();">
                                <option value=""></option>
                                <sw:WBOOptionList wboList='<%=projectsList%>' displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=projectID%>"/>
                            </select>
                            <input type="hidden" name="op" value="getProjectsStages" />
                        </td>
                    </tr>
                </table>
                <br/>
                <table name="units" class="display" cellspacing="0" width="100%" dir="rtl">
                    <thead>
                        <tr>
                            <th>الاسم</th>
                            <th>تاريخ الأنتهاء المتوقع</th>
                            <th>التكلفة المتوقعة</th>
                            <th>&nbsp;</th>
                            <th>&nbsp;</th>
                            <th>&nbsp;</th>
                            <th>&nbsp;</th>
                            <th>&nbsp;</th>
                        </tr>
                    </thead> 
                    <tbody>
                        <%
                            for (WebBusinessObject unit : unitsList) {
                        %>
                        <tr style="cursor: pointer" onmouseover="this.className = ''" onmouseout="this.className = ''">
                            <td><%=unit.getAttribute("projectName")%></td>
                            <td><%=unit.getAttribute("estimatedFinishDate") != null ?  ((String) unit.getAttribute("estimatedFinishDate")).substring(0, 10) : ""%></td>
                            <td><%=unit.getAttribute("estimatedCost") != null ? unit.getAttribute("estimatedCost") : ""%></td>
                            <td>
                                <a href="<%=context%>/StageServlet?op=getStageWorkItems&stageID=<%=unit.getAttribute("projectID")%>&projectID=<%=projectID%>">
                                    بنود الأعمال
                                </a>
                            </td>
                            <td>
                                <a href="<%=context%>/StageServlet?op=getEditStageForm&stageID=<%=unit.getAttribute("projectID")%>&projectID=<%=projectID%>">
                                    تعديل
                                </a>
                            </td>
                            <td>
                                <a href="JavaScript: alert('تفعيل النظام');">
                                    طلبات التسليم
                                </a>
                            </td>
                            <td>
                                <a href="JavaScript: alert('تفعيل النظام');">
                                    المستخلصات
                                </a>
                            </td>
                            <td>
                                <a href="JavaScript: alert('تفعيل النظام');">
                                    التكلفة
                                </a>
                            </td>
                        </tr>
                        <%}%>
                    </tbody>
                </table>
            </form>
        </fieldset>
    </body>
</html>