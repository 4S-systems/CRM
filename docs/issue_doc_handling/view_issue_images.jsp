<%@ page import="com.docviewer.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.db_access.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>

    <%
        response.addHeader("Pragma", "No-cache");
        response.addHeader("Cache-Control", "no-cache");
        response.addDateHeader("Expires", 1);
        Vector imagePath = (Vector) request.getAttribute("imagePath");

        String businessID = "";
        String businessIdByDate = "";
        WebBusinessObject issue = (WebBusinessObject) request.getAttribute("issue");
        if (issue != null) {
            businessID = (String) issue.getAttribute("businessID");
            businessIdByDate = (String) issue.getAttribute("businessIDbyDate");
        }

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String sView, close, title, noAttachedImages;
        if (cMode.equals("En")) {

            align = "center";
            dir = "LTR";
            sView = "View";
            close = "Close";
            title = "Images Relating to Follow-Up No.";
            noAttachedImages = "No Attached Images";
        } else {
            align = "center";
            dir = "RTL";
            sView = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
            close = "&#1573;&#1594;&#1604;&#1575;&#1602;";
            title = "\u0627\u0644\u0631\u0633\u0648\u0645\u0627\u062a \u0627\u0644\u0645\u062a\u0639\u0644\u0642\u0629 \u0628\u0631\u0642\u0645 \u0627\u0644\u0645\u062a\u0627\u0628\u0639\u0629 ";
            noAttachedImages = "\u0644\u0627\u064a\u0648\u062c\u062f \u0631\u0633\u0648\u0645\u0627\u062a \u0645\u0631\u0641\u0642\u0629";
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
        </style>
    </HEAD>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <DIV align="left" STYLE="color:blue;">

            <button onclick="javascript:window.close();" class="button"><%=close%> </button>

        </DIV> 

        <br><br>
        <fieldset align=center class="set">
            <legend align="center">

                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>

                        <td class="td">
                            <font color="blue" size="6">
                                <font color="blue" size="6"><%=title%> <font color="red"><%=businessID%></font>/<%=businessIdByDate%>
                                </font>
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
            <br>
            <% if (imagePath.size() > 0) {
            %>
            <div class="image_carousel">
                <div id="foo">

                    <%for (int i = 0; i < imagePath.size(); i++) {%>
                    <img src="<%=imagePath.get(i)%>" width="600" height="600"/>
                    <%}%>
                </div>
                <div class="clearfix"></div>
                <a class="prev" id="foo_prev" href="#"><span>Previous</span></a>
                <a class="next" id="foo_next" href="#"><span>Next</span></a>
            </div>
            <% } else {
            %>
            <b style="font-size: large; color: red;">
                <%=noAttachedImages%>
            </b>
            <%}%>
            <br>
        </fieldset>
    </BODY>
</HTML>     
