<%@page import="com.maintenance.common.Tools"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.tracker.db_access.ProjectMgr, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.common.ParseSideMenu"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE html>
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
<html class="dark" lang="en">
    <head>
        <title>Login | 4S Systems</title>
        <meta charset="utf-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <link rel="Shortcut Icon" href="images/short_cut_icon.png" />
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&amp;family=Inter:wght@300;400;500;600&amp;display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
        <script  src="jquery-ui/jquery_2.1.3.js"></script>
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        colors: {
                            "surface-container-low": "#1a1c20",
                            "surface-container": "#1e2024",
                            "surface-container-high": "#282a2e",
                            "surface-container-highest": "#333539",
                            "surface": "#111317",
                            "outline-variant": "#494552",
                            "on-surface": "#e2e2e8",
                            "on-surface-variant": "#cbc3d4",
                            "primary": "#d4bbff",
                            "primary-container": "#7048b6",
                            "secondary": "#e9c349",
                            "error": "#ffb4ab",
                            "error-container": "#93000a",
                            "on-error-container": "#ffdad6"
                        },
                        fontFamily: {
                            headline: ["Manrope", "sans-serif"],
                            body: ["Inter", "sans-serif"]
                        }
                    }
                }
            };
        </script>

    </head>
    <style type="text/css">
        body {
            font-family: "Inter", sans-serif;
            background-color: #111317;
            margin: 0;
        }
        .font-headline {
            font-family: "Manrope", sans-serif;
        }
        .glass-card {
            background: rgba(30, 32, 36, 0.6);
            backdrop-filter: blur(24px);
            -webkit-backdrop-filter: blur(24px);
        }
        .material-symbols-outlined {
            font-variation-settings: "FILL" 0, "wght" 400, "GRAD" 0, "opsz" 24;
        }
        #lg-form input[type="text"],
        #lg-form input[type="password"] {
            margin-bottom: 0;
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
    <body ONLOAD="document.frm_My_Form.userNameWrite.focus();" class="bg-surface text-on-surface min-h-screen flex flex-col items-center justify-center relative overflow-hidden">
        <div class="absolute inset-0 z-0">
            <div class="absolute inset-0 bg-gradient-to-tr from-surface via-surface/80 to-primary-container/30 z-10"></div>
            <img class="w-full h-full object-cover grayscale opacity-40" src="images/11.jpg" alt="Background"/>
        </div>

        <main class="relative z-20 w-full max-w-[440px] px-6">
            <div class="wrapper glass-card p-10 rounded-xl shadow-[0px_20px_40px_rgba(0,0,0,0.4)] border border-outline-variant/30 text-left">
                <div class="flex flex-col items-center mb-10 text-center">
                    <div class="w-20 h-20 bg-surface-container-highest/60 rounded-xl flex items-center justify-center mb-6 shadow-lg shadow-primary/20 p-3">
                        <img src="images/<%=logoName%>" alt="Company Logo" class="max-w-full max-h-full object-contain"/>
                    </div>
                    <h1 class="font-headline text-3xl font-bold tracking-tighter text-white mb-2">4S Systems</h1>
                    <p class="text-on-surface-variant text-sm tracking-wide">Enter your credentials to access the workspace</p>
                </div>

                <form class="form space-y-6" NAME="frm_My_Form" id="lg-form" onsubmit="JavaScript: Validate()" ACTION="TrackerLoginServlet" METHOD="post">
                    <%if (message != null) {%>
                    <div class="bg-error-container/70 text-on-error-container px-4 py-3 rounded-md text-sm border border-error/30">
                        <span class="font-semibold">خطاء: </span><%=message%>
                    </div>
                    <% }%>

                    <div>
                        <label class="block text-xs font-medium text-on-surface-variant mb-1 ml-1" for="userNameWrite">إسم المستخدم</label>
                        <input type="hidden" name="userName" id="userName" value="" />
                        <div class="flex items-center bg-surface-container-highest/50 rounded-md px-4 py-3 border-b-2 border-transparent transition-all duration-300 focus-within:border-primary focus-within:bg-surface-container-highest">
                            <span class="material-symbols-outlined text-on-surface-variant mr-3 text-lg">person</span>
                            <input class="bg-transparent border-none focus:ring-0 w-full text-white placeholder:text-slate-500 font-body text-sm" type="text" name="userNameWrite" id="userNameWrite" placeholder="إسم المستخدم" onChange="getUserName();" value="<%=userName%>"/>
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-medium text-on-surface-variant mb-1 ml-1" for="passwordWrite">الرقم السرى</label>
                        <input type="hidden" name="password" id="password" value="" />
                        <div class="flex items-center bg-surface-container-highest/50 rounded-md px-4 py-3 border-b-2 border-transparent transition-all duration-300 focus-within:border-primary focus-within:bg-surface-container-highest">
                            <span class="material-symbols-outlined text-on-surface-variant mr-3 text-lg">lock</span>
                            <input class="bg-transparent border-none focus:ring-0 w-full text-white placeholder:text-slate-500 font-body text-sm" type="password" name="passwordWrite" id="passwordWrite" placeholder="الرقم السرى" onChange="getPassword();" value="<%=passWord%>"/>
                        </div>
                    </div>

                    <div>
                        <button type="submit" id="login" class="w-full bg-gradient-to-br from-primary-container to-primary text-white font-headline font-bold py-4 rounded-md shadow-lg shadow-primary/20 transform transition-all duration-300 hover:scale-[1.02] active:scale-95 focus:outline-none focus:ring-2 focus:ring-primary/50">
                            Sign In
                        </button>
                    </div>
                </form>
            </div>
        </main>
    </body>
</html>