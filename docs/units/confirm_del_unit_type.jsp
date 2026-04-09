<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        WebBusinessObject unitTypeWbo = (WebBusinessObject) request.getAttribute("unitTypeWbo");
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style, title, delete, cancel, name;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            style = "text-align:left";
            title = "Delete Unit Type - Are you Sure ?";
            delete = "Delete";
            cancel = "Back To List";
            name = "Name";
        } else {
            align = "right";
            dir = "RTL";
            style = "text-align:Right";
            title = "حذف نوع الوحدة - متأكد؟";
            delete = "حذف";
            cancel = "العودة إلي القائمة";
            name = "الاسم";
        }
    %>
    <head>
        <script language="JavaScript" type="text/javascript">
            function submitForm() {
                document.UNIT_TYPE_DELETE_FORM.action = "<%=context%>/ProjectServlet?op=confirmDeleteUnitType&delete=true";
                document.UNIT_TYPE_DELETE_FORM.submit();
            }
            function cancelForm() {
                document.UNIT_TYPE_DELETE_FORM.action = "<%=context%>/ProjectServlet?op=listUnitTypes";
                document.UNIT_TYPE_DELETE_FORM.submit();
            }
        </script>
    </head>
    <body>
        <form name="UNIT_TYPE_DELETE_FORM" id="UNIT_TYPE_DELETE_FORM" method="POST">
            <div align="left" style="color:blue;">
                <button type="button" onclick="cancelForm()" class="button"><%=cancel%> <img valign="bottom" height="15" src="images/leftarrow.gif"></button>
                <button type="button" onclick="submitForm()" class="button"><%=delete%></button>
            </div> 
            <br />
            <fieldset class="set" style="border-color: #006699; width: 50%">
                <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color='white' size="+1"> <%=title%> </font><br/></td>
                    </tr>
                </table>
                <br />
                <table align="center" dir="<%=dir%>" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td class='td'>
                            <b><%=name%></b>
                        </td>
                        <td class='td'>
                            <input disabled type="text" name="name" value="<%=unitTypeWbo.getAttribute("typeName")%>" id="name" size="33" maxlength="50"/>
                        </td>
                    </tr>
                    <input type="hidden" name="id" value="<%=unitTypeWbo.getAttribute("id")%>">
                </table>
                <br/><br/>
            </fieldset>
        </form>
    </body>
</html>
