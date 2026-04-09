<%@page import="com.maintenance.common.Tools"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.tracker.db_access.ProjectMgr, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.common.ParseSideMenu"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    metaMgr.setMetaData("xfile.jar");
    metaMgr.closeDataSource();

    String encryptedUserName = (String) request.getParameter("userName");
    String userName = (encryptedUserName != null) ? Tools.getRealChar(encryptedUserName) : "";

    String passWord = "";
    ApplicationSessionRegistery.AuthenticationType authentication = (ApplicationSessionRegistery.AuthenticationType) request.getAttribute("authentication");
    String message = null;
    if (ApplicationSessionRegistery.AuthenticationType.InvalidUserOrPassword.equals(authentication)) {
        message = "خطاء فى اسم المستخدم او كلمة المرور";
    } else if (ApplicationSessionRegistery.AuthenticationType.ExistsAnotherUser.equals(authentication)) {
        message = "يوجد مستخدم حاليا قد تم تسجيل الدخول من هذا المتصفح";
    } else if (ApplicationSessionRegistery.AuthenticationType.SessionsLimits.equals(authentication)) {
        message = "يوجد عدد مستخدمين الان اكثر من المسموح به";
    }

    String companyName = metaMgr.getCompanyNameForLogo();
    String logoName = "logo.png";
    if (companyName != null) {
        logoName = "logo-" + companyName + ".png";
    }
%>
<html lang="en-US">
    <head>
        <TITLE> CRM System</TITLE>
        <META HTTP-EQUIV="Content-Type" CONTENT="text/html  charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=8">
        <link rel="stylesheet"  href="css/loginStyle.css" />
        <link rel="stylesheet"  href="css/loginStyle2.css" />
        <link rel="stylesheet"  href="css/message-boxs/box.css" />
        <link rel="stylesheet"  href="css/animate.css" />
        <link rel="Shortcut Icon" href="images/short_cut_icon.png" />
        <%--<script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>--%>
        <script  src="jquery-ui/jquery_2.1.3.js"></script>

    </head>
    <style type="text/css">
        body{
            background:url('images/11.jpg') center fixed;
            background-repeat: no-repeat;
            background-position: center;
            font-family: 'Oleo Script', cursive;
            direction: rtl;
            -webkit-background-size: cover;
            -moz-background-size: cover;
            -o-background-size: cover;
            background-size: cover;
            overflow: hidden;
        }
        .lg-container{
            width:300px;
            margin:100px auto;
            padding:20px 40px;
            border:1px solid #f4f4f4;
            /*background:rgba(255,255,255,1);*/
            background:-webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(0,0,0,0.65)), color-stop(100%,rgba(0,0,0,0.8)));
            -webkit-border-radius:10px;
            -moz-border-radius:10px;
            border-radius:10px;
            -webkit-box-shadow: 0 0 2px #aaa;
            -moz-box-shadow: 0 0 2px #aaa;
            box-shadow: 0 0 2px #aaa;
        }
        .lg-container h1{
            font-size:40px;
            text-align:center;
        }
        #lg-form > div {
            margin:10px 5px;
            padding:5px 0;
            text-align: center;
        }
        #lg-form label{
            display: none;
            font-size: 20px;
            line-height: 25px;
        }
        #lg-form input[type="text"],
        #lg-form input[type="password"]{
            /* -webkit-border-radius:10px;
             -moz-border-radius:10px;*/
            font-size: 16px;
            line-height: 20px;
            width: 50%;
            background-color: red important;
            font-family: 'Oleo Script', cursive;
            text-align:center;
        }

        #lg-form input[type="text"]:focus {
            background-color: white;
            width: 80%;
            color: #50a3a2;
        }

        #lg-form input[type="password"]:focus {
            background-color: white;
            width: 80%;
            color: #50a3a2;
        }

        #lg-form div:nth-child(3) {
            text-align:center;
        }
        #lg-form button{
            font-family: 'Oleo Script', cursive;
            font-size: 18px;
            border:1px solid #000;
            padding:5px 10px;
            border:1px solid rgba(51,51,51,.5);
            -webkit-border-radius:10px;
            -moz-border-radius:10px;
            border-radius:10px;
            -webkit-box-shadow: 2px 1px 1px #aaa;
            -moz-box-shadow: 2px 1px 1px #aaa;
            box-shadow: 2px 1px 1px #aaa;
            cursor:pointer;
        }
        #lg-form button:active{
            -webkit-box-shadow: 0px 0px 1px #aaa;
            -moz-box-shadow: 0px 0px 1px #aaa;
            box-shadow: 0px 0px 1px #aaa;
        }
        #lg-form button:hover{
            background:#f4f4f4;
        }
        #message{width:100%;text-align:center}
        .success {
            color: green;
        }
        .error {
            color: red;
        }
        @font-face {
            font-family: 'Oleo Script';
            font-style: normal;
            font-weight: 400;
            src: local('Oleo Script'), local('OleoScript-Regular'), url('css/oleo.woff') format('woff');
        }
        .imageSTYLE{
            width: 200px;
            height: 35px;
            margin-top: 210px;
            margin-right: 20px;
            background-color: rgba(255, 255, 255, 0.50);
            padding: 6px 6px 6px 6px;
        }
    </style>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        $(function () {
            $("#passwordWrite").keyup(function () {
                $("#message").html("");
            });
        });

        function Validate() {
            getUserName();
            getPassword();
            document.frm_My_Form.submit();
        }

        function getUserName() {
            var name = document.getElementById('userNameWrite').value;
            var res = "";
            for (i = 0; i < name.length; i++) {
                res += name.charCodeAt(i) + ',';
            }
            res = res.substr(0, res.length - 1);

            document.getElementById('userName').value = res;
        }

        function getPassword() {
            var passwordWrite = document.getElementById('passwordWrite').value;
            var res = "";
            for (i = 0; i < passwordWrite.length; i++) {
                res += passwordWrite.charCodeAt(i) + ',';
            }
            res = res.substr(0, res.length - 1);

            document.getElementById('password').value = res;
        }
        $("#login").click(function (event) {
            event.preventDefault();

            $('form').fadeOut(500);
            $('.wrapper').addClass('form-success');
        });

    </SCRIPT>
    <script type="text/javascript">
        window.location.hash = "no-back-button";
        window.location.hash = "Again-No-back-button";//again because google chrome don't insert first hash into history
        window.onhashchange = function () {
            window.location.hash = "4S";
        }
    </script> 
    <body ONLOAD="document.frm_My_Form.userNameWrite.focus();" >
        <div  style="float: right">
            <img src="images/oracle.png" class="animated fadeInRight imageSTYLE" />
        </div>

        <div class="container">
            <center>
                <div class="wrapper" align="center" style="margin-top: 8%;">  
                    <div style="margin-right: auto;margin-left: auto;text-align: center; margin-top: 25px;">
                        <center>
                            <img src="images/<%=logoName%>" />
                        </center>
                    </div>
                    <form class="form" NAME="frm_My_Form" id="lg-form" onsubmit="JavaScript: Validate()" ACTION="TrackerLoginServlet" METHOD="post">
                        <%if (message != null) {%>
                        <div class="alert-box error"><span>خطاء: </span><%=message%></div>
                        <% }%>
                        <div >
                            <label for="userNameWrite" >إسم المستخدم :</label>
                            <input type="hidden" name="userName" id="userName" value="" />     
                            <input type="text"  name="userNameWrite" id="userNameWrite" placeholder="إسم المستخدم" onChange="getUserName();" value="<%=userName%>"/>
                        </div>
                        <div>
                            <label for="passwordWrite" >الرقم السرى :</label>
                            <input type="hidden" name="password" id="password" value="" />     
                            <input type="password"  name="passwordWrite" id="passwordWrite" placeholder="الرقم السرى" onChange="getPassword();" value="<%=passWord%>"/>
                        </div>
                        <div>
                            <button type="submit" id="login" style="">login</button>
                        </div>
                    </form>
                </div>
            </center>
            <ul class="bg-bubbles">
                <li></li>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
                <li></li>
            </ul>
        </div>
    </body>
</html>
