<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.maintenance.common.ConfigFileMgr" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <%
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        Vector employeeList = (Vector) request.getAttribute("employeeList");
        String empIdStr = null, empNameStr = null;

        WebBusinessObject empWbo = null;

        Calendar cal = Calendar.getInstance();
        String jDateFormat = "yyyy/MM/dd";
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String nowTime = sdf.format(cal.getTime());
        String type = (String) request.getAttribute("type");
        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;

        String search, cancel, save, dir, style, selectStr, lang, langCode,
                title, back, modelStr, dir1;

        int flipper = 0;
        String bgColor = null;
        String bgColorm = null;

        String textAlign;

        if (stat.equals("En")) {
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            style = "text-align:left";
            langCode = "Ar";
            dir = "LTR";
            dir1 = "left";
            cancel = "Cancel";
            title = "Search Models";
            search = "Search";
            back = "Back";
            save = "Save";
            selectStr = "Select";
            modelStr = "Model";

        } else {
            lang = "   English    ";
            style = "text-align: right";
            langCode = "En";
            dir = "RTL";
            dir1 = "right";
            back = "العودة";
            save = "حفظ";
            cancel = tGuide.getMessage("cancel");
            title = "بحث عن موديل";
            search = "بحث";
            selectStr = "إختر";
            modelStr = "موديل";
        }

    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="js/silkworm_validate.js"></script>

        <script type="text/javascript">
            
            function cancelForm(url)
            {
                window.navigate(url);
            }

            function submitForm() {
                if($("#unitId").val() == '') {
                    alert("Please choose a model!");
                    
                } else {
                    document.SEARCH_EQUIPMENTS_BY_MODEL.action = "<%=context%>/EquipmentServlet?op=getEquipmentListByModel";
                    document.SEARCH_EQUIPMENTS_BY_MODEL.submit();
                    
                }                
            }

            function clearEmpId(index) {
                $("#empId" + index).val('');
                
            }

            function clearUnitId() {
                $("#unitId").val('');

            }

        </script>

        <style type="text/css">
            #showHide{
                /*background: #0066cc;*/
                border: none;
                padding: 10px;
                font-size: 16px;
                font-weight: bold;
                color: #0066cc;
                cursor: pointer;
                padding: 5px;
            }
            #dropDown{
                position: relative;
            }
            .backStyle{
                border-bottom-width:0px;
                border-left-width:0px;
                border-right-width:0px;
                border-top-width:0px
            }

            .datepick {}

            .save {
                width:20px;
                height:20px;
                background-image:url(images/icons/icon-32-publish.png);
                background-repeat: no-repeat;
                cursor: pointer;
            }

        </style>
    </HEAD>

    <BODY STYLE="background-color:#ffffb9">
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <FORM NAME="SEARCH_EQUIPMENTS_BY_MODEL" METHOD="POST">
        <DIV align="left" STYLE="color:blue; padding-left: 5%; padding-bottom: 10px; padding-top: 10px">
            <button  onclick="JavaScript: cancelForm('<%=context%>/main.jsp');" class="button"><%=back%></button>            
            <button  onclick="JavaScript: submitForm();" class="button"><%=search%></button>
            
        </DIV>
        <CENTER>
            <FIELDSET class="set" style="width:90%;border-color: #006699;" >
                <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                    <TR>
                        <TD dir="<%=dir%>" style="text-align:center;border-color: #006699" width="100%" class="blueBorder blueHeaderTD"><font color="#006699" size="4"><%=title%></font></TD>
                    </TR>
                </TABLE>

                <br><br>
                <TABLE id="MaintNum" ALIGN="center" DIR="<%=dir%>" WIDTH="40%" CELLSPACING=0 CELLPADDING=0 BORDER="0" style="display: block;">

                    <TR>
                        <TD style="<%=style%>; width: 20%; padding-<%=dir1%>: 5px;" class="td2 formInputTag boldFont backgroundHeader" id="CellData">
                            <b><%=modelStr%><font color="#FF0000">*</font></b>
                        </TD>
                        <TD style="<%=style%>; border: none; padding-<%=dir1%>: 5px;">
                            <input type="TEXT" dir="<%=dir%>" name="unitName" ID="unitName" size="20" style="width:200px;" maxlength="255" onchange="JavaScript: clearUnitId();">
                            <input type="hidden" name="unitId" id="unitId"/>
                            <input type="button" class="button" name="search" id="search" value="<%=selectStr%>" onclick="getDataInPopup('EquipmentServlet?op=listModelsInPopup&formName=SEARCH_EQUIPMENTS_BY_MODEL&fieldName=Unit_Name&fieldValue='+getASSCIChar(document.getElementById('unitName').value));" STYLE="height: 25px;font-size:15px;color:black;font-weight:bold;width:60px">
                        </TD>
                    </TR>
                </TABLE>
                
                <br><br>

            </FIELDSET>
        </CENTER>
        </FORM>
    </BODY>
</HTML>