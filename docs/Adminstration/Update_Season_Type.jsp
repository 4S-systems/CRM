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
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    WebBusinessObject wboSeason=(WebBusinessObject)request.getAttribute("wboSeason");
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>new Client</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="autosuggest.css">
        <script type="text/javascript" src="js/jquery.min.js"></script>
      </HEAD>

    <SCRIPT  TYPE="text/javascript">

function submitForm()
        {
            if (!validateData("req", this.SEASON_FORM.code, "Please, enter Season Number.") ){
                this.SEASON_FORM.code.focus();
            }
            else if (!validateData("req", this.SEASON_FORM.englishName, "Please, enter English Name.") || !validateData("minlength=3", this.SEASON_FORM.englishName, "Please, enter a valid English Name.")){
                this.SEASON_FORM.englishName.focus();
            }
            else if (!validateData("req", this.SEASON_FORM.arabicName, "Please, enter Arabic Name.") || !validateData("minlength=3", this.SEASON_FORM.arabicName, "Please, enter a valid Arabic Name.")){
                this.SEASON_FORM.arabicName.focus();
            }
            else{
                document.SEASON_FORM.action = "<%=context%>/SeasonServlet?op=updateSeason";
                document.SEASON_FORM.submit();
                }
        }
 
     function cancelForm()
        {


        document.SEASON_FORM.action = "<%=context%>/SeasonServlet?op=listSeasons";
        document.SEASON_FORM.submit();
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
 <FORM NAME="SEASON_FORM" METHOD="POST">
        <TABLE style="width:60% ">
                 <TR>
                    <TD style="width: 10%;; border: none">
                             <IMG class="img" style="cursor: pointer" width="50%" VALIGN="BOTTOM" onclick="JavaScript: cancelForm();" SRC="images/buttons/backBut.png" > 
                          
                    </TD>
                   <TD style="width: 50%; border: none">
                        <fieldset class="set" align="center"  >
            <legend  dir=<fmt:message key="direction" /> align="center" >
                <table dir=<fmt:message key="direction" /> align="center" >
                    <tr>

                        <td class="td">
                            <font color="blue" size="6">
                            <fmt:message key="updatetittle" />
                            </font>

                        </td>
                    </tr>
                </table>
                            
            </legend>
            <%
            if(null!=status) {
        if(status.equalsIgnoreCase("ok")){
            %>
                <table align="center"  dir=<fmt:message key="direction" />>
                    <tr>
                        <td class="td">
                            <font size=4 color="black">
                            
                            <fmt:message key="supdate_Status" />
                            </font>
                        </td>
                </tr> </table>
            <%
            }else{%>
                <table align="center" dir=<fmt:message key="direction" />>
                    <tr>
                        <td class="td">
                            <font size=4 color="red" >
                            <fmt:message key="fupdate_Status" />
                            </font>
                        </td>
                </tr> </table>
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
                        <input  type="TEXT" style="width:230px" name="code" ID="code" size="33" value="<%=wboSeason.getAttribute("type_code")%>" maxlength="255" autocomplete="off" >
                        <input  type="hidden" style="width:230px" name="seasonTypeId" ID="seasonTypeId" size="33" value="<%=wboSeason.getAttribute("id")%>" maxlength="255" autocomplete="off" >
                    </TD>
                </TR>
                <TR>
                    <TD STYLE="text-align: <fmt:message key="textalign" />" class='td'>
                        <LABEL FOR="address">
                            <p><b>
                                    <fmt:message key="english_name" /> 
                                    <font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="text-align: <fmt:message key="textalign" />" class='td'>
                        <input type="TEXT" style="width:230px" name="arabic_name" ID="arabicName" size="33" value="<%=wboSeason.getAttribute("arabicName")%>" maxlength="255">
                    </TD>
                </TR>
                <TR>
                    <TD STYLE="text-align: <fmt:message key="textalign" />" class='td'>
                        <LABEL FOR="supplierName">
                            <p><b>
                                    <fmt:message key="arabic_name" /> 
                                    <font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="text-align: <fmt:message key="textalign" />" class='td'>
                        <input  type="TEXT" style="width:230px" name="english_name" ID="englishName" size="33" value="<%=wboSeason.getAttribute("englishName")%>" maxlength="255">
                    </TD>
                </TR>
                <TR>
                    <TD STYLE="text-align: <fmt:message key="textalign" />" class='td'>
                        <p><b><fmt:message key="display" /></b>&nbsp;
                    </TD>
                    <TD STYLE="text-align: <fmt:message key="textalign" />"class='td'>
                        <input type="checkbox" name="display" ID="display" value="1" <%="1".equals(wboSeason.getAttribute("display")) ? "checked" : ""%>/>
                    </TD>
                </TR>
            </TABLE>
                    <br>
                     <DIV align="center" STYLE="color:blue;">
             <button  onclick="JavaScript:  submitForm();" class="button">
                <fmt:message key="update" />
                <IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV>
                   <br>
            </FIELDSET>
                    </TD>
                 </TR>
                </TABLE>
            
        </FORM>
    </BODY>
</HTML>
