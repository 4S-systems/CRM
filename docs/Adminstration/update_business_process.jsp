<%@page import="com.maintenance.common.UserClosureConfigMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.silkworm.db_access.*"%>
<%@ taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    WebBusinessObject user = (WebBusinessObject) request.getAttribute("user");
    Vector closureConfigList = (Vector) request.getAttribute("closureConfigList");
    String status = (String) request.getAttribute("status");

    ArrayList<WebBusinessObject> userMgr = UserMgr.getInstance().getUsersManager();

    TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
    String stat = (String) request.getSession().getAttribute("currentMode");

    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode;
    String cancel_button_label, save_button_label;
    String sFullName, sUserName, isDefault, sDept, sSelect;

    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "عربي";
        langCode = "Ar";

        cancel_button_label = "Back To List";
        save_button_label = "Save";
        sFullName = "Full Name";
        sUserName = "User Name";
        isDefault = "Is Default";
        sDept = "Department";
        sSelect = "Select";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";

        cancel_button_label = "عودة";
        save_button_label = "تسجيل";
        sFullName = "الاسم بالكامل";
        sUserName = "اسم المستخدم";
        isDefault = "إفتراضى";
        sDept = "القسم";
        sSelect = "اختار";
    }
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new user</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <link rel="stylesheet" href="css/chosen.css"/>


        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            function submitForm()
            {
                document.USER_CLOSURE_FORM.action = "<%=context%>/UsersServlet?op=saveBusinessProcess";
                document.USER_CLOSURE_FORM.submit();
            }

            function cancelForm()
            {
                document.USER_CLOSURE_FORM.action = "<%=context%>/ListerServlet?op=ListUsers";
                document.USER_CLOSURE_FORM.submit();
            }

            function  checkGroup()
            {

                var rows = document.getElementById('rows').value;
                var countGroup = 0;

                for (x = 0; x < rows; x++) {
                    if (document.getElementById('group' + x).checked == true) {
                        countGroup = countGroup + 1;
                    }
                }
                if (countGroup > 0) {

                    return true;
                } else {
                    return false;

                }
            }

            function  checkRadioDefault()
            {
                var rows = document.getElementById('rows').value;
                var countDefault = 0;

                for (x = 0; x < rows; x++) {
                    if (document.getElementById('isDefault' + x).checked == true) {
                        countDefault = countDefault + 1;
                    }
                }
                if (countDefault > 0) {
                    return true;
                } else {
                    return false;
                }
            }

            function checkDefault(i)
            {
                var check = document.getElementById('group' + i);
                var rows = document.getElementById('rows').value;
                var count = 0;
                for (x = 0; x < rows; x++) {
                    if (document.getElementById('isDefault' + x).checked == true) {
                        count = count + 1;
                    }
                }

                if (check.checked == true) {
                    document.getElementById('isDefault' + i).disabled = false;

                } else {
                    document.getElementById('isDefault' + i).checked = false;
                    document.getElementById('isDefault' + i).disabled = true;
                }

            }
        </SCRIPT>
    </HEAD>

    <BODY>
        <FORM NAME="USER_CLOSURE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button onclick="cancelForm()" class="button"><%=cancel_button_label%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
                <button onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV>

            <fieldset class="set" align="center">
                <legend align="center">
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">Add Manger To Team Leader</font>
                            </td>
                        </tr>
                    </table>
                </legend>

                <%
                    if (null != status) {
                        if (status.equalsIgnoreCase("ok")) {
                %>
                <center>
                    <h3 style="color: green">Save Success</h3>
                </center>
                <br>
                <%} else {%>
                <center>
                    <h3>Not Save</h3>
                </center>
                <br>
                <%}
                    }

                %>

                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" ALIGN="CENTER" DIR="<%=dir%>">
                    <TR>
                        <TD class='td'>
                            <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sFullName%></b></p>
                        </TD>

                        <%
                            if (user.getAttribute("fullName") != null) {
                        %>
                        <TD class='td'>
                            <input disabled type="TEXT" name="fullName" ID="fullName" size="33" value="<%=user.getAttribute("fullName")%>" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                        </TD>
                        <%
                        } else {
                        %>
                        <TD class='td'>
                            <input disabled type="TEXT" name="fullName" ID="fullName" size="33" value="" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                        </TD>
                        <%
                            }
                        %>
                    </TR>
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=sUserName%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <input disabled type="TEXT" name="userName" ID="userName" size="33" value="<%=user.getAttribute("userName")%>" maxlength="255">
                            <INPUT TYPE='HIDDEN' name='userId' value="<%=user.getAttribute("userId")%>" > 

                        </TD>
                    </TR>
                    <% if (user.getAttribute("userType").equals("1")) {%>
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=sUserName%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <select name="requestType" id="requestType" style="width: 200px;" class="chosen-select-campaign">
                                <option value="">choice</option>
                                <sw:WBOOptionList wboList="<%=userMgr%>" displayAttribute="user_name" valueAttribute="user_id" />
                            </select>
                        </TD>
                    </TR>
                    <% } %>
                </TABLE>

                <br/> <br/>
            </fieldset>
        </FORM>
        <script>
            var config = {
                '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'},
                '.chosen-select-rate': {no_results_text: 'No classification found with this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            getEmployees($("#departmentID"), true);
        </script>
    </BODY>
</HTML>