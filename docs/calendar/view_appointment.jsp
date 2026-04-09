<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>  
    <%
        WebBusinessObject appointmentWbo = (WebBusinessObject) request.getAttribute("appointmentWbo");
        WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
        WebBusinessObject technicianWbo = (WebBusinessObject) request.getAttribute("technicianWbo");
        WebBusinessObject createdByWbo = (WebBusinessObject) request.getAttribute("createdByWbo");
        ArrayList<WebBusinessObject> unitsList = (ArrayList<WebBusinessObject>) request.getAttribute("unitsList");
        if (unitsList == null) {
            unitsList = new ArrayList<>();
        }
        String unitID = "";
        if (appointmentWbo.getAttribute("option6") != null) {
            unitID = (String) appointmentWbo.getAttribute("option6");
        }
        String appointmentDate = "";
        if (appointmentWbo.getAttribute("appointmentDate") != null) {
            appointmentDate = (String) appointmentWbo.getAttribute("appointmentDate");
            if (appointmentDate.contains(" ")) {
                appointmentDate = appointmentDate.substring(0, appointmentDate.indexOf(" "));
            }
        }
        String stat = (String) request.getSession().getAttribute("currentMode");
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
        <script type="text/javascript">

        </script>
        <style type="text/css">
            .supervisorClass {
                color: red;
            }
            .technicianClass {
                color: black;
            }
            .button_action_items {
                width:100px;
                height:20px;
                margin: 4px;
                background-size: 100%;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/action_items.png);
            }
            .button_raw_materials {
                width:100px;
                height:20px;
                margin: 4px;
                background-size: 100%;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/raw_materials.png);
            }
            .button_spare_parts {
                width:100px;
                height:20px;
                margin: 4px;
                background-size: 100%;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/spare_parts.png);
            }
            .button_worker {
                width:100px;
                height:20px;
                margin: 4px;
                background-size: 100%;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/worker.png);
            }
            .button_work_items {
                width:100px;
                height:20px;
                margin: 4px;
                background-size: 100%;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/buttons/work_items.png);
            }
        </style>
    </head>
    <body>

        <div style="clear: both;margin-left: 95%;margin-top: 0px;margin-bottom: -38px;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopupDialog('client_joborder')"/>
        </div>
        <div class="login" style="width: 95%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
            <h1 align="center" style="vertical-align: middle; background-color: #006daa;">أمر شغل <img src="images/icons/visit_icon.png" alt="phone" width="24px"/></h1>
            <table class="table" style="width:100%;">
                <tr>
                    <td style="vertical-align: baseline;">
                        <table class="table" style="width:100%;">
                            <tr>
                                <td nowrap>
                                    <input type="button" class="button_spare_parts"/>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap>
                                    <input type="button" class="button_raw_materials"/>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap>
                                    <input type="button" class="button_worker"/>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap>
                                    <input type="button" class="button_work_items"/>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap>
                                    <input type="button" class="button_action_items"/>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <table class="table" style="width:100%;">
                            <tr>
                                <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">اسم العميل : </td>
                                <td style="text-align:right">
                                    <label><%=clientWbo.getAttribute("name")%></label>
                                </td>
                            </tr>
                            <tr>
                                <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">رقم الموبايل : </td>
                                <td style="text-align:right">
                                    <label><%=clientWbo.getAttribute("mobile")%></label>
                                </td>
                            </tr>
                            <tr>
                                <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">العنوان : </td>
                                <td style="text-align:right">
                                    <label><%=clientWbo.getAttribute("address") != null ? clientWbo.getAttribute("address") : ""%></label>
                                </td>
                            </tr>
                            <tr>
                                <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">الوحدة : </td>
                                <td style="text-align:right">
                                    <select id="unitID" name="unitID" style="font-size: 12px; width: 200px;">
                                        <sw:WBOOptionList wboList="<%=unitsList%>" displayAttribute="productName" valueAttribute="projectId" scrollToValue="<%=unitID%>"/>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">اسم الفني : </td>
                                <td style="text-align:right">
                                    <label><%=technicianWbo.getAttribute("fullName")%></label>
                                </td>
                            </tr>
                            <tr>
                                <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">عامل الأتصال : </td>
                                <td style="text-align:right">
                                    <label><%=createdByWbo.getAttribute("fullName")%></label>
                                </td>
                            </tr>
                            <tr>
                                <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">تاريخ الصيانة : </td>
                                <td style="text-align:right">
                                    <input id="joborderDate" name="joborderDate" type="text" value="<%=appointmentDate%>" readonly="true"
                                           title="Date Format: yyyy/MM/dd" style="width: 180px;"/>
                                </td>
                            </tr>
                            <tr>
                                <td style="color:#f1f1f1; font-size: 16px;font-weight: bold; text-align: left;">تعليق : </td>
                                <td style="text-align:right">
                                    <textarea cols="26" rows="10" id="joborderComment" style="width: 99%; background-color: #FFF7D6;" readonly="true"><%=appointmentWbo.getAttribute("comment")%></textarea>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </body>
</html>
