<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*,com.tracker.business_objects.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <%
        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String lang, langCode;
        String title;
        String splash;
        String logo;
        String systemImages, companyInfo;
        String companyConfigButton, enName, arName;
        if (stat.equals("En")) {
            align = "right";
            dir = "LTR";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            title = "Application Configuration";
            splash = "Main Photo";
            logo = "Logo";
            langCode = "Ar";
            companyInfo = "Company Information";
            systemImages = "System Images";
            companyConfigButton = "Save";
            enName = "English Name";
            arName = "Arabic Name";
        } else {
            align = "left";
            dir = "RTL";
            lang = "English";
            title = "&#1578;&#1603;&#1608;&#1610;&#1606; &#1575;&#1604;&#1578;&#1591;&#1576;&#1610;&#1602;";
            splash = "&#1575;&#1604;&#1589;&#1608;&#1585;&#1577; &#1575;&#1604;&#1585;&#1574;&#1610;&#1587;&#1610;&#1577;";
            logo = "&#1575;&#1604;&#1588;&#1593;&#1575;&#1585;";
            langCode = "En";
            systemImages = "&#1589;&#1608;&#1585; &#1575;&#1604;&#1578;&#1591;&#1576;&#1610;&#1602;";
            companyInfo = "&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1575;&#1604;&#1588;&#1585;&#1603;&#1577;";
            companyConfigButton = "&#1581;&#1601;&#1592;";
            enName = "&#1575;&#1604;&#1571;&#1587;&#1605; &#1576;&#1575;&#1604;&#1571;&#1606;&#1580;&#1604;&#1610;&#1586;&#1610;&#1577;";
            arName = "&#1575;&#1604;&#1571;&#1587;&#1605; &#1576;&#1575;&#1604;&#1593;&#1585;&#1576;&#1610;&#1577;";
        }
        WebBusinessObject companyConfig = (WebBusinessObject) request.getAttribute("companyConfig");
    %>
    <style type="text/css">
        .mainHeaderNormal {
            background-color: #E6E6FA;
        }
    </style>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
    <META HTTP-EQUIV="Expires" CONTENT="0"/>

    <HEAD>
        <TITLE>Application Configuration</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"/>
        <script type="text/javascript">
            function changeDisplay(id){
                var object = document.getElementById(id);
                if(object.style.display == 'none'){
                    object.style.display = 'block';
                }
                else
                {
                    object.style.display = 'none';
                }
            }
            function validateImages()
            {
                var logo = document.getElementById('logo');
                var splash = document.getElementById('splash');
                var logoExt = getFileExt(logo.value)
                var splashExt = getFileExt(splash.value);
                if(logoExt != 'jpg' && logoExt !='noFile'){
                    alert('image must be .jpg');
                    return false;
                }
                else if(splashExt != 'jpg' && splashExt !='noFile'){
                    alert('image must be .jpg');
                    return false;
                }
                else if(splashExt =='noFile' && logoExt == 'noFile'){
                    alert('select file first');
                    return false;
                }
                else{
                    return true;
                }
            }
            function getFileExt(file){
                if(file.length > 0){
                    var fileExtPos = file.lastIndexOf('.');
                    var fileExt = file.substr(fileExtPos + 1);
                    return fileExt;
                }else{
                    return 'noFile';
                }
            }
        </script>
    </HEAD>

    <body STYLE="background-color:#F5F5F5">
        <div style="padding-left:5%;margin-bottom: 10px;" >
            <input type="button" style="font-size:15px;color:white;font-weight:bold"  value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button"/>
        </div>
        <fieldset align="center" class="set" dir="<%=dir%>" style="width:90%;border-color: #006699" >
            <table class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                <tr>
                    <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                        <font color="#F3D596" size="4"><%=title%></font>
                    </td>
                </tr>
            </table>
            <br/>
            <br/>
            <div style="margin-bottom: 0px;padding-right: 5px;padding-left: 5px;">
                <img style="cursor: pointer;" src="images/arrow_down_white.png" onclick="changeDisplay('companyInfo')"/>
                <b><%=companyInfo%></b>
            </div>
            <hr/>
            <form name="COMPANY_CONFIG" method="post" action="ApplicationConfigurationServlet?op=saveCompanyConfig">
                <table id="companyInfo" align="center" width="50%" style="display: none">
                    <tr>
                        <td BGCOLOR="#bbc4d0" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="30%">
                            <font size=3 color="black"><%=arName%></font>
                        </td>
                        <td bgcolor="#e8e8e8" STYLE="border-left-WIDTH:1px;border-right-width: 1px;text-align:center;padding:5px" WIDTH="70%">
                            <input type="text" value="<%=companyConfig.getAttribute("arName")%>" name="companyNameAR" dir="RTL" style="width: 90%;" />
                        </td>
                    </tr>
                    <tr>
                        <td BGCOLOR="#bbc4d0" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="30%">
                            <font size=3 color="black"><%=enName%></font>
                        </td>
                        <td bgcolor="#e8e8e8" STYLE="border-left-WIDTH:1px;border-right-width: 1px;text-align:center;padding:5px" WIDTH="70%">
                            <input type="text" value="<%=companyConfig.getAttribute("enName")%>" name="companyNameEN" dir="LTR" style="width: 90%;" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: <%=align%>;padding-top: 5px;border-left-WIDTH:0px;border-right-width: 0px;border-bottom-width: 0px;">
                            <button class="button" type="submit"><%=companyConfigButton%></button>
                        </td>
                    </tr>
                </table>
            </form>
            <div style="margin-bottom: 0px;padding-right: 5px;padding-left: 5px;">
                <img style="cursor: pointer;" src="images/arrow_down_white.png" onclick="changeDisplay('systemImages')"/>
                <b><%=systemImages%></b>
            </div>
            <hr/>
            <form name="SYSTEM_IMAGES" method="post" enctype="multipart/form-data" action="ApplicationConfigurationServlet?op=saveSystemImages" onsubmit="return validateImages()">
                <table id="systemImages" align="center" width="50%" style="display: none">
                    <tr>
                        <td BGCOLOR="#bbc4d0" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="30%">
                            <font size=3 color="black"><%=logo%></font>
                        </td>
                        <td bgcolor="#e8e8e8" STYLE="border-left-WIDTH:1px;border-right-width: 1px;text-align:center;padding:5px" WIDTH="70%">
                            <input type="file" id="logo" name="logo" style="width: 90%;" />
                        </td>
                    </tr>
                    <tr>
                        <td BGCOLOR="#bbc4d0" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="30%">
                            <font size=3 color="black"><%=splash%></font>
                        </td>
                        <td bgcolor="#e8e8e8" STYLE="border-left-WIDTH:1px;border-right-width: 1px;text-align:center;padding:5px" WIDTH="70%">
                            <input type="file" id="splash" name="splash" style="width: 90%;" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: <%=align%>;padding-top: 5px;border-left-WIDTH:0px;border-right-width: 0px;border-bottom-width: 0px;">
                            <button class="button" type="submit"><%=companyConfigButton%></button>
                        </td>
                    </tr>
                </table>
            </form>
        </fieldset>
    </body>
</HTML>
