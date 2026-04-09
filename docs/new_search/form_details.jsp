<%@page import="com.silkworm.project_doc.SelfDocMgr"%>
<%@page import="com.silkworm.system_events.WebAppStartupEvent"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*,com.tracker.business_objects.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>

    <%
                Vector<WebBusinessObject> formsWbo = (Vector<WebBusinessObject>) request.getAttribute("formsWbo");
                String imageSuccess = "images/ok_white.png";
                String imageFail = "images/cancel_white.png";
                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;
                String align = null;
                String dir = null;
                String style = null;
                String lang, langCode, viewName, viewStatus, valid, inValid, decription;
                 if(stat.equals("En")){

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
                }else{
//
                    align="center";
                    dir="RTL";
                    style="text-align:Right";
                    lang="English";
                    langCode="En";
                 decription="Description";
                //     trade="&#1606;&#1608;&#1593; &#1575;&#1605;&#1585; &#1575;&#1604;&#1593;&#1605;&#1604;";
                 }
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
        <TITLE>Main_Type</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="blueStyle.css">
    </HEAD>

    <BODY STYLE="background-color:#F5F5F5">
        <FORM action=""  NAME="ISSUE_CUSTOMIZATION_FORM" METHOD="POST">
            <CENTER>
                <FIELDSET class="set" style="width:99.5%;border-color: #006699;" >
                    <table class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="border-color: #006699;background: none repeat scroll 0 0 #006699;padding: 5px;">
                        <tr>
                            <td width="100%" style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <font color="white" size="6" style="font-weight: bold;background: #006699;">Form Information</font>
                            </td>
                        </tr>
                    </table>
                    <br>
                    <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="1" style="" dir="rtl" align="center" width="99%">
                        <%
                                    int index = 0;
                                    String className, imageSrc;
                                    String font, fontName, code, descAr, descEn, nameEn, nameAr, tableRead, tableWrite, viewsRead , jspRead , query;
                                    for (WebBusinessObject wbo : formsWbo) {
                                        index++;
                                        code = (String) wbo.getAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_FORM_CODE);
                                        nameEn = (String) wbo.getAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_NAME_EN);
                                        nameAr = (String) wbo.getAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_NAME_AR);
                                        tableRead = (String) wbo.getAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_TABEL_READ);
                                        tableWrite = (String) wbo.getAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_TABLE_WRITE);
                                        viewsRead = (String) wbo.getAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_VIEWS_READ);
                                        descAr = (String) wbo.getAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_DECRIPTION_AR);
                                        descEn = (String) wbo.getAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_DECRIPTION_EN);
                                        jspRead = (String) wbo.getAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_JSP_TAG);
                                        query=(String) wbo.getAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_QUERY_STRING);

                                        String regex = "(\r\n|\n\r|\n|,)";
                                        String replacement = "</br>";

                                        descEn = descEn.replaceAll(regex, replacement);
                                        tableRead = tableRead.replaceAll(regex, replacement);
                                        tableWrite = tableWrite.replaceAll(regex, replacement);
                                        viewsRead   = viewsRead.replaceAll(regex, replacement);
                                        jspRead = jspRead.replaceAll(regex, replacement);

                                        font = "black";
                                        fontName = "blue";
                                        imageSrc = imageSuccess;

                                        descEn = (String) wbo.getAttribute(SelfDocMgr.ATTRIBUTE_FORMS_XML_DECRIPTION_EN);
                                        if(descEn.equalsIgnoreCase("") || descEn.equalsIgnoreCase(null)) {
                                           descEn = "<font color=\"silver\">No Description</font>";
                                           
                                        }
                        %>
                        <tr>
                            <TD class='borderStyle' class='td' STYLE="color:<%=font%>;font-weight:bold;font-size:12px; text-align: left; padding-left: 10px">
                                <%=code%>
                            </TD>
                            <TD width="20%" class='td' STYLE="text-align: center;height:30px;color:white;font-weight:bold;font-style:oblique;font-size:18px; text-align: left; padding-left: 10px" BGCOLOR="#696565">
                                Form Code
                            </TD>
                        </tr>
                         <tr>
                            <TD class='borderStyle' class='td' title="<%=nameAr%>" STYLE="color:<%=fontName%>;font-weight:bold;font-size:12px; text-align: left; padding-left: 10px">
                                <%=nameEn%>
                            </TD>
                            <TD width="20%" class='td' STYLE="text-align: center;height:30px;color:white;font-weight:bold;font-style:oblique;font-size:18px; text-align: left; padding-left: 10px" BGCOLOR="#696565">
                                Name
                            </TD>
                        </tr>
                        <tr>
                            <TD class='borderStyle' class='td' title="<%=descAr%>" dir="ltr" STYLE="color:<%=font%>;font-weight:bold;font-size:12px; text-align: left; padding-left: 10px">
                                <%=descEn%>
                            </TD>
                            <TD width="2%" class='td' STYLE="text-align: center;height:30px;color:white;font-weight:bold;font-style:oblique;font-size:18px; text-align: left; padding-left: 10px" BGCOLOR="#696565">
                                 <%=decription%>
                            </TD>
                        </tr>
                        <tr>
                            <TD class='borderStyle' class='td' dir="ltr" STYLE="color:<%=font%>;font-weight:bold;font-size:12px; text-align: left; padding-left: 10px">
                                <%=tableRead%>
                            </TD>
                            <TD width="2%" class='td' STYLE="text-align: center;height:30px;color:white;font-weight:bold;font-style:oblique;font-size:18px; text-align: left; padding-left: 10px" BGCOLOR="#696565">
                                Table Read
                            </TD>
                        </tr>
                        <tr>
                            <TD class='borderStyle' class='td' dir="ltr" STYLE="color:<%=font%>;font-weight:bold;font-size:12px; text-align: left; padding-left: 10px">
                                <%=tableWrite%>
                            </TD>
                            <TD width="2%" class='td' STYLE="text-align: center;height:30px;color:white;font-weight:bold;font-style:oblique;font-size:18px; text-align: left; padding-left: 10px" BGCOLOR="#696565">
                                 Table Write
                            </TD>
                        </tr>
                        <tr>
                            <TD class='borderStyle' class='td' dir="ltr" STYLE="color:<%=font%>;font-weight:bold;font-size:12px; text-align: left; padding-left: 10px">
                                <%=viewsRead%>
                            </TD>
                            <TD width="2%" class='td' STYLE="text-align: center;height:30px;color:white;font-weight:bold;font-style:oblique;font-size:18px; text-align: left; padding-left: 10px" BGCOLOR="#696565">
                                 Views Read
                            </TD>
                        </tr>
                  <tr>
                            <TD class='borderStyle' class='td' dir="ltr" STYLE="color:<%=font%>;font-weight:bold;font-size:12px; text-align: left; padding-left: 10px">
                                <%=jspRead%>
                            </TD>
                            <TD width="2%" class='td' STYLE="text-align: center;height:30px;color:white;font-weight:bold;font-style:oblique;font-size:18px; text-align: left; padding-left: 10px" BGCOLOR="#696565">
                                  Jsp Read
                            </TD>
                        </tr>
                         <tr>
                            <TD class='borderStyle' class='td' dir="ltr" STYLE="color:<%=fontName%>;font-weight:bold;font-size:12px; text-align: left; padding-left: 10px">
                                <%=query%>
                            </TD>
                            <TD width="2%" class='td' STYLE="text-align: center;height:30px;color:white;font-weight:bold;font-style:oblique;font-size:18px; text-align: left; padding-left: 10px" BGCOLOR="#696565">
                                  Query String
                            </TD>
                        </tr>

                        <% }%>
                    </TABLE>
                    <br />
                    <br />
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>
