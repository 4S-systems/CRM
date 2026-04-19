
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}" />
    <fmt:setBundle basename="Languages.Campaigns.Campaigns" />

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        List<WebBusinessObject> clients = (List) request.getAttribute("clients");
    %>
    <head>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css"/>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>

        <script type="text/javascript" src="js/jquery-1.12.4.js"></script>
        <script type="text/javascript" src="jquery-ui/jquery-ui-1.12.1.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>

        <script type="text/javascript">
            jQuery.browser = {};
            (function () {
                jQuery.browser.msie = false;
                jQuery.browser.version = 0;
                if (navigator.userAgent.match(/MSIE ([0-9]+)\./)) {
                    jQuery.browser.msie = true;
                    jQuery.browser.version = RegExp.$1;
                }
            })();
            var oTable;
            $(document).ready(function () {
                $("#clients").css("display", "none");
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);

                $("#startDate,#endDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
            function changePage(url) {
                window.navigate(url);
            }
            function submitForm() {
                document.CUSTOMER_REFERRAL.action = "<%=context%>/CampaignServlet?op=getCustomerReferral";
                document.CUSTOMER_REFERRAL.submit();
            }
            function showTitle(obj, clientID) {
                if (!$(obj).is(':ui-tooltip')) {
                    $(obj).attr("title", 'Loading ...');
                    $.ajax({
                        type: 'POST',
                        url: "<%=context%>/ClientServlet?op=showReferralCustomerAjax",
                        data: {
                            clientID: clientID
                        },
                        success: function (data) {
                            var jsonString = $.parseJSON(data);
                            if (jsonString.status === 'ok') {
                                setClickableTooltip(obj, 'Recommended By: <a target="blank" href="<%=context%>/ClientServlet?op=clientDetails&clientId=' + jsonString.clientID + '">' + jsonString.clientName + '</a>');
                            } else {
                                setClickableTooltip(obj, "Recommended By: None");
                            }
                        }
                    });
                }
            }
            function setClickableTooltip(target, content) {
                $(target).tooltip({
                    show: true, // show immediately 
                    position: {my: "right", at: "right"},
                    content: content, //from params
                    hide: {effect: ""}, //fadeOut
                    close: function (event, ui) {
                        ui.tooltip.hover(
                                function () {
                                    $(this).stop(true).fadeTo(40, 1);
                                },
                                function () {
                                    $(this).fadeOut(40, function () {
                                        $(this).remove();
                                    });
                                }
                        );
                    }
                });
            }
        </script>
        <style>
            label{
                font: Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight:bold;
                color:#005599;
                margin-right: 5px;
            }
            #row:hover{
                background-color: #EEEEEE;
            }
            .client_btn {
                width:145px;
                height:31px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/addclient.png);
            }
            .company_btn {
                width:145px;
                height:31px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/addCompany.png);
            }
            .enter_call {
                width:145px;
                height:31px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/Number.png);
            }
            .titlebar {
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
        </style>
    </head>
    <body>
        <div id="divTag"></div>
        <form name="CUSTOMER_REFERRAL" method="post">
            <fieldset class="set" style="width:85%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">
                            <fmt:message key="customerReferral"/>
                            </font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table class="blueBorder" ALIGN="CENTER" DIR=<fmt:message key="direction"/> ID="code" width="30%" style="border-width:1px;border-color:white;display: block;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b>
                                <font size=3 color="white"> 
                                <fmt:message key="fromDate"/>
                                </font>
                            </b>
                        </td>
                        <td bgcolor="#dedede" valign="middle" >
                            <input type="TEXT" style="width:190px" ID="startDate" name="startDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("startDate") == null ? "" : request.getAttribute("startDate")%>"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b>
                                <font size=3 color="white"> 
                                <fmt:message key="toDate"/>
                                </font>
                            </b>
                        </td>
                        <td bgcolor="#dedede" valign="middle" width="30%">
                            <input type="TEXT" style="width:190px" ID="endDate" name="endDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("endDate") == null ? "" : request.getAttribute("endDate")%>"/>
                        </td>
                    </tr>
                </table>
                <br/>
                <button class="button" type="button" onclick="JavaScript: submitForm();" style="color: #27272A;font-size:15px;margin-top: 20px;font-weight:bold; height: 50px; "><fmt:message key="print"/><img height="15" src="images/search.gif"> </button>
                <br/><br/>
                <% if (clients != null && clients.size() > 0) {%>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <h1 style="color: #0000ff; font-size: 20px;">
                        <div style="color: blue;" id="tableTitle">
                            <fmt:message key="tableTitle"/>
                        </div>
                    </h1>
                    <table align="center" dir="<fmt:message key="direction"/>" width="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><input type="checkbox" onclick="JavaScript: selectAll(this);" /> </th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><fmt:message key="clientcode"/></th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><fmt:message key="clientname"/></th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><fmt:message key="mobile"/></th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><fmt:message key="interPhone"/></th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><fmt:message key="source"/></th>
                                <th style="color: #005599 !important;font-size: 14px; font-weight: bold;"><fmt:message key="resp"/></th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (WebBusinessObject wbo_ : clients) {
                            %>
                            <tr style="cursor: pointer" id="row" onmouseenter="JavaScript: showTitle(this, '<%=wbo_.getAttribute("clientID")%>');">
                                <td>
                                    <input type="checkbox" name="clientID" value="<%=wbo_.getAttribute("clientID")%>" />
                                </td>
                                <td>
                                    <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo_.getAttribute("clientID")%>">
                                        <%=wbo_.getAttribute("clientNo")%>
                                    </a>
                                </td>
                                <td>
                                    <%=wbo_.getAttribute("clientName")%>
                                </td>
                                <td>
                                    <%=wbo_.getAttribute("mobile") != null ? wbo_.getAttribute("mobile") : ""%>
                                </td>
                                <td>
                                    <%=wbo_.getAttribute("interPhone") != null && !"UL".equals(wbo_.getAttribute("interPhone")) ? wbo_.getAttribute("interPhone") : ""%>
                                </td>
                                <td>
                                    <%=wbo_.getAttribute("createdBy")%>
                                </td>
                                <td>
                                    <%=wbo_.getAttribute("ownerUser") != null ? wbo_.getAttribute("ownerUser") : "لا يوجد"%>
                                </td>
                            </tr>
                            <%}%>
                        </tbody>
                    </table>
                    <br/>
                    <br/>
                </div>
                <%} else {%>
                <br/>
                <b style="font-size: x-large; color: red;"><fmt:message key="nodata" /></b>
                <br/>
                <br/>
                <%}%>
            </fieldset>
        </form>
    </body>
</html>