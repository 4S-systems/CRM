<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Projects List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/headers.css">
    </HEAD>
    <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        //AppConstants appCons = new AppConstants();

        String[] projectAttributes = {"typeCode"};
        String[] locationTypeListTitles = new String[6];

        int s = projectAttributes.length;
        int t = s + 5;
        int iTotal = 0;

        String attName = null;
        String attValue = null;
        String cellBgColor = null;

        String status = (String) request.getAttribute("status");

        Vector projectsList = (Vector) request.getAttribute("data");


        WebBusinessObject wbo = null;
        int flipper = 0;
        String bgColor = null;
        String bgColorm = null;

        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

        ProjectMgr projectMgr = ProjectMgr.getInstance();

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, tit, save, cancel, TT, IG, AS, QS, BO, CD, PN, NAS, PL, sSccess, sFail, update;
        String typeName = null;
        String cancel_button_label;
        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:center";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            tit = "Delete Schedule - Are you Sure ?";
            save = "Delete";
            cancel = "Back To List";
            cancel_button_label = "Cancel ";
            TT = "Task Title ";
            IG = "Indicators guide ";
            AS = "Active Site by Equipment";
            NAS = "Non Active Site";
            QS = "Quick Summary";
            BO = "Basic Operations";
            locationTypeListTitles[0] = "#";
            locationTypeListTitles[1] = "Description";
            locationTypeListTitles[2] = "View";
            locationTypeListTitles[3] = "Edit";
            locationTypeListTitles[4] = "Delete";
            locationTypeListTitles[5] = "Display";

            typeName = "enDesc";

            CD = "Can't Delete Site";
            PN = "Location Types No.";
            PL = "Location Types List";
            sSccess = "Project Deleted Successfully";
            sFail = "Fail To Delete Project <br> May be related with other Things";
            update = "Update";
        } else {

            align = "center";
            dir = "RTL";
            style = "text-align:center";
            lang = "English";
            langCode = "En";
            tit = " &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
            save = " &#1573;&#1581;&#1584;&#1601;";
            cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569; ";
            cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
            TT = "&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
            IG = "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
            AS = "&#1605;&#1608;&#1602;&#1593; &#1578;&#1593;&#1605;&#1604; &#1576;&#1607; &#1605;&#1593;&#1583;&#1575;&#1578;";
            NAS = "&#1605;&#1608;&#1602;&#1593; &#1604;&#1575; &#1578;&#1593;&#1605;&#1604; &#1576;&#1607; &#1605;&#1593;&#1583;&#1575;&#1578;";
            QS = "&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
            BO = "&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
            locationTypeListTitles[0] = "#";
            locationTypeListTitles[1] = "الوصف";
            locationTypeListTitles[2] = "&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
            locationTypeListTitles[3] = "&#1578;&#1581;&#1585;&#1610;&#1585;";
            locationTypeListTitles[4] = "&#1581;&#1584;&#1601;";
            locationTypeListTitles[5] = "إظهار";

            typeName = "arDesc";

            CD = " &#1604;&#1575; &#1578;&#1587;&#1578;&#1591;&#1610;&#1593; &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
            PN = "عدد أنواع العناصر ";
            PL = "عرض أنواع العناصر";
            sSccess = "&#1578;&#1605; &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593; &#1576;&#1606;&#1580;&#1575;&#1581;";
            sFail = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1581;&#1584;&#1601; <br> &#1605;&#1581;&#1578;&#1605;&#1604; &#1575;&#1606; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1571;&#1588;&#1610;&#1575;&#1569; &#1571;&#1582;&#1585;&#1609;";
            update = "تحديث";
        }


    %>
    <script language="javascript" type="text/javascript">
        
        function cancelForm(){
            document.new_location_type_Form.action = "<%=context%>/main.jsp"
            document.new_location_type_Form.submit();
        }
        function updateForm(){
            document.new_location_type_Form.submit();
        }
    </script>
    <body>

        <FORM NAME="location_type_FORM" id="new_location_type_Form" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>"onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button onclick="JavaScript: updateForm();" class="button"><%=update%><img valign="bottom" src="images/cancel.gif"/> </button>
            </DIV> 

            <br />

            <fieldset class="set" style="border-color: #006699; width: 90%">
                <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <TR>
                        <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"> <%=PL%> </FONT><BR></TD>
                    </TR>
                </TABLE> 
                <br />

                <center> <b> <font size="3" color="red"> <%=PN%> : <%=projectsList.size()%> </font></b></center> 
                <br>

                <%if (status != null) {
                %>
                <table width="50%" align="center">
                    <tr>
                        <%if (status.equalsIgnoreCase("ok")) {%>
                        <td class="bar">
                            <b><font color="blue" size="3"><%=sSccess%></font></b>
                        </td>
                        <%} else {%>
                        <td class="bar">
                            <b><font color="red" size="3"><%=sFail%></font></b>
                        </td>
                        <%}%>
                    </tr>
                </table>
                <br>
                <%}%>

                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">

                    <TR>
                        <TD CLASS="blueBorder blueHeaderTD" COLSPAN="2" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:18">
                            <B><%=QS%></B>
                        </TD>
                        <TD CLASS="blueBorder blueHeaderTD" COLSPAN="4" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:18">
                            <B><%=BO%></B>
                        </TD>
                    </tr>

                    <TR class="silver_header">

                        <%
                            String columnColor = new String("");
                            String columnWidth = new String("");
                            String font = new String("");
                            for (int i = 0; i < t; i++) {
                                if (i == 0) {
                                    columnColor = "#9B9B00";
                                } else {
                                    columnColor = "#7EBB00";
                                }
                                if (locationTypeListTitles[i].equalsIgnoreCase("")) {
                                    columnWidth = "1";
                                    columnColor = "black";
                                    font = "1";
                                } else {
                                    columnWidth = "100";
                                    font = "12";
                                }
                        %>                
                        <TD nowrap CLASS="silver_header" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:<%=font%>;" nowrap>
                            <B><%=locationTypeListTitles[i]%></B>
                        </TD>
                        <%
                            }
                        %>
                    </TR>

                    <%

                        Enumeration e = projectsList.elements();


                        while (e.hasMoreElements()) {
                            iTotal++;
                            wbo = (WebBusinessObject) e.nextElement();

                            flipper++;
                            if ((flipper % 2) == 1) {
                                bgColor = "silver_odd";
                                bgColorm = "silver_odd_main";
                            } else {
                                bgColor = "silver_even";
                                bgColorm = "silver_even_main";
                            }
                    %>

                    <TR >    
                        <TD CLASS="<%=bgColorm%>" nowrap STYLE="<%=style%>"  BGCOLOR="#DDDD00"  >
                            <DIV >

                                <b> <%=iTotal%> </b>
                            </DIV>
                        </TD>
                        <TD CLASS="<%=bgColorm%>" nowrap STYLE="<%=style%>"  BGCOLOR="#DDDD00"  >
                            <DIV >

                                <b> <%=(String) wbo.getAttribute(typeName)%> </b>
                            </DIV>
                        </TD>

                        <TD nowrap CLASS="<%=bgColor%>" STYLE="padding-left:10;<%=style%>" BGCOLOR="#D7FF82">
                            <DIV ID="links">
                                <A HREF="<%=context%>/ProjectServlet?op=viewLocationType&id=<%=wbo.getAttribute("id")%>">

                                    <%= locationTypeListTitles[2]%>
                                </A>
                            </DIV>
                        </TD>

                        <TD nowrap CLASS="<%=bgColor%>" STYLE="padding-left:10;<%=style%>" BGCOLOR="#D7FF82" >
                            <DIV ID="links">
                                <A HREF="<%=context%>/ProjectServlet?op=getUpdateLocationType&id=<%=wbo.getAttribute("id")%>">
                                    <%= locationTypeListTitles[3]%>
                                </A>
                            </DIV>
                        </TD>
                        <TD nowrap CLASS="<%=bgColor%>" STYLE="padding-left:10;<%=style%>" BGCOLOR="#D7FF82" >
                            <DIV ID="links">
                                <A HREF="<%=context%>/ProjectServlet?op=confirmDeleteLocationType&id=<%=wbo.getAttribute("id")%>&typeName=<%=wbo.getAttribute(typeName)%>">
                                    <%= locationTypeListTitles[4]%>
                                </A>
                            </DIV>
                        </TD>
                        <TD nowrap CLASS="<%=bgColor%>" STYLE="padding-left: 10px; <%=style%>" BGCOLOR="#D7FF82" >
                            <input type="checkbox" name="displayInTree" value="<%=wbo.getAttribute("id")%>" <%="1".equals(wbo.getAttribute("displayInTree")) ? "checked" : ""%>/>
                        </TD>
                    </TR> <%}%>
                    <TR>
                        <TD CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="3" STYLE="<%=style%>;padding-right:5;border-right-width:1;font-size:16;">
                            <b><%=PN%></b>
                        </TD>  
                        <TD CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="3" STYLE="<%=style%>;padding-left:5;font-size:16;">

                            <DIV NAME="" ID="">
                                <b><%=iTotal%></b>
                            </DIV>
                        </TD>
                    </TR>
                </table>
                <br /><br />
            </fieldset>
        </FORM>
    </body>
</html>
