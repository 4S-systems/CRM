<%@page import="com.maintenance.db_access.UserCompanyProjectsMgr"%>
<%@page import="com.maintenance.db_access.TradeMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.tracker.db_access.UserAreaMgr"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.util.List"%>
<%@page import="com.crm.common.CalendarUtils"%>
<%@page import="com.crm.common.CalendarUtils.Day"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.Map"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>  
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        Map<String, Map<String, WebBusinessObject>> data = (Map<String, Map<String, WebBusinessObject>>) request.getAttribute("data");
        WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
        Calendar c = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        String nowDate = sdf.format(c.getTime());
        List<CalendarUtils.Day> days = (List<CalendarUtils.Day>) request.getAttribute("days");
        String projectID = (String) request.getAttribute("projectID");
        ArrayList<WebBusinessObject> unitsList = (ArrayList<WebBusinessObject>) request.getAttribute("unitsList");
        if(unitsList == null) {
            unitsList = new ArrayList<>();
        }
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String PL, titleRow, joborderTitle, roleTitle;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            PL = "Agents Appoientments";
            titleRow = "Agent Name";
            joborderTitle = "Job Order";
            roleTitle = "Role";
        } else {
            align = "center";
            dir = "RTL";
            PL = "أوامر شغل فنيين";
            titleRow = "اسم الموظف";
            joborderTitle = "زيارة لعميل";
            roleTitle = "المهنة";
        }
    %>
    <head>
        <script type="text/javascript">
            $(function () {
                $("#joborderDate").datepicker({
                    minDate: new Date('<%=nowDate%>'),
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy/mm/dd'
                });
            });
            function popupJoborder(userID, userName, roleType) {
                divID = "client_joborder";
                $('#joborderClientName').html($('#clientName').val() ? $('#clientName').val() : $('#clientName').html());
                $('#joborderClientMobile').html($("#clientMobile").val() ? $("#clientMobile").val() : $('#client_mobile').html());
                $('#joborderAddress').html($('#address').val() ? $('#address').val() : $('#address').html());
                $('#joborderTechnician').html(userName);
                $('#joborderUserID').val(userID);

                if (roleType == 'supervisor') {
                    $('#joborderManager').show();
                    $('#joborderWorker').hide();
                } else {
                    $('#joborderManager').hide();
                    $('#joborderWorker').show();
                }

                $('#client_joborder').css("display", "block");
                $('#client_joborder').bPopup();
            }
            function saveJoborderManager(obj) {
                var ticketType = "12";
                var comment = $('#joborderComment').val();
                var userId = $('#joborderUserID').val();
                var clientId = $('#clientId').val();
                var joborderDate = $('#joborderDate').val();
                var address = $('#joborderAddress').val();
                var unitID = $('#unitID').val();
                if (validateJoborder(obj)) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/IssueServlet?op=saveJoborderManager",
                        data: {
                            userId: userId,
                            comment: comment,
                            ticketType: ticketType,
                            clientId: clientId,
                            joborderDate: joborderDate,
                            title: 'Job Order',
                            note: 'Job Order',
                            address: address,
                            unitID: unitID
                            subject: 'Job Order',
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status == 'ok') {
                                alert('تم حفظ الزيارة بنجاح');
                                closePopupDialog('client_joborder');
                                $("#add_service").trigger("click");
                            } else if (info.status == 'notManager') {
                                alert('المشرف علي هذه المنطقة ليس مدير ﻷدارة. لا يمكن الحفظ.');
                            } else if (info.status == 'hasMaxVisit') {
                                alert('أوامر تشغيل العامل مكتملة لهذا اليوم. لا يمكن الحفظ.');
                            }
                        }
                    });
                }
            }
            function saveJoborderWorker(obj) {
                var ticketType = "12";
                var comment = $('#joborderComment').val();
                var userId = $('#joborderUserID').val();
                var clientId = $('#clientId').val();
                var joborderDate = $('#joborderDate').val();
                var address = $('#joborderAddress').val();
                var unitID = $('#unitID').val();
                if (validateJoborder(obj)) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/IssueServlet?op=saveJoborderWorker",
                        data: {
                            userId: userId,
                            comment: comment,
                            ticketType: ticketType,
                            clientId: clientId,
                            joborderDate: joborderDate,
                            title: 'Job Order',
                            note: 'Job Order',
                            address: address,
                            unitID: unitID,
                            subject: 'Job Order'
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status == 'ok') {
                                alert('تم حفظ الزيارة بنجاح');
                                closePopupDialog('client_joborder');
                                $("#add_service").trigger("click");
                            } else if (info.status == 'hasNoManager') {
                                alert('المشرف علي هذه العامل ليس مدير ﻷدارة. لا يمكن الحفظ.');
                            } else if (info.status == 'hasMaxVisit') {
                                alert('أوامر تشغيل العامل مكتملة لهذا اليوم. لا يمكن الحفظ.');
                            }
                        }
                    });
                }
            }
            function validateJoborder(obj) {
                return true;
            }
        </script>
        <style type="text/css">
            .supervisorClass {
                color: red;
            }
            .technicianClass {
                color: black;
            }
        </style>
    </head>
    <body>
        <div id="client_joborder" style="width: 40% !important;display: none;position: relative; z-index: 10000;">
            <div style="clear: both;margin-left: 95%;margin-top: 0px;margin-bottom: -38px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopupDialog('client_joborder')"/>
            </div>
            <div class="login" style="width: 95%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <h1 align="center" style="vertical-align: middle; background-color: #006daa;">أمر شغل <img src="images/icons/visit_icon.png" alt="phone" width="24px"/></h1>
                <table class="table" style="width:100%;">
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">اسم العميل : </td>
                        <td style="text-align:right">
                            <label id="joborderClientName"></label>
                            <input type="hidden" id="joborderUserID" name="joborderUserID"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">رقم الموبايل : </td>
                        <td style="text-align:right">
                            <label id="joborderClientMobile"></label>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">العنوان : </td>
                        <td style="text-align:right">
                            <label id="joborderAddress"></label>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">الوحدة : </td>
                        <td style="text-align:right">
                            <select id="unitID" name="unitID" style="font-size: 12px; width: 200px;">
                                <sw:WBOOptionList wboList="<%=unitsList%>" displayAttribute="productName" valueAttribute="projectId"/>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">اسم الفني : </td>
                        <td style="text-align:right">
                            <label id="joborderTechnician"></label>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">عامل الأتصال : </td>
                        <td style="text-align:right">
                            <label id="joborderEmployee"><%=loggedUser.getAttribute("userName")%></label>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">تاريخ الصيانة : </td>
                        <td style="text-align:right">
                            <input id="joborderDate" name="joborderDate" type="text" value="<%=nowDate%>" readonly="true"
                                   title="Date Format: yyyy/MM/dd" style="width: 180px;"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">تعليق : </td>
                        <td style="text-align:right">
                            <textarea cols="26" rows="10" id="joborderComment" style="width: 99%; background-color: #FFF7D6;"></textarea>
                        </td>
                    </tr>
                </table>
                <div style="text-align: left;margin-left: 2%;margin-right: auto;" > 
                    <button type="button" id="joborderManager" onclick="javascript: saveJoborderManager(this);" style="font-size: 14px; font-weight: bold; width: 150px">حفظ</button>
                    <button type="button" id="joborderWorker" onclick="javascript: saveJoborderWorker(this);" style="font-size: 14px; font-weight: bold; width: 150px">حفظ</button>
                </div>
                <div id="progress" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
                <div style="margin: 0 auto;display: none; width: 90%;text-align: center;color: white;font-size: 16px;font-weight: bold" id="appMsg">تم إضافة المقابلة </div>
            </div>  
        </div>
        <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="800px" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
            <TR>
                <TD class="blueBorder blueHeaderTD" COLSPAN="<%=(days.size() + 3)%>" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:14px">
                    <DIV>
                        <B>
                            <%=PL%>
                        </B>
                    </DIV>
                </TD>
            </TR>
            <TR>
                <TD rowspan="2" STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="silver_odd_main" >
                    <b><font size="2" color="#000080" style="text-align: center;">#</font></b>
                </TD>
                <TD rowspan="2" class="silver_footer" bgcolor="#808000" STYLE="width: 200px;text-align:center;color:black;font-size:14px">
                    <b><font color="#000080" style="text-align: center;"><%=titleRow%></font></b>
                </TD>
                <TD rowspan="2" class="silver_footer" bgcolor="#808000" STYLE="width: 200px;text-align:center;color:black;font-size:14px">
                    <b><font color="#000080" style="text-align: center;"><%=roleTitle%></font></b>
                </TD>
            </TR>
            <TR>
                <% for (Day day : days) {%>
                <TD STYLE="text-align: center; font-size: x-small;" BGCOLOR="#DDDD00" nowrap  CLASS="silver_odd_main" >
                    <font color="red"><%=day.getName()%></font>
                    <br>
                    <B><%=day.getDay()%></B>
                </TD>
                <%}%>
                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="silver_odd_main" >
                    &nbsp;
                </TD>
            </TR>
            <%
                String userId, userName, bgColorm;
                Map<String, WebBusinessObject> dayInfo;
                WebBusinessObject appointment;
                WebBusinessObject userRole;
                String roleType, altValue, visitCount;
                int flipper = 0;
                UserCompanyProjectsMgr userCompanyProjectsMgr = UserCompanyProjectsMgr.getInstance();
                TradeMgr tradeMgr = TradeMgr.getInstance();
                for (Map.Entry<String, Map<String, WebBusinessObject>> entry : data.entrySet()) {
                    userId = entry.getKey().split("@@")[0];
                    ArrayList<WebBusinessObject> usersInProjectList = new ArrayList<>(userCompanyProjectsMgr.getOnArbitraryDoubleKeyOracle(
                                projectID, "key2", CRMConstants.TRADE_FIELD_TECHNICIAN_ID, "key4"));
//                    ArrayList<WebBusinessObject> userAreaList = new ArrayList(userAreaMgr.getOnArbitraryDoubleKeyOracle(userId, "key1", areaID, "key2"));
                    WebBusinessObject userWbo ;
                    String roleName = "none";
                    if(!usersInProjectList.isEmpty()) {
                        userWbo = usersInProjectList.get(usersInProjectList.size() - 1);
                        roleName = (String)tradeMgr.getOnSingleKey((String) userWbo.getAttribute("option1")).getAttribute("tradeName");
                    }
                    userName = entry.getKey().split("@@")[1];
                    dayInfo = entry.getValue();
                    userRole = dayInfo.get("userRole");
                    roleType = "technician";
                    altValue = "";
                    if (userRole != null && "supervisor".equals(userRole.getAttribute("roleType"))) {
                        roleType = "supervisor";
                        altValue = "مشرف المنطقة";
                    }
                    if ((flipper % 2) == 1) {
                        bgColorm = "silver_odd_main";
                    } else {
                        bgColorm = "silver_even_main";
                    }
                    flipper++;
            %>
            <TR>
                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                    <DIV>
                        <%=flipper%>
                    </DIV>
                </TD>
                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%> <%=roleType%>Class" >
                    <DIV title="<%=altValue%>">
                        <%=userName%>
                    </DIV>
                </TD>
                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%> <%=roleType%>Class" >
                    <DIV title="<%=altValue%>">
                        <%=roleName%>
                    </DIV>
                </TD>
                <%
                    for (Day day : days) {
                        appointment = dayInfo.get(day.getDay() + "");
                        if (appointment != null) {
                            visitCount = (String) appointment.getAttribute("visitCount");
                        } else {
                            visitCount = "";
                        }
                %>
                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                    <b style="font-size: medium;"><%=visitCount%></b>
                </TD>
                <% }%>
                <TD STYLE="text-align: center" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                    <img src="images/icons/visit_icon.png" height="30px" title="<%=joborderTitle%>"
                         style="cursor: hand;" onclick="JavaScript: popupJoborder('<%=userId%>', '<%=userName%>', '<%=roleType%>')"/>
                </TD>
            <TR>
                <% }%>
        </TABLE>
        <br/><br/>
    </body>
</html>
