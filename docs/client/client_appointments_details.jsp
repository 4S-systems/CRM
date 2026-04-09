<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="com.maintenance.db_access.UserStoresMgr"%>
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
        String stat = (String) request.getSession().getAttribute("currentMode");

        String appoitmentsJson = (String) request.getAttribute("appoitmentsJson");

        String beginDate = (String) request.getAttribute("beginDate");
        String endDate = (String) request.getAttribute("endDate");
        String departmentID = request.getAttribute("departmentID") != null ? (String) request.getAttribute("departmentID") : "";
        String userID = (String) request.getAttribute("userID");
        String repType = (String) request.getAttribute("repType");

        UserStoresMgr userStoresMgr = UserStoresMgr.getInstance();
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = new Vector();
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String dd = (String) userWbo.getAttribute("groupID");
        groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        WebBusinessObject wbo = new WebBusinessObject();

        ArrayList<String> userPrevList = new ArrayList<String>();
        for (int i = 0; i < groupPrev.size(); i++) {
            wbo = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wbo.getAttribute("prevCode"));
        }

        String userName = (String) request.getAttribute("userName");
        String future = (String) request.getAttribute("future");

        String align = null, xAlign;
        String dir = null, from, to, clntNm, callDt, branch, calStat, calRed, tknTim, contactAft,
                note, mob, tel, empNm, inDate;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            from = "Appointments From";
            to = "To";
            clntNm = "Client Name";
            callDt = "Appointment Date";
            branch = "C Type";
            calStat = "Appointment Status";
            calRed = "Appointment Result";
            tknTim = "Period";
            contactAft = "Contacting After";
            note = "Notes";
            mob = "Mobile";
            tel = "InterNantional No";
            empNm = "Employee Name";
            inDate = "Date";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            from = "المتابعات من";
            to = "الى";
            clntNm = "اسم العميل";
            callDt = "تاريخ المتابعة";
            branch = "نوع التواصل";
            calStat = "حالة المتابعه";
            calRed = "نتيجة المتابعه";
            tknTim = "المدة";
            contactAft = "التواصل بعد";
            note = "ملاحظات";
            mob = "الموبايل ";
            tel = "الرقم الدولى";
            empNm = "اسم الموظف";
            inDate = "في تاريخ";
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
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.rowsGroup.js"></script>
        <script type="text/javascript" language="javascript" src="js/rateit/jquery.rateit.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>

        <script type="text/javascript" language="javascript">
            $(document).ready(function () {
            var data = <%=appoitmentsJson%>;
            var f = '<%=future%>';
            var today = new Date();
            /*var dd = today.getDate()+1;
             var mm = today.getMonth()+1; //January is 0!
             
             var yyyy = today.getFullYear();
             if(dd<10){
             dd='0'+dd;
             } 
             if(mm<10){
             mm='0'+mm;
             } 
             var today = yyyy+'-'+mm+'-'+dd;*/

            <%
                    if (future != null && future.equalsIgnoreCase("ok")) {
            %>
            var table = $('#clients').DataTable({
            "aLengthMenu": [[10, 25, 50, - 1], [10, 25, 50, "All"]],
                    iDisplayLength: 10,
                    columns: [
                    {
                    title: '<%=clntNm%> ',
                            name: 'clientName',
                    },
                    {
                    title: '<%=mob%> ',
                            name: 'mobile',
                    },
                    {
                    title: '<%=tel%> ',
                            name: 'interTel',
                    },
                    {
                    title: '<%=callDt%>',
                            name: 'appointmentDate',
                    },
                    {
                    title: '<%=branch%>',
                            name: 'appointmentPlace',
                    }
                    ,
                    {
                    title: '<%=calRed%>',
                            name: 'note'
                    }
                    ,
                    {
                    title: '<%=inDate%>',
                            name: 'date',
                    }
                    ,
//                    {
//                    title: '<!%=contactAft%>',
//                            name: 'duration',
//                    },
                    {
                    title: '<%=note%>',
                            name: 'comment',
                    },
                    {
                    title: '',
                            name: '',
                    }
                    ],
                    data: data,
                    rowsGroup: [
                            'clientName:name'
                    ],
                    "columnDefs": [
                    { "width": "10%", "targets": 0 },
                    { "width": "10%", "targets": 0 },
                    { "width": "10%", "targets": 0 },
//                    { "width": "10%", "targets": 0 },
                    { "width": "8%", "targets": 0 },
                    { "width": "25%", "targets": 0 },
                    {
                    "width": "5%",
                            "targets": - 1,
                            "data": null,
                            "defaultContent": "<img id='star' style='width: 30px; hight: 30px;'/> <a target='_blanck' id='goTo'><img src='images/client_details.jpg'/></a>"
                            + "<a href='#' id='pdf'><img src='images/pdf_icon.gif' style='height: 20px;' title='Datasheet'/></a>"
                    }
                    ],
                    pageLength: '25',
                    "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                    var date2 = new Date(aData[4]);
                    var timeDiff = today.getTime() - date2.getTime();
                    var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
                    if (aData[9] == "اهملت" || (aData[9] == "مفتوحة" && diffDays > 1)){
                    $('td', nRow).css('background-color', '#FF988A'); //red
                    } else if (aData[9] == "متابعة مباشرة"){
                    $('td', nRow).css('background-color', '#d6f4fe'); //blue
                    } else if (aData[9] == "معتنى بها"){
                    $('td', nRow).css('background-color', '#A4FFD2'); //green
                    } else if (aData[9] == "مفتوحة"){
                    $('td', nRow).css('background-color', '#F0FF9B'); //yellwo
                    } else if (aData[9] == "تمت بنجاح"){
                    $('#star', nRow).attr('src', 'images/icons/bookmarks.png');
                    }
                    $('.sorting_1', nRow).css('background-color', 'white');
                    $('#goTo', nRow).attr("href", "<%=context%>/ClientServlet?op=clientDetails&clientId=" + aData[8]);
                    $('#pdf', nRow).attr("href", "JavaScript: printClientInformation('" + aData[8] + "')");
                    }
            });
            <%} else {%>
            var table = $('#clients').DataTable({
            "aLengthMenu": [[10, 25, 50, - 1], [10, 25, 50, "All"]],
                    iDisplayLength: 10,
                    columns: [
                    {
                    title: '<%=clntNm%>',
                            name: 'clientName',
                    },
                    {
                    title: '<%=mob%> ',
                            name: 'mobile',
                    },
                    {
                    title: '<%=tel%> ',
                            name: 'interTel',
                    },
                    {
                    title: '<%=callDt%>',
                            name: 'appointmentDate',
                    },
                    {
                    title: '<%=branch%>',
                            name: 'option2',
                    },
                    {
                    title: '<%=calStat%>',
                            name: 'option9',
                    }
                    ,
                    {
                    title: ' <%=calRed%>',
                            name: 'note'
                    },
                    {
                    title: ' <%=tknTim%>',
                            name: 'appointmentDate',
                    }
                    ,
//                    {
//                    title: '<%=contactAft%>',
//                            name: 'duration',
//                    },
                    {
                    title: '<%=note%>',
                            name: 'comment',
                    },
                    {
                    title: '',
                            name: '',
                    }
                    ],
                    data: data,
                    rowsGroup: [
                            'clientName:name'
                    ],
                    "columnDefs": [
                    { "width": "10%", "targets": 0 },
                    { "width": "10%", "targets": 0 },
                    { "width": "10%", "targets": 0 },
                    { "width": "10%", "targets": 0 },
                    { "width": "10%", "targets": 0 },
//                    { "width": "10%", "targets": 0 },
                    { "width": "8%", "targets": 0 },
                    { "width": "25%", "targets": 0 },
                    {
                    "width": "5%",
                            "targets": - 1,
                            "data": null,
                            "defaultContent": "<img id='star' style='width: 30px; hight: 30px;'/> <a target='_blanck' id='goTo'><img src='images/client_details.jpg'/></a>"
                            + "<a href='#' id='pdf'><img src='images/pdf_icon.gif' style='height: 20px;' title='Datasheet'/></a>"
            <%if (userPrevList.contains("DELETE_APPOINTMENT")) {%>
                    + "<a href='#' id='dltApp'><img src='images/icons/delete_ready.png' style='height: 20px; margin-right: 5px;' title='Delete Appointment'/></a>"
            <%}%>

                    }
                    ],
                    pageLength: '25',
                    "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
                    var date2 = new Date(aData[5]);
                    var timeDiff = today.getTime() - date2.getTime();
                    var diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
                    if (aData[10] == "اهملت" || (aData[10] == "مفتوحة" && diffDays > 1)){
                    $('td', nRow).css('background-color', '#FF988A'); //red
                    } else if (aData[10] == "متابعة مباشرة"){
                    $('td', nRow).css('background-color', '#d6f4fe'); //blue
                    } else if (aData[10] == "معتنى بها"){
                    $('td', nRow).css('background-color', '#A4FFD2'); //green
                    } else if (aData[10] == "مفتوحة"){
                    $('td', nRow).css('background-color', '#F0FF9B'); //yellwo
                    } else if (aData[10] == "تمت بنجاح"){
                    $('#star', nRow).attr('src', 'images/icons/bookmarks.png');
                    }
                    $('.sorting_1', nRow).css('background-color', 'white');
                    $('#goTo', nRow).attr("href", "<%=context%>/ClientServlet?op=clientDetails&clientId=" + aData[9]);
                    $('#pdf', nRow).attr("href", "JavaScript: printClientInformation('" + aData[9] + "')");
                    $('#dltApp', nRow).attr("href", "JavaScript: deleteAppointment('" + aData[9] + "')");
                    }
            });
            <%}%>
            });
            function printClientInformation(clientID) {
            var url = "<%=context%>/PDFReportServlet?op=clientDataSheet&clientId=" + clientID + "&objectType=client";
            window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=700, height=600");
            }

            function deleteAppointment(rowId){
            $.ajax({
            type: "post",
                    url: "<%=context%>/AppointmentServlet?op=deleteAppointment",
                    data: {
                    rowId: rowId
                    },
                    success: function (jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'Ok') {
                    alert("Appointment Has Been Deleted");
                    location.reload();
                    }
                    }
            });
            }
        </script>
        <style type="text/css">
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
        </style>
    </HEAD>
    <body>
        <fieldset align=center class="set" style="width: 90%">
            <form name="CLIENTS_FORM" action="" method="POST">
                <br/>

                <%--<div align="left" STYLE="color:blue; margin-left: 50px;">
                    <input type="button"  value="عودة"  onclick="history.go(-1);" class="button"/>
                </div>--%>

                <br/><br/>

                <b><font size="3" ><%=empNm%></font></b> : <b><font size="3" color="red"><%=userName%></font></b>
                <br>
                <b><font size="3" ><%=from%></font></b> : <b><font size="3" color="red"><%=beginDate%></font></b> 
                <b><font size="3" ><%=to%></font></b> : <b><font size="3" color="red"><%=endDate%></font></b>

                <br>
                <a title="PDF" id="pdf" href="<%=context%>/AppointmentServlet?op=clientAppDetailsPDF&beginDate=<%=beginDate%>&endDate=<%=endDate%>&userName=<%=userName%>&userID=<%=userID%>&repType=<%=repType%>&projectID=<%=departmentID%>">
                    <img alt="PDF" style="margin: 3px" src="images/icons/pdf.png" width="24" height="24"/>
                </a>
                
                    <a title="Excel Export" id="excel" href="<%=context%>/AppointmentServlet?op=clientAppDetailsExcel&type=call&beginDate=<%=beginDate%>&endDate=<%=endDate%>&userName=<%=userName%>&userID=<%=userID%>&repType=<%=repType%>&projectID=<%=departmentID%>">
                      <img alt="Excel" style="margin: 3px" src="images/excelIcon.png" width="24" height="24"/>
                </a>    
                    
                <br/><br/>

                <div style="width: 95%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <TABLE WIDTH="100%" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" id="clients">                    
                    </table>
                </div>
                <br/><br/>
            </form>
        </fieldset>
    </body>
</html>