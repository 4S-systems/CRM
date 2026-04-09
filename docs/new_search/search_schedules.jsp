<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.maintenance.common.ConfigFileMgr" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@page pageEncoding="UTF-8" %>
<HTML>

    <%
        TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        // get all need data
        ArrayList allMainType = (ArrayList) request.getAttribute("allMainType");
        ArrayList parents = (ArrayList) request.getAttribute("parents");

        //get session logged user and his trades
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;

        String lang, langCode, dir, back, align, search, cancel, mainType,
               selectAll, brand, withItemsStr, byUnitStr, selectStr, title,
               reportCode;

        if (stat.equals("En")) {
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            back = "Back";
            align = "left";
            dir = "LTR";search = "Export Report";
            cancel = "Cancel";
            mainType = "By Main Type";
            brand = "By Brand";
            selectAll = "All";
            withItemsStr = "With Maintenance Items";
            byUnitStr = "By Equipment";
            selectStr = "Select";
            title = "Schedules Report";
            reportCode = "Report Code: M-SCH-GENERAL-1";

        } else {
            lang = "English";
            langCode = "En";
            back = "&#1585;&#1580;&#1608;&#1593;";
            align = "right";
            dir = "RTL";
            search = "&#1575;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
            cancel = tGuide.getMessage("cancel");
            mainType = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1606;&#1600;&#1600;&#1608;&#1593; &#1585;&#1574;&#1610;&#1600;&#1600;&#1587;&#1609;";
            brand = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1605;&#1600;&#1600;&#1600;&#1575;&#1585;&#1603;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1577;";
            selectAll = "&#1603;&#1600;&#1600;&#1600;&#1604;";
            withItemsStr = "مع بنود الصيانة";
            byUnitStr = "بـــ المــــعـــــــــــــدة";
            selectStr = "إختر";
            title = "تقرير جداول الصيانة";
            reportCode = "Report Code: M-SCH-GENERAL-1";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_centerwindow.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <script type="text/javascript" src="js/tip_followscroll.js"></script>
        <script type="text/javascript" src="js/common.js"></script>
        <script type="text/javascript" src="js/silkworm_validate.js"></script>
        <script type="text/javascript" src="js/getEquipmentsList.js"></script>
        <script type="text/javascript" src="js/datepicker_limit.js"></script>
        <script type="text/javascript">
            
            var mainTypeAll = "no";
            var brandAll = "no";
            
            function submitForm()
            {
                var searchBy = getSearchBy();

                if(document.getElementById('mainTypeRadio').checked && document.getElementById('maintype').value == "") {
                    alert("Please Select Main Type");
                    document.SEARCH_MAINTENANCE_FORM.maintype.focus();
                    return;
                } else if(document.getElementById('brandRadio').checked && document.getElementById('brand').value == "") {
                    alert("Please Select Brand");
                    document.SEARCH_MAINTENANCE_FORM.brand.focus();
                    return;
                } else if(document.getElementById('unit').checked && document.getElementById('unitId').value == "") {
                    alert("Please Select a Unit");
                    document.SEARCH_MAINTENANCE_FORM.unitName.focus();
                    return;
                }
                
                document.SEARCH_MAINTENANCE_FORM.action = "PDFReportServlet?op=searchSchedules&mainTypeAll=" + mainTypeAll + "&brandAll=" + brandAll + "&searchBy=" + searchBy;                
                openCustom('');
                document.SEARCH_MAINTENANCE_FORM.target = "window_chaild";
                document.SEARCH_MAINTENANCE_FORM.submit();
            }
            
            function openCustom(url)
            {
                openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
            }
            
            function cancelForm()
            {
                document.SEARCH_MAINTENANCE_FORM.target = "";
                document.SEARCH_MAINTENANCE_FORM.action = "<%=context%>/main.jsp;";
                document.SEARCH_MAINTENANCE_FORM.submit();
            }

            function back()
            {
                document.SEARCH_MAINTENANCE_FORM.target = "";
                document.SEARCH_MAINTENANCE_FORM.action = "<%=context%>/ReportsServlet?op=mainPage";
                document.SEARCH_MAINTENANCE_FORM.submit();
            }

            function getSearchBy() {
                var selectEquip = document.getElementsByName("selectEquip");
                for(var i = 0; i < selectEquip.length; i++) {
                    if(selectEquip[i].checked) {
                        return selectEquip[i].value;
                    }
                }

                return "maintype";
            }
     
            function textChange(textBox){
                document.getElementById(textBox).value = "";
            }

            function openWindow(url)
            {
                chaild_window = window.open(url, "chaild_window", "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
                chaild_window.focus();
            }

            function showHide(id){
                var divUnit = document.getElementById('divUnit');
                var divMainType = document.getElementById('divMainType');
                var divBrand = document.getElementById('divBrand');
                if(id == 'mainTypeRadio') {
                    divMainType.style.display = "block";
                    divUnit.style.display = "none";
                    divBrand.style.display = "none";
                } else if(id == 'brandRadio') {
                    divBrand.style.display = "block";
                    divUnit.style.display = "none";
                    divMainType.style.display = "none";
                } else {
                    divUnit.style.display = "block";
                    divMainType.style.display = "none";
                    divBrand.style.display = "none";
                }
            }

            function trim(str) {
                return str.replace(/^\s+|\s+$/g,"");
            }
        
            function selectAllElements(optionListId){
                var length = document.getElementById(optionListId).options.length;
                var option = document.getElementById(optionListId).options;
                if(option[0].selected) {
                    option[0].selected = false;
                    for(var i = 1; i<length; i++){
                        option[i].selected = true;
                    }
                    if(optionListId == "maintype"){
                        mainTypeAll = "yes";
                    } else if(optionListId == "brand"){
                        brandAll = "yes";
                    }
                } else {
                    if(optionListId == "maintype"){
                        mainTypeAll = "no";
                    } else if(optionListId == "brand"){
                        brandAll = "no";
                    }
                }
            }
            
            function getEquipmentInPopup() {
                getDataInPopup('SelectiveServlet?op=listEquipments&fieldName=UNIT_NAME&fieldValue=' + getASSCIChar(document.getElementById('unitName').value) + '&formName=SEARCH_MAINTENANCE_FORM');
                
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
    </style>

    </HEAD>
    
    <BODY STYLE="background-color:#E8E8E8">
        <FORM action=""  NAME="SEARCH_MAINTENANCE_FORM" METHOD="POST">
            <input type="hidden" name="search" value="search" />
            <DIV DIR="LTR" style="padding-left: 2.5%; padding-bottom: 10px" >
                <input type="button" style="font-size:15px;font-weight:bold"  value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button onclick="JavaScript:back();" class="button" style="font-size:15px;font-weight:bold"><%=back%></button>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="width:95%;border-color: #006699;" >
                    
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <font color="#F3D596" size="4"><%=title%></font>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <div style="text-align: left;">
                        <table>
                            <tr>
                                <td style="text-align: left;border: none;">
                                    <font color="#FF385C" size="2" style="font-weight: bold;">
                                        <%=reportCode%>
                                    </font>
                                </td>
                            </tr>
                        </table>
                    </div>      <BR>
                    <TABLE BGCOLOR="#E8E8E8" ALIGN="center" DIR="<%=dir%>" WIDTH="60%" CELLSPACING=5 CELLPADDING=0 BORDER="0">
                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="3" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="17%">
                                <b style="text-align:<%=align%>;padding-<%=align%> : 10px"><font size=3 color="black"><input type="radio" id="mainTypeRadio" value="maintype" name="selectEquip" checked onclick="JavaScript:showHide(this.id);" /><%=mainType%></font></b>
                            </TD>
                            <TD BGCOLOR="#E8E8E8" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="33%">
                                <DIV ID="divMainType">
                                    <select name="mainType" id="maintype" multiple size="5" style="font-size:12px; font-weight:bold; width:100%" onchange="selectAllElements(this.id)">
                                        <option value="selectAll" style="color:#989898;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                        <sw:WBOOptionList wboList="<%=allMainType%>" displayAttribute="typeName" valueAttribute="id" />
                                    </select>
                                </DIV>
                            </TD>
                        </TR>
                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="17%">
                                <b><font size=3 color="black"><input type="radio" id="brandRadio" value="brand" name="selectEquip" onclick="JavaScript:showHide(this.id);" /><%=brand%></font></b>
                            </TD>
                            <TD BGCOLOR="#E8E8E8" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="33%">
                                <DIV ID="divBrand" style="display: none;">
                                    <select name="brand" id="brand" multiple size="5" style="font-size:12px;font-weight:bold;width:100%" onchange="selectAllElements(this.id)">
                                        <option value="selectAll" style="color:#989898;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                        <sw:WBOOptionList wboList="<%=parents%>" displayAttribute="unitName" valueAttribute="id" />
                                    </select>
                                </DIV>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><input type="radio" id="unit" value="unit" name="selectEquip" onclick="JavaScript:showHide(this.id);" /><%=byUnitStr%></font></b>
                            </TD>
                            <td style="text-align:<%=align%>;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;padding:5px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <DIV ID="divUnit" style="display: none;">
                                    <input type="hidden" name="unitId" value="" id="unitId" />
                                    <input type="text" name="unitName" id="unitName" value="" readonly="readonly"/>
                                    &nbsp;&nbsp;
                                    <input class="button" type="button" name="search" id="search" value="<%=selectStr%>" onclick="return getEquipmentInPopup();"  STYLE="font-size:15;font-weight:bold;width:60px" />
                                </DIV>
                            </td>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="3" >
                                &ensp;
                            </TD>
                        </TR>
                        
                        <TR>
                            <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="3" >
                                &ensp;
                            </TD>
                        </TR>
                        
                        <TR>
                            <TD colspan="3" DIR="<%=dir%>" style="text-align:<%=align%>;font:bold 14px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE">
                                <input type="checkbox" name="withItems" id="withItems"/><%=withItemsStr%>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="3" >
                                &ensp;
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <TABLE BGCOLOR="#E8E8E8" ALIGN="center" DIR="<%=dir%>" WIDTH="60%" CELLSPACING=10 CELLPADDING=0 BORDER="0" style="display: block;">
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <button onclick="JavaScript: submitForm();" class="button" STYLE="font-size:15px;font-weight:bold; width: 150px"><%=search%></button>
                                &ensp;
                                <button class="button" onclick="JavaScript: cancelForm();" STYLE="font-size:15px;font-weight:bold; "><%=cancel%></button>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>
