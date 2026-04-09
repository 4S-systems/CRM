<%@ page import="com.silkworm.business_objects.secure_menu.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<HTML>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
        int iTotal = 0, i = 0, j = 0;
        HttpSession s = request.getSession();
        ServletContext c = s.getServletContext();
        ThreeDimensionMenu tdm = (ThreeDimensionMenu) c.getAttribute("myMenu");

    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>New Group</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    </SCRIPT>

    <%        HttpSession thisSession = request.getSession();
        ServletContext thisContext = thisSession.getServletContext();
        ThreeDimensionsContainer tdc = (ThreeDimensionsContainer) thisContext.getAttribute("myMenu");
        TwoDimensionMenu twoDContainer = new TwoDimensionMenu();

        ArrayList headers = tdc.getContents();
        ListIterator headersIterator = headers.listIterator();
        ListIterator contentsIterator = null;
        ArrayList contents = null;
        WebBusinessObjectsContainer wboc = null;
        WebBusinessObject wbo = null;

        WebBusinessObject group = (WebBusinessObject) request.getAttribute("group");
        String gMenu = (String) group.getAttribute("groupMenu");

        String check = null;
        String onOff = null;
        String pos = null;
        int intPos;
        String status = (String) request.getAttribute("status");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode;

        String saving_status;
        String sTitle, title_2;
        String sGroupName, sGroupDesc;
        String cancel_button_label;
        String save_button_label, sPadding, sMenu, sSelect, sGroupType, success, fail;
        if (stat.equals("En")) {

            saving_status = "Saving status";
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";

            sGroupName = "Group Name";
            sGroupDesc = "Group Description";
            sTitle = "Update Group";
            title_2 = "All information are needed";
            cancel_button_label = "Back To List";
            save_button_label = "Update";
            langCode = "Ar";
            sPadding = "left";
            sMenu = "Menu";
            sSelect = "Select";
            sGroupType = "Type";
            success = "Group updated Successfully";
            fail = "Fail to Update Group";
        } else {

            saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";

            sGroupName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
            sGroupDesc = "&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
            sTitle = "&#1578;&#1581;&#1583;&#1610;&#1579; &#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
            title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
            cancel_button_label = "&#1593;&#1608;&#1583;&#1577;";
            save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604;";
            langCode = "En";
            sPadding = "right";
            sMenu = "&#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
            sSelect = "&#1575;&#1582;&#1578;&#1575;&#1585;";
            success = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1581;&#1583;&#1610;&#1579; &#1576;&#1606;&#1580;&#1575;&#1581;";
            fail = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1581;&#1583;&#1610;&#1579; &#1576;&#1606;&#1580;&#1575;&#1581;";
            sGroupType = "&#x0627;&#x0644;&#x0645;&#x062C;&#x0645;&#x0648;&#x0639;&#x0647; &#x0627;&#x0644;&#x0625;&#x062F;&#x0627;&#x0631;&#x064A;&#x0647;";
        }

    %>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        <!--
        var checked = false;
        function checkAll(mainMenuId) {

            if (document.getElementById('mainMenu' + mainMenuId).checked == true) {
                checked = true;
            } else {
                checked = false;
            }

            var totalSubMainMenu = document.getElementById('totalSubMainMenu' + mainMenuId).value;
            for (i = 1; i <= totalSubMainMenu; i++) {
                document.getElementById('subMainMenu' + mainMenuId + '' + i).checked = checked;
            }
        }

        function checkAllSub(i, obj) {
            $(".mainMenu" + i).prop('checked', $(obj).is(':checked'));
            var len = $(".mainMenu" + i).length;
            for (l = 0; l < len; l++) {
                checkAllElement(i, l, $(".mainMenu" + i)[l]);
            }
        }

        function checkAllElement(k, j, obj) {
            $(".mainMenu" + k + "_" + j).prop('checked', $(obj).is(':checked'));
        }

        function getChecked(i, j, obj) {
            if ($(obj).is(':checked')) {
                $("#menuCheck" + i).prop('checked', $(obj).is(':checked'));
                $("#mainMenu" + i + "_" + j).prop('checked', $(obj).is(':checked'));
            } else {
                var isChecked = false;
                $(".mainMenu" + i + "_" + j).each(function () {
                    if ($(this).is(':checked')) {
                        isChecked = true;
                        return;
                    }
                });
                $("#mainMenu" + i + "_" + j).prop('checked', isChecked);
                isChecked = false;
                $(".mainMenu" + i).each(function () {
                    if ($(this).is(':checked')) {
                        isChecked = true;
                        return;
                    }
                });
                $("#menuCheck" + i).prop('checked', isChecked);
            }
        }

        function getCheckedSubParent(i, obj) {
            if ($(obj).is(':checked')) {
                $("#menuCheck" + i).prop('checked', $(obj).is(':checked'));
            } else {
                var isChecked = false;
                $(".mainMenu" + i).each(function () {
                    if ($(this).is(':checked')) {
                        isChecked = true;
                        return;
                    }
                });
                $("#menuCheck" + i).prop('checked', isChecked);
            }
        }

        function submitForm()
        {
            var selectedMsg = $("#group").find(":checkbox:checked");
            $("#url").val("");
            var url = "";
            $(selectedMsg).each(function (index, obj) {


                var urlPath = $(obj).parent().find("#target").val();
                var urlPath2 = $(obj).parent().parent().find("#target2").val();
                if (urlPath2 != null && urlPath2 != "undefined" && urlPath2 != "") {
                    url += urlPath2 + ",";
                }
                if (urlPath != null && urlPath != "undefined" && urlPath2 != "") {
                    url += urlPath + ",";


                }


            })

            $("#url").val(url);
            document.GROUP_FORM.action = "<%=context%>/GroupServlet?op=UpdateGroup";
            document.GROUP_FORM.submit();
        }
        function cancelForm()
        {
            document.GROUP_FORM.action = "<%=context%>/GroupServlet?op=ListAll";
            document.GROUP_FORM.submit();
        }
-->
    </SCRIPT>
    <BODY>
        <FORM NAME="GROUP_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <button    onclick="cancelForm()" class="button"><%=cancel_button_label%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV>
            <FIELDSET class="set" align="center">
                <legend align="center">
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>

                            <td class="td">
                                <font color="blue" size="6">    <%=sTitle%>
                                </font>

                            </td>
                        </tr>
                    </table>
                </legend>
                <TABLE  CELLPADDING="0" CELLSPACING="0" BORDER="0" ALIGN="CENTER" DIR="<%=dir%>">
                    <%
                        if (null != status) {
                            if (status.equalsIgnoreCase("ok")) {
                    %>

                    <font color="blue" size="4"><%=success%></font>

                    <%
                    } else {%>
                    <font color="#FF0000" size="4"><%=fail%></font>
                    <%}
                        }
                    %>
                </TABLE>
                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" ALIGN="CENTER" DIR="<%=dir%>">
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Group_Name">
                                <p><b><%=sGroupName%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <input  type="TEXT" name="groupName" ID="groupName" size="33" value="<%=group.getAttribute("groupName")%>" maxlength="255" style="width:230px;">
                            <input type="HIDDEN" name="groupID" ID="groupID" size="33" value="<%=group.getAttribute("groupID")%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Group_Type">
                                <p><b><%=sGroupType%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <select id="type" name="type" style="font-size: 14px;width:230px;">
                                <OPTION VALUE="admin" <% if (group.getAttribute("defaultPage").equals("administrator.jsp")) {%> SELECTED <% }%>>Administrator</option>
                                <OPTION VALUE="mgr" <% if (group.getAttribute("defaultPage").equals("manager_agenda.jsp")) {%> SELECTED <% }%>>Middle Manager</option>
                                <OPTION VALUE="super" <% if (group.getAttribute("defaultPage").equals("supervisor_agenda.jsp")) {%> SELECTED <% }%>>Field Supervisor</option>
                                <OPTION VALUE="tech" <% if (group.getAttribute("defaultPage").equals("technical_agenda.jsp")) {%> SELECTED <% }%>>Field Technician</option>
                                <OPTION VALUE="call" <% if (group.getAttribute("defaultPage").equals("call_center.jsp")) {%> SELECTED <% }%>>Call Center</option>
                                <OPTION VALUE="emp" <% if (group.getAttribute("defaultPage").equals("employee_agenda.jsp")) {%> SELECTED <% }%>>Employee</option>
                                <OPTION VALUE="qa" <% if (group.getAttribute("defaultPage").equals("quality_assurance.jsp")) {%> SELECTED <% }%>>Quality Assurance</option>
                                <OPTION VALUE="pm" <% if (group.getAttribute("defaultPage").equals("project_manager.jsp")) {%> SELECTED <% }%>>Project Manager</option>
                                <OPTION VALUE="notification" <% if (group.getAttribute("defaultPage").equals("notification_system.jsp")) {%> SELECTED <% }%>>Notification</option>
                                <OPTION VALUE="monitor" <% if (group.getAttribute("defaultPage").equals("manager_monitor.jsp")) {%> SELECTED <% }%>>Manager Monitor</option>
                                <OPTION VALUE="sales" <% if (group.getAttribute("defaultPage").equals("sales_market.jsp")) {%> SELECTED <% }%>>Sales and Marketing</option>
                                <OPTION VALUE="secretary" <% if (group.getAttribute("defaultPage").equals("secretary_agenda.jsp")) {%> SELECTED <% }%>>Secretary</option>
                                <OPTION VALUE="units" <% if (group.getAttribute("defaultPage").equals("marketing.jsp")) {%> SELECTED <% }%>>Units</option>
                                <OPTION VALUE="subDivMonitor" <% if (group.getAttribute("defaultPage").equals("sub_div_manager_monitor.jsp")) {%> SELECTED <% }%>>Sub Department Monitor</option>
                                <OPTION VALUE="contracts" <% if (group.getAttribute("defaultPage").equals("contracts_agenda.jsp")) {%> SELECTED <% }%>>Contracts</option>
                                <OPTION VALUE="globalNotifications" <% if (group.getAttribute("defaultPage").equals("global_notify_agenda.jsp")) {%> SELECTED <% }%>>Global Notifications</option>
                                <OPTION VALUE="purchase" <% if (group.getAttribute("defaultPage").equals("purchase_agenda.jsp")) {%> SELECTED <% }%>>Purchase</option>
                                <option VALUE="generalTask" <% if (group.getAttribute("defaultPage").equals("general_task_agenda.jsp")) {%> SELECTED <% }%>>General Task</option>
                                <option VALUE="sla" <% if (group.getAttribute("defaultPage").equals("sla_agenda.jsp")) {%> SELECTED <% }%>>Service Level Agreement</option>
                                <option VALUE="gsla" <% if (group.getAttribute("defaultPage").equals("global_sla_agenda.jsp")) {%> SELECTED <% }%>>Global Service Level Agreement</option>
                                <option VALUE="quality" <% if (group.getAttribute("defaultPage").equals("quality_agenda.jsp")) {%> SELECTED <% }%>>Quality Manager</option>
                                <option VALUE="qualityAssistant" <% if (group.getAttribute("defaultPage").equals("quality_assistant_agenda.jsp")) {%> SELECTED <% }%>>Quality Assistant</option>
                                <option VALUE="siteTechOffice" <% if (group.getAttribute("defaultPage").equals("site_tech_office_agenda.jsp")) {%> SELECTED <% }%>>Site Tech Office</option>
                                <option VALUE="techOfficeRequest" <% if (group.getAttribute("defaultPage").equals("tech_office_request_agenda.jsp")) {%> SELECTED <% }%>>Tech Office Request View</option>
                                <option VALUE="nonDistributed" <% if (group.getAttribute("defaultPage").equals("non_distributed_agenda.jsp")) {%> SELECTED <% }%>>Non Distributed View</option>
                                <option VALUE="procurement" <% if (group.getAttribute("defaultPage").equals("procurement_agenda.jsp")) {%> SELECTED <% }%>>Procurement</option>
                                <option VALUE="procurementRequests" <% if (group.getAttribute("defaultPage").equals("procurement_requests.jsp")) {%> SELECTED <% }%>>Procurement Requests</option>
                                <option VALUE="storeTransactions" <% if (group.getAttribute("defaultPage").equals("store_transactions.jsp")) {%> SELECTED <% }%>>Store Transactions</option>
                                <option VALUE="generalComplaint" <% if (group.getAttribute("defaultPage").equals("general_complaint_agenda.jsp")) {%> SELECTED <% }%>>General Complaint Form</option>
                                <option VALUE="CSSecretary" <% if (group.getAttribute("defaultPage").equals("customer_servies_agenda.jsp")) {%> SELECTED <% }%>>CS Secertary</option>
                                <option VALUE="CHD" <% if (group.getAttribute("defaultPage").equals("CHD_agenda.jsp")) {%> SELECTED <% }%>>Client Help Desk</option>
                                <option VALUE="CHDManager" <% if (group.getAttribute("defaultPage").equals("CHD_Manager.jsp")) {%> SELECTED <% }%>>Client Help Desk Manager</option>
                                <option VALUE="customerJobOrderTrack" <% if (group.getAttribute("defaultPage").equals("jobOrderTrack.jsp")) {%> SELECTED <% }%>>Customer Job Order Tracking</option>
                                <option VALUE="jOQualityAssurance" <% if (group.getAttribute("defaultPage").equals("jOQualityAssurance.jsp")) {%> SELECTED <% }%>>JO Quality Assurance</option>
                                <option VALUE="em" <% if (group.getAttribute("defaultPage").equals("EmployeeSheet.jsp")) {%> SELECTED <% }%>>Employee Affairs</option>
                                <option VALUE="contractsNotifications" <% if (group.getAttribute("defaultPage").equals("generic_contracts_agenda.jsp")) {%> SELECTED <% }%>>Contracts Notifications</option>
                                <option VALUE="departmentsContracts" <% if (group.getAttribute("defaultPage").equals("dep_contracts_agenda.jsp")) {%> SELECTED <% }%>>Department's Contracts</option>
                                <option VALUE="clientClassifications" <% if (group.getAttribute("defaultPage").equals("client_class_2.jsp")) {%> SELECTED <% }%>>Client Classifications</option>
                                <option VALUE="teamLeader" <% if (group.getAttribute("defaultPage").equals("emp_statistic_page.jsp")) {%> SELECTED <% }%>>Team Leader</option>
                                <option VALUE="teamLeader" <% if (group.getAttribute("defaultPage").equals("client_statistic_page.jsp")) {%> SELECTED <% }%>>Client CRM</option>                           
                            </select>
                        </TD>
                    </TR>
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_group_Desc">
                                <p><b><%=sGroupDesc%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <TEXTAREA rows="5" name="groupDesc" cols="40" style="width:230px;"><%=group.getAttribute("groupDesc")%></TEXTAREA>
                        </TD>
                    </TR>
                </TABLE>
                </TABLE>
                <BR>
                <TABLE  id="group" WIDTH="600"  CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" ALIGN="CENTER" DIR="<%=dir%>">
                    <TR CLASS="head" STYLE="background:#055DA3;">
                        <TD CLASS="firstname"  STYLE="border-top-WIDTH:0; color:white;font-size:18;">
                            <%=sMenu%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;color:white;font-size:18;" WIDTH="33">
                            <B>
                                &nbsp;<%=sSelect%>&nbsp;
                            </B>
                        </TD>
                    </TR>
                    <%
                        com.silkworm.business_objects.secure_menu.MenuBuilder menuBuilder = new com.silkworm.business_objects.secure_menu.MenuBuilder();
                        menuBuilder.setFileURL("menu.xml");
                        menuBuilder.setXslFile(metaMgr.getWebInfPath() + "/menu_update_group" + (stat.equalsIgnoreCase("Ar") ? "" : "_en") + ".xsl");
                        menuBuilder.setFileURL(metaMgr.getWebInfPath() + "/menu.xml");
                    %>
                    <%=group.getAttribute("groupMenu") != null ? menuBuilder.getMenuGroupForEdit((String) group.getAttribute("groupMenu")) : tdm.getMenuGroupString()%>
                    <input type="hidden" name="totalMainMenu" id="totalMainMenu" value="<%=i%>">
                    <input type="hidden" name="total" id="total" value="<%=iTotal%>">
                    <input type="hidden" name="url" id="url" value="">
                </TABLE>
                <BR><BR>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>
