<%@ page import="com.docviewer.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<HTML>

    <%
        response.addHeader("Pragma", "No-cache");
        response.addHeader("Cache-Control", "no-cache");
        response.addDateHeader("Expires", 1);

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String equipmentID = (String) request.getAttribute("equipmentID");
        Vector imagePath = (Vector) request.getAttribute("imagePath");
        ArrayList<String> imageWidth = (ArrayList<String>) request.getAttribute("imageWidth");
        ArrayList<String> imageHeight = (ArrayList<String>) request.getAttribute("imageHeight");

        String emailTitle = (String) request.getAttribute("emailTitle");
        String emailBody = (String) request.getAttribute("emailBody");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, sView, cancel, close;
        if (cMode.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            sView = "View";
            cancel = "Back";
            close = "Close";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            sView = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
            cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; ";
            close = "&#1573;&#1594;&#1604;&#1575;&#1602;";
        }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - Document Details</TITLE>
        <script type="text/javascript" src="js/jquery-1.9.0.min.js"></script>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script type="text/javascript" src="js/jquery.carouFredSel-6.2.0.js"></script>
        <script type="text/javascript" src="js/jquery.transit.min.js"></script>
        <script type="text/javascript" src="js/jquery.mousewheel.min.js"></script>
        <script type="text/javascript" src="treemenu/script/contextmenu.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>

        <script>
            $(function() {

                $("#foo").carouFredSel({
                    auto: false,
                    transition: true,
                    mousewheel: true,
                    prev: "#foo_prev",
                    next: "#foo_next"
                });

            });
            $(document).ready(function() {
                $('.imageClass').contextMenu('conMenu', {
                    bindings: {
                        'email': function(t) {
                            popupEmail($(t).attr('src'));
                        },
                        'emailAll': function(t) {
                            popupEmailAllImages();
                        }
                    },
                    itemStyle: {
                        width: '98%',
                        backgroundColor: '#C8C8C8',
                        color: 'black',
                        border: 'none',
                        padding: '1px'
                    },
                    itemHoverStyle: {
                        color: 'white',
                        backgroundColor: '#66CCFF',
                        border: 'none'
                    }
                });
            });
            function popupEmail(src) {
                $("#imageSrc").val(src);
                $("#clientName").html("");
                $("#emailTo").val("");
                $("#clientNo").val("");
                $("#subject").val("<%=emailTitle%>");
                $("#msgContent").val("<%=emailBody%>");
                $("#progressx").hide();
                divID = "email_content";
                $('#email_content').css("display", "block");
                $('#email_content').bPopup();
            }
            function popupEmailAllImages() {
                var src = '';
                $('.imageClass').each(function (index, obj) {
                    src += ',' + $(obj).attr('src');
                });
                if (src !== '') {
                    src = src.substring(1, src.length);
                }
                $("#imageSrc").val(src);
                $("#clientName").html("");
                $("#emailTo").val("");
                $("#clientNo").val("");
                $("#subject").val("<%=emailTitle%>");
                $("#msgContent").val("<%=emailBody%>");
                $("#progressx").hide();
                $("#sendEmailBtn").show();
                divID = "email_content";
                $('#email_content').css("display", "block");
                $('#email_content').bPopup();
            }
            var divID;
            function closePopup(formID) {
                $("#" + formID).bPopup().close();
            }
            function closeOverlay() {
                $("#" + divID).hide();
                $("#overlay").hide();
            }
            function centerDiv(div) {
                $("#" + div).css("position", "fixed");
                $("#" + div).css("top", Math.max(0, (($(window).height() - $("#" + div).outerHeight()) / 2) +
                        $(window).scrollTop()) + "px");
                $("#" + div).css("left", Math.max(0, (($(window).width() - $("#" + div).outerWidth()) / 2) +
                        $(window).scrollLeft()) + "px");
            }
            $(function() {
                centerDiv("email_content");
            });
            function getClient() {
                var clientNo = $("#clientNo").val();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/ClientServlet?op=getClientNameByNo",
                    data: {
                        clientNumber: clientNo
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'Ok') {
                            $("#clientName").html(info.name);
                            $("#emailTo").val(info.email);
                            $("#errorMsgSell").html("");
                        } else {
                            $("#errorMsgSell").html("هذا الرقم غير صحيح");
                            $("#clientName").html("");
                            $("#emailTo").val("");
                        }
                    }
                });

            }
            function sendEmail() {
                var email = $("#emailTo").val();
                var imageSrc = $("#imageSrc").val();
                var subject = $("#subject").val();
                var body = $("#msgContent").val();
                $("#sendbtn").hide();
                $.ajax({
                    type: "post",
                    url: "<%=context%>/EmailServlet?op=sendImageMailByAjax",
                    data: {
                        email: email,
                        imageSrc: imageSrc,
                        subject: subject,
                        body: body
                    },
                    success: function(jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'ok') {
                            alert("تم أرسال الرسالة");
                            closePopup("email_content");
                            $("#sendbtn").show();
                        } else {
                            alert("خطأ في أرسال الرسالة");
                            closePopup("email_content");
                            $("#sendbtn").show();
                        }
                    }
                });
                return false;
            }
        </script>

        <style type="text/css">

            .image_carousel {
                padding: 15px 0 15px 40px;
                width: 800px;
                height: 1400px;
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
            .remove{
                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);
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
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function cancelForm()
        {
            window.location = "<%=context%>/UnitDocReaderServlet?op=ViewImages&equipmentID=<%=equipmentID%>";
                }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <div class="contextMenu" id="conMenu">
            <ul>
                <li id="email"> Email ... </li>
                <li id="emailAll"> Email All ... </li>
            </ul>
        </div>
        <div id="overlay" class="overlayClass" onclick="JavaScript: closeOverlay();">

        </div>
        <div id="email_content"  style="width: 400px;display: none;position: absolute;margin-left: auto;margin-right: auto; top: 100px; z-index: 1000;">
            <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -40px;">
                <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                     -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                     box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                     -webkit-border-radius: 20px;
                     -moz-border-radius: 20px;
                     border-radius: 20px;" onclick="closePopup('email_content')"/>
            </div>
            <div class="login" style="width: 90%;text-align: center">
                <form id="myForm" method="post">
                    <table class="table " style="width:100%;">
                        <tr >
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">رقم العميل</td>
                            <td style="text-align:right;width: 70%;">
                                <input id="clientNo" type="text" onkeyup="getClient(this)"></b>
                                <div style="color: red;width: 80px;"><b  id="errorMsgSell"></b></div>
                                <input type="hidden" id="imageSrc"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">إسم العميل</td>
                            <td style="text-align:right;width: 70%;">
                                <b id="clientName" />
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">إلى</td>
                            <td style="text-align:right;width: 70%;">
                                <input type="email" size="25" maxlength="60" id="emailTo" />
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;" >الموضوع</td>
                            <td style="text-align:right;width: 70%;">
                                <input type="text" size="25" maxlength="60" id="subject" name="subject" class="login-input"/>
                            </td>
                        </tr>
                        <tr>
                            <td style="color:#f1f1f1; font-size: 16px;font-weight: bold;width: 30%;">نص الرسالة</td>
                            <td  style="text-align:right;width: 70%;">
                                <textarea placeholder="محتوى الرسالة" rows="10" cols="24" name="message"  id="msgContent"class="login-input" style="height: 100px;"></textarea>
                            </td>
                        </tr> 
                    </table>
                    <div style="width: 30%;text-align: center;margin-left: auto;margin-right: auto;" id="status"></div>
                    <div id="message" style="margin-left: auto;margin-right: auto;text-align: center"></div>
                    <input type="button" id="sendbtn" value="إرسال"  class="login-submit" style="margin-left: auto;margin-right: auto;text-align: center" onclick="sendEmail(this)" />
                </form>
                <div id="progressx" style="display: none;">
                    <img src="images/Loading2.gif" width="32px" height="32px;" style="background-repeat: no-repeat;margin-left: auto;margin-right: auto"/>
                </div>
            </div>
        </div>
        <DIV align="left" STYLE="color:blue;">

            <button onclick="javascript:window.close();" class="button"><%=close%> </button>

        </DIV> 

        <br><br>
        <fieldset align=center class="set">
            <legend align="center">

                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>

                        <td class="td">
                            <font color="blue" size="6"><%=sView%> <%=request.getAttribute("projectName") != null ? "صور " + request.getAttribute("projectName") : ""%>
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
            <br>
            <%
                if (imagePath.size() == 0) {
            %>
            <b style="font-size: large; color: red;">لا يوجد صور لعرضها</b>
            <%
                }
            %>
            <div class="image_carousel">
                <div id="foo">

                    <%for (int i = 0; i < imagePath.size(); i++) {%>
                    <img src="<%=imagePath.get(i)%>"class="imageClass" height="<%=imageHeight.get(i)%>" width="<%=imageWidth.get(i)%>"/>
                    <%}%>
                </div>
                <div class="clearfix"></div>
                <a class="prev" id="foo_prev" href="#"><span>prev</span></a>
                <a class="next" id="foo_next" href="#"><span>next</span></a>
            </div>
            <br>
        </fieldset>
    </BODY>
</HTML>     
