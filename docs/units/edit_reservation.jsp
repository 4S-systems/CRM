<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<html>
    <%
        String status = (String) request.getAttribute("status");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> paymentPlace = (ArrayList<WebBusinessObject>) request.getAttribute("paymentPlace");
        SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
        ArrayList<WebBusinessObject> prvType = new ArrayList();
        prvType = securityUser.getComplaintMenuBtn();
        ArrayList<String> privilegesList = new ArrayList<>();
        for (WebBusinessObject wboTemp : prvType) {
            if (wboTemp != null && wboTemp.getAttribute("prevCode") != null) {
                privilegesList.add((String) wboTemp.getAttribute("prevCode"));
            }
        }
        String reservationID = (String) request.getAttribute("reservationID");
        WebBusinessObject reservationWbo = (WebBusinessObject) request.getAttribute("reservationWbo");
        WebBusinessObject unitWbo = (WebBusinessObject) request.getAttribute("unitWbo");
        WebBusinessObject salesUserWbo = (WebBusinessObject) request.getAttribute("salesUserWbo");
        WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
        WebBusinessObject clientProductWbo = (WebBusinessObject) request.getAttribute("clientProductWbo");
        String period = "";
        String unitValue = "";
        String beforeDiscount = "";
        String contractValue = "";
        String reservationValue = "";
        String budget = "";
        String plotArea = "";
        String floorNo = "";
        String modelNo = "";
        String receiptNo = "";
        String additions = "";
        String buildingArea = "";
        String paymentSystem = "";
        String paymentLocation = "";
        String reservationDate = "";
        String unitValueText = "";
        String beforeDiscountText = "";
        String reservationValueText = "";
        String contractValueText = "";
        if (clientProductWbo != null) {
            if (clientProductWbo.getAttribute("period") != null) {
                period = (String) clientProductWbo.getAttribute("period");
            }
            if (clientProductWbo.getAttribute("unitValue") != null) {
                unitValue = (String) clientProductWbo.getAttribute("unitValue");
            }

            if (clientProductWbo.getAttribute("beforeDiscount") != null) {
                beforeDiscount = (String) clientProductWbo.getAttribute("beforeDiscount");
            }

            if (clientProductWbo.getAttribute("contractValue") != null) {
                contractValue = (String) clientProductWbo.getAttribute("contractValue");
            }


            if (clientProductWbo.getAttribute("reservationValue") != null) {
                reservationValue = (String) clientProductWbo.getAttribute("reservationValue");
            }

            if (clientProductWbo.getAttribute("budget") != null) {
                budget = (String) clientProductWbo.getAttribute("budget");
            }
            if (clientProductWbo.getAttribute("plotArea") != null) {
                plotArea = (String) clientProductWbo.getAttribute("plotArea");
            }
            if (clientProductWbo.getAttribute("buildingArea") != null) {
                buildingArea = (String) clientProductWbo.getAttribute("buildingArea");
            }
            if (clientProductWbo.getAttribute("paymentSystem") != null) {
                paymentSystem = (String) clientProductWbo.getAttribute("paymentSystem");
            }
            if (clientProductWbo.getAttribute("note") != null) {
                paymentLocation = (String) clientProductWbo.getAttribute("note");
            }
        }
        if (reservationWbo != null) {
            if (reservationWbo.getAttribute("reservationDate") != null) {
                reservationDate = (String) reservationWbo.getAttribute("reservationDate");
                if (reservationDate.contains(" ")) {
                    reservationDate = reservationDate.substring(0, reservationDate.indexOf(" "));
                }
            }

            if (reservationWbo.getAttribute("option1") != null) {
                floorNo = (String) reservationWbo.getAttribute("option1");
            }

            if (reservationWbo.getAttribute("option2") != null) {
                modelNo = (String) reservationWbo.getAttribute("option2");
            }

            if (reservationWbo.getAttribute("option3") != null) {
                receiptNo = (String) reservationWbo.getAttribute("option3");
            }

            if (reservationWbo.getAttribute("paymentPlace") != null) {
                additions = (String) reservationWbo.getAttribute("paymentPlace");
            }
            
            if (reservationWbo.getAttribute("option4") != null) {
                unitValueText = (String) reservationWbo.getAttribute("option4");
            }
            
            if (reservationWbo.getAttribute("option5") != null) {
                beforeDiscountText = (String) reservationWbo.getAttribute("option5");
            }
            
            if (reservationWbo.getAttribute("option7") != null) {
                contractValueText = (String) reservationWbo.getAttribute("option7");
            }
            
            if (reservationWbo.getAttribute("option6") != null) {
                reservationValueText = (String) reservationWbo.getAttribute("option6");
            }
        }

        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir,SManager,Client,CodeUV,LandA,AUnit,DataOfReservation,DataSheetUnit,FloorOfUnit,TheModel,PriceBeforeDiscount,Only,PriceUnit,DateReservation,DurationOfReservation,PaymentforReservation,ContractPayment,ReceiptNO,Additions,PaymentPlan, style;

        String title, fStatus, sStatus;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            title = "Update Client";
            sStatus = "Supplier Updated Successfully";
            fStatus = "Fail To Update This Supplier";
            SManager = "Sales Manager";
            Client = "Client";
            CodeUV = "code unit / Villa";
            LandA = "Land Area";
            AUnit ="Area Unit";
            FloorOfUnit = "Floor Of Unit";
            TheModel = "TheModel";
            PriceBeforeDiscount = "Price Before Discount";
            Only ="Only";
            PriceUnit = "Price Unit";
            DateReservation = "Date Reservation";
            DurationOfReservation = "Duration Of Reservation";
            PaymentforReservation = "Payment for Reservation";
            ContractPayment = "Contract Payment";
            ReceiptNO = "Receipt NO.";
            Additions = "Additions";
            PaymentPlan = "Payment Plan";
            DataSheetUnit = "Data Sheet Unit";
            DataOfReservation = "Data Of Reservation";
            
            
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            title = "تحديث حجز وحدة";
            fStatus = "&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
            sStatus = "&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
            SManager = "مسئول المبيعات";
            Client = "العميل";
            CodeUV = "كود الوحده / الفيلا";
            LandA = "مساحه الارض";
            AUnit ="مساحه الوحده";
            FloorOfUnit = "دور الوحدة/الفيلا	";
            TheModel = "نموذج الوحدة/الفيلا	";
            PriceBeforeDiscount = "قيمة الوحدة قبل الخصم	";
            Only ="فقط";
            PriceUnit = "قيمة الوحدة	";
            DateReservation = "تاريخ الحجز	";
            DurationOfReservation = "مدة الحجز	";
            PaymentforReservation = "دفعة الحجز	";
            ContractPayment = "دفعة التعاقد	";
            ReceiptNO = "ايصال استلام رقم	";
            Additions = "إضافات	";
            PaymentPlan = "طريقة السداد	";
            DataSheetUnit = "بيانات الوحدة/فيلا";
            DataOfReservation = "بيانات الحجز";
        }
    %>
    <head>
        <link rel="stylesheet" type="text/css" href="CSS.css"/>
        <link rel="stylesheet" type="text/css" href="Button.css"/>
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
        <script type="text/javascript" src="js/Tafqeet.js"></script>
        <script type="text/javascript" src="js/validator.js"></script>
        <script language="JavaScript" type="text/javascript">
            $(function () {
                $("#reservationDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
            function submitForm()
            {
                document.EDIT_RESERVATION_FORM.action = "<%=context%>/UnitServlet?op=updateReservation";
                document.EDIT_RESERVATION_FORM.submit();
            }
            function cancelForm() {
                self.close();
            }
            function tafqeetVal (obj) {
                var text = " جنيها مصريا";
                if($("#" + obj).val() !== '') {
                    $("#" + obj + "Text").val(tafqeet($("#" + obj).val()) + text);
                }
            }
        </script>
        <style type="text/css">
            .closeBtn{
                width:145px;
                height:31px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/close2.png);
            }
            .submitBtn{
                width:145px;
                height:31px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/submit.png);
            }
            .titleTD {
                text-align:center;
                font-weight: bold;
                font-size: 16px;
                color: black;
                background-color:#b9d2ef;
            }
            div.ui-datepicker{
                font-size:12px;
            }
        </style>
    </head>
    <body>
        <div align="center" style="color:blue;">
            <input type="button" onclick="JavaScript:cancelForm()" class="closeBtn" style="margin-right: 2px;"></button>
            <input type="button" onclick="JavaScript:submitForm()" id='submitBtn' class="submitBtn" value="" style="display: inline-block;"/>
        </div> 
        <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="center">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">
                            <%=title%>
                            </font>
                        </td>
                    </tr>
                </table>
            </legend>
            <form name="EDIT_RESERVATION_FORM" method="POST">
                <%
                    if (null != status) {
                        if (status.equalsIgnoreCase("ok")) {
                %>  
                <tr>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="black"><%=sStatus%></font> 
                        </td>                    
                    </tr> </table>
                </tr>
                <%
                } else {%>
                <tr>
                <table align="<%=align%>" dir=<%=dir%>>
                    <tr>                    
                        <td class="td">
                            <font size=4 color="red" ><%=fStatus%></font> 
                        </td>                    
                    </tr> </table>
                </tr>
                <%}
                    }

                %>
                <br/>
                <div style="width: 100%; text-align: center; margin: auto; padding: auto;">
                    <table dir="<%=dir%>" align="center" cellpadding="1" cellspacing="2" width="70%;" style="margin:auto; padding: auto;">
                        <tr>
                            <td class="td titleTD"><%=SManager%></td>
                            <td style="text-align:right;">
                                <%=salesUserWbo != null ? salesUserWbo.getAttribute("fullName") : ""%>
                            </td>
                        </tr>
                        <tr>
                            <td class="td titleTD"><%=Client%></td>
                            <td style="text-align:right;">
                                <%=clientWbo != null ? clientWbo.getAttribute("name") : ""%>
                            </td>
                        </tr>
                        <tr>
                            <td class="td titleTD"><%=CodeUV%></td>
                            <td style="text-align:right;">
                                <%=unitWbo != null ? unitWbo.getAttribute("projectName") : ""%>
                                <input type="hidden" name="reservationID" value="<%=reservationID%>"/>
                                <input type="hidden" name="clientProductID" value="<%=clientProductWbo != null && clientProductWbo.getAttribute("id") != null ? clientProductWbo.getAttribute("id") : ""%>"/>
                            </td>
                        </tr>

                        <tr>
                            <td class="td titleTD" colspan="2" style="color:red"><%=DataSheetUnit%></td>
                        </tr>

                        <tr>
                            <td class="td titleTD"><%=AUnit%></td>
                            <td style="text-align:right;">
                                <input type="number" size="7" maxlength="7" id="buildingArea" name="buildingArea" style='width:170px;'
                                       value="<%=buildingArea%>"/>
                            </td>
                        </tr>

                        <tr>
                            <td class="td titleTD"><%=LandA%></td>
                            <td style="text-align:right;">
                                <input type="number" size="7" maxlength="7" id="plotArea" name="plotArea" style='width:170px;'
                                       value="<%=plotArea%>"/>
                            </td>
                        </tr>

                        <tr>
                            <td class="td titleTD"><%=FloorOfUnit%></td>
                            <td style="text-align:right;">
                                <input type="text" size="7" maxlength="7" id="floorNo" name="floorNo" style='width:170px;'
                                       value="<%=floorNo%>" readonly/>
                            </td>
                        </tr>

                        <tr>
                            <td class="td titleTD"><%=TheModel%></td>
                            <td style="text-align:right;">
                                <input type="text" size="7" maxlength="7" id="modelNo" name="modelNo" style='width:170px;'
                                       value="<%=modelNo%>" readonly/>
                            </td>
                        </tr>

                        <tr>
                            <td class="td titleTD"><%=PriceBeforeDiscount%></td>
                            <td style="text-align:right;">
                                <input type="number" size="7" maxlength="7" id="beforeDiscount" name="beforeDiscount" style='width:170px;'
                                       value="<%=beforeDiscount%>" onchange="JavaScript: tafqeetVal('beforeDiscount');"/>
                            </td>
                        </tr>

                        <tr>
                            <td class="td titleTD"><%=Only%></td>
                            <td style="text-align:right;">
                                <TEXTAREA cols="50" rows="1" name="beforeDiscountText" id="beforeDiscountText" style="background: #FFFF99;"><%=beforeDiscountText%></TEXTAREA>                               
                            </td>
                        </tr>

                        <tr>
                            <td class="td titleTD"><%=PriceUnit%></td>
                            <td style="text-align:right;">
                                <input type="number" size="7" maxlength="7" id="unitValue" name="unitValue" style='width:170px;'
                                       value="<%=unitValue%>" onchange="JavaScript: tafqeetVal('unitValue');"/>
                            </td>
                        </tr>

                        <tr>
                            <td class="td titleTD"><%=Only%></td>
                            <td style="text-align:right;">
                                <TEXTAREA cols="50" rows="1" name="unitValueText" id="unitValueText" style="background: #FFFF99;"><%=unitValueText%></TEXTAREA>                               
                            </td>
                        </tr>

                        <tr>
                            <td class="td titleTD" colspan="2" style="color:red"><%=DataOfReservation%></td>
                        </tr>

                        <tr>
                            <td class="td titleTD"><%=DateReservation%></td>
                            <td style="text-align:right;">
                                <input type="text" size="7" maxlength="7" readonly id="reservationDate" name="reservationDate" style='width:170px;'
                                       value="<%=reservationDate%>"/>
                            </td>
                        </tr>

                        <tr>
                            <td class="td titleTD"><%=DurationOfReservation%></td>
                            <td style="text-align:right;">
                                <input type="number" size="7" maxlength="7" id="period" name="period" style="width:170px;"
                                        <%=metaMgr.getReservationDefaultPeriod() != null && !"".equals(metaMgr.getReservationDefaultPeriod()) && !"0".equals(metaMgr.getReservationDefaultPeriod()) && !privilegesList.contains("EDIT_RESERVE_PERIOD") ? "readonly" : ""%>
                                       value="<%=period%>"/>
                            </td>
                        </tr>

                        <tr>
                            <td class="td titleTD"><%=ContractPayment%></td>
                            <td style="text-align:right;">
                                <input type="number" size="7" maxlength="7" id="contractValue" name="contractValue" style='width:170px;'
                                       value="<%=contractValue%>" onchange="JavaScript: tafqeetVal('contractValue');"/>
                            </td>
                        </tr>

                        <tr>
                            <td class="td titleTD"><%=Only%></td>
                            <td style="text-align:right;">
                                <TEXTAREA cols="50" rows="1" name="contractValueText" id="contractValueText" style="background: #FFFF99;"><%=contractValueText%></TEXTAREA>                               
                            </td>
                        </tr>

                        <tr>
                            <td class="td titleTD"><%=PaymentforReservation%></td>
                            <td style="text-align:right;">
                                <input type="number" size="7" maxlength="7" id="reservationValue" name="reservationValue" style='width:170px;'
                                       value="<%=reservationValue%>" onchange="JavaScript: tafqeetVal('reservationValue');"/>
                            </td>
                        </tr>

                        <tr>
                            <td class="td titleTD"><%=Only%></td>
                            <td style="text-align:right;">
                                <TEXTAREA cols="50" rows="1" name="reservationValueText" id="reservationValueText" style="background: #FFFF99;"><%=reservationValueText%></TEXTAREA>                               
                            </td>
                        </tr>

                        <tr>
                            <td class="td titleTD"><%=PaymentPlan%></td>
                            <td style="text-align:right;">
                                <select name="paymentSystem" id="paymentSystem" style="width: 170px; font-size: 16px;">
                                    <option value="كاش" <%="كاش".equals(paymentSystem) ? "selected" : ""%>>كاش</option>
                                    <option value="أقساط" <%="أقساط".equals(paymentSystem) ? "selected" : ""%>>أقساط</option>
                                </select>
                            </td>
                        </tr> 

                        <tr>
                            <td class="td titleTD"><%=ReceiptNO%></td>
                            <td style="text-align:right;">
                                <input type="number" size="7" maxlength="7" id="receiptNo" name="receiptNo" style='width:170px;'
                                       value="<%=receiptNo%>"/>
                            </td>
                        </tr> 

                        <tr>
                            <td class="td titleTD"><%=Additions%></td>
                            <td style="text-align:right;">
                                <TEXTAREA cols="50" rows="6" name="addtions" id="addtions"><%=additions%></TEXTAREA>                               
                            </td>
                        </tr>
                    </table>
                </div>
            </form>
        </fieldset>
        <br/>
    </body>
</html>     
