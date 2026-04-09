<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.maintenance.db_access.ProjectsByGroupMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.maintenance.db_access.IssueByComplaintAllCaseMgr"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@page import="com.silkworm.international.TouristGuide"%>
<%@page import="com.silkworm.util.DateAndTimeConstants"%>
<%@page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE html>

<HTML>
    <HEAD>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" src="js/custom_popup/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>

        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            UserMgr userMgr = UserMgr.getInstance();
            String context = metaMgr.getContext();

            int iTotal = 0;

            WebBusinessObject client = (WebBusinessObject) request.getAttribute("client");
            Vector products = (Vector) request.getAttribute("products");
            Vector reservedUnit = (Vector) request.getAttribute("reservedUnit");
            Vector soldUnits = (Vector) request.getAttribute("soldUnits");
            Vector appointments = (Vector) request.getAttribute("appointments");
            Vector directFollows = (Vector) request.getAttribute("directFollows");
            Vector comments = (Vector) request.getAttribute("comments");
            Vector seasons = (Vector) request.getAttribute("seasons");
            Vector complaints = (Vector) request.getAttribute("complaints");
            WebBusinessObject clientRateWbo = (WebBusinessObject) request.getAttribute("clientRateWbo");
            WebBusinessObject rateWbo = (WebBusinessObject) request.getAttribute("rateWbo");
            WebBusinessObject rateUserWbo = (WebBusinessObject) request.getAttribute("rateUserWbo");
            
            ProjectMgr projectMgr = ProjectMgr.getInstance();
            CampaignMgr campaignMgr = CampaignMgr.getInstance();
            WebBusinessObject tempWbo, tempWbo2;
            
            //Privileges
            SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
            ArrayList<WebBusinessObject> prvType = new ArrayList();
            prvType = securityUser.getComplaintMenuBtn();
            ArrayList<String> privilegesList = new ArrayList<>();
            for (WebBusinessObject wboTemp : prvType) {
                if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                    privilegesList.add((String) wboTemp.getAttribute("prevCode"));
                }
            }
            
            WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

            String stat = "Ar";
            String align = "center";
            String dir = null;
            String style = null, lang, langCode, cancel, title, beginDate, endDate, print;
            String complaintNo, customerName, complaintDate, complaint;
            String sat, sun, mon, tue, wed, thu, fri, view, complaintCode, PN, type, compStatus, compSender, noResponse, ageComp;
            String complStatus, senderName = null, fullName = null, noClientExistMsg;
            if (stat.equals("En")) {
                align = "left";
                dir = "LTR";
                style = "text-align:right";
                lang = "&#1593;&#1585;&#1576;&#1610;";
                langCode = "Ar";
                cancel = "Cancel";
                title = "Complaints Reprot";
                beginDate = "From Date";
                endDate = "To Date";
                print = "Print";
                complaintNo = "Order No.";
                customerName = "Customer name";
                complaintDate = "Calling date";
                complaint = "Complaint";
                sat = "Sat";
                sun = "Sun";
                mon = "Mon";
                tue = "Tue";
                wed = "Wed";
                thu = "Thu";
                fri = "Fri";
                view = "View";
                complaintCode = "Complaint code";
                type = "Type";
                compStatus = "Staus";
                compSender = "Sender";
                noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
                ageComp = "A.C(day)";
                PN = "Requests No.";
                noClientExistMsg = "No Client Exist for this Number or Number is not Valid or you have no Authority to view client's details";
            } else {
                dir = "RTL";
                align = "right";
                style = "text-align:Right";
                lang = "English";
                langCode = "En";
                cancel = "&#1573;&#1606;&#1607;&#1575;&#1569;";
                title = "البحث عن طلب";
                PN = "عدد الطلبات";
                beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
                endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
                print = "&#1591;&#1576;&#1575;&#1593;&#1577; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
                complaintNo = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1578;&#1575;&#1576;&#1593;&#1577;";
                customerName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1593;&#1605;&#1610;&#1604;";
                complaintDate = "&#1608;&#1602;&#1578; &#1575;&#1604;&#1575;&#1578;&#1589;&#1575;&#1604;";
                complaint = "&#1575;&#1604;&#1591;&#1604;&#1576;";
                sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
                sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
                mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
                tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
                wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
                thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
                fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
                view = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
                complaintCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1591;&#1604;&#1576;";
                type = "النوع";
                compStatus = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
                compSender = "&#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604;";
                noResponse = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1583;&#1575;&#1608;&#1604;";
                ageComp = "&#1593;.&#1591; (&#1610;&#1608;&#1605;)";
                noClientExistMsg = "لا يوجد عميل لهذا الرقم أو رقم خطأ أو لا يوجد لك صلاحية لمشاهدة تفاصيل العميل";
            }

            String sDate, sTime = null;
        %>
    </HEAD>

    <style type="text/css">  
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
        
        font {
            font-weight: bold;
        }
    </style>
    <script type="text/javascript">
        function withdrewClient(issueId) {
            var r = confirm("سيتم سحب العميل. أكمال العملية؟");
            if (r === true)
            {
                $.ajax({
                    type: "post",
                    url: "<%=context%>/DatabaseControllerServlet?op=withdrewClientAjax",
                    data: {
                        issueId: issueId
                    },
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'Ok') {
                            alert("تم سحب العميل بنجاح");
                            document.location.reload();
                        } else {
                            alert("لم يتم سحب العميل");
                        }
                    }
                });
            }
        }
    </script>

    <Body>
        <%
            if (client == null) {
        %>
        <b style="color: red">
            <%=noClientExistMsg%>
        </b>
        <%
            } else {
        %>
        <table align="center" width="80%" cellpadding="0" cellspacing="0" style="">
            <tr>
                <td class="titlebar" style="text-align: center">
                    <font color="#005599" size="4" style="font-weight: bold;">السجل التاريخي</font>
                </td>
            </tr>
        </table>
        <br>

        <table id="" class="titlebar" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0">
            <thead>
                <tr>
                    <td style="font-size: 16px; font-weight: bold; border-width: 0px; padding-bottom: 3px; padding-top: 3px; ">
                        <font color="#005599" >بيانات العميل</font></td>
                </tr>
            </thead>
        </table>

        <TABLE class="excelentCell" width="80%" CELLPADDING="0" CELLSPACING="8" ALIGN="center" DIR="rtl" style="background: #FFFF99; ">
            <tr>
                <td style="text-align:Right; padding-right: 5px; width: 10%" >
                    <font color="black" size="3">رقم العميل</font>
                </td>
                <td style="text-align:Right; padding-right: 5px;">
                    <%if (client.getAttribute("clientNO") != null) {%>
                    <label><font color="#005599" size="3"> <%=client.getAttribute("clientNO")%> </font></label>
                        <%} else {%>
                    <label><font color="#005599" size="3"> --- </font></label>
                        <%}%>
                </td>
                <td style="text-align:Right; padding-right: 5px; width: 10%">
                    <font color="black" size="3">رقم البطاقة</font>
                </td>
                <td style="text-align:Right; padding-right: 5px;">
                    <%if (client.getAttribute("clientSsn") != null) {%>
                    <label><font color="#005599" size="3"> <%=client.getAttribute("clientSsn")%> </font></label>
                        <%} else {%>
                    <label><font color="#005599" size="3"> --- </font></label>
                        <%}%>
                </td>
                <td style="text-align:Right; padding-right: 5px; width: 10%" >
                    <font color="black" size="3">المهنة<font>
                </td>
                <td style="text-align:Right; padding-right: 5px; ">
                    <%if (client.getAttribute("jobName") != null) {%>
                    <label><font color="#005599" size="3"> <%=client.getAttribute("jobName")%> </font></label>
                        <%} else {%>
                    <label><font color="#005599" size="3"> --- </font></label>
                        <%}%>
                </td>
            </tr>

            <tr>
                <td style="text-align:Right; padding-right: 5px; width: 10%">
                    <font color="black" size="3">اسم العميل</font>
                </td>
                <td style="text-align:Right; padding-right: 5px; ">
                    <%if (client.getAttribute("name") != null) {%>
                    <label><font color="#005599" size="3"> <%=client.getAttribute("name")%> </font></label>
                        <%} else {%>
                    <label><font color="#005599" size="3"> --- </font></label>
                        <%}%>
                </td>
                <td style="text-align:Right; padding-right: 5px; width: 10%" >
                    <font color="black" size="3">رقم التليفون</font>
                </td>
                <td style="text-align:Right; padding-right: 5px;">
                    <%if (client.getAttribute("phone") != null) {%>
                    <label><font color="#005599" size="3"> <%=client.getAttribute("phone")%> </font></label>
                        <%} else {%>
                    <label><font color="#005599" size="3"> --- </font></label>
                        <%}%>
                </td>
                <td style="text-align:Right; padding-right: 5px; width: 10%">
                    <font color="black" size="3">النوع<font>
                </td>
                <td style="text-align:Right; padding-right: 5px; ">
                    <%if (client.getAttribute("gender") != null) {%>
                    <label><font color="#005599" size="3"> <%=client.getAttribute("gender")%> </font></label>
                        <%} else {%>
                    <label><font color="#005599" size="3"> --- </font></label>
                        <%}%>
                </td>
            </tr>

            <tr>
                <td style="text-align:Right; padding-right: 5px; width: 11%">
                    <font color="black" size="3">اسم الزوجة / الزوج</font>
                </td>
                <td style="text-align:Right; padding-right: 5px; ">
                    <%if (client.getAttribute("partner") != null) {%>
                    <label><font color="#005599" size="3"> <%=client.getAttribute("partner")%> </font></label>
                        <%} else {%>
                    <label><font color="#005599" size="3"> --- </font></label>
                        <%}%>
                </td>
                <td style="text-align:Right; padding-right: 5px; width: 10%" >
                    <font color="black" size="3">رقم الموبايل</font>
                </td>
                <td style="text-align:Right; padding-right: 5px;">
                    <%if (client.getAttribute("mobile") != null) {%>
                    <label><font color="#005599" size="3"> <%=client.getAttribute("mobile")%> </font></label>
                        <%} else {%>
                    <label><font color="#005599" size="3"> --- </font></label>
                        <%}%>
                </td>
                <td style="text-align:Right; padding-right: 5px; width: 10%">
                    <font color="black" size="3">الحاله الاجتماعيه<font>
                </td>
                <td style="text-align:Right; padding-right: 5px;">
                    <%if (client.getAttribute("matiralStatus") != null) {%>
                    <label><font color="#005599" size="3"> <%=client.getAttribute("matiralStatus")%> </font></label>
                        <%} else {%>
                    <label><font color="#005599" size="3"> --- </font></label>
                        <%}%>
                </td>
            </tr>

            <tr>
                <td style="text-align:Right; padding-right: 5px; width: 10%">
                    <font color="black" size="3">العنوان</font>
                </td>
                <td style="text-align:Right; padding-right: 5px;">
                    <%if (client.getAttribute("address") != null) {%>
                    <label><font color="#005599" size="3"> <%=client.getAttribute("address")%> </font></label>
                        <%} else {%>
                    <label><font color="#005599" size="3"> --- </font></label>
                        <%}%>
                </td>
                <td style="text-align:Right; padding-right: 5px; width: 10%">
                    <font color="black" size="3">البريد الالكتروني</font>
                </td>
                <td style="text-align:Right; padding-right: 5px;">
                    <%if (client.getAttribute("email") != null) {%>
                    <label><font color="#005599" size="3"> <%=client.getAttribute("email")%> </font></label>
                        <%} else {%>
                    <label><font color="#005599" size="3"> --- </font></label>
                        <%}%>
                </td>
                <td style="text-align:Right; padding-right: 5px; width: 10%">
                    <font color="black" size="3">تاريخ الميلاد<font>
                </td>
                <td style="text-align:Right; padding-right: 5px;">
                    <%if (client.getAttribute("birthDate") != null) {%>
                    <label><font color="#005599" size="3"> <%=client.getAttribute("birthDate")%> </font></label>
                        <%} else {%>
                    <label><font color="#005599" size="3"> --- </font></label>
                        <%}%>
                </td>
            </TR>

            <tr>
                <td style="text-align:Right; padding-right: 5px; width: 10%" >
                    <font color="black" size="3">يعمل بالخارج</font>
                </td>
                <td style="text-align:Right; padding-right: 5px;">
                    <%
                        String option = "";
                        if ("1".equals(client.getAttribute("option1"))) {
                            option = "نعم";
                        } else {
                            option = "لا";
                        }
                    %>
                    <label><font color="#005599" size="3"> <%=option%> </font></label>
                </td>
                <td style="text-align:Right; padding-right: 5px; width: 10%">
                    <font color="black" size="3">الفئه العمريه<font>
                </td>
                <td style="text-align:Right; padding-right: 5px; border-width: 0px;">
                    <label><font color="#005599" size="3"> <%=client.getAttribute("age")%> </font></label>
                </td>
                <TD style="border-width: 0px;"></TD>
                <TD style="border-width: 1px;  border-right-width: 0px"></TD>
            </TR>

            <tr>
                <td style="text-align:Right; padding-right: 5px; width: 10%">
                    <font color="black" size="3">ملاحظات</font>
                </td>
                <td style="text-align:Right; padding-right: 5px;" colspan="5">
                    <label><font color="#005599" size="3"> <%=client.getAttribute("description") != null ? client.getAttribute("description") : "---"%> </font></label>
                </td>
            </TR>
        </TABLE>
        <br>
        <br>

        <table id="" class="titlebar" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0">
            <thead>
                <tr>
                    <td style="font-size: 16px; font-weight: bold; padding-bottom: 3px; padding-top: 3px; ">
                        <font color="#005599">المشتريات</font></td>
                </tr>
            </thead>
        </table>


        <table  id="requestedItems" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0" style="background: #b9d2ef">
            <thead>
                <tr>
                    <td class="blueBorder backgroundTable" width="30%" ><FONT size="3">الوحدة</FONT></td>
                    <td class="blueBorder backgroundTable" width="30%"><FONT size="3">المشروع</FONT></td>
                </tr>
            </thead>
            <tbody>
                <%
                    if (soldUnits.size() > 0 && soldUnits != null) {
                        for (int i = 0; i < soldUnits.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) soldUnits.get(i);
                %>
                <TR>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("productName")%> </font></label>
                    </TD>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("productCategoryName")%> </font></label>
                    </TD>
                </TR>
                <%
                    }
                } else {%>  
                <TR>
                    <td style="text-align:Center; padding-right: 5px;" colspan="5">
                        <label><font color="red" size="4">لا يوجد بيانات</font></label>
                    </td>
                </TR>
                <%}%>
            </tbody>
        </table>
        <br>
        <br>

        <table class="titlebar" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0" >
            <thead>
                <tr>
                    <td style="font-size: 16px; font-weight: bold; padding-bottom: 3px; padding-top: 3px; ">
                        <font color="#005599">الحجوزات</font></td>
                </tr>
            </thead>
        </table>

        <table id="requestedItems" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0" style="background: #b9d2ef">
            <thead>
                <tr>
                    <td class="blueBorder backgroundTable" width="25%"><FONT size="3">الوحدة</FONT></td>
                    <td class="blueBorder backgroundTable" width="20%"><FONT size="3">المشروع</FONT></td>
                    <td class="blueBorder backgroundTable" width="15%"><FONT size="3">نظام الدفع</FONT></td>
                    <td class="blueBorder backgroundTable" width="15%"><FONT size="3">مدة الحجز</FONT></td>
                    <td class="blueBorder backgroundTable" width="15%"><FONT size="3">تاريخ الحجز</FONT></td>
                </tr>
            </thead>
            <tbody>
                <%
                    if (reservedUnit.size() > 0 && reservedUnit != null) {
                        for (int i = 0; i < reservedUnit.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) reservedUnit.get(i);
                            tempWbo = projectMgr.getOnSingleKey((String) wbo.getAttribute("projectId"));
                            tempWbo2 = projectMgr.getOnSingleKey((String) wbo.getAttribute("projectCategoryId"));
                %>
                <TR>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=tempWbo.getAttribute("projectName")%> </font></label>
                    </TD>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=tempWbo2.getAttribute("projectName")%> </font></label>
                    </TD>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("paymentSystem")%> </font></label>
                    </TD>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("period")%> </font></label>
                    </TD>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=((String) wbo.getAttribute("reservationDate")).split(" ")[0]%> </font></label>
                    </TD>
                </TR>
                <%
                    }
                } else {%>  
                <TR>
                    <td style="text-align:Center; padding-right: 5px;" colspan="5">
                        <label><font color="red" size="4">لا يوجد بيانات</font></label>
                    </td>
                </TR>
                <%}%>
            </tbody>
        </table>
        <br>
        <br>



        <table class="titlebar" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0">
            <thead>
                <tr>
                    <td style="font-size: 16px; font-weight: bold; padding-bottom: 3px; padding-top: 3px; ">
                        <font color="#005599">الرغبات</font></td>
                </tr>
            </thead>
        </table>

        <table id="requestedItems" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0" style="background: #b9d2ef">
            <thead>
                <tr>
                    <td class="blueBorder backgroundTable" width="30%"><FONT size="3">المشروع</FONT></td>
                    <td class="blueBorder backgroundTable" width="15%"><FONT size="3">المساحة</FONT></td>
                    <td class="blueBorder backgroundTable" width="10%"><FONT size="3">الفترة</FONT></td>
                    <td class="blueBorder backgroundTable" width="15%"><FONT size="3">نظام الدفع</FONT></td>
                    <td class="blueBorder backgroundTable" width="30%"><FONT size="3">ملاحظات</FONT></td>
                </tr>
            </thead>
            <tbody>
                <%
                    if (products.size() > 0 && products != null) {
                        for (int i = 0; i < products.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) products.get(i);
                %>
                <TR>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("productCategoryName")%> </font></label>
                    </TD>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("budget")%> </font></label>
                    </TD>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("period")%> </font></label>
                    </TD>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("paymentSystem")%> </font></label>
                    </TD>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("note") != null && !wbo.getAttribute("note").equals("UL") ? wbo.getAttribute("note") : "---"%> </font></label>
                    </TD>


                </TR>
                <%
                    }
                } else {%>  
                <TR>
                    <td style="text-align:Center; padding-right: 5px;" colspan="5">
                        <label><font color="red" size="4">لا يوجد بيانات</font></label>
                    </td>
                </TR>
                <%}%>
            </tbody>
        </table>
        <br>
        <br>

        <table class="titlebar" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0">
            <thead>
                <tr>
                    <td style="font-size: 16px; font-weight: bold; padding-bottom: 3px; padding-top: 3px; ">
                        <font color="#005599">المقابلات</font></td>
                </tr>

            </thead>
        </table>
        <table id="requestedItems" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0" style="background: #b9d2ef">
            <thead>
                <tr>
                    <td class="blueBorder backgroundTable" width="25%"><FONT size="3">عنوان المقابله</FONT></td>
                    <td class="blueBorder backgroundTable" width="25%"><FONT size="3">تاريخ المقابله</FONT></td>
                    <td class="blueBorder backgroundTable" width="50%"><FONT size="3">ملاحظات المقابله</FONT></td>
                </tr>
            </thead>
            <tbody>
                <%
                    if (appointments.size() > 0 && appointments != null) {
                        for (int i = 0; i < appointments.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) appointments.get(i);
                %>
                <TR>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("title")%> </font></label>
                    </TD>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("appointmentDate")%> </font></label>
                    </TD>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("comment")%> </font></label>
                    </TD>
                </TR>
                <%
                    }
                } else {%>  
                <TR>
                    <td style="text-align:center; padding-right: 5px;" colspan="3">
                        <label><font color="red" size="4">لا يوجد بيانات</font></label>
                    </td>
                </TR>
                <%}%>
            </tbody>
        </table>
        <br>
        <br>
        <table class="titlebar" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0">
            <thead>
                <tr>
                    <td style="font-size: 16px; font-weight: bold; padding-bottom: 3px; padding-top: 3px; ">
                        <font color="#005599">المتابعات</font></td>
                </tr>

            </thead>
        </table>
        <table id="requestedItems" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0" style="background: #b9d2ef">
            <thead>
                <tr>
                    <td class="blueBorder backgroundTable" width="25%"><FONT size="3">تاريخ المتابعة</FONT></td>
                    <td class="blueBorder backgroundTable" width="50%"><FONT size="3">ملاحظات المتابعة</FONT></td>
                </tr>
            </thead>
            <tbody>
                <%
                    if (directFollows.size() > 0 && directFollows != null) {
                        for (int i = 0; i < directFollows.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) directFollows.get(i);
                %>
                <TR>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("appointmentDate")%> </font></label>
                    </TD>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("comment")%> </font></label>
                    </TD>
                </TR>
                <%
                    }
                } else {%>  
                <TR>
                    <td style="text-align:center; padding-right: 5px;" colspan="3">
                        <label><font color="red" size="4">لا يوجد بيانات</font></label>
                    </td>
                </TR>
                <%}%>
            </tbody>
        </table>
        <br>
        <br>

        <table class="titlebar" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0">
            <thead>
                <tr>
                    <td style="font-size: 16px; font-weight: bold; padding-bottom: 3px; padding-top: 3px; ">
                        <font color="#005599">التعليقات</font></td>
                </tr>

            </thead>
        </table>

        <table id="requestedItems" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0" style="background: #b9d2ef">
            <thead>
                <tr>
                    <td class="blueBorder backgroundTable" width="25%" hie><FONT size="3">أسم المستخدم</FONT></td>
                    <td class="blueBorder backgroundTable" width="25%"><FONT size="3">تاريخ التعليق</FONT></td>
                    <td class="blueBorder backgroundTable" width="50%"><FONT size="3">التعليق</FONT></td>
                </tr>
            </thead>
            <tbody>
                <%
                    if (comments.size() > 0 && comments != null) {
                        for (int i = 0; i < comments.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) comments.get(i);
                %>
                <TR>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("userName")%> </font></label>
                    </TD>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("commentDate")%> </font></label>
                    </TD>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("comment")%> </font></label>
                    </TD>
                </TR>
                <%
                    }
                } else {%>  
                <TR>
                    <td style="text-align:center; padding-right: 5px;" colspan="3">
                        <label><font color="red" size="4">لا يوجد بيانات</font></label>
                    </td>
                </TR>
                <%}%>
            </tbody>
        </table>
        <br>
        <br>

        <table class="titlebar" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0">
            <thead>
                <tr>
                    <td  style="font-size: 16px; font-weight: bold; padding-bottom: 3px; padding-top: 3px; ">
                        <font color="#005599">الحملات</font></td>
                </tr>
            </thead>
        </table>

        <table id="requestedItems" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0" style="background: #b9d2ef">
            <thead>
                <tr>
                    <td class="blueBorder backgroundTable" width="33%"  ><FONT size="3">عنوان الحمله</FONT></td>
                    <td class="blueBorder backgroundTable" width="33%"  ><FONT size="3">في تاريخ</FONT></td>
                    <td class="blueBorder backgroundTable" width="33%" ><FONT size="3">مرشح من قبل</FONT></td>
               </tr>
            </thead>
            <tbody>
                <%
                    if (seasons.size() > 0 && seasons != null) {
                        for (int i = 0; i < seasons.size(); i++) {
                            WebBusinessObject wbo = (WebBusinessObject) seasons.get(i);
                            tempWbo = campaignMgr.getOnSingleKey((String) wbo.getAttribute("campaignId"));
                %>
                <TR>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=tempWbo.getAttribute("campaignTitle")%> </font></label>
                    </TD>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("creationTime") != null ? ((String) wbo.getAttribute("creationTime")).substring(0, 10) : "---"%> </font></label>
                    </TD>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=wbo.getAttribute("reference") != null ? wbo.getAttribute("reference") : "---"%> </font></label>
                    </TD>
                </TR>
                <%
                    }
                } else {%>  
                <TR>
                    <td style="text-align:center; padding-right: 5px;" colspan="2">
                        <label><font color="red" size="4">لا يوجد بيانات</font></label>
                    </td>
                </TR>
                <%}%>
            </tbody>
        </table>
            
        <br/>
        <br/>
        <table class="titlebar" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0">
            <thead>
                <tr>
                    <td  style="font-size: 16px; font-weight: bold; padding-bottom: 3px; padding-top: 3px; ">
                        <font color="#005599">تقييم العميل</font></td>
                </tr>
            </thead>
        </table>

        <table id="requestedItems" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0" style="background: #b9d2ef">
            <thead>
                <tr>
                    <td class="blueBorder backgroundTable" width="33%"><font size="3">التقييم</font></td>
                    <td class="blueBorder backgroundTable" width="33%"><font size="3">بواسطة</font></td>
                    <td class="blueBorder backgroundTable" width="33%"><font size="3">في تاريخ</font></td>
               </tr>
            </thead>
            <tbody>
                <%
                    if (clientRateWbo != null) {
                %>
                <tr>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=rateWbo != null ? rateWbo.getAttribute("projectName") : ""%> </font></label>
                    </td>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=rateUserWbo != null ? ((String) rateUserWbo.getAttribute("fullName")) : "---"%> </font></label>
                    </td>
                    <td style="text-align:Center; padding-right: 5px;">
                        <label><font color="black" size="3"> <%=clientRateWbo.getAttribute("creationTime") != null ? ((String) clientRateWbo.getAttribute("creationTime")).substring(0, 10) : "---"%> </font></label>
                    </td>
                </tr>
                <%
                } else {%>  
                <tr>
                    <td style="text-align:center; padding-right: 5px;" colspan="3">
                        <label><font color="red" size="4">لا يوجد تقييم</font></label>
                    </td>
                </tr>
                <%}%>
            </tbody>
        </table>
        <br>
        <br>

        <table class="titlebar" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0">
            <thead>
                <tr>
                    <td style="font-size: 16px; font-weight: bold; padding-bottom: 3px; padding-top: 3px"><font color="#005599">الطلبات</font></td>
                </tr>
            </thead>
        </table>

        <table id="indextable" align="center" dir="rtl" width="80%" CELLPADDING="0" CELLSPACING="0" style="background: url ">
            <thead>
                <tr>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 30px" width="2%" rowspan="2"><b>#</b></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 30px" width="3%" colspan="3" rowspan="2"><img src="images/icons/operation.png" width="24" height="24"/></TH>  
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 30px" width="3%" rowspan="2"><img src="images/icons/Numbers.png" width="20" height="20" /><b> رقم المتابعة</b></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 30px" width="5%" rowspan="2"><b>النوع</b></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 30px" width="7%" rowspan="2"><img src="images/icons/list_.png" width="20" height="20" /><b>الطلب</b></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 30px" width="10%" rowspan="2"><img src="images/icons/key.png" width="20" height="20" /><b> كود الطلب</b></TH>
                    <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" width="10%" rowspan="2"><b>المصدر</b></th>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 30px" width="5%" rowspan="2"><b>الحاله</b></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 30px" width="5%" rowspan="2"><b>تاريخ الحاله</b></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 30px" width="8%" rowspan="2"><b>المسئول</b></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 30px" width="8%" rowspan="2"><b>ع.ط  ( يوم)</b></TH>
                    <TH CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 30px" width="10%" rowspan="2"><b>سحب عمبل</b></TH>
                </tr>
            </thead>

            <tbody  id="planetData2">
                <%
                    if (complaints.size() > 0 && complaints != null) {
                        Enumeration e = complaints.elements();
                        String compStyle = "";
                        WebBusinessObject wbo = new WebBusinessObject();

                        while (e.hasMoreElements()) {
                            iTotal++;
                            wbo = (WebBusinessObject) e.nextElement();
                            WebBusinessObject senderInf = null;

                            senderInf = userMgr.getOnSingleKey(wbo.getAttribute("senderId").toString());
                            WebBusinessObject clientCompWbo = null;
                            String compType = "";
                            ClientComplaintsMgr clientComplaintsMgr = ClientComplaintsMgr.getInstance();
                            clientCompWbo = clientComplaintsMgr.getOnSingleKey(wbo.getAttribute("clientComId").toString());
                            if (clientCompWbo.getAttribute("ticketType").toString().equals("1")) {
                                compType = "شكوى";
                                compStyle = "comp";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("2")) {
                                compType = "طلب";
                                compStyle = "order";
                            } else if (clientCompWbo.getAttribute("ticketType").toString().equals("3")) {
                                compType = "استعلام";
                                compStyle = "query";
                            }
                %>
                <TR style="padding: 1px;">
                    <TD width="2%">
                        <%=iTotal%>
                    </td>
                    <td width="3%">
                        <a href="JavaScript: openAttachmentDialog('<%=wbo.getAttribute("issue_id")%>', '<%=CRMConstants.OBJECT_TYPE_ISSUE%>');">
                            <img style="margin: 3px" src="images/icons/attachment.png" width="24" height="24"/>
                        </a>
                    </td>
                    <td width="3%">
                        <a href="JavaScript: viewDocuments('<%=wbo.getAttribute("issue_id")%>')"
                           onmouseover="JavaScript: getDocumentCount(this, '<%=wbo.getAttribute("issue_id")%>')">
                            <img style="margin: 3px" src="images/Foldericon.png" width="24" height="24"/>
                        </a>
                    </td>
                    <td width="3%">
                        <a href="JavaScript: openCommentsDialog('<%=wbo.getAttribute("clientComId")%>');">
                            <img style="margin: 3px" src="images/icons/accept-with-note.png" width="24" height="24"/>
                        </a>
                    </td>
                    <TD  style="cursor: pointer" onmouseover="this.className = '<%=compStyle%>'" onmouseout="this.className = ''" width="10%">
                        <%if (wbo.getAttribute("issue_id") != null) {%>
                        <a href="<%=context%>/IssueServlet?op=getCompl3&issueId=<%=wbo.getAttribute("issue_id")%>&compId=<%=wbo.getAttribute("clientComId")%>&statusCode=<%=wbo.getAttribute("statusCode")%>&receipId=<%=wbo.getAttribute("receipId")%>&senderID=<%=wbo.getAttribute("senderId")%>"> <font color="red"><%=wbo.getAttribute("businessID").toString()%></font><font color="blue">/<%=wbo.getAttribute("businessIDbyDate").toString()%></font></a>
                            <%}%>
                    </TD>
                    <TD width="8%">
                        <%if (compType != null) {%><b><%=compType%></b><%}%>
                    </TD>
                    <% String sCompl = " ";
                        if (wbo.getAttribute("compSubject") != null && !wbo.getAttribute("compSubject").equals("")) {
                            sCompl = (String) wbo.getAttribute("compSubject");
                            if (sCompl.length() > 10) {
                    %>
                    <TD width="7%"><b><%=sCompl%></b></TD>
                            <% } else {%>
                    <TD width="5%" ><b><%=sCompl%></b></TD>
                            <% }%>
                            <% } else {%>
                    <TD width="5%"><b><%=sCompl%></b></TD>
                            <%}%>
                    <TD width="10%" nowrap><b><%=wbo.getAttribute("businessCompId")%></b></TD>
                    <td width="8%">
                        <%if (wbo.getAttribute("createdByName") != null) {%><b><%=wbo.getAttribute("createdByName")%></b><%}%>
                    </td>

                    <% if (stat.equals("En")) {
                            complStatus = (String) wbo.getAttribute("statusEnName");
                        } else {
                            complStatus = (String) wbo.getAttribute("statusArName");
                        }
                    %>
                    <TD width="8%"><b><%=complStatus%></b></TD>

                    <%  Calendar c = Calendar.getInstance();
                        DateFormat formatter;
                        formatter = new SimpleDateFormat("dd/MM/yyyy");
                        String[] arrDate = wbo.getAttribute("entryDate").toString().split(" ");
                        Date date = new Date();
                        sDate = arrDate[0];
                        sTime = arrDate[1];
                        String[] arrTime = sTime.split(":");
                        sTime = arrTime[0] + ":" + arrTime[1];
                        sDate = sDate.replace("-", "/");
                        arrDate = sDate.split("/");
                        sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
                        c.setTime((Date) formatter.parse(sDate));
                        int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                        String currentDate = formatter.format(date);
                        String sDay = null;
                        if (dayOfWeek == 7) {
                            sDay = sat;
                        } else if (dayOfWeek == 1) {
                            sDay = sun;
                        } else if (dayOfWeek == 2) {
                            sDay = mon;
                        } else if (dayOfWeek == 3) {
                            sDay = tue;
                        } else if (dayOfWeek == 4) {
                            sDay = wed;
                        } else if (dayOfWeek == 5) {
                            sDay = thu;
                        } else if (dayOfWeek == 6) {
                            sDay = fri;
                        }
                    %>
                    <%if (currentDate.equals(sDate)) {%>
                    <TD nowrap><font color="red">Today - </font><b><%=sTime%></b></TD>
                            <%} else {%>

                    <TD nowrap  ><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b></TD>
                            <%}%>

                    <% if (wbo.getAttribute("currentOwner") != null && !wbo.getAttribute("currentOwner").equals("")) {
                            fullName = (String) wbo.getAttribute("currentOwner");
                        } else {
                            fullName = "";
                        }
                    %>
                    <TD style="width: 10%;"  ><b><%=fullName%></b></TD>
                    <td>
                        <%
                            try {
                                out.write("<b>" + DateAndTimeControl.getDelayTime(wbo.getAttribute("entryDate").toString(), "Ar") + "</b>");
                            } catch (Exception E) {
                                out.write("<b>" + noResponse + "</b>");
                            }
                        %>
                    </td>
                    <td>
                        <%
                            if((loggedUser != null && client != null && client.getAttribute("createdBy") != null
                                    && client.getAttribute("createdBy").equals(loggedUser.getAttribute("userId")))
                                    || privilegesList.contains("WITHDREW_CLIENT")) {
                        %>
                        <a href="JavaScript: withdrewClient(<%=wbo.getAttribute("issue_id")%>);">سحب عمبل</a>
                        <%
                            } else {
                        %>
                        ---
                        <%
                            }
                        %>
                    </td>
                </TR>
                <%
                    }
                } else {%>  
                <TR>
                    <td style="text-align:center; padding-right: 5px;" colspan="14">
                        <label><font color="red" size="4">لا يوجد بيانات</font></label>
                    </td>
                </TR>
                <%}%>
            </tbody>
        </TABLE>
        <%
            }
        %>
    </BODY>
</HTML>