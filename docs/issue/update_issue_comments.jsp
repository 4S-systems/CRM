<%@page import="com.maintenance.common.UserClosureConfigMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.silkworm.db_access.*"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    UserMgr userMgr = UserMgr.getInstance();
    String context = metaMgr.getContext();

    Calendar cal = Calendar.getInstance();
    String timeFormat = "yyyy/MM/dd HH:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
    String nowTime = sdf.format(cal.getTime());
    String DateStr = nowTime.substring(0, nowTime.indexOf(" ")).replaceAll("/", "-");

    ArrayList issueCommentsList = (ArrayList) request.getAttribute("issueCommentsList");
    List<WebBusinessObject> usersList = (List) request.getAttribute("usersList");

    String selectionDate = (String) request.getAttribute("selectionDate");
    String status = (String) request.getAttribute("status");

    TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
    String stat = (String) request.getSession().getAttribute("currentMode");

    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode;
    String cancel_button_label;

    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "عربي";
        langCode = "Ar";

        cancel_button_label = "Back To List";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";

        cancel_button_label = "عودة";
    }
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Untitled Document</title>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
        <link rel="stylesheet" type="text/css" href="css/CSS.css" />
        <link rel="stylesheet" type="text/css" href="css/Button.css" />
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function () {
                $("#issueDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });

            function submitForm()
            {
                document.ISSUE_COMMENT_FORM.action = "<%=context%>/DatabaseControllerServlet?op=getIssueComments";
                document.ISSUE_COMMENT_FORM.submit();
            }

            function updateIssueSourceID(issueID) {
                var userID = $("#userId" + issueID).val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/IssueServlet?op=updateIssueSourceIDAjax",
                    data: {
                        userID: userID,
                        issueID: issueID
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            location.reload();
                        } else {
                            alert("Error");
                        }
                    }
                });
            }
        </script>
    </HEAD>

    <BODY>
        <FORM NAME="ISSUE_COMMENT_FORM" METHOD="POST">
            <FIELDSET class="set" align="center">
                <legend align="center">
                </legend>

                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>
                        <td class="td">
                            <b style="font-size: medium;">عرض طلبات يوم :</b>
                        </td>

                        <td class="td">
                            <input type="text" size="7" maxlength="7" readonly id="issueDate" name="issueDate" style='width:170px;' value="<%=selectionDate != null ? selectionDate : DateStr%>"/>
                        </td>

                        <td class="td">
                            <button onclick="JavaScript:  submitForm();" class="button" style="width: 100px">بحث</button>
                        </td>
                    </tr>
                </table>

                <%if (issueCommentsList != null && issueCommentsList.size() > 0) {%>
                <TABLE CLASS="blueBorder" style="border-color: silver; border-right-WIDTH:1px;"  CELLPADDING="0" CELLSPACING="0"  ALIGN="center" DIR="<%=dir%>">
                    <TR class="backgroundHeader">
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;color:white;">
                            <B>
                                &nbsp;Issue Business Number&nbsp;
                            </B>
                        </TD>

                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;color:white;">
                            <B>
                                &nbsp;Created By User&nbsp;
                            </B>
                        </TD>

                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;color:white;">
                            <B>
                                &nbsp;Change Created By User&nbsp;
                            </B>
                        </TD>

                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;color:white;">
                        </TD>
                    </TR>

                    <%
                        for (int i = 0; i < issueCommentsList.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) issueCommentsList.get(i);
                    %>
                    <tr>
                        <TD  CLASS="cell" style="text-align: center">
                            <font color='red'><%=wbo.getAttribute("businessID")%></font><font color='blue'>/<%=wbo.getAttribute("businessIDByDate")%></font>
                        </TD>

                        <TD  CLASS="cell" style="text-align: center">
                            <%
                                WebBusinessObject userWbo = userMgr.getOnSingleKey(wbo.getAttribute("createdBy").toString());
                            %>
                            <%=userWbo.getAttribute("userName")%>
                        </TD>

                        <TD  CLASS="cell" style="text-align: center">
                            <%if (usersList.size() > 0 && usersList != null) {%>
                            <select id="userId<%=wbo.getAttribute("issueID")%>" name="userId" style="width: 50%; font-weight: bold; font-size: 13px;" >
                                <sw:WBOOptionList displayAttribute="userName" valueAttribute="userId" wboList="<%=usersList%>" />
                            </select>
                            <% } %>
                        </TD>

                        <TD  CLASS="cell" style="text-align: center">
                            <button onclick="JavaScript: updateIssueSourceID('<%=wbo.getAttribute("issueID")%>');" class="button" style="width: 100px">update</button>
                        </TD>
                    </TR>
                    <%}%>
                </TABLE>
                <br/>
                <%}%>
            </FIELDSET>
        </Form>
    </Body>
</HTML>