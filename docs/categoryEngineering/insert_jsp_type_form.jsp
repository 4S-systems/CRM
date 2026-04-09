<%-- 
    Document   : insert_jsp_type_form
    Created on : Feb 29, 2012, 2:08:17 PM
    Author     : khaled abdo
--%>

<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Vector"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.international.TouristGuide"%>
<%
            TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
            MetaDataMgr metaMgr = MetaDataMgr.getInstance();
            String context = metaMgr.getContext();

            Vector categoryList = (Vector) request.getAttribute("data");
            String doubleName = (String) request.getAttribute("name");
            String status = (String) request.getAttribute("status");
            String message;

            // if re back to this page
            String typeName = (String) request.getParameter("typeName");
            if (typeName == null) {
                typeName = "";
            }
            String notes = (String) request.getParameter("notes");
            if (notes == null) {
                notes = "";
            }
            String apprivation = (String) request.getParameter("apprivation");
            if (apprivation == null) {
                apprivation = "";
            }
            String BasicCounter = (String) request.getParameter("basicCounter");
            if (BasicCounter == null) {
                BasicCounter = "";
            }
            String StandAlone = (String) request.getParameter("standAlone");
            if (StandAlone == null) {
                StandAlone = "";
            }
            String isAgroupEq = "";
            if (request.getParameter("isAgroupEq") == null) {
                isAgroupEq = "0";
            } else {
                isAgroupEq = "1";
            }

            int iTotal = 0;

            String cMode = (String) request.getSession().getAttribute("currentMode");
            String stat = cMode;
            String align = null;
            String Xalign = null;
            String dir = null;
            String style = null;
            String lang, langCode, CateName, CatDes, M1, M2, save, back, noData, newCat, catNum, Locations, Departments, Employees, Suppliers;
            String Dupname, CatApp, appriv, categName, isAgroup, standAlone, notStandAlone, typeCategory, basicCounter, sHour, sKilometer, type1, type2, show, categoryEngineeringLabel;
            if (stat.equals("En")) {
                align = "left";
                Xalign = "right";
                dir = "LTR";
                standAlone = "Tractor";
                notStandAlone = "Trailer";
                typeCategory = "Type Category";
                style = "text-align:left";
                lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                langCode = "Ar";
                CateName = tGuide.getMessage("catname");
                CatDes = tGuide.getMessage("catdescription");
                M1 = "The Saving Successed";
                M2 = "The Saving Successed Faild";
                save = "Save ";
                noData = "No Data are available for one or more of those fields:";
                newCat = "New Basic Category";
                catNum = "Categories Number";
                Locations = "Locations";
                Departments = "Departments";
                Employees = "Employees";
                Suppliers = "Suppliers";
                back = "Cancel";
                Dupname = "Name is Duplicated Change it";
                CatApp = "Engilsh Abbriviation";
                appriv = "Abbrivation";
                categName = "Name";
                isAgroup = "Equipments Compound";
                basicCounter = "Counter Unit";
                sHour = "Hour";
                sKilometer = "Kilometer";
                type1 = "";
                type2 = "";
                show = "Show Details";

                categoryEngineeringLabel = "Category Engineering";

                categoryEng = categoryEngEn;

            } else {
                align = "right";
                Xalign = "left";
                dir = "RTL";
                style = "text-align:Right";
                lang = "English";
                langCode = "En";
                M1 = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581; ";
                M2 = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
                CateName = " &#1573;&#1587;&#1605; &#1575;&#1604;&#1606;&#1600;&#1600;&#1600;&#1608;&#1593;";
                CatDes = " &#1608;&#1589;&#1601; &#1575;&#1604;&#1606;&#1600;&#1600;&#1600;&#1608;&#1593;";
                save = " &#1578;&#1587;&#1580;&#1610;&#1604; ";
                noData = "&#1604;&#1610;&#1587; &#1607;&#1606;&#1575;&#1603; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1578;&#1608;&#1601;&#1585;&#1607;&#1601;&#1610; &#1607;&#1584;&#1607; &#1575;&#1604;&#1605;&#1580;&#1575;&#1604;&#1575;&#1578;";
                newCat = "&#1606;&#1600;&#1600;&#1600;&#1600;&#1608;&#1593; &#1571;&#1587;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1575;&#1587;&#1609; &#1580;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1583;&#1610;&#1583;";
                catNum = "&#1593;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1583;&#1583; &#1575;&#1604;&#1575;&#1606;&#1600;&#1600;&#1600;&#1600;&#1608;&#1575;&#1593;";
                Locations = "&#1575;&#1604;&#1605;&#1608;&#1575;&#1602;&#1593;";
                Departments = " &#1575;&#1604;&#1575;&#1602;&#1587;&#1575;&#1605;";
                Employees = " &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;&#1610;&#1606;";
                Suppliers = "&#1575;&#1604;&#1605;&#1608;&#1585;&#1583;&#1610;&#1606;";
                back = tGuide.getMessage("cancel");
                Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
                CatApp = "&#1575;&#1604;&#1575;&#1582;&#1578;&#1589;&#1575;&#1585; &#1576;&#1575;&#1604;&#1575;&#1606;&#1580;&#1604;&#1610;&#1586;&#1609;";
                appriv = "&#1575;&#1604;&#1575;&#1582;&#1578;&#1589;&#1575;&#1585;";
                categName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1606;&#1608;&#1593;";
                isAgroup = "&#1605;&#1580;&#1605;&#1593; &#1605;&#1593;&#1583;&#1575;&#1578;";
                standAlone = "&#1602;&#1575;&#1591;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1585;&#1577;";
                notStandAlone = "&#1605;&#1602;&#1591;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1608;&#1585;&#1577;";
                typeCategory = "&#1575;&#1604;&#1578;&#1589;&#1606;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1610;&#1601; &#1575;&#1604;&#1581;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1585;&#1603;&#1609;";
                basicCounter = "&#1608;&#1581;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1583;&#1577; &#1575;&#1604;&#1593;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1583;&#1575;&#1583;";
                sHour = "&#1587;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1575;&#1593;&#1577;";
                sKilometer = "&#1603;&#1610;&#1604;&#1600;&#1600;&#1600;&#1600;&#1608;&#1605;&#1578;&#1585;";
                type1 = "&#1605;&#1593;&#1600;&#1600;&#1583;&#1577; &#1579;&#1575;&#1576;&#1578;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1577; &#1576;&#1605;&#1608;&#1578;&#1600;&#1600;&#1608;&#1585;";
                type2 = "&#1605;&#1593;&#1600;&#1600;&#1583;&#1577; &#1579;&#1575;&#1576;&#1578;&#1600;&#1600;&#1577; &#1576;&#1583;&#1608;&#1606; &#1605;&#1608;&#1578;&#1600;&#1600;&#1608;&#1585;";
                show = "&#1593;&#1585;&#1590; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";

                categoryEngineeringLabel = "التصنيف الهندسي";

                categoryEng = categoryEngAr;
            }
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>

    <BODY>
        <form name="CATEGORY_FORM" method="post" action="">
            <DIV align="left" STYLE="color:blue; padding-left: 2.5%; padding-bottom: 10px">
                <input type="button" value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button  onclick="JavaScript: cancelForm('<%=context%>/main.jsp');" class="button"><%=back%></button>
                &ensp;
                <button  onclick="JavaScript: submitForm();" class="button"><%=save%></button>
                &ensp;
                <button  class="button" onclick="getFormDetails()" ><%=show%></button>
            </DIV>
            <center>
                <fieldset class="set" style="border-color: #006699; width: 95%">
                    <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><Font color='white' SIZE="+1"><%=newCat%></Font><BR></TD>
                        </TR>
                    </table>

                    <% if (false) {%>
                    <TABLE ALIGN="<%=Xalign%>" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;vertical-align:top;">
                        <TR CLASS="head">
                            <TD class="TD" COLSPAN="4">
                                <CENTER><B><Font FACE="tahoma"><B><%=noData%>&nbsp;</B></Font></B></CENTER>
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="shaded">
                                <Font FACE="tahoma"><B><%=Locations%></B></Font><br>
                            </TD>

                            <TD CLASS="shaded">
                                <Font FACE="tahoma"><B><%=Departments%></B></Font><br>
                            </TD>

                            <TD CLASS="shaded">
                                <Font FACE="tahoma"><B><%=Employees%></B></Font><br>
                            </TD>

                            <TD CLASS="shaded">
                                <Font FACE="tahoma"><B><%=Suppliers%></B></Font><br>
                            </TD>
                        </TR>
                    </TABLE>
                    <% } else {%>
                    <TABLE ALIGN="center"  WIDTH="98%" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" style="margin-top: 10px">
                        <%
                             String color = "blue";
                             if (null != status) {
                                 if (status.equalsIgnoreCase("ok")) {
                                     message = M1;
                                 } else {
                                     message = M2;
                                     color = "red";
                                 }
                        %>
                        <TR>
                            <TD STYLE="text-align: center" colspan="2">
                                <div class="excelentCell">
                                    <B><Font color='<%=color%>' size="3"><%=message%></Font></B>
                                </div>
                            </TD>
                        </TR>
                        <% }%>
                        <%  if (null != doubleName) {%>
                        <TR>
                            <TD STYLE="text-align: center; margin-top: 5px" colspan="2">
                                <div class="excelentCell">
                                    <B><Font color='red' size="3"><%=Dupname%></Font></B>
                                </div>
                            </TD>
                        </TR>
                        <% }%>
                        <TR>
                            <TD STYLE="<%=style%>" class='TD' COLSPAN="2">
                                &nbsp;
                            </TD>
                        </TR>
                        <TR>
                            <TD class="TD" style="vertical-align:top;" WIDTH="52%">
                                <TABLE ALIGN="<%=Xalign%>"  WIDTH="100%" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="3">
                                    <TR>
                                        <TD width="35%" title="<%=CateName%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag">
                                            <%=CateName%>
                                        </TD>
                                        <TD width="65%" style="<%=style%>" class='TD' id="CellData">
                                            <input type="TEXT" name="typeName" ID="typeName" style="width:100%;"  maxlength="30" size="34" value="<%=typeName%>" maxlength="90" >
                                        </TD>
                                    </TR>

                                    <TR>
                                        <TD title="<%=CatDes%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag">
                                            <%=CatDes%>
                                        </TD>
                                        <TD style="<%=style%>" class='TD'>
                                            <TEXTAREA rows="5" name="notes" ID="notes" cols="27" style="width:100%;" ><%=notes%></TEXTAREA>
                                        </TD>
                                    </TR>

                                    <TR>
                                        <TD title="<%=CatApp%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag">
                                            <%=CatApp%>
                                        </TD>
                                        <TD style="<%=style%>" class='TD'>
                                            <input type="text" name="apprivation" id="apprivation" value="<%=apprivation%>"  style="width:100%">
                                        </TD>
                                    </TR>

                                    <TR>
                                        <TD title="<%=isAgroup%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag"><%=isAgroup%></TD>
                                        <TD style="<%=style%>" class='TD'>
                                            <input type="checkbox" id="isAgroupEq" name="isAgroupEq" <% if (isAgroupEq.equals("1")) {%> checked <% }%> value="1" />
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD title="<%=typeCategory%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag"><%=typeCategory%></TD>
                                        <TD style="<%=style%>" class="excelentCell">
                                            <div style="width:100%;font:bold;color:black;font-size:14px">
                                                <table align="center" cellpadding="0" cellspacing="0" width="100%" border="0">
                                                    <tr>
                                                        <td width="40%" style="<%=style%>;border: none; font:bold; color:black; font-size:15px">
                                                            <input type="radio"  onclick="check()" name="standAlone" value="0" checked>&ensp;<%=standAlone%><br>
                                                            <input type="radio"   onclick="check()" name="standAlone" value="1" <% if (StandAlone.equals("1")) {%> checked <% }%>>&ensp;<%=notStandAlone%><br>
                                                        </td>
                                                        <td width="60%" style="<%=style%>;border: none; font:bold; color:black; font-size:15px">
                                                            <input type="radio"  onclick="check()" name="standAlone" id="unitWith" value="2" <% if (StandAlone.equals("2")) {%> checked <% }%>>&ensp;<%=type1%><br>
                                                            <input type="radio"  onclick="check()" name="standAlone" id="unit" value="3" <% if (StandAlone.equals("3")) {%> checked <% }%>>&ensp;<%=type2%><br>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD title="<%=basicCounter%>" style="<%=style%>; font-weight: bold; font-size: 16px; color: black" class="excelentCell formInputTag"><%=basicCounter%></TD>
                                        <TD style="<%=style%>" class="excelentCell">
                                            <div style="width:95%;font:bold;color:black;font-size:14px">
                                                <table align="center" cellpadding="0" cellspacing="0" width="100%" border="0">
                                                    <tr>
                                                        <td width="50%" style="<%=style%>;border: none; font:bold; color:black; font-size:15px">
                                                            <input type="radio" name="basicCounter" id="Time" value="BY_TIME" checked>&ensp;<%=sHour%><br>
                                                            <input type="radio" name="basicCounter" id="Km" value="BY_KM" <% if (BasicCounter.equals("BY_KM")) {%> checked <% }%> >&ensp;<%=sKilometer%><br>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </div>
                                        </TD>
                                    </TR>

                                    <tr>
                                        <td width="35%" class="excelentCell formInputTag" style="text-align:Right; font-weight: bold; font-size: 16px; color: black" title=" إسم النـــوع">
                                            <%=categoryEngineeringLabel%>
                                        </td>
                                        <td width="65%" id="CellData" class="TD" style="text-align:Right">
                                            <select style="width: 100%; height: 30px;" id="departType" name="departType">
                                                <option value="<%%>"><%%></option>
                                            </select>
                                        </td>
                                    </tr>
                                </TABLE>
                            </TD>

                            <TD CLASS="TD" WIDTH="48%">
                                <div style="height:25px; text-align:center; font-size:16px;">
                                    <TABLE class="sortable" ALIGN="<%=Xalign%>" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                                        <TR>
                                            <Th CLASS="blueHeaderTD" bgcolor="#9B9B00" WIDTH="45%" STYLE="text-align:center;color:white;font-size:16px;cursor:pointer" nowrap >
                                                <font size="3"><b><%=categName%></b></font>
                                            </Th>
                                            <Th CLASS="blueHeaderTD" bgcolor="#9B9B00" WIDTH="55%" STYLE="text-align:center;color:white;cursor:pointer" nowrap>
                                                <font size="3"><b><%=appriv%></b></font>
                                            </Th>
                                        </TR>
                                    </TABLE>
                                </div>
                                <div style="overflow:hidden;border-style:solid;border-width:1px;border-color:blue;width:100%">
                                    <div id="motioncontainer" style="width:100%; height:250px; overflow:hidden; position: relative;">
                                        <div id="motiongallery" style="position:absolute; left:0; top:0;">
                                            <!--Gallery Contents below-->
                                            <TABLE class="sortable" ALIGN="<%=Xalign%>" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                                                <%
                                                     Enumeration e = categoryList.elements();
                                                     String classStyle = "odd";
                                                     while (e.hasMoreElements()) {
                                                         iTotal++;
                                                         WebBusinessObject wbo = (WebBusinessObject) e.nextElement();
                                                         if ((iTotal % 2) == 1) {
                                                             classStyle = "odd";
                                                         } else {
                                                             classStyle = "even";
                                                         }
                                                %>
                                                <TR STYLE="<%=style%>">
                                                    <TD  nowrap  CLASS="<%=classStyle%>" bgcolor="#DDDD00" STYLE="<%=style%>;font-size:14px;color:black;padding-<%=align%>:10px;">
                                                        <DIV ><b><%=(String) wbo.getAttribute("typeName")%></b></DIV>
                                                    </TD>
                                                    <TD  nowrap  CLASS="<%=classStyle%>" bgcolor="#DDDD00" STYLE="<%=style%>;font-size:14px;color:black;padding-<%=align%>:10px;">
                                                        <DIV ><b><%=(String) wbo.getAttribute("appreviation")%></b></DIV>
                                                    </TD>
                                                </TR>
                                                <% }%>
                                            </TABLE>
                                            <!--End Gallery Contents-->
                                        </div>
                                    </div>
                                </div>
                                <TABLE ALIGN="<%=Xalign%>" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                                    <TR>
                                        <TD CLASS="silver_footer" BGCOLOR="#808080" STYLE="<%=style%>;padding-right:5px;border-right-width:1px;color:white;font-size:14px;">
                                            <B><%=catNum%></B>
                                        </TD>

                                        <TD CLASS="silver_footer"  BGCOLOR="#808080" STYLE="<%=style%>;padding-left:5px;;color:white;font-size:14px;">
                                            <B><%=iTotal%></B>
                                        </TD>
                                    </TR>
                                </TABLE>
                            </TD>
                        </TR>
                    </TABLE>
                    <% }%>
                    <br>
                </fieldset>
            </center>
        </form>
    </BODY>
</html>
