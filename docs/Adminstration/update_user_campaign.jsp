<%@page import="com.maintenance.common.UserClosureConfigMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.silkworm.db_access.*"%>
<%@ taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    WebBusinessObject user = (WebBusinessObject) request.getAttribute("user");
    ArrayList<WebBusinessObject> campaignsUserList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignsUserList");
    String status = (String) request.getAttribute("status");
    String stat = (String) request.getSession().getAttribute("currentMode");
    String align = null;
    String dir = null;
    String style = null;
    String cancel_button_label, save_button_label;
    String sFullName, sUserName, campaignName, select, title;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        cancel_button_label = "Back To List";
        save_button_label = "Save";
        sFullName = "Full Name";
        sUserName = "User Name";
        campaignName = "Campaign";
        select = "Select";
        title = "User's Campaigns Joining";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        cancel_button_label = "عودة";
        save_button_label = "تسجيل";
        sFullName = "الاسم بالكامل";
        sUserName = "اسم المستخدم";
        campaignName = "الحملة";
        select = "اختار";
        title = "أرتباط المستخدم بالحملات";
    }
%>
<html>
    <head>
        <link rel="stylesheet" type="text/css" href="CSS.css" />
        <script LANGUAGE="JavaScript" type="text/javascript">
            function submitForm() {
                document.USER_CAMPAIGN_FORM.action = "<%=context%>/UsersServlet?op=saveUserCampaignsConfig";
                document.USER_CAMPAIGN_FORM.submit();
            }

            function cancelForm() {
                document.USER_CAMPAIGN_FORM.action = "<%=context%>/ListerServlet?op=ListUsers";
                document.USER_CAMPAIGN_FORM.submit();
            }
            
            function selectAll(obj) {
                $("input[name='campaignID']").prop('checked', $(obj).is(':checked'));
            }

        </script>
    </head>
    <body>
        <form name="USER_CAMPAIGN_FORM" method="post">
            <div align="left" style="color: blue;">
                <button type="button" onclick="cancelForm()" class="button"><%=cancel_button_label%> <IMG valign="bottom" height="15" src="images/leftarrow.gif"></button>
                <button onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG height="15" src="images/save.gif"></button>
            </div>

            <fieldset class="set" align="center">
                <legend align="center">
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"><%=title%></font>
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
                <table cellpadding="0" cellspacing="0" ORDER="0" align="CENTER" DIR="<%=dir%>">
                    <tr>
                        <td class='td'>
                            <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold"><%=sFullName%></b></p>
                        </td>
                        <%
                            if (user.getAttribute("fullName") != null) {
                        %>
                        <td class='td'>
                            <input disabled type="text" name="fullName" id="fullName" size="33" value="<%=user.getAttribute("fullName")%>" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                        </td>
                        <%
                        } else {
                        %>
                        <td class='td'>
                            <input disabled type="text" name="fullName" id="fullName" size="33" value="" maxlength="255" style="width:100%;color: black; font-weight: bold; font-size: 12px">
                        </td>
                        <%
                            }
                        %>
                    </tr>
                    <tr>
                        <td class='td'>
                            <p><b><%=sUserName%>:</b>&nbsp;
                        </td>
                        <td class='td'>
                            <input disabled type="text" name="userName" id="userName" size="33" value="<%=user.getAttribute("userName")%>" maxlength="255">
                        </td>
                    </tr>
                </table>
                <br/> <br/>
                <%if (campaignsUserList.size() > 0 && campaignsUserList != null) {%>
                <table class="blueBorder" style="border-color: silver; border-right-width: 1px;" width="600" cellpadding="0" cellspacing="0" align="center" DIR="<%=dir%>">
                    <TR class="backgroundHeader">
                        <td valign="bottom" style="border-top-width:0;color:white;" width="40">
                            <b>
                                &nbsp;
                            </b>
                        </td>
                        <td nowrap class="firstname" width="570" style="border-top-width: 0; font-size: 12px; color: white;" nowrap >
                            <%=campaignName%>
                        </td>
                        <td valign="bottom" style="border-top-width: 0; color: white;" width="30">
                            <b>
                                &nbsp;<%=select%>&nbsp;<input type="checkbox" onclick="JavaScript: selectAll(this);"/>
                            </b>
                        </td>
                    </tr>       
                    <input type="hidden" name="rows" id="rows" value="<%=campaignsUserList.size()%>">
                    <%
                        for (int i = 0; i < campaignsUserList.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) campaignsUserList.get(i);
                    %>
                    <tr>
                        <td class="cell">
                            <%=i + 1%>
                        </td>
                        <td class="cell" style="padding-left: 40px; text-align: right;">
                            <%=wbo.getAttribute("campaignTitle")%>
                        </td>
                        <td class="cell">
                            <input type="checkbox" name="campaignID" value="<%=wbo.getAttribute("campaignID")%>" id="campaignID<%=i%>" <%=wbo.getAttribute("id") != null ? "checked" : ""%> /> 
                        </td>
                    </tr>
                    <%
                        }
                    %>
                    <tr>
                    <input type='hidden' name='userId' value="<%=user.getAttribute("userId")%>" />
                    </tr>
                </table>
                <br/><br/>
                <%
                    }
                %>
            </fieldset>
        </form>
    </body>
</html>