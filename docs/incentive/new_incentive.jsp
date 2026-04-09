<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
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
        ArrayList<WebBusinessObject> incentivesList = (ArrayList<WebBusinessObject>) request.getAttribute("incentivesList");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar c = Calendar.getInstance();
        String clientId = (String) request.getAttribute("clientId");
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
            function saveClientIncentives() {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=saveClientIncentivesByAjax",
                    data: $("#incentives_form").serialize(),
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            alert("تم التسجيل بنجاح");
                            $("#add_incentives").bPopup().close();
                        } else if (info.status == 'faild') {
                            alert("لم يتم التسجيل");
                        }
                    }
                });
                return false;
            }
            $(function() {
                $(".incentiveDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
            function closePopup(formID) {
                $("#" + formID).hide();
                $("#" + formID).bPopup().close();
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
                 border-radius: 100px;" onclick="closePopup('add_incentives')"/>
        </div>
        <div class="login" style="width: 90%;float: left;margin: 0px 0xp;">
            <input type="hidden" id="siteAll" value="no" name="siteAll"/>
            <form id="incentives_form" action="<%=context%>/ClientServlet?op=saveClientIncentivesByAjax">
                <input type="hidden" name="clientId" value="<%=clientId%>"/>
                <br/>
                <TABLE  id="incentivesList" CELLPADDING="4" style="width: 80%;" CELLSPACING="2" STYLE="border:none;" align="center"  DIR="<%=dir%>">
                    <tr>
                        <TD WIDTH="100%" nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                            Incentive
                        </TD>
                        <TD WIDTH="100%" nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                            Date
                        </TD>
                    </TR>
                    <%
                        int i = 0;
                        for (WebBusinessObject wbo : incentivesList) {
                            String incentiveTitle = (String) wbo.getAttribute("incentiveTitle");
                            String incentiveId = (String) wbo.getAttribute("id");
                    %>
                    <tr>
                        <TD WIDTH="100%" nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                            <INPUT TYPE="CHECKBOX" NAME="incentiveId" ID="incentiveId" value="<%=incentiveId%>" class="checkboxClass" />
                            <%=incentiveTitle%>
                        </TD>
                        <TD WIDTH="100%" STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;" nowrap>
                            <INPUT TYPE="TEXT" NAME="incentiveDate<%=incentiveId%>" ID="incentiveDate<%=incentiveId%>"
                                   style="width: 150px;" class="incentiveDate" readonly
                                   value="" />
                        </TD>
                    </TR>
                    <%
                        }
                    %>
                    <tr> <td style="text-align: center;border: none" colspan="5"><br/><input type="button" onclick="saveClientIncentives();"  value="Save" style="font-family: sans-serif" ></td> </tr>
                </TABLE>
            </form>
        </div>
    </BODY>
</html>