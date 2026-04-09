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
        Vector<WebBusinessObject> result = (Vector) request.getAttribute("result");
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
                "aLengthMenu": [[10, 20, 30, -1], [10, 20, 30, "All"]],
                iDisplayLength: 10,
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
        function closePopup(obj){
           
            $(obj).parent().parent().bPopup().close();
              
        
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

    <% if (result != null && !result.isEmpty()) {

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

                <tr>
                    <th ><b>#</b></th>
                    <th  ><b>التخصص</b></th>
                    <th  ><b>إسم المنطقة</b></th>
                    <th  ><b>ملاحظات</b></th>
                    <th  ><b>تاريخ البداية</b></th>
                    <th   ><b>تاريخ النهاية</b></th>
                </tr>


            </thead>
            <tbody>
                <%

                    for (WebBusinessObject wbo : result) {
                        int i = 0;
                        i++;
                        String rollId = (String) wbo.getAttribute("rollId");
                        TradeMgr tradeMgr = TradeMgr.getInstance();
                        WebBusinessObject wbo2 = new WebBusinessObject();
                        wbo2 = tradeMgr.getOnSingleKey(rollId);
                        String rollName = (String) wbo2.getAttribute("tradeName");
                        String area_id = (String) wbo.getAttribute("serviceIn");
                        ProjectMgr projectMgr = ProjectMgr.getInstance();
                        wbo2 = new WebBusinessObject();
                        wbo2 = projectMgr.getOnSingleKey(area_id);
                        String area_name = (String) wbo2.getAttribute("projectName");
                        String beginDate = (String) wbo.getAttribute("beginDate");
                        String endDate = (String) wbo.getAttribute("endDate");
                        String note = (String) wbo.getAttribute("notes");



                %>
                <tr>
                    <td >
                    </td>
                    <td >
                        <input  type="text" id="rollId" style="float: right;display: none;" value="" />
                        <b id="rollText"><%=rollName%></b>
                    </td>
                    <td >
                        <input  type="text" id="areaId" style="float: right;display: none;" value="" />
                        <b id="areaText"><%=area_name%></b>
                    </td>
                    <td >
                        <input  type="text" id="area_note" style="float: right;display: none;" value="" />
                        <b id="area_note_text"><%=note%></b>
                    </td>
                    <td >
                        <input  type="text" id="bDate" style="float: right;display: none;" value="" />
                        <b id="bDateText"><%=beginDate%></b>
                    </td>
                    <td >
                        <input  type="text" id="eDate" style="float: right;display: none;" value="" />
                        <b id="eDateText"><%=endDate%></b>
                    </td>

                </tr>
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

    <div class="login1" style="width: 40%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
        <div style="margin-right: auto;margin-left: auto;width: 100%;font-size: 24px;color: white;text-align: center;">لاتوجد مناطق للعرض</div>
    </div>

    <%}
    %>
</html>
<!--         </tr> 
     
 </table> -->
