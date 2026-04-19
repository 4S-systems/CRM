<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<html>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Campaigns.Campaigns"  />
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        List<WebBusinessObject> clients = (List) request.getAttribute("clients");
        Calendar c = Calendar.getInstance();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String nowDate = sdf.format(c.getTime());
        ArrayList<WebBusinessObject> groupsList = (ArrayList<WebBusinessObject>) request.getAttribute("groupsList");
        
        String groupId = "";
        if (request.getAttribute("groupId") != null) {
            groupId = (String) request.getAttribute("groupId");
        }
    %>
    <head>
       <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" language="javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">

        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/default/easyui.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/themes/icon.css">
        <link rel="stylesheet" type="text/css" href="jquery-easyui/demo/demo.css">
        <script type="text/javascript" src="jquery-easyui/easyloader.js"></script>
        
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
        <script type="text/javascript">
            var oTable;
            $(document).ready(function () {
                $("#clients").css("display", "none");
                oTable = $('#clients').dataTable({
                    "bJQueryUI": true,
                    "destroy": true,
                    "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                    "order": [[0, "asc"]],
                    "columnDefs": [
                        {
                            "targets": 1,
                            "visible": false
                        }, {
                            "targets": [0, 2, 3, 4, 5],
                            "orderable": false
                        }],
                    "drawCallback": function (settings) {
                        var api = this.api();
                        var rows = api.rows({page: 'current'}).nodes();
                        var last = null;
                        api.column(1, {page: 'current'}).data().each(function (group, i) {
                            if (last !== group) {
                                $(rows).eq(i).before(
				    '<tr class="group"><td class="blueBorder blueBodyTD" style="font-size: 14px; background-color: lightgray;" colspan="2"><fmt:message key="mobile"/></td><td class="blueBorder blueBodyTD" style="font-size: 16px; color: #a41111;" colspan="4">'
				    + group + '</td></tr>'
				);
                                last = group;
                            }
                        });
                    }
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
            function submitForm() {
                document.CampClientsLoads.action = "<%=context%>/AppointmentServlet?op=reenteredClients";
                document.CampClientsLoads.submit();
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
        <form name="CampClientsLoads" method="post">
            <fieldset class="set" style="width: 85%; border-color: #006699;">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">
                            <fmt:message key="existingClients"/>
                            </font>
                        </td>
                    </tr>
                </table>
                <br/>
                <table class="blueBorder" align="CENTER" dir="<fmt:message key="direction"/>" id="code" width="30%" style="border-width: 1px; border-color: white; display: block;">
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b><font size=3 color="white"> 
                                <fmt:message key="fromDate"/></font></b>
                        </td>
                        <td  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b><font size=3 color="white"> 
                                <fmt:message key="toDate"/>
                            </b>
                        </td>
                    </tr>

                    <tr>
                        <td  bgcolor="#dedede" valign="middle" >
                            <input type="text" style="width:190px" ID="startDate" name="startDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("startDate") == null ? nowDate : request.getAttribute("startDate")%>"/>
                        </td>
                        <td  bgcolor="#dedede" valign="middle" width="30%">
                            <input type="text" style="width:190px" ID="endDate" name="endDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("endDate") == null ? nowDate : request.getAttribute("endDate")%>"/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=3 color="white"> 
                                <fmt:message key="group"/></font></b>
                        </td>
                    </tr>
                    
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <select style="font-size: 14px;font-weight: bold; width: 250px;" name="groupId" id="groupId">
                                <sw:WBOOptionList wboList='<%=groupsList%>' displayAttribute="groupName" valueAttribute="groupID" scrollToValue="<%=groupId%>"/>
                            </select>
                        </td>
                    </tr>
                </table>
                <br/>
                <button class="button" type="button" onclick="JavaScript: submitForm();"   STYLE="color: #27272A;font-size:15;margin-top: 20px;font-weight:bold; "><fmt:message key="print"/><IMG HEIGHT="15" SRC="images/search.gif"> </button>
                <br><br>


                <% if (clients != null && clients.size() > 0) {%>
                <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
                    <table ALIGN="center" dir=<fmt:message key="direction"/> WIDTH="100%" id="clients" style="">
                        <thead>
                            <tr>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="clientname"/>  </th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="mobile"/>  </th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="interPhone"/>  </th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="source"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="resp"/></th>
                                <th style="color: #005599 !important;font: 14px; font-weight: bold;"><fmt:message key="inDate"/></th>
                            </tr>
                        </thead>

                        <tbody>
                            <% for (WebBusinessObject wbo : clients) {
                            %>
                            <tr style="cursor: pointer" id="row">
                                <td>
                                    <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("id")%>">
                                        <%=wbo.getAttribute("name")%>
                                    </a>
                                </td>
                                <td>
                                    <%=wbo.getAttribute("mobile") != null ? wbo.getAttribute("mobile") : ""%>
                                </td>
                                <td>
                                    <%=wbo.getAttribute("interPhone") != null && !"UL".equals(wbo.getAttribute("interPhone")) ? wbo.getAttribute("interPhone") : ""%>
                                </td>
                                <td>
                                    <%=wbo.getAttribute("sourceName")%>
                                </td>
                                <td>
                                    <%=wbo.getAttribute("currentOwnerName") != null ? wbo.getAttribute("currentOwnerName") : "لا يوجد"%>
                                </td>
                                <td>
                                    <%=wbo.getAttribute("eventTime") != null ? ((String) wbo.getAttribute("eventTime")).substring(0, 16) : "---"%>
                                </td>
                            </tr>
                            <%}%>
                        </tbody>
                    </table>
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