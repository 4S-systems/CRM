<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<html>
    <head>
        <!--        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>-->
        <!--<script type="text/javascript" src="js/jquery.bpopup.min.js"></script>-->
        <!--<script type="text/javascript" src="js/jquery.easing.1.3.js"></script>-->
        <!--        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
                <link rel="stylesheet" href="css/demo_table.css">-->
    </head>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        HttpSession s = request.getSession();
        Vector<WebBusinessObject> appointments = (Vector) request.getAttribute("appointments");
        WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
        String loggedUser = (String) waUser.getAttribute("userId");
        Calendar weekCalendar = Calendar.getInstance();
        Calendar beginWeekCalendar = Calendar.getInstance();
        Calendar cal = Calendar.getInstance();
        String timeFormat = "yyyy/MM/dd hh:mm";
        SimpleDateFormat sdf = new SimpleDateFormat(timeFormat);
        Calendar endWeekCalendar = Calendar.getInstance();
        String nowTime = sdf.format(cal.getTime());
        metaMgr.setMetaData("xfile.jar");
        ParseSideMenu parseSideMenu = new ParseSideMenu();
        Hashtable logos = new Hashtable();

    %>
    <script type="text/javascript">
        $(function(){
            $('#appointmentTable').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[5, 10, 15, -1], [5, 10, 15, "All"]],
                iDisplayLength: 5,
                iDisplayStart: 0,
                "bSort": false,
                "bPaginate": true,
                "bProcessing": true,
                "fnDrawCallback": function ( oSettings ) {
                    /* Need to redo the counters if filtered or sorted */
                    if ( oSettings.bSorted || oSettings.bFiltered )
                    {
                        for ( var i=0, iLen=oSettings.aiDisplay.length ; i<iLen ; i++ )
                        {
                            $('td:eq(0)', oSettings.aoData[ oSettings.aiDisplay[i] ].nTr ).html( i+1 );
                        }
                    }
                },
                "aoColumnDefs": [
                    { "bSortable": false, "aTargets": [ 0 ] }
                ],
                "aaSorting": [[ 1, 'asc' ]]
                
                //            "aaSorting": [[ 5, "desc" ]]

            }).show();
            
        })
        
    </script>
    <script type="text/javascript">

        function editData(obj) {
            var appTitle, appDate, appNote;

            appDate = $(obj).parent().parent().parent().find("#appNote1").val();
            var appointmentId = $(obj).parent().parent().parent().find("#appointmentId").val();
            //            alert(appointmentId)
            $(obj).parent().parent().parent().find("#appNote1").removeProp("disabled");
            $(obj).parent().parent().parent().find("#appTitleText").css("display", "none");
            $(obj).parent().parent().parent().find("#appTitleInput").css("display", "block");
            $(obj).parent().parent().parent().find("#appDateText").css("display", "none");
            $(obj).parent().parent().parent().find("#appDate1").css("display", "block");

            $(obj).parent().parent().parent().find("#appDate1").datetimepicker({
                maxDate: "+d",
                changeMonth: true,
                changeYear: true,
                timeFormat: 'hh:mm',
                dateFormat: 'yy/mm/dd'
            });

            $(obj).parent().parent().parent().find("#saveRow").css("display", "block");
            //            $(obj).parent().parent().parent().find("#updateA").css("background-position", "bottom");
            //            $(obj).parent().parent().parent().parent().parent().parent().find($("#appTitle1")).removeProp("disabled");

        }
        function removeApp(obj) {
            var appointmentId = $(obj).parent().find("#appointmentId").val();
          
            //            alert(appointmentId)
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=removeAppointment",
                data: {
                    appointmentId: appointmentId
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {

                        // change update icon state1370883718265
                        //                        $(obj).parent().parent().parent().parent().find("#"+appointmentId).remove();
                        $(obj).parent().parent().parent().remove();
                        
                        $(obj).parent().parent().parent().find("#hr").hide();
                        $(obj).parent().parent().parent().parent().find("#hr").hide();
                        $(obj).parent().parent().parent().parent().parent().find("#hr").hide();
                       
                        //                        $("#appointmentTable").fnDraw();
                        
                        $("#appointmentTable").fnDeleteRow($(obj).parent().parent().parent().parent().find("#"+appointmentId));
                        //                        alert("sdfs")

                    }
                }
            });
        }
        function updateApp(obj) {
            var appointmentId = $(obj).parent().parent().parent().find("#appointmentId").val();
            var title = $(obj).parent().parent().parent().find("#appTitleInput").val();
            var note = $(obj).parent().parent().parent().find("#appNote1").val();
            var appDate = $(obj).parent().parent().parent().find("#appDate1").val();
            //            alert(appointmentId)
            $.ajax({
                type: "post",
                url: "<%=context%>/ClientServlet?op=updateAppointment",
                data: {
                    appointmentId: appointmentId,
                    title: title,
                    note: note,
                    date: appDate

                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);

                    if (info.status == 'ok') {
                        $(obj).parent().parent().parent().find("#appNote1").attr("disabled", "disabled");
                        $(obj).parent().parent().parent().find("#appNote1").val(note);
                        $(obj).parent().parent().parent().find("#appTitleText").text(title);
                        $(obj).parent().parent().parent().find("#appTitleInput").css("display", "none");
                        $(obj).parent().parent().parent().find("#appTitleInput").val(title);
                        $(obj).parent().parent().parent().find("#appDateText").text(appDate);
                        $(obj).parent().parent().parent().find("#appDate1").css("display", "none");
                        $(obj).parent().parent().parent().find("#appDate1").val(appDate);
                        $(obj).parent().parent().parent().find("#appTitleText").css("display", "block");
                        $(obj).parent().parent().parent().find("#appDateText").css("display", "block");

                        $(obj).css("background-position", "top");


                    }
                }
            });
        }
        //        $(function() {
        //            $("#appDate1").datetimepicker({
        //                maxDate: "+d",
        //                changeMonth: true,
        //                changeYear: true,
        //                timeFormat: 'hh:mm',
        //                dateFormat: 'yy/mm/dd'
        //            });
        //        })
    </script>
    <style type="text/css">
        .updateA {
            margin-left: auto;
            margin-right: auto;
            width:20px;
            height:20px;
            background-image:url(images/icons/check1.png);
            background-repeat: no-repeat;
            background-position: bottom;
            cursor: pointer;
        }
        .editA {

            margin-left: auto;
            margin-right: auto;
            width:20px;
            height:20px;
            background-image:url(images/icons/update.png);
            background-repeat: no-repeat;
            background-position: top;
            cursor: pointer;
        }
        .removeA {
            margin-left: auto;
            margin-right: auto;
            width:20px;
            height:20px;
            background-image:url(images/icons/remove1.png);
            background-repeat: no-repeat;
            background-position: top;
            cursor: pointer;
        }
        #appointmentTable td{
            border: none !important;
        }
        #appointmentTable {
            border: none !important;
        }
    </style>


    <!--<h1>رسالة قصيرة</h1>-->

    <% if (appointments != null && !appointments.isEmpty()) {

    %>
    <div style="clear: both;margin-left: 86%;margin-top: 0px;margin-bottom: -33px;z-index: 1000;">
        <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
             -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
             box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
             -webkit-border-radius: 100px;
             -moz-border-radius: 100px;
             border-radius: 100px;" onclick="closePopup(this)"/>
    </div>
    <!--<h1>رسالة قصيرة</h1>-->
    <div class="login1" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
        <table style="width:100%;text-align: center;display: none;z-index: -100"  id="appointmentTable">
            <thead >  
                <tr >

                    <th style="color: #000;font-weight: bold">#</th>
                    <th style="color: #000;font-weight: bold">رقم العميل</th>
                    <th style="color: #000;font-weight: bold">إسم العميل</th>
                    <th style="color: #000;font-weight: bold">الموبايل</th>
                    <th style="color: #000;font-weight: bold">العنوان</th>
                    <th style="color: #000;font-weight: bold">المنتج</th>
                    <th style="color: #000;font-weight: bold">الخدمة</th>
                    <th style="color: #000;font-weight: bold">تاريخ الخدمة</th>



                </tr>
            </thead>
            <tbody>
                <%

                    for (WebBusinessObject wbo : appointments) {
                        int i = 0;
                        i++;
                        String createdBy = (String) wbo.getAttribute("userId");

                        WebBusinessObject wbo2 = new WebBusinessObject();
                        UserMgr userMgr = UserMgr.getInstance();
                        wbo2 = userMgr.getOnSingleKey(createdBy);
                        String createdByUsername = (String) wbo2.getAttribute("fullName");
                        String appointmentNote = (String) wbo.getAttribute("note");
                        if (appointmentNote != null & !appointmentNote.equals("")) {
                        } else {
                            appointmentNote = "لاتوجد ملاحظات";
                        }
                        String appointmentDate = (String) wbo.getAttribute("appointmentDate");
                        String time = "";
                        if (wbo.getAttribute("option2").equals("UL")) {
                            time = "";
                        } else {
                            time = (String) wbo.getAttribute("option2");
                        }
                        if (appointmentDate != null & !appointmentDate.equals("")) {
                        } else {
                            appointmentDate = "";
                        }
                        String enterDate = (String) wbo.getAttribute("creationTime");
                        String clientNO = (String) wbo.getAttribute("clientNO");
                        String clientName = (String) wbo.getAttribute("name");
                        String mobile = (String) wbo.getAttribute("mobile");
                        String address = (String) wbo.getAttribute("address");
                        String product_id = (String) wbo.getAttribute("option3");
                         String clientId = (String) wbo.getAttribute("clientId");
                        ProjectMgr projectMgr = ProjectMgr.getInstance();
                        WebBusinessObject wbo3 = new WebBusinessObject();
                        wbo3 = projectMgr.getOnSingleKey(product_id);
                        String product_name = "";
                        if (wbo3 != null) {
                            product_name = (String) wbo3.getAttribute("projectName");
                        }
                        String appointmentId = (String) wbo.getAttribute("id");

                        //            if (loggedUser.equals(createdBy)) {

                %>
                <tr onclick="popupShowClient(this)">
                    <td >
                    </td>
                    <td >
                        <input  type="text" id="appTitleInput" style="float: right;display: none;" value="<%=clientNO%>" />
                        <b id="appTitleText"><%=clientNO%></b>
                    </td>
                    <td >
                        <input  type="text" id="appTitleInput" style="float: right;display: none;" value="<%=clientNO%>" />
                         <input type="hidden" id="clientId" value="<%=clientId%>"
                        <b id="appTitleText"><%=clientName%></b>
                    </td>
                    <td >
                        <input  type="text" id="appTitleInput" style="float: right;display: none;" value="<%=clientNO%>" />
                        <b id="appTitleText"><%=mobile%></b>
                    </td>
                    <td >
                        <input  type="text" id="appTitleInput" style="float: right;display: none;" value="<%=clientNO%>" />
                        <b id="appTitleText"><%=address%></b>
                    </td>
                    <td >
                        <input  type="text"  style="float: right;display: none;" value="<%=clientNO%>" />
                        <b ><%=product_name%></b>
                    </td>
                    <td >
                        <%
                            appointmentNote.trim();
                        %>
                        <textarea style="width:100%;height: 60px;" id="appNote1" disabled="true"><%=appointmentNote%></textarea>
                    </td>

                    <td >

                        <b id="appDateText" style="color: #f00;"><%=appointmentDate + "  " + time%></b>
                <!--<center> <input name="entryDate" id="appDate1" type="text" size="50" maxlength="50" style="width:80%;float: right;display: none;font-size: 12px;" value="<%=nowTime%>"/></center>-->
                    </td>





                </tr>
<!--                <tr id="<%=appointmentId%>">
                    <td colspan="6">
                        <hr style="width: 100%;clear: both;">
                    </td>

                </tr>-->
                <%
                    }
                %>
            </tbody>
        </table>

    </div>
    <% } else {
    %>

    <div style="clear: both;margin-left: 68%;margin-top: 0px;margin-bottom: -35px;width: 32px;">
        <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
    </div>

    <div class="login" style="width: 40%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
        <div style="margin-right: auto;margin-left: auto;width: 100%;font-size: 24px;color: white;text-align: center;">لاتوجد خدمات للمشاهدة</div>
    </div>

    <%}
    %>
</html>
<!--         </tr> 
     
 </table> -->
