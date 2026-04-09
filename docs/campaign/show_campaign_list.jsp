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
        ArrayList<WebBusinessObject> campaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList");
        ArrayList<WebBusinessObject> clientCampaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientCampaignsList");
        HashMap<String, ArrayList> campaignToolsList = (HashMap<String, ArrayList>) request.getAttribute("campaignToolsList");
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
            function saveClientCampaigns() {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=saveClientCampaignsByAjax",
                    data: $("#campaigns_form").serialize(),
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            alert("تم التسجيل بنجاح");
                            closePopupDialog('add_campaigns');
                        } else if (info.status == 'faild') {
                            alert("لم يتم التسجيل");
                        }


                    }
                });
                return false;
            }
            function changeValue(obj, obj2) {
                $("#" + obj2).val($("#" + obj).val());
            }
            $(document).ready(function()
            {
                $('#campaignsList').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[-1], ['All']],
                    iDisplayLength: -1,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[5, "desc"]]
                }).show();
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
                 border-radius: 100px;" onclick="closePopupDialog('add_campaigns')"/>
        </div>
        <div class="login" style="width: 90%;float: left;margin: 0px 0xp;">
            <input type="hidden" id="siteAll" value="no" name="siteAll"/>
            <form id="campaigns_form" action="<%=context%>/ClientServlet?op=saveClientCampaignsByAjax">
                <input type="hidden" name="clientId" value="<%=clientId%>"/>
                <br/>
                <TABLE  id="campaignsList" CELLPADDING="4" style="width: 100%;" CELLSPACING="2" STYLE="border:none;" align="center"  DIR="<%=dir%>">
                    <thead>
                        <tr>
                            <TD nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                Campaign
                            </TD>
                            <TD nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                &nbsp;
                            </TD>
                            <TD nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                Date
                            </TD>
                            <TD nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center; font-size: 13px; font-weight: bold;">
                                Created by
                            </TD>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int i = 0;
                            for (WebBusinessObject wbo : campaignsList) {
                                String campaignTitle = (String) wbo.getAttribute("campaignTitle");
                                String campaignId = (String) wbo.getAttribute("id");
                                boolean exists = false;
                                String referredType = "Campaign";
                                if (campaignTitle.indexOf("Employee") >= 0) {
                                    referredType = "Employee";
                                } else if (campaignTitle.indexOf("Customer") >= 0) {
                                    referredType = "Customer";
                                } else if (campaignTitle.indexOf("Brokers") >= 0) {
                                    referredType = "Broker";
                                } else if (campaignTitle.indexOf("Sales") >= 0) {
                                    referredType = "Sales Agent";
                                }
                                StringBuilder toolsTitle = new StringBuilder("Tools");
                                if (campaignToolsList != null) {
                                    ArrayList<WebBusinessObject> tools = campaignToolsList.get(campaignId);
                                    if (tools != null) {
                                        for (WebBusinessObject wboTool : tools) {
                                            toolsTitle.append("\n" + (String) wboTool.getAttribute("arabicName"));
                                        }
                                    }
                                }
                        %>
                        <tr>
                            <TD nowrap STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                                <%=campaignTitle%>
                            </TD>
                            <TD STYLE="<%=style%>;background-image: url('images/gradient.gif');background-repeat: repeat-x; text-align: center;">
                                <img src="images/tools.png" width="30" style="" title="<%=toolsTitle%>"/>
                            </TD>
                            <TD STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;" nowrap>
                                <%=wbo.getAttribute("creationTime") != null ? ((String) wbo.getAttribute("creationTime")).substring(0, 10) : "" %>
                            </TD>
                            <TD STYLE="<%=style%>;padding:3px;background-image: url('images/gradient.gif');background-repeat: repeat-x;" nowrap>
                                <%=wbo.getAttribute("createdByName")%>
                            </TD>
                        </TR>
                        <%
                                if (exists) {
                                    i++;
                                }
                            }
                        %>
                    </tbody>
                </TABLE>
            </form>
        </div>
    </BODY>
</html>