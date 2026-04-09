<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.crm.db_access.EmployeesLoadsMgr"%>
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
        ArrayList<WebBusinessObject> projectList = (ArrayList<WebBusinessObject>) request.getAttribute("projectList");
        WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
        String align, dir, style = null;
        String sTitle, num, projectTitle;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            sTitle = "Call Center Integration";
            num = "Phone\\Mobile Number";
            projectTitle = "Project";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            sTitle = "Call Center Integration";
            num = "رقم التليفون/الموبايل";
            projectTitle = "المشروع";
        }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE></TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
    </HEAD>
    <script type="text/javascript">
        function getClientInfo(obj) {
            $("#info").html("");
            var num = $("#num").val();
            var projectID = $("#projectID").val();
            if (num.length > 7 && IsNumeric(num)) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientByNumAjax",
                    data: {
                        num: num,
                        projectID: projectID
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'ok') {
                            $("#status").val("ok");
                            $("#info").html("");
                            $("#clientNO").val(info.clientNO);
                            $("#name").val(info.name);
                            $("#phone").val(info.phone);
                            $("#mobile").val(info.mobile);
                            window.location.hash = '&phone=' + info.phone + '&userId=' + info.userId;
                        } else if (info.status == 'fail') {
                            $("#info").html("لا يوجد عميل لهذا الرقم أو رقم خطأ");
                            window.location.hash = '#';
                        }
                    }
                });
            } else {
                $("#info").html("أدخل رقم تليفون أو موبايل صحيح");
                $("#num").focus();
                $("#num").css("border", "1px solid red");
            }
        }
        function IsNumeric(sText) {
            var ValidChars = "0123456789.";
            var IsNumber = true;
            var Char;
            for (i = 0; i < sText.length && IsNumber == true; i++)
            {
                Char = sText.charAt(i);
                if (ValidChars.indexOf(Char) == -1)
                {
                    return false;
                }
            }
            return IsNumber;
        }
    </script>
    <style>
        .titleTD {
            text-align:center;
            font-weight: bold;
            font-size: 16px;
            color: black;
            background-color:#b9d2ef;
        }
        .dataTD {
            text-align:right;
            border: none;
            font-weight: bold;
            font-size: 16px;
            color: black;
        }
        tr:nth-child(even) td.dataTD {background: #FFF}
        tr:nth-child(odd) td.dataTD {background: #f1f1f1}
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
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM NAME="CLIENT_FORM" METHOD="POST">
            <div style="margin-left: auto;margin-right: auto;width: 96%" class="set">
                <div style="width: 100%;">
                    <fieldset class="set" align="center" width="100%" style="width: 70%;margin-bottom: 10px;">
                        <legend align="center">
                            <table dir="<%=dir%>" align="center">
                                <tr>
                                    <td class="td">
                                        <font color="blue" size="6">
                                        <%=sTitle%>
                                        </font>
                                    </td>
                                </tr>
                            </table>
                        </legend>
                        <%
                            if (clientWbo == null) {
                        %>
                        <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%">
                            <tr>
                                <td class='td'>
                                    <TABLE ALIGN="center" DIR="<%=dir%>"  CELLPADDING="0" CELLSPACING="0" BORDER="0" style="margin-right: auto;margin-left: auto;">
                                        <tr>
                                            <td colspan="2" STYLE="<%=style%>" class='td'>
                                                <div style="text-align: center;width: 96%;margin-left: auto;margin-right: auto">
                                                    <LABEL id="info" style="color: green;">لا يوجد عميل لهذا الرقم أو رقم خطأ</LABEL>
                                                </div>
                                            </td>
                                        </tr>
                                    </TABLE>
                                </td>
                            </tr>
                        </table>
                        <%
                        } else {
                        %>
                        <div style="width: 85%;margin-right: auto;margin-left: auto; direction: rtl;" id="clientDetails">
                            <table style="width: 100%;">
                                <tr>
                                    <td class="td titleTD">
                                        رقم العميل
                                    </td>
                                    <td class="td dataTD" colspan="3">
                                        <b><%=clientWbo.getAttribute("clientNO")%></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="td titleTD">
                                        اسم العميل
                                    </td>
                                    <td class="td dataTD">
                                        <b><%=clientWbo.getAttribute("name")%></b>
                                        <input type="hidden" id="clientId" name="clientId" value="<%=clientWbo.getAttribute("id")%>"/>
                                    </td>
                                    <td class="td titleTD">
                                        رقم التليفون
                                    </td>
                                    <td class="td dataTD">
                                        <b><%=clientWbo.getAttribute("phone")%></b>
                                    </td>
                                </tr>

                                <tr>
                                    <td class="td titleTD" nowrap>
                                        اسم الزوجة/الزوج
                                    </td>
                                    <td class="td dataTD">
                                        <b><%=clientWbo.getAttribute("partner")%></b>
                                    </td>
                                    <td class="td titleTD">
                                        رقم الموبايل
                                    </td>
                                    <td class="td dataTD">
                                        <b><%=clientWbo.getAttribute("mobile")%></b>
                                    </td>
                                </tr>
                                <TR>
                                    <td class="td titleTD">
                                        الرقم الطالب
                                    </td>
                                    <td class="td dataTD">
                                        <b><%=clientWbo.getAttribute("option3") != null && !((String) clientWbo.getAttribute("option3")).equalsIgnoreCase("ON") ? clientWbo.getAttribute("option3") : ""%></b>
                                    </td>
                                    <td class="td titleTD">
                                        العنوان
                                    </td>
                                    <td class="td dataTD">
                                        <b><%=clientWbo.getAttribute("address")%></b>
                                    </td>
                                </TR>
                                <TR>
                                    <td class="td titleTD" nowrap>
                                        البريد الإلكترونى
                                    </td>
                                    <td class="td dataTD">
                                        <b><%=clientWbo.getAttribute("email")%></b>
                                    </td>
                                    <td class="td titleTD">
                                        ر.قومى / ج. سفر
                                    </td>
                                    <td class="td dataTD">
                                        <b><%=clientWbo.getAttribute("clientSsn")%></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="td titleTD">
                                        ملاحظات
                                    </td>
                                    <td class="td dataTD" colspan="3">
                                        <b><%=clientWbo.getAttribute("description") != null ? clientWbo.getAttribute("description") : ""%></b>
                                    </td>
                                </tr>
                            </table>
                        </div>
                        <%
                            }
                        %>
                        <br/>
                    </FIELDSET>
                </div>
            </div>
        </FORM>
    </BODY>
</HTML>     