<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="com.silkworm.common.SecurityUser"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
            WebBusinessObject reservationWbo = (WebBusinessObject) request.getAttribute("reservationWbo");
            String companyName = metaMgr.getCompanyNameForLogo();
            String logoName = "logo.png";
            if (companyName != null) {
                if (companyName.equalsIgnoreCase("metawee")) {
                    logoName = "logo-metawe.png";
                } else if (companyName.equalsIgnoreCase("almoez")) {
                    logoName = "logo-almoez.png";
                }
            }
            String imagePath = "images/" + logoName;
            if (request.getAttribute("imagePath") != null) {
                imagePath = (String) request.getAttribute("imagePath");
            }
        %>
        <title>أستمارة حجز</title>
        <script type="text/javascript">
            function date_time(id)
            {
                date = new Date;
                year = date.getFullYear();
                month = date.getMonth();
                months = new Array('January', 'February', 'March', 'April', 'May', 'June', 'Jully', 'August', 'September', 'October', 'November', 'December');
                d = date.getDate();
                day = date.getDay();
                days = new Array('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
                h = date.getHours();
                if (h < 10)
                {
                    h = "0" + h;
                }
                m = date.getMinutes();
                if (m < 10)
                {
                    m = "0" + m;
                }
                s = date.getSeconds();
                if (s < 10)
                {
                    s = "0" + s;
                }
                result = '' + days[day] + ' ' + months[month] + ' ' + d + ' ' + year + ' / ' + h + ':' + m;
                document.getElementById(id).innerHTML = result;
                setTimeout('date_time("' + id + '");', '1000');
                return true;
            }
        </script>
        <style type="text/css">  
            .h1 {
                background-image:url(img.PNG);
                background-repeat: no-repeat;
                background-attachment: scroll;
                background-position:19% 6.1%;
                background-size:130% 310%;
            }
            .h2 {
                width:100%;
            }

            #table2 {
                font-style: italic;
            }
        </style>
    </head>
    <body>
        <div>
            <span id="date_time"></span>
            <script type="text/javascript">window.onload = date_time('date_time');</script>
            <hr noshade size=4 width="100%">
            <table>
                <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                </tr>
            </table>
            <div class="h1">
                <h1 align="right" style="padding:5px 170px 0px 0px; font-size:20px">أستمارة حجز مشروع</h1>
                <h2 align="right" style="padding:5px 10px 0px 0px; font-size:15px">شركة الأفق للأستثمار العقارى</h2>
                <h3 align="right" style="padding:5px 20px 0px 0px; font-size:15px">قطاع التسويق والمبيعات</h3>
                <h4 align="right" style="padding:5px 95px 0px 0px; font-size:11px">
                    <strong><%=reservationWbo.getAttribute("projectName")%></strong>
                </h4>
            </div>
            <div>
                <img src="<%=imagePath%>" style="margin-top:-30% ; height:50%; width:30%" />
            </div>
            <hr noshade size=4 width="100%">
            <div class="h2">
                <table cellspacing="12" align="right">
                    <tr align="right">
                        <td style="border:1px solid; width:400px; font-size:16px"><%=reservationWbo.getAttribute("clientName")%></td>
                        <td style="border:1px solid; width:110px; font-size:16px; white-space: nowrap; font-weight: bold;">:اسم العميل</td>
                    </tr>
                </table>
                <table cellspacing="12" align="right">
                    <tr align="right">
                        <td style="border:1px solid; width:400px; font-size:16px"><%=reservationWbo.getAttribute("clientAddress")%></td>
                        <td style="border:1px solid; width:110px; font-size:16px; white-space: nowrap; font-weight: bold;">:العنوان</td>
                    </tr>
                </table>
                <table cellspacing="12" align="right">
                    <tr align="right">
                        <td style="border:1px solid; width:400px; font-size:16px"><%=reservationWbo.getAttribute("clientJob")%></td>
                        <td style="border:1px solid; width:110px; font-size:16px; white-space: nowrap; font-weight: bold;">:المهنة</td>
                    </tr>
                </table>
                <table cellspacing="12" align="right">
                    <tr align="right">
                        <td style="border:1px solid; width:400px; font-size:16px"><%=reservationWbo.getAttribute("clientEmail")%></td>
                        <td style="border:1px solid; width:110px; font-size:16px; white-space: nowrap; font-weight: bold;">:البريد الالكتروني</td>
                    </tr>
                </table>
                <table cellspacing="12" align="right">
                    <tr align="right">
                        <td style="border:1px solid; width:100px; font-size:16px"><%=reservationWbo.getAttribute("clientPhone2")%></td>
                        <td style="border:1px solid; width:110px; font-size:16px; white-space: nowrap; font-weight: bold;">:رقم الموبايل</td>
                        <td style="border:1px solid; width:100px; font-size:16px"><%=reservationWbo.getAttribute("clientPhone")%></td>
                        <td style="border:1px solid; width:110px; font-size:16px; white-space: nowrap; font-weight: bold;">:رقم التليفون</td>
                    </tr>
                </table>
                <table cellspacing="12" align="right">
                    <tr align="right">
                        <td style="border:1px solid; width:400px; font-size:16px"><%=reservationWbo.getAttribute("clientNationalID")%></td>
                        <td style="border:1px solid; width:110px; font-size:16px; white-space: nowrap; font-weight: bold;">:رقم البطاقة</td>
                    </tr>
                </table>
                <table cellspacing="13" align="right">
                    <tr align="right">
                        <td ></td>
                        <td ></td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">:نموذج رقم</td>
                        <td style="border:0px solid; width:40px; font-size:16px">&nbsp;</td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;"><%=reservationWbo.getAttribute("unitNumber")%>:وحدة رقم</td>
                        <td style="border:0px solid; width:40px; font-size:16px">&nbsp;</td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;"><%=reservationWbo.getAttribute("buildingNumber")%>:عمارة رقم</td>
                    </tr>
                    <%
                        if (!("").equals(reservationWbo.getAttribute("plotArea"))
                                && !("").equals(reservationWbo.getAttribute("buildingArea"))) {
                    %>
                    <tr align="right">
                        <td></td>
                        <td></td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">:الدور</td>
                        <td ></td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;"><%=reservationWbo.getAttribute("plotArea")%>:مساحة اﻷرض</td>
                        <td ></td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;"><%=reservationWbo.getAttribute("buildingArea")%>:مساحة المبانى </td>
                    </tr>
                    <%
                        }
                        if (!("").equals(reservationWbo.getAttribute("unitValue"))
                                && !("").equals(reservationWbo.getAttribute("reservationValue"))) {
                    %>
                    <tr align="right">
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">فقط</td>
                        <td style="border:0px solid; width:40px; font-size:16px"><%=reservationWbo.getAttribute("reservationValue")%></td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">:قيمة الحجز</td>
                        <td ></td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">فقط</td>
                        <td style="border:0px solid; width:40px; font-size:16px"><%=reservationWbo.getAttribute("unitValue")%></td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">:قيمة الوحدة</td>
                    </tr>
                    <%
                        }
                        if (!("").equals(reservationWbo.getAttribute("downPayment"))
                                && !("").equals(reservationWbo.getAttribute("contractValue"))) {
                    %>
                    <tr align="right">
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">فقط</td>
                        <td style="border:0px solid; width:40px; font-size:16px"><%=reservationWbo.getAttribute("contractValue")%></td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">:قيمة التعاقد</td>
                        <td ></td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">فقط</td>
                        <td style="border:0px solid; width:40px; font-size:16px"><%=reservationWbo.getAttribute("downPayment")%></td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">:دفعة التعاقد</td>
                    </tr>
                    <%
                        }
                        if (!("").equals(reservationWbo.getAttribute("beforeDiscount"))) {
                    %>
                    <tr align="right">
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">فقط</td>
                        <td style="border:0px solid; width:40px; font-size:16px">&nbsp;</td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">:المبلغ المدفوع من</td>
                        <td ></td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">فقط</td>
                        <td style="border:0px solid; width:40px; font-size:16px"><%=reservationWbo.getAttribute("beforeDiscount")%></td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">:الوحدة قبل الخصم</td>
                    </tr>
                    <%
                        }
                    %>
                    <tr align="right">
                        <td ></td>
                        <td ></td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">:بتاريخ</td>
                        <td ></td>
                        <td ></td>
                        <td ></td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">:مسدد بإيصال أستلام رقم</td>
                    </tr>
                    <tr align="right">
                        <td ></td>
                        <td ></td>
                        <td ></td>
                        <td ></td>
                        <td ></td>
                        <td style="border:0px solid; width:40px; font-size:16px">&nbsp;</td>
                        <td style="border:1px solid; width:100px; font-size:16px; white-space: nowrap; font-weight: bold;">:طريقة السداد/ مدة الاقساط</td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>

                </table>
                <hr noshade size=4 width="100%" />
                <div align="right" style="margin-top:20px"> الأفق و الربوة للأستثمار العقارى </div>
            </div>

        </div>
    </form>
    <div align="left" style="margin-top:-4%; padding:10px" > </div>
</body>
</html>
