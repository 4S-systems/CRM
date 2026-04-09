<%@page import="java.util.HashMap"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.ArrayList"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> managersList = (ArrayList<WebBusinessObject>) request.getAttribute("managersList");
        String userID = (String) request.getAttribute("userID");
        String spage = (String) request.getAttribute("page");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir, style, changeManager, manager, successMsg, failMsg, save;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            style = "text-align:left";
            changeManager = "Change Manager";
            manager = "New Manager";
            successMsg = "Changed Successfully";
            failMsg = "Fail to Change";
            save = "Save";
        } else {
            align = "right";
            dir = "RTL";
            style = "text-align:Right";
            changeManager = "تغيير المدير";
            manager = "المدير الجديد";
            successMsg = "تم التغيير بنجاح";
            failMsg = "لم يتم التغيير";
            save = "حفظ";
        }
    %>
    <head>
        <meta HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <meta HTTP-EQUIV="Expires" CONTENT="0"/>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            function changeUserManager() {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/EmployeeServlet?op=changeUserManagerAjax",
                    data: $("#users_form").serialize(),
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            alert("<%=successMsg%>");
                            $("#manager_dialog").bPopup().close();
                            $('#manager_dialog').hide();
                        } else if (info.status === 'fail') {
                            alert("<%=failMsg%>");
                        }
                    }
                });
                return false;
            }
            
            function changeUserManagerN(){
                $.ajax({
                    type: "post",
                    url: "<%=context%>/EmployeeServlet?op=changeUserManagerNAjax",
                    data: $("#users_form").serialize(),
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                            alert("<%=successMsg%>");
                            $("#manager_dialog").bPopup().close();
                            $('#manager_dialog').hide();
                            location.reload();
                        } else if (info.status === 'fail') {
                            alert("<%=failMsg%>");
                        }
                    }
                });
                return false;
            }
            function changeValue(obj, obj2) {
                $("#" + obj2).val($("#" + obj).val());
            }
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
                 border-radius: 100px;" onclick="closePopup(this);"/>
        </div>
        <div class="login" style="width: 90%;float: left;margin: 0px 0xp;">
            <input type="hidden" id="siteAll" value="no" name="siteAll"/>
            <form id="users_form" action="<%=context%>/ClientServlet?op=saveClientCampaignsByAjax">
                <input type="hidden" name="userID" value="<%=userID%>"/>
                <br/>
                <TABLE  id="userGroupList" CELLPADDING="4" style="width: 80%;" CELLSPACING="2" STYLE="border:none;" align="center"  DIR="<%=dir%>">
                    <tr>
                        <td nowrap colspan="2" style="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 16px; font-weight: bold;">
                            <%=changeManager%>
                        </td>
                    </tr>
                    <tr>
                        <td nowrap style="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                            <%=manager%>
                        </td>
                        <td style="<%=style%>;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center;">
                            <select name="managerID" id="managerID">
                                <sw:WBOOptionList wboList="<%=managersList%>" displayAttribute="fullName" valueAttribute="userId"/>
                            </select>
                        </td>
                    </tr>
                    <tr> 
                        <td style="text-align: center;border: none" colspan="5">
                            <br/>
                            <%if(spage != null && spage.equals("newmanager")){%>
                            <input type="button" onclick="changeUserManagerN();"  value="<%=save%>" style="font-family: sans-serif" >
                            <%} else {%>
                                <input type="button" onclick="changeUserManager();"  value="<%=save%>" style="font-family: sans-serif" >
                            <%}%>
                        </td> 
                    </tr>
                </TABLE>
            </form>
        </div>
    </BODY>
</html>