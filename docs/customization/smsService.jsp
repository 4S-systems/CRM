<%-- 
    Document   : smsService
    Created on : Apr 11, 2019, 2:22:52 PM
    Author     : walid
--%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.crm.db_access.EmployeesLoadsMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
         String state = (String) request.getSession().getAttribute("currentMode");
            String align = null;
            String dir = null;
            String title,tryit,visitProvider ;
            if (state.equals("En")) {
                align = "center";
                dir = "LTR";
                title="SMS Service";
                tryit="Send Sms ";
                visitProvider="Visit Provider Site";
            } else {
                align = "center";
                dir = "RTL";
                title="خدمة الرسائل القصيرة";
                tryit="ارسل رسالة ";
                visitProvider="زيارة موقع مزود الخدمة";
            }
    %>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <script type="text/javascript">
     
    </script>
    <style>
        label{
            font: Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight:bold;
            color:#005599;
            margin-right: 5px;
        }
        #row:hover{
            background-color: #EEEEEE;
        }
        .client_btn {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/addclient.png);
        }
        .company_btn {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/addCompany.png);
        }
        .enter_call {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/Number.png);
        }
        .login {
            direction: rtl;
            margin: 20px auto;
            padding: 10px 5px;
            background: #3f65b7;
            background-clip: padding-box;
            border: 1px solid #ffffff;
            border-bottom-color: #ffffff;
            border-radius: 5px;
            color: #ffffff;

            background: #7abcff; /* Old browsers */
            background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
            background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
            background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
            background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
            background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
            background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
            filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
        }
        .remove{
            width:20px;
            height:20px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            background-image:url(images/icons/icon-32-remove.png);
        }
        .toolBox {
            width:40px;
            height: 40px;
            float:right;
            margin: 0px;
            padding: 0px;
        }

        .toolBox a img {
            width: 40px important;
            height: 40px important;
            float: right;
            margin: 0px;
            padding: 0px;
            text-align: right;
        }
        .button2{
            font-family: "Script MT", cursive;
            font-size: 18px;
            font-style: normal;
            font-variant: normal;
            font-weight: 400;
            line-height: 20px;
            color: black;
            width: 134px;
            height: 32px;
            text-decoration: none;
            display: inline-block;
            margin: 4px 2px;
            -webkit-transition-duration: 0.4s; /* Safari */
            transition-duration: 0.8s;
            cursor: pointer;
            border-radius: 12px;
            border: 1px solid #008CBA;
            padding-left:2%;
            text-align: center;
        }


        .button2:hover {
            background-color: #afdded;
            padding-top: 0px;
        }
        </style>
    <body>
        <form id="smsServiceF">
            <fieldset style="width:55%">
                <legend>
                    <font color="blue"  size="4" > <i><%=title%></i></font>
                </legend>
                <table dir="<%=dir%>">
                    <tr >
                        
                       
                        <td style="border: none">
                            <div class="button2">    <a href="<%=context%>/SmsSenderServlet?op=sendSmsService&send=true"  style="color: black;"><%=tryit%></a></div>
                          <br/>
                          <br/>
                          <div class="button2">   <a href="https://www.nexmo.com" style="color: black;"><%=visitProvider%></a></div>
                        </td >
                        <td style="border: none; width:30;">
                           &nbsp; 
                        </td>
                          <td style="border: none" >
                            <img src="images/smsi.png" />
                        </td>
                      
                    </tr>
                </table>
                
            </fieldset>
        </form>
    </body>
</html>
