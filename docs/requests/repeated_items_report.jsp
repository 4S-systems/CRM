<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.maintenance.db_access.IssueDocumentMgr"%>
<%@page import="com.maintenance.db_access.ProjectsByGroupMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.maintenance.db_access.IssueByComplaintAllCaseMgr"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    List<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    Calendar calendar = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    if (beDate == null || eDate == null) {
        eDate = sdf.format(calendar.getTime());
        calendar = Calendar.getInstance();
        calendar.add(Calendar.MONTH, -1);
        int yaer = calendar.get(Calendar.YEAR);
        int month = (calendar.get(Calendar.MONTH)) + 1;
        int day = calendar.get(Calendar.DATE);
        beDate = yaer + "/" + month + "/" + day;
    }

    String stat = "Ar";
    String dir = null;
    String title, beginDate, endDate;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Repeated Items";
        beginDate = "From Date";
        endDate = "To Date";
    } else {
        dir = "RTL";
        title = "بنود اﻷعمال المكررة";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
    }
%>
<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   

        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: "yy/mm/dd"
                });
            });

            $(document).ready(function () {
                $("#items").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "iDisplayLength": 10,
                    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    "destroy": true
                }).fadeIn(2000);
            });

            function getItems() {
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                if ((beginDate == null || beginDate == "")) {
                    alert("من فضلك أدخل تاريخ البداية");
                } else if ((endDate == null || endDate == "")) {
                    alert("من فضلك أدخل تاريخ النهاية");
                } else {
                    document.ITEM_FORM.action = "<%=context%>/RequestItemServlet?op=getRepeatedUnitItems&beginDate=" + beginDate + "&endDate=" + endDate;
                    document.ITEM_FORM.submit();
                }
            }

            var divGallaryTag;
            function openRepeatedItemIssuesDialog(unitName, itemID) {
                divGallaryTag = $("div[name='divGallaryTag']");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/RequestItemServlet?op=getRepeatedItemIssues',
                    data: {
                        unitName: unitName,
                        itemID: itemID
                    },
                    success: function (data) {
                        divGallaryTag.html(data)
                                .dialog({
                                    modal: true,
                                    title: "عرض الطلبات",
                                    show: "fade",
                                    hide: "explode",
                                    width: 950,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Done: function () {
                                            divGallaryTag.dialog('close');
                                        }
                                    }
                                })
                                .dialog('open');
                    },
                    error: function (data) {
                        alert(data);
                    }
                });
            }
        </script>
        <style type="text/css">
        </style>
    </head>
    <body>
        <div name="divGallaryTag"></div>
        <form name="ITEM_FORM" method="post">
            <table align="center" width="98%">
                <tr>
                    <td class="td">
                        <FIELDSET class="set" style="width:98%;border-color: #006699">
                            <table align="center" width="98%" cellpadding="0" cellspacing="0" style="">
                                <tr>
                                    <td class="titlebar" style="text-align: center">
                                        <img width="40" height="40" src="images/icons/request.png" style="vertical-align: middle;"/> &nbsp;<font color="#005599" size="4"><%=title%></font>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <table align="center" dir="rtl" width="60%" cellspacing="2" cellpadding="1">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="40%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </td>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="40%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <input id="beginDate" readonly name="beginDate" type="text" value="<%=beDate%>" /><img src="images/showcalendar.gif" >                 
                                        <br><br>
                                    </td>
                                    <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                                        <input id="endDate" readonly name="endDate" type="text" value="<%=eDate%>" ><img src="images/showcalendar.gif" > 
                                        <br><br>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center; margin-bottom: 5px; margin-top: 5px" bgcolor="#dedede" colspan="2">
                                        <button type="button" onclick="JavaScript: getItems();" style="color: #000;font-size:15px;margin-top: 8px;margin-bottom: 8px;font-weight:bold; width: 150px">بحث<IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <div id="loading" class="container" style="display: none">
                                <div class="contentBar">
                                    <div id="block_1" class="barlittle"></div>
                                    <div id="block_2" class="barlittle"></div>
                                    <div id="block_3" class="barlittle"></div>
                                    <div id="block_4" class="barlittle"></div>
                                    <div id="block_5" class="barlittle"></div>
                                </div>
                            </div>
                            <br/>
                            <br/>
                            <br/>
                            <% if (data != null && !data.isEmpty()) {%>
                            <center>
                                <div style="width: 60%">
                                    <table class="display" id="items" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="40%"><b>كود الوحدة</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="4%"><b>بند اﻷعمال</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "12px" : "14px"%>; font-weight: bold" width="20%"><b>عدد التكرارات</b></TH>
                                            </tr>
                                        </thead> 
                                        <tbody>
                                            <%
                                                for (WebBusinessObject wbo : data) {
                                            %>
                                            <tr id="row">
                                                <td nowrap>
                                                    <a href="JavaScript: openRepeatedItemIssuesDialog('<%=wbo.getAttribute("unitName")%>', '<%=wbo.getAttribute("itemID")%>')">
                                                        <b><%=wbo.getAttribute("unitName")%></b>
                                                    </a>
                                                </td>
                                                <td nowrap>
                                                    <a href="JavaScript: openRepeatedItemIssuesDialog('<%=wbo.getAttribute("unitName")%>', '<%=wbo.getAttribute("itemID")%>')">
                                                        <b><%=wbo.getAttribute("itemName")%></b>
                                                    </a>
                                                </td>
                                                <td nowrap>
                                                    <a href="JavaScript: openRepeatedItemIssuesDialog('<%=wbo.getAttribute("unitName")%>', '<%=wbo.getAttribute("itemID")%>')">
                                                        <b><%=wbo.getAttribute("num")%></b>
                                                    </a>
                                                </td>
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </center>
                            <br/>
                            <br/>
                            <% }%>
                        </fieldset>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>     
