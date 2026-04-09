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
    List<ApplicationSessionRegistery.SessionRegistery> sessions = (List<ApplicationSessionRegistery.SessionRegistery>) request.getAttribute("sessions");

    String stat = "Ar";
    String dir = null;
    String title;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Current Users In System";
    } else {
        dir = "RTL";
        title = "المستخدمين الحاليين";
    }
%>
<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   
        >   

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

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function() {
                $(document).tooltip({
                    track: true,
                    position: {
                        my: "left top",
                        at: "right+5 top-5"
                    }
                })
            });

            $(document).ready(function() {
                $("#requests").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                }).fadeIn(2000);
            });

            function closeSession(sessionId) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/SessionsServlet?op=closeSession",
                    data: {
                        sessionId: sessionId
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            alert("Close Session: " + sessionId + " Successful");
                            $("tr[name=" + sessionId + "]").fadeOut(1000, function() {
                                this.remove();
                            });
                        } else {
                            alert("Close Session: " + sessionId + " Faild");
                        }

                    }
                });
            }
        </script>

        <style type="text/css">
            .canceled {
                background-color: rgba(255, 0, 0, 0.5);
                color: #004276;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .confirmed {
                background-color: #459E00;
                color: black;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
            .titlebar {
                height: 30px;
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
            #row:hover{
                cursor: pointer;
                background-color: #D3E3EB !important;
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
                        <FIELDSET class="set" style="width:98%;border-color: #006699">
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
                            </div>
                            <% if (sessions != null && !sessions.isEmpty()) {%>
                            <center>
                                <div style="width: 97%">
                                    <table class="display" id="requests" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                                        <thead>
                                            <tr> 
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="20%"><b>المستخدم</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="15%"><b>رقم الجهاز</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="30%"><b>عنوان اخر زيارة</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="15%"><b>تاريخ أخر دخول</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="15%"><b>تاريخ اخر تفاعل</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="5%"><b></b></TH>
                                            </tr>
                                        </thead> 
                                        <tbody>
                                            <%
                                                String lastVisitedUrl;
                                                for (ApplicationSessionRegistery.SessionRegistery registery : sessions) {
                                                    lastVisitedUrl = registery.getLastVisitedUrl();
                                                    if (lastVisitedUrl == null) {
                                                        lastVisitedUrl = "";
                                                    } else if (lastVisitedUrl.length() > 60) {
                                                        lastVisitedUrl = lastVisitedUrl.substring(0, 60) + "...";
                                                    }
                                            %>
                                            <tr id="row" name="<%=registery.getId()%>">
                                                <td title="Session No: <%=registery.getId()%>" style="cursor: hand"><b><%=registery.getLoggedInUser().getFullName()%></b></td>
                                                <td><b><%=registery.getLoggedInMachine()%></b></td>
                                                <td title="<%=registery.getLastVisitedUrl()%>" style="cursor: hand"><font color="blue"><b><font color="blue"><%=lastVisitedUrl%></b></font></td>
                                                <td><b><%=DateAndTimeControl.getStanderdFormat(registery.getLoggedInDate(), stat)%></b></td>
                                                <td><b><%=DateAndTimeControl.getStanderdFormat(registery.getLastActionDate(), stat)%></b></td>
                                                <td>
                                                    <%if (!registery.getId().equalsIgnoreCase(session.getId())) {%>
                                                    <b><a href="JavaScript: closeSession('<%=registery.getId()%>');"><img src="images/icons/logout.png" width="24" height="24"/></a></b>
                                                            <%}%>
                                                </td>
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
