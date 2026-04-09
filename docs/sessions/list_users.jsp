<%@page import="com.silkworm.util.DateAndTimeControl.TimeType"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.maintenance.db_access.IssueDocumentMgr"%>
<%@page import="com.maintenance.db_access.ProjectsByGroupMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.maintenance.db_access.IssueByComplaintAllCaseMgr"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    ArrayList<WebBusinessObject> usersList = (ArrayList<WebBusinessObject>) request.getAttribute("usersList");

    String stat = "Ar";
    String dir = null;
    String title;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Current Users In System";
    } else {
        dir = "RTL";
        title = "مستخدمي النظام";
    }
%>
<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.structure.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.structure.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.theme.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.theme.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery.datetimepicker.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css" />
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery.datetimepicker.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>

        <script LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function () {
                $(document).tooltip({
                    track: true,
                    position: {
                        my: "left top",
                        at: "right+5 top-5"
                    }
                })
            });

            $(document).ready(function () {
                $("#requests").dataTable({
                    "order": [[3, "desc"]],
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true,
                    "columnDefs": [{
                            "targets": 0,
                            "orderable": false
                        }]
                }).fadeIn(2000);
            });
            function terminateSelected() {
                document.COMP_FORM.action = "<%=context%>/SessionsServlet?op=listUsers&terminate=true";
                document.COMP_FORM.submit();
            }
            function selectAll(obj) {
                $("input[name='userID']").prop('checked', $(obj).is(':checked'));
            }
        </script>
        <style type="text/css">
            #row:hover{
                cursor: pointer;
                background-color: #D3E3EB !important;
            }
            .today {
                background-color: #FF5C5C;
            }
        </style>
    </head>
    <body>
        <div name="divGallaryTag"></div>
        <div name="divAttachmentTag"></div>
        <form name="COMP_FORM" method="post">
            <table align="center" width="98%">
                <tr>
                    <td class="td">
                        <fieldset class="set" style="width:98%;border-color: #006699">
                            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <tr>
                                    <td class="titlebar" style="text-align: center">
                                        <img width="40" height="40" src="images/icons/sessions-icon.png" width="40" height="40" style="vertical-align: middle;"/> &nbsp;<font color="#005599" size="4"><%=title%></font>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <div style="width: 97%">
                                <button type="submit" style="float: left; margin-left: 1.5%; margin-bottom: 5px; width: 200px; height: 30px; font-size: 16px;">تحديث&ensp;<img src="images/icons/refresh.png" alt="" height="24" width="24" /></button>
                                <button type="button" style="float: left; margin-left: 1.5%; margin-bottom: 5px; width: 200px; height: 30px; font-size: 16px;" onclick="JavaScript: terminateSelected();">Terminate</button>
                            </div>
                            <% if (usersList != null && !usersList.isEmpty()) {%>
                            <center>
                                <div style="width: 97%">
                                    <table class="display" id="requests" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0">
                                        <thead>
                                            <tr> 
                                                <th><input type="checkbox" onclick="JavaScript: selectAll(this);"/></th>
                                                <th STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold"><b>المستخدم</b></th>
                                                <th STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold"><b>الأدارة</b></th>
                                                <th STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold"><b>تاريخ أخر دخول</b></th>
                                                <th STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold"><b>IP</b></th>
                                            </tr>
                                        </thead> 
                                        <tbody>
                                            <%
                                                Calendar c = Calendar.getInstance();
                                                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                                                String today = sdf.format(c.getTime());
                                                String className = "";
                                                for (WebBusinessObject userWbo : usersList) {
                                                    String loginDate = (String) userWbo.getAttribute("loginDate");
                                                    loginDate = loginDate.substring(0, loginDate.indexOf(" "));
                                                    if (loginDate.equals(today)) {
                                                        className = "today";
                                                    } else {
                                                        className = "";
                                                    }
                                            %>
                                            <tr id="row">
                                                <td style="cursor: hand" class="<%=className%>"><input type="checkbox" name="userID" value="<%=userWbo.getAttribute("userId")%>"/></td>
                                                <td style="cursor: hand" class="<%=className%>"><b><%=userWbo.getAttribute("userName")%></b></td>
                                                <td style="cursor: hand; direction: ltr;" class="<%=className%>"><b><%=userWbo.getAttribute("departmentName") != null ? userWbo.getAttribute("departmentName") : "---"%></b></td>
                                                <td style="cursor: hand" class="<%=className%>"><b><%=userWbo.getAttribute("loginDate")%></b></td>
                                                <td style="cursor: hand" class="<%=className%>"><b><%=userWbo.getAttribute("optionOne")%></b></td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </center>
                            <br/>
                            <br/>
                            <% }%>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>     
