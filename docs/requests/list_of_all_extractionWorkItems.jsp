<%-- 
    Document   : list_of_all_extractionMaintItems
    Created on : Oct 31, 2015, 4:58:49 PM
    Author     : abdo
--%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <%
            String issueId = (String) request.getAttribute("issueID");
            ArrayList<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");
            ArrayList<WebBusinessObject> allWorkItemsData=(ArrayList<WebBusinessObject>) request.getAttribute("workItemsList");
            ArrayList<WebBusinessObject> measuerUnits=(ArrayList<WebBusinessObject>) request.getAttribute("measuerUnits");
            WebBusinessObject clientWbo = (WebBusinessObject) request.getAttribute("clientWbo");
            boolean showInvoice = request.getAttribute("showInvoice") != null && request.getAttribute("showInvoice").equals("true");
        %>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link REL="stylesheet" TYPE="text/css" HREF="css/CSS.css" />
        <link REL="stylesheet" TYPE="text/css" HREF="css/Button.css" />
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
        <style>
            input.popupWidth
            {
                width: 50px;
                text-align: center;
            }
            thead
            {
                font-size: 12.5px;
            }
            .Red{color:#ff0000;}
            .Green{color:#009933;}
            .Yellow{color:#AA9739;}
            .qualityTD {
                background-color: #D4EAFF;
            }
            .priceTD {
                background-color: #FFFFCC;
            }
            .totalTD {
                background-color: #FFA366;
            }
            .titlebar {
                height: 30px;
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
        <script>
            $(document).ready(function() {
                $("table[name='workitemsTable']").dataTable({
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true,
                    "iDisplayLength": 50
                }).fadeIn(2000);
            });
            $(document).ready(function () 
            {
                $('[name="validitySelect" ]').removeClass($('[name="validitySelect" ]').attr('class'))
                        .addClass($(":selected", '[name="validitySelect" ]').attr('class'));
                computePrices();
            });
            $('[name="validitySelect" ]').change(function () {
                $(this).removeClass($(this).attr('class'))
                        .addClass($(":selected", this).attr('class'));
                /*If you want to keep some classes just add them back here*/
                //Optional: $(this).addClass("Classes that should always be on the select");

            });
            function computePrices()
            {
                var checks = $("input[name='check']");
                var total = 0;
                var temp, discount = 0;
                for(var i=0;i<checks.length;i++)
                {
                    discount = parseFloat($("#discount"+checks[i].value).val());
                    temp = $("#itemValue"+checks[i].value).val() * $("#itemQuantity"+checks[i].value).val();
                    if(!isNaN(discount)) {
                        temp -= (temp * discount /100);
                    }
                    $("#workItemPrice"+checks[i].value).val(temp);
                    total += temp;
                }
                $("#totalValues").html(total); 
            }
            function toggleSelect()
            {
                var checkAll = document.getElementById("checkAll");
                var checks = document.getElementsByName("check");
                if (checkAll.checked)
                {
                    for (var i = 0; i < checks.length; i++)
                    {
                        checks[i].checked = true;
                    }
                }
                else
                {
                    for (var i = 0; i < checks.length; i++)
                    {
                        checks[i].checked = false;
                    }
                }
            }
        </script>
    </head>
    <body>
        <form>
            <input type="hidden" name="op" value="getExtractionWorkItems"/>
            <input type="hidden" name="issueID" value="<%=issueId%>"/>
            <input type="hidden" name="businessID" value="<%=request.getAttribute("businessID")%>"/>
            <input type="hidden" name="businessIDbyDate" value="<%=request.getAttribute("businessIDbyDate")%>"/>
            <input type="hidden" name="showInvoice" value="<%=showInvoice%>"/>
            <div align="left" style="color:blue; margin-left: 2.5%">
                <button type="submit" style="float: left; margin-right: 10px; margin-bottom: 5px; width: 200px; height: 30px; font-size: 16px">حفظ&ensp;<img src="images/icons/accept.png" alt="" height="18" width="18" /></button>
            </div>
            <fieldset align="center" class="set">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td class="titlebar" style="text-align: center">
                            <font color="blue" size="5">عرض بنود المستخلص</font> <font color="red" size="5"><%=request.getAttribute("businessID")%></font>
                        </td>
                    </tr>
                </table>
                <%
                    if (clientWbo != null && clientWbo.getAttribute("name") != null) {
                %>
                <table dir=" RTL" align="center">
                    <tbody>
                        <tr>
                            <td class="td" style="text-align: center;">
                                <font color="blue" size="5">المقاول : </font><font size="5"><%=clientWbo.getAttribute("name")%></font>
                            </td>
                        </tr>
                    </tbody>
                </table>
                <%
                    }
                %>
                <br/>
                <div style="width: 90%; margin: auto;">
                <button type="button" onclick="JavaScript: alert('Under Construction')" style="float: left; margin-left: 50px; margin-bottom: 5px;">
                    <img style="height:25px;" src="images/icons/printer.png" title="طباعة البيانات">
                </button>
                <table name="workitemsTable" style="width: 100%">
                    <thead>
                        <tr>
                            <th>كلي البند</th>
                            <th>نسبة الخصم</th>
                            <th>السعر الفعلي</th>
                            <th>السعر الأفتراضي</th>
                            <th>الكميه</th>
                            <th>وحدة القياس</th>
                            <th>تعليقات الجودة</th>
                            <th style="width: 120px">القبول</th>
                            <th>نسبه الأنجاز %</th>
                            <th>أسم البند</th>
                            <th>كود البند</th>
                            <th>رقم الوحده</th>
                            <th>رقم طلب التسليم</th>
                            <th>
                                <input type="checkbox" id="checkAll" name="checkAll" onchange="toggleSelect()"/>
                            </th>
                        </tr>
                    </thead>
                    <tfoot>
                        <tr>
                            <th id="totalValues"></th>
                            <th colspan="13" style="text-align: left">اجمالي</th>
                        </tr>
                    </tfoot>
                    <tbody>
                        <%
                            int counter=0;
                            for (int i = 0; i < data.size(); i++)
                            {
                                List<WebBusinessObject> requestedItems = (ArrayList<WebBusinessObject>) data.get(i).getAttribute("requestedItems");
                                List<WebBusinessObject> requestedItems2 = (ArrayList<WebBusinessObject>) data.get(i).getAttribute("requestedItems2");
                                for (int j = 0; j < requestedItems.size(); j++)
                                {
                                    WebBusinessObject issue = (WebBusinessObject) data.get(i).getAttribute("issue");
                                    String unitNumber = issue != null && issue.getAttribute("unitId") != null ? (String) issue.getAttribute("unitId") : null;
                                    String id = (String) requestedItems.get(j).getAttribute("id");
                                    String code = (String) requestedItems.get(j).getAttribute("itemCode");
                                    String itemName = (String) requestedItems.get(j).getAttribute("itemName");
                                    String validity = (String) requestedItems.get(j).getAttribute("valid");
                                    String note = (String) requestedItems2.get(j).getAttribute("note");
                                    String quantity=(String)requestedItems.get(j).getAttribute("quantity");
                                    if (note == null)
                                    {
                                        note = "";
                                    }
                                    WebBusinessObject workItemsWBO = allWorkItemsData.get(getWorkItem(itemName, allWorkItemsData));
                                    String unit_id = (String) workItemsWBO.getAttribute("optionTwo");
                                    String unitValue = "UL".equals(workItemsWBO.getAttribute("optionThree")) ? "0" : (String) workItemsWBO.getAttribute("optionThree");
                                    WebBusinessObject unit=getWorkItemUnit(unit_id, measuerUnits);

                        %>
                        <tr>
                            <td class="totalTD">
                                <input id="workItemPrice<%=counter%>" class="popupWidth" type="number" min="0" name="total" value="" readonly="readonly" />
                            </td>
                            <td>
                                <input id="discount<%=counter%>" class="popupWidth" type="number" min="0" name="discount" value="<%=requestedItems2.get(j).getAttribute("option5") == null || requestedItems2.get(j).getAttribute("option5").equals("UL") ? "" : requestedItems2.get(j).getAttribute("option5")%>" onchange="JavaScript: computePrices('<%=counter%>')"/>
                            </td>
                            <td class="priceTD">
                                <input id="itemValue<%=counter%>" class="popupWidth" type="number" name="price" <%=showInvoice ? "readonly" : ""%>
                                       value="<%=requestedItems2.get(j).getAttribute("option4") == null || requestedItems2.get(j).getAttribute("option4").equals("UL") ? unitValue : requestedItems2.get(j).getAttribute("option4")%>" onchange="JavaScript: computePrices('<%=counter%>')" />
                            </td>
                            <td class="qualityTD">
                                <%=unitValue%>
                            </td>
                            <td><input id="itemQuantity<%=counter%>" class="popupWidth" type="number" min="1" name="quantity" <%=showInvoice ? "readonly" : ""%>
                                       value="<%=quantity%>" onchange="JavaScript: computePrices('<%=counter%>')" /></td>
                            <td><%=unit != null ? unit.getAttribute("arDesc") : ""%></td>
                            <td class="qualityTD">
                                <%=note%>
                            </td>
                            <td class="qualityTD">
                                <%
                                    if ("1".equalsIgnoreCase(validity)) {
                                %>
                                مقبول
                                <%
                                } else if ("0".equalsIgnoreCase(validity)) {
                                %>
                                مرفوض
                                <%
                                } else if ("2".equalsIgnoreCase(validity)) {
                                %>
                                مقبول بملاحظات
                                <%
                                    }
                                %>
                            </td>
                            <td class="qualityTD">
                                <%=requestedItems2.get(j).getAttribute("option1")%>
                            </td>
                            <td>
                                <%=itemName%>
                            </td>
                            <td>
                                <%=code%>
                            </td>
                            <td>
                                <%=unitNumber%>
                            </td>
                            <td nowrap>
                                <font color="red"><%=data.get(i).getAttribute("businessID")%></font><font color="blue">/<%=data.get(i).getAttribute("businessIDbyDate")%></font>
                            </td>
                            <td>
                                <input type="checkbox" name="check" value="<%=counter%>" />
                                <input type="hidden" name="id" value="<%=id%>"/>
                            </td>
                        </tr>
                        <%
                                    counter++;
                                }
                            }
                        %>
                    </tbody>
                </table>
                </div>
                <br/>
            </fieldset>
        </form>
    </body>
</html>
<%!
public int getWorkItem(String workItemName,ArrayList<WebBusinessObject> allWorkItemsData)
{
    for(int i=0;i<allWorkItemsData.size();i++)
    {
        WebBusinessObject workItemWBO = (WebBusinessObject) allWorkItemsData.get(i);
        String projectName = (String) workItemWBO.getAttribute("projectName");
        if(workItemName.equals(projectName))
        {
            return i;
        }
    }
    return -1;
}
public WebBusinessObject getWorkItemUnit(String unit_id,ArrayList<WebBusinessObject>measuerUnits)
{
    for (int i = 0; i < measuerUnits.size(); i++)
    {
        WebBusinessObject measureUnitsWBO = (WebBusinessObject) measuerUnits.get(i);
        String unitId = (String) measureUnitsWBO.getAttribute("ID");
        if(unitId.equals(unit_id))
        {
            return measureUnitsWBO;
        }
    }
    return null;
}
%>