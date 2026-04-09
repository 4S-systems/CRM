<%@page import="com.silkworm.business_objects.secure_menu.ThreeDimensionMenu"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.business_objects.secure_menu.TwoDimensionMenu,com.silkworm.business_objects.secure_menu.OneDimensionMenu"%> 

<HTML>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        HttpSession s = request.getSession();
        ServletContext c = s.getServletContext();
        int iTotal = 0, i = 0, j = 0;
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
        <!--
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
                if (urlPath != null && urlPath != "undefined") {
                    url += urlPath + ",";


                }


            })

            $("#url").val(url);

            document.GROUP_FORM.action = "<%=context%>/GroupServlet?op=SaveGroup";
            document.GROUP_FORM.submit();
        }

        function cancelForm()
        {
            document.GROUP_FORM.action = "main.jsp";
            document.GROUP_FORM.submit();
        }
-->
    </SCRIPT>

    <%
        TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
        HttpSession thisSession = request.getSession();
        ServletContext thisContext = thisSession.getServletContext();

        ThreeDimensionsContainer tdc = (ThreeDimensionsContainer) thisContext.getAttribute("myMenu");
        TwoDimensionMenu twoDContainer = new TwoDimensionMenu();

        ArrayList headers = tdc.getContents();
        ListIterator headersIterator = headers.listIterator();
        ListIterator contentsIterator = null;
        ArrayList contents = null;
        WebBusinessObjectsContainer wboc = null;
        WebBusinessObject wbo = null;

        String status = (String) request.getAttribute("status");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode;

        String saving_status, Dupname;
        String sTitle, title_2;
        String sGroupName, sGroupDesc, sGroupType;
        String cancel_button_label;
        String save_button_label, sPadding, sMenu, sSelect;
        String fStatus;
        String sStatus;
        if (stat.equals("En")) {

            saving_status = "Saving status";
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            Dupname = "Name is Duplicated Chane it";
            sGroupName = "Group Name";
            sGroupDesc = "Group Description";
            sTitle = "New Group";
            title_2 = "All information are needed";
            cancel_button_label = "Cancel";
            save_button_label = "Save";
            langCode = "Ar";
            sPadding = "left";
            sMenu = "Menu";
            sSelect = "Select";
            sStatus = "Group Saved Successfully";
            fStatus = "Fail To Save This Group";
            sGroupType = "Group Type";
        } else {

            saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";

            Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
            sGroupName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
            sGroupDesc = "&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
            sTitle = "&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1580;&#1583;&#1610;&#1583;&#1577;";
            title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
            cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569;";
            save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604;";
            langCode = "En";
            sPadding = "right";
            sMenu = "&#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
            sSelect = "&#1575;&#1582;&#1578;&#1575;&#1585;";
            sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
            fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
            sGroupType = "&#x0627;&#x0644;&#x0645;&#x062C;&#x0645;&#x0648;&#x0639;&#x0647; &#x0627;&#x0644;&#x0625;&#x062F;&#x0627;&#x0631;&#x064A;&#x0647;";
        }
        String doubleName = (String) request.getAttribute("name");
    %>

    <BODY>

        <FORM NAME="GROUP_FORM" METHOD="POST">
            <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
            <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>

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
                <%
                    if (null != doubleName) {
                %>
                <table dir="<%=dir%>" align="<%=align%>" width="400">
                    <tr>
                        <td class="td" style="height:30;">
                    <center>
                        <font size="3" color="red" ><%=Dupname%></font>
                    </center>
                    </td>
                    </tr> </table>
                    <%}%>    
                    <%
                        if (null != status) {
                            if (status.equalsIgnoreCase("ok")) {
                    %>

                <table align="<%=align%>" dir="<%=dir%>">
                    <tr align="<%=align%>">
                        <td class="td" STYLE="<%=align%>"> 
                            <b>
                                <font size=4 >
                                <%=sStatus%>
                                </font>
                            </b>
                        </td>
                    </tr>
                </table>

                <%
                } else {%>
                <table align="<%=align%>" dir="<%=dir%>">
                    <tr align="<%=align%>">
                        <td class="td" STYLE="<%=align%>"> 
                            <b>
                                <font size=4 >
                                <%=fStatus%>
                                </font>
                            </b>
                        </td>
                    </tr>
                </table>
                <% }
                    }
                %>           
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
                            <input type="TEXT" name="groupName" ID="groupName" size="33" value="" maxlength="255" style="width:230px;">
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
                                <option value="admin">Administrator</option>
                                <option value="mgr">Middle Manager</option>
                                <option value="call">Call Center</option>
                                <option value="emp">Employee</option>
                                <option VALUE="qa">Quality Assurance</option>
                                <option VALUE="pm">Project Manager</option>
                                <option VALUE="notification">Notification</option>
                                <OPTION VALUE="monitor">Manager Monitor</option>
                                <OPTION VALUE="sales">Sales and Marketing</option>
                                <OPTION VALUE="secretary">Secretary</option>
                                <OPTION VALUE="units">Units</option>
                                <OPTION VALUE="subDivMonitor">Sub Department Monitor</option>
                                <OPTION VALUE="contracts">Contracts</option>
                                <OPTION VALUE="globalNotifications">Global Notifications</option>
                                <OPTION VALUE="purchase">Purchase</option>
                                <option VALUE="generalTask">General Task</option>
                                <option VALUE="sla">Service Level Agreement</option>
                                <option VALUE="gsla">Global Service Level Agreement</option>
                                <option VALUE="quality">Quality Manager</option>
                                <option VALUE="qualityAssistant">Quality Assistant</option>
                                <option VALUE="siteTechOffice">Site Tech Office</option>
                                <option VALUE="techOfficeRequest">Tech Office Request View</option>
                                <option VALUE="nonDistributed">Non Distributed View</option>
                                <option VALUE="procurement">Procurement</option>
                                <option VALUE="procurementRequests">Procurement Requests</option>
                                <option VALUE="storeTransactions">Store Transactions</option>
                                <option VALUE="generalComplaint">General Complaint Form</option>
                                <option VALUE="CSSecretary">CS Secretary</option>
                                <option VALUE="CHD">Client Help Desk</option>
                                <option VALUE="CHDManager">Client Help Desk Manager</option>
                                <option VALUE="customerJobOrderTrack">Customer Job Order Tracking</option>
                                <option VALUE="jOQualityAssurance">JO Quality Assurance</option>
                                <option VALUE="em">Employee Affairs</option>
                                <option VALUE="contractsNotifications">Contracts Notifications</option>
                                <option VALUE="departmentsContracts">Department's Contracts</option>
                                <option VALUE="clientClassifications">Client Classifications</option>
                                <option VALUE="teamLeader">Team Leader</option>
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
                            <TEXTAREA rows="5" name="groupDesc" cols="25" style="width:230px;"></TEXTAREA>
                        </TD>
                    </TR>
                </TABLE>
                <BR>
                <TABLE id="group" WIDTH="600"  CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" ALIGN="CENTER" DIR="<%=dir%>">
                    <TR CLASS="head" STYLE="background:#005599;">
                        <TD CLASS="firstname"  STYLE="border-top-WIDTH:0; color:white;font-size:12">
                            <%=sMenu%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;color:white;" WIDTH="33">
                            <B>
                                &nbsp;<%=sSelect%>&nbsp;
                            </B>
                        </TD>
                    </TR>
                    <%
                        ThreeDimensionMenu tdm = (ThreeDimensionMenu) c.getAttribute("myMenu");
                    %>
                    <%=stat.equalsIgnoreCase("Ar") ? tdm.getMenuGroupString() : tdm.getMenuEnGroupString()%>
                    <input type="hidden" name="totalMainMenu" id="totalMainMenu" value="<%=i%>">
                    <input type="hidden" name="total" id="total" value="<%=iTotal%>">
                    <input type="hidden" name="url" id="url" value="">
                </TABLE>
                <BR><BR>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
