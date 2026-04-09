
<%@page import="com.docviewer.business_objects.Document"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<html>
    <head>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            String[] docAttributes = {"documentTitle", "docDate", "typeName"};
            String[] docTitles = new String[5];
            int s = docAttributes.length;
            int t = s + 2;
            String attName = null;
            String attValue = null;
            ArrayList<WebBusinessObject> docList = (ArrayList<WebBusinessObject>) request.getAttribute("data");
            String stat = (String) request.getSession().getAttribute("currentMode");
            String align = null;
            String dir = null;
            String style = null;
            if (stat.equals("En")) {
                align = "center";
                dir = "LTR";
                style = "text-align:left";
                docTitles[0] = "Name";
                docTitles[1] = "Date";
                docTitles[2] = "Type";
                docTitles[3] = "View";
                docTitles[4] = "Delete";
            } else {
                align = "center";
                dir = "RTL";
                style = "text-align:Right";
                docTitles[0] = "الاسم";
                docTitles[1] = "التاريخ";
                docTitles[2] = "النوع";
                docTitles[3] = "مشاهدة";
                docTitles[4] = "مسح";
            }
        %>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>  
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript">
            $(document).ready(function () {
                $('#documents').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                });
            });
            function openWindow(url) {
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=700, height=600");
            }
        </script>
    </head>
    <body>
        <div style="width: 100%;">
            <table id="documents" align="center" dir="<%=dir%>" cellpadding="0" cellspacing="0" style="width: 100%; text-align: center;">
                <thead>
                    <tr>
                        <%
                            for (int i = 0; i < t; i++) {
                        %>     
                        <% if (i != 6) {%>
                        <td>
                            <b><%=docTitles[i]%></b>
                        </td>
                        <%}%>
                        <%
                            }
                        %>
                    </tr>  
                </thead>
                <tbody >
                    <%
                        if (null != docList) {;
                            for (WebBusinessObject doc : docList) {
                    %>
                    <tr>
                        <%
                            for (int i = 0; i < s; i++) {
                                attName = docAttributes[i];
                                attValue = (String) doc.getAttribute(attName);
                        %>
                        <td>
                            <b><%=attValue%></b>
                        </td>
                        <%
                            }
                        %>
                        <td>
                            <a href="<%=context%>/UnitDocReaderServlet?op=viewIssueDocFile&docType=<%=doc.getAttribute("documentType")%>&docID=<%=doc.getAttribute("documentID")%>&metaType=<%=doc.getAttribute("metaType")%>" target="_blank">
                                <%=docTitles[3]%>
                                <img src="images/download.ico" style="height: 20px;"/>
                            </a>
                        </td>
                        <td>
                            <a href="#" onclick="deleteDocument('<%=doc.getAttribute("documentID")%>');
                                    return false;">
                                <%=docTitles[4]%>
                                <img src="images/delete.png" style="height: 20px;" />
                            </a>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
        <script>
            function deleteDocument(documentID) {
                var xhr = new XMLHttpRequest();
                xhr.open("GET", "<%=context%>/SalesMarketingServlet?op=removeUploadedFile&documentID=" + documentID, true);
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        var response = JSON.parse(xhr.responseText);
                        if (response.status === "ok") {
                            // Refresh the page on successful deletion
                            location.reload();
                        } else {
                            alert("Failed to delete the document.");
                        }
                    }
                };
                xhr.send();
            }
        </script>
    </body>
</html>
