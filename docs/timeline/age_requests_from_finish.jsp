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
    List<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");

    String stat = "Ar";
    String dir = null;
    String title;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Complaints Reprot";
    } else {
        dir = "RTL";
        title = "عمر الطلبات من الأنتهاء";
    }
%>
<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   

        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

            $(document).ready(function() {
                $("#requests").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                }).fadeIn(2000);
            });
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
                                        <img width="40" height="40" src="images/icons/timeline.png" width="30" height="30" style="vertical-align: middle;"/> &nbsp;<font color="#005599" size="4"><%=title%></font>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <% if (data != null && !data.isEmpty()) {%>
                            <center>
                                <div style="width: 97%">
                                    <table class="display" id="requests" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                                        <thead>
                                            <tr> 
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="10%"><b>رقم المتابعة</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="9%"><b>نوع الطلب</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="10%"><b>رقم الطلب</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="15%"><b>تاريخ الطلب</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="18%"><b>العمر</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="20%"><b>المصدر</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="18%"><b>العمر من الانتهاء</b></TH>
                                            </tr>
                                        </thead> 
                                        <tbody>
                                            <%
                                                WebBusinessObject formatted;
                                                String className = "";
                                                String businessId;
                                                String businessIdByDate;
                                                String sourceName;
                                                String businessComplaintId;
                                                String creationTime;
                                                String ticketTypeName;
                                                String totalTimeSeconds;
                                                String lastTimeUpdatedSeconds;
                                                for (WebBusinessObject wbo : data) {
                                                    businessId = (String) wbo.getAttribute("businessId");
                                                    businessIdByDate = (String) wbo.getAttribute("businessIdByDate");
                                                    sourceName = (String) wbo.getAttribute("sourceName");
                                                    businessComplaintId = (String) wbo.getAttribute("businessComplaintId");
                                                    creationTime = (String) wbo.getAttribute("creationTime");
                                                    ticketTypeName = (String) wbo.getAttribute("ticketTypeName");
                                                    totalTimeSeconds = (String) wbo.getAttribute("totalTimeSeconds");
                                                    lastTimeUpdatedSeconds = (String) wbo.getAttribute("lastTimeUpdatedSeconds");
                                                    formatted = DateAndTimeControl.getFormattedDateTime(creationTime, stat);
                                                    className = "confirmed";
                                                    
                                                    totalTimeSeconds = DateAndTimeControl.getTimeRemainingFormatted(totalTimeSeconds, TimeType.SECONDS, stat);
                                                    lastTimeUpdatedSeconds = DateAndTimeControl.getTimeRemainingFormatted(lastTimeUpdatedSeconds, TimeType.SECONDS, stat);
                                            %>
                                            <tr id="row">
                                                <td  style="cursor: pointer" onmouseover="this.className = '<%=className%>'" onmouseout="this.className = ''">
                                                    <font color="red"><%=businessId%></font><font color="blue">/<%=businessIdByDate%></font>
                                                </td>
                                                <td><b><%=ticketTypeName%></b></td>
                                                <td><b><%=businessComplaintId%></b></td>                                     
                                                <td nowrap><font color="red"><%=formatted.getAttribute("day")%> - </font><b><%=formatted.getAttribute("time")%></b></td>
                                                <td><b><%=totalTimeSeconds%></b></td>
                                                <td><b><%=sourceName%></b></td>
                                                <td><b><%=lastTimeUpdatedSeconds%></b></td>
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
