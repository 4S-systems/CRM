

<%@page import="com.planning.db_access.SeasonMgr"%>
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
        WebBusinessObject wboSeason = (WebBusinessObject) request.getAttribute("wboSeason");
        ArrayList<WebBusinessObject> seasonsList = (ArrayList<WebBusinessObject>) request.getAttribute("seasonsList");
        SeasonMgr seasonMgr=SeasonMgr.getInstance();
        String isForever =null;
        if(wboSeason!=null) {isForever= (String) wboSeason.getAttribute("isForever");}
        if (isForever == null) {
            isForever = "";
        }
          
          

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

        function submitForm()
        {

            document.SEASON_FORM.action = "<%=context%>/SeasonServlet?op=ExcuteUpdateRecordSeason";
            document.SEASON_FORM.submit();

        }

        function cancelForm()
        {


            document.SEASON_FORM.action = "<%=context%>/SeasonServlet?op=listRecordSeasons";
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
                           <fieldset align=center class="set"  >
            <legend   align="center">
                     <font color="blue" size="4">
                     <fmt:message key="updaterecordtittle"/>
                                </font>
 
                </legend>
                <%
                    if (null != status) {
                        if (status.equalsIgnoreCase("ok")) {
                %>
                <table align="center" dir=<fmt:message key="direction" />>
                    <tr>
                        <td class="td">
                            <font size=4 color="black">
                            
                            <fmt:message key="supdate_Status"/>
                            </font>
                        </td>
                    </tr> </table>
                <%
            } else {%>
                <table align="center" dir=<fmt:message key="direction" />>
                    <tr>
                        <td class="td">
                            <font size=4 color="red" >
                                <fmt:message key="fupdate_Status"/>
                            </font>
                        </td>
                    </tr> </table>
                <%}
                    }

                %>

            
                <TABLE align="center" dir=<fmt:message key="direction" /> CELLPADDING="0" CELLSPACING="0" BORDER="0" id="MainTable">


                    <TR>
                        <TD STYLE="text-align : <fmt:message key="textalign"/>" class='td'>
                            <LABEL FOR="supplierNO2">
                                <p><b>
                                        <fmt:message key="channel"/>
                                        <font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD  STYLE="text-align : <fmt:message key="textalign"/>"class='td' id="CellData">
                            <!--<input  type="TEXT" style="width:230px" name="code" ID="code" size="33" value="<%=wboSeason.getAttribute("record_code")%>" maxlength="255" autocomplete="off" >-->
                            <%  String chID="";
                                WebBusinessObject chWbo= seasonMgr.getOnSingleKey("key1", (String)wboSeason.getAttribute("record_code"));
                                if(chWbo!=null){
                                    chID=(String)chWbo.getAttribute("id"); 
                                }
                            %>
                            <select name="ChanelID" id="ChanelID" style="font-weight: bold; font-size: 16px; width: 230px; direction: rtl;">
                                             <%
                                                for (WebBusinessObject seasonWbo : seasonsList) {
                                            %>
                                            <option value="<%=seasonWbo.getAttribute("id")%>" <%if(chID.equals(seasonWbo.getAttribute("id"))){%> selected="true" <% }%> ><%=seasonWbo.getAttribute("arabicName")%></option>
                                            <%
                                                }
                                            %>

                                        </select>
                            <input  type="hidden" style="width:230px" name="id" ID="id" size="33" value="<%=wboSeason.getAttribute("id")%>" maxlength="255" autocomplete="off" >
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="text-align : <fmt:message key="textalign"/>" class='td'>
                            <LABEL FOR="address">
                                <p><b>   <fmt:message key="arabic_name"/>
                                        <font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="text-align : <fmt:message key="textalign"/>" class='td'>
                            <input type="TEXT" style="width:230px" name="arabic_name" ID="arabic_name" size="33" value="<%=wboSeason.getAttribute("arabicName")%>" maxlength="255">
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="text-align : <fmt:message key="textalign"/>" class='td'>
                            <LABEL FOR="supplierName">
                                <p><b> 
                                    <fmt:message key="forever"/>
                                    </b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="text-align : <fmt:message key="textalign"/>"class='td'>
                            <input type="checkbox" id="forever" name="forever" value="1"
                                   <%=isForever.equals("1")?"checked":""%>/>
                        </TD>
                    </TR>
                </TABLE>
                        <br>
                         <DIV align="center" STYLE="color:blue;">
                 <button  onclick="JavaScript:  submitForm();" class="button">
                    <fmt:message key="update"/>
                    <IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV>
                    <br>
            </fieldset>
                        
                        
                    </TD>
                 </TR>
                     </TABLE>
         
                </FORM>
                </BODY>
                </HTML>
