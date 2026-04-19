<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.silkworm.persistence.relational.*"%>
<%@ page import="com.silkworm.common.TimeServices, java.lang.Math"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Campaigns.Campaigns"  />

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        List<WebBusinessObject> campaigns = (List) request.getAttribute("campaigns");
        List<WebBusinessObject> clients = (List) request.getAttribute("clients");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        int a = 0, b = 0, c = 0, d = 0, e = 0, f = 0, g = 0, h = 0;
	
	SecurityUser securityUser = (SecurityUser) request.getSession().getAttribute("securityUser");
	ArrayList<WebBusinessObject> prvType = securityUser.getComplaintMenuBtn();
	ArrayList<String> privilegesList = new ArrayList<String>();
        for (WebBusinessObject wboTemp : prvType) {
            if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                privilegesList.add((String) wboTemp.getAttribute("prevCode"));
            }
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Campaigns Load</TITLE>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
        <link rel="stylesheet" href="css/chosen.css"/>

        <script type="text/javascript">
            var oTable;
            $(document).ready(function() {
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

        </script>

        <script language="javascript" type="text/javascript">
            function changePage(url) {
                window.navigate(url);
            }



            function submitForm()
            {
                if($("#campaignId").val() == '') {
                    alert('<fmt:message key="camperror" />');
                } else {
                    document.CampClientsLoads.action = "<%=context%>/CampaignServlet?op=listCampaignClients&campaignId=" + $("#campaignId").val();
                    document.CampClientsLoads.submit();
                }
            }
            function deleteSelected() {
                if($("input[name='clientID']:checked").length > 0) {
                    document.CampClientsLoads.action = "<%=context%>/CampaignServlet?op=listCampaignClients&delete=true&campaignId=" + $("#campaignId").val();
                    document.CampClientsLoads.submit();
                } else {
                    alert('<fmt:message key="deleteSelectMsg" />');
                }
            }

            function cancelForm() {
                document.Stat.action = "<%=context%>/SearchServlet?op=Projects";
                document.Stat.submit();
            }
            function selectAll(obj) {
                $("input[name='clientID']").prop('checked', $(obj).is(':checked'));
            }
            
            function showClientsDialog(fromDate, toDate) {
                if ($("#campaignId").val() !== '') {
                    var divTag = $("#divTag");
                    $.ajax({
                        type: "post",
                        url: '<%=context%>/ClientServlet?op=getClientsForCampaign',
                        data: {
                            campaignID: $("#campaignId").val(),
                            fromDate: fromDate,
                            toDate: toDate
                        },
                        success: function (data) {
                            divTag.html(data).dialog({
                                modal: true,
                                title: "<fmt:message key="addClients"/> " + $("#campaignId :selected").text(),
                                show: "blind",
                                hide: "explode",
                                width: 700,
                                position: {
                                    my: 'center',
                                    at: 'center'
                                },
                                buttons: {
                                    Close: function () {
                                        $("#divTag").html("");
                                        $(this).dialog('close').dialog('destroy');
                                    },
                                    Save: function () {
                                        saveClients();
                                    },                
                                    Search: function () {
                                        showClientsDialog($("#searchFrom").val(), $("#searchTo").val());
                                    }
                                }
                            }).dialog('open');
                        }
                    });
                }
            }
            function saveClients() {
                if($("input[name='popupClientID']:checked").length === 0) {
                    alert('<fmt:message key="selectOneClient" />');
                } else {
                    var clientIDs = $("input[name='popupClientID']:checked").map(function () {
                        return $(this).val();
                    }).get();
                    $.ajax({
                        type: 'POST',
                        url: "<%=context%>/ClientServlet?op=saveClientsToCampaign",
                        data: {
                            clientIDs: clientIDs.join(","),
                            campaignID: $("#campaignId").val()
                        },
                        success: function (data) {
                            var jsonString = $.parseJSON(data);
                            if (jsonString.status === 'ok') {
                                showClientsDialog($("#searchFrom").val(), $("#searchTo").val());
                            } else {
                                alert('<fmt:message key="failMsg" />');
                            }
                        }
                    });
                }
            }
            function showMoveClientsDialog() {
                if($("input[name='clientID']:checked").length === 0) {
                    alert('<fmt:message key="selectOneClient" />');
                } else {
                    var divTag = $("#moveClients");
                    divTag.dialog({
                        modal: true,
                        title: "<fmt:message key="moveClients"/>",
                        show: "blind",
                        hide: "explode",
                        width: 400,
                        height: 300,
                        position: {
                            my: 'center',
                            at: 'center'
                        },
                        buttons: {
                            Close: function () {
                                $("#divTag").html("");
                                $(this).dialog('close').dialog('destroy');
                            },
                            Move: function () {
                                moveClients();
                            }
                        }
                    }).dialog('open');
                }
            }
            function moveClients() {
                var clientIDs = $("input[name='clientID']:checked").map(function () {
                    return $(this).val();
                }).get();
                $.ajax({
                    type: 'POST',
                    url: "<%=context%>/ClientServlet?op=moveClientsToCampaign",
                    data: {
                        clientIDs: clientIDs.join(","),
                        oldCampaignID: $("#campaignId").val(),
                        newCampaignID: $("#newCampaignID").val()
                    },
                    success: function (data) {
                        var jsonString = $.parseJSON(data);
                        if (jsonString.status === 'ok') {
                            location.reload();
                        } else {
                            alert('<fmt:message key="failMsg" />');
                        }
                    }
                });
            }
            function changeTitle() {
                try {
                    var x = $("#tableTitle").text();
                    var y = $("#campaignId option:selected").text();
                    x += "'"+$("#campaignId option:selected").text()+"'";
                    $("#tableTitle").html(x);
                    
                } catch (err) {
                }
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
    </HEAD>

    <BODY>
        <div id="divTag"></div>
        <div id="moveClients" style="display: none;">
            <table class="blueBorder" align="center" dir="<fmt:message key="direction"/>" width="90%" style="border-width: 1px; border-color: white; display: block;">
                <tr>
                    <td class="ui-dialog-titlebar ui-widget-header" style="width: 50%;">
                        <b>
                            <fmt:message key="campaignname"/>
                        </b>
                    </td>
                    <td class="td">
                        <select style="width: 100%; height: 75%;" id="newCampaignID" name="newCampaignID"
                                class="">
                            <%
                                for (WebBusinessObject campaignWbo : campaigns) {
                                    if (!campaignWbo.getAttribute("id").equals(request.getAttribute("id"))) {
                            %>
                            <option value="<%=campaignWbo.getAttribute("id")%>"><%=campaignWbo.getAttribute("campaignTitle")%></option>
                            <%
                                    }
                                }
                            %>
                        </select>
                    </td>
                </tr>
            </table>
        </div>
        <FORM name="CampClientsLoads" method="post">

            <FIELDSET class="set" style="width:85%;border-color: #006699">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">
                            <fmt:message key="campaigns_loadtittle"/>
                            </font>
                        </td>
                    </tr>
                </table>
                <br/>

                <TABLE class="blueBorder" ALIGN="CENTER" DIR=<fmt:message key="direction"/> ID="code" width="30%"  STYLE="border-width:1px;border-color:white;display: block;" >
                    <TR>
                        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b><font size=3 color="white"> 
                                <fmt:message key="fromDate"/>

                                </TD>
                                <td  bgcolor="#dedede" valign="middle" >
                                    <input type="TEXT" style="width:190px" ID="startDate" name="startDate" size="20" maxlength="100" readonly="true"
                                           value="<%=request.getAttribute("startDate") == null ? "" : request.getAttribute("startDate")%>"/>
                                </td>

                    </TR>

                    <TR>
                        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b><font size=3 color="white"> 
                                <fmt:message key="toDate"/>
                            </b>
                        </TD>
                        <td  bgcolor="#dedede" valign="middle" width="30%">
                            <input type="TEXT" style="width:190px" ID="endDate" name="endDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("endDate") == null ? "" : request.getAttribute("endDate")%>"/>
                        </td>
                    </TR>

                    <TR>
                        <TD  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b><font size=3 color="white"> 
                                <fmt:message key="campaignname"/>
                            </b>
                        </TD>
                        <TD bgcolor="#dedede" valign="MIDDLE" >
                            <select style="width: 100%; height: 75%;" id="campaignId" name="campaignId" onchange="submitForm()"
                                    class="chosen-select-campaign">
                                <option value=""> <fmt:message key="choosecamp" /> </option>
                                <sw:WBOOptionList displayAttribute="campaignTitle" valueAttribute="id" wboList="<%=campaigns%>" scrollToValue='<%=(String) request.getAttribute("id")%>' />
                            </select>
                        </TD>
                    </TR>


                </TABLE>
                <br/>


                <button class="button" type="button" onclick="JavaScript: showMoveClientsDialog();" style="color: #27272A; font-size: 15px; margin-top: 20px; font-weight: bold; display: <%=privilegesList.contains("MOVE_CLIENTS") ? "inline-block" : "none"%>; height: 50px;"><fmt:message key="moveClients"/><img height="20" src="images/icons/transfer.png"> </button>
                <button class="button" type="button" onclick="JavaScript: showClientsDialog();" style="color: #27272A; font-size: 15px; margin-top: 20px; font-weight: bold; display: <%=privilegesList.contains("ADD_CLIENTS") ? "inline-block" : "none"%>; height: 50px;"><fmt:message key="addClients"/><img height="15" src="images/icons/add_item.png"> </button>
                <button class="button" type="button" onclick="JavaScript: deleteSelected();" style="color: #27272A; font-size: 15px; margin-top: 20px; font-weight: bold; display: <%=privilegesList.contains("DELETE_CLIENTS") ? "inline-block" : "none"%>; height: 50px;"><fmt:message key="deleteClients"/><img height="15" src="images/delete.png"> </button>
                <button class="button" type="button" onclick="JavaScript: submitForm();"   STYLE="color: #27272A;font-size:15;margin-top: 20px;font-weight:bold; height: 50px; "><fmt:message key="print"/><IMG HEIGHT="15" SRC="images/search.gif"> </button>
                <br><br>


                <% if (clients != null && clients.size() > 0) {%>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <h1 style="color: #0000ff; font-size: 20px;">
                        <div style="color: blue;" id="tableTitle">
                            <fmt:message key="tableTitle"/>
                        </div>
                    </h1>
                    <TABLE ALIGN="center" dir=<fmt:message key="direction"/> WIDTH="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><input type="checkbox" onclick="JavaScript: selectAll(this);" /> </th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="clientcode"/>  </th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="clientname"/>  </th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="mobile"/>  </th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="interPhone"/>  </th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="source"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="resp"/></th>
                            </tr>
                        </thead>

                        <tbody>
                            <% for (WebBusinessObject wbo_ : clients) {
                            %>
                            <tr style="cursor: pointer" id="row">
                                <td>
                                    <input type="checkbox" name="clientID" value="<%=wbo_.getAttribute("clientID")%>" />
                                </td>
                                <TD>
				    <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo_.getAttribute("clientID")%>">
					<%=wbo_.getAttribute("clientNo")%>
				    </a>
                                </TD>
                                <TD>
                                    <%=wbo_.getAttribute("clientName")%>
                                </TD>
                                <TD>
                                    <%=wbo_.getAttribute("mobile") != null ? wbo_.getAttribute("mobile") : ""%>
                                </TD>
                                <TD>
                                    <%=wbo_.getAttribute("interPhone") != null && !"UL".equals(wbo_.getAttribute("interPhone")) ? wbo_.getAttribute("interPhone") : ""%>
                                </TD>
                                <TD>
                                    <%=wbo_.getAttribute("createdBy")%>
                                </TD>
                                <TD>
                                    <%=wbo_.getAttribute("ownerUser") != null ? wbo_.getAttribute("ownerUser") : "لا يوجد"%>
                                </TD>
                            </tr>
                            <%}%>
                        </tbody>
                    </TABLE>
                </div>
                <%} else {%>
                <br/>
                <b style="font-size: x-large; color: red;"><fmt:message key="nodata" /></b>
                <br/>
                <br/>
                <%}%>
            </FIELDSET>
        </FORM>
        <script>
            var config = {
                '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            $("#divTag").hide();
            changeTitle();
        </script>
    </BODY>
</HTML>