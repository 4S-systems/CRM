<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>.<c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Campaigns.Campaigns"  />
    <%
        String status = (String) request.getAttribute("Status");
       System.out.println("status");
       System.out.println(status);
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        WebBusinessObject wboSeason = (WebBusinessObject) request.getAttribute("wboSeason");
         %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>new Client</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="autosuggest.css">
        <script type="text/javascript" src="js/jquery.min.js"></script>
        <script type="text/javascript" src="js/jquery.calendars.js"></script>
        <script type="text/javascript" src="js/jquery.calendars.plus.js"></script>
        <link  rel="stylesheet" type="text/css" href="js/jquery.calendars.picker.css"/>
        <script type="text/javascript" src="js/jquery.calendars.picker.js"></script>
        <script type="text/javascript">
            $(document).ready(function() {
                $(".calendar").calendarsPicker();
            });

        </script>

    </HEAD>

    <SCRIPT  TYPE="text/javascript">



        function IsNumeric(sText)

        {
            var ValidChars = "0123456789.";
            var IsNumber = true;
            var Char;


            for (i = 0; i < sText.length && IsNumber == true; i++)
            {
                Char = sText.charAt(i);
                if (ValidChars.indexOf(Char) == -1)
                {
                    var TCode = document.getElementById('code').value;

                    if (/[^a-zA-Z0-9]/.test(TCode)) {
                        alert('Input is not alphanumeric');
                        return false;
                    }
                }
                else {
                    alert("The code is either alphanumeric or alphabetical");
                    break;
                }
            }
            return IsNumber;

        }

        function checkEmail(email) {
            if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)) {
                return (true)
            }
            return (false)
        }

        function clearValue(no) {
            document.getElementById('Quantity' + no).value = '0';
            total();
        }

        function cancelForm()
        {


            document.SEASON_FORM.action = "<%=context%>/SeasonServlet?op=listSeasons";
            document.SEASON_FORM.submit();
        }
    </SCRIPT>
     <BODY>




        <FORM NAME="SEASON_FORM" METHOD="POST">

            <TABLE style="width:60% ">
                
                <TR>
                    <TD style="width: 10%;; border: none">
                        <IMG class="img" style="cursor: pointer" width="50%" VALIGN="BOTTOM" onclick="JavaScript: cancelForm();" SRC="images/buttons/backBut.png" > 
                          
                    </TD>
                    <TD style="width: 50%; border: none">
                             <fieldset class="set" align="center" style="margin-top: 20px">
                <legend  dir=<fmt:message key="direction" /> align="center">
                       <font color="blue" size="6">
                                <fmt:message key="pagetitle" />
                                </font>
 
                </legend>
                <%
                    if (null != status) {
                        if (status.equalsIgnoreCase("ok")) {
                %>
            <table align="center" dir=<fmt:message key="direction" />>
                    <tr>
                        <td class="td">
                            <font size=4 color="black"> <fmt:message key="success_Status" /> </font>
                        </td>
                    </tr> 
            </table>
                </tr>
                <%
                } else {%>
                <tr>
                <table align="center" dir=<fmt:message key="direction" />>
                    <tr>
                        <td class="td">
                            <font size=4 color="red" ><fmt:message key="fail_Status" /></font>
                        </td>
                    </tr> </table>
                </tr>
                <%}
                    }

                %>
 
                <TABLE align="center" dir=<fmt:message key="direction" /> CELLPADDING="0" CELLSPACING="0" BORDER="0" id="MainTable">


                    <TR>
                        <TD STYLE="text-align: <fmt:message key="textalign" />" class='td'>
                            <LABEL FOR="supplierNO2">
                                <p><b>
                                        <fmt:message key="camp_code" />
                                        <font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD  STYLE="text-align: <fmt:message key="textalign" />" class='td' id="CellData">
                            <input readonly type="TEXT" style="width:230px" name="code" ID="code" size="33" value="<%=wboSeason.getAttribute("type_code")%>" maxlength="255" autocomplete="off" >
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="text-align: <fmt:message key="textalign" />" class='td'>
                            <LABEL FOR="address">
                                <p><b>
                                         <fmt:message key="arabic_name" />
                                         <font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="text-align: <fmt:message key="textalign" />" class='td'>
                            <input readonly type="TEXT" style="width:230px" name="arabic_name" ID="arabicName" size="33" value="<%=wboSeason.getAttribute("arabicName")%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="text-align: <fmt:message key="textalign" />" class='td'>
                            <LABEL FOR="supplierName">
                                <p><b>
                                        <fmt:message key="english_name" />
                                        <font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="text-align: <fmt:message key="textalign" />" class='td'>
                            <input readonly type="TEXT" style="width:230px" name="english_name" ID="englishName" size="33" value="<%=wboSeason.getAttribute("englishName")%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="text-align: <fmt:message key="textalign" />" class='td'>
                            <p><b><fmt:message key="display" /></b>&nbsp;
                        </TD>
                        <TD STYLE="text-align: <fmt:message key="textalign" />"class='td'>
                            <%if("1".equals(wboSeason.getAttribute("display"))){%> <fmt:message key="yes" /> <%} else {%><fmt:message key="no" /><%}%>
                        </TD>
                    </TR>
                </TABLE>
                    </FIELDSET>
                    </TD>
                </TR>
            </TABLE>
          
               
        </FORM>
    </BODY>
</HTML>
