<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String[] clientsAttributes = {"name", "mobile", "phone", "statusName"};
        String[] clientsListTitles = new String[5];
        int s = clientsAttributes.length;
        int t = s + 1;
        String attName = null;
        String attValue = null;
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
        Calendar c = Calendar.getInstance();
        String beginDate;
        if (request.getAttribute("beginDate") != null) {
            beginDate = (String) request.getAttribute("beginDate");
        } else {
            beginDate = sdf.format(c.getTime());
        }
        c.add(Calendar.MONTH, 1);
        String endDate;
        if (request.getAttribute("endDate") != null) {
            endDate = (String) request.getAttribute("endDate");
        } else {
            endDate = sdf.format(c.getTime());
        }
        String status = (String) request.getAttribute("status");
        ArrayList<WebBusinessObject> clientsList = (ArrayList<WebBusinessObject>) request.getAttribute("clientsList");
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null, xAlign;
        String dir = null;
        String clientsNo, title, savePlan, period, dateMsg, planTitle;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            clientsListTitles[0] = "Client Name";
            clientsListTitles[1] = "Mobile";
            clientsListTitles[2] = "Phone";
            clientsListTitles[3] = "Status";
            clientsListTitles[4] = "Rating";
            clientsNo = "Clients No.";
            title = "Internal Campagins";
            savePlan = "Save";
            period = "Follow in";
            dateMsg = "\"From Date must be greater than or equal \"To Date\"";
            planTitle = "Campagin Title";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            clientsListTitles[0] = "اسم العميل";
            clientsListTitles[1] = "موبايل";
            clientsListTitles[2] = "هاتف";
            clientsListTitles[3] = "الحالة";
            clientsListTitles[4] = "التقييم";
            clientsNo = "عدد العملاء";
            title = "الحملات الداخلية";
            savePlan = "حفظ";
            period = "متابعة كل";
            dateMsg = "\"ألي تاريخ\" يجب أن يكون أكبر من أو يساوي \"من تاريخ\"";
            planTitle = "عنوان الحملة";
        }
    %>
    <HEAD>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" href="js/rateit/rateit.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/rateit/jquery.rateit.min.js"></script>
        <script type="text/javascript">
            var oTable;
            var users = new Array();
            var divID;
            $(document).ready(function () {
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true

                }).fadeIn(2000);
            });
            $(function () {
                $("#beginDate, #endDate").datepicker({
                    changeMonth: true,
                    changeYear: true,
                    minDate: 0,
                    dateFormat: "yy/mm/dd"
                });
            });
            function selectAll(obj) {
                $("input[name='clientID']").prop('checked', $(obj).is(':checked'));
            }
            function submitForm() {
                if (!compareDate()) {
                    alert('<%=dateMsg%>');
                } else if (!validateData("req", this.CALLING_PLAN_FORM.frequencyRate, "أدخل معدل التكرار") ||
                        !validateData("numeric", this.CALLING_PLAN_FORM.frequencyRate, "أدخل رقم صحيح")) {
                    this.CALLING_PLAN_FORM.frequencyRate.focus();
                } else if (!validateData("req", this.CALLING_PLAN_FORM.planTitle, "أدخل عنوان الخطة")) {
                    this.CALLING_PLAN_FORM.planTitle.focus();
                } else if ($("input[name='clientID']:checked").length === 0) {
                    alert("يجب أختيار عميل واحد علي الأقل");
                } else {
                    document.CALLING_PLAN_FORM.submit();
                }
            }
            function compareDate() {
                return Date.parse(document.getElementById("endDate").value) >= Date.parse(document.getElementById("beginDate").value);
            }
            function getClientCampaigns(clientID) {
                var div = $('#client_campaigns');
                $.ajax({
                    type: "post",
                    url: '<%=context%>/ClientServlet?op=getClientCampaigns',
                    data: {
                        clientID: clientID
                    },
                    success: function (data) {
                        div.html(data)
                                .dialog({
                                    modal: true,
                                    title: "حملات العميل",
                                    show: "fade",
                                    hide: "explode",
                                    width: 500,
                                    position: {
                                        my: 'center',
                                        at: 'center'
                                    },
                                    buttons: {
                                        Done: function () {
                                            div.dialog('close');
                                        }
                                    },
                                    close: function () {
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
                -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 0.67);
                -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 0.67);
                box-shadow:         0px 0px 17px rgba(255, 255, 255, 0.67);
                -webkit-border-radius: 20px;
                -moz-border-radius: 20px;
                border-radius: 20px;
            }
            .remove__{
                width:20px;
                height:20px;
                background-image:url(images/icons/remove1.png);
                background-position: bottom;
                background-repeat: no-repeat;
                cursor: pointer;
                margin-right: auto;
                margin-left: auto;
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
                color: #ffffff;
                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #cc0000;
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
            .login-input {
                width: 100%;
                height: 23px;
                padding: 0 9px;
                color: #27272A;
                font-size: 13px;
                cursor: auto;
                text-shadow: 0 1px black;
                background: #2b3e5d;
                border: 1px solid #ffffff;
                border-top-color: #0d1827;
                border-radius: 4px;
                background: rgb(249,252,247); /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, rgba(249,252,247,1) 0%, rgba(245,249,240,1) 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(249,252,247,1)), color-stop(100%,rgba(245,249,240,1))); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* IE10+ */
                background: linear-gradient(to bottom, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9fcf7', endColorstr='#f5f9f0',GradientType=0 ); /* IE6-8 */
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
        </style>
    </HEAD>
    <body>
        <div id="client_campaigns">&nbsp;</div>
        <b style="float: <%=xAlign%>; font-size: 16px;color: #005599; font-style: oblique; margin-<%=xAlign%>: 80px;">Internal Campaigns الحملات الداخلية</b>
        <fieldset align=center class="set" style="width: 90%">
            <%
                if ("ok".equalsIgnoreCase(status)) {
            %>
            <table style="margin-left: auto; margin-right: auto;">
                <tr>
                    <td class="td"> 
                        <b>
                            <font size="4" style="color: green;">
                            تم الحفظ بنجاح برقم </font>
                            <font size="4" style="color: red;">
                            <%=request.getAttribute("planCode")%>
                            </font>
                        </b>
                    </td>
                </tr>
            </table>
            <br/>
            <%
            } else if ("no".equalsIgnoreCase(status)) {
            %>
            <table style="margin-left: auto; margin-right: auto;">
                <tr>
                    <td class="td"> 
                        <b>
                            <font size="4" style="color: green;">
                            لم يتم الحفظ
                            </font>
                        </b>
                    </td>
                </tr>
            </table>
            <br/>
            <%
                }
            %>
            <form name="CALLING_PLAN_FORM" action="<%=context%>/ClientServlet?op=generateCallingPlan" method="POST">
                <table ALIGN="center" DIR="RTL" WIDTH="50%" CELLSPACING=2 CELLPADDING=1>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b><font size=3 color="white">بداية الحملة</b>
                        </td>
                        <td   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%">
                            <b> <font size=3 color="white">نهاية الحملة</b>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                            <input id="beginDate" name="beginDate" type="text" value="<%=beginDate%>" style="margin: 5px;" readonly />
                        </td>
                        <td  bgcolor="#dedede"  style="text-align:center" valign="middle">
                            <input id="endDate" name="endDate" type="text" value="<%=endDate%>" style="margin: 5px;" readonly />
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="50%" colspan="2">
                            <b> <font size=3 color="white"><%=period%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede" style="text-align:center" valign="middle" colspan="2">
                            <input type="number" style="width: 100px;" name="frequencyRate" ID="frequencyRate" size="20" value="" maxlength="255"/>
                            <select style="width: 150px; font-size: 15px; font-weight: bold;" name="frequencyType" ID="frequencyType">
                                <option value="1">أسبوع</option>
                                <option value="2">شهر</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b> <font size=3 color="white"><%=planTitle%></b>
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#dedede"  style="text-align:center" valign="middle" colspan="2">
                            <input type="text" style="width: 400px;" name="planTitle" ID="planTitle" size="20" value="" maxlength="255"/>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align:center" bgcolor="#dedede" colspan="2">  
                            <button type="button" onclick="JavaScript: submitForm();" style="color: #27272A;font-size:15px;margin: 5px;font-weight:bold; width: 100px;"><%=savePlan%></button>
                        </td>
                    </tr>
                </table>
                <br>
                <center> <b> <font size="3" color="red"> <%=clientsNo%> : <%=clientsList.size()%> </font></b></center> 
                <br/>
                <div style="width: 70%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" id="clients" style="width:100%;">
                        <thead>
                            <tr>
                                <th>
                                    <input type="checkbox" name="checkAll" onclick="JavaScript: selectAll(this);"/>
                                </th>
                                <%
                                    for (int i = 0; i < t; i++) {
                                %>                
                                <th>
                                    <B><%=clientsListTitles[i]%></B>
                                </th>
                                <%
                                    }
                                %>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                for (WebBusinessObject clientWbo : clientsList) {
                                    attName = clientsAttributes[0];
                                    attValue = (String) clientWbo.getAttribute(attName);
                            %>
                            <tr style="background-color: <%="1".equals(clientWbo.getAttribute("planFlag")) ? "#fbfdba" : ""%>;">
                                <td>
                                    <input type="checkbox" name="clientID" value="<%=clientWbo.getAttribute("id")%>"/>
                                </td>
                                <td>
                                    <div>
                                        <a href="JavaScript: getClientCampaigns('<%=clientWbo.getAttribute("id")%>');"<b><%=attValue%></b>
                                    </div>
                                </td>
                                <%
                                    for (int i = 1; i < s; i++) {
                                        attName = clientsAttributes[i];
                                        attValue = (String) clientWbo.getAttribute(attName);
                                %>
                                <td>
                                    <div>
                                        <b><%=attValue%></b>
                                    </div>
                                </td>
                                <%
                                    }
                                %>
                                <td>
                                    <select id="<%=clientWbo.getAttribute("id")%>" name="rating">
                                        <option value="1" <%="12".equals(clientWbo.getAttribute("currentStatus")) ? "selected=\"selected\"" : ""%>>1</option>
                                        <option value="2" <%="13".equals(clientWbo.getAttribute("currentStatus")) ? "selected=\"selected\"" : ""%>>2</option>
                                        <option value="3" <%="14".equals(clientWbo.getAttribute("currentStatus")) ? "selected=\"selected\"" : ""%>>3</option>
                                        <option value="4" <%="11".equals(clientWbo.getAttribute("currentStatus")) ? "selected=\"selected\"" : ""%>>4</option>
                                    </select>
                                    <div class="rateit" data-rateit-backingfld="#<%=clientWbo.getAttribute("id")%>" data-rateit-resetable="false"
                                         data-rateit-readonly="true"></div>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
                <br/><br/>
            </form>
        </fieldset>
    </body>
</html>
