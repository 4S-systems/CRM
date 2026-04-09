<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE></TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] shippingMfstAttributes = {"campaignTitle", "fromDate", "toDate"};
        String[] shippingMfstTitles = new String[7];
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        int s = shippingMfstAttributes.length;
        int t = s + 5;
        int iTotal = 0;

        String attName = null;
        String attValue = null;

        ArrayList<WebBusinessObject> campaignsList = (ArrayList<WebBusinessObject>) request.getAttribute("campaignsList");

        int flipper = 0;
        String bgColor = null;
        String bgColorm = null;

        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        String action = "delete";

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, PN, PL;
        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            shippingMfstTitles[0] = "Campaign Code";
            shippingMfstTitles[1] = "From Date";
            shippingMfstTitles[2] = "To Date";
            shippingMfstTitles[3] = "View";
            shippingMfstTitles[4] = "Delete";
            shippingMfstTitles[5] = "Status";
            shippingMfstTitles[6] = "";
            PN = "Campaigns  No.";
            PL = "Campaigns List";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            shippingMfstTitles[0] = "كود الحملة";
            shippingMfstTitles[1] = "من تاريخ";
            shippingMfstTitles[2] = "ألي تاريخ";
            shippingMfstTitles[3] = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
            shippingMfstTitles[4] = "&#1581;&#1584;&#1601;";
            shippingMfstTitles[5] = "الحالة";
            shippingMfstTitles[6] = "";
            PN = "عدد الحملات";
            PL = "عرض الحملات";
        }
    %>
    <body>
        <script language="javascript" type="text/javascript">
            function back(url)
            {
                document.CAMPAIGN_FORM.action = url;
                document.CAMPAIGN_FORM.submit();
            }
            function changeStatus(id, oldStatus, newStatus, type) {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/CampaignServlet?op=changeCampaignStatusByAjax",
                    data: {
                        id: id,
                        oldStatus: oldStatus,
                        newStatus: newStatus
                    }
                    ,
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            alert("تم تغيير الحالة");
                            $("#currentStatus" + id).html(info.currentStatusName);
                            if (type == 'active') {
                                $("#active" + id).attr("disabled", "disabled");
                                $("#onhold" + id).removeAttr("disabled");
                                $("#cancel" + id).attr("disabled", "disabled");
                                $("#finish" + id).removeAttr("disabled");
                            } else if (type == 'onhold') {
                                $("#active" + id).removeAttr("disabled");
                                $("#onhold" + id).attr("disabled", "disabled");
                                $("#cancel" + id).removeAttr("disabled");
                                $("#finish" + id).attr("disabled", "disabled");
                            } else if (type == 'cancel' || type == 'finish') {
                                $("#active" + id).attr("disabled", "disabled");
                                $("#onhold" + id).attr("disabled", "disabled");
                                $("#cancel" + id).attr("disabled", "disabled");
                                $("#finish" + id).attr("disabled", "disabled");
                            }
                        } else if (info.status == 'faild') {
                            alert("لم يتم تغيير الحالة");
                        } else if (info.status == 'date out of range') {
                            alert("Can not activate, out of Campaign's dates");
                        }
                    }
                });
            }
        </script>
        <FORM NAME="CAMPAIGN_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            </DIV>
        </FORM>
        <fieldset align=center class="set">
            <legend align="center">
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6"><%=PL%>
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
            <br />
            <center>
                <b> <font size="3" color="red"> <%=PN%> : <%=campaignsList.size()%> </font></b>
            </center>
            <br>
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                <TR >
                    <TD nowrap CLASS="silver_header" STYLE="border-width: 0px; white-space: nowrap;">
                        &nbsp;
                    </TD>
                    <%
                        String columnColor = new String("");
                        String columnWidth = new String("");
                        String font = new String("");
                        for (int i = 0; i < t - 1; i++) {
                            if (i == 0) {
                                columnColor = "#9B9B00";
                            } else {
                                columnColor = "#7EBB00";
                            }
                            if (shippingMfstTitles[i].equalsIgnoreCase("")) {
                                columnWidth = "1";
                                columnColor = "black";
                                font = "1";
                            } else {
                                columnWidth = "150";
                                font = "12";
                            }
                    %>
                    <TD nowrap CLASS="silver_header" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:<%=font%>;white-space: nowrap;" >
                        <B><%=shippingMfstTitles[i]%></B>
                    </TD>
                    <%
                        }
                    %>
                </TR>
                <%
                    for (WebBusinessObject wbo : campaignsList) {
                        iTotal++;
                        flipper++;
                        String currentStatus = (String) wbo.getAttribute("currentStatus");
                        if (currentStatus == null) {
                            currentStatus = "";
                        }
                        if ((flipper % 2) == 1) {
                            bgColor = "silver_odd";
                            bgColorm = "silver_odd_main";
                        } else {
                            bgColor = "silver_even";
                            bgColorm = "silver_even_main";
                        }
                        String permenantColor = "";
                        if (currentStatus.equalsIgnoreCase("20")) {
//                            permenantColor = "#FFFF99";
                        }
                %>
                <TR>
                    <TD STYLE="<%=style%>; background-color: #dfdfdf;" nowrap  CLASS="<%=bgColor%>" >
                        <img src="images/perm_campaign.png" width="20" style="display: <%=currentStatus.equalsIgnoreCase("20")?"":"none"%>"/>
                    </TD>
                    <%
                        for (int i = 0; i < s; i++) {
                            attName = shippingMfstAttributes[i];
                            String color = "red";
                            String dateAlign = "";
                            if (i == 0) {
                                attValue = (String) wbo.getAttribute(attName) + " ";
                            } else {
                                dateAlign = "center";
                                if (currentStatus.equalsIgnoreCase("20")) {
                                    attValue = "---";
                                } else {
                                    attValue = sdf.format(sdf.parse((String) wbo.getAttribute(attName)));
                                }
                                color = "black";
                            }

                    %>
                    <TD STYLE="<%=style%>; background-color: <%=permenantColor%>; text-align: <%=dateAlign%>;" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColor%>" >
                        <DIV >

                            <b style="color: <%=color%>;"> <%=attValue%> </b>
                        </DIV>
                    </TD>
                    <%
                        }
                    %>
                    <TD nowrap CLASS="<%=bgColor%>" BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>; background-color: <%=permenantColor%>;">
                        <DIV ID="links" style="display: <%=currentStatus.equalsIgnoreCase("20") ? "none" : ""%>">
                            <A HREF="<%=context%>/CampaignServlet?op=viewCampaign&id=<%=wbo.getAttribute("id")%>">
                                <%=shippingMfstTitles[3]%>
                            </A>
                        </DIV>
                        <DIV style="display: <%=currentStatus.equalsIgnoreCase("20") ? "" : "none"%>; text-align: center;">
                            ---
                        </DIV>
                    </TD>
                    <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>; background-color: <%=permenantColor%>;">
                        <DIV ID="links" style="display: <%=currentStatus.equalsIgnoreCase("20") ? "none" : ""%>">
                            <A HREF="#">
                                <%=shippingMfstTitles[4]%>
                            </A>
                        </DIV>
                        <DIV style="display: <%=currentStatus.equalsIgnoreCase("20") ? "" : "none"%>; text-align: center;">
                            ---
                        </DIV>
                    </TD>
                    <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>; background-color: <%=permenantColor%>;">
                        <DIV >
                            <b style="color: blue;" id="currentStatus<%=wbo.getAttribute("id")%>"> <%=wbo.getAttribute("currentStatusName")%> </b>
                        </DIV>
                    </TD>
                    <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>; background-color: <%=permenantColor%>;">
                        <input type="button" id="active<%=wbo.getAttribute("id")%>" value="Active"
                               onclick="JavaScript: changeStatus('<%=wbo.getAttribute("id")%>', '<%=currentStatus%>', '16', 'active')"
                               <%=currentStatus.equalsIgnoreCase("15") || currentStatus.equalsIgnoreCase("17") ? "" : "disabled"%>/>
                        <input type="button" id="onhold<%=wbo.getAttribute("id")%>" value="Onhold"
                               onclick="JavaScript: changeStatus('<%=wbo.getAttribute("id")%>', '<%=currentStatus%>', '17', 'onhold')"
                               <%=currentStatus.equalsIgnoreCase("16") ? "" : "disabled"%>/>
                        <input type="button" id="cancel<%=wbo.getAttribute("id")%>" value="Cancel"
                               onclick="JavaScript: changeStatus('<%=wbo.getAttribute("id")%>', '<%=currentStatus%>', '19', 'cancel')"
                               <%=currentStatus.equalsIgnoreCase("15") || currentStatus.equalsIgnoreCase("17") ? "" : "disabled"%>/>
                        <input type="button" id="finish<%=wbo.getAttribute("id")%>" value="Finish"
                               onclick="JavaScript: changeStatus('<%=wbo.getAttribute("id")%>', '<%=currentStatus%>', '18', 'finish')"
                               <%=currentStatus.equalsIgnoreCase("16") ? "" : "disabled"%>/>
                    </TD>
                </TR>
                <%
                    }
                %>
                <TR>
                    <TD CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="4" STYLE="<%=style%>;padding-right:5;border-right-width:1;font-size:16;">
                        <B><%=PN%></B>
                    </TD>
                    <TD CLASS="silver_footer" BGCOLOR="#808080" colspan="4" STYLE="<%=style%>;padding-left:5;font-size:16;"  >

                        <DIV NAME="" ID="">
                            <B><%=iTotal%></B>
                        </DIV>
                    </TD>
                </TR>
            </TABLE>
            <br /><br />
        </fieldset>
    </body>
</html>
