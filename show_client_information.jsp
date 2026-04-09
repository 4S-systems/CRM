<%@page import="com.clients.db_access.CustomerGradesMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*, com.contractor.db_access.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, java.util.Hashtable"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*, java.lang.Integer"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>

<html>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <%

        WebBusinessObject client = (WebBusinessObject) request.getAttribute("clientWbo");
        String clientName = (String) client.getAttribute("name");
        String clientId = (String) client.getAttribute("id");
    %>
    <head>

    </head>
    <style type="text/css">
        #ta td{
            border: none;
        }
        .showx{
            display: block;
        }
        .hidex{
            display: none; font-size: 14px;
        }
    </style>
    <body>





        <div style="clear: both;margin-left: 90%;margin-top: 0px;margin-bottom: -38px;z-index: -10000000;">
            <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);background-color: transparent;
                 -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                 box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                 -webkit-border-radius: 100px;
                 -moz-border-radius: 100px;
                 border-radius: 100px;" onclick="closePopup(this)"/>
        </div>

        <!--<h1>رسالة قصيرة</h1>-->
        <div class="login" style="width:90%;margin-left: auto;margin-right: auto;">
            <table  id="ta" border="0px" class="table" style="width:100%;text-align: right;margin-bottom: 10px !important;margin-left: auto;margin-right: auto;" >
                <!--<table align="right" width="30%" class="login" style="display: none;color: white" id="" cellpadding="3px;" cellspacing="3px;">-->
                <%
                    //  if (connectByRealEstate != null && !connectByRealEstate.equals("")
                    //     && connectByRealEstate.equals("1")) {
%>

                <%//} else {%>
                <tr >
                    <td style="width: 45%;">
                        <table style="">
                            <tr>
                                <td width="40%"style="color: #000;text-align: match-parent" >رقم العميل</td>
                                <td style="text-align:right;border: none;">
                                    <label style="float: right;" id="clientNO"><%=client.getAttribute("clientNO").toString()%></label>
                                    <hr style="float: right;width: 70%;clear: both;" >
                                </td>
                            </tr>
                            <!--                                <tr>
                                                                <td width="40%" style="color: #000;" >رقم العميل</td>
                                                                <td style="text-align:right;border: none;"><label style="color: #ffffff;" id="clientNO"><%=client.getAttribute("clientNO")%></label>
                                                                    <hr style="float: right;width: 70%;clear: both;" 
                            
                                                                </td>
                                                            </tr>-->

                            <tr>
                                <td style="color: #000;" width="40%" >اسم العميل</td>
                                <td style="text-align:right;"><label class="showx" id="clientName"><%=client.getAttribute("name")%></label>
                                    <hr style="float: right;width: 70%;" class="showx">
                                    <input type="text"  name="clientName" class="hidex" value="<%=client.getAttribute("name")%>"/>
                                    <input type="hidden" id="hideName" value="<%=client.getAttribute("name")%>" />
                                    <% String mail = "";
                                        if (client.getAttribute("email") != null) {
                                            mail = (String) client.getAttribute("email");
                                        }
                                    %>
                                    <input type="hidden" id="hideEmail" value="<%=mail%>" />
                                    <input type="hidden" id="clientId" name="clientId" value="<%=client.getAttribute("id")%>"/>
                                </td>

                            </tr>
                            <%if (client.getAttribute("partner") != null && !client.getAttribute("partner").equals("")) {
                            %>
                            <tr>
                                <td style="color: #000;" width="40%" >إسم الزوجة/الزوج</td>
                                <td style="text-align:right"><label id="partner"class="showx"><%=client.getAttribute("partner")%></label>
                                    <hr style="float: right;width: 70%;" class="showx">
                                    <input type="text"  name="partner" class="hidex" value="<%=client.getAttribute("partner")%>"/>
                                </td>
                            </tr>
                            <%} else {%>
                            <tr>
                                <td style="color: #000;" width="40%" >إسم الزوجة/الزوج</td>
                                <td style="text-align:right"><label id="partner"class="showx"><%=client.getAttribute("partner")%></label>
                                    <hr style="float: right;width: 70%;" class="showx">
                                    <input type="text"  name="partner" class="hidex" value=""/>
                                </td>
                            </tr>

                            <%}%>
                            <TR>
                                <TD style="color: #000;width: 40%;"  width="40%">النوع</TD>

                                <td style="float: right;text-align: right" class='td'>
                                    <span><input type="radio" name="gender" value="ذكر"  <% if (client.getAttribute("gender").equals("ذكر")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>ذكر</b></font></span>
                                    <span><input type="radio"  name="gender" value="أنثى"  <% if (client.getAttribute("gender").equals("أنثى")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>أنثى</b></font></span>
                                </td>
                            </TR>
                            <TR>
                                <TD style="color: #000;width: 40%;"  width="40%">

                                    الحالة الإجتماعية
                                </TD>

                                <td class='td'>
                                    <span><input type="radio" name="matiral_status" value="أعزب"  <% if (client.getAttribute("matiralStatus").equals("أعزب")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>أعزب</b></font></span>
                                    <span><input type="radio" name="matiral_status" value="متزوج" <% if (client.getAttribute("matiralStatus").equals("متزوج")) {%> checked="true" <%}%> />  <font size="3" color="#005599"><b>متزوج</b></font></span>
                                    <span><input type="radio" name="matiral_status" value="مطلق"  <% if (client.getAttribute("matiralStatus").equals("مطلق")) {%> checked="true" <%}%>/>  <font size="3" color="#005599"><b>مطلق</b></font></span>

                                </td>

                            </TR>
                            <%if (client.getAttribute("clientSsn") != null && !client.getAttribute("clientSsn").equals("")) {
                            %>
                            <tr>
                                <td style="color: #000;" width="40%" >الرقم القومى</td>
                                <td style="text-align:right;"><label id="clientSsn" class="showx"><%=client.getAttribute("clientSsn")%></label>
                                    <hr style="float: right;width: 70%;" class="showx">

                                    <input type="text" name="clientSsn" class="hidex" value="<%=client.getAttribute("clientSsn")%>" onkeypress="javascript:return isNumber(event)"/>

                                </td>
                            </tr>
                            <%} else {%>
                            <tr>
                                <td style="color: #000;" width="40%">الرقم القومى</td>
                                <td style="text-align:right;"><label class="showx" id="clientSsn"></label>
                                    <hr style="float: right;width: 70%;" class="showx">
                                    <input type="text"  name="clientSsn" class="hidex" value="" onkeypress="javascript:return isNumber(event)"/>
                                </td>
                            </tr>
                            <%}%>
                            <tr>
                                <td style="color: #000;width: 40%;"  width="40%">
                                    <LABEL FOR="job" style="color: #000;">
                                        المهنة
                                    </LABEL>
                                </td>
                                <td style="float: right;text-align: right"class='td'>
                                    <%
                                        String jobName = "";
                                        if (client.getAttribute("job") != null & !client.getAttribute("job").equals("")) {
                                            String jobCode = (String) client.getAttribute("job");
                                            WebBusinessObject wbo5 = new WebBusinessObject();
                                            TradeMgr tradeMgr = TradeMgr.getInstance();
                                            wbo5 = tradeMgr.getOnSingleKey("key2", jobCode);
                                            if (wbo5 != null) {

                                                jobName = (String) wbo5.getAttribute("tradeName");
                                            } else {
                                                jobName = "لم يتم الإختيار";
                                            }
                                        }
                                    %>


                                    <label class="showx" id="clientJob"><%=jobName%></label>



                                </td>
                            </tr>
                        </table>
                    </td>
                    <td style="width: 50%;">
                        <table>
                            <%if (client.getAttribute("phone") != null && !client.getAttribute("phone").equals("")) {
                            %>

                            <tr>
                                <td style="color: #000;" width="40%" >رقم التليفون</td>
                                <td style="text-align:right;"><label class="showx" id="phone"><%=client.getAttribute("phone")%></label>
                                    <hr style="float: right;width: 70%;" class="showx">

                                    <input type="text"  name="phone" class="hidex" value="<%=client.getAttribute("phone")%>" onkeypress="javascript:return isNumber(event)"/>
                                </td>
                            </tr>
                            <%} else {%>
                            <tr>
                                <td style="color: #000;" width="40%" >رقم التليفون</td>
                                <td style="text-align:right;"><label class="showx" id="phone"></label>
                                    <hr style="float: right;width: 70%;" class="showx">
                                    <input type="text" name="phone" class="hidex" value="" onkeypress="javascript:return isNumber(event)"/>
                                </td>
                            </tr>
                            <%}%>
                            <tr>
                                <td style="color: #000;" width="40%" >رقم الموبايل</td>
                                <td style="text-align:right;"><label  class="showx" id="client_mobile"><%=client.getAttribute("mobile")%></label>
                                    <hr style="float: right;width: 70%;" class="showx">

                                    <input type="text"  name="client_mobile" class="hidex" value="<%=client.getAttribute("mobile")%>" onkeypress="javascript:return isNumber(event)"/>
                                </td>
                            </tr>
                            <%if (client.getAttribute("address") != null && !client.getAttribute("address").equals("")) {
                            %>
                            <tr>
                                <td style="color: #000;"  width="40%">العنوان</td>
                                <td style="text-align:right;"><label class="showx" id="address"><%=client.getAttribute("address")%></label>
                                    <hr style="float: right;width: 70%;" class="showx">

                                    <input type="text"  name="address" class="hidex" value="<%=client.getAttribute("address")%>"/>
                                </td>
                            </tr>
                            <%} else {%>
                            <tr>
                                <td style="color: #000;"  width="40%">العنوان</td>
                                <td style="text-align:right;"><label class="showx"  id="address"></label>
                                    <hr style="float: right;width: 70%;" class="showx">
                                    <input type="text"  name="address" class="hidex" value=""/>
                                </td>
                            </tr>

                            <%}%>
                            <%if (client.getAttribute("email") != null && !client.getAttribute("email").equals("")) {
                            %>
                            <tr>
                                <td style="color: #000;"  width="30%" >البريد الإلكترونى</td>
                                <td style="text-align:right;"><label  class="showx"  id="email"><%=client.getAttribute("email")%></label>
                                    <hr style="float: right;width: 90%;" class="showx">

                                    <input type="text"  name="email" class="hidex" value="<%=client.getAttribute("email")%>"/>
                                </td>
                            </tr>
                            <%} else {%>
                            <tr>
                                <td style="color: #000;"  width="30%" >البريد الإلكترونى</td>
                                <td style="text-align:right;"><label  class="showx"  id="email"></label>
                                    <hr style="float: right;width: 90%;" class="showx">
                                    <input type="text"  name="email" class="hidex" value=""/>
                                </td>
                            </tr>
                            <%}%>
                            <!--
                            --><tr>
                                <td style="color: #000;"  width="40%" >يعمل بالخارج</td>

                                <td style="text-align:right;">
                                    <span><input type="radio" name="workOut" value="1"  <% if (client.getAttribute("option1").equals("1")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">نعم</b></font></span>
                                    <span><input type="radio" name="workOut" value="0"  <% if (client.getAttribute("option1").equals("0")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">لا</b></font></span>
                                </td>

                            </tr>

                            <tr>
                                <td style="color: #000;width: 40%;"  width="40%" >أقارب بالخارج</td>
                                <td style="text-align:right;">
                                    <span><input type="radio" name="kindred" value="1"  <% if (client.getAttribute("option2").equals("1")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">نعم</b></font></span>
                                    <span><input type="radio" name="kindred" value="0"  <% if (client.getAttribute("option2").equals("0")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">لا</b></font></span>
                                </td>
                            </tr>
                            <TR>
                                <TD style="color: #000;width: 40%;"  width="40%" >الفئة العمرية</TD>

                                <td class='td'>

                                    <span><input type="radio" name="age" value="20-30"  <% if (client.getAttribute("age").equals("20-30")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">20-30</b></font></span>
                                    <span><input type="radio" name="age" value="30-40"  <% if (client.getAttribute("age").equals("30-40")) {%> checked="true" <%}%>/> <b style="font-size: 11px;">30-40</b></font></span>
                                    <span><input type="radio" name="age" value="40-50" <% if (client.getAttribute("age").equals("40-50")) {%> checked="true" <%}%>/>  <b  style="font-size: 11px;">40-50</b></font></span>
                                    <span><input type="radio" name="age" value="50-60"  <% if (client.getAttribute("age").equals("50-60")) {%> checked="true" <%}%>/>  <b  style="font-size: 11px;">50-60</b></font></span>

                                </td>
                            </TR>
                        </table>
                    </td>
                </tr>
            </table>
        </div>


    </body>
</html>