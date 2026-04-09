<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@page pageEncoding="UTF-8" %>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    WebBusinessObject unitTypeWbo = (WebBusinessObject) request.getAttribute("unitTypeWbo");
    String stat = (String) request.getSession().getAttribute("currentMode");
    String align = null;
    String dir = null;
    String style = null;
    String title, cancel, typeName;
    String name = null;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        title = "View Unit Type ";
        cancel = "Back To List";
        typeName = "Type";
        name = "Name";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        title = "مشاهدة نوع وحدة";
        cancel = " العودة إلي القائمة ";
        typeName = "النوع";
        name = "الاسم";
    }
%>
<html>
    <head>
        <script language="javascript" type="text/javascript" >
            function cancelForm() {
                document.UNIT_TYPE_VIEW_FORM.action = "<%=context%>/ProjectServlet?op=listUnitTypes";
                document.UNIT_TYPE_VIEW_FORM.submit();
            }
        </script>
    </head>
    <body>
        <div align="left" style="color:blue;">
            <button onclick="cancelForm()" class="button"><%=cancel%> <img valign="bottom" height="15" src="images/leftarrow.gif"/></button>
        </div> 
        <br />
        <fieldset class="set" style="border-color: #006699; width: 50%">
            <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color='white' size="+1"><%=title%></font><br /></td>
                </tr>
            </table>
            <form name="UNIT_TYPE_VIEW_FORM" method="POST">
                <table align="<%=align%>" dir="<%=dir%>">
                    <tr>
                        <td style="<%=style%>; width: 200px;" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <b><%=typeName%></b>&nbsp;
                        </td>
                        <td style="width: 207px;" class="blueBorder backgroundTable">
                            <b><%=unitTypeWbo.getAttribute("locationTypeName")%></b>
                        </td>
                    </tr>
                    <tr>
                        <td style="<%=style%>" class="td2 formInputTag boldFont boldFont backgroundHeader" id="CellData">
                            <b> <%=name%> </b>&nbsp;
                        </td>
                        <td colspan="3" class="blueBorder backgroundTable">
                            <b><%=unitTypeWbo.getAttribute("typeName")%></b>
                        </td>
                    </tr>
                </table>
                <br />
                <br />
            </form>
        </fieldset>
    </body>
</html>