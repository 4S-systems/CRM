<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <%
        int flipper = 0;
        String bgColor = null;
        String bgColorm = null;

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        AppConstants appCons = new AppConstants();

        String[] groupAttributes = appCons.getGroupAttributes();
        String[] groupListTitles = appCons.getGroupHeaders();

        int s = groupAttributes.length;
        int t = s + 4;
        int iTotal = 0;

        String attName = null;
        String attValue = null;
        String cellBgColor = null;

        Vector usersList = (Vector) request.getAttribute("data");

        WebBusinessObject wbo = null;
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, tit, save, cancel, TT, IG, newGroupName, QS, BO, cloneGroup, sGroupsTotal, NAS, sGroupsList, previliges, setPreviliges;
        String setProject;
        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            tit = "Delete Schedule - Are you Sure ?";
            save = "Save";
            cancel = "Back To List";
            TT = "Task Title ";
            IG = "Indicators guide ";
            newGroupName = "New Group";
            NAS = "Non Active Site";
            QS = "Quick Summary";
            BO = "Basic Operations";
            groupListTitles[0] = "Group Name";
            groupListTitles[1] = "Type";
            groupListTitles[2] = "View";
            groupListTitles[3] = "Edit";
            groupListTitles[4] = "Delete";
            cloneGroup = "Clone Group";
            sGroupsTotal = "Total Groups";
            sGroupsList = "Groups List";
            previliges = "Previliges";
            setPreviliges = "Assign Prevliges";
            setProject = "assign folders";
        } else {

            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            tit = " &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
            save = " حفظ";
            cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
            TT = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
            IG = "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
            newGroupName = "المجموعة الجديدة";
            NAS = "&#1605;&#1608;&#1602;&#1593; &#1604;&#1575; &#1578;&#1593;&#1605;&#1604; &#1576;&#1607; &#1605;&#1593;&#1583;&#1575;&#1578;";
            QS = "&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
            BO = "&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
            groupListTitles[0] = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
            groupListTitles[1] = "المجموعة اﻷدارية";
            groupListTitles[2] = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
            groupListTitles[3] = "&#1578;&#1581;&#1585;&#1610;&#1585;";
            groupListTitles[4] = "&#1581;&#1584;&#1601;";
            cloneGroup = "نسخ المجموعة";
            sGroupsTotal = "&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1575;&#1578;";
            sGroupsList = "&#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1575;&#1578;";
            previliges = "&#1575;&#1604;&#1589;&#1604;&#1575;&#1581;&#1610;&#1575;&#1578;";
            setPreviliges = "ص.العمل";
            setProject = "ص.هيكل المؤسسة";
        }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>Group List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="css/tooltip.css"/>

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <SCRIPT  TYPE="text/javascript">
            var divID;
            var oTable;
            var group = new Array();
            $(document).ready(function() {
                oTable = $('#group').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });

            function showGroupUsers(groupID) {
                var url = "<%=context%>/GroupServlet?op=manageGroupMembers&groupID=" + groupID;
                jQuery('#group_users').load(url);
                $('#group_users').css("display", "block");
                $('#group_users').bPopup();
            }
            function showCloneGroup(groupID, groupName) {
                $("#cloneGroupID").val(groupID);
                $("#cloneGroupName").html(groupName);
                $('#clone_group').css("display", "block");
                $('#clone_group').bPopup();
            }
            function saveCloneGroup() {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/GroupServlet?op=cloneGroupAjax",
                    data: $("#clone_form").serialize(),
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            alert("تم الحفظ بنجاح");
                            location.reload();
                        } else if (info.status === 'fail') {
                            alert("لم يتم الحفظ");
                        }
                    }
                });
                return false;
            }
            function closePopup(obj) {
                $(obj).parent().parent().bPopup().close();
            }
            function showUserInfo(obj, userID, status) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UsersServlet?op=getUserInfoAjax",
                    data: {
                        userID: userID
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        $(obj).tooltip({
                            content: function () {
                                return "<table class='user_info_table' border='0' dir='<%=dir%>'><tr><td class='user_info_header' colspan='2'></td></tr>\n\
                                <tr><td class='user_info_title'>Created By</td><td class='user_info_data'>" + info.createdByName + "</td></tr>\n\
                                <tr><td class='user_info_title' nowrap>Creation Date</td><td class='user_info_data'>" + info.creationDate + "</td></tr>\n\
                                <tr><td class='user_info_title' nowrap>Status</td><td class='user_info_data'>" + (status === '21' ? 'Active' : 'Inactive') + "</td></tr>\n\
                                </table>";
                            }
                        });
                    }
                });
            }
        </SCRIPT>
        <style>
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;

                background: #7abcff; /* Old browsers */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
            .remove{
                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);
            }
            .smallDialog {
                width: 320px;
                display: none;
                position: fixed;
                z-index: 1100;
            }
            .mediumDialog {
                width: 370px;
                display: none;
                position: fixed;
                z-index: 1100;
                top: 150px;
                left: 500px;
            }
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 1000;
                top: 0px;
                left: 0px;
                position: fixed;
            }
            .img:hover{
                cursor: pointer ;
            }
            .user_info_table {
                padding: 10px 20px;
                color: white;
                border-radius: 20px;
                font: bold 16px "Helvetica Neue", Sans-Serif;
                box-shadow: 0 0 7px black;
            }
            .user_info_header {
                background-color: #d18080;
                padding: 5px;
            }
            .user_info_title {
                background-color: #abc0e5;
                padding: 5px;
            }
            .user_info_data {
                background-color: white;
                padding: 5px;
            }
        </style>
    </HEAD>

    <body>
        <div id="overlay" class="overlayClass" onclick="JavaScript: closeOverlay();"></div>
        <div id="group_users" style="width: 30% !important; display: none; position: fixed;"></div>
        <div id="clone_group" style="width: 30% !important; display: none; position: fixed;">
            <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 90%;float: left;margin: 0px 0xp;">
                <input type="hidden" id="siteAll" value="no" name="siteAll"/>
                <form id="clone_form" action="<%=context%>/ClientServlet?op=saveClientCampaignsByAjax">
                    <input type="hidden" name="groupID" id="cloneGroupID" value=""/>
                    <br/>
                    <table id="userGroupList" cellpadding="4" style="width: 80%;" cellspacing="2" style="border:none;" align="center" dir="<%=dir%>">
                        <tr>
                            <td style="text-align: center; border: none;">
                            <%=groupListTitles[0]%>
                            </td>
                            <td style="text-align: center; border: none;" id="cloneGroupName">
                            
                            </td>
                        </tr>
                        <tr>
                            <td style="text-align: center; border: none;" nowrap>
                            <%=newGroupName%>
                            </td>
                            <td style="text-align: center; border: none;" id="cloneGroupName">
                                <input type="text" name="groupName" id="newGroupName"/>
                            </td>
                        </tr>
                        <tr> <td style="text-align: center; border: none;" colspan="2"><br/><input type="button" onclick="saveCloneGroup();"  value="<%=save%>" style="font-family: sans-serif" ></td> </tr>
                    </table>
                </form>
            </div>
        </div>

        <fieldset align=center class="set">
            <legend align="center">
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6"><%=sGroupsList%></font>
                        </td>
                    </tr>
                </table>
            </legend>
            <br>
            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>
            </table>

            <div style="width: 70%;margin-left: auto;margin-right: auto;">
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" style="width: 100%;" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" id="group">
                    <thead>
                        <TR>
                            <TD class="blueBorder blueHeaderTD" COLSPAN="2" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:18">
                                <B><%=QS%></B>
                            </TD>
                            <TD class="blueBorder blueHeaderTD" COLSPAN="8" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:18">
                                <B><%=BO%></B>
                            </TD>
                        </TR>
                        <TR>
                            <%
                                String columnColor = new String("");
                                String columnWidth = new String("100");
                                String font = new String("12");
                                for (int i = 0; i < t; i++) {
                                    if (i == 0) {
                                        columnColor = "#9B9B00";
                                    } else {
                                        columnColor = "#7EBB00";
                                    }
                            %>
                            <TH>
                                <B><%=groupListTitles[i]%></B>
                            </TH>
                            <%
                                }
                            %>
                            <TH>
                                <B><%=previliges%></B>
                            </TH>
                            <TH>
                                <B><%=previliges%></B>
                            </TH>
                            <TH>
                                <B>اضافة مستخدم</B>
                            </TH>
                            <th>
                                <b>مستخدم جديد</b>
                            </th>
                            <th>
                                <b><%=cloneGroup%></b>
                            </th>
                        </TR>
                    </thead>

                    <TBODY>
                        <%
                            Enumeration e = usersList.elements();
                            String departmentName = "";
                            while (e.hasMoreElements()) {
                                iTotal++;
                                flipper++;
                                if ((flipper % 2) == 1) {
                                    bgColor = "silver_odd";
                                    bgColorm = "silver_odd_main";
                                } else {
                                    bgColor = "silver_even";
                                    bgColorm = "silver_even_main";
                                }
                                wbo = (WebBusinessObject) e.nextElement();
                                if (wbo.getAttribute("defaultPage") != null) {
                                    String defaultPage = (String) wbo.getAttribute("defaultPage");
                                    if (defaultPage.equals("administrator.jsp")) {
                                        departmentName = "Administrator";
                                    } else if (defaultPage.equals("manager_agenda.jsp")) {
                                        departmentName = "Middle Manager";
                                    } else if (defaultPage.equals("supervisor_agenda.jsp")) {
                                        departmentName = "Field Supervisor";
                                    } else if (defaultPage.equals("technical_agenda.jsp")) {
                                        departmentName = "Field Technician";
                                    } else if (defaultPage.equals("call_center.jsp")) {
                                        departmentName = "Call Center";
                                    } else if (defaultPage.equals("employee_agenda.jsp")) {
                                        departmentName = "Employee";
                                    } else if (defaultPage.equals("quality_assurance.jsp")) {
                                        departmentName = "Quality Assurance";
                                    } else if (defaultPage.equals("project_manager.jsp")) {
                                        departmentName = "Project Manager";
                                    } else if (defaultPage.equals("notification_system.jsp")) {
                                        departmentName = "Notification";
                                    } else if (defaultPage.equals("manager_monitor.jsp")) {
                                        departmentName = "Manager Monitor";
                                    } else if (defaultPage.equals("sales_market.jsp")) {
                                        departmentName = "Sales and Marketing";
                                    } else if (defaultPage.equals("secretary_agenda.jsp")) {
                                        departmentName = "Secretary";
                                    } else if (defaultPage.equals("marketing.jsp")) {
                                        departmentName = "Units";
                                    } else if (defaultPage.equals("sub_div_manager_monitor.jsp")) {
                                        departmentName = "Sub Department Monitor";
                                    } else if (defaultPage.equals("contracts_agenda.jsp")) {
                                        departmentName = "Contracts";
                                    } else if (defaultPage.equals("global_notify_agenda.jsp")) {
                                        departmentName = "Global Notifications";
                                    } else if (defaultPage.equals("purchase_agenda.jsp")) {
                                        departmentName = "Purchase";
                                    } else if (defaultPage.equals("general_task_agenda.jsp")) {
                                        departmentName = "General Task";
                                    } else if (defaultPage.equals("sla_agenda.jsp")) {
                                        departmentName = "Service Level Agreement";
                                    } else if (defaultPage.equals("global_sla_agenda.jsp")) {
                                        departmentName = "Global Service Level Agreement";
                                    } else if (defaultPage.equals("quality_agenda.jsp")) {
                                        departmentName = "Quality Manager";
                                    } else if (defaultPage.equals("quality_assistant_agenda.jsp")) {
                                        departmentName = "Quality Assistant";
                                    } else if (defaultPage.equals("site_tech_office_agenda.jsp")) {
                                        departmentName = "Site Tech Office";
                                    } else if (defaultPage.equals("tech_office_request_agenda.jsp")) {
                                        departmentName = "Tech Office Request View";
                                    } else if (defaultPage.equals("non_distributed_agenda.jsp")) {
                                        departmentName = "Non Distributed View";
                                    } else if (defaultPage.equals("procurement_agenda.jsp")) {
                                        departmentName = "Procurement";
                                    } else if (defaultPage.equals("procurement_requests.jsp")) {
                                        departmentName = "Procurement Requests";
                                    } else if (defaultPage.equals("store_transactions.jsp")) {
                                        departmentName = "Store Transactions";
                                    } else if (defaultPage.equals("general_complaint_agenda.jsp")) {
                                        departmentName = "General Complaint Form";
                                    } else if (defaultPage.equals("customer_servies_agenda.jsp")) {
                                        departmentName = "CS Secretary";
                                    } else if (defaultPage.equals("CHD_agenda.jsp")) {
                                        departmentName = "Client Help Desk";
                                    } else if (defaultPage.equals("CHD_Manager.jsp")) {
                                        departmentName = "Client Help Desk Manager";
                                    } else if (defaultPage.equals("jobOrderTrack.jsp")) {
                                        departmentName = "Customer Job Order Tracking";
                                    } else if (defaultPage.equals("jOQualityAssurance.jsp")) {
                                        departmentName = "JO Quality Assurance";
                                    } else if (defaultPage.equals("generic_contracts_agenda.jsp")) {
                                        departmentName = "Contracts Notifications";
                                    } else if (defaultPage.equals("dep_contracts_agenda.jsp")) {
                                        departmentName = "Department's Contracts";
                                    } else if (defaultPage.equals("client_class_2.jsp")) {
                                        departmentName = "Client Classifications";
                                    } else if (defaultPage.equals("EmployeeSheet.jsp")) {
                                        departmentName = "Employee Affairs";
                                    }
                                }
                        %>                                


                        <TR>
                            <%
                                for (int i = 0; i < s; i++) {
                                    attName = groupAttributes[i];
                                    attValue = (String) wbo.getAttribute(attName);
                            %>

                            <TD STYLE="<%=style%>" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                                <DIV >
                                    <b onclick="JavaScript: showGroupUsers('<%=wbo.getAttribute("groupID")%>');" style="cursor: pointer;"> <%=attValue%> </b>
                                </DIV>
                            </TD>
                            <%
                                }
                            %>
                            
                            <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>">
                                <DIV ID="links">
                                    <%=departmentName%>
                                </DIV>
                            </TD>
                            
                            <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>">
                                <DIV ID="links">
                                    <A HREF="<%=context%>/GroupServlet?op=ViewGroup&groupID=<%=wbo.getAttribute("groupID")%>">
                                        <%=groupListTitles[2]%>
                                    </A>
                                </DIV>
                            </TD>

                            <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>">
                                <DIV ID="links">
                                    <% if (attValue.equalsIgnoreCase("administrator")) {
                                    %>
                                    ******
                                    <%} else {%>
                                    <A HREF="<%=context%>/GroupServlet?op=GetUpdateForm&groupID=<%=wbo.getAttribute("groupID")%>">
                                        <%=groupListTitles[3]%>
                                    </A>
                                </DIV>
                                <%
                                    }
                                %>
                            </TD>

                            <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>">
                                <DIV ID="links">
                                    <% if (attValue.equalsIgnoreCase("administrator")) {%>
                                    ******
                                    <%
                                    } else {
                                        if (metaMgr.getCandelete().equals("1")) {
                                    %>
                                    <A HREF="<%=context%>/GroupServlet?op=ConfirmDelete&groupID=<%=wbo.getAttribute("groupID")%>">
                                        <%=groupListTitles[4]%>
                                    </A>
                                    <%
                                    } else { %>
                                    ******                                    
                                    <% }
                                        }
                                    %>
                                </DIV>
                            </TD>
                            <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>">
                                <DIV ID="links">

                                    <A HREF="<%=context%>/GroupServlet?op=assignPrevliges&groupId=<%=wbo.getAttribute("groupID")%>">
                                        <%=setPreviliges%>
                                    </A>
                                </DIV>

                            </TD>

                            <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>">
                                <DIV ID="links">
                                    <A HREF="<%=context%>/GroupServlet?op=assignProjectByGroup&groupId=<%=wbo.getAttribute("groupID")%>">
                                        <%=setProject%>
                                    </A>
                                </DIV>
                            </TD>
                            
                            <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>">
                                <DIV ID="links">
                                    <A onclick="return getDataInPopup('GroupServlet?op=GetAllUsers&groupId=<%=wbo.getAttribute("groupID")%>&groupName=<%=wbo.getAttribute("groupName")%>&defaultPage=<%=wbo.getAttribute("defaultPage")%>')">
                                        اضافة مستخدم
                                    </A>
                                </DIV>
                            </TD>
                            <td nowrap class="<%=bgColor%>" bgcolor="#D7FF82" style="padding-right:10;<%=style%>">
                                <div ID="links">
                                    <a target="newUser" href="<%=context%>/UsersServlet?op=GetForm&groupID=<%=wbo.getAttribute("groupID")%>">
                                        مستخدم جديد
                                    </a>
                                </div>
                            </td>
                            <td style="<%=style%>" bgcolor="#DDDD00" nowrap class="<%=bgColorm%>">
                                <div>
                                    <a href="JavaScript: showCloneGroup('<%=wbo.getAttribute("groupID")%>', '<%=wbo.getAttribute("groupName")%>');" style="cursor: pointer;"> <%=cloneGroup%> </a>
                                </div>
                            </td>
                        </TR>
                        <%
                            }
                        %> 
                    </TBODY>
                </TABLE>
            </DIV>
        </fieldset>
    </body>
</html>
