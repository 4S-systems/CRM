<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@ page pageEncoding="UTF-8"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <%
                UserMgr userMgr = UserMgr.getInstance();
                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                DepartmentMgr departmentMgr = DepartmentMgr.getInstance();
                String context = metaMgr.getContext();
                TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

                String message = (String) request.getAttribute("message");
                ArrayList arrDep = departmentMgr.getCashedTableAsBusObjects();

                String stat = (String) request.getSession().getAttribute("currentMode");
                String align = null;
                String dir = null;
                String style = null;
                String lang, langCode, sTitle, sCancel, sOk, sSearchTitle, search, title;

                if (stat.equals("En")) {
                    align = "center";
                    dir = "LTR";
                    style = "text-align:left";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    sTitle = "Search for Equipment";
                    sCancel = "Cancel";
                    sOk = "Search";
                    langCode = "Ar";
                    sSearchTitle = "Equipment Name ";
                    title = "Search Total Time Between Failure and Work";
                    search = "Search";
                } else {
                    align = "center";
                    dir = "RTL";
                    style = "text-align:Right";
                    lang = "English";
                    sTitle = "&#1576;&#1581;&#1579; &#1593;&#1606; &#1605;&#1593;&#1583;&#1607;";
                    sCancel = tGuide.getMessage("cancel");
                    sOk = "&#1576;&#1581;&#1579;";
                    langCode = "En";

                    title = "إجمالي الوقت بين الفشل والعمل";
                    sSearchTitle = "إسم المعدة ";
                    search = "&#1576;&#1581;&#1579;";
                }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <script src='js/silkworm_validate.js' type='text/javascript'></script>
        <script src='js/validator.js' type='text/javascript'></script>
        <script src='js/CustomDialog.js' type='text/javascript'></script>
        <script src='js/ChangeLang.js' type='text/javascript'></script>
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {   if(!validateData("req", document.EQUIP_STATUS_FORM.unitId, "Must Select Equpmint From Search...")){
                document.EQUIP_STATUS_FORM.btnSearch.focus();
            
            } else {
                document.EQUIP_STATUS_FORM.action = "<%=context%>/ReportsServletThree?op=equipmentFaiulerReport";
                document.EQUIP_STATUS_FORM.submit();
            }
        }

        function checkKey(e){
            if(e.keyCode == 13){
                submitForm();
            }
        }
        
        function cancelForm()
        {    
            document.EQUIP_STATUS_FORM.action = "main.jsp";
            document.EQUIP_STATUS_FORM.submit();
        }

        function inputChange() {
            document.getElementById('unitId').value = "";
        }

        function getEquipment() {
            var formName = document.getElementById('EQUIP_STATUS_FORM').getAttribute("name");
            var name = document.getElementById('unitName').value
            name = getASSCIChar(name);
            openWindow('SelectiveServlet?op=listEquipmentsAndViewEquipment&unitName=' + name + '&formName=' + formName);
        }

        function openWindow(url) {
            openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=750, height=400");
        }

    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM ID="EQUIP_STATUS_FORM" NAME="EQUIP_STATUS_FORM" METHOD="POST">
            <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            <%--<button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"> </button>--%>
            <button  onclick="JavaScript: submitForm();" class="button"><%=sOk%> <IMG HEIGHT="15" SRC="images/search.gif"></button>
            <BR>
            <fieldset class="set" style="border-color: #006699; width: 95%">
                <table class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <TR>
                        <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><Font color='white' SIZE="+1"><%=title%></Font><BR></TD>
                    </TR>
                </table>

                <br>
                <TABLE ALIGN="CENTER" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">

                    <TR>
                        <TD STYLE="text-align:right " class='td'>
                            <LABEL FOR="Project_Name">
                                <p><b><%=sSearchTitle%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>;color:white;font-size:14;height:40;border-width:0px" >
                            <input style="width:200px; <%=style%>" type="text" onchange="javascript:inputChange();" name="unitName" ID="unitName">
                            <input type="button" name="btnSearch" id="btnSearch" style="width:70px" onclick="JavaScript:getEquipment();" value="<%=search%>">
                            <input type="hidden" dir="ltr"  class="head"  name="unitId" ID="unitId">
                        </TD>
                    </TR>                         
                </TABLE>
                <INPUT TYPE="hidden" name="filterValue" value="">

                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD class="td">
                            &nbsp;
                        </TD>
                    </TR>
                </TABLE>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
