<%@page import="com.maintenance.common.UserClosureConfigMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.silkworm.db_access.*"%>
<%@ taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    WebBusinessObject user = (WebBusinessObject) request.getAttribute("user");
    Vector repsGoupsList = (Vector) request.getAttribute("repsGroupsList");

    System.out.println("Groups Vector size = " + repsGoupsList.size());

    String status = (String) request.getAttribute("status");

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
        sDept = "Group";
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
        sDept = "المجموعة";
        sSelect = "اختار";
    }
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>CRM - Update User Reports Group</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script src='ChangeLang.js' type='text/javascript'></script>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            function submitForm()
            {
                if (checkGroup() == true) {
                    if (checkRadioDefault() == true) {
                        document.USER_GROUPS_FORM.action = "<%=context%>/UsersServlet?op=saveUsersGroupsConfig";
                        document.USER_GROUPS_FORM.submit();
                    } else {
                        alert("Select default group for user.");
                    }
                } else {
                    alert("Select at least one group for user");
                }
            }

            function cancelForm()
            {
                document.USER_GROUPS_FORM.action = "<%=context%>/ListerServlet?op=ListUsers";
                document.USER_GROUPS_FORM.submit();
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
        <FORM NAME="USER_GROUPS_FORM" METHOD="POST">
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
                                <font color="blue" size="6">تعديل تقارير المجموعات</font>
                            </td>
                        </tr>
                    </table>
                </legend>

                <%
                    if (null != status) {
                        if (status.equalsIgnoreCase("ok")) {
                %>
                <center>
                    <h3>تم الحفظ بنجاح</h3>
                </center>
                <br>
                <%} else {%>
                <center>
                    <h3>لم يتم الحفظ</h3>
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
                        </TD>
                    </TR>
                </TABLE>

                <br/> <br/>

                <%if (repsGoupsList.size() > 0 && repsGoupsList != null) {%>
                <TABLE CLASS="blueBorder" style="border-color: silver; border-right-WIDTH:1px;" WIDTH="600" CELLPADDING="0" CELLSPACING="0"  ALIGN="center" DIR="<%=dir%>">
                    <TR class="backgroundHeader">
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;color:white;" WIDTH="40">
                            <B>
                                &nbsp;
                            </B>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;color:white;" WIDTH="40">
                            <B>
                                &nbsp;<%=isDefault%>&nbsp;
                            </B>
                        </TD>
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;color:white;" nowrap >
                            <%=sDept%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;color:white;" WIDTH="30">
                            <B>
                                &nbsp;<%=sSelect%>&nbsp;
                            </B>
                        </TD>
                    </TR>       

                    <input type="hidden" name="rows" id="rows" value="<%=repsGoupsList.size()%>">

                    <%
                        for (int i = 0; i < repsGoupsList.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) repsGoupsList.get(i);
                    %>
                    <TR>
                        <TD  CLASS="cell">
                            <%=i + 1%>
                        </TD>
                        <TD  CLASS="cell">
                            <%
                                if (wbo.getAttribute("isDefault").toString().equals("1")) {
                            %>
                            <INPUT TYPE="RADIO" NAME="isDefault" ID="isDefault<%=i%>" value="<%=wbo.getAttribute("groupID")%>" checked>
                            <%} else {%>
                            <INPUT TYPE="RADIO" NAME="isDefault" ID="isDefault<%=i%>" value="<%=wbo.getAttribute("groupID")%>" disabled>
                            <%}%>
                        </TD>

                        <TD  CLASS="cell" STYLE="padding-left:40;text-align:right;">
                            <%=wbo.getAttribute("groupName")%>
                        </TD>

                        <TD  CLASS="cell">
                            <%
                                if (wbo.getAttribute("included").toString().equals("1")) {
                            %>
                            <INPUT TYPE="CHECKBOX" NAME="userGroups" ONCLICK="checkDefault(<%=i%>)" value ="<%=wbo.getAttribute("groupID")%>" ID="group<%=i%>" checked> 
                            <%} else {%>
                            <INPUT TYPE="CHECKBOX" NAME="userGroups" ONCLICK="checkDefault(<%=i%>)" value ="<%=wbo.getAttribute("groupID")%>" ID="group<%=i%>"> 
                            <%}%>
                        </TD>
                    </TR>
                    <%
                        }
                    %>
                    <tr>

                    <INPUT TYPE='HIDDEN' name='userId' value="<%=user.getAttribute("userId")%>" > 
                    <INPUT TYPE='HIDDEN' name='userName' value="<%=user.getAttribute("userName")%>" > 
                    </tr>
                </TABLE>
                <br/><br/>
                <%
                    }
                %>
            </fieldset>
        </FORM>
    </BODY>
</HTML>
