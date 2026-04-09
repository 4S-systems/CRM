<%-- 
    Document   : my_client_locations
    Created on : Jan 11, 2021, 3:36:31 PM
    Author     : mariam
--%>

<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="java.text.DecimalFormat"%>

<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.silkworm.common.UserMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%> 
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
        <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
    <fmt:setLocale value="${loc}"  />
    <fmt:setBundle basename="Languages.Client.client" />
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        ArrayList<WebBusinessObject> locationsList = (ArrayList<WebBusinessObject>) request.getAttribute("locationsList");

        String stat = (String) request.getSession().getAttribute("currentMode");
        WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String usrEmail=(String) loggedUser.getAttribute("email");
        String clientId = request.getAttribute("clientID") != null ? (String) request.getAttribute("clientID") : "";
        ClientMgr clientMgr=ClientMgr.getInstance();
        String clientName=clientMgr.getByKeyColumnValue("key",clientId,"key5");
        String clientEmail=clientMgr.getByKeyColumnValue("key",clientId,"key12");
        String dir, align, to, title, attachFile, body, unit, none, from, direction, title1,successMsg,failMsg;
        String address,date,coordinate,sendEmail;
       if (stat.equals("En")) {
        dir = "ltr";
        align = "left";
        to = "To";
        title = "Email";
        attachFile = "Attach File";
        body = "Body";
        unit= "Unit Details";
        none="None";
        from = " From ";
        direction = "left";
        title1 = "Title";
        successMsg = "Message Sent Successfully";
        failMsg = "Fail to Send Message";
        address="Address";
        date="Address Status Since";
        coordinate="Coordinate";
        sendEmail="Send Address by mail";
    } else {
        dir = "rtl";
        align = "right";
        to = "إلي";
        title = "الايميل";
        attachFile = "إرفاق ملف";
        body = "نص الرسالة";
        unit= "تفاصيل الوحده";
        none= "لا يوجد";
        direction = "right";
        from = " من ";
        title1 = "العنوان";
        successMsg = "تم أرسال الرسالة";
        failMsg = "لم يتم أرسال الرسالة";
        address="اسم العنوان";
        date=" منذ تاريخ";
        coordinate="الاحداثيات";
        sendEmail=" ارسال العنوان بالايميل";
            
    }


    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
            
            <link href="js/jquery-te/jquery-te-1.4.0.css" rel="stylesheet"/>
        <title>JSP Page</title>
        <style type="text/css">
            html { height: 100% }
            
            #map_canvas { height: 540px; width:100%; }
            .table tr td:nth-child(1){
                width:20%;
            }
            
        </style>
        <script type="text/javascript"src="http://maps.googleapis.com/maps/api/js?key=AIzaSyBF6bzM0-thal8DDuQuuMrPXUW5JLOGTUY&sensor=true&language=ar&region=ES">
        </script>
        <script type="text/javascript">
            
            
            
            
            function openLocation(loc){
                $.ajax({
                        type: "POST",
                                url: "<%=context%>/ProjectServlet",
                                data: "op=insertClientLocation&clientID=<%=clientId%>&type=show&coordinate="+ loc,
                                success: function (msg) {
                                var url = '<%=context%>/ProjectServlet?op=insertClientLocation&clientID=<%=clientId%>&type=show&coordinate='+ loc;
                                        var wind = window.open(url, '<fmt:message key="showmaps" />', "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                                        wind.focus();
                                }
                        });
                       
            }
            function openEmailPopup(lat,lng){
//            $(this).dialog('close');
//            $("#sendEmailDiv").css("display","block");
//            $("#sendEmailDiv").bPopup();
//             //$("input").removeClass("uneditable-input");


            //$("#mailBody").html("https://www.google.com.eg/maps/place/"+lat+","+lng);
            
            $.ajax({
                        type: "POST",
                        url: "<%=context%>/EmailServlet",
                        data: "op=getEmailPopupLocation&clientID=<%=clientId%>&lat="+ lat+"&lng="+lng,
                        success: function (msg) {
                        var url = '<%=context%>/EmailServlet?op=getEmailPopupLocation&clientID=<%=clientId%>&lat='+ lat+'&lng='+lng;
                                var wind = window.open(url, '<fmt:message key="sendEmail" />', "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no");
                                wind.focus();
                        }
                        });
            
            }
            function sendMailByAjax2() {
                $("#progressx").css("display", "block");
                $("#progressx").show();
                $("#emailStatus").html("");
                $("#progressx").css("display", "block");
                var formData = new FormData($("#emailForm")[0]);
                var obj = $("#listFile");
                $.each($(obj).find("input[type='file']"), function (i, tag) {
                    $.each($(tag)[0].files, function (i, file) {
                        formData.append(tag.name, file);
                    });
                });
                
                formData.append("to", $("#to").val());
                formData.append("title", $("#subject").val());
                formData.append("subject", $("#subject2").val());
                formData.append("counter", $("#emailCounter").val());
                formData.append("message", $("#mailBody").val());
                $.ajax({
                    url: '<%=context%>/EmailServlet?op=sendByAjaxClient',
                    type: 'POST',
                    data: formData,
                    async: false,
                    success: function (data) {
                        var result = $.parseJSON(data);
                        $("#progressx").html('');
                        $("#progressx").css("display", "none");
                        if (result.status == 'ok') {
                            $("#emailStatus").html("<font color='green'><%=successMsg%></font>");
                        } else if (result.status == 'error') {
                            $("#emailStatus").html("<font color='red'><%=failMsg%></font>");
                        }
                    }, error: function (){
                        $("#emailStatus").html("<font color='red'><%=failMsg%></font>");
                    }, cache: false,
                    contentType: false,
                    processData: false
                });
                return false;
            }

            var count = 1;
            function addEmailFiles(obj) {
                if ((count * 1) == 4) {
                $("#addEmailFile").removeAttr("disabled");
                }

                if (count >= 1 & count <= 4) {
                    $("#listFile").append("<input type='file' style='text-align:right;font-size:12px;margin:1.5px;' name='file" + count + "' id='file2'  maxlength='60'/>");
                    $("#emailCounter").val(count);
                    count = Number(count * 1 + 1)
                } else {
                    $("#addEmailFile").attr("disabled", true);
                }
            }
            
        </script>
    </head>
    <body>
         <form id="COMPLAINTS_FORM" name="COMPLAINTS_FORM" method="POST" action="<%=context%>/ClientServlet?op=withdrawFromDetails">
	    <input type="hidden" id="clientId" name="clientId" value="<%=clientId%>">
	    

            <table id="clientLocationPopup" align="center" dir="rtl" width="100%" cellpadding="0" cellspacing="0">
                <thead>
                    <tr>
                        
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap><b>#</b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap><b><%=address%></b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap><b><%=date%></b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap><b><%=coordinate%></b></th>
                        <th class="blueBorder backgroundTable" style="text-align:center;font-size:14px; font-weight: bold; height: 30px" nowrap><b><%=sendEmail%></b></th>
                        
                    </tr>
                </thead>
                <tbody>

                    <%
                        if (locationsList.size() > 0 && locationsList != null) {
                            String complStatus;
                            String sDate, sTime;
                            int iTotal = 0;
                            double lat=0.0;
                            double lng=0.0;
                            int decLat=0;
                            for (WebBusinessObject wbo : locationsList) {
                                iTotal++;
                                DecimalFormat df = new DecimalFormat("0.00"); 
                                lat=Double.parseDouble(wbo.getAttribute("coordinate").toString().split(" ")[1]);
                                lng=Double.parseDouble(wbo.getAttribute("coordinate").toString().split(" ")[3]);
                                
                    %>
                    <tr style="padding: 1px;">
                        <td>
                            <%=iTotal%>
                        </td>
                        <td style="cursor: pointer">
                             <b><%=wbo.getAttribute("locName")%></b>      
                        </td>
                        <td>
                            <b><%=wbo.getAttribute("currentStatusSince").toString().split(" ")[0]%></b>
                        </td>
                        
                        <td>
                            <a  onclick="javascript:openLocation('('+<%=lat%>+', '+<%=lng%>+')')"><font color="blue">[<b><%=df.format(lat)%></b>,<b><%=df.format(lng)%></b>]</font></a>
                        </td>
                        
                        <td>
                            <a  onclick="javascript:openEmailPopup('<%=lat%>','<%=lng%>')"><img width="8%" src="images/icons/email.png"/></a>
                        </td>
                        
                    </tr>
                    <%
                            }
                        }
                    %>
                </tbody>
            </table>
                
                
        </form>
               
    </body>
</html>
