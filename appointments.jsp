<%@page import="com.crm.common.CRMConstants"%>
<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
 <HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Issue.clientProduct" />


<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    List<WebBusinessObject> appointments = (List) request.getAttribute("appointments");
    //get quickCalender previlige
    WebBusinessObject  loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
    UserGroupMgr userGroupMgr=UserGroupMgr.getInstance();
    ArrayList<WebBusinessObject> groupslist=userGroupMgr.getOnArbitraryKey2(loggedUser.getAttribute("userId").toString(),"key6");
    GroupPrevMgr groupPrevMgr=GroupPrevMgr.getInstance();
    boolean quickCalenderPrev=false;
   for(WebBusinessObject groupWbo:groupslist)
    {

        ArrayList<String> groupPrivilegeList
        = groupPrevMgr.getGroupPrivilegeCodes(groupWbo.getAttribute("groupID").toString());
        if(groupPrivilegeList.contains("QUICK_CALENDER"))
        { 
            quickCalenderPrev=true;
            break;
        }
    }
    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    List<WebBusinessObject> userProjects = new ArrayList<WebBusinessObject>(projectMgr.getOnArbitraryKeyOracle("1365240752318", "key2"));// = securityUser.getUserProjects();

    String disabled;
    Vector<WebBusinessObject> vecApp = projectMgr.getOnArbitraryKey("call-result", "key3");

    List dataArray = new ArrayList();
    if (vecApp.size() > 0) {
        WebBusinessObject wboComplaint = (WebBusinessObject) vecApp.get(0);
        dataArray = new ArrayList(projectMgr.getOnArbitraryKeyOracle((String) wboComplaint.getAttribute("projectID"), "key2"));
    }
%>

<script type="text/javascript">
    var prevappointmentId=null;
    function showcomment( appointmentId,canmakeaction)
    {
        if(prevappointmentId != null)
        {
             $("#"+"commentText"+prevappointmentId).hide();
             $("#"+"commentVal"+prevappointmentId).hide();
             $("#"+"callDuration"+prevappointmentId).hide();
             $("#"+"appointmentPlace"+prevappointmentId).hide();
        }
         var commenttextid="commentText"+appointmentId;
         var commentValID="commentVal"+appointmentId;
         var callDurationID = "callDuration" + appointmentId;
         var appointmentPlaceID = "appointmentPlace" + appointmentId;
        if(appointmentId == prevappointmentId)
          {
             $("#"+commenttextid).hide();
             $("#"+commentValID).hide();
             $("#"+callDurationID).hide();
             $("#"+appointmentPlaceID).hide();
              console.log("True");
             prevappointmentId=null;
          } 
        else
           { 
              $("#"+commenttextid).show();
              $("#"+commentValID).show();
              $("#"+callDurationID).show();
              $("#"+appointmentPlaceID).show();
               if(canmakeaction== "true")
              {
                  $("#"+commenttextid).prop("readonly",true);
                  $("#"+callDurationID).prop("readonly",true);
              } else {
                  $("#"+commenttextid).prop("readonly",false);
                  $("#"+callDurationID).prop("readonly",false);
              }
              prevappointmentId=appointmentId;
           }
        
    }
    function editData(obj) {
        appDate = $(obj).parent().parent().parent().find("#appNote1").val();
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
    }

    function updateComment(obj) {
        var appointmentID = $(obj).parent().parent().parent().find("#appointmentId").val();
        var comment = $(obj).parent().parent().find("#commentText" + appointmentID).val();

        $.ajax({
            url: "<%=context%>/AppointmentServlet?op=updateAppointmentComment",
            data: {comment: comment, appointmentID: appointmentID},
            success: function(data, textStatus, jqXHR) {
                
                if(data === "true"){
                    $(obj).attr("src","images/ok2.png");
                } else if(data === "false"){
                    alert("Error on update");
                }
            }

        });
    }
    function getDetailData(obj) {
        var note = $(obj).parent().parent().parent().find("#appNote1").val();
        $("#showDiv").css("display", "block");
        $("#shownTextArea").val(note);
    }

    function removeApp(obj) {
        var appointmentId = $(obj).parent().parent().parent().find("#appointmentId").val();
        var clientName = $(obj).parent().parent().parent().find("#clientNameInput").val();
        var title = $(obj).parent().parent().parent().find("#appTitleInput").val();
        var appDate = $(obj).parent().parent().parent().find("#appDate1").val();
        var message = "هل انت متأكد من مسح " + "\n\t اسم العميل : " + clientName + "\n\t عنوان المقابلة : " + title + "\n\t وقت المقابلة: " + appDate + " ?";
        var choice = confirm(message);
        if (choice == true) {
            $.ajax({
                type: "post",
                url: "<%=context%>/AppointmentServlet?op=removeAppointment",
                data: {
                    appointmentId: appointmentId
                },
                success: function(jsonString) {
                    var info = $.parseJSON(jsonString);
                    if (info.status == 'ok') {
                        canMakeAction('ok', appointmentId);
                        $(obj).parent().parent().parent().parent().find("#" + appointmentId).remove();
                        $(obj).parent().parent().parent().remove();
                        $(obj).parent().parent().parent().find("#hr").hide();
                        $(obj).parent().parent().parent().parent().find("#hr").hide();
                        $(obj).parent().parent().parent().parent().parent().find("#hr").hide();
                    } else {
                        canMakeAction('no', appointmentId);
                    }
                }
            });
        }
    }

    function updateApp(obj, counter, type) {
        var appointmentId = $(obj).parent().parent().parent().find("#appointmentId").val();
        var clientId = $(obj).parent().parent().parent().find("#clientId").val();
        var appointmentPlace = $(obj).parent().parent().parent().find("#appointmentPlace" + appointmentId).val();
        var title = $(obj).parent().parent().parent().find("#appTitleInput").val();
        var note = $(obj).parent().parent().parent().find("#appNote1").val();
        var appDate = $(obj).parent().parent().parent().find("#appDate1").val();
        var appDoneStatus = $(obj).parent().parent().parent().find("#appStatus" + counter + ":checked").val();
        var appType = $(obj).parent().parent().parent().find("#note" + counter).val();
        var appDir = $(obj).parent().parent().parent().find("#call_status" + counter + ":checked").val();
        var comment = "&#13;&#10;" + $(obj).parent().parent().parent().parent().find("#commentText" + appointmentId).val();
        var callDuration = $(obj).parent().parent().parent().parent().find("#callDuration" + appointmentId).val();
        var currentStatus = $(obj).parent().parent().parent().parent().find("#currentStatus" + appointmentId).val();
        
        $.ajax({
            type: "post",
            url: "<%=context%>/AppointmentServlet?op=updateAppointment",
            data: {
                appointmentId: appointmentId,
                title: title,
                note: note,
                date: appDate,
                appStatus: appDoneStatus,
                appType: appType,
                appDir: appDir,
                clientId: clientId,
                appointmentPlace: appointmentPlace,
                comment : comment,
                callDuration: callDuration,
                type: type,
                currentStatus: currentStatus
            },
            success: function(jsonString) {
                var info = $.parseJSON(jsonString);
                if (info.status == 'ok') {
            if(type == "close")      
            {
                canMakeAction('ok', appointmentId);}
                    $(obj).parent().parent().parent().find("#appNote1").attr("disabled", "disabled");
                    $(obj).parent().parent().parent().find("#appNote1").val(note);
                 //   $(obj).parent().parent().parent().find("#appTitleText").text(title);
                    $(obj).parent().parent().parent().find("#appTitleInput").css("display", "none");
                    $(obj).parent().parent().parent().find("#appTitleInput").val(title);
                    $(obj).parent().parent().parent().find("#appDateText").text(appDate);
                    $(obj).parent().parent().parent().find("#appDate1").css("display", "none");
                    $(obj).parent().parent().parent().find("#appDate1").val(appDate);
                  //  $(obj).parent().parent().parent().find("#appTitleText").css("display", "block");
                    $(obj).parent().parent().parent().find("#appDateText").css("display", "block");
                    $(obj).parent().parent().parent().find("#myDurationLink").html(callDuration);
//                    $(obj).parent().parent().parent().find("#myLink").html(comment);
                    $(obj).parent().parent().parent().find("#myPlaceLink").html(appointmentPlace);
                    $(obj).parent().parent().parent().parent().find("#commentText" + appointmentId).hide();
                    $("#commentText" + appointmentId).val("");
                    $(obj).parent().parent().parent().parent().find("#commentVal" + appointmentId).hide();
                    $(obj).parent().parent().parent().parent().find("#callDuration" + appointmentId).hide();
                    $(obj).parent().parent().parent().parent().find("#appointmentPlace" + appointmentId).hide();
                    $(obj).css("background-position", "top");
                    getAppointmentComment(appointmentId);
                    reload();
                    console.log("status is ok");
                } 
                else 
                {
                    canMakeAction('no', appointmentId);
                }
            }
        });
    }
    
    function updateApp1(obj, counter, result) {
        var appointmentId = $(obj).parent().parent().parent().find("#appointmentId").val();
        var clientId = $(obj).parent().parent().parent().find("#clientId").val();
        var appointmentPlace = $(obj).parent().parent().parent().find("#appointmentPlace" + appointmentId).val();
        var title = $(obj).parent().parent().parent().find("#appTitleInput").val();
        var note = $(obj).parent().parent().parent().find("#appNote1").val();
        var appDate = $(obj).parent().parent().parent().find("#appDate1").val();
        var appDoneStatus = $(obj).parent().parent().parent().find("#appStatus" + counter + ":checked").val();
        var appType = $(obj).parent().parent().parent().find("#note" + counter).val();
        console.log("appType "+appType);
        var appDir = $(obj).parent().parent().parent().find("#call_status" + counter + ":checked").val();
        var comment = "&#13;&#10;" + $(obj).parent().parent().parent().parent().find("#commentText" + appointmentId).val();
        var callDuration = $(obj).parent().parent().parent().parent().find("#callDuration" + appointmentId).val();
        var currentStatus = $(obj).parent().parent().parent().parent().find("#currentStatus" + appointmentId).val();
        console.log("result "+result);
        
        $.ajax({
            type: "post",
            url: "<%=context%>/AppointmentServlet?op=updateAppointment",
            data: {
                appointmentId: appointmentId,
                title: title,
                note: note,
                date: appDate,
                appStatus: appDoneStatus,
                appType: appType,
                appDir: appDir,
                clientId: clientId,
                appointmentPlace: appointmentPlace,
                comment : comment,
                callDuration: callDuration,
                type: 'close',
                currentStatus: currentStatus,
                result: result
            },
            success: function(jsonString) {
                var info = $.parseJSON(jsonString);
                if (info.status == 'ok') {
                alert("Done successfully");  
                //location.reload();
                if(type == "close")      
                {
                    canMakeAction('ok', appointmentId);
                    //location.reload();
                }
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
                    $(obj).parent().parent().parent().find("#myDurationLink").html(callDuration);
//                    $(obj).parent().parent().parent().find("#myLink").html(comment);
                    $(obj).parent().parent().parent().find("#myPlaceLink").html(appointmentPlace);
                    $(obj).parent().parent().parent().parent().find("#commentText" + appointmentId).hide();
                    $("#commentText" + appointmentId).val("");
                    $(obj).parent().parent().parent().parent().find("#commentVal" + appointmentId).hide();
                    $(obj).parent().parent().parent().parent().find("#callDuration" + appointmentId).hide();
                    $(obj).parent().parent().parent().parent().find("#appointmentPlace" + appointmentId).hide();
                    $(obj).css("background-position", "top");
                    getAppointmentComment(appointmentId);
                    reload();
                    console.log("status is ok");
                } 
                else 
                {
                    canMakeAction('no', appointmentId);
                }
                location.reload();
            }
        });
    }

function reload()
{
    var url = "<%=context%>/AppointmentServlet?op=showClientAppointment&clientId=" + $("#clientId").val() + "&cach=" + (new Date()).getTime();
    $.ajax({
        
        type: "post",
         url: url,
           success: function(jsonString) {
           },
           error: function (jqXHR, textStatus, errorThrown) {
                    }
     });
}
    function closePopupDiv() {
        $("#showDiv").css("display", "none");
        $("#shownTextArea").val("");
    }

    function canMakeAction(ok, appointmentId) {
        if (ok == 'ok') {
            document.getElementById('updateIcon' + appointmentId).style.display = 'none';
            
            document.getElementById('closeIcon1' + appointmentId).style.display = 'none';
            document.getElementById('deleteIcon' + appointmentId).style.display = 'none';
            document.getElementById('updateStopIcon' + appointmentId).style.display = 'block';
            
             document.getElementById('closeStopIcon' + appointmentId).style.display = 'block';
            document.getElementById('deleteStopIcon' + appointmentId).style.display = 'block';
        } else {
            document.getElementById('updateIcon' + appointmentId).style.display = 'block';
            document.getElementById('closeIcon1' + appointmentId).style.display = 'block';
            document.getElementById('deleteIcon' + appointmentId).style.display = 'block';
            document.getElementById('updateStopIcon' + appointmentId).style.display = 'none';
            document.getElementById('deleteStopIcon' + appointmentId).style.display = 'none';
             document.getElementById('closeStopIcon' + appointmentId).style.display = 'none';
        }
    }
    function openInNewWindow(url) {
        var win = window.open(url, '_blank');
        win.focus();
    }
    
    function getAppointmentComment(appointmentID) {
        $.ajax({
            type: "post",
            url: "<%=context%>/AppointmentServlet?op=getAppointmentCommentAjax",
            data: {
                appointmentID: appointmentID
            },
            success: function (jsonString) {
                var info = $.parseJSON(jsonString);
                if (info.status === 'ok') {
                    $("#commentPre" + appointmentID).html(info.comment);
                }
            }
        });
    }
</script>

<style type="text/css">
 
 

/* visited link */
a:visited {
    color: black;
}

/* mouse over link */
a:hover {
    color: blue;
}

/* selected link */
a:active {
    color: blue;
}

 th{text-align: center}
 td{text-align: center}
    .login  h1 {

        font-size: 16px;
        font-weight: bold;

        padding-top: 10px;
        padding-bottom: 10px;
        text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
        text-align: center;
        width: 96%;

        margin-left: auto;
        margin-right: auto;
        text-height: 30px;


        color: #ffffff;

        text-shadow: 0 1px rgba(255, 255, 255, 0.3);
        background: #FF9900;
        /*background: #cc0000;*/
        background-clip: padding-box;
        border: 1px solid #284473;
        border-bottom-color: #223b66;
        border-radius: 4px;
        cursor: pointer;
     }

    .save3{
        width:20px;
        height:20px;
        background-image:url(images/icons/icon-32-publish.png);
        background-repeat: no-repeat;
        background-position: bottom;
        cursor: pointer;
        background-color:transparent;
        border:none;    

    }

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
</style>
<body>
    <% if (appointments != null && !appointments.isEmpty()) { %>
     
    <div id="showDiv" style="position: relative;display: none;height: 100px;width: 500px;">
        <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
             -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
             box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
             -webkit-border-radius: 100px;
             -moz-border-radius: 100px;
             border-radius: 100px;" onclick="closePopupDiv()"/>
        <textarea id="shownTextArea"  maxlength="500" name="shownTextArea" style="background-color: #0088cc;height: 75%" ></TEXTAREA>
    </div>
    <div class="login" style="width: 100%;margin-bottom: 10px;margin-left: auto;margin-right: auto;overflow: auto;height: 300px;">
        <h1><fmt:message key="followup"/>   </h1> 

        <table  border="0px" style="width:100%;text-align: center" class="table" id="appointmentTable" dir="<fmt:message key="direction"/>">
            <thead>
                <tr>
                    <th CLASS="blueHeaderTD backgroundTable"style="width: 1%; border-width: 0px ;text-align: center">#</th>
                    <th CLASS="blueHeaderTD backgroundTable"style="width: 9%; border-width: 0px ;text-align: center"><fmt:message key="client"/> </th>
                     <th CLASS="blueHeaderTD backgroundTable"style="width: 9%; border-width: 0px ;text-align: center"><fmt:message key="mobileno"/> </th>
                    <th CLASS="blueHeaderTD backgroundTable"style="width: 9%; border-width: 0px ;text-align: center"><fmt:message key="source"/> </th>
                     <th CLASS="blueHeaderTD backgroundTable"style="width:  6%; border-width: 0px ;text-align: center"><fmt:message key="result"/></th>
                     <th CLASS="blueHeaderTD backgroundTable" style="width: 7%; border-width: 0px ;text-align: center"><fmt:message key="date2"/></th>
                    <th CLASS="blueHeaderTD backgroundTable"style="width:  7%; border-width: 0px ;text-align: center"><fmt:message key="date"/>  </th>        
                    <th CLASS="blueHeaderTD backgroundTable" style="width: 1%; border-width: 0px ;text-align: center"><fmt:message key="type"/> </th>
                     <th CLASS="blueHeaderTD backgroundTable" style="width: 10%; border-width: 0px ;text-align: center"><fmt:message key="notes"/> </th>
                    <th CLASS="blueHeaderTD backgroundTable" style="width: 1%; border-width: 0px ;text-align: center"><fmt:message key="edit"/></th>
                     <%if(quickCalenderPrev){%>
                    <th CLASS="blueHeaderTD backgroundTable" style="width: 1%; border-width: 0px ;text-align: center;" colspan="2"><fmt:message key="close"/></th>
                    <%}%>
                    <th CLASS="blueHeaderTD backgroundTable" style="width: 1%; border-width: 0px ;text-align: center; display: none;"><fmt:message key="delete"/></th>
                </tr>
            </thead>
            <%
                String appointmentId, appointmentTitle, appointmentDate, appointmentNote, clientId, clientName, createdByName, enterDate, appointmentPlace,comment="",subcomment, callDuration;
                int counter = 0, timeRemaining;
                boolean canMakeAction;
                for (WebBusinessObject wbo : appointments) {
                    System.out.println(wbo.getObjectAsJSON2());
                    String call = "", option2="",meeting = "", incoming = "", outgoing = ""; 
                    timeRemaining = 0;
                    try {
                        timeRemaining = Integer.parseInt((String) wbo.getAttribute("timeRemaining"));
                    } catch (Exception ex) {
                    }

//                    if ((CRMConstants.APPOINTMENT_STATUS_OPEN.equalsIgnoreCase((String) wbo.getAttribute("currentStatusCode")) && (timeRemaining > 0))
//                            || CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP.equalsIgnoreCase((String) wbo.getAttribute("currentStatusCode"))) {
                        canMakeAction = true;
                        disabled = "";
//                    } else {
//                        canMakeAction = false;
//                        disabled = "disabled";
//                    }

                    // for the Radio Button Mark (Meeting type)
                    if (wbo.getAttribute("option2") != null && (wbo.getAttribute("option2").equals("phone") || wbo.getAttribute("option2").equals("call"))) {
                        call = "checked";
                        option2="مكالمة";
                        meeting = "";
                    } else if (wbo.getAttribute("option2") != null && wbo.getAttribute("option2").equals("meeting")) {
                        call = "";
                        meeting = "checked";
                        option2="مقابلة";

                    }

                    if (wbo.getAttribute("option3") != null && wbo.getAttribute("option3").equals("incoming")) {
                        incoming = "checked";
                        outgoing = "";
                    } else if (wbo.getAttribute("option3") != null && wbo.getAttribute("option3").equals("out_call")) {
                        incoming = "";
                        outgoing = "checked";
                    }

                    counter++;
                    clientId = (String) wbo.getAttribute("clientId");
                    clientName = (String) wbo.getAttribute("clientName");
                    createdByName = (String) wbo.getAttribute("createdByName");
                    appointmentNote = (String) wbo.getAttribute("note");
                    if (appointmentNote != null & !appointmentNote.equals("")) {
                    } else {
                        appointmentNote = "لاتوجد ملاحظات";
                    }
                    appointmentNote.trim();
                    appointmentDate = DateAndTimeControl.getDateAfterSubString(((String) (wbo.getAttribute("appointmentDate"))).substring(0, wbo.getAttribute("appointmentDate").toString().length() - 5));
                    if (appointmentDate != null & !appointmentDate.equals("")) {
                    } else {
                        appointmentDate = "";
                    }
                    enterDate = DateAndTimeControl.getDateAfterSubString(((String) (wbo.getAttribute("creationTime"))).substring(0, wbo.getAttribute("creationTime").toString().length() - 5));
                    appointmentTitle = (String) wbo.getAttribute("title");
                    if (appointmentTitle != null & !appointmentTitle.equals("")) {
                    } else {
                        appointmentTitle = "لايوجد عنوان للمقابلة";
                    }

                    appointmentPlace = (String) wbo.getAttribute("appointmentPlace");
                    if (appointmentPlace != null && !appointmentPlace.equals("") && !appointmentPlace.equals("UL")) {
                    } else {
                        appointmentPlace = "لايوجد مكان للمقابلة";
                    }
                    if(wbo.getAttribute("comment")!=null ){
                     comment=((String) wbo.getAttribute("comment")).trim();
                }
                     subcomment=comment;
                     if(comment!=null && !comment.isEmpty() && comment.length() > 15)
                     {
                     subcomment=comment.substring(0, 15)+ " ...";
                     }
                    appointmentId = (String) wbo.getAttribute("id");
                    callDuration = wbo.getAttribute("callDuration") != null ? (String) wbo.getAttribute("callDuration") : "0";

                    String checkboxName = "appStatus" + counter;
                    String noteName = "note" + counter;
                    String call_statusName = "call_status" + counter;
            %>
            <tr id="row<%=appointmentId%>">
                <td style="border-width: 0px">
                    <b id="appTitleText"><%=counter%></b>
                </td>
                <td style="border-width: 0px">
                    <input type="hidden" id="appointmentId" value="<%=appointmentId%>" />
                    <input type="hidden" id="clientId" value="<%=clientId%>" />
                    <input type="hidden" id="clientNameInput" name="clientNameInput" value="<%=clientName%>" />
                    <a href="#" onclick="JavaScript: openInNewWindow('<%=context%>/ClientServlet?op=clientDetails&clientId=<%=clientId%>')">
                        <b id="clientName"><%=clientName%></b>
                    </a>
                </td>
                <td style="border-width: 0px">
                    <b id="clientMobile"><%=wbo.getAttribute("mobile")%></b>
                </td>
                <td style="border-width: 0px">
                    <b id="createdByName"><%=createdByName%></b>
                     <input  type="hidden" id="appTitleInput" style="float: right;display: none;" value="<%=appointmentTitle%>" />
                </td>
                 
                <td style="border-width: 0px">
                  
                    <%=appointmentNote%>
                    <input type="hidden" id="appNote1" name="appNote1" value="<%=appointmentNote%>" />
                    <input type="hidden" id="appointmentPlace" name="appointmentPlace" value="<%=appointmentPlace%>" />

                </td>
                 
                <td style="border-width: 0px">
                    <input type="hidden" id="appDate1" name="appDate1" value="<%=appointmentDate%>" />
                    <b id="appDateText" style="color: #f00;"><%=appointmentDate%></b>
                    <input type="hidden" id="currentStatus<%=appointmentId%>" value="<%=wbo.getAttribute("currentStatusCode")%>"/>

                </td>
                <td style="border-width: 0px">
                    <b style="color: white;">  <%=enterDate%></b>
                </td>
                <td style="border-width: 0px ; text-align: center">
                    <%=option2%>
                    <input type="hidden" name="<%=noteName%>" id="<%=noteName%>" value="<%=wbo.getAttribute("option2")%>" />
                    <%--<input name=<%=noteName%> type="radio" value="call" id="<%=noteName%>" <%=disabled%> <%=call%> />
                    <label><fmt:message key="call"/>  </label>
                    <input name=<%=noteName%> type="radio" value="meeting" id="<%=noteName%>" style="margin-right: 10px;" <%=disabled%> <%=meeting%>/>
                           <label> <fmt:message key="meeting"/> </label> --%>
                </td>
                 
                <td style="border-width: 0px ; text-align: center">
                    <a id="myLink" title="<%=comment%>" href="#" onclick="showcomment('<%=appointmentId%>','<%=!canMakeAction%>');return false;"  ><%=subcomment%></a>
                    <b id="commentVal<%=appointmentId%>" style="display: none;"><pre id="commentPre<%=appointmentId%>"><%=comment != null ? comment : ""%></pre></b>
                    <textarea id="commentText<%=appointmentId%>" cols="30" rows="5" style="background-color: yellow; display: none"></textarea>
                </td>
                <td style="border-width: 0px">
                    <div align="center" style="width: 100%;display: block">
                        <img src="images/icons/edit.png" id="updateIcon<%=appointmentId%>" width="19" height="19" style="cursor: hand; vertical-align: middle; display: <%=(canMakeAction) ? "block" : "none"%>" onclick="updateApp(this,<%=counter%>, 'update')" />
                        <img src="images/icons/stop.png" id="updateStopIcon<%=appointmentId%>" width="19" height="19" style="vertical-align: middle; display: <%=(canMakeAction) ? "none" : "block"%>" />
                    </div>
                </td>
                <%if(quickCalenderPrev){%>
                <td style="border-width: 0px;">
                    <div align="center" style="width: 100%;display: <%=CRMConstants.APPOINTMENT_STATUS_DONE.equalsIgnoreCase(wbo.getAttribute("currentStatusCode").toString()) ? "none" : "block"%>;">
                        <%if(option2 != null && option2.equalsIgnoreCase("مكالمة")){%>
                            <img src="images/ok_white.png" id="closeIcon1<%=appointmentId%>" width="19" height="19" style="cursor: hand; vertical-align: middle; display: <%=(canMakeAction) ? "block" : "none"%>" title="<fmt:message key="answered"/>" onclick="updateApp1(this,<%=counter%>, 'answered')" />
                            <fmt:message key="answered"/>
                        <%} else {%>
                            <img src="images/ok_white.png" id="closeIcon1<%=appointmentId%>" width="19" height="19" style="cursor: hand; vertical-align: middle; display: <%=(canMakeAction) ? "block" : "none"%>" title="<fmt:message key="attended"/>" onclick="updateApp1(this,<%=counter%>, 'attended')" />
                            <fmt:message key="attended"/>
                        <%}%>
                        <img src="images/icons/stop.png" id="closeStopIcon<%=appointmentId%>" width="19" height="19" style="vertical-align: middle; display: <%=(canMakeAction) ? "none" : "block"%>" />
                    </div>
                </td>
                <td style="border-width: 0px; ">
                    <div align="center" style="width: 100%;display: <%=CRMConstants.APPOINTMENT_STATUS_DONE.equalsIgnoreCase(wbo.getAttribute("currentStatusCode").toString()) ? "none" : "block"%>;">
                        <%if(option2 != null && option2.equalsIgnoreCase("مكالمة")){%>
                            <img src="images/ok_white.png" id="closeIcon2<%=appointmentId%>" width="19" height="19" style="cursor: hand; vertical-align: middle; display: <%=(canMakeAction) ? "block" : "none"%>" title="<fmt:message key="nanswered"/>" onclick="updateApp1(this,<%=counter%>, 'not answered')" />
                            <fmt:message key="nanswered"/>
                        <%} else {%>
                            <img src="images/ok_white.png" id="closeIcon2<%=appointmentId%>" width="19" height="19" style="cursor: hand; vertical-align: middle; display: <%=(canMakeAction) ? "block" : "none"%>" title="<fmt:message key="nattended"/>" onclick="updateApp1(this,<%=counter%>, 'not attended')" />
                            <fmt:message key="nattended"/>
                        <%}%>
                        <img src="images/icons/stop.png" id="closeStopIcon<%=appointmentId%>" width="19" height="19" style="vertical-align: middle; display: <%=(canMakeAction) ? "none" : "block"%>" />
                    </div>
                </td>
                <%}%>
                <td style="border-width: 0px;display: none;">
                    <div align="center" style="width: 100%;display: block">
                        <img src="images/icons/delete_ready.png" id="deleteIcon<%=appointmentId%>" width="19" height="19" style="cursor: hand; vertical-align: middle; display: <%=(canMakeAction) ? "block" : "none"%>" onclick="removeApp(this)" />
                        <img src="images/icons/stop.png" id="deleteStopIcon<%=appointmentId%>" width="19" height="19" style="vertical-align: middle; display: <%=(canMakeAction) ? "none" : "block"%>"/>
                    </div>
                </td>
            </tr>
            <tr>
                <td id="commentTextcol<%=appointmentId%>" colspan="10" style="border: none ; display: none">
                    
                </td>
             </tr>
            <% } %>
        </table>
    </div>
    <% } else { %>
    <div style="clear: both;margin-left: 68%;margin-top: 0px;margin-bottom: -35px;width: 32px;">
        <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;" onclick="closePopup(this)"/>
    </div>
    <div class="login" style="width: 40%;margin-bottom: 10px;margin-left: auto;margin-right: auto;">
        <div style="margin-right: auto;margin-left: auto;width: 100%;font-size: 24px;color: white;text-align: center;"> <fmt:message key="nomeetings"/> </div>
    </div>
    <% }%>
</body>   