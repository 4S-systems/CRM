<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>

<html>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align, dir, style, modelCode, modelName;
        if (stat.equals("En")) {
            align = "left";
            dir = "LTR";
            style = "text-align:left";
            modelCode = "Model Code";
            modelName = "Model Name";
        } else {
            align = "right";
            dir = "RTL";
            style = "text-align:Right";
            modelCode = "كود النموذج";
            modelName = "اسم النموذج";
        }
    %>
    <head>
        <style>
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
        </style>
    </head>
    <body>
        <form name="MODEL_FORM" id="MODEL_FORM" method="post" style="margin-left: auto; margin-right: auto; width: 95%;">
            <center>
                <table align="center" dir="<%=dir%>" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td class="silver_header td2 formInputTag boldFont" style="text-align:center; font-weight: bold; height: 25px; font-size: 16px; width: 10px; color: black;">
                            <p><b><%=modelCode%></b>
                        </td>
                        <td class="td" style="text-align: <%=align%>; border-top: 0px;">
                            <input type="text" name="modelCode" id="modelCode" value="" style="width: 150px;"/>
                            <input type="hidden" name="locationType" id="locationType" value="RES-MODEL"/>
                        </td>
                    </tr>
                    <tr>
                        <td class="silver_header td2 formInputTag boldFont" style="text-align:center; font-weight: bold; height: 25px; font-size: 16px; width: 10px; color: black;">
                            <p><b><%=modelName%></b>
                        </td>
                        <td class="td" style="text-align: <%=align%>; border-top: 0px;">
                            <input type="text" name="modelName" id="modelName" value="" style="width: 150px;"/>
                        </td>
                    </tr>
                </table>
                <br/>
            </center>
        </form>
    </body>
</html>     
