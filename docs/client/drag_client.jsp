<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>


<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        String status = (String) request.getAttribute("status");
        String searchBy = (String) request.getAttribute("searchBy");
        if (searchBy == null) {
            searchBy = "unitNo";
        }

        List<WebBusinessObject> data = (List<WebBusinessObject>) request.getAttribute("data");
        List<WebBusinessObject> employees = (List<WebBusinessObject>) request.getAttribute("employees");
        ArrayList<WebBusinessObject> requestTypes = (ArrayList<WebBusinessObject>) request.getAttribute("requestTypes");
        for (int i = requestTypes.size() - 1; i >= 0; i--) {
            if ("0".equals(requestTypes.get(i).getAttribute("mainProjId"))) {
                requestTypes.remove(i);
                break;
            }
        }

        String dir = null;
        String style = null;
        String sTitle;
        String complaintNo, customerName;

        if (stat.equals("En")) {
            dir = "LTR";
            style = "text-align:left";
            sTitle = "Withdrawal and Distribution";
            complaintNo = "Order No.";
            customerName = "Customer name";
        } else {
            dir = "RTL";
            style = "text-align:Right";
            sTitle = "سحب عميل";
            complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
            customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="//code.jquery.com/jquery-1.10.2.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jshaker.js"></script>

        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">


        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>

        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>

        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        <script type="text/javascript">

            var oTable;
            var users = new Array();
            $(document).ready(function () {
                $("#clients").css("display", "none");
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);

            });

            $(function () {
                $("input[name=search]").change(function () {
                    var value = $("input[name=search]:checked").attr("id");
                    if (value == 'parentName') {
                        $("#searchValue").val("");
                        $("#searchValue").attr("placeholder", "اسم المشروع");
                        $("#msgT").html("");
                        $("#msgM").html("");
                        $("#msgNo").html("");
                        $("#info").html("");
                        $("#msgNa").html("");

                        $("#searchValue").css("border", "");
                        $("#showClients").css("display", "none");
                    } else if (value == 'unitNo') {
                        $("#searchValue").val("");
                        $("#searchValue").attr("placeholder", "كود الوحده");
                        $("#msgT").html("");
                        $("#msgM").html("");
                        $("#msgNo").html("");
                        $("#msgNa").html("");
                        $("#info").html("");
                        $("#searchValue").css("border", "");
                        $("#showClients").css("display", "none");
                    }
                })

            })
            function clearAlert() {

                $("#msgT").html("");
                $("#msgM").html("");
                $("#msgNo").html("");
                $("#info").html("");
                $("#msgNa").html("");
                $("#searchValue").css("border", "");
                $("#showClients").css("display", "none");
            }
            function getClientInfo2(obj) {
                var searchByValue = '';
                var value = $(obj).parent().parent().parent().parent().find("input[name=search]:checked").attr("id");
                $("#info").html("");
                if ($(obj).parent().find("#searchValue").val().length > 0) {
                    if (value == 'unitNo') {
                        searchByValue = $(obj).parent().parent().find("#searchValue").val();
                    } else {
                        searchByValue = $(obj).parent().parent().find("#searchValue").val();
                    }
                    document.CLIENT_FORM.action = "<%=context%>/DatabaseControllerServlet?op=dragClientForm&searchBy=" + value + "&searchByValue=" + searchByValue;
                    document.CLIENT_FORM.submit();
                    $("#clients").css("display", "");
                    $("#showClients").val("show");
                }
            }

            function deleteTask(issueId) {
                var r = confirm("Are You Sure You want to delete task and all its data.");

                if (r === true)
                {
                    document.CLIENT_FORM.action = "<%=context%>/DatabaseControllerServlet?op=dragClient&issueId=" + issueId + "&searchValue=" + $('#searchValue').val();
                    document.CLIENT_FORM.submit();
                }
            }
            function deleteRedirectTask() {
                if ($("#requestType").val() === '') {
                    alert("You must select a request type to create new request");
                    return;
                }
                if ($("#employeeID").val() === '') {
                    alert("You must select an employee to distrubite new request to it");
                    return;
                }
                var r = confirm("Are You Sure You want to delete task and all its data.");
                if (r === true) {
                    document.CLIENT_FORM.action = "<%=context%>/DatabaseControllerServlet?op=dragClient&issueId=" + $("#issueId").val() + "&employeeID=" + $("#employeeID").val()
                            + "&requestType=" + $("#requestType").val() + "&searchValue=" + $('#searchValue').val();
                    document.CLIENT_FORM.submit();
                }
            }
            function showRedirectTask(issueId) {
                $("#issueId").val(issueId);
                $('#redirectClient').show();
                $('#redirectClient').bPopup({easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }
            function closePopup(obj) {
                $(obj).parent().parent().bPopup().close();
                $(obj).parent().parent().hide();
            }
        </script>
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
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
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
        </style>
    </HEAD>
    <BODY>
        <FORM NAME="CLIENT_FORM" METHOD="POST">
            <div style="margin-left: auto;margin-right: auto;width: 96%" class="set">
                <div style="display:none;width: 310px;margin-top: 10px;margin-left: auto;margin-right: auto;height: 20px;background-color: #f3f3f5;" id="errorMsg">
                    <FONT style="color: red;font-size: 16px;"><b>يجب أولا إختيار عميل</B></font>
                </div>
                <BR>
                <div style="width: 100%;">
                    <FIELDSET class="set" style="width:85%;border-color: #006699" >
                        <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                            <tr>
                                <td width="100%" class="titlebar">
                                    <font color="#005599" size="4"><%=sTitle%></font>
                                </td>
                            </tr>
                        </table>
                        <br />
                        <% if (status != null) {%>
                        <br>
                        <table align="center" dir="<%=dir%>" WIDTH="70%">
                            <tr>
                                <td class="backgroundHeader">
                                    <% if (status.equalsIgnoreCase("fail")) {%>
                                    <font size="3" color="red">Withdrawal Not Success</font>
                                    <% } else { %>
                                    <font size="3" color="blue">Withdrawal Success</font>
                                    <script>
                                        setTimeout(function () {
                                            window.location.href = 'main.jsp';
                                        }, 2000);
                                    </script>
                                    <% } %>
                                </td>
                            </tr>
                        </table>
                        <%}%>
                        <br />
                        <!--TABLE ALIGN="center" DIR="<1%=dir%>" width="95%" CELLPADDING="0" CELLSPACING="0" BORDER="0" style="margin-right: auto;margin-left: auto;">
                            <TR>
                                <TD style="border-left-width: 0px" bgcolor="#dedede" width="50%">
                                    <TABLE WIDTH="100%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER">
                                        <tr>
                                            <td STYLE="<1%=style%>" class='td'>
                                                <LABEL style="font-size: 20px;">بحث بـــ : </LABEL>
                                                <span><input type="radio" name="search" value="unitNo" id="unitNo" <1%=searchBy.equalsIgnoreCase("unitNo") ? "checked" : ""%>  />  <font size="2"  color="#000"><b>كود الطلب </b></font></span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td STYLE="<1%=style%>" class='td'></td></tr>
                                        <tr>
                                            <td STYLE="<1%=style%>" class='td'>
                                                <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto" id="te">
                                                    <input type="button" value="بحث" style="display: inline" class="" width="150px" onclick="getClientInfo2(this)"/>
                                                    <input type="text" name="searchValue" id="searchValue" placeholder="كود الطلب" onkeyup="clearAlert()" onkeypress="clearAlert()"onblur="getClientInfo2(this)"/>
                                                </div>
                                            </td>
                                        </tr>
                                    </TABLE>
                                </TD>
                                <TD style="border-right-width: 0px" bgcolor="#dedede" align="right" width="50%">
                                    <img src="images/client.png" width="190" style="border: none; vertical-align: middle;" />
                                </TD>
                            </TR>
                        </TABLE-->
                        <br />
                        <% if (data != null && !data.isEmpty()) {%>
                        <br />
                        <div style="width: 95%;">
                            <table id="clients" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0" style="display: none;">
                                <thead>
                                    <tr>
                                        <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%"><span><b>#</b></span></th>
                                        <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><span><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></span></th>
                                        <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="40%"><span><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></span></th>
                                        <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="30%"><b>Creation Time</b></th>
                                        <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="15%">&nbsp;</th>
                                        <th CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="15%">&nbsp;</th>
                                    </tr>
                                </thead> 
                                <tbody id="planetData2">  
                                    <%
                                        int counter = 0;
                                        String compStyle = "";
                                        for (WebBusinessObject wbo : data) {
                                            counter++;
                                    %>
                                    <tr style="padding: 1px;">
                                        <td>
                                            <div>
                                                <b> <%=counter%> </b>
                                            </div>
                                        </td>
                                        <td onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''">
                                            <%if (wbo.getAttribute("id") != null) {%>
                                            <a href="<%=context%>/IssueServlet?op=getCompUnderIssue&issueId=<%=wbo.getAttribute("id")%>"><font color="red"><%=wbo.getAttribute("businessID")%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate")%></font></a>
                                                <%} %>
                                        </td>
                                        <td>
                                            <%if (wbo.getAttribute("clientName") != null) {%>
                                            <b><%=wbo.getAttribute("clientName")%></b>
                                            <%}%>
                                        </td>
                                        <%
                                            WebBusinessObject formattedTime = DateAndTimeControl.getFormattedDateTime((String) wbo.getAttribute("creationTime"), stat);
                                        %>
                                        <TD nowrap  ><font color="red"><%=formattedTime.getAttribute("day")%> - </font><b><%=formattedTime.getAttribute("time")%></b></TD>
                                        <td>
                                            <a href="JavaScript: deleteTask('<%=wbo.getAttribute("id")%>');"><b>Withdrawal</b></a>
                                        </td>
                                        <td>
                                            <a href="JavaScript: showRedirectTask('<%=wbo.getAttribute("id")%>');"><b>Withdrawal and Distribution</b></a>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                            <br />
                            <br />
                        </div>
                        <% }%>
                    </FIELDSET>
                    <br />
                </div>
            </DIV>
        </FORM>
        <div id="redirectClient" style="width: 30% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 500px;">
            <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 100px;
                     -moz-border-radius: 100px;
                     border-radius: 100px;" onclick="closePopup(this)"/>
            </div>
            <div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
                <table  border="0px"  style="width:100%;"  class="table">
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">Type Request</td>
                        <td style="width: 70%;">
                            <select name="requestType" id="requestType" style="width: 200px;">
                                <option value="">choose</option>
                                <sw:WBOOptionList wboList="<%=requestTypes%>" displayAttribute="projectName" valueAttribute="projectName" />
                            </select>
                        </td>
                    </tr> 
                    <tr>
                        <td style="color:#f1f1f1;   font-size: 16px;font-weight: bold;width: 30%;">Sales</td>
                        <td style="width: 70%;">
                            <select name="employeeID" id="employeeID" style="width: 200px;">
                                <option value="">choose</option>
                                <sw:WBOOptionList wboList="<%=employees%>" displayAttribute="fullName" valueAttribute="userId" />
                            </select>
                            <input type="hidden" name="issueId" id="issueId" />
                        </td>
                    </tr> 
                </table>
                <div style="text-align: center;margin-left: auto;margin-right: auto;clear: both" > <input type="button" value="سحب وتوزيع" onclick="JavaScript: deleteRedirectTask();" id="redirectClient" class="login-submit"/></div>
            </div>
        </div>
    </BODY>
</HTML>     
