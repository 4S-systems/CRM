<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.maintenance.common.ConfigFileMgr" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        Vector<WebBusinessObject> departments = (Vector<WebBusinessObject>) request.getAttribute("departments");
        Vector<WebBusinessObject> channels = (Vector<WebBusinessObject>) request.getAttribute("channels");

        String status = (String) request.getAttribute("status");
        String action = (String) request.getAttribute("action");
        String departmentName = (String) request.getAttribute("departmentName");

        String stat = (String) request.getSession().getAttribute("currentMode");

        String channelId = request.getParameter("channelId");
        List<String> channelsUsersIds = new ArrayList();
        List<String> departmentNames = new ArrayList();
        String channelName = "";
        if (channelId != null) {
            channelsUsersIds = (List<String>) request.getAttribute("channelsUsersIds");
            departmentNames = (List<String>) request.getAttribute("departmentNames");
            channelName = (String) request.getAttribute("channelName");
        }

        String dir, title;
        String align = "center";
        String fStatus;
        String sStatus;
        String save, cancel, newForm;
        if (stat.equals("En")) {
            dir = "LTR";
            title = "New / Edit Channel";
            sStatus = "Save Successfully";
            fStatus = "Fail To Save";
            save = "Save Channel";
            cancel = "Cancel";
            newForm = "New Channel";
        } else {
            dir = "RTL";
            title = "تعريف / تعديل قناة";
            newForm = "تعريف قناة جديدة";
            fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
            sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
            save = "حفظ";
            cancel = "الغاء";
        }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>Doc Viewer- Attach Employees</TITLE>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="js/silkworm_validate.js"></script>
        <link rel="stylesheet" type="text/css" href="css/CSS.css" />
        <link rel="stylesheet" type="text/css" href="css/Button.css" />
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <link rel="stylesheet" type="text/css" href="css/hierarchy_tree.css" />
        <script type="text/javascript" src="js/validator.js"></script>

        <script type="text/javascript">
            document.addEventListener('DOMContentLoaded', function() {
                getChecked();
            }, false);

            function submitForm() {

                if (!validateData("req", this.CHANNEL_FORM.channelName, "Please, Enter Channel Name ...")) {
                    this.CHANNEL_FORM.channelName.focus();
                } else {
                    var userSeletelAtLeastOne = false;

                    var department = null;
                    var totalSubMainMenu = document.getElementById('checkall').value;

                    for (i = 0; i < totalSubMainMenu; i++) {
                        department = document.getElementById('department' + i);
                        if (department.checked == true) {
                            userSeletelAtLeastOne = true;
                            break;
                        }
                    }

                    if (userSeletelAtLeastOne) {
                        var url = "<%=context%>/ChannelsServlet?op=saveOrUpdateChannel";
                        if ('<%=action%>' != "add") {
                            url += "&channelId=<%=channelId%>"
                        }
                        document.CHANNEL_FORM.action = url;
                        document.CHANNEL_FORM.submit();
                    } else {
                        alert("من فضلك اختر الادارات");
                    }
                }
            }

            function newForm() {
                var url = "<%=context%>/ChannelsServlet?op=getChannelChannel";
                document.CHANNEL_FORM.action = url;
                document.CHANNEL_FORM.submit();
            }

            function updateChannel(id) {
                var url = "<%=context%>/ChannelsServlet?op=getChannelChannel&channelId=" + id;
                document.CHANNEL_FORM.action = url;
                document.CHANNEL_FORM.submit();
            }

            function checkAll(object) {
                var checked;
                if (object.checked == true) {
                    checked = true;
                } else {
                    checked = false;
                }

                var totalSubMainMenu = object.value;
                for (i = 0; i < totalSubMainMenu; i++) {
                    document.getElementById('department' + i).checked = checked;
                }
                if (checked) {
                    addAll();
                } else {
                    removeAll();
                }
            }

            function getChecked() {
                var checkedOffsprings = true;

                var department = null;
                var totalSubMainMenu = document.getElementById('checkall').value;

                for (i = 0; i < totalSubMainMenu; i++) {
                    department = document.getElementById('department' + i);
                    if (department.checked == false) {
                        checkedOffsprings = false;
                        break;
                    }
                }

                document.getElementById('checkall').checked = checkedOffsprings;
            }

            function makeChecked(i, id, title) {
                if (document.getElementById('department' + i).checked == true) {
                    document.getElementById('department' + i).checked = false;
                    removeChildren(id);
                } else {
                    document.getElementById('department' + i).checked = true;
                    addChildren(id, title);
                }
                getChecked();
            }

            function checkChannelName() {
                var channelName = $("#channelName").val();

                if (channelName.length > 0) {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ChannelsServlet?op=checkChannelName",
                        data: {
                            channelId: <%=channelId%>,
                            channelName: channelName,
                            action: '<%=action%>'
                        },
                        success: function(jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status == 'no') {
                                $("#nameMSG").css("color", "green");
                                $("#nameMSG").css(" text-align", "left");
                                $("#nameMSG").css("font-size", "18px");
                                $("#nameMSG").text(" متاح")
                                $("#nameMSG").removeClass("error");
                                $("#nameWarning").css("display", "none");
                                $("#nameOk").css("display", "inline")
                            } else if (info.status == 'ok') {
                                $("#nameMSG").css("color", "red");
                                $("#nameMSG").css("font-size", "18px");
                                $("#nameMSG").text(" محجوز");
                                $("#nameMSG").addClass("error");
                                $("#nameWarning").css("display", "inline")
                                $("#nameOk").css("display", "none");

                            }
                        }
                    });
                } else {
                    $("#nameMSG").text("");
                    $("#nameWarning").css("display", "none");
                    $("#nameOk").css("display", "none");
                }
            }

            function addAll() {
                var projectName = document.getElementsByName("projectName");
                var users = document.getElementsByName("users");

                for (i = 0; i < users.length; i++) {
                    addChildren(users[i].value, projectName[i].value);
                }
            }

            function removeAll() {
                var users = document.getElementsByName("users");

                for (i = 0; i < users.length; i++) {
                    removeChildren(users[i].value);
                }
            }

            function addChildren(id, title) {
                if (document.getElementById(id) == null) {
                    var ul = document.getElementById("children");
                    var li = document.createElement("li");
                    var a = document.createElement("a");
                    a.appendChild(document.createTextNode(title));
                    li.appendChild(a);
                    li.setAttribute("id", id);
                    ul.appendChild(li);
                }
            }

            function removeChildren(id) {
                var ul = document.getElementById("children");
                var li = document.getElementById(id);
                ul.removeChild(li);
            }
        </script>

        <style type="text/css">

            .selectedRow {
                background: #FFFFFF;
            }
            .remove{

                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);

            }
            #showHide{
                /*background: #0066cc;*/
                border: none;
                padding: 10px;
                font-size: 16px;
                font-weight: bold;
                color: #0066cc;
                cursor: pointer;
                padding: 5px;
            }
            #dropDown{
                position: relative;
            }
            .backStyle{
                border-bottom-width:0px;
                border-left-width:0px;
                border-right-width:0px;
                border-top-width:0px
            }

            .datepick {}

            .save {
                width:20px;
                height:20px;
                background-image:url(images/icons/icon-32-publish.png);
                background-repeat: no-repeat;
                cursor: pointer;
            }
            .silver_odd_main,.silver_even_main {
                text-align: center;
            }

            input { font-size: 18px; }

            .titlebar {
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

        </style>
    </HEAD>

    <BODY STYLE="">
        <FORM NAME="CHANNEL_FORM" METHOD="POST">
            <input type="hidden" id="action" name="action" value="<%=action%>" />
            <DIV align="left" STYLE="color:blue;padding-left: 7.3%; padding-bottom: 10px">
                <button onclick="cancelForm()" class="button"><%=cancel%></button>
                &ensp;
                <input type="button" onclick="JavaScript:newForm();" value="<%=newForm%>" class="button"/>
                &ensp;
                <input type="button" onclick="JavaScript:submitForm();" value="<%=save%>" class="button" />
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="width:90%;border-color: #006699" >
                    <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td width="100%" class="titlebar">
                                <font color="#005599" size="4"><%=title%></font>
                            </td>
                        </tr>
                    </table>
                    <br/>
                    <table align="<%=align%>" dir="<%=dir%>">
                        <% if (null != status && status.equalsIgnoreCase("ok")) {%>  
                        <tr>
                        <table width="90%" align="<%=align%>" dir=<%=dir%>>
                            <tr class="backgroundHeader">
                                <td class="td" style="text-align: center">
                                    <font size=4 color="black"><%=sStatus%></font>
                                </td>
                            </tr> 
                        </table>
                        </tr>
                        <% } else if (null != status && status.equalsIgnoreCase("no")) {%>
                        <tr>
                        <table width="90%" class="backgroundHeader" align="<%=align%>" dir=<%=dir%>>
                            <tr>
                                <td class="td" style="text-align: center">
                                    <font size=4 color="red" ><%=fStatus%></font>
                                </td>
                            </tr> 
                        </table>
                        </tr>
                        <% }%>
                    </table>
                    <center>
                        <DIV id="tblDataDiv" align="center" style="display: block">
                            <TABLE WIDTH="95%" ALIGN="center" DIR="<%=dir%>">
                                <TR>
                                    <td class="td">
                                        <TABLE class="backgroundTable" width="100%" CELLPADDING="0" CELLSPACING="8" ALIGN="CENTER" DIR="<%=dir%>" style="vertical-align: top">
                                            <TR>
                                                <TD class="backgroundHeader" width="35%">
                                                    <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold">اسم القناة: </b>
                                                </TD>
                                                <TD style="border-width: 0px" width="55%">
                                                    <input type="TEXT" name="name" ID="channelName" size="33"onmouseout="checkChannelName()" onblur="checkChannelName()" value="<%=channelName%>" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                                                </TD>
                                                <TD style="border-width: 0px" width="5%">
                                                    <img id="nameWarning" src="images/cancel_white.png" alt="images/cancel_white.png" align="middle" style="display: none"/>
                                                    <img id="nameOk" src="images/ok_white.png" alt="images/ok_white.png" align="middle" style="display: none"/>
                                                </TD>
                                                <TD style="border-width: 0px" width="5%">
                                                    <p id="nameMSG"></p>
                                                </TD>
                                            </TR>
                                        </TABLE>
                                        <br />
                                        <TABLE id="tblData" class="blueBorder" ALIGN="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0" style="vertical-align: top">
                                            <TR>
                                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="5%"><b><INPUT TYPE="CHECKBOX" NAME="" value ="<%=departments.size()%>" ID="checkall" onclick="checkAll(this);"></b></TD>
                                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="45%" ><b>اسم الأدارة</b></TD>
                                                <TD CLASS="silver_header" STYLE="text-align:center;color:black;font-size:14px;font-weight: bold" nowrap width="50%" id="empNameShown" value=""><b>اسم المدير</b></TD>
                                            </TR>
                                            <%
                                                WebBusinessObject department;
                                                String rowStyle;
                                                for (int i = 0; i < departments.size(); i++) {
                                                    department = departments.get(i);
                                                    rowStyle = "silver_odd";
                                                    if (i % 2 == 0) {
                                                        rowStyle = "silver_even";
                                                    }
                                            %>
                                            <TR class="silver_even" onclick="makeChecked('<%=i%>', '<%=department.getAttribute("userId")%>', '<%=department.getAttribute("projectName")%>')" style="cursor: pointer" onmousemove="this.className = 'selectedRow'" onmouseout="this.className = '<%=rowStyle%>'">
                                                <TD CLASS="" STYLE="text-align:center;color:black;font-size:12px;font-weight: bold" nowrap width="5%">
                                                    <b><INPUT TYPE="CHECKBOX" NAME="departments" value ="<%=i%>" ID="department<%=i%>" onclick="getChecked();" <%if (channelsUsersIds.contains((String) department.getAttribute("userId"))) { %>checked<% }%> /></b>
                                                    <INPUT type="hidden" name="users" value="<%=department.getAttribute("userId")%>" />
                                                    <INPUT type="hidden" name="projectName" value="<%=department.getAttribute("projectName")%>" />
                                                </TD>
                                                <TD CLASS="" STYLE="text-align:right;color:black;font-size:12px;font-weight: bold" nowrap width="45%" ><b><%=department.getAttribute("projectName")%></b></TD>
                                                <TD CLASS="" STYLE="text-align:right;color:black;font-size:12px;font-weight: bold" nowrap width="50%" id="" value=""><b><%=department.getAttribute("userName")%></b></TD>
                                            </TR>
                                            <% } %>
                                        </TABLE>
                                        <br />
                                        <TABLE  WIDTH="100%"  CELLPADDING="0" CELLSPACING="0" STYLE="border-right-width:1px;">
                                            <TR CLASS="head" STYLE="background:#9B9B00;">
                                                <TD CLASS="silver_header"  STYLE="font-size:14px;">
                                                    القنوات الحاليه
                                                </TD>
                                            </TR>
                                            <%
                                                WebBusinessObject channel;
                                                rowStyle = "silver_odd";
                                                for (int i = 0; i < channels.size(); i++) {
                                                    channel = channels.get(i);
                                                    rowStyle = "silver_odd";
                                                    if (i % 2 == 0) {
                                                        rowStyle = "silver_even";
                                                    }
                                            %>
                                            <TR CLASS="<%=rowStyle%>" onclick="updateChannel(<%=(String) channel.getAttribute("id")%>)" style="cursor: pointer" onmousemove="this.className = 'selectedRow'" onmouseout="this.className = '<%=rowStyle%>'">
                                                <TD STYLE="text-align:right;color:black;font-size:12px;font-weight: bold" nowrap width="50%" id="" value=""><b><%=channel.getAttribute("name")%></b></TD>
                                            </TR>
                                            <% } %>
                                            <% if (channels != null && channels.isEmpty()) {%>
                                            <TR>
                                                <TD STYLE="text-align:center;color:black;font-size:12px;font-weight: bold" nowrap width="50%" id="" value=""><font color="red"><b>لاتوجد قنوات معرفة</b></font></TD>
                                            </TR>
                                            <% }%>
                                        </TABLE>
                                    </td> 
                                    <TD  WIDTH="20%" style="vertical-align:top;" nowrap class="td">
                                        <TABLE  WIDTH="200" HIEGHT="100%"  CELLPADDING="0" CELLSPACING="0" STYLE="border-right-width:1px;">
                                            <TR>
                                                <TD STYLE="text-align:center;color:black;font-size:12px;font-weight: bold" nowrap width="50%" id="" value="">
                                                    <img src="images/Employee-network.jpg"/>
                                                </TD>
                                            </TR>
                                        </TABLE>
                                        <BR />
                                    </TD>
                                </TR>
                                <TR>
                                    <td class="td" colspan="2">
                                        <div class="tree" style="width: 100%; vertical-align: middle">
                                            <ul>
                                                <li>
                                                    <a href="#"><%=departmentName%></a>
                                                    <ul id="children">
                                                        <%
                                                            String[] data;
                                                            String t, id;
                                                            for (int i = 0; i < departmentNames.size(); i++) {
                                                                t = departmentNames.get(i);
                                                                id = channelsUsersIds.get(i);
                                                        %>
                                                        <li id="<%=id%>">
                                                            <a href="#"><%=t%></a>
                                                        </li>
                                                        <% }%>
                                                    </ul>
                                                </li>
                                            </ul>
                                        </div>
                                    </td>
                                </TR>
                            </TABLE>
                        </DIV>
                    </center>
                    <br />
                    <br />
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>
