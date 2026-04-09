<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,java.text.*,com.docviewer.db_access.*, com.maintenance.db_access.*,com.maintenance.common.ParseSideMenu"%>
<%@ page contentType="text/HTML; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    HttpSession s = request.getSession();
    WebBusinessObject waUser = (WebBusinessObject) s.getAttribute("loggedUser");
    String loggedUser = (String) waUser.getAttribute("userId");

    //get logged user data
    UserMgr userMgr = UserMgr.getInstance();
    WebBusinessObject userWbo = userMgr.getOnSingleKey(loggedUser);
    String userName = userWbo.getAttribute("userName").toString();

    //get project Wbo
    WebBusinessObject project = (WebBusinessObject) request.getAttribute("project");
    String projectCode = project.getAttribute("projectName").toString();

    String stat = (String) request.getSession().getAttribute("currentMode");
    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode, title;
    String cancel_button_label;
    if (stat.equals("En")) {
        align = "center";
        dir = "Ltr";
        style = "text-align:left";
        lang = "عربي";
        langCode = "Ar";
        title = "Initial Reservation";
        cancel_button_label = "Cancel";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        title = "حجزمبدئي";
        cancel_button_label = "إنهاء";
    }
%>

<html>
    <head>
        <title>Unit Reservation Details</title>
        <link rel="stylesheet" href="css/demo_table.css">    
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jquery-1.9.0.min.js"></script>
        <script type="text/javascript" src="js/jquery.carouFredSel-6.2.0.js"></script>
        <script type="text/javascript" src="js/jquery.transit.min.js"></script>
        <script type="text/javascript" src="js/jquery.mousewheel.min.js"></script>
    </head>

    <script type="text/javascript">
        function cancelForm()
        {
            window.close();
        }

        function getClient() {
            alert($('#client_code').text);
        }
    </script>

    <style type="text/css">
        .titlebar {
            background-image: url(images/title_bar.png);
            background-position-x: 50%;
            background-position-y: 50%;
            background-size: initial;
            background-repeat-x: repeat;
            background-repeat-y: no-repeat;
            background-attachment: initial;
            background-origin: initial;
            background-clip: initial;
            background-color: rgb(204, 204, 204);
        }

        .image_carousel {
            padding: 15px 0 15px 40px;
            width: 100%;
            height: 100%;
            position: relative;
        }
        .image_carousel img {
            border: 1px solid #ccc;
            background-color: white;
            padding: 9px;
            margin: 7px;
            display: block;
            float: left;
        }
        a.prev, a.next {
            background: url(images/miscellaneous_sprite.png) no-repeat transparent;
            width: 45px;
            height: 50px;
            display: block;
            position: absolute;
            top: -40px;
        }
        a.prev {			
            left: 15px;
            background-position: 0 0; }
        a.prev:hover {		background-position: 0 -50px; }
        a.next {			right: -30px;
                   background-position: -50px 0; }
        a.next:hover {		background-position: -50px -50px; }

        a.prev span, a.next span {
            display: none;
        }
        .clearfix {
            float: none;
            clear: both;
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
        .table td{
            padding:5px;
            text-align:center;
            font-family:Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight: bold;
            border: none;
            margin-bottom: 30px;
        }
        .smallDialog {
            width: 320px;
            display: none;
            position: fixed;
            z-index: 1000;
        }
        .overlayClass {
            width: 100%;
            height: 100%;
            display: none;
            background-color: rgb(0, 85, 153);
            opacity: 0.4;
            z-index: 500;
            top: 0px;
            left: 0px;
            position: fixed;
        }
    </style>

    <body>
        <FORM NAME="UNIT_FORM" id="new_location_type_Form" METHOD="POST">
            <DIV align="left" STYLE="color:blue; margin-left: 30px">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript: createPDF();" class="button"> حجز مبدئي <IMG VALIGN="BOTTOM"   SRC="images/pdf.gif"> </button>
            </DIV>

            <br/>
            <br/>

            <fieldset class="set" style="border-color: #006699; width: 95%; min-height: 400px;">
                <TABLE class="backgroundTable" width="50%" CELLPADDING="0" CELLSPACING="8" ALIGN="CENTER" DIR="<%=dir%>">
                    <TR>
                        <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD" colspan="2"><FONT color='white' SIZE="+1"> <%=title%> </FONT><BR></TD>
                    </TR>

                    <tr>
                        <TD style="<%=style%>; text-align:center; border:1px" class="backgroundHeader" id="CellData"><b style="margin-left: 5px;padding-left: 5px;font-weight: bold">مسؤل المبعات  </b></td>
                        <TD style=" background-color: white">
                            <%=userName%>
                        </td>
                    </tr>
                    <tr>
                        <TD style="<%=style%>; text-align:center; border:1px" class="backgroundHeader" id="CellData"><b style="margin-left: 5px;padding-left: 5px;font-weight: bold">كود الوحدة </b></td>
                        <TD style=" background-color: white">
                            <%=projectCode%>
                        </td>
                    </tr>
                    <tr>
                        <TD style="<%=style%>; text-align:center; border:1px" class="backgroundHeader" id="CellData"><b style="margin-left: 5px;padding-left: 5px;font-weight: bold">رقم العميل </b></td>
                        <TD style=" background-color: white">
                            <input style="width:100%;font-size:14px;font-weight: bold" type="TEXT" dir="<%=dir%>" name="client_code" ID="client_code" size="20" value="" maxlength="20" onchange="this.getClient()">                   
                        </td>
                    </tr>
                    <tr>
                        <TD style="<%=style%>; text-align:center; border:1px" class="backgroundHeader" id="CellData"><b style="margin-left: 5px;padding-left: 5px;font-weight: bold">اسم العميل</b></td>
                        <td id="client_name">

                        </td>
                    </tr>
                    <tr>
                        <TD style="<%=style%>; text-align:center; border:1px" class="backgroundHeader" id="CellData"><b style="margin-left: 5px;padding-left: 5px;font-weight: bold">مبلغ الحجز</b></td>
                        <td style="width: 50%;">
                            <input style="width:100%;font-size:14px;font-weight: bold" type="TEXT" dir="<%=dir%>" name="reserve_budget" ID="client_code" size="20" value="" maxlength="20">                   
                        </td>
                    </tr>
                    <tr>
                        <TD style="<%=style%>; text-align:center; border:1px" class="backgroundHeader" id="CellData"><b style="margin-left: 5px;padding-left: 5px;font-weight: bold">مدةالحجز بالساعة</b></td>
                        <td style="width: 50%;">
                            <input style="width:100%;font-size:14px;font-weight: bold" type="TEXT" dir="<%=dir%>" name="reserve_hours" ID="client_code" size="20" value="" maxlength="20">                   
                        </td>
                    </tr>
                </table>
            </fieldset>
        </FORM>
    </body>
</html>