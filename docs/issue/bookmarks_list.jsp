<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] bookmarkAttributes = {"objectType", "issueTitle", "bookmarkText", "CREATION_TIME"};
        String[] bookmarkListTitles = new String[5];

        int s = bookmarkAttributes.length;
        int t = s + 1;

        String attName = null;
        String attValue = null;

        Vector bookmarksList = (Vector) request.getAttribute("data");

        WebBusinessObject wbo = null;
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String lang, langCode, title;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            bookmarkListTitles[0] = "Type";
            bookmarkListTitles[1] = "Title";
            bookmarkListTitles[2] = "Subject";
            bookmarkListTitles[3] = "Creation Date";
            bookmarkListTitles[4] = "Delete";
            title = "Bookmarks List";
        } else {

            align = "center";
            dir = "RTL";
            lang = "English";
            langCode = "En";
            bookmarkListTitles[0] = "النوع";
            bookmarkListTitles[1] = "العنوان";
            bookmarkListTitles[2] = "الموضوع";
            bookmarkListTitles[3] = "تاريخ الأنشاء";
            bookmarkListTitles[4] = "حذف";
            title = "قائمة العلامات";
        }


    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Projects List</TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            $(document).ready(function() {
                oTable = $('#projects').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });
        </script>
        
    </HEAD>
    <body>
        
        <fieldset align=center class="set" style="width: 90%">
            <legend align="center">

                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6"><%=title%> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
            <br>
            <div style="width: 70%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" id="projects" style="width:100%;display: none; ">
                    <thead>
                        <TR>
                            <%
                                for (int i = 0; i < t; i++) {
                            %>                
                            <Th>
                                <B><%=bookmarkListTitles[i]%></B>
                            </Th>
                            <%
                                }
                            %>
                        </TR>
                    </thead>
                    <tbody>
                        <%
                            Enumeration e = bookmarksList.elements();
                            ClientMgr clientmgr = ClientMgr.getInstance();
                            ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            String url;
                            while (e.hasMoreElements()) {
                                wbo = (WebBusinessObject) e.nextElement();
                                url = "#";
                                WebBusinessObject wboClient = new WebBusinessObject();
                                if (((String) wbo.getAttribute("objectType")).equalsIgnoreCase("CLIENT")) {
                                    wboClient = clientmgr.getOnSingleKey((String) wbo.getAttribute("issueId"));
                                    if(wboClient != null){
                                        url = context + "/IssueServlet?op=newComplaint&type=call&clientId=" + wbo.getAttribute("issueId")
                                            + "&clientType=" + wboClient.getAttribute("age");
                                    }
                                } else if (((String) wbo.getAttribute("objectType")).equalsIgnoreCase("CLIENT_COMPLAINT")) {
                                    WebBusinessObject complaintWbo = clientComplaintsMgr.getOnSingleKey((String) wbo.getAttribute("issueId"));
                                    url = context + "/IssueServlet?op=getCompl&issueId=" + complaintWbo.getAttribute("issueId")
                                            + "&compId=" + complaintWbo.getAttribute("id")
                                            + "&senderId=" + complaintWbo.getAttribute("createdBy")
                                            + "&statusCode=" + complaintWbo.getAttribute("currentStatus")
                                            + "&receipId=" + complaintWbo.getAttribute("currentOwnerId")
                                            + "&senderID=" + complaintWbo.getAttribute("createdBy")
                                            + "&clientType=30-40";
                                }
                        %>
                        <TR>
                            <%  for (int i = 0; i < s; i++) {
                                    attName = bookmarkAttributes[i];
                                    attValue = (String) wbo.getAttribute(attName);
                            %>
                            <TD>
                                <DIV>
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
                                </DIV>
                            </TD>
                            <%
                                }
                            %>
                            <TD>
                                <DIV ID="links">
                                    <A HREF="<%=context%>/BookmarkServlet?op=delete&key=<%=wbo.getAttribute("bookmarkId")%>&filterName=BookmarkServlet&filterValue=ViewBookmarks">

                                        <%= bookmarkListTitles[4]%>
                                    </A>
                                </DIV>
                            </TD>
                        </TR>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div> 
        </fieldset>
    </body>
</html>
