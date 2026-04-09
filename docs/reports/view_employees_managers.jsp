<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.silkworm.persistence.relational.*"%>
<%@ page import="com.silkworm.common.TimeServices, java.lang.Math"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<HTML>
    <%
        List<Map.Entry<String, List<String>>> data = (List<Map.Entry<String, List<String>>>) request.getAttribute("data");

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String stat = (String) request.getSession().getAttribute("currentMode");;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Equipment Statistics</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <!-- prefix free to deal with vendor prefixes -->
        <script type="text/javascript" src="js/prefixfree-1.0.7.js"></script>
        <!-- jQuery -->
        <script type="text/javascript" src="js/jquery-1.7.1.min.js"></script>

        <style>
            /*Basic reset*/
            * {margin: 0; padding: 0;}

            body {
                /*background: #4EB889;*/
                font-family: Nunito, arial, verdana;
            }
            #accordian {
                background: #FFFFFF;
                width: 40%;
                margin: 0 auto 0 auto;
                color: black;
                /*Some cool shadow and glow effect*/
                box-shadow: 
                    0 5px 15px 1px rgba(0, 0, 0, 0.6), 
                    0 0 200px 1px rgba(255, 255, 255, 0.5);
            }
            /*heading styles*/
            #accordian h3 {
                text-align: center;
                font-size: 16px;
                line-height: 34px;
                padding: 0 10px;
                cursor: pointer;
                /*fallback for browsers not supporting gradients*/
                background: #E6E6FA;
                background: linear-gradient(#bbcad0, #E8E8E8);
            }
            /*heading hover effect*/
            #accordian h3:hover {
                text-shadow: 0 0 1px rgba(255, 255, 255, 0.7);
            }
            /*iconfont styles*/
            #accordian h3 span {
                font-size: 16px;
                margin-right: 10px;
            }
            /*list items*/
            #accordian li {
                list-style-type: none;
            }
            /*links*/
            #accordian ul ul li a {
                text-align: right;
                color: black;
                text-decoration: none;
                font-size: 11px;
                line-height: 27px;
                display: block;
                padding: 0 15px;
                /*transition for smooth hover animation*/
                transition: all 0.15s;
            }
            /*hover effect on links*/
            #accordian ul ul li a:hover {
                background: #E8E8E8;
                border-right: 5px solid lightgreen;
            }
            /*Lets hide the non active LIs by default*/
            #accordian ul ul {
                display: none;
            }
            #accordian li.active ul {
                display: block;
            }
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
                line-height: 40px;
            }
        </style>
    </HEAD>         
    <BODY>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <FORM name="Stat" action="post">
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            </DIV>  
            <br><br>
            <FIELDSET align=center class="set" style="width: 90%">
                <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <tr>
                        <td width="100%" class="titlebar">
                            <font color="#005599" size="4">عرض الموظفين بالنسبة للأدارات</font>
                        </td>
                    </tr>
                </table>
                <br />
                <div id="accordian">
                    <ul>
                        <%
                            List<String> employees;
                            String clazz = "active";
                            String department;
                            for (Map.Entry<String, List<String>> entry : data) {
                                department = entry.getKey();
                                employees = entry.getValue();
                        %>
                        <li class="<%=clazz%>">
                            <h3><span class="icon-tasks"></span> إدارة: <%=department%></h3>
                            <ul>
                                <% if (!employees.isEmpty()) { %>
                                <% for (String employee : employees) {%>
                                <li><a href="#"><%=employee%></a></li>
                                <li><HR></li>
                                    <% } %>
                                    <% } else { %>
                                <li><a href="#" style="color: red">لايوجد موظفين فى هذه الأدارة</a></li>
                                    <% } %>
                            </ul>
                        </li>
                        <%
                                clazz = "";
                            }
                        %>
                    </ul>
                </div>
                <br/>
            </FIELDSET>
        </FORM>
    </BODY>

    <script>
        /*jQuery time*/
        $(document).ready(function() {
            $("#accordian h3").click(function() {
                //slide up all the link lists
                $("#accordian ul ul").slideUp();
                //slide down the link list below the h3 clicked - only if its closed
                if (!$(this).next().is(":visible"))
                {
                    $(this).next().slideDown();
                }
            })
        })
    </script>
</HTML>     
