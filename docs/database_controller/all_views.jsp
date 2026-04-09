<%@page import="com.DatabaseController.db_access.DatabaseControllerMgr"%>
<%@page import="com.silkworm.system_events.WebAppStartupEvent"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*,com.tracker.business_objects.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>

    <%
        Vector<WebBusinessObject> summary = (Vector<WebBusinessObject>) request.getAttribute("summary");
        String imageSuccess = "images/ok_white.png";
        String imageFail = "images/cancel_white.png";
        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, viewName, viewStatus, valid, inValid, decription;
        //  if(stat.equals("En")){

        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        viewName = "Name";
        viewStatus = "Status";
        valid = "Valid";
        inValid = "In Valid";
        decription = "Decription";
        //  }else{
//
        //    align="center";
        //    dir="RTL";
        //  style="text-align:Right";
        //    lang="English";
        //    langCode="En";
        //   shift="&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607;";
        //     trade="&#1606;&#1608;&#1593; &#1575;&#1605;&#1585; &#1575;&#1604;&#1593;&#1605;&#1604;";
        // }
%>

    <script type="text/javascript" language="JAVASCRIPT">
        function submitForm(){
            ISSUE_CUSTOMIZATION_FORM.action = "CustomizationServlet?op=saveIssueForm";
            ISSUE_CUSTOMIZATION_FORM.submit();
        }
    </script>

    <style type="text/css" >
        .hideStyle{
            visibility:hidden
        }
        .borderStyle{
            border-bottom:black solid 1px;
            border-left-width:0px;
            border-right-width:0px;
            border-top-width:0px
        }
        .odd { 
        }
        .even {
            background-color: #E6E6FA;
        }
    </style>

    <script src='ChangeLang.js' type='text/javascript'></script>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Customize-Issue</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <BODY STYLE="background-color:#F5F5F5">
        <FORM action=""  NAME="ISSUE_CUSTOMIZATION_FORM" METHOD="POST">
            <CENTER>
                <FIELDSET class="set" style="width:99.5%;border-color: #006699;" >
                    <table class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <font color="#F3D596" size="4">Views Report</font>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="rtl" align="<%=align%>" width="99%">
                        <TR>
                            <TD width="5%" class='td' BGCOLOR="#696565" STYLE="text-align: center;color:white;font-weight:bold;font-style:oblique;font-size:18px; text-align: left; padding-left: 10px">
                                <%=viewStatus%>
                            </TD>
                            <TD width="64%" class='td' STYLE="text-align: center;height:30px;color:white;font-weight:bold;font-style:oblique;font-size:18px; text-align: left; padding-left: 10px" BGCOLOR="#696565">
                                <%=decription%>
                            </TD>
                            <TD width="22%" class='td' STYLE="text-align: center;height:30px;color:white;font-weight:bold;font-style:oblique;font-size:18px; text-align: left; padding-left: 10px" BGCOLOR="#696565">
                                <%=viewName%>
                            </TD>
                            <TD width="4%" class='td' STYLE="text-align: center;height:30px;color:white;font-weight:bold;font-style:oblique;font-size:18px; text-align: left; padding-left: 10px" BGCOLOR="#696565">
                                #
                            </TD>
                        </TR>
                        <%
                            int index = 0;
                            String className, imageSrc;
                            String font, fontName, message;
                            for (WebBusinessObject wbo : summary) {
                                index++;
                                message = (String) wbo.getAttribute("message");
                                if ("Success".equalsIgnoreCase(message) || "Valid".equalsIgnoreCase(message)) {
                                    font = "black";
                                    fontName = "blue";
                                    imageSrc = imageSuccess;
                                } else {
                                    font = "red";
                                    fontName = font;
                                    imageSrc = imageFail;
                                }

                                if (index % 2 == 0) {
                                    className = "even";
                                } else {
                                    className = "odd";
                                }
                                
                                if (message.equalsIgnoreCase("") || message.equalsIgnoreCase("***")) {
                                    message = "<font color=silver>No Description</font>";
                                }
                        %>
                        <TR STYLE="padding-top:5px;padding-bottom:3px; cursor: pointer" class="<%=className%>" onmouseover="this.className='transportRowHilight'" onmouseout="this.className='<%=className%>'">
                            <TD class='borderStyle' STYLE="color:<%=font%>;text-align:center;font-weight:bold;font-size:12px">
                                <img src="<%=imageSrc%>" alt="<%=imageSrc%>" align="middle"/>
                            </TD>
                            <TD class='borderStyle' title="<%=wbo.getAttribute(DatabaseControllerMgr.ATTRIBUTE_VIEWS_XML_DECRIPTION_AR)%>" dir="ltr" STYLE="color:<%=font%>;font-weight:bold;font-size:12px; text-align: left; padding-left: 10px">
                                <%=message%>
                            </TD>
                            <TD class='borderStyle' STYLE="color:<%=fontName%>;font-weight:bold;font-size:12px; text-align: left; padding-left: 10px">
                                <%=wbo.getAttribute("viewQuary")%>
                            </TD>
                            <TD class='borderStyle' STYLE="color:<%=font%>;font-weight:bold;font-size:12px; text-align: left; padding-left: 10px">
                                <%=wbo.getAttribute(DatabaseControllerMgr.ATTRIBUTE_VIEWS_XML_VIEW_INDEX)%>
                            </TD>
                        </TR>
                        <% }%>
                    </TABLE>
                    <br>
                    <br>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>
