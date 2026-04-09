<%@page import="java.util.List"%>
<%@page import="com.silkworm.common.EmpRelationMgr"%>
<%@page import="com.maintenance.db_access.EmployeeMgr"%>
<%@page import="com.sun.imageio.plugins.wbmp.WBMPImageReader"%>
<%@page import="com.maintenance.db_access.UserTradeMgr"%>
<%@page import="com.silkworm.common.UserGroupMgr"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.UserMgr"%>
<%@ page import="com.silkworm.business_objects.WebBusinessObject,java.util.Vector,com.tracker.db_access.ProjectMgr"%>
<%@ page pageEncoding="UTF-8"%>
<%
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    WebBusinessObject wbo;
    String departmentMgrId = (String) request.getAttribute("departmentMgrId");
    String departmentMgrName = (String) request.getAttribute("departmentMgrName");
    List<WebBusinessObject> employees = (List<WebBusinessObject>) request.getAttribute("employees");
    if (employees == null) {
        employees = new ArrayList<WebBusinessObject>();
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">

        <head>
            <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
                <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
                    <LINK rel="stylesheet" type="text/css" href="css/blueStyle.css" />
                    <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
                    </head>

                    <%
                        int i = 0, j = 0;
                        WebBusinessObject mainProjectWbo = null, subProjectWbo = null;

                        Vector mainProducts = (Vector) request.getAttribute("mainProducts"), subProjectVec = null;
                        String mainProductId = null, subProducttId = null;

                        String stat = (String) request.getSession().getAttribute("currentMode");
                        String align, dir, style, checkAllStr;

                        UserTradeMgr groupMgr = UserTradeMgr.getInstance();
                        ArrayList<WebBusinessObject> users = groupMgr.getSalesUsers();

                        if (stat.equals("En")) {

                            align = "left";
                            dir = "LTR";
                            style = "text-align:left";
                            checkAllStr = "Check All";

                        } else {

                            align = "right";
                            dir = "RTL";
                            style = "text-align:Right";
                            checkAllStr = "إختر الكل";

                        }

                    %>

                    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
                        var checked = false;
                        var totalSubProjectCount = null;

                        function checkSubProjects(mainProductId) {
                            if (document.getElementById('mainProject' + mainProductId).checked == true) {
                                checked = true;

                                totalSubProjectCount = document.getElementById('totalSubProjectCount' + mainProductId).value;
                                for (var i = 0; i < totalSubProjectCount; i++) {
                                    document.getElementById('subProduct' + mainProductId + i).checked = checked;
                                }

                            } else {
                                checked = false;
                            }

                        }

                        function checkAllProjects() {
                            var allProjectsCbx = document.getElementById('allProjectsCbx');
                            var allProjects = document.getElementById('siteAll');
                            var projectArr = document.getElementsByName('site');

                            if (allProjectsCbx.checked == true) {
                                checked = true;
                                allProjects.value = "yes";

                            } else {
                                checked = false;
                                allProjects.value = "no";

                            }

                            for (var i = 0; i < projectArr.length; i++) {
                                projectArr[i].checked = checked;
                            }

                        }

                        /*
                         // trying to check/uncheck 'check all' checkbox automatically
                         function getChecked() {
                         
                         var checkedOffsprings = false;
                         
                         var allProjectsCbx = document.getElementById('allProjectsCbx');
                         var projectArr = document.getElementsByName('site');
                         
                         for (var i = 0; i < projectArr.length; i++) {
                         if(projectArr[i].checked == false) {
                         checkedOffsprings = false;
                         break;
                         
                         }
                         }
                         alert(checkedOffsprings)
                         allProjectsCbx.checked = checkedOffsprings;
                         }
                         */

                        function getEquipmentInPopup() {

                            var sites = document.getElementsByName('site');
                            var count = 0;

                            for (var i = 0; i < sites.length; i++) {
                                if (sites[i].checked) {
                                    count++;

                                }
                            }
                            if (count > 0) {
                                getDataInPopup('ReportsServletThree?op=ListEquipments' + '&fieldName=UNIT_NAME&fieldValue=' + getASSCIChar(document.getElementById('unitName').value) + '&site=' + getSites() + '&formName=SEARCH_MAINTENANCE_FORM');
                            } else {
                                alert("Must select at least one Site");
                            }
                        }

                        function getSites() {

                            var sitesValues = "'";
                            var sites = document.getElementsByName('site');
                            for (var i = 0; i < sites.length; i++) {
                                if (sites[i].checked) {
                                    sitesValues = sitesValues + sites[i].value + "','";
                                }
                            }

                            return sitesValues + "'";
                        }





                        function addTasks() {
                            var selectedProductArr = $('#products').find(':checkbox:checked');
                            var productId, productName, parentProductName, parentProductId;
                            var productTable = window.opener.jQuery("#products_table");
                            var insertedTable = window.opener.document.getElementById('products_table');
                            var viewEmployeeLoads = window.opener.document.getElementById('viewEmployeeLoads');
                            var businessId = window.opener.document.getElementById('businessId');

                            $(selectedProductArr).each(function(index, product) {
                                productId = $(product).parent().find('#productId').val();
                                parentProductId = $(product).parent().parent().parent().find('#parentProductId').val();
                                productName = $(product).parent().find('#productName').val();
                                if (productName == null || productName == "" || productName == "undefiend") {
                                    productName = "تصنيف عام";
                                }
                                if (productId == null || productId == "" || productId == "undefiend") {
                                    productId = "1364111290870";
                                }
                                parentProductName = $(product).parent().find('#parentProductName').val();
                                row = insertedTable.insertRow(-1);

                                var cell0 = row.insertCell(0);
                                cell0.innerHTML = "<input type='hidden' id='departmentMgrId' value='" +<%=departmentMgrId%> + "' /><SELECT name='employeeId' id='employeeId' style='width:150px;font-size:13px;'>\n\
                               <option value='" +<%=departmentMgrId%> + "'><%=departmentMgrName%></option>\n\
                        <%

                            if (employees.size() > 0) {
                                String userId = "";
                                String userName = null;
                                for (int q = 0; q < employees.size(); q++) {
                                    wbo = (WebBusinessObject) employees.get(q);
                                    userId = (String) wbo.getAttribute("userId");
                                    userName = (String) wbo.getAttribute("fullName");
                                    if (!departmentMgrId.equalsIgnoreCase(userId)) {
                        %>\n\<option value='<%=userId%>'><%=userName%></option>\n\
                        <%}
                                }
                            }%>\n\
    </select>"
                                var cell1 = row.insertCell(1);
                                cell1.width = "30%";
                                cell1.innerHTML = parentProductName;

                                var cell2 = row.insertCell(2);
                                cell2.innerHTML = productName;

                                var cell3 = row.insertCell(3);
                                cell3.innerHTML = "<SELECT name='period' id='period'>فى خلال \n\
                          <OPTION value='1'>1</OPTION> <OPTION value='2'>2</OPTION> \n\
                        <% for (int c = 3; c < 6; c++) {%> \n\
                              <OPTION value='<%=c%>'><%=c%></OPTION> \n\
                        <% }%>\n\
                        </SELECT>";
                        <%--  cell3.innerHTML = "<SELECT name='period' id='period'>فى خلال \n\
                    <OPTION value='سنة'>سنة</OPTION> <OPTION value='سنتين'>سنتين</OPTION> \n\
                  <% for (int c = 3; c <= 10; c++) {%> \n\
                        <OPTION value='<%=c%>month'><%=c%>سنين</OPTION> \n\
                  <% }%>\n\
                  <% for (int c = 11; c <= 15; c++) {%> \n\
                          <OPTION value='<%=c%>سنه'><%=c%>سنه</OPTION> \n\
              <% }%></SELECT>"; --%>

                                var cell4 = row.insertCell(4);
                                cell4.innerHTML = " <SELECT name='paymentSystem' id='paymentSystem'>نظام الدفع\n\
                                  <OPTION>نقدى</OPTION>\n\
                                                <OPTION>تقسيط</OPTION>\n\
                                            </SELECT>";
//                                    var cell5 = row.insertCell(5);
//                                    cell5.width = "5%";
//                                    cell5.innerHTML = "<input type='text' maxlength='20' name='budget' id='budget' style='width:80px' onkeyup='totalCost(this,event)' value='0'/>";
//                                    cell5.innerHTML = "<input type='text' maxlength='20' name='budget' id='budget' style='width:80px' value='0'/>";
                                var cell5 = row.insertCell(5);
                                cell5.innerHTML = "<input type='text' maxlength='20' name='budget' id='budget' style='width:80px' value='0'/> <input type='hidden' name='notes' id='notes'style='width:80px'  value='0'/><input type='hidden' name='productId' id='productId' value='" + productId + "' />\n\
                    <input type='hidden' name='productCategoryName' id='productCategoryName' value='" + parentProductName + "' />\n\
                <input type='hidden' name='productName' id='parentProductId' value='" + parentProductId + "' />\n\
                            <input type='hidden' name='productName' id='productName' value='" + productName + "'/>";
//                                    var cell7 = row.insertCell(7);
//                                    cell7.width = "5%";
//                                    cell7.innerHTML = "<input readonly='true' type='text' maxlength='20' name='totalCostForProducts' id='totalCostForProducts' style='width:80px'value='0'/>";
                                var cell6 = row.insertCell(6);
                                cell6.innerHTML = "<div <input type='button' class='save' id='save' name='save' onclick='saveProduct(this)'/></div>";
                                var cell7 = row.insertCell(7);
                                cell7.innerHTML = "<div type='button' class='remove' id='removeRow' name='removeRow' onclick='removeRow(this)'></div>";


                                insertedTable.style.display = "block";
                                viewEmployeeLoads.style.display = "block";
                                window.close();


                            }

                            );
                        }

                        function sendData(mainProducId,obj) {
                        
//                            var selectedProductArr = $('#products').find(':checkbox:checked');
                            var productId, productName, parentProductName, parentProductId;
                            var productTable = window.opener.jQuery("#products_table");
                            var insertedTable = window.opener.document.getElementById('products_table');
                            var viewEmployeeLoads = window.opener.document.getElementById('viewEmployeeLoads');
                            var businessId = window.opener.document.getElementById('businessId');

//                            $(selectedProductArr).each(function(index, product) {
                                productId = $(obj).parent().find('#productId').val();
                                parentProductId = $(obj).parent().parent().parent().find('#parentProductId').val();
                                productName = $(obj).parent().find('#productName').val();
                                if (productName == null || productName == "" || productName == "undefiend") {
                                    productName = "تصنيف عام";
                                }
                                if (productId == null || productId == "" || productId == "undefiend") {
                                    productId = "1364111290870";
                                }
                                parentProductName = $(obj).parent().find('#parentProductName').val();
                                row = insertedTable.insertRow(-1);

                                var cell0 = row.insertCell(0);
                                cell0.innerHTML = "<input type='hidden' id='departmentMgrId' value='" +<%=departmentMgrId%> + "' /><SELECT name='employeeId' id='employeeId' style='width:150px;font-size:13px;'>\n\
                               <option value='" +<%=departmentMgrId%> + "'><%=departmentMgrName%></option>\n\
                        <%

                            if (employees.size() > 0) {
                                String userId = "";
                                String userName = null;
                                for (int q = 0; q < employees.size(); q++) {
                                    wbo = (WebBusinessObject) employees.get(q);
                                    userId = (String) wbo.getAttribute("userId");
                                    userName = (String) wbo.getAttribute("fullName");
                                    if (!departmentMgrId.equalsIgnoreCase(userId)) {
                        %>\n\<option value='<%=userId%>'><%=userName%></option>\n\
                        <%}
                                }
                            }%>\n\
    </select>"
                                var cell1 = row.insertCell(1);
                                cell1.width = "30%";
                                cell1.innerHTML = parentProductName;

                                var cell2 = row.insertCell(2);
                                cell2.innerHTML = "<SELECT name='period' id='period'>فى خلال \n\
                          <OPTION value='1'>1</OPTION> <OPTION value='2'>2</OPTION> \n\
                        <% for (int c = 3; c < 6; c++) {%> \n\
                              <OPTION value='<%=c%>'><%=c%></OPTION> \n\
                        <% }%>\n\
                        </SELECT>";
                        <%--  cell2.innerHTML = "<SELECT name='period' id='period'>فى خلال \n\
                    <OPTION value='سنة'>سنة</OPTION> <OPTION value='سنتين'>سنتين</OPTION> \n\
                  <% for (int c = 3; c <= 10; c++) {%> \n\
                        <OPTION value='<%=c%>month'><%=c%>سنين</OPTION> \n\
                  <% }%>\n\
                  <% for (int c = 11; c <= 15; c++) {%> \n\
                          <OPTION value='<%=c%>سنه'><%=c%>سنه</OPTION> \n\
              <% }%></SELECT>"; --%>

                                var cell3 = row.insertCell(3);
                                cell3.innerHTML = " <SELECT name='paymentSystem' id='paymentSystem'>نظام الدفع\n\
                                  <OPTION>نقدى</OPTION>\n\
                                                <OPTION>تقسيط</OPTION>\n\
                                            </SELECT>";
//                                    var cell5 = row.insertCell(5);
//                                    cell5.width = "5%";
//                                    cell5.innerHTML = "<input type='text' maxlength='20' name='budget' id='budget' style='width:80px' onkeyup='totalCost(this,event)' value='0'/>";
//                                    cell5.innerHTML = "<input type='text' maxlength='20' name='budget' id='budget' style='width:80px' value='0'/>";
                                var cell4 = row.insertCell(4);
                                cell4.innerHTML = "<input type='text' maxlength='20' name='budget' id='budget' style='width:80px' value='0'/> <input type='hidden' name='notes' id='notes'style='width:80px'  value='0'/><input type='hidden' name='productId' id='productId' value='" + productId + "' />\n\
                    <input type='hidden' name='productCategoryName' id='productCategoryName' value='" + parentProductName + "' />\n\
                <input type='hidden' name='productName' id='parentProductId' value='" + parentProductId + "' />\n\
                            <input type='hidden' name='productName' id='productName' value='" + productName + "'/>";
//                                    var cell7 = row.insertCell(7);
//                                    cell7.width = "5%";
//                                    cell7.innerHTML = "<input readonly='true' type='text' maxlength='20' name='totalCostForProducts' id='totalCostForProducts' style='width:80px'value='0'/>";
                                var cell5 = row.insertCell(5);
                                cell5.innerHTML = "<div <input type='button' class='save' id='save' name='save' onclick='saveProduct(this)'/></div>";
                                var cell6 = row.insertCell(6);
                                cell6.innerHTML = "<div type='button' class='remove' id='removeRow' name='removeRow' onclick='removeRow(this)'></div>";


                                insertedTable.style.display = "block";
                                viewEmployeeLoads.style.display = "block";
                                window.close();


//                            }

//                            );
                        }




                        function sendInfo(mainProduectId, mainProduectName, subProduectId, subProduectName) {

                            //            if (isExecutedFound(taskId)) {
                            //                alert(" that item is exist already in executed tasks table");
                            //                return;
                            //            }

                            //            if (isFound(taskId)) {
                            //                alert(" that item is exist already in the table");
                            //                return;
                            //            }

                            //            var className = "tRow";
                            //            if ((numRows % 2) == 1)
                            //            {
                            //                className = "tRow";
                            //            } else {
                            //                className = "tRow2";
                            //            }

                            var x = window.opener.document.getElementById('products_table').insertRow();

                            var C1 = x.insertCell(0);
                            var C2 = x.insertCell(1);
                            var C3 = x.insertCell(2);
                            var C4 = x.insertCell(3);
                            //            var C5 = x.insertCell(4);
                            //            var C6 = x.insertCell(5);
                            //            var C7 = x.insertCell(6);
                            //var C8 = x.insertCell(7);

                            C1.borderWidth = "3px";
                            C1.borderColor = "white";
                            C1.id = "codeTask";
                            C1.bgColor = "powderblue";
                            C1.className = className;

                            C2.borderWidth = "1px";
                            C2.id = "descEn";
                            C2.bgColor = "powderblue";
                            C2.className = className;

                            C3.borderWidth = "1px";
                            C3.id = "trade";
                            C3.bgColor = "powderblue";
                            C3.className = className;
                        }
                    </SCRIPT>
                    <style>
                        #products{
                            direction: rtl;
                            margin-left: auto;
                            margin-right: auto;

                        }
                        #products tr{
                            padding: 5px;
                        }
                        #products td{                font-size: 12px;
                                                     font-weight: bold;}
                        #products select{                font-size: 12px;
                                                         font-weight: bold;}
                        .button_products{
                            width:145px;
                            height:31px;
                            /*            margin: 4px;*/
                            background-repeat: no-repeat;
                            cursor: pointer;
                            border: none;
                            background-position: right top ;
                            display: inline-block;
                            background-color: transparent;
                            background-image:url(images/buttons/select.png);


                        }

                    </style>
                    <BODY>
                        <input type="hidden" id="siteAll" value="no" name="siteAll"/>
                        <!--<div style="position:fixed;top: 45%;right: 5px;"> <input type="button" onclick="addTasks()"  class ="button_products" /></DIV>-->
                        <div id='projectScroll' style="width:70%;margin-right:150px;float: right;margin-left: 10px;">
                            <TABLE  id="products" CELLPADDING="0" CELLSPACING="0" STYLE="border:0px;margin-left:5px;width:70%;float: right;" align="center"  DIR="<%=dir%>">
                                <%
                                    while (i < mainProducts.size()) {
                                        mainProjectWbo = (WebBusinessObject) mainProducts.get(i);
                                        mainProductId = (String) mainProjectWbo.getAttribute("projectID");
                                        String mainProductName = (String) mainProjectWbo.getAttribute("projectName");

                                %>
                                <TR>
                                    <TD style="cursor: pointer" onmouseover="this.className = 'order'" onclick="sendData(<%=mainProductId%>,this)" onmouseout="this.className = 'act_sub_heading'" CLASS="act_sub_heading" WIDTH="100%" STYLE="<%=style%>;padding-<%=align%>:5;background-image: url('images/gradient.gif');background-repeat: repeat-x;">
                                        <!--<INPUT TYPE="CHECKBOX" NAME="site" ID="mainProject<%=i%>" value=""  onclick="checkSubProjects(<%=i%>);
//                                                getChecked()"/> -->
                                        <a href="#"  onclick="sendData(<%=mainProductId%>,this)"/>
                                        <%=mainProductName%>
                                        <input type="hidden" id="productName" name="productName" value=""/>
                                        <input type="hidden" id="mainProject" name="mainProject" value="<%=mainProductId%>"/>
                                        <input type="hidden" id="parentProductName" name="parentProductName" value="<%=mainProductName%>"/>
                                        <input type="hidden" id="parentProductId" name="parentProductId" value="<%=mainProductId%>"/>
                                    </TD>
                                </TR>

                                <input type="hidden" name="totalSubProjectCount<%=i%>" id="totalSubProjectCount<%=i%>" value="<%=j%>">

                                    <%
                                            j = 0;
                                            i++;
                                        }
                                    %>

                            </TABLE>
                        </DIV>

                    </BODY>
                    </HTML>