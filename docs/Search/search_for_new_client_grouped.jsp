<%@page import="java.util.Vector"%>
<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="java.util.List"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String data = (String) request.getAttribute("data");
    System.out.println(data);
    ArrayList<WebBusinessObject> usersList = (ArrayList<WebBusinessObject>) request.getAttribute("usersList");
    ArrayList<WebBusinessObject> groupsList = (ArrayList<WebBusinessObject>) request.getAttribute("groupsList");
    String beDate = (String) request.getAttribute("beginDate");
    String eDate = (String) request.getAttribute("endDate");
    String senderID = (String) request.getAttribute("senderID");
    String groupID = (String) request.getAttribute("groupID");
    String descriptionValue = (String) request.getAttribute("description");
    Calendar cal = Calendar.getInstance();
    String jDateFormat = "yyyy/MM/dd HH:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowTime = sdf.format(cal.getTime());
    cal = Calendar.getInstance();
    cal.add(Calendar.MONTH, -1);
    int a = cal.get(Calendar.YEAR);
    int b = (cal.get(Calendar.MONTH)) + 1;
    int d = cal.get(Calendar.DATE);
    String prev = a + "/" + b + "/" + d + " 00:00";
    String timeFormat = "yyyy/MM/dd HH:mm";
    sdf = new SimpleDateFormat(timeFormat);
    String reportType = "total";
    if (request.getAttribute("reportType") != null) {
        reportType = (String) request.getAttribute("reportType");
    }
    // String stat = "En";
    String dir = null;
    String stat = (String) request.getSession().getAttribute("currentMode");
    String title, beginDate, endDate, detail, total, reportTypeStr;
    String source, responsible, all, searchButton, description,distrDate;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "New Client Grouped";
        beginDate = "From Date";
        endDate = "To Date";
        description = "Description";
        source = "Distributor";
        responsible = "Group";
        all = "All";
        searchButton = "Search";
        detail = "Detail";
        total = "Total";
        reportTypeStr = "Report Type";
        distrDate="Distribuation Date";
    } else {
        dir = "RTL";
        title = "تقرير عميل جديد بالمجموعة";
        beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        description = "البحث بالوصف";
        source = "الموزع";
        responsible = "المجموعة";
        all = "الكل";
        searchButton = "بحث";
        detail = "تفصيلي";
        total = "أجمالي";
        reportTypeStr = "نوع التقرير";
        distrDate="تاريخ التوزيع";

    }
    
	WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

	GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
	Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
	ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
        }
%>
<html>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   

        <LINK REL="stylesheet" type="text/css" href="css/CSS.css"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" href="js/rateit/rateit.css"/>
        <link rel="stylesheet" href="js/jquery/api/jquery.datetimepicker.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery.datetimepicker.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.rowsGroup.js"></script>
        <script type="text/javascript" language="javascript" src="js/rateit/jquery.rateit.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>

        <SCRIPT LANGUAGE="JavaScript" type="text/javascript">
            $(function () {
                $("#beginDate, #endDate").datetimepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd",
                    timeFormat: "HH:mm"
                });
            });

            $(document).ready(function () {
                getGroupUsers(true);
                var data = <%=data%>;
                var Str, counter = 0;
                var table = $('#clients').DataTable({
                    "aLengthMenu": [[10, 25, 50, -1], [10, 25, 50, "All"]],
                    iDisplayLength: 10,
                    iDisplayStart: 0,
                    columns: [
                <%
                    if ("detail".equals(reportType)) {
                %>
                        
                <%
                } else {
                %>          
                        {
                            title: 'المجموعة',
                            name: 'group'
                        },
                        {
                            title: 'عدد العملاء',
                            name: 'source'
                        }
                <%
                    }
                %>
                        
                    ],
                   <%
                    if ("detail".equals(reportType)) {
                %> "aoColumns" : 
                [
            {
                mData :'CREATED_BY_NAME',
                'render' : function (data, type, full, meta) {
                    return  data;
                }
            },
            {
                mData :'CUSTOMER_NAME',
                'render' : function (data, type, full, meta) {
                    return  data;
                }
            },
            {
                mData :'CLIENT_MOBILE',
                'render' : function (data, type, full, meta) {
                    return  data;
                }
            },
            {
                mData :'INTER_PHONE',
                'render' : function (data, type, full, meta) {
                    return  data;
                }
            },
            {
                mData :'RATE_NAME',
                'render' : function (data, type, full, meta) {
                    return  data;
                }
            },
            {
                mData :'SEASON_NAME',
                'render' : function (data, type, full, meta) {
                    return  data;
                }
            },
            {
                mData :'CAMPAIGN_TITLE',
                'render' : function (data, type, full, meta) {
                    return  data;
                }
            },
            {
                mData :'GROUP_NAME',
                'render' : function (data, type, full, meta) {
                    return  data;
                }
            }
            
                ],<%
                }
                %>
                    data: data,
                    pageLength: '25',
                     
                    "fnRowCallback": function (nRow, data, iDisplayIndex, iDisplayIndexFull) {
                        $('td', nRow).eq(7).css("border-bottom", "none");
                        
                        
                        if(iDisplayIndex == 0){
                            Str = data["GROUP_NAME"];
                        } else {
                            if (data["GROUP_NAME"] == Str)
                            {
                                $('td', nRow).eq(7).css("border-top", "none");
                                $('td', nRow).eq(7).text("");
                            } else {
                                $('td', nRow).eq(7).css("rowspan", "3");
                            }
                            Str = data["GROUP_NAME"];
                        }
                        
                    }
                });
                
                table.order( [ 7, 'desc' ] ).draw();
                console.log(" table = ");
                    console.log(table);
            });
            function getComplaints() {
                var beginDate = $("#beginDate").val();
                var endDate = $("#endDate").val();
                var description = $("#description").val();
                var senderID = $("#senderID").val();
                var groupID = $("#groupID").val();
                if ((beginDate === null || beginDate === "")) {
                    alert("من فضلك أدخل تاريخ البداية");
                }
                else if ((endDate === null || endDate === "")) {
                    alert("من فضلك أدخل تاريخ النهاية");

                } else {
                    document.COMP_FORM.action = "<%=context%>/SearchServlet?op=searchNewClientsGroup&beginDate=" + beginDate + "&endDate=" + endDate + "&description=" + description + "&senderID=" + senderID + "&groupID=" + groupID;
                    document.COMP_FORM.submit();
                }
            }
            function exportToExcel() {
                var url = "<%=context%>/SearchServlet?op=exportNewClientsGroup&beginDate=" + $("#beginDate").val()
                        + "&endDate=" + $("#endDate").val() + "&description=" + $("#description").val()
                        + "&senderID=" + $("#senderID").val() + "&groupID=" + $("#groupID").val()
                        + "&reportType=" + $("input[name='reportType']:checked").val();
                window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
            }
            
            
            function getGroupUsers(isPost) {
                var groupID = $("#groupID").val();
                console.log("groupID "+groupID);
                $.ajax({
                    type: "post",
                    url: "<%=context%>/UsersServlet?op=getGroupUsers",
                    data: {
                        groupID: groupID
                    },
                    success: function (jsonString) {
                        try {
                            var output = [];
//                            output.push('<option value="">' + 'الكل' + '</option>');
                            var userID = $("#senderID");
                            $(userID).html("");
                            var info = $.parseJSON(jsonString);
                            output.push('<option value="">all</option>');
                            for (i = 0; i < info.length; i++) {
                                var item = info[i];
                                var senderID = '<%=senderID%>';
                                if(senderID == item.userId ){
                                    output.push('<option value="' + item.userId + '" selected>' + item.fullName + '</option>');
                                } else {
                                    output.push('<option value="' + item.userId + '">' + item.fullName + '</option>');
                                }
                            }
                            userID.html(output.join(''));
                            if (isPost && '' !== '<%=userID%>') {
                                $("#senderID").val('<%=userID%>');
                            }
                        } catch (err) {
                        }
                    }
                });
            }
        </script>
        <style>
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;

                background: #7abcff; /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
            }
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
            .titleRow {
                background-color: orange;
            }
            .login  h1 {
                font-size: 16px;
                font-weight: bold;
                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 96%;
                margin-left: auto;
                margin-right: auto;
                text-height: 30px;
                color: black;
                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #FFBB00;
                /*background: #cc0000;*/
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
            .num{background: #ffc578; /* Old browsers */
                 background: -moz-linear-gradient(top,  #ffc578 0%, #fb9d23 100%); /* FF3.6+ */
                 background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#ffc578), color-stop(100%,#fb9d23)); /* Chrome,Safari4+ */
                 background: -webkit-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* Chrome10+,Safari5.1+ */
                 background: -o-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* Opera 11.10+ */
                 background: -ms-linear-gradient(top,  #ffc578 0%,#fb9d23 100%); /* IE10+ */
                 background: linear-gradient(to bottom,  #ffc578 0%,#fb9d23 100%); /* W3C */
                 filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffc578', endColorstr='#fb9d23',GradientType=0 ); /* IE6-9 */
                 font-weight: bold
            }
        </style>
    </head>
    <body>
        <form NAME="COMP_FORM" METHOD="POST">
            <table align="center" width="80%">
                <tr>
                    <td class="td">
                        <fieldset >
                            <legend align="center">
                                <table dir="rtl" align="center">
                                    <tr>
                                        <td class="td">
                                            <font color="blue" size="6"> <%=title%>
                                            </font>
                                        </td>
                                    </tr>
                                </table>
                            </legend>
                            <table align="center" dir="rtl" width="570" cellspacing="2" cellpadding="1">
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                                        <b><font size=3 color="white"> <%=beginDate%></b>
                                    </td>
                                    <td   class="blueBorder blueHeaderTD" style="font-size:18px;"width="50%">
                                        <b> <font size=3 color="white"> <%=endDate%> </b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <%
                                            Calendar c = Calendar.getInstance();
                                        %>
                                        <% if (beDate != null && !beDate.isEmpty()) {%>

                                        <input id="beginDate" name="beginDate" type="text" value="<%=beDate%>" readonly title="<%=distrDate%>"/><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="beginDate" name="beginDate" type="text" value="<%=prev%>" readonly title="<%=distrDate%>"/><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>
                                    <td bgcolor="#dedede" style="text-align:center" valign="middle">
                                        <% if (eDate != null && !eDate.isEmpty()) {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=eDate%>" readonly title="<%=distrDate%>" /><img src="images/showcalendar.gif" > 
                                        <%} else {%>
                                        <input id="endDate" name="endDate" type="text" value="<%=nowTime%>" readonly  title="<%=distrDate%>" /><img src="images/showcalendar.gif" > 
                                        <%}%>
                                        <br><br>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="50%">
                                        <b><font size=3 color="white"><%=source%></b>
                                    </td>
                                    <td   class="blueBorder blueHeaderTD" style="font-size:18px;"width="50%">
                                        <b> <font size=3 color="white"><%=responsible%></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                                        <!--<select style="font-size: 14px;font-weight: bold;" id="senderID" >
                                            <option value=""><%=all%></option>
                                            <sw:WBOOptionList wboList='<%=usersList%>' displayAttribute = "fullName" valueAttribute="userId" scrollToValue="<%=senderID%>"/>
                                        </select>-->
                                        <select id="senderID" name="senderID" style="font-size: 14px;font-weight: bold;width: 60%" >
                                        </select>
                                        <br/>
                                    </td>
                                    <td bgcolor="#dedede" style="text-align:center" valign="middle">
                                        <select style="font-size: 14px;font-weight: bold;" id="groupID" onchange="JavaScript: getGroupUsers(false);">
                                            <sw:WBOOptionList wboList='<%=groupsList%>' displayAttribute = "groupName" valueAttribute="groupID" scrollToValue="<%=groupID%>"/>
                                        </select>
                                        <br/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                                        <b><font size=3 color="white"> <%=description%></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td bgcolor="#dedede" style="text-align:center" valign="middle" colspan="2">
                                        <input type="text" name="description" id="description" value="<%=descriptionValue != null ? descriptionValue : ""%>"
                                               style="width: 500px; background-color: #FBEC88;"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                                        <b><font size=3 color="white"><%=reportTypeStr%></b>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" bgcolor="#dedede" valign="middle" colspan="2">
                                        <input type="radio" name="reportType" value="total" <%=reportType.equals("total") ? "checked" : ""%>/><%=total%>
                                        <input type="radio" name="reportType" value="detail" <%=reportType.equals("detail") ? "checked" : ""%>/><%=detail%>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align:center" class="td" colspan="3">
                                        <br/><br/>
                                        <button  onclick="JavaScript: getComplaints();" style="color: #27272A;font-size:15;margin-top: 20px;font-weight:bold; "><%=searchButton%><IMG HEIGHT="15" SRC="images/search.gif" ></button>  
                                        &nbsp;&nbsp;
                                        <button type="button" STYLE="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>; color: #27272A;font-size:15;margin-top: 20px;font-weight:bold;"
                                                onclick="exportToExcel()">Excel<IMG HEIGHT="15" SRC="images/search.gif" />
                                        </button>
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                </tr></td ></table>
        </form>
        <% if (data != null && !data.isEmpty()) {%>
        <div style="width: 80%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
            <TABLE WIDTH="100%" ALIGN="center " DIR="RTL" CELLPADDING="0" CELLSPACING="0" id="clients">  
                <%
                    if ("detail".equals(reportType)) {
                %>
                    <thead>
                        <tr>
                            <th>المصدر</th>
                            <th>اسم العميل</th>
                            <th>المحمول</th>
                            <th>الدولي</th>
                            <th>التصنيف</th>
                            <th>عرفتنا عن طريق</th>
                            <th>الحملة</th>
                            <th>المجموعة</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td id="groupName" style="border-bottom: none; border-top: none;"></td>
                        </tr>
                    </tbody>
                <%}%>
            </table>
        </div>
        <%
        } else if (data != null && data.equals("")) {
        %>
        <b style="color: red; font-size: x-large;">لا يوجد نتائج للبحث</b>
        <%
            }
        %>
        <input type="hidden" id="clientId" value="1"/>
        
    </body>
</html>     