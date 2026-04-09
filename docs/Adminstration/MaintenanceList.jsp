<%-- 
    Document   : WorkList
    Created on : Oct 10, 2015, 1:03:44 PM
    Author     : walid
--%>
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
                    }
                    else
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
                var checkedNumber=0;
                for (var i = 0; i < checkBoxes.length; i++)
                {
                    if (checkBoxes[i].checked === true)
                    {
                        checkBoxesindex[i].value="1";
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
                }
                else
                {
                    return true;
                }
            }
        </script>
    </head>
    <%
        ArrayList<WebBusinessObject> workItems = (ArrayList<WebBusinessObject>) request.getAttribute("workItemsList");
        ArrayList<WebBusinessObject> measureUnits = (ArrayList<WebBusinessObject>) request.getAttribute("measuerUnits");
        Vector equipClass = (Vector) request.getAttribute("equipClass");
        int totalWorkItems = workItems.size();
    %>
    <body>
        <fieldset align="center" class="set">
            <legend align="center">

                <table dir=" RTL" align="center">
                    <tbody><tr>

                            <td class="td">
                                <font color="blue" size="6">عرض بنود الصيانة
                                </font>
                            </td>
                        </tr>
                    </tbody></table>
            </legend>
            <br>
            <center>
                <b> <font size="3" color="red"> عدد بنود الصيانة : <%=totalWorkItems%> </font></b>
            </center>
            <br>
            <table dir="RTL" align="RIGHT" width="100%" cellpadding="0" cellspacing="0" style="border-right-WIDTH:1px;"></table>
            <form action="<%=context%>/ProjectServlet?op=GetMaintenanceItemsList" name="updateWorkItemForm" method="POST" onsubmit="return validateForm()">
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
                                <b>أسم بند الصيانة</b>
                            </th>
                            <th nowrap="" class="silver_header" width="150" bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                <b>وحدة القياس</b>
                            </th>
                            <th nowrap="" class="silver_header" width="150" bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                <b>القيمة اﻷفتراضية</b>
                            </th>
                            <th nowrap="" class="silver_header" width="150" bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                <b>نوع المعدة</b>
                            </th>
                        </TR>
                    </thead>
                    <tbody>

                        <%
                            for (int i = 0; i < workItems.size(); i++)
                            {
                                WebBusinessObject workItemsWBO = (WebBusinessObject) workItems.get(i);
                                String projectName = (String) workItemsWBO.getAttribute("projectName");
                                String projectID = (String) workItemsWBO.getAttribute("projectID");
                                String projectCode = (String) workItemsWBO.getAttribute("eqNO");
                                String unit_id = (String) workItemsWBO.getAttribute("optionTwo");
                                String unitValue = (String) workItemsWBO.getAttribute("optionThree");
                                String equipClassId = (String) workItemsWBO.getAttribute("coordinate");
                        %>
                        <tr id="row">
                            <td style="text-align:Right" bgcolor="#DDDD00" nowrap="" class="silver_odd">
                                <div>
                                    <input type="hidden" name="workItemcheckIndex" value="0">
                                    <input type="checkbox" name="workItemcheck" id="workItemcheck<%=i%>" value="<%=projectID%>"/>
                                </div>
                            </td>
                            <td style="text-align:Right" bgcolor="#DDDD00" nowrap="" class="silver_odd">
                                <div>

                                    <b style="color: red;"> <%=projectCode%>  </b>
                                </div>
                            </td>
                            <td style="text-align:Right" bgcolor="#DDDD00" nowrap="" class="silver_odd">
                                <div>

                                    <b style="color: red;"> <%=projectName%>  </b>
                                </div>
                            </td>
                            <td style="text-align:Right" bgcolor="#DDDD00" nowrap="" class="silver_odd">
                                <div>
                                    <select name="unit" id="unitID<%=i%>">
                                        <option value="null">...</option>
                                        <%
                                            for (int j = 0; j < measureUnits.size(); j++)
                                            {
                                                WebBusinessObject measureUnitsWBO = (WebBusinessObject) measureUnits.get(j);
                                                String unitId = (String) measureUnitsWBO.getAttribute("ID");
                                                String unitName = (String) measureUnitsWBO.getAttribute("arDesc");
                                                if (unit_id.equals(unitId))
                                                {
                                                    out.println("<option value=\"" + unitId + "\" selected >" + unitName + "</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option value=\"" + unitId + "\">" + unitName + "</option>");
                                                }
                                            }
                                        %>
                                    </select>
                                </div>
                            </td>
                            <td style="text-align:Right" bgcolor="#DDDD00" nowrap="" class="silver_odd">
                                <div>
                                    <input type="number" name="value" id="value<%=i%>" value="<%=unitValue%>" />
                                </div>
                            </td>
                            <td style="text-align:Right" bgcolor="#DDDD00" nowrap="" class="silver_odd">
                                <div>
                                    <select name="equipClass" id="equipID<%=i%>">
                                        <option value="null">...</option>
                                        <%
                                            for (int j = 0; j < equipClass.size(); j++)
                                            {
                                                WebBusinessObject equipWBO = (WebBusinessObject) equipClass.get(j);
                                                String equipId = (String) equipWBO.getAttribute("projectID");
                                                String equipName = (String) equipWBO.getAttribute("projectName");
                                                if (equipId.equals(equipClassId))
                                                {
                                                    out.println("<option value=\"" + equipId + "\" selected >" + equipName + "</option>");
                                                }
                                                else
                                                {
                                                    out.println("<option value=\"" + equipId + "\">" + equipName + "</option>");
                                                }
                                            }
                                        %>
                                    </select>
                                </div>
                            </td>
                            
                        </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </form>
            <TABLE align="center" dir="RTL" width="400" cellpadding="0" cellspacing="0" style="border-right-WIDTH:1px;">
                <tr>
                    <td class="silver_footer" bgcolor="#808080" colspan="1" style="text-align:Right;padding-right:5;border-right-width:1;font-size:16;">
                        <b>عدد بنود الصيانة</b>
                    </td>
                    <td class="silver_footer" bgcolor="#808080" colspan="2" style="text-align:Right;padding-left:5;font-size:16;">

                        <div name="" id="">
                            <b><%=totalWorkItems%></b>
                        </div>
                    </td>
                </tr>          
            </TABLE>

            <br><br>
        </fieldset>
    </body>
</html>
