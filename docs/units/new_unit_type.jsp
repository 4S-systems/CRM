<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<html>
    <%
        ArrayList<WebBusinessObject> locationTypesList = (ArrayList<WebBusinessObject>) request.getAttribute("locationTypesList");
        String status = (String) request.getAttribute("status");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir, style, itemType, unitTypeName, title, cancel, save, fStatus, sStatus;

        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            style = "text-align:left";
            itemType = "Type";
            unitTypeName = "Name";
            title = "New Unit Type";
            cancel = "Cancel ";
            save = "Save ";
            sStatus = "Saved Successfully";
            fStatus = "Fail To Save";
        } else {
            align = "right";
            dir = "RTL";
            style = "text-align:Right";
            itemType = "النوع";
            unitTypeName = "الاسم";
            title = "نوع وحدة جديد";
            cancel = "إلغاء";
            save = "حفظ";
            fStatus = "لم يتم الحفظ";
            sStatus = "تم الحفظ بنجاح ";
        }
    %>
    <head>
        <script language="JavaScript" type="text/javascript">
            function submitForm() {
                if (!validateData("req", this.UNIT_TYPE_FORM.type, "Please, select type.")) {
                    this.UNIT_TYPE_FORM.type.focus();
                } else if (!validateData("req", this.UNIT_TYPE_FORM.name, "Please, enter name.") || !validateData("minlength=3", this.UNIT_TYPE_FORM.name, "Location Type Arabic Description Must be greater than 3 letters.")) {
                    this.UNIT_TYPE_FORM.name.focus();
                } else {
                    document.UNIT_TYPE_FORM.action = "<%=context%>/ProjectServlet?op=getUnitTypeForm&save=true";
                    document.UNIT_TYPE_FORM.submit();
                }
            }
            function cancelForm() {
                document.UNIT_TYPE_FORM.action = "<%=context%>/main.jsp"
                document.UNIT_TYPE_FORM.submit();
            }
        </script>
    </head>
    <body>
        <form name="UNIT_TYPE_FORM" id="UNIT_TYPE_FORM" method="POST">
            <div align="left" STYLE="color:blue;">
                <button type="button" onclick="JavaScript: cancelForm();" class="button"><%=cancel%><img valign="bottom" src="images/cancel.gif"/> </button>
                <button type="button" onclick="JavaScript: submitForm();" class="button"><%=save%><img height="15" src="images/save.gif"/></button>
            </div>
            <br />
            <br />
            <fieldset class="set" style="border-color: #006699; width: 50%; margin-left: auto; margin-right: auto;">
                <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color='white' SIZE="+1"> <%=title%> </font><BR></td>
                    </tr>
                </table> 
                <br />
                <table align="center" dir="<%=dir%>" style="margin-left: auto; margin-right: auto;">
                    <%
                        if (null != status) {
                            if (status.equalsIgnoreCase("ok")) {
                    %>
                    <tr>
                        <td class="td">
                            <table align="<%=align%>" dir=<%=dir%>>
                                <tr>
                                    <td class="td">
                                        <font size=4 color="green"><%=sStatus%></font>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%
                    } else {
                    %>
                    <tr>
                        <td class="td">
                            <table align="<%=align%>" dir=<%=dir%>>
                                <tr>
                                    <td class="td">
                                        <font size=4 color="red" ><%=fStatus%></font>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </table>
                <br />
                <table align="center" dir="<%=dir%>" style="margin-left: auto; margin-right: auto;">
                    <tr>
                        <td style="<%=style%>; width: 200px;" class="td2 formInputTag boldFont boldFont backgroundHeader">
                            <p><b><%=itemType%></b>
                        </td>
                        <td colspan="3" class="blueBorder backgroundTable" >
                            <select name="type" ID="type" style="width: 270px; font-size: 16px;">
                                <sw:WBOOptionList wboList="<%=locationTypesList%>" displayAttribute="arDesc" valueAttribute="id" />
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader">
                            <p><b> <%=unitTypeName%></b>
                        </td>
                        <td colspan="3" class="blueBorder backgroundTable">
                            <input type="text" dir="<%=dir%>" name="name" ID="name" size="32" value="" maxlength="255" style="width: 270px;"/>
                        </td>
                    </tr>
                </table>
                <br /><br />
            </fieldset>
        </form>
    </body>
</html>