<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.tracker.db_access.CampaignMgr"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <link rel="stylesheet" type="text/css" href="css/custom_popup.css" />
        <title>JSP Page</title>
        <%
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();
            int hoursBeforeNeglect=Integer.parseInt(metaMgr.getHoursBeforeNeglect());
            int numberOfRows = 3;
            List<WebBusinessObject> appointments = (List<WebBusinessObject>) request.getAttribute("appointments");
             int doneCntr=0,caredCntr=0,followCntr=0,fntrCntr=0,negCntr=0;
            String stat = (String) request.getSession().getAttribute("currentMode");
            String dateReport=request.getAttribute("date").toString();
            String dir = null;
            if (stat.equals("En")) {
                dir = "LTR";
            } else {
                dir = "RTL";
            }
        %>
    </head>
    <body style="width: 100%">
        <div style="margin-left: auto; margin-right: auto; width: 40%; white-space: nowrap;">
            <h4>Appointments Schedule for <b id="employeeName" style="color: red;">&nbsp;</b> in <b id="appointmentDate" style="color: blue;">&nbsp;</b></h4>
        </div>
        <div id="visualization"></div>
        <TABLE width="100%" CELLPADDING="0" CELLSPACING="2" ALIGN="CENTER" style="border-width: 0px" DIR="<%=dir%>">
            <tr id="excelRow" >
            
            </tr>
            <br></br>
            <%
                String popupTitle, title, creator, responsible = "", date, type, option2, directedByName, currentStatusCode, imageName, campaignName,
                        clientName, comment;
                WebBusinessObject appointment, formattedTime;
                int timeRemaining, counter = 0, index;
                while (counter < appointments.size()) {
                    index = 1;
                   
            %>
            
            <TR style="border-width: 0px">
                <%
                    while (((index % (numberOfRows + 1)) != 0) && (counter < appointments.size())) {
                        index++;
                        appointment = appointments.get(counter++);
                        timeRemaining = Integer.parseInt((String) appointment.getAttribute("timeRemaining"));
                        currentStatusCode = (String) appointment.getAttribute("currentStatusCode");
                        option2 = (String) appointment.getAttribute("option2");
                        if (CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP.equalsIgnoreCase(currentStatusCode)) {
                            index--;
                        continue;
                        }                       

                        if (CRMConstants.CALL_RESULT_MEETING.equalsIgnoreCase(option2)) {
                            type = "مقابلة";
                        } else if (CRMConstants.CALL_RESULT_FOLLOWUP.equalsIgnoreCase(option2)) {
                            type = "متابعة مباشرة";
                        } else {
                            type = "مكالمة";
                        }

                        if (CRMConstants.APPOINTMENT_STATUS_DONE.equalsIgnoreCase(currentStatusCode)) {
                            imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DONE);
                            popupTitle = " تمت بنجاح";
                            doneCntr++;
                        } else if (CRMConstants.APPOINTMENT_STATUS_CARED.equalsIgnoreCase(currentStatusCode)) {
                            imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_CARED);
                            popupTitle = type + " معتنى بها";
                            caredCntr++;
                        } else if (CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP.equalsIgnoreCase(currentStatusCode)) {
                            imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DIRECT_FOLLOW_UP);
                            popupTitle = "متابعة مباشرة";
                            followCntr++;
                        } else if (timeRemaining >= -(hoursBeforeNeglect* 60) && CRMConstants.APPOINTMENT_STATUS_OPEN.equalsIgnoreCase(currentStatusCode)) {
                            System.out.println(timeRemaining);
                            imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_OPEN);
                            popupTitle = type + " مستقبلية";
                            fntrCntr++;
                        } else {
                            appointment.setAttribute("currentStatusCode", CRMConstants.APPOINTMENT_STATUS_NEGLECTED);
                            imageName = CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_NEGLECTED);
                            popupTitle = type + " أهملت";
                            negCntr++;
                        }

                        directedByName = "---";
                        if (appointment.getAttribute("directedByName") != null) {
                            directedByName = (String) appointment.getAttribute("directedByName");
                        }

                        title = (String) appointment.getAttribute("title");
                        creator = (String) appointment.getAttribute("createdByName");
                        responsible = (String) appointment.getAttribute("userName");
                        clientName = (String) appointment.getAttribute("clientName");
                        date = (String) appointment.getAttribute("appointmentDate");
                        String tempDate = date.split(" ")[0];
                        String[] dateArr = tempDate.contains("-") ? tempDate.split("-") : tempDate.split("/");
                        if (dateArr.length == 3) {
                            if (dateArr[0].length() == 4) {
                                date = dateArr[2] + "/" + dateArr[1] + "/" + dateArr[0] + " " + date.split(" ")[1];
                            } else {
                                date = dateArr[0] + "/" + dateArr[1] + "/" + dateArr[2] + " " + date.split(" ")[1];
                            }
                        }
                        campaignName = "لايوجد";
                        formattedTime = DateAndTimeControl.getFormattedDateTime2(date, stat);
                        if (appointment.getAttribute("option5") != null && !((String) appointment.getAttribute("option5")).equalsIgnoreCase("UL")) {
                            CampaignMgr campaignMgr = CampaignMgr.getInstance();
                            WebBusinessObject campaignWbo = campaignMgr.getOnSingleKey((String) appointment.getAttribute("option5"));
                            if (campaignWbo != null) {
                                campaignName = (String) campaignWbo.getAttribute("campaignTitle");
                            }
                        }
                        if (appointment.getAttribute("comment") != null) {
                            comment = (String) appointment.getAttribute("comment");
                        } else {
                            comment = "لا يوجد";
                        }
                %>
                <TD style="border-width: 0px">
                    <h3 class="popup-title" style="text-align: right">                        
                        <img id="popup-title-icon" src="images/icons/<%=imageName%>" width="24" height="24" style="vertical-align: middle"/>
                        <b id="popup-title-text" style="font-size: 16px"><%=popupTitle%></b>
                    </h3>
                    <br />
                    <TABLE class="backgroundTable" width="390" CELLPADDING="0" CELLSPACING="8" ALIGN="CENTER" DIR="<%=dir%>">
                        <TR>
                            <TD class="backgroundHeader" style="text-align: right" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold">اسم الحملة :</b>
                            </TD>
                            <TD id="campaign-name" style="border-width: 0px; text-align: right" width="65%"><%=campaignName%></TD>
                        </TR>
                        <TR>
                            <TD class="backgroundHeader" style="text-align: right" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold">اسم العميل :</b>
                            </TD>
                            <TD id="campaign-name" style="border-width: 0px; text-align: right" width="65%">
                                <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=appointment.getAttribute("clientId")%>" target="clientTab"><%=clientName%></a>
                            </TD>
                        </TR>
                        <tr>
                            <td class="backgroundHeader" style="text-align: right" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold">رقم العميل :</b>
                            </td>
                            <td id="campaign-name" style="border-width: 0px; text-align: right" width="65%">
                                <a href="<%=context%>/ClientServlet?op=clientDetails&clientId=<%=appointment.getAttribute("clientId")%>" target="clientTab"><%=appointment.getAttribute("clientNo")%></a>
                            </td>
                        </tr>
                        <tr>
                            <td class="backgroundHeader" style="text-align: right" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold">الموبايل :</b>
                            </td>
                            <td id="campaign-name" style="border-width: 0px; text-align: right" width="65%"><%=appointment.getAttribute("mobile")%></td>
                        </tr>
                        <TR>
                            <TD class="backgroundHeader" style="text-align: right" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold">عنوان المقابلة :</b>
                            </TD>
                            <TD id="appointment-title" style="border-width: 0px; text-align: right" width="65%"><%=title%></TD>
                        </TR>
                        <TR>
                            <TD class="backgroundHeader" style="text-align: right" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold">النوع : </b>
                            </TD>
                            <TD id="appointment-type" style="border-width: 0px; text-align: right" width="65%"><%=type%></TD>
                        </TR>
                        <TR>
                            <TD class="backgroundHeader" style="text-align: right" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold">الموظف المسؤل :</b>
                            </TD>
                            <TD id="appointment-for" style="border-width: 0px; text-align: right" width="65%"><%=responsible%></TD>
                        </TR>
                        <TR>
                            <TD class="backgroundHeader" style="text-align: right" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold">انشئت بواسطة :</b>
                            </TD>
                            <TD id="appointment-creator" style="border-width: 0px; text-align: right" width="65%"><%=creator%></TD>
                        </TR>
                        <TR>
                            <TD class="backgroundHeader" style="text-align: right" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold">وجهت بواسطة : </b>
                            </TD>
                            <TD id="appointment-directed-by" style="border-width: 0px; text-align: right" width="65%"><%=directedByName%></TD>
                        </TR>
                        <TR>
                            <TD class="backgroundHeader" style="text-align: right" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold">التاريخ :</b>
                            </TD>
                            <TD id="appointment-date" style="border-width: 0px; text-align: right" width="65%"><font color="red"><%=formattedTime.getAttribute("day")%> - </font><b><%=formattedTime.getAttribute("time")%></b></TD>
                        </TR>
                        <TR>
                            <TD class="backgroundHeader" style="text-align: right" width="35%">
                                <p><b style="margin-left: 5px;margin-left: 5px;font-weight: bold">تعليق :</b>
                            </TD>
                            <TD id="appointment-directed-by" style="border-width: 0px; text-align: right" width="65%"><%=comment%></TD>
                        </TR>
                    </TABLE>
                    <br/>
                </TD>
                <%}%>
            <TR>
                <%}%>
        </TABLE>
        <script type="text/javascript">
            // DOM element where the Timeline will be attached
            var container = document.getElementById('visualization');

            // Create a DataSet (allows two way data-binding)
            var items = new vis.DataSet([
            <%
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                Calendar c = Calendar.getInstance();
                index = 1;
                for (WebBusinessObject wbo : appointments) {
                    c.setTime(sdf.parse((String) wbo.getAttribute("appointmentDate")));
                    if (CRMConstants.CALL_RESULT_MEETING.equals(wbo.getAttribute("option2"))) {
            %>
                {id: <%=index++%>, content: '<%=wbo.getAttribute("clientName")%>', start: '<%=wbo.getAttribute("appointmentDate")%>'},
            <%
                    }
                }
            %>
            ]);

            // Configuration for the Timeline
//            var options = {};
            var options = {
                height: '120px',
                min: new Date(<%=c.get(Calendar.YEAR)%>, <%=c.get(Calendar.MONTH)%>, <%=c.get(Calendar.DATE)%>, 0, 1), // lower limit of visible range
                max: new Date(<%=c.get(Calendar.YEAR)%>, <%=c.get(Calendar.MONTH)%>, <%=c.get(Calendar.DATE)%>, 23, 0), // upper limit of visible range
                zoomMin: 1000 * 60 * 60 * 24, // one day in milliseconds
                zoomMax: 1000 * 60 * 60 * 24
            };

            // Create a Timeline
            var timeline = new vis.Timeline(container, items, options);
            <%
                sdf.applyPattern("dd MMMM yyyy");
            %>
            $("#employeeName").html('<%=responsible%>');
            $("#appointmentDate").html('<%=sdf.format(c.getTime())%>');
            var rHtml="";
            
            
            <%if(negCntr>0){%> 
                $("#excelRow").append("<td style='border-width:0px'><a onclick='javascript:getCallsExcel(<%=CRMConstants.APPOINTMENT_STATUS_NEGLECTED%>)'  title='neglected calls Excel'><img src='images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_NEGLECTED)%>'width='24' height='24' style='vertical-align: middle'/><img width='40px' src='images/excelIcon.png'/></a></td>")
             <%}%>
                
            <%if(fntrCntr>0){%>
                $("#excelRow").append("<td style='border-width:0px'><a onclick='javascript:getCallsExcel(<%=CRMConstants.APPOINTMENT_STATUS_OPEN%>)' title='Future calls Excel' ><img src='images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_OPEN)%>' width='24' height='24' style='vertical-align: middle'/><img width='40px' src='images/excelIcon.png'/></a></td>")
            <%}%>
                
            <%if(caredCntr>0){%>
                $("#excelRow").append("<td style='border-width:0px'><a onclick='javascript:getCallsExcel(<%=CRMConstants.APPOINTMENT_STATUS_CARED%>)' title='Cared calls Excel'> <img src='images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_CARED)%>' width='24' height='24' style='vertical-align: middle'/><img width='40px' src='images/excelIcon.png'/></a></td>")
            <%}%>
            
            <%if(doneCntr>0){%> 
              $("#excelRow").append("<td style='border-width:0px'><a onclick='javascript:getCallsExcel(<%=CRMConstants.APPOINTMENT_STATUS_DONE%>)' title='Done calls Excel'> <img src='images/icons/<%=CRMConstants.APPOINTMENT_STATUS_IMAGES.get(CRMConstants.APPOINTMENT_STATUS_DONE)%>' width='24' height='24' style='vertical-align: middle'/><img width='40px' src='images/excelIcon.png'/></a></td>") 
            <%}%>
             
            
            
    
        
        function getCallsExcel(type){
            var url = "<%=context%>/AppointmentServlet?op=showAppointmentsForUserExcel&type="+type+"&userId="+<%=request.getAttribute("userId")%>+"&date="+'<%=dateReport%>';
           $.ajax({
               type:"post",
               url:url,
               data:{
                   appointments:'<%=appointments%>'
               },
                       success:function(){
                           window.open(url, "_blank", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=700, height=700");
                       }
           })
            
            
            
        }
            
        </script>
    </body>
</html>
