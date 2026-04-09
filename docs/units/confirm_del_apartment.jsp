<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
        String apartmentId = (String) request.getAttribute("apartmentId");
        String apartmentName = (String) request.getAttribute("apartmentName");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        String align = null;
        String dir = null;
        String title, save, cancel, apartment;
        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            title = "Delete Apartment - Are you Sure ?";
            save = "Delete";
            cancel = "Back To List";
            apartment = "Apartment";
        } else {
            align = "center";
            dir = "RTL";
            title = "حذف الوحدة- هل أنت متأكد؟";
            save = "حذف";
            cancel = " &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
            apartment = "الوحدة";
        }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">
        <HEAD>
            <TITLE>Confirm Deletion</TITLE>
            <link rel="stylesheet" type="text/css" href="css/CSS.css" />
            <link rel="stylesheet" type="text/css" href="css/Button.css" />
            <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
            <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
            <script src='js/jsiframe.js' type='text/javascript'></script>
            <script type="text/javascript" src="treemenu/script/jquery-1.2.6.min.js"></script>
            <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
                function submitForm()
                {
                    var url = "op=DeleteApartment&apartmentId=<%=apartmentId%>&apartmentName=<%=apartmentName%>";
                    $.ajax({
                        async: false,
                        type: "POST",
                        url: "<%=context%>/UnitServlet",
                        data: url,
                        success: function(msg) {
                            document.PROJECT_DEL_FORM.action = "<%=context%>/UnitServlet?op=listApartments";
                            document.PROJECT_DEL_FORM.submit();
                        }
                    });
                }
                function cancelForm()
                {
                    document.PROJECT_DEL_FORM.action = "<%=context%>/UnitServlet?op=listApartments";
                    document.PROJECT_DEL_FORM.submit();
                }
            </SCRIPT>
        </HEAD>
        <BODY>
        <center>
            <FORM NAME="PROJECT_DEL_FORM" id="deleteForm" METHOD="POST">
                <DIV align="left" STYLE="color:blue;">
                    <button onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
                    <button onclick="submitForm()" class="button"><%=save%></button>
                </DIV> 
                <br />
                <fieldset class="set" style="border-color: #006699; width: 90%">
                    <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color='white' SIZE="+1"> <%=title%> </FONT><BR></TD>
                        </TR>
                    </TABLE>
                    <br />
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">

                        <TR>
                            <TD class='td'>
                                <LABEL FOR="str_Function_Name">
                                    <p><b><%=apartment%></b>&nbsp;
                                </LABEL>
                            </TD>
                            <TD class='td'>
                                <input disabled type="TEXT" name="apartmentName" value="<%=apartmentName%>" ID="<%=apartmentName%>" size="33"  maxlength="50">
                            </TD>
                        </TR>
                        <input  type="HIDDEN" name="apartmentId" value="<%=apartmentId%>">
                    </TABLE>
                    <br><br>
                </fieldset>
            </FORM>
        </center>
    </BODY>
</HTML>     
