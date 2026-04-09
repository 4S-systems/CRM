<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    String groupId = (String) request.getAttribute("groupID");
    List<WebBusinessObject> listUsers = (List<WebBusinessObject>) request.getAttribute("usersList");
    WebBusinessObject wbo = null;
%>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Users List</title>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script TYPE="text/javascript" LANGUAGE="JavaScript" SRC="js/common.js" ></script>
        <script TYPE="text/javascript" LANGUAGE="JavaScript" SRC="js/silkworm_validate.js" ></script>
        <script type="text/javascript" LANGUAGE="JavaScript">
            function submitForm()
            {
                document.LIST_USERS_FORM.action = "<%=context%>/GroupServlet?op=SaveUsersGroups";
                document.LIST_USERS_FORM.submit();
            }
            function selectAll(obj) {
                $("input[name='userId']").prop('checked', $(obj).is(':checked'));
            }
        </script>

        <style type="text/css">
            td,th{padding: 5px;}

            td{
                background-color: #d3d5d4;
            }

            th{
                background-color: #4c85b4;
                color: #aed5de;
            }

            a{ text-decoration: none; }

            #content tr:hover{background: #aed5de; }
        </style>
    </head>

    <body>
        <form method="post" name="LIST_USERS_FORM" action="">
            <fieldset class="border" style="width: auto;">
                <div style="padding: 5px; background: #d3d5d4;">
                    <input type="hidden" name="groupID" value="<%=groupId%>"/>
                    <TABLE ID="tableSearch" class="blueBorder" ALIGN="center" DIR="RTL" CELLPADDING="0" CELLSPACING="0" width="90%">
                        <thead>
                            <tr>
                                <th>
                                    <input id="all" type="checkbox" onclick="JavaScript: selectAll(this);"
                                    إضافة
                                </th>
                                <th>
                                    اسم المستخدم
                                </th>
                                <th>
                                    <button  onclick="JavaScript: submitForm();" class="button"> أضافة</button>
                                    <button  onclick="JavaScript: closeForm();" class="button"> إغلاق</button>
                                </th>
                            </tr>
                        </thead>

                        <tbody>
                            <%
                                if (listUsers.size() > 0) {
                                    for (int i = 0; i < listUsers.size(); i++) {
                                        wbo = listUsers.get(i);
                                        String userId = wbo.getAttribute("userId").toString();
                                        String checked = wbo.getAttribute("exist").toString();
                            %>
                            <tr>
                                <td class="td2" style="width: 20px;">
                                    <%if (checked.equals("yes")) {%>
                                    <input type="CHECKBOX" name="userId" value="<%=userId%>" id="<%=userId%>" checked="true" disabled="true"/>
                                    <%} else {%>
                                    <input type="CHECKBOX" name="userId" value="<%=userId%>" id="<%=userId%>"/>
                                    <%}%>
                                </td>
                                <td class="td2" style="width: 20px;" colspan="2">
                                    <%=wbo.getAttribute("userName").toString()%>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                            <tr>
                                <td colspan="3" align="center">
                                    <button  onclick="JavaScript: submitForm();" class="button"> أضافة</button>
                                    <button  onclick="JavaScript: closeForm();" class="button"> إغلاق</button>
                                </td>
                            </tr>
                            <%
                            } else {
                            %>
                            <tr>
                                <td colspan="2">
                                    لآ يوجد مستخدمين
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </fieldset>
        </form>
    </body>
</html>