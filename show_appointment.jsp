<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>


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
            dateFormat: 'dd/mm/yy'
        });

        $(obj).parent().parent().parent().find("#saveRow").css("display", "block");
        //            $(obj).parent().parent().parent().find("#updateA").css("background-position", "bottom");
        //            $(obj).parent().parent().parent().parent().parent().parent().find($("#appTitle1")).removeProp("disabled");

    }
    function removeApp(obj) {
        var appointmentId = $(obj).parent().parent().parent().find("#appointmentId").val();
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
                    $(obj).parent().parent().parent().parent().find("#" + appointmentId).remove();
                    $(obj).parent().parent().parent().remove();

                    $(obj).parent().parent().parent().find("#hr").hide();
                    $(obj).parent().parent().parent().parent().find("#hr").hide();
                    $(obj).parent().parent().parent().parent().parent().find("#hr").hide();

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
                date: appDate,
                comment:note

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
            },
                    error: function (xhr, ajaxOptions, thrownError) 
           {
               console.log("error");
              
           }
        });
    }
    
</script> 


<!--<h1>رسالة قصيرة</h1>-->
<body>
<% if (appointments != null && !appointments.isEmpty()) {
%>
<div style="clear: both;margin-left: 85%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
         -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
         box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
         -webkit-border-radius: 100px;
         -moz-border-radius: 100px;
         border-radius: 100px;" onclick="closePopup(this)"/>
</div>
<!--<h1>رسالة قصيرة</h1>-->
<div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;overflow: auto;height: 300px;">
    <table  border="0px"  style="width:100%;text-align: center"    class="table" id="appointmentTable">
        <thead >   <tr >


                <th CLASS="blueBorder backgroundTable"style="width: 20%">عنوان المقابلة</th>

                <th CLASS="blueBorder backgroundTable"style="width: 30%">ملاحظات المقابلة</th>
                <th CLASS="blueBorder backgroundTable" style="width:20%">تاريخ المقابلة</th>
                <th CLASS="blueBorder backgroundTable"style="width: 15%">تاريخ التسجيل</th>
                <th  CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 25px" width="5%" >تعديل</th>
                <th  CLASS="blueBorder backgroundTable" style="width: 5%">حذف</th>
                <th  style="width: 5%;"></th>

            </tr>
        </thead>
        <%            for (WebBusinessObject wbo : appointments) {
                String createdBy = (String) wbo.getAttribute("userId");

                WebBusinessObject wbo2 = new WebBusinessObject();
                UserMgr userMgr = UserMgr.getInstance();
                wbo2 = userMgr.getOnSingleKey(createdBy);
                String createdByUsername = (String) wbo2.getAttribute("fullName");
                String appointmentNote=null;
                  appointmentNote= (String) wbo.getAttribute("comment");
                if (appointmentNote != null && !appointmentNote.equals("")) {
                } else {
                    appointmentNote = "لاتوجد ملاحظات";
                }
                
                
               /* String appointmentcomment = (String) wbo.getAttribute("comment");
                if (appointmentcomment != null & !appointmentcomment.equals("")) {
                } else {
                    appointmentcomment = "لاتوجد ملاحظات";
                }*/
                String appointmentDate = DateAndTimeControl.getDateAfterSubString(((String) (wbo.getAttribute("appointmentDate"))).substring(0, wbo.getAttribute("appointmentDate").toString().length() - 5));
                if (appointmentDate != null & !appointmentDate.equals("")) {
                } else {
                    appointmentDate = "";
                }
                String enterDate = DateAndTimeControl.getDateAfterSubString(((String) (wbo.getAttribute("creationTime"))).substring(0, wbo.getAttribute("creationTime").toString().length() - 5));
                String appointmentTitle = (String) wbo.getAttribute("title");
                if (appointmentTitle != null & !appointmentTitle.equals("")) {
                } else {
                    appointmentTitle = "لايوجد عنوان للمقابلة";
                }
                String appointmentId = (String) wbo.getAttribute("id");

                //            if (loggedUser.equals(createdBy)) {

        %>

        <td >
            <input  type="text" id="appTitleInput" style="float: right;display: none;" value="<%=appointmentTitle%>" />
            <b id="appTitleText"><%=appointmentTitle%></b>
        </td>

        <td >
            <%
                appointmentNote.trim();
            %>
            <textarea style="width:100%;height: 60px;" id="appNote1" disabled="true" maxlength="500"><%=appointmentNote%></textarea>
        </td>

        <td >

            <b id="appDateText" style="color: #f00;"><%=appointmentDate%></b>
        <center> <input name="entryDate" id="appDate1" type="text" size="50" maxlength="50" style="width:80%;float: right;display: none;font-size: 12px;" value="<%=nowTime%>"/></center>
        </td>
        <td  >
            <b style="color: white;">  <%=enterDate%></b>

        </td>

        <td >
            <div style="width: 100%;">
                <div id="editAppointment" class="editA"  onclick="editData(this)" > </div>

            </div>
            <input type="hidden" id="appointmentId" value="<%=appointmentId%>" />
        </td>

        <td >
            <div style="width: 100%;display: inline-block">

                <div  id="reomveAppointment" class="removeA" onclick="removeApp(this)" />

            </div>

        </td>
        <td id="saveRow" style="display: none;">
            <div>

                <div id="updateAppointment" class="updateA"  onclick="updateApp(this)" /> 
            </div>
        </td>




        </tr>
        <tr id="<%=appointmentId%>">
            <td colspan="6">
                <hr style="width: 100%;clear: both;">
            </td>

        </tr>
        <%}
        %>
    </table>

</div>
<% } else {
      
%>

<div style="clear: both;margin-left: 68%;margin-top: 0px;margin-bottom: -35px;width: 32px;">
    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
</div>

<div class="login" style="width: 40%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
    <div style="margin-right: auto;margin-left: auto;width: 100%;font-size: 24px;color: white;text-align: center;">لاتوجد مقابلات للمشاهدة</div>
</div>

<%}
%>
<!--         </tr> 

 </table> -->
  </body>   