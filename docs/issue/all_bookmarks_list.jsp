<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] bookmarkAttributes = {"objectType", "issueTitle", "bookmarkText", "CREATION_TIME", "userName"};
        String[] bookmarkListTitles = new String[5];
        int s = bookmarkAttributes.length;
        int t = s;
        String attName = null;
        String attValue = null;
        ArrayList<WebBusinessObject> bookmarksList = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String lang, langCode, title = "Bookmarks List";
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            bookmarkListTitles[0] = "Type";
            bookmarkListTitles[1] = "Title";
            bookmarkListTitles[2] = "Subject";
            bookmarkListTitles[3] = "Creation Date";
            bookmarkListTitles[4] = "Employee Name";
        } else {
            align = "center";
            dir = "RTL";
            lang = "English";
            langCode = "En";
            bookmarkListTitles[0] = "النوع";
            bookmarkListTitles[1] = "العنوان";
            bookmarkListTitles[2] = "الموضوع";
            bookmarkListTitles[3] = "تاريخ الأنشاء";
            bookmarkListTitles[4] = "اسم الموظف";
        }
    %>
    <head>
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css" />

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            $(document).ready(function () {
                oTable = $('#projects').dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[4, "asc"]],
                    "columnDefs": [
                        {
                            "targets": 4,
                            "visible": false
                        }], "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        var title;
                        api.column(4, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
                                        '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 16px; background-color: lightgray; color: #a41111; text-align: <%=dir%>;" colspan="2"><%=bookmarkListTitles[4]%></td> <td class="" style="font-size: 16px; color: #a41111; text-align: <%=dir%>;" colspan="1"> <b style="color: black;">' + group + ' </b> </td> <td class="" style="font-size: 16px; color: #a41111; text-align: <%=dir%>;" colspan="1" >&nbsp;</td></tr>'
                                        );
                                last = group;
                            }
                        });
                    }
                }).fadeIn(2000);
            });
        </script>
    </head>
    <body>
        <fieldset align=center class="set" style="width: 90%">
            <legend align="center">
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">
                            <%=title%> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
            <br/>
            <div style="width: 70%; margin-left: auto; margin-right: auto; margin-bottom: 7px;">
                <table align="<%=align%>" dir="<%=dir%>" id="projects" style="width: 100%; display: none;">
                    <thead>
                        <tr>
                            <%
                                for (int i = 0; i < t; i++) {
                            %>                
                            <th>
                                <b><%=bookmarkListTitles[i]%></b>
                            </th>
                            <%
                                }
                            %>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            ClientMgr clientmgr = ClientMgr.getInstance();
                            for (WebBusinessObject wbo : bookmarksList) {
                                WebBusinessObject wboClient = new WebBusinessObject();
                                if (((String) wbo.getAttribute("objectType")).equalsIgnoreCase("CLIENT")) {
                                    wboClient = clientmgr.getOnSingleKey((String) wbo.getAttribute("issueId"));
                                }
                        %>
                        <tr>
                            <%  for (int i = 0; i < s; i++) {
                                    attName = bookmarkAttributes[i];
                                    attValue = (String) wbo.getAttribute(attName);
                            %>
                            <td>
                                <div>
                                    <%
                                        if (i == 0) {
                                    %>
                                    <a target="_blank" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wboClient.getAttribute("id")%>">
                                        <img src="images/client_details.jpg" width="30" style="float: left;" title="تفاصيل"
                                             onmouseover="JavaScript: changeCommentCounts('<%=wboClient.getAttribute("id")%>', this);"/>
                                    </a>
                                    <%
                                    } else {
                                    %>
                                    <b><%=attValue%></b>
                                    <%
                                        }
                                    %>
                                </div>
                            </td>
                            <%
                                }
                            %>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div> 
        </fieldset>
    </body>
</html>
