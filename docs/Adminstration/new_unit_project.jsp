<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        String status = (String) request.getAttribute("Status");
        String doubleName = (String) request.getAttribute("name");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir, style, duplicateNameMsg, projectCode, projectName, projectDescription, title, cancel, save;
        String failStatus, successStatus;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            projectCode = "Project Code";
            projectName = "Project Name";
            projectDescription = "Description";
            title = "Add New Project";
            cancel = "Cancel ";
            save = "Save ";
            duplicateNameMsg = "Name or code is duplicated change it";
            failStatus = "Fail to Save";
            successStatus = "Saved Successfully";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            projectCode = "كود المشروع ";
            projectName = "اسم المشروع";
            projectDescription = "الوصف ";
            title = "إضافة مشروع جديد";
            cancel = "أنهاء";
            save = "حفظ";
            duplicateNameMsg = "الإسم أو الكود مكرر الرجاء تغييره";
            failStatus = "تم الحفظ بنجاح";
            successStatus = "لم يتم الحفظ";
        }
    %>
    <head>
        <script src='silkworm_validate.js' type='text/javascript'></script>
        <script language="JavaScript" type="text/javascript">
            function submitForm() {
                if (!validateData("req", this.PROJECT_FORM.eqNO, "Project Code is required.") || !validateData("alphanumeric", this.PROJECT_FORM.eqNO, "Enter a valid Code.")) {
                    this.PROJECT_FORM.eqNO.focus();
                } else if (!validateData("req", this.PROJECT_FORM.project_name, "Project Name is required.") || !validateData("minlength=3", this.PROJECT_FORM.project_name, "Enter a valid Name.")) {
                    this.PROJECT_FORM.project_name.focus();
                } else if (!validateData("req", this.PROJECT_FORM.project_desc, "Description is required.")) {
                    this.PROJECT_FORM.project_desc.focus();
                } else {
                    document.PROJECT_FORM.action = "<%=context%>/ProjectServlet?op=newUnitProject";
                    document.PROJECT_FORM.submit();
                }
            }
            function cancelForm() {
                document.PROJECT_FORM.action = "main.jsp";
                document.PROJECT_FORM.submit();
            }
        </script>
    </head>
    <body>
        <form name="PROJECT_FORM" method="post" action="">
            <div align="left" style="color:blue;">
                <button type="button" onclick="JavaScript: cancelForm();" class="button"><%=cancel%><img valign="bottom" src="images/cancel.gif"/> </button>
                <button type="button" onclick="JavaScript: submitForm();" class="button"><%=save%><img height="15" src="images/save.gif"/></button>
            </div>
            <br />
            <center>
                <fieldset class="set" style="border-color: #006699; width: 90%">
                    <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color='white' size="+1"> <%=title%></font><br /></td>
                        </tr>
                    </table> 
                    <br />
                    <%if (null != doubleName) {%>

                    <table dir="<%=dir%>" align="<%=align%>">
                        <tr>
                            <td class="td">
                                <font size=4 > <%=duplicateNameMsg%> </font>
                            </td>
                        </tr>
                    </table>
                    <%}%>

                    <table align="<%=align%>" dir="<%=dir%>">
                        <%
                            if (null != status) {
                                if (status.equalsIgnoreCase("ok")) {
                        %>
                        <tr>
                            <td>
                                <table align="<%=align%>" dir=<%=dir%>>
                                    <tr>
                                        <td class="td">
                                            <font size=4 color="black"><%=successStatus%></font>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%} else {%>
                        <tr>
                            <td>
                                <table align="<%=align%>" dir=<%=dir%>>
                                    <tr>
                                        <td class="td">
                                            <font size=4 color="red" ><%=failStatus%></font>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <%}
                            }%>
                    </table>
                    <br />
                    <table align="<%=align%>" dir="<%=dir%>">
                        <tr>
                            <td style="<%=style%>; width: 120px;" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <p><b><%=projectCode%></b></p>
                            </td>
                            <td colspan="3" class="blueBorder backgroundTable" >
                                <input type="text" name="eqNO" dir="<%=dir%>" id="eqNO" size="32" value="" maxlength="255">
                                <input type="hidden" name="mainProjectId" id="mainProjectId" value="<%=CRMConstants.PROJECTS_ID%>"/>
                                <input type="hidden" name="futile" id="futile" value="1" />
                                <input type="hidden" name="location_type" id="location_type" value="44" />
                            </td>
                        </tr>
                        <tr>
                            <td style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <p><b> <%=projectName%></b></p>
                            </td>
                            <td colspan="3" class="blueBorder backgroundTable">
                                <input type="text" dir="<%=dir%>" name="project_name" id="project_name" size="32" value="" maxlength="255">
                            </td>
                        </tr>
                        <tr>
                            <td style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                                <p><b><%=projectDescription%></b></p>
                            </td>
                            <td colspan="3" class="blueBorder backgroundTable" >
                                <textarea rows="5" name="project_desc" dir="<%=dir%>" id="project_desc" cols="26"></textarea>
                            </td>
                        </tr>
                    </table>
                    <br /><br /><br />
                </fieldset>
            </center>
        </form>
    </body>
</html>
