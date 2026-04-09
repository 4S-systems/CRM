<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<html>
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

        String dir = null;
        String style = null;
        String sTitle;
        String complaintNo, customerName;

        if (stat.equals("En")) {
            dir = "LTR";
            style = "text-align:left";
            sTitle = "Delete Request";
            complaintNo = "Order No.";
            customerName = "Customer name";
        } else {
            dir = "RTL";
            style = "text-align:Right";
            sTitle = "حذف طلب تسليم";
            complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
            customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
        }
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>

        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>

        <script type="text/javascript" src="//code.jquery.com/jquery-1.10.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jshaker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
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
                    document.CLIENT_FORM.action = "<%=context%>/DatabaseControllerServlet?op=deleteRequestForm&searchBy=" + value + "&searchByValue=" + searchByValue;
                    document.CLIENT_FORM.submit();
                }
            }

            function deleteTask(issueId) {
                var r = confirm("سيتم حذف طلب التسليم؟");
                if (r === true)
                {
                    document.CLIENT_FORM.action = "<%=context%>/DatabaseControllerServlet?op=deleteRequest&issueId=" + issueId + "&searchValue=" + document.getElementById('searchValue');
                    document.CLIENT_FORM.submit();
                }
            }
        </script>
    </head>
    <body>
        <form NAME="CLIENT_FORM" METHOD="POST">
            <div style="margin-left: auto;margin-right: auto;width: 96%" class="set">
                <div style="display:none;width: 310px;margin-top: 10px;margin-left: auto;margin-right: auto;height: 20px;background-color: #f3f3f5;" id="errorMsg">
                    <font style="color: red;font-size: 16px;"><b>يجب أولا إختيار عميل</B></font>
                </div>
                <br/>
                <div style="width: 100%;">
                    <fieldset class="set" style="width:85%;border-color: #006699" >
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
                                    <font size="3" color="red">لم يتم الحذف</font>
                                    <% } else { %>
                                    <font size="3" color="blue">تم الحذف بنجاح</font>
                                    <% } %>
                                </td>
                            </tr>
                        </table>
                        <%}%>
                        <br />
                        <table align="center" dir="<%=dir%>" width="95%" cellpadding="0" cellspacing="0" border="0" style="margin-right: auto;margin-left: auto;">
                            <tr>
                                <td style="border-left-width: 0px" bgcolor="#dedede" width="50%">
                                    <table width="100%" cellpading="0" cellspacing="0" align="center">
                                        <tr>
                                            <td style="<%=style%>" class='td'>
                                                <label style="font-size: 20px;">بحث بـــ : </label>
                                                <span><input type="radio" name="search" value="unitNo" id="unitNo" <%=searchBy.equalsIgnoreCase("unitNo") ? "checked" : ""%>  />  <font size="2"  color="#000"><b>كود الطلب </b></font></span>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="<%=style%>" class='td'></td></tr>
                                        <tr>
                                            <td style="<%=style%>" class='td'>
                                                <div style="text-align: center;width: 100%;margin-left: auto;margin-right: auto" id="te">
                                                    <input type="button" value="بحث" style="display: inline" class="" width="150px" onclick="getClientInfo2(this)"/>
                                                    <input type="text" name="searchValue" id="searchValue" placeholder="كود الطلب" onblur="getClientInfo2(this)"/>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td style="border-right-width: 0px" bgcolor="#dedede" align="right" width="50%">
                                    <img src="images/client.png" width="190" style="border: none; vertical-align: middle;" />
                                </td>
                            </tr>
                        </table>
                        <br />
                        <% if (data != null && !data.isEmpty()) {%>
                        <br />
                        <div style="width: 95%;">
                            <table id="clients" align="center" dir="<%=dir%>" width="100%" cellpadding="0" cellspacing="0" style="display: none;">
                                <thead>
                                    <tr>
                                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="5%"><span><b>#</b></span></th>
                                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="10%"><span><img src="images/icons/Numbers.png" width="20" height="20" /><b> <%=complaintNo%></b></span></th>
                                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="40%"><span><img src="images/icons/client.png" width="20" height="20" /><b> <%=customerName%></b></span></th>
                                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="30%"><b>تاريخ اﻷدخال</b></th>
                                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold; height: 25px" width="15%">&nbsp;</th>
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
                                        <td nowrap  ><font color="red"><%=formattedTime.getAttribute("day")%> - </font><b><%=formattedTime.getAttribute("time")%></b></td>
                                        <td>
                                            <a href="JavaScript: deleteTask('<%=wbo.getAttribute("id")%>');"><b>حــــــذف</b></a>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                            <br />
                            <br />
                        </div>
                        <% }%>
                    </fieldset>
                    <br />
                </div>
            </div>
        </form>
    </body>
</html>     
