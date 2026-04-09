<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.HashMap"%>
<%@page import="javax.sound.sampled.Line"%>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        Vector<WebBusinessObject> summary = (Vector<WebBusinessObject>) request.getAttribute("summary");
        boolean noErrors = ((Boolean) request.getAttribute("noErrors")).booleanValue();
    %>

    <HEAD>
        <TITLE>Update Database</TITLE>
    </HEAD>
    <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
        function updateDatabase() {
            document.UPDATE_DATABASE_FORM.action = "<%=context%>/DatabaseControllerServlet?op=updateDatabase";
            document.UPDATE_DATABASE_FORM.submit();
        }

        function ignoreError() {
            var url = "<%=context%>/ajaxServlet?op=IgnoreDBError";

            if (window.XMLHttpRequest) {
                req = new XMLHttpRequest();
            } else if (window.ActiveXObject) {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            }

            req.open("POST", url, true);
            req.onreadystatechange =  callbackFillItemForm;
            req.send(null);
        }

        function callbackFillItemForm() {
            var span = document.getElementById("update");
            if(req.readyState == 4) {
                if (req.status == 200) {
                    span.innerHTML = "";
                }
            } else {
                span.innerHTML = "<img src='images/Loading2.gif' />";
            }
        }
    </SCRIPT>
    <BODY>
        <FORM name="UPDATE_DATABASE_FORM" method="POST" action="">
            <center>
                <fieldset class="set" style="">
                    <table class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1">Update DataBase</FONT></td>
                        </tr>
                    </table>
                    <br>
                    <table width="95%" cellpadding="0" cellspacing="0" align="center">
                        <tr>
                            <td class="excelentCell" style="text-align: center">
                                <% if (noErrors && summary.size() > 0) {%>
                                <font color="blue" size="4">Update Database Success ...</font>
                                <% } else if (summary.size() == 0) {%>
                                <font color="blue" size="4">Not Found Script To Update</font>
                                <% } else {%>
                                <font color="red" size="4">Update Database No Complete yet for Following Reasons Errors ..</font>
                                <% }%>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <% if (summary.size() > 0) {%>
                    <table class="blueBorder" width="95%" cellpadding="0" cellspacing="0" align="center">
                        <tr>
                            <td class="blueHeaderTD blueBorder" width="8%">
                                Index
                            </td>
                            <td class="blueHeaderTD blueBorder" width="62%">
                                Script
                            </td>
                            <td class="blueHeaderTD blueBorder" width="30%">
                                Message
                            </td>
                        </tr>
                        <%
                            String font, query;
                            String prefix = " ...";
                            for (WebBusinessObject wbo : summary) {
                                query = (String) wbo.getAttribute("query");

                                if (query != null && query.length() > 80) {
                                    query = query.substring(0, 79) + prefix;
                                }

                                font = "black";
                                if (wbo.getAttribute("status").equals("no")) {
                                    font = "red";
                                }
                        %>
                        <tr>
                            <td class="blueBorder blueBodyTD">
                                <font color="<%=font%>"><%=wbo.getAttribute("index")%></font>
                            </td>
                            <td class="blueBorder blueBodyTD" style="text-align: left; padding-left: 20px">
                                <font color="<%=font%>"><%=query%></font>
                            </td>
                            <td class="blueBorder blueBodyTD">
                                <font color="<%=font%>"><%=wbo.getAttribute("message")%></font>
                            </td>
                        </tr>
                        <% }%>
                    </table>
                    <br>
                    <% if (!noErrors) {%>
                    <table border="0" width="90%" align="center">
                        <tr>
                            <td style="border-width: 0px;width: 100%">
                                <input type="button" style="padding-left: 1px" onclick="JavaScript:updateDatabase();" value="Re-Update" />
                                <span id="update">
                                    <input type="button" style="padding-left: 1px" onclick="JavaScript:ignoreError();"  value="Ignore Error" />
                                </span>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <% }%>
                    <% }%>
                </fieldset>
            </center>
        </FORM>
    </BODY>
</HTML>


