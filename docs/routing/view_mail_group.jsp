<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        String status = (String) request.getAttribute("Status");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        WebBusinessObject clientWBO = (WebBusinessObject) request.getAttribute("mailGroupWbo");
        String action = (String) request.getAttribute("action");
        if (action == null) {
            action = "";
        }

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode;

        String saving_status;
        String client_number,privateStr, client_name, age, client_address, client_job, client_phone, client_ssn, client_mobile, client_city, client_mail, client_service, client_notes, working_status, TT, title_3;
        String title_1, title_2;
        String cancel_button_label;
        String save_button_label;
        if (stat.equals("En")) {

            saving_status = "Saving status";
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";

            client_name = "Client name";
            client_number = "Client number";
            client_address = "Client address";
            client_job = "Client job";
            client_phone = "Client phone";
            //        client_fax = "Fax";
            client_mobile = "Mobile Number";
            client_mail = "E-mail";
            client_city = "Client city";
            client_ssn = "Client ssn";
            client_notes = "Notes";
            age = "age";
            // sup_city = "Supplier city";
            working_status = "Working";
            TT = "Waiting Business Rule";


            title_1 = "Delete supplier";
            title_2 = "All information are needed";
            cancel_button_label = "Back To List ";
            save_button_label = "Save ";
            langCode = "Ar";
            title_3 = "View Client";
            privateStr="Private";
        } else {

            saving_status = "&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";

            client_name = "اسم المجموعه";
            client_number="كود المجموعه";
            client_address = "&#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
            client_job = "المهنة";
            client_phone = "&#1578;&#1604;&#1610;&#1601;&#1608;&#1606;";
//        client_fax = "&#1575;&#1604;&#1601;&#1575;&#1603;&#1587;";
            client_mail = "&#1575;&#1604;&#1576;&#1585;&#1610;&#1583; &#1575;&#1604;&#1573;&#1604;&#1603;&#1578;&#1585;&#1608;&#1606;&#1610;";
            client_city = "&#1575;&#1604;&#1605;&#1583;&#1610;&#1606;&#1607;";
            client_ssn = "&#1575;&#1604;&#1585;&#1602;&#1605; &#1575;&#1604;&#1602;&#1608;&#1605;&#1609;";
            client_notes = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
            client_mobile = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1576;&#1575;&#1610;&#1604;";
            //sup_city = "Supplier city";
            working_status = "&#1606;&#1588;&#1591;";
            age = "الفئة العمرية";

            title_1 = " بيانات العميل";
            title_2 = "&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
            cancel_button_label = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
            save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604; ";
            langCode = "En";
            TT = "&#1605;&#1606;&#1578;&#1592;&#1585; &#1602;&#1575;&#1593;&#1583;&#1577; &#1593;&#1605;&#1604;";
            title_3 = "عرض بيانات العميل";
            privateStr="خاص";
        }

    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE></TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <style>

        label{
            font-size: 15px;
        }
    </style>
    <script language="javascript" type='text/javascript'>
        function cancelForm()
        {
            document.ITEM_FORM.action = "<%=context%>/ComplaintEmployeeServlet?op=listMailGroups";
            document.ITEM_FORM.submit();
        }
    </script>
    <script src='ChangeLang.js' type='text/javascript'></script>

    <BODY>

        <FORM NAME="ITEM_FORM" METHOD="POST">

            <%    if (action.equals("delete")) {

            %>
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm()" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>

            </DIV> 
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="<%=align%>">
                        <tr>

                            <td class="td">
                                <font color="blue" size="6"><%=title_1%>                
                                </font>

                            </td>
                        </tr>
                    </table>
                </legend>
                <br>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" >

                    <table align="<%=align%>" dir="<%=dir%>" ><tr><td style="<%=style%>"class="td">
                                <b><FONT COLOR="red" SIZE="4"> <%=TT%></font></b>
                            </td></tr></table>
                    <br>
                    </fieldset>
                    <%
                    } else {
                    %>    
                    <DIV align="left" STYLE="color:blue;">
                        <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                        <button  onclick="JavaScript: cancelForm()" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>

                    </DIV> 

                    <fieldset class="set" style="border-color: #006699; width: 90%;margin-top: 20px; ">

                        <table dir="<%=dir%>" align="<%=align%>" class="blueBorder" width="100%" border="0px">
                            <tr>

                                <td style="text-align:center;border-color: #006699; width:100%;" class="blueBorder blueHeaderTD">
                                    <FONT color='white' SIZE="+1"><%=title_1%>                
                                    </font>

                                </td>
                            </tr>
                        </table>


                        <br><br>

                        <table style="margin-bottom: 20px;background: #f9f9f9;border: none;" ALIGN="center"  dir="<%=dir%>" width="100%" >
                            <tr>
                                <td style="width: 50%;border: none;">
                                    <table border="0px" style="float: right;" width="100%" >

                                        <TR>
                                            <TD td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%" >
                                                <p><b><%=client_number%></b></p>
                                            </TD>
                                            <TD STYLE="<%=style%>;" class='TD' width="50%">    
                                                <b><font color="red" size="3"><%=clientWBO.getAttribute("code")%></font></b>
                                            </TD>
                                        </TR>
                                        <tr >
                                            <td td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                                <LABEL FOR="clientName">
                                                    <p><b><%=client_name%></b>&nbsp;
                                                </LABEL>
                                            </td>
                                            <TD STYLE="<%=style%>; padding: 5px" class='TD' width="50%">
                                                <SPAN><LABEL id="con"><%=clientWBO.getAttribute("name").toString()%></LABEL></SPAN>
                                            </TD>
                                        </tr>
                                        <% if (clientWBO.getAttribute("private") != null && !(clientWBO.getAttribute("private").equals(""))) {
                                                if(clientWBO.getAttribute("private").equals("Yes")){
                                        %>
                                        <tr >
                                            <td td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                                                <p><b><%=client_number%></b></p>
                                            </TD>
                                            <TD style="border-width: 0px" width="65%">
                                                <input type="checkbox" name="private" ID="private" checked>
                                            </td>
                                            <%}else{%>
                                            <TD class="backgroundHeader" style="<%=style%>" width="35%">
                                                <p><b><%=privateStr%></b></p>
                                            </TD>
                                           <TD style="border-width: 0px" width="65%">
                                                <input type="checkbox" name="private" ID="private">
                                            </td>
                                            <%}%>
                                        </tr>
                                        <%  }%>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </FIELDSET>
                    <% }%>
                    </FORM>
                    </BODY>
                    </HTML>     
