<%-- 
    Document   : clientsCommChannels
    Created on : Oct 17, 2018, 9:33:39 AM
    Author     : walid
--%>

<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <TITLE>System Departments List</TITLE>
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.structure.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.structure.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery.datetimepicker.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css" />
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery.datetimepicker.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
        
        <style>
            td.silver_header{
                text-align: right;
            }
            
            input.saveBtn{
                float:left;
                width: 240px;
                height: 35px;
                font-weight: bold;
                font-size: 20px;
                font-family: "Times New Roman";
            }
            
            th.silver_header{
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
                $("#comChannel").select2();
                
                $("#workDataTable").dataTable({
                    "columnDefs": [
                        {"width": "5%", "targets": 0},
                        {orderable: false, targets: [0, 4]}
                    ],
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "bAutoWidth": true,
                    "aaSorting": [[0, "asc"]]
                });
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy/mm/dd'
                });
                
                $("#checkAll").change(function ()
                {
                    var checkBoxes = document.getElementsByName("clientcheck");
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
                var checkBoxes = document.getElementsByName("clientcheck");
                var checkBoxesindex = document.getElementsByName("clientscheckIndex");
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
                    alert("check clients first");
                    return false;
                }
                else
                {
                    return true;
                }
            }
            
            function chngCtgry(){
                document.updateClientsForm.action = "<%=context%>/AppointmentServlet?op=clientsCommChannels&chngCt=1";
                document.updateClientsForm.submit();
            }
            function submitForm() {
                document.COMM_CHANNEL_FORM.action = "<%=context%>/AppointmentServlet?op=clientsCommChannels";
                document.COMM_CHANNEL_FORM.submit();
            }
            
        </script>
    </head>
    <%
        ArrayList<WebBusinessObject> clientsLst = (ArrayList<WebBusinessObject>) request.getAttribute("clientsLst");
        ArrayList<WebBusinessObject> comCahhnels = (ArrayList<WebBusinessObject>) request.getAttribute("comCahhnels");
        ArrayList<WebBusinessObject> groupsList = (ArrayList<WebBusinessObject>) request.getAttribute("groupsList");
        String groupID = request.getAttribute("groupID") != null ? (String) request.getAttribute("groupID") : "";
        String fromDate = (String) request.getAttribute("fromDate");
        String toDate = (String) request.getAttribute("toDate");
        
        String stat = (String) request.getSession().getAttribute("currentMode");
        String dir, title, upComChan, clntNo, clntName, clntMob, clntComChannel, email,interPhone,
                fromDateStr, toDateStr, group, search, notes;
        if (stat.equals("En")) {
            dir = "LTR";
            title = "Clients Without Communication Channels";
            upComChan = "Set Communication Channel";
            clntNo = "Client No.";
            clntName = "Client Name";
            clntMob = "Mobile";
            clntComChannel = "Communication Channel";
            email = "Email";
            interPhone = "International No.";
            fromDateStr = "From Date";
            toDateStr = "To Date";
            group = "Group";
            search = "Search";
            notes = "Notes";
        } else {
            dir = "RTL";
            title = "عملاء بدون قنوات إتصال";
            upComChan = "إضافة قناة إتصال للعملاء";
            clntNo = "رقم العميل";
            clntName = "إسم العميل";
            clntMob = "الموبايل";
            clntComChannel = "قناة الإتصال";
            email = "الإيميل";
            interPhone = "الرقم الدولى";
            fromDateStr = "من تاريخ";
            toDateStr = "إلي تاريخ";
            group = "المجموعة";
            search = "بحث";
            notes = "ملاحظات";
        }
    %>
    <body>
        <fieldset align="center" class="set">
            <legend align="center">

                <table dir=" RTL" align="center">
                    <tbody><tr>

                            <td class="td">
                                <font color="blue" size="6">
                                    <%=title%>
                                </font>
                            </td>
                        </tr>
                    </tbody></table>
            </legend>
            <br/>
            <form name="COMM_CHANNEL_FORM" method="post">
                <table class="blueBorder" align="CENTER" dir="<%=dir%>" id="code" width="30%" style="border-width: 1px; border-color: white; display: block;">
                       <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b>
                                <font size=3 color="white"> 
                                <%=fromDateStr%>
                                </font>
                            </b>
                        </td>
                        <td  class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="50%">
                            <b>
                                <font size=3 color="white"> 
                                <%=toDateStr%>
                                </font>
                            </b>
                        </td>
                    </tr>
                    <tr>
                        <td  bgcolor="#dedede" valign="middle" >
                            <input type="text" style="width:190px" ID="fromDate" name="fromDate" size="20" maxlength="100" readonly="true"
                                   value="<%=fromDate%>"/>
                        </td>
                        <td  bgcolor="#dedede" valign="middle" width="30%">
                            <input type="text" style="width:190px" ID="toDate" name="toDate" size="20" maxlength="100" readonly="true"
                                   value="<%=toDate%>"/>
                        </td>
                    </tr>

                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b>
                                <font size=3 color="white"> 
                                <%=group%>
                                </font>
                            </b>
                        </td>
                    </tr>

                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <select style="font-size: 14px;font-weight: bold; width: 250px;" name="groupID" id="groupID" onchange="getGrpEmp();" >
                                <sw:WBOOptionList wboList='<%=groupsList%>' displayAttribute="groupName" valueAttribute="groupID" scrollToValue="<%=groupID%>"/>
                            </select>
                        </td>
                    </tr>
                </table>
            </form>
            <button class="button" type="button" onclick="JavaScript: submitForm();" style="color: #27272A; font-size: 15px; font-weight: bold;"><%=search%><IMG HEIGHT="15" SRC="images/search.gif"> </button>
            <br>
            <br>
            <table dir="<%=dir%>" align="RIGHT" width="100%" cellpadding="0" cellspacing="0" style="border-right-WIDTH:1px;"></table>
            <form action="<%=context%>/AppointmentServlet?op=clientsCommChannels" name="updateClientsForm" method="POST" onsubmit="return validateForm()">
                <div style="margin-bottom: 5px;">
                    <select name="comChannel" id="comChannel" style="width: 30%;">
                         <sw:WBOOptionList wboList='<%=comCahhnels%>' displayAttribute = "englishName" valueAttribute="id"/>
                    </select>
                    
                    <input style="margin-bottom: 10px;" type="button" value="<%=upComChan%>" onclick="chngCtgry();"/>
                </div>
                <br><br>
                <div style="width: 90%;margin-left:5%; "align="center" >
                    <table id="workDataTable" align="center" dir="RTL" width="100%" cellspacing="10">
                        <thead>
                            <TR>
                                <th nowrap="" class="silver_header"  bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                    <input style="float:right;" type="checkbox" id="checkAll"/>
                                </th>
                                <th nowrap="" class="silver_header" bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                    <b><%=clntNo%></b>
                                </th>
                                <th nowrap="" class="silver_header"  bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                    <b><%=clntName%></b>
                                </th>
                                <th nowrap="" class="silver_header"  bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                    <b><%=email%></b>
                                </th>
                                <th nowrap="" class="silver_header"  bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                    <b><%=clntMob%></b>
                                </th>
                                <th nowrap="" class="silver_header"  bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                    <b><%=interPhone%></b>
                                </th>
                                <th nowrap="" class="silver_header"  bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                    <b><%=notes%></b>
                                </th>
                                <th nowrap="" class="silver_header"  bgcolor="#9B9B00" style="border-WIDTH:0; white-space: nowrap;">
                                    <b><%=clntComChannel%> </b>
                                </th>
                            </TR>
                        </thead>
                        <tbody>
                            <%
                                for (int i = 0; i < clientsLst.size(); i++)
                                {
                                    WebBusinessObject clientWBO = (WebBusinessObject) clientsLst.get(i);
                            %>
                            <tr id="row" style="padding-bottom: 1px;">
                                <td bgcolor="" nowrap="" class="">
                                    <div>
                                        <input type="hidden" name="clientscheckIndex" value="0">
                                        <input type="checkbox" name="clientcheck" id="clientcheck<%=i%>" value="<%=clientWBO.getAttribute("id")%>"/>
                                    </div>
                                </td>
                                <td  bgcolor="" nowrap="" class="">
                                    <div>
                                        <%=clientWBO.getAttribute("clientNO")%>
                                    </div>
                                </td>
                                <td bgcolor="" nowrap="" class="">
                                    <div>
                                        <%=clientWBO.getAttribute("name")%>
                                    </div>
                                </td>
                                <td bgcolor="" nowrap="" class="">
                                    <div>
                                        <%=clientWBO.getAttribute("email")%>
                                    </div>
                                </td>
                                <td bgcolor="" nowrap="" class="">
                                    <div>
                                        <%=clientWBO.getAttribute("mobile")%>
                                    </div>
                                </td>
                                <td  bgcolor="" nowrap="" class="">
                                    <div>
                                        <%=clientWBO.getAttribute("interPhone")%>
                                    </div>
                                </td>
                                <td  bgcolor="" nowrap="" class="">
                                    <div>
                                        <%=clientWBO.getAttribute("notes")%>
                                    </div>
                                </td>
                                 <td  bgcolor="" nowrap="" class="">
                                    <div>
                                        <%=clientWBO.getAttribute("commChannel")%>
                                    </div>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </form>
        </fieldset>
    </body>
</html>
