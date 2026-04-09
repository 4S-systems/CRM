<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> userGroupList = (ArrayList<WebBusinessObject>) request.getAttribute("userGroupList");
        Map<String, String> statusMap = (HashMap<String, String>) request.getAttribute("statusMap");
        String groupID = (String) request.getAttribute("groupID");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir, style;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            style = "text-align:left";
        } else {
            align = "right";
            dir = "RTL";
            style = "text-align:Right";
        }
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            function removeUsersFromGroup() {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/GroupServlet?op=removeUsersFromGroupByAjax",
                    data: $("#users_form").serialize(),
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            alert("تم ألغاء العضوية بنجاح");
                            $("#group_users").hide();
                            $('#overlay').hide();
                        } else if (info.status == 'faild') {
                            alert("لم يتم اﻷلغاء");
                        }
                    }
                });
                return false;
            }
            function changeValue(obj, obj2) {
                $("#" + obj2).val($("#" + obj).val());
            }
            $(function(){
                $("[title]").tooltip({
                    position: {
                        my: "left top",
                        at: "right+5 top-5"
                    }
                });
            });
        </SCRIPT>
        <style>
            #products
            {
                direction: rtl;
                margin-left: auto;
                margin-right: auto;
            }
            #products tr
            {
                padding: 5px;
            }
            #products td
            {  
                font-size: 12px;
                font-weight: bold;
            }
            #products select
            {                
                font-size: 12px;
                font-weight: bold;
            }
        </style>
    </head>
    <BODY>
        <div style="clear: both;margin-left: 88%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup(this)"/>
        </div>
        <div class="login" style="width: 90%;float: left;margin: 0px 0xp;">
            <input type="hidden" id="siteAll" value="no" name="siteAll"/>
            <form id="users_form" action="<%=context%>/ClientServlet?op=saveClientCampaignsByAjax">
                <input type="hidden" name="groupID" value="<%=groupID%>"/>
                <br/>
                <TABLE  id="userGroupList" CELLPADDING="4" style="width: 80%;" CELLSPACING="2" STYLE="border:none;" align="center"  DIR="<%=dir%>">
                    <tr> <td style="text-align: center;border: none" colspan="5"><br/><input type="button" onclick="removeUsersFromGroup();"  value="ألغاء العضوية" style="font-family: sans-serif" ></td> </tr>
                    <tr>
                        <TD WIDTH="20%" nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                            &nbsp;
                        </TD>
                        <TD WIDTH="60%" nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                            العضو
                        </TD>
                        <TD WIDTH="20%" nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                            &nbsp;
                        </TD>
                    </TR>
                    <%
                        int i = 0;
                        for (WebBusinessObject wbo : userGroupList) {
                            String userName = (String) wbo.getAttribute("userName");
                            String userID = (String) wbo.getAttribute("userId");
                    %>
                    <tr>
                        <td width="20%" style="<%=style%>;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center;">
                            <input type="checkbox" value="<%=userID%>" name="userID"/>
                        </td>
                        <TD WIDTH="60%" nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;">

                            <b title="User Info" onmouseover="JavaScript: showUserInfo(this, '<%=userID%>', '<%=statusMap.containsKey(userID) ? statusMap.get(userID) : "22"%>');"><%=userName%></b>
                        </TD>
                        <td width="20%" style="<%=style%>;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center;">
                            <a href="<%=context%>/UsersServlet?op=ViewUser&userId=<%=userID%>&index=null&numberOfUsers=&statusCode=<%=statusMap.containsKey(userID) ? statusMap.get(userID) : "22"%>" target="viewUser">View</a>
                        </td>
                    </TR>
                    <%
                        }
                    %>
                    <tr> <td style="text-align: center;border: none" colspan="5"><br/><input type="button" onclick="removeUsersFromGroup();"  value="ألغاء العضوية" style="font-family: sans-serif" ></td> </tr>
                </TABLE>
            </form>
        </div>
    </BODY>
</html>