<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>


<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    HttpSession s = request.getSession();
    Vector<WebBusinessObject> campaigns = (Vector) request.getAttribute("campaigns");
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
        var campaignId = $(obj).parent().parent().parent().find("#campaignId").val();
        //            alert(appointmentId)
        $(obj).parent().parent().parent().find("#appNote1").removeProp("disabled");
        //            $(obj).parent().parent().parent().find("#appTitleText").css("display", "none");
        //            $(obj).parent().parent().parent().find("#appTitleInput").css("display", "block");
        $(obj).parent().parent().parent().find("#appDateText").css("display", "none");
        $(obj).parent().parent().parent().find("#appDate1").css("display", "block");
        $(obj).parent().parent().parent().find("#saveRow").css("display", "block");
        //            $(obj).parent().parent().parent().find("#updateA").css("background-position", "bottom");
        //            $(obj).parent().parent().parent().parent().parent().parent().find($("#appTitle1")).removeProp("disabled");

    }
    function removeApp(obj) {
        var campaignId = $(obj).parent().parent().parent().find("#campaignId").val();
        //            alert(appointmentId)
        $.ajax({
            type: "post",
            url: "<%=context%>/ClientServlet?op=removeCampaign",
            data: {
                campaignId: campaignId
            },
            success: function(jsonString) {
                var info = $.parseJSON(jsonString);

                if (info.status == 'ok') {

                    // change update icon state1370883718265
                    $(obj).parent().parent().parent().parent().find("#"+campaignId).remove();
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
        var campaignId = $(obj).parent().parent().parent().find("#campaignId").val();
           
        var title = $(obj).parent().parent().parent().find("#appTitleInput").val();
        var note = $(obj).parent().parent().parent().find("#appNote1").val();
        var appDate = $(obj).parent().parent().parent().find("#appDate1").val();
        //            alert(appointmentId)
        $.ajax({
            type: "post",
            url: "<%=context%>/ClientServlet?op=updateCampaign",
            data: {
                campaignId: campaignId,
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
    $(function() {
        $("#appDate1").datetimepicker({
            maxDate: "+d",
            changeMonth: true,
            changeYear: true,
            timeFormat: 'hh:mm',
            dateFormat: 'yy/mm/dd'
        });
    })
</script>
<style type="text/css">
    /*        .updateA {
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
            }*/
</style>


<% if (campaigns != null && !campaigns.isEmpty()) {

%>
<div style="clear: both;margin-left: 91%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
         -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
         box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
         -webkit-border-radius: 100px;
         -moz-border-radius: 100px;
         border-radius: 100px;" onclick="closePopup(this)"/>
</div>

<!--<h1>رسالة قصيرة</h1>-->
<div class="login" style="width: 85%;margin-bottom: 10px;margin-left: auto;margin-right: auto;overflow: auto;height: 300px;">

    <table  border="0px"  style="width:100%;"    class="table" id="appointmentTable">
        <thead >   <tr >


                <th CLASS="blueBorder backgroundTable"style="width: 20%">عنوان الحملة</th>

                <th CLASS="blueBorder backgroundTable"style="width: 30%">الملاحظات</th>

                <th CLASS="blueBorder backgroundTable"style="width: 15%">تاريخ التسجيل</th>
                <th  CLASS="blueBorder backgroundTable" STYLE="text-align:center;font-size:14px; font-weight: bold; height: 25px" width="5%" >تعديل</th>
                <th  CLASS="blueBorder backgroundTable" style="width: 5%">حذف</th>
                <th  style="width: 5%;"></th>

            </tr>
        </thead>
        <%
            for (WebBusinessObject wbo : campaigns) {
                String createdBy = (String) wbo.getAttribute("createdBy");

                WebBusinessObject wbo2 = new WebBusinessObject();
                UserMgr userMgr = UserMgr.getInstance();
                wbo2 = userMgr.getOnSingleKey(createdBy);
                String createdByUsername = (String) wbo2.getAttribute("fullName");
                String note = "";
                if (wbo.getAttribute("note") != null) {
                    note = (String) wbo.getAttribute("note");
                }
                String enterDate = (String) wbo.getAttribute("creationTime");
                String title = (String) wbo.getAttribute("seasonName");
                String campaignId = (String) wbo.getAttribute("id");

                //            if (loggedUser.equals(createdBy)) {

        %>



        <td >

            <input  type="text" id="appTitleInput" style="float: right;display: none;" value="<%=title%>" />
            <b id="appTitleText"><%=title%></b>
        </td>

        <td >
            <textarea style="width:100%;height: 60px;" id="appNote1" disabled="true">
                <%=note%>
            </textarea>
        </td>
        <td  >
            <b style="color: white;">  <%=enterDate%></b>
        </td>
        <td >
            <div style="width: 100%;">
                <div id="editAppointment" class="editA"  onclick="editData(this)" /> 
            </div>
            <input type="hidden" id="campaignId" value="<%=campaignId%>" />
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
        <tr id="<%=campaignId%>">
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

<div style="clear: both;margin-left: 63%;margin-top: 0px;margin-bottom: -35px;width: 32px;">
    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
</div>

<div class="login" style="width: 30%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
    <div style="margin-right: auto;margin-left: auto;width: 100%;font-size: 24px;color: white;text-align: center;">لاتوجد حملات للمشاهدة</div>
</div>

<%}
%>
<!--         </tr> 
     
 </table> -->
