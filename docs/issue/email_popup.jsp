<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String titleStr = (String) request.getAttribute("titleStr");
    String bodyStr = (String) request.getAttribute("bodyStr");
    ArrayList<WebBusinessObject> managersList = (ArrayList<WebBusinessObject>) request.getAttribute("managersList");
    String stat = (String) request.getSession().getAttribute("currentMode");
    String dir, align, to, title, attachFile, body;
    if (stat.equals("En")) {
        dir = "ltr";
        align = "left";
        to = "To";
        title = "Title";
        attachFile = "Attach File";
        body = "Body";
    } else {
        dir = "rtl";
        align = "right";
        to = "إلي";
        title = "موضوع الرسالة";
        attachFile = "إرفاق ملف";
        body = "نص الرسالة";
    }
%>

<html>
    <head>
        <script type="text/javascript" src="js/multiple-select/multiple-select.js"/>
        <script type="text/javascript" src="js/jquery-te/jquery-te-1.4.0.min.js"/>
        <link href="js/multiple-select/multiple-select.css" rel="stylesheet"/>
        <link href="js/jquery-te/jquery-te-1.4.0.css" rel="stylesheet"/>
        <script type="text/javascript">
        </script>
        <style>
            .table td {
                border: 0px;
            }
            .jqte_editor{height:150px;max-height:150px;}
        </style>
    </head>
    <body>
        <form id="emailForm" action="<%=context%>/EmailServlet?op=sendByAjax" method="post" enctype="multipart/form-data">
            <table class="table" style="width:580px; direction: <%=dir%>">
                <tr>
                    <td style="font-size: 16px;font-weight: bold;"><%=to%></td>
                    <td style="width: 80%; text-align: <%=align%>;">
                        <select id="to" value=""name="to" style="width: 470px;" multiple="multiple" class="selectMulti">
                            <%
                                for (WebBusinessObject managerWbo : managersList) {
                            %>
                            <option value="<%=managerWbo.getAttribute("email")%>">&nbsp;<%=managerWbo.getAttribute("fullName")%></option>
                            <%
                                }
                            %>
                        </select>
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 16px; font-weight: bold;" nowrap><%=title%></td>
                    <td style=" text-align: <%=align%>;">
                        <input type="text" size="60" maxlength="60" id="subject" name="subject" style="width: 100%;" value="<%=titleStr%>"/>
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 16px; font-weight: bold;" nowrap><%=body%>
                        <input id="emailCounter" value="0" type="hidden" name="counter"/></td>
                    <td style="width: 60%; text-align: <%=align%>;">
                        <textarea placeholder="<%=body%>" name="message" id="message" style="height: 150px; width: 100%;" class="editor"><%=bodyStr%></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 16px; font-weight: bold;" nowrap>
                        <%=attachFile%>
                    </td>
                    <td style="text-align: <%=align%>;">
                        <input type="button" id="addEmailFile" onclick="addEmailFiles(this)" value="+" />
                        <div id="listFile">

                        </div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div style="width: 30%;text-align: center;margin-left: auto;margin-right: auto;" id="emailStatus"></div>
                    </td>
                </tr>
            </table>
        </form>
        <script>
            $(".selectMulti").multipleSelect({
                isOpen: false,
                keepOpen: false,
                selectAll: false
            });
            $(".editor").jqte();
        </script>
    </body>
</html>
