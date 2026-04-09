<%@page import="java.math.BigDecimal"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<html>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">    

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        
        String beginDate = (String) request.getAttribute("beginDate");
        String endDate = (String) request.getAttribute("endDate");
        String rateID = request.getAttribute("rateID") != null ? (String) request.getAttribute("rateID") : "";
        String groupID = request.getAttribute("groupID") != null ? (String) request.getAttribute("groupID") : "";
        String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";

        ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
        ArrayList<WebBusinessObject> ratesList = (ArrayList<WebBusinessObject>) request.getAttribute("ratesList");
        ArrayList<WebBusinessObject> groups = (ArrayList<WebBusinessObject>) request.getAttribute("groups");
        
        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
        } else {
            align = "center";
            dir = "RTL";
        }
    %>
    <head>
        <TITLE>System Users List</TITLE>
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="css/chosen.css"/>

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <link href="js/select2.min.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" language="javascript" src="js/select2.min.js"></script>
        <script src="js/chosen.jquery.js" type="text/javascript"></script>
        <script src="js/docsupport/prism.js" type="text/javascript" charset="utf-8"></script>
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
            .remove{
                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);
            }
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 500;
                top: 0px;
                left: 0px;
                position: fixed;
            }
            .img:hover{
                cursor: pointer ;
            }

            #mydiv {
                text-align:center;
            }
        </style>

        <script type="text/javascript">
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    maxDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });

            var oTable;
            $(document).ready(function () {
                $("#Employee").css("display", "none");
                oTable = $('#Employee').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                }).fadeIn(2000);
            });

            function getResults() {
                $("#Emplyee").css("display", "");
                $("#showResults").val("show");
                
                document.stat_form.action = "<%=context%>/AppointmentServlet?op=viewDataCetnerClientStatistic";
                document.stat_form.submit();
            }
            function getGroupUsers(isPost) {
                var groupID = $("#groupID").val();
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
                            var userID = $("#userID");
                            $(userID).html("");
                            var info = $.parseJSON(jsonString);
                            for (i = 0; i < info.length; i++) {
                                var item = info[i];
                                output.push('<option value="' + item.userId + '">' + item.fullName + '</option>');
                            }
                            userID.html(output.join(''));
                            if (isPost && '' !== '<%=userID%>') {
                                $("#userID").val('<%=userID%>');
                            }
                        } catch (err) {
                        }
                    }
                });
            }
        </script>
    </head>

    <body>
        <fieldset class="set" style="width:95%; border-color: #006699;">
            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td width="100%" class="titlebar">
                        <font color="#005599" size="4">إحصائيات مكالمات العملاء</font>
                    </td>
                </tr>
            </table>
            <br/>
            <FORM NAME="stat_form" METHOD="POST">
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="50%" CELLPADDING="0" CELLSPACING="0" STYLE="border: 2px solid #d3d5d4">
                    <TR>
                        <TD width="8%" STYLE="text-align: center; color: blue; font-size: 16px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <DIV> 
                                عرض خلال 
                            </DIV>
                        </TD>
                        <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            من تاريخ :
                        </TD>
                        <TD width="9%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <input id="beginDate" name="beginDate" type="text" value="<%=beginDate%>" style="margin: 5px; width: 100px;" readonly />
                        </TD>
                        <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            الى تاريخ :
                        </TD>
                        <TD width="15%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <input id="endDate" name="endDate" type="text" value="<%=endDate%>" style="margin: 5px; width: 100px;" readonly />
                        </TD>
                        <TD width="3%" STYLE="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            التصنيف :
                        </TD>
                        <TD width="15%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <select name="rateID" id="rateID" style="width: 150px;" class="chosen-select-rate">
                                <option value="">الكل</option>
                                <sw:WBOOptionList wboList="<%=ratesList%>" valueAttribute="projectID" displayAttribute="projectName" scrollToValue="<%=rateID%>"/>
                            </select>
                        </TD>
                        <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            المجموعة
                        </td>
                        <td style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            <select id="groupID" name="groupID" style="font-size: 14px; width: 150px;"
                                    onchange="JavaScript: getGroupUsers(false);">
                                <%if (!groups.isEmpty()){%>
                                    <sw:WBOOptionList wboList="<%=groups%>" displayAttribute="groupName" valueAttribute="group_id" scrollToValue="<%=groupID%>" />
                                <%} else {%>
                                    <option>لا يوجد مجموعات</option>
                                <%}%>
                            </select>
                        </td>
                        <td width="3%" style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            الموظف
                        </td>
                        <td style="text-align: right; color: black; font-size: 14px; padding-left: 5px; border-left-width: 0px" nowrap class="silver_even_main" >
                            <select id="userID" name="userID" style="font-size: 14px; width: 150px;">
                            </select>
                        </td>

                        <TD width="9%" STYLE="text-align: right; color: blue; font-size: 14px; padding-left: 10px; border-left-width: 0px" nowrap CLASS="silver_even_main" >
                            <button style="width: 100px" type="button" onclick="javascript:getResults();"><b style="font-weight: bold; font-size: 14px; vertical-align: middle">عرض</b>&ensp;<img src="images/icons/refresh.png" width="20" height="20" style="vertical-align: middle"/></button>
                        </TD>
                    </tr>
                </table>
            </form>

            <br/>

            <%if (data != null) {%>
            <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showResults">
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="Employee" style="">
                    <thead>
                        <tr>
                            <th style="width: 2%;"></th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;">اسم العميل</th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;"> تصنيف العميل </th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;"> تصنيف بواسطة</th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;">عدد المكالمات</th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;">المتكرر</th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;">عدد المقابلات</th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;">المتكرر</th>
                        </tr>
                    <thead>
                    <tbody >  
                        <%
                            int callCount = 0, meetingCount = 0, callVal, meetingVal;
                            for (WebBusinessObject wbo : data) {
                                callVal = ((BigDecimal) wbo.getAttribute("call")).intValueExact();
                                if (callVal != 0) {
                                    callCount += (callVal - 1);
                                }
                                meetingVal = ((BigDecimal) wbo.getAttribute("meeting")).intValueExact();
                                if (meetingVal != 0) {
                                    meetingCount += (meetingVal - 1);
                                }
                        %>
                        <tr>
                            <TD style="width: 2%;">
                                <a target="_blanck" href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=wbo.getAttribute("CLIENT_ID")%>">
                                    <img src="images/client_details.jpg" width="30" title="تفاصيل"/>
                                </a>
                            </TD>
                            <TD style="width: 20%;">
                                <%=wbo.getAttribute("CLIENT_NAME")%>
                            </TD>

                            <TD style="width: 10%;">
                                <%=wbo.getAttribute("rate")%>
                            </TD>

                            <TD style="width: 20%;">
                                <%=wbo.getAttribute("fullName")%>
                            </TD>

                            <TD style="width: 10%;">
                               <%=callVal%>
                            </TD>

                            <td style="width: 10%; background-color: #fed198;">
                                <%=callVal != 0 ? callVal - 1 : "0"%>
                            </td>

                            <TD style="width: 10%;">
                                <%=meetingVal%>
                            </TD>

                            <td style="width: 10%; background-color: #c5fdbe;">
                                <%=meetingVal != 0 ? meetingVal - 1 : "0"%>
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>  
                    <tfoot>
                        <tr>
                            <th colspan="4">
                                &nbsp;
                            </th>
                            <th>
                                إجمالي
                            </th>
                            <th>
                                <%=callCount%>
                            </th>
                            <th>
                                &nbsp;
                            </th>
                            <th>
                                <%=meetingCount%>
                            </th>
                        </tr>
                    </tfoot>
                </TABLE>
            </div>
            <%}%>
            <br/>
        </fieldset>
        <script>
            var config = {
                '.chosen-select-campaign': {no_results_text: 'No campaign found with this name!'},
                '.chosen-select-rate': {no_results_text: 'No classification found with this name!'}
            };
            for (var selector in config) {
                $(selector).chosen(config[selector]);
            }
            getGroupUsers(true);
        </script>
    </body>
</html>