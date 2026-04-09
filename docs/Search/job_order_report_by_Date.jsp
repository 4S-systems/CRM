<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
                //MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
                //IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();

                TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
                ArrayList mainTypeList = (ArrayList) request.getAttribute("mainTypeList");
                ArrayList tradeList = (ArrayList) request.getAttribute("tradeList");
                
                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;
                String lang, mainTypeRequiredMsg, unitRequiredMsg, tradeRequiredMsg, langCode, notAssignedStr, byUnitStr, selectStr, mainType, tradeName, selectAll, sCancel, search, align, bDate, eDate, sTitle, closed, open, canceled, Status, All;
                // get current defaultLocationName
                //String defaultLocationName = (String) request.getAttribute("defaultLocationName");
                //ArrayList allSites = (ArrayList) request.getAttribute("allSites");
                String site, dir;
                if (stat.equals("En")) {
                    bDate = "from";
                    eDate = "to";
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    sCancel = "Cancel";
                    langCode = "Ar";
                    canceled = "Canceled";
                    closed = "Closed";
                    All = "All";
                    open = "Open";
                    Status = "Status";
                    search = "Search";
                    sTitle = "Statistical Maintenance Report";
                    mainType = "By Main Type";
                    tradeName = "Maintenance Type";
                    site = "Site";
                    selectAll = "All";
                    selectStr = "Select";
                    byUnitStr = "By Equipment";
                    dir = "LTR";
                    align = "left";
                    notAssignedStr = "Not Assigned";
                    mainTypeRequiredMsg = "Select at lease one main type";
                    unitRequiredMsg = "Select a unit";
                    tradeRequiredMsg = "Select at least one trade";
                    
                } else {
                    bDate = "&#1605;&#1606;";
                    canceled = "ملغى";
                    All = "الكل";
                    Status = "الحالة";
                    closed = "منهى";
                    open = "مفتوح";
                    eDate = "&#1575;&#1604;&#1609;";
                    lang = "English";
                    sCancel = tGuide.getMessage("cancel");
                    langCode = "En";
                    search = "&#1576;&#1581;&#1579;";
                    sTitle = " تقرير الصيانة الإحصائى ";
                    mainType = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1606;&#1600;&#1600;&#1608;&#1593; &#1575;&#1604;&#1585;&#1574;&#1610;&#1600;&#1600;&#1587;&#1609;";
                    tradeName = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
                    site = "الموقع";
                    selectAll = "الكل";
                    byUnitStr = "&#1576;&#1600; &#1575;&#1604;&#1605;&#1593;&#1600;&#1600;&#1600;&#1583;&#1577;";
                    selectStr = "&#1573;&#1582;&#1578;&#1585;";
                    dir = "rtl";
                    align = "right";
                    notAssignedStr = "لم يبدأ بعد";
                    mainTypeRequiredMsg = "إختر نوع رئيسى واحد على الأقل";
                    unitRequiredMsg = "إختر معدة";
                    tradeRequiredMsg = "إختر نوع صيانة واحد على الأقل";
                    
                }

                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                String context = metaMgr.getContext();

                //get session logged user and his trades
                WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

                // get current date and Time
                Calendar cal = Calendar.getInstance();
                String jDateFormat = user.getAttribute("javaDateFormat").toString();
                SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
                String nowDate = sdf.format(cal.getTime());

    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    
        var dp_cal1,dp_cal12;      
        window.onload = function () {
            dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
            dp_cal12  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
        };
    
        function submitForm()
        {
            if (document.getElementById('site').value == "") {
                alert("Please Select Site");
                document.SEARCH_MAINTENANCE_FORM.site.foucs();
                return;
                
            } else if(document.getElementById('mainTypeRadio').checked && document.getElementById('maintype').value == "") {
                alert('<%=mainTypeRequiredMsg%>');
                document.SEARCH_MAINTENANCE_FORM.maintype.focus();
                return;

            } else if(document.getElementById('unitRadio').checked && document.getElementById('unitId').value == ""){
                alert('<%=unitRequiredMsg%>');
                document.SEARCH_MAINTENANCE_FORM.unitName.focus();
                return;

            } else if(document.getElementById('trade').value == "") {
                alert('<%=tradeRequiredMsg%>');
                document.SEARCH_MAINTENANCE_FORM.trade.focus();
                return;
                
            } else if (!compareDate()) {
                alert('End Date must be greater than or equal Begin Date');
                
            } else {
                document.SEARCH_MAINTENANCE_FORM.action = "<%=context%>/PDFReportServlet?op=jobOrderByIntervalDate";
                document.SEARCH_MAINTENANCE_FORM.submit();
            }
        }
        function cancelForm()
        {    
            document.SEARCH_MAINTENANCE_FORM.action = "<%=context%>/ReportsServlet?op=mainPage";
            document.SEARCH_MAINTENANCE_FORM.submit();  
        }
    
        function compareDate()
        {
            return Date.parse(document.getElementById("endDate").value) >= Date.parse(document.getElementById("beginDate").value);
        }
        function selectAllSites(optionListId,typeAllId){
            var length = document.getElementById(optionListId).options.length;
            var option = document.getElementById(optionListId).options;
            //window.SEARCH_MAINTENANCE_FORM.site.multiple = true;
            if(option[0].selected) {

                document.getElementById(typeAllId).value = "yes";
                siteAll = "yes";
                option[0].selected = false;
                for(var i = 1; i<length; i++){
                    option[i].selected = true;
                }
            } else {

                //window.SEARCH_MAINTENANCE_FORM.site.multiple = false;
                /*var selected = 0;
                var i = 0;
                for(i = 1; i<length; i++){
                    if(option[i].selected == true){
                        selected = i;
                        break;
                    }
                }
                for(i = 0; i<length; i++){
                    option[i].selected = false;
                }
                option[selected].selected = true;*/

                document.getElementById(typeAllId).value = "no";
            }
        }
        
        function showHide(id){
            var divUnit = document.getElementById('divUnit');
            var divMainType = document.getElementById('divMainType');
            if(id == 'mainTypeRadio') {
                divMainType.style.display = "block";
                divUnit.style.display = "none";
            } else if(id == 'unitRadio') {
                divUnit.style.display = "block";
                divMainType.style.display = "none";
            }
        }
        
        function selectAllElements(optionListId,typeAllId){
            var length = document.getElementById(optionListId).options.length;
            var option = document.getElementById(optionListId).options;
            if(option[0].selected) {
                document.getElementById(typeAllId).value = "yes";
                option[0].selected = false;
                for(var i = 1; i<length; i++){
                    option[i].selected = true;
                }
            } else {
                document.getElementById(typeAllId).value = "no";
            }
        }
    
    </SCRIPT>
    <BODY>


        <FORM NAME="SEARCH_MAINTENANCE_FORM" METHOD="POST">

            <DIV align="left" STYLE="color:blue;padding-left: 5%; padding-bottom: 10px">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript: submitForm();" class="button"><%=search%> <IMG VALIGN="BOTTOM" SRC="images/search.gif"> </button> <br>
            </DIV>
            <table align="center" width="90%">
                <tr><td class="td">
                        <fieldset >
                            <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <TR>
                                    <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;background-color: #ffcc66;" width="100%" class="blueBorder blueHeaderTD"><font color="#006699" size="4"><%=sTitle%></font></TD>
                                </TR>
                            </TABLE>

                            <table ALIGN="center" DIR="RTL" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                                
                                <TR>
                                    <td BGCOLOR="#999999" STYLE="border-left-WIDTH: 1;text-align:center;" WIDTH="50%">
                                        <b style="text-align:<%=align%>;padding-<%=align%> : 10px"><font size=3 color="white"><input type="radio" id="mainTypeRadio" value="maintype" name="selectEquip" checked onclick="JavaScript:showHide(this.id);" /><%=mainType%></font></b>
                                    </TD>
                                    <TD colspan="2" BGCOLOR="#E8E8E8" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="33%">
                                        <DIV ID="divMainType">
                                            <input type="hidden" id="allMainTypes" name="allMainTypes" value="no" />
                                            <select name="mainType" id="maintype" multiple size="5" style="font-size:12px; font-weight:bold; width:100%" onchange="selectAllElements(this.id, 'allMainTypes')">
                                                <option value="selectAll" style="color:#989898;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                                <sw:WBOOptionList wboList="<%=mainTypeList%>" displayAttribute="typeName" valueAttribute="id" />
                                            </select>
                                        </DIV>
                                    </TD>
                                </TR>
                                
                                <TR>
                                    <td BGCOLOR="#999999" STYLE="border-left-WIDTH: 1;text-align:center;" WIDTH="50%">
                                        <b><font size=3 color="white"><input type="radio" id="unitRadio" value="unitRadio" name="selectEquip" onclick="JavaScript:showHide(this.id);" /><%=byUnitStr%></font></b>
                                    </TD>
                                    <td colspan="2" style="text-align:<%=align%>;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;padding:5px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                        <DIV ID="divUnit" style="display: none;">
                                            <input type="hidden" name="unitId" value="" id="unitId" />
                                            <input type="text" name="unitName" id="unitName" value="" readonly="readonly"/>
                                            &nbsp;&nbsp;
                                            <input class="button" type="button" name="search" id="search" value="<%=selectStr%>" onclick="return getEquipmentInPopup();"  STYLE="font-size:15;font-weight:bold;width:60px" />
                                        </DIV>
                                    </td>
                                </TR>
                                
                                <TR>
                                    <td BGCOLOR="#999999" STYLE="border-left-WIDTH: 1;text-align:center;" WIDTH="50%">
                                        <b><font size=3 color="white"><%=tradeName%></font></b>
                                    </TD>
                                    <td colspan="2" style="text-align:<%=align%>;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;padding:5px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                        <input type="hidden" id="allTrades" name="allTrades" value="no" />
                                        <select name="trade" id="trade" onchange="selectAllElements(this.id,'allTrades');" multiple size="3" style="font-size:12px;font-weight:bold;width:100%">
                                            <option value="selectAll" style="color:#989898" ><%=selectAll%></option>
                                            <sw:WBOOptionList wboList="<%=tradeList%>" displayAttribute="tradeName" valueAttribute="tradeId" />
                                        </select>
                                    </TD>
                                </TR>
                                
                                <tr>

                                    <td rowspan="2" BGCOLOR="#999999" STYLE="border-left-WIDTH: 1;text-align:center;" WIDTH="50%">
                                        <b><font size=3 color="white"> <%=site%></font></b>
                                    </td>
                                    <td colspan="2" rowspan="2" style="text-align:right" bgcolor="#e8e8e8"  valign="MIDDLE" >
                                        <div id='projectScroll' style="width:100%; height: 200px; overflow:auto;">
                                            <jsp:include page="/docs/new_search/project_checkbox_list.jsp" flush="true"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr></tr>
                                <tr>

                                    <td  BGCOLOR="#999999" STYLE="border-left-WIDTH: 1;text-align:center;" WIDTH="50%">
                                        <b><font size=3 color="white"> <%=bDate%></font></b>
                                    </td>
                                    <td   BGCOLOR="#999999"  STYLE="border-left-WIDTH: 1;text-align:center;" WIDTH="50%">
                                        <b> <font size=3 color="white"> <%=eDate%></font></b>
                                    </td>
                                    <td   BGCOLOR="#999999"  STYLE="border-left-WIDTH: 1;text-align:center;" WIDTH="50%"> <b> <font size=3 color="white"><%=Status%></font></b></td>
                                </tr>
                                <tr>

                                    <td style="text-align:right" bgcolor="#e8e8e8"  valign="MIDDLE" >
                                        <%
                                                    String url = request.getRequestURL().toString();
                                                    String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                                                    Calendar c = Calendar.getInstance();
                                        %>

                                        <input id="beginDate" name="beginDate" type="text" value="<%=nowDate%>"><img src="images/showcalendar.gif" > 

                                        <br><br>
                                    </td>

                                    <td  bgcolor="#e8e8e8"  style="text-align:right" valign="middle">

                                        <input id="bendDate" name="endDate" type="text" value="<%=nowDate%>"><img src="images/showcalendar.gif" > 
                                        <br><br>
                                    </td>
                                    <td  bgcolor="#e8e8e8"  style="text-align:right" valign="middle"><table width="183">
                                            <tr>
                                                <td width="86" nowrap><label>
                                                        <input type="radio" name="currenStatus" value="Assigned" checked="checked" id="currenStatus">
                                                        <%=open%></label></td>
                                                <td width="85" nowrap><label>
                                                        <input type="radio" name="currenStatus" value="Finished" id="currenStatus">
                                                        <%=closed%></label></td>
                                            </tr>
                                            <tr>

                                                <td nowrap><label>
                                                        <input type="radio" name="currenStatus" value="a" id="currenStatus">
                                                        <%=canceled%></label></td>
                                                <td nowrap><label>
                                                        <input type="radio" name="currenStatus" value="Schedule" id="currenStatus">
                                                        <%=notAssignedStr%></label></td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" nowrap><label>
                                                    <input type="radio" name="currenStatus" value="all" id="currenStatus">
                                                    <%=All%></label></td>
                                            </tr>
                                        </table></td>

                                </tr>

                                <tr>
                                <br><br>
                                <td STYLE="text-align:center" CLASS="td" colspan="4">
                                    <DIV align="left" STYLE="color:blue;padding-left: 0%; padding-bottom: 10px">
                                        <button  onclick="JavaScript: submitForm();" class="button"><%=search%> <IMG VALIGN="BOTTOM" SRC="images/search.gif"> </button> <br>
                                    </DIV>
                                </td>
                                </tr>
                            </table>

                        </fieldset>

                </tr></table>
        </FORM>
    </BODY>
</HTML>     
