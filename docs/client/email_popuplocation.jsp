<%-- 
    Document   : email_popuplocation
    Created on : Jan 20, 2021, 5:42:02 AM
    Author     : mariam
--%>
<%@page import="com.clients.db_access.ClientMgr"%>
<%@page import="com.silkworm.business_objects.secure_menu.MenuElement"%>
<%@page import="com.silkworm.business_objects.secure_menu.OneDimensionMenu"%>
<%@page import="com.silkworm.business_objects.secure_menu.TwoDimensionMenu"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,java.util.regex.Matcher,java.util.regex.Pattern,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>

    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        

        String stat = (String) request.getSession().getAttribute("currentMode");
        WebBusinessObject loggedUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String usrEmail=(String) loggedUser.getAttribute("email");
        String clientId = request.getAttribute("clientID") != null ? (String) request.getAttribute("clientID") : "";
        String lat=(String) request.getAttribute("lat");
        String lng=(String) request.getAttribute("lng");
        ClientMgr clientMgr=ClientMgr.getInstance();
        String clientName=clientMgr.getByKeyColumnValue("key",clientId,"key5");
        String clientEmail=clientMgr.getByKeyColumnValue("key",clientId,"key12");
       String dir, align, to, title, attachFile, body, unit, none, from, direction, title1,successMsg,failMsg;
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
            
    }


    %>
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/tr/xhtml1/DTD/xhtml1-transitional.dtd"> 
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
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
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script> 
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>
    
        <script type="text/javascript">
        
        function sendMailByAjax2() {
            alert("in");
                $("#emailStatus").html("");
                alert("form before");
                var formData = new FormData($("#emailForm")[0]);
                alert("form");
                formData.append("to", $("#subject2").val());
                formData.append("title", $("#subject").val());
                formData.append("subject", $("#subject2").val());
                formData.append("counter", $("#emailCounter").val());
                formData.append("message", $("#mailBody").val());
                alert("before ajax");
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

        </script>
    </head>
    <body>
        <div id="sendEmailDiv" style="background-color: white;border:5px solid black;">
                    
                        
           <form id="emailForm" action="<%=context%>/EmailServlet?op=sendByAjaxClient" method="post" enctype="multipart/form-data">
            <table class="table" style="width:580px; direction: <%=dir%>">
                <tr style="padding-bottom: 5px;">
                    <td style="font-size: 16px;font-weight: bold;"><%=from%></td>

                    <td style="text-align: <%=align%>; border: none; width: 25%;">
                        <input type="radio" value="<%=metaMgr.getEmailAddress()%>" id="from" name="from" style="width: 5%;" onclick="getpassword('comEmail');" checked/> <%=metaMgr.getEmailAddress()%> 
                    </td>

                    </tr>
                <tr>
                    <td style="font-size: 16px;font-weight: bold;"><%=to%></td>
                    <td style="width: 80%; text-align: <%=align%>;" colspan="2">
                        <%=clientName!=null&&!clientName.equalsIgnoreCase("null")? clientName : ""%>
                        
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 16px; font-weight: bold;" nowrap><%=title1%></td>
                    <td style=" text-align: <%=align%>;" colspan="2">
                        <input type="text" size="60" maxlength="60" id="subject" name="subject" style="width: 100%;" value=""/>
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 16px; font-weight: bold;" nowrap><%=title%></td>
                    <td style=" text-align: <%=align%>;" colspan="2">
                        <input type="text" size="60" maxlength="60" id="subject2" name="subject2" style="width: 100%;" value="<%=clientEmail!=null&&!clientEmail.equalsIgnoreCase("null")? clientEmail : ""%>"/>
                    </td>
                </tr>
                <tr>
                    <td style="font-size: 16px; font-weight: bold;" nowrap><%=body%>
                        <input id="emailCounter" value="0" type="hidden" name="counter"/></td>
                    <td style="width: 60%; text-align: <%=align%>;" colspan="2">
                        <textarea  placeholder="<%=body%>" name="mailBody" id="mailBody" style="height: 150px; width: 100%;" class="editor">
                        link to location: https://www.google.com.eg/maps/place/<%=lat%>,<%=lng%>
                        </textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div style="width: 30%;text-align: center;margin-left: auto;margin-right: auto;" id="emailStatus"></div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <input id="sendMail" type="button" value="send mail" onclick="javascript:sendMailByAjax2()"/>
                    </td>
                </tr>
            </table>
        </form>
       
                </div>
    </body>
</html>
