<%-- 
    Document   : WorkList
    Created on : Oct 10, 2015, 1:03:44 PM
    Author     : walid
--%>
<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <TITLE>System Departments List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.structure.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.structure.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.theme.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.theme.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery.datetimepicker.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css" />
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery.datetimepicker.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <style>
            td.silver_header
            {
                text-align: right;
            }
            input.saveBtn
            {
                float:left;
                width: 240px;
                height: 35px;
                font-weight: bold;
                font-size: 20px;
                font-family: "Times New Roman";
            }
            th.silver_header
            {
                text-align: right;
                font-weight: bold;
                font-size: 15px;
                font-family: "Times New Roman";
            }
        </style>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            ArrayList<WebBusinessObject> workItems = (ArrayList<WebBusinessObject>) request.getAttribute("workItemsList");
            ArrayList<LiteWebBusinessObject> measureUnits = (ArrayList<LiteWebBusinessObject>) request.getAttribute("measuerUnits");
            ArrayList<LiteWebBusinessObject> equipClass = (ArrayList<LiteWebBusinessObject>) request.getAttribute("equipClass");
            int totalWorkItems = workItems.size();
            String stat = (String) request.getSession().getAttribute("currentMode");
            String align, xAlign, dir, itemCodeRequiredMsg, itemNameRequiredMsg, itemTypeRequiredMessage, measureUnitRequiredMessage,
                    defaultValueRequiredMessage, minPriceRequiredMessage, maxPriceRequiredMessage, successMsg, failMessage;
            if (stat.equals("En")) {
                align = "left";
                xAlign = "right";
                dir = "LTR";
                itemCodeRequiredMsg = "Item Code is required";
                itemNameRequiredMsg = "Item Name is required";
                itemTypeRequiredMessage = "Item Type is required";
                measureUnitRequiredMessage = "Measure Unit is required";
                defaultValueRequiredMessage = "Default Value is required";
                minPriceRequiredMessage = "Min. Price is required";
                maxPriceRequiredMessage = "Max. Price is required";
                successMsg = "Saved Successfully";
                failMessage = "Fail to Save";
            } else {
                align = "right";
                xAlign = "left";
                dir = "RTL";
                itemCodeRequiredMsg = "مطلوب أدخال كود البند";
                itemNameRequiredMsg = "مطلوب أدخال اسم البند";
                itemTypeRequiredMessage = "مطلوب أدخال نوع البند";
                measureUnitRequiredMessage = "مطلوب أدخال وحدة القياس";
                defaultValueRequiredMessage = "مطلوب أدخال القيمة الأفتراضية بشكل صحيح";
                minPriceRequiredMessage = "مطلوب أدخل أقل سعر بشكل صحيح";
                maxPriceRequiredMessage = "مطلوب أدخال أكبر سعر بشكل صحيح";
                successMsg = "تم الحفظ بنجاح";
                failMessage = "لم يتم الحفظ";
            }
        %>
        <script type="text/javascript">
            $(document).ready(function ()
            {
                $("#workDataTable").dataTable({
                    "columnDefs": [
                        {"width": "5%", "targets": 0},
                        {orderable: false, targets: [0, 4]}
                    ]
                });
                $("#checkAll").change(function ()
                {
                    var checkBoxes = document.getElementsByName("workItemcheck");
                    var checked = this.checked;
                    if (checked)
                    {
                        for (var i = 0; i < checkBoxes.length; i++)
                        {
                            checkBoxes[i].checked = true;
                        }
                    } else
                    {
                        for (var i = 0; i < checkBoxes.length; i++)
                        {
                            checkBoxes[i].checked = false;
                        }
                    }
                });
            });
            function validateForm()
            {
                var checkBoxes = document.getElementsByName("workItemcheck");
                var checkBoxesindex = document.getElementsByName("workItemcheckIndex");
                var checkedNumber = 0;
                for (var i = 0; i < checkBoxes.length; i++)
                {
                    if (checkBoxes[i].checked === true)
                    {
                        checkBoxesindex[i].value = "1";
                        checkedNumber++
                    }
                }
                if (checkedNumber <= 0)
                {
                    alert("check work item first");
                    return false;
                    /*$.ajax({
                     type: "post",
                     url: "<%=context%>/ProjectServlet?op=updateWorkItems",
                     data: {
                     data: data
                     },
                     success: function () {
                     alert("success:");
                     }
                     });*/
                } else
                {
                    return true;
                }
            }
            var divTag;
            function openNewWorkItem() {
                divTag = $("#workItemForm");
                $.ajax({
                    type: "post",
                    url: '<%=context%>/ProjectServlet?op=getWorkItemForm',
                    data: {
                    },
                    success: function (data) {
                        divTag.html(data).dialog({
                            modal: true,
                            title: "بند عمل جديد",
                            show: "fade",
                            hide: "explode",
                            width: 600,
                            position: {
                                my: 'center',
                                at: 'center'
                            },
                            buttons: {
                                'Close and Reload': function () {
                                    location.reload();
                                },
                                Save: function () {
                                    saveNewForm();
                                }
                            }
                        }).dialog('open');
                    }
                });
            }
            function saveNewForm() {
                var itemCode = $("#itemCode").val();
                var mainProjectID = $("#mainProjectID").val();
                var locationType = $("#locationType").val();
                var itemName = $("#itemName").val();
                var itemType = $("#itemType").val();
                var unitID = $("#unitID").val();
                var defaultValue = $("#defaultValue").val();
                var minPrice = $("#minPrice").val();
                var maxPrice = $("#maxPrice").val();
                if (itemCode === '') {
                    alert("<%=itemCodeRequiredMsg%>");
                    $("#itemCode").focus();
                } else if (itemName === '') {
                    alert("<%=itemNameRequiredMsg%>");
                    $("#itemName").focus();
//                } else if (itemType === '') {
//                    alert("<%=itemTypeRequiredMessage%>");
//                    $("#itemType").focus();
                } else if (unitID === '') {
                    alert("<%=measureUnitRequiredMessage%>");
                    $("#unitID").focus();
                } else if (defaultValue === '') {
                    alert("<%=defaultValueRequiredMessage%>");
                    $("#defaultValue").focus();
                } else if (minPrice === '') {
                    alert("<%=minPriceRequiredMessage%>");
                    $("#minPrice").focus();
                } else if (maxPrice === '') {
                    alert("<%=maxPriceRequiredMessage%>");
                    $("#maxPrice").focus();
                } else {
                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ProjectServlet?op=saveWorkItemAjax",
                        data: {
                            itemCode: itemCode,
                            mainProjectID: mainProjectID,
                            locationType: locationType,
                            itemName: itemName,
                            itemType: itemType,
                            unitID: unitID,
                            defaultValue: defaultValue,
                            minPrice: minPrice,
                            maxPrice: maxPrice
                        },
                        success: function (jsonString) {
                            var info = $.parseJSON(jsonString);
                            if (info.status === 'ok') {
                                alert("<%=successMsg%>");
                                openNewWorkItem();
                            } else {
                                alert("<%=failMessage%>");
                            }
                        }
                    });
                }
            }
        </script>
        <style>
            .toolBox {
                width:55px;
                height: 55px;
                float:<%=align%>;
                margin: 0px;
                padding: 0px;
                border: 1px solid black;
            }
            .toolBox a img {
                width: 40px important;
                height: 40px important;
                float: right;
                margin: 0px;
                padding: 0px;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <div id="workItemForm"></div>
        <table  border="0px" dir="<%=dir%>" class="table" style="width:700px;text-align: <%=align%>;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >
            <tr>
                <td class="td" colspan="2" style="text-align: center;">
                    <div class="toolBox" style="padding: 2px 2px 2px 0px; border-<%=align%>-width: 1px;">
                        <a href="#" onclick="JavaScript: openNewWorkItem();"><image style="height:45px;" src="images/icons/add.png" title="بند عمل جديد"/></a>
                    </div>
                </td>
            </tr>
        </table>
        <fieldset align="center" class="set">
            <legend align="center">

                <table dir=" RTL" align="center">
                    <tbody><tr>

                            <td class="td">
                                <font color="blue" size="6">عرض بنود الأعمال
                                </font>
                            </td>
                        </tr>
                    </tbody></table>
            </legend>
            <br>
            <center>
                <b> <font size="3" color="red"> عدد بنود الأعمال : <%=totalWorkItems%> </font></b>
            </center>
            <br>
            <table dir="RTL" align="RIGHT" width="100%" cellpadding="0" cellspacing="0" style="border-right-WIDTH:1px;"></table>
            <form action="<%=context%>/ProjectServlet?op=GetWorkItemsList" name="updateWorkItemForm" method="POST" onsubmit="return validateForm()"
                  style="width: 90%; margin-left: auto; margin-right: auto;">
                <div>
                    <input type="submit" class="saveBtn" value="Update Items"/>
                </div>
                <table id="workDataTable" align="center" dir="RTL" width="100%" cellpadding="0" cellspacing="0" style="border-right-WIDTH:1px;">
                    <thead>
                        <TR>
                            <th nowrap="" class="silver_header" width="150" bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                <input style="float:right;" type="checkbox" id="checkAll"/>
                            </th>
                            <th nowrap="" class="silver_header" width="150" bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                <b>كود البند</b>
                            </th>
                            <th nowrap="" class="silver_header" width="150" bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                <b>اسم بند العمل</b>
                            </th>
                            <th nowrap="" class="silver_header" width="150" bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                <b>نوع بند العمل</b>
                            </th>
                            <th nowrap="" class="silver_header" width="150" bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                <b>وحدة القياس</b>
                            </th>
                            <th nowrap="" class="silver_header" width="150" bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                <b>القيمة اﻷفتراضية</b>
                            </th>
                            <th nowrap="" class="silver_header" width="150" bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                <b>أقل سعر</b>
                            </th>
                            <th nowrap="" class="silver_header" width="150" bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                <b>أعلي سعر</b>
                            </th>
                        </TR>
                    </thead>
                    <tbody>

                        <%
                            WebBusinessObject workItemsWBO;
                            String projectName, projectID, projectCode, unit_id, unitValue, minValue, maxValue, itemType;
                            for (int i = 0; i < workItems.size(); i++) {
                                workItemsWBO = (WebBusinessObject) workItems.get(i);
                                projectName = (String) workItemsWBO.getAttribute("projectName");
                                projectID = (String) workItemsWBO.getAttribute("projectID");
                                projectCode = (String) workItemsWBO.getAttribute("eqNO");
                                unit_id = workItemsWBO.getAttribute("optionTwo") != null ? (String) workItemsWBO.getAttribute("optionTwo") : "";
                                itemType = workItemsWBO.getAttribute("optionOne") != null ? (String) workItemsWBO.getAttribute("optionOne") : "";
                                unitValue = "UL".equals(workItemsWBO.getAttribute("optionThree")) ? "0" : (String) workItemsWBO.getAttribute("optionThree");
                                minValue = "UL".equals(workItemsWBO.getAttribute("isMngmntStn")) ? "0" : (String) workItemsWBO.getAttribute("isMngmntStn");
                                maxValue = "UL".equals(workItemsWBO.getAttribute("integratedId")) ? "0" : (String) workItemsWBO.getAttribute("integratedId");
                        %>
                        <tr id="row">
                            <td style="text-align:Right">
                                <div>
                                    <input type="hidden" name="workItemcheckIndex" value="0">
                                    <input type="checkbox" name="workItemcheck" id="workItemcheck<%=i%>" value="<%=projectID%>"/>
                                </div>
                            </td>
                            <td style="text-align:Right" nowrap="" class="">
                                <div>

                                    <b style="color: red;"> <%=projectCode%>  </b>
                                </div>
                            </td>
                            <td style="text-align:Right" nowrap>
                                <div>

                                    <b> <%=projectName%>  </b>
                                </div>
                            </td>
                            <td style="text-align:Right">
                                <select name="equipClass" id="equipClass<%=i%>">
                                    <option value="">...</option>
                                    <sw:WBOOptionList wboList="<%=equipClass%>" displayAttribute="projectName" valueAttribute="projectID" scrollToValue="<%=itemType%>" />
                                </select>
                            </td>
                            <td style="text-align:Right">
                                <div>
                                    <select name="unit" id="unitID<%=i%>">
                                        <option value="null">...</option>
                                        <%
                                            for (int j = 0; j < measureUnits.size(); j++) {
                                                LiteWebBusinessObject measureUnitsWBO = (LiteWebBusinessObject) measureUnits.get(j);
                                                String unitId = (String) measureUnitsWBO.getAttribute("ID");
                                                String unitName = (String) measureUnitsWBO.getAttribute("arDesc");
                                                if (unit_id.equals(unitId)) {
                                                    out.println("<option value=\"" + unitId + "\" selected >" + unitName + "</option>");
                                                } else {
                                                    out.println("<option value=\"" + unitId + "\">" + unitName + "</option>");
                                                }
                                            }
                                        %>
                                    </select>
                                </div>
                            </td>
                            <td style="text-align:Right">
                                <div>
                                    <input type="number" name="value" id="value<%=i%>" value="<%=unitValue%>" style="width: 50px;" />
                                </div>
                            </td>
                            <td style="text-align:Right">
                                <input type="number" name="minValue" id="minValue<%=i%>" value="<%=minValue%>" style="width: 50px;" />
                            </td>
                            <td style="text-align:Right">
                                <input type="number" name="maxValue" id="maxValue<%=i%>" value="<%=maxValue%>" style="width: 50px;" />
                            </td>
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </form>
            <br/><br/>
        </fieldset>
    </body>
</html>
