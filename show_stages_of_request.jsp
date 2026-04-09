<%@page import="java.sql.Timestamp"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<html>
    <%
        Vector<WebBusinessObject> statuses = (Vector) request.getAttribute("status");
        WebBusinessObject clientComplaint = (WebBusinessObject) request.getAttribute("clientComplaint");
        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String context = metaDataMgr.getContext();
        //Privileges
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        ArrayList<WebBusinessObject> prvType = new ArrayList();
        prvType = securityUser.getComplaintMenuBtn();
        ArrayList<String> privilegesList = new ArrayList<>();
        for (WebBusinessObject wboTemp : prvType) {
            if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                privilegesList.add((String) wboTemp.getAttribute("prevCode"));
            }
        }
        boolean deleteStatus = false;
        if (privilegesList.contains("DELETE_STATUS")) {
            deleteStatus = true;
        }
    %>
    <head>
        <title></title>
        <script type="text/javascript">
            function deleteStatusConfirm(statusID) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=deleteComplaintStatusAjax",
                    data: {
                        statusID: statusID
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'Ok') {
                            alert("Status deleted successfully.");
                            $("#row" + statusID).hide(1000, function () {
                                $("#row" + statusID).remove();
                            });
                        } else {
                            alert("Could not delete status.");
                        }
                    }
                });
            }
        </script>
    </head>
    <body>
        <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup(this)"/>
        </div>
        <div class="login" style="width: 90%;margin-bottom: 10px;margin-left: auto;margin-right: auto;overflow: auto;height: auto;">
            <table style="width:100%;text-align: right;border: none;margin-bottom: 20px;" class="table" dir="rtl">
                <thead>
                    <tr>
                        <td rowspan="2">مراحل الطلب</td>
                        <td rowspan="2">تاريخ البداء</td>
                        <td rowspan="2">تاريخ الانتهاء</td>
                        <td colspan="3">المدة المنصرمة</td>
                        <td rowspan="2">ملاحظات</td>
                        <td rowspan="2">بواسطة</td>
                        <%
                        if(deleteStatus){
                        %>
                        <td style="display: none;" rowspan="2">&nbsp;</td>
                        <%
                        }
                        %>
                    </tr>
                    <tr>
                        <td style="width: 5%;">يوم</td>
                        <td style="width: 5%;">ساعة</td>
                        <td style="width: 5%;">دقيقة</td>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="10">
                            <hr style="width: 100%;">
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 17%;"> <label style="width: 100px;">التسليم</label></td>
                        <td style="width: 17%;"><label id="requestDate"><%=DateAndTimeControl.getDateAfterSubString(clientComplaint.getAttribute("creationTime").toString().substring(0, clientComplaint.getAttribute("creationTime").toString().length() - 5))%></label></td>
                        <td style="width: 17%;"><label id="">----</label></td>
                        <td colspan="3" style="width: 15%;"><label id="">----</label></td>
                        <td  style="width: 17%;"><label id="">----</label></td>
                        <td  style="width: 17%;"><label id="">----</label></td>
                        <%
                        if(deleteStatus){
                        %>
                        <td>&nbsp;</td>
                        <%
                        }
                        %>
                    </tr>
                    <%
                        String endDate;

                        DateAndTimeControl.CustomDate custom;
                        int duration, totalDuration = 0;
                        for (WebBusinessObject status : statuses) {
                            endDate = "-----";
                            duration = (Integer) status.getAttribute("duration");
                            totalDuration += duration;
                            custom = DateAndTimeControl.getDelayTime(duration);
                            if (status.getAttribute("endDate") != null) {

                                endDate = DateAndTimeControl.getArabicDateTimeFormatted((Timestamp) status.getAttribute("endDate"));
    //                            endDate = sdf.format((Timestamp) status.getAttribute("endDate"));
                            }
                    %>

                    <tr id="row<%=status.getAttribute("statusID")%>">
                        <td style="width: 17%;"> <label style="width: 100px;"><%=status.getAttribute("caseName")%></label></td>
                        <td style="width: 17%;">
                            <label id="requestDate">
                                <%=DateAndTimeControl.getArabicDateTimeFormatted((Timestamp) status.getAttribute("beginDate"))%>
                            </label>
                        </td>
                        <td style="width: 17%;">
                            <label id=""><%=endDate%></label>
                        </td>
                        <td style="width: 5%;"><label id=""><%=DateAndTimeControl.CustomDate.getAsString(custom.getDays())%></label></td>
                        <td style="width: 5%;"><label id=""><%=DateAndTimeControl.CustomDate.getAsString(custom.getHours())%></label></td>
                        <td style="width: 5%;"><label id=""><%=DateAndTimeControl.CustomDate.getAsString(custom.getMinutes())%></label></td>
                        <td style="width: 17%;background-color: yellow"><label id=""><%=status.getAttribute("status")%> </label></td>
                        <td style="width: 17%;" nowrap><label id="" ><%=status.getAttribute("createdByName")%> </label></td>
                        <%
                        if(deleteStatus){
                        %>
                        <td style="display: none;"><img src="images/icons/remove.png" style="height: 20px; cursor: hand;" title="Delete Status"
                                 onclick="JavaScript: deleteStatusConfirm('<%=status.getAttribute("statusID")%>')"/></td>
                        <%
                        }
                        %>

                    </tr>
                    <% }%>
                    <tr>
                        <td colspan="10">
                            <hr style="width: 100%;">
                        </td>
                    </tr>
                    <tr id="total">
                        <%
                            custom = DateAndTimeControl.getDelayTime(totalDuration);
                        %>
                        <td style="width: 17%;">الوقت الكلى </td>
                        <td style="width: 17%;"></td>
                        <td style="width: 17%;"></td>
                        <td style="width: 5%; text-decoration:underline"><%=DateAndTimeControl.CustomDate.getAsString(custom.getDays())%></td>
                        <td style="width: 5%; text-decoration:underline"><%=DateAndTimeControl.CustomDate.getAsString(custom.getHours())%></td>
                        <td style="width: 5%; text-decoration:underline"><%=DateAndTimeControl.CustomDate.getAsString(custom.getMinutes())%></td>
                        <td style="width: 17%"></td>
                        <td style="width: 17%"></td>
                        <%
                        if(deleteStatus){
                        %>
                        <td>&nbsp;</td>
                        <%
                        }
                        %>
                    </tr>
                </tbody>
            </table>
        </div>
    </body>
</html>