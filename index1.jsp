<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.tracker.db_access.ProjectMgr, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.common.ParseSideMenu"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
    //open Jar File
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    metaMgr.setMetaData("xfile.jar");
    ParseSideMenu parseSideMenu = new ParseSideMenu();
    Hashtable logos = new Hashtable();
    logos = parseSideMenu.getCompanyLogo("configration" + metaMgr.getCompanyName() + ".xml");
    Hashtable siteData = parseSideMenu.getSiteData("configration" + metaMgr.getCompanyName() + ".xml");
    metaMgr.closeDataSource();
    ProjectMgr projectMgr = null;
    projectMgr = ProjectMgr.getInstance();

    // try {
    //    projectMgr = ProjectMgr.getInstance();
    // } catch (java.lang.NullPointerException np) {
    //      System.out.println("Null Pointer Exception  ");
    //  }
%>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function Validate() {
        getUserName();
        getPassword();
        document.frm_My_Form.submit();
    }

    function getUserName() {
        var name = document.getElementById('userNameWrite').value
        var res = ""
        for (i=0;i < name.length; i++) {
            res += name.charCodeAt(i) + ',';
        }
        res = res.substr(0, res.length - 1);

        document.getElementById('userName').value = res;
    }

    function getPassword() {
        var password = document.getElementById('passwordWrite').value
        var res = ""
        for (i=0;i < password.length; i++) {
            res += password.charCodeAt(i) + ',';
        }
        res = res.substr(0, res.length - 1);

        document.getElementById('password').value = res;
    }

</SCRIPT>

<HTML>
    <HEAD>
        <META HTTP-EQUIV="Content-Type" CONTENT="text/html  charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=8">
        <TITLE> CRM System</TITLE>
        <link rel="Shortcut Icon" href="images/short_cut_icon.png" />
        <script type="text/javascript" src="jquery-ui/jquery-1.7.1.js"></script>
        <STYLE type="text/css" >

            html,body{			   
                height:100%;
                margin: 0px;
                padding: 0px
            } .TD {
                border: none;
            }

            .tableright {
                text-align:center;
            }

            .error {
                color:red;
                font-weight:bold;
            }
            .button
            {
                /*background:#808000;*/
                /*background:#006699;*/
                /*background:#3b5998;*/
                font-size: 15px;
                color:#003366;
                background-image:url(images/buttonbg.jpg);
                background-repeat: repeat-x;
                background-position: bottom;
                background-color: #BACBDB;  
                border: 1px solid #3C5983;
                border-radius:10px;
                font-family: "Times New Roman", Times, serif;

                font-weight: bold;
                width: 12%;
                height: .8cm;
                /*background-attachment: scroll;
                border-style:groove;
                border-width: thin;*/
            } 
            #FF input[type="text"]
            {
                /*background:#808000;*/
                /*background:#006699;*/
                /*background:#3b5998;*/
                font-size: 16px;
                color:#003366;   
                height: 20px;
                padding: 5px;
                width: 200px;
                background-image:url(images/buttonbg.jpg);
                vertical-align: middle;
                background-color:#e7f7fb;  
                border: 1px solid #3C5983;
                border-radius:10px;
                font-family: "Times New Roman", Times, serif;
                font-weight: bold;

                /*background-attachment: scroll;
                border-style:groove;
                border-width: thin;*/
            }
            #FF input[type="password"]
            {
                /*background:#808000;*/
                /*background:#006699;*/
                /*background:#3b5998;*/
                font-size: 16px;
                color:#003366;   
                height: 20px;
                padding: 5px;
                width: 200px;
                background-image:url(images/buttonbg.jpg);
                vertical-align: middle;
                background-color:#e7f7fb;  
                border: 1px solid #3C5983;
                border-radius:10px;
                font-family: "Times New Roman", Times, serif;
                font-weight: bold;

                /*background-attachment: scroll;
                border-style:groove;
                border-width: thin;*/
            }
            #FF input:focus{
                /*background:#808000;*/
                /*background:#006699;*/
                /*background:#3b5998;*/
                font-size: 16px;
                color:#003366;   
                height: 20px;
                padding: 5px;
                width: 200px;
                vertical-align: middle;
                background-color: #C1D2EE;  
                border: 1px solid #0066cc;
                border-radius:10px;
                font-family: "Times New Roman", Times, serif;
                font-weight: bold;

                /*background-attachment: scroll;
                border-style:groove;
                border-width: thin;*/
            }
            .fontl{ 
                font-size: 20px;
                color:#003366;font-weight: bold;
            }
            #loginBtn {
                width:50px;
                height:50px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                border: none;
                background-position: right top ;
                display: inline-block;
                background-color: transparent;
                background-image:url(images/icons/login3.png);
            }

        </STYLE>

    </HEAD>
    <script type="text/javascript">
        window.location.hash="no-back-button";
        window.location.hash="Again-No-back-button";//again because google chrome don't insert first hash into history
        window.onhashchange=function(){window.location.hash="4S";}
    </script> 


    <!--  <SCRIPT type="text/javascript">    
                 window.history.forward();
                 function noBack() { 
                      window.history.forward(); 
                 }
            </SCRIPT>-->


    <BODY ONLOAD="document.frm_My_Form.userNameWrite.focus();" >
        <CENTER style="height:100%; margin: 0px;padding:0px;">
            <TABLE width="100%" height="90%" border="0" cellpadding="20" dir="rtl" >
                <TR>
                    <TD  width="60%" height="100%"   valign="middle">

                        <FORM NAME="frm_My_Form" id="FF" onsubmit="JavaScript: Validate()" ACTION="TrackerLoginServlet" METHOD="post">
                            <!--style="background-image:url(images/header.jpg); background-repeat:no-repeat; width:700px;height:385px; " -->
                            <table  width="608" border="0" align="center" cellpadding="0" cellspacing="0"  DIR="RTL" >
                                <TR>
                                    <TD><IMG src="images/header1.png" height="204px" width="534px"></TD>
                                </TR> 
                                <TR>
                                    <TD><IMG src="images/title2.jpg" height="50px" width="430`px" style="margin-top: 20px;"></TD>
                                </TR> 
                                <!--                                <TR>
                                                                    <TD height="115" ALIGN="CENTER" valign="middle" style="border: none;">&nbsp;</TD>
                                                                </TR>-->
                                <TR>
                                    <TD WIDTH="100%"   ALIGN="center" valign="middle">


                                        <TABLE WIDTH="607" border="0"  ALIGN="Center" cellspacing="11">
                                            <TR>
                                                <TD height="" colspan="2" ALIGN="Center"   style="text-align: center">
                                                    <%
                                                        String isValid = (String) request.getAttribute("loginResult");
                                                        System.out.println("0000 " + isValid);
                                                        if (isValid != null && isValid.equals("invalid")) {
                                                    %>
                                                    <FONT color = 'red' SIZE="+1">&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1582;&#1575;&#1591;&#1574;&#1607;</FONT>
                                                    <% }%>
                                                </TD>
                                            </TR>
                                            <TR>
                                                <TD  class="fontl"align="left" > اسم المستخدم </TD>
                                                <TD align="right" ><input type="hidden" name="userName" id="userName" value="">                                                     
                                                    <input type="TEXT" name="userNameWrite" class="inputlogin" id="userNameWrite" onChange="getUserName();" value=""></TD>
                                            </TR>
                                            <TR>
                                                <TD width="31%" height="24" class="fontl" align="left" >كلمة المرور</TD>
                                                <TD align="right" ><input type="hidden" name="password" id="password" value="">                                            
                                                    <input type="PASSWORD" name="passwordWrite" class="inputlogin"id="passwordWrite" onChange="getPassword();" value=""></TD>
                                            </TR>

                                            <!--                                            <TR>
                                                                                            <TD height="26" colspan="2">            <% if (siteData.get("userType").toString().equalsIgnoreCase("multi")) {%>
                                                                                                <LABEL FOR="project_Name">
                                                                                                    <b> &#1575;&#1604;&#1605;&#1608;&#1602;&#1593; </b>
                                                                                                </LABEL>
                                                                                                <SELECT name="projectID">
                                            <sw:WBOOptionList wboList='<%=projectMgr.getCashedTableAsBusObjects()%>' displayAttribute="projectName" valueAttribute="projectID" scrollTo = ""/>
                                        </SELECT>
                                            <% }%> </TD>
                                        </TR>-->


                                        </TABLE>

                                    </TD>
                                </TR>
                                <TR>
                                    <TD ALIGN="center" valign="middle"><input type="submit" id="loginBtn" value=""/></TD>
                                </TR>

                            </TABLE>


                        </FORM>

                    </TD>
                </TR>
            </TABLE>
        </CENTER>

    </BODY>
</HTML>