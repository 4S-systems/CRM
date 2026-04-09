<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.maintenance.common.ConfigFileMgr" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<HTML>

    <%
                TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
                MetaDataMgr metaMgr = MetaDataMgr.getInstance();
                String context = metaMgr.getContext();

                // get all need data
                ArrayList allMainType = (ArrayList) request.getAttribute("allMainType");
                ArrayList parents = (ArrayList) request.getAttribute("parents");
                ArrayList departments = (ArrayList) request.getAttribute("departments");
                ArrayList productionLines = (ArrayList) request.getAttribute("productionLines");

                //get session logged user and his trades
                WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

                // get defaultLocationName

                // get current date
                Calendar cal = Calendar.getInstance();
                String jDateFormat = user.getAttribute("javaDateFormat").toString();
                SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
                String nowTime = sdf.format(cal.getTime());

                String cMode = (String) request.getSession().getAttribute("currentMode");
                String stat = cMode;

                String withDepartments, beginDate, byProduction, byDepartments, detailed, endDate, search, cancel, calenderTip, nameEquip, mainType, site, divAlign,
                        dir, lang, langCode, title, selectAll, select, back, unit, withBrand, withMainType, notEmergancy, brand , show , pageTitle ,pageTitleTip;

                if (stat.equals("En")) {
                    lang = "   &#1593;&#1585;&#1576;&#1610;    ";
                    langCode = "Ar";
                    unit = "With Units";
                    dir = "LTR";
                    divAlign = "left";
                    detailed = "Detailed";
                    withDepartments = "With Departments";
                    beginDate = "From Date";
                    endDate = "To Date";
                    search = "Export Report";
                    cancel = "Cancel";
                    calenderTip = "click inside text box to opn calender window";
                    nameEquip = "By Equipment";
                    site = "Site";
                    mainType = "By Main Type";
                    brand = "By Brand";
                    title = "Spare Parts By Equipment";
                    selectAll = "All";
                    select = "Select";
                    back = "Back";
                    withBrand = "With Brands";
                    withMainType = "With Main Types";
                    notEmergancy = "Periodic";
                    byDepartments = "By Departments";
                    byProduction = "By Production Line";
                    show="Show Details";
                    pageTitle ="RPT-EQP-MI-14" ;
                    pageTitleTip ="Equipment Maintenance Item Report";
                } else {
                    lang = "   English    ";
                    langCode = "En";
                    unit = "&#1605;&#1593; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
                    dir = "RTL";
                    divAlign = "right";
                    detailed = "&#1578;&#1601;&#1589;&#1610;&#1604;&#1610;";
                    withDepartments = "&#1605;&#1593; &#1575;&#1604;&#1575;&#1602;&#1587;&#1575;&#1605;";
                    beginDate = "&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
                    endDate = "&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
                    search = "&#1575;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
                    cancel = tGuide.getMessage("cancel");
                    calenderTip = "&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
                    site = "&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
                    mainType = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1606;&#1600;&#1600;&#1608;&#1593; &#1575;&#1604;&#1585;&#1574;&#1610;&#1600;&#1600;&#1587;&#1609;";
                    brand = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1605;&#1600;&#1600;&#1600;&#1575;&#1585;&#1603;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1577;";
                    nameEquip = "&#1576;&#1600;&#1600;&#1600; &#1575;&#1604;&#1605;&#1600;&#1600;&#1600;&#1600;&#1593;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1583;&#1577;";
                    selectAll = "&#1603;&#1600;&#1600;&#1600;&#1604;";
                    select = "&#1575;&#1582;&#1578;&#1610;&#1575;&#1585;";
                    back = "&#1585;&#1580;&#1608;&#1593;";
                    title = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607; ";
                    withBrand = "&#1605;&#1593; &#1575;&#1604;&#1605;&#1575;&#1585;&#1603;&#1575;&#1578;";
                    withMainType = "&#1605;&#1593; &#1575;&#1604;&#1575;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1585;&#1574;&#1610;&#1587;&#1610;&#1577;";
                    notEmergancy = "&#1583;&#1608;&#1585;&#1610;&#1577;";
                    byDepartments = "&#1576;&#1600;&#1600; &#1575;&#1604;&#1571;&#1602;&#1587;&#1575;&#1605;";
                    byProduction = "&#1576;&#1600; &#1582;&#1591; &#1575;&#1604;&#1571;&#1606;&#1578;&#1575;&#1580;";
                    show="&#1593;&#1585;&#1590; &#1575;&#1604;&#1578;&#1601;&#1575;&#1589;&#1610;&#1604;";
                    pageTitle ="RPT-EQP-MI-14" ;
                    pageTitleTip="&#1578;&#1602;&#1585;&#1610;&#1585; &#1593;&#1585;&#1590; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1590;&#1610;&#1575;&#1606;&#1607; &#1576;&#1575;&#1604;&#1606;&#1587;&#1576;&#1607; &#1604;&#1605;&#1593;&#1583;&#1607; &#1605;&#1593;&#1610;&#1606;&#1607;";
                    }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <script type="text/javascript" src="js/tip_centerwindow.js"></script>
        <script type="text/javascript" src="js/tip_balloon.js"></script>
        <script type="text/javascript" src="js/tip_followscroll.js"></script>
        <script type="text/javascript">
            var dp_cal1 = null;
            var dp_cal2 = null;
            var chaild_window;
            var sitesValues = "";
            window.onload = function (){
                if(dp_cal1 == null && dp_cal2 == null) {
                    dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
                    dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
                }
            }

            function submitForm(){
                if (!compareDate()){
                    alert('End Date must be greater than or equal Begin Date');
                    document.SEARCH_MAINTENANCE_FORM.end.focus();
                    return;
               
              
                } else if(document.getElementById('unit').checked && document.getElementById('unitId').value == ""){
                    alert('Please Select Unit');
                    document.getElementById('unitId').focus();
                    return;
                }
                document.SEARCH_MAINTENANCE_FORM.action = "PDFReportServlet?op=sparePartsReport";
                openCustom('');
                document.SEARCH_MAINTENANCE_FORM.target="window_chaild";
                document.SEARCH_MAINTENANCE_FORM.submit();
            }

            function back()
            {
                document.SEARCH_MAINTENANCE_FORM.target="";
                document.SEARCH_MAINTENANCE_FORM.action = "<%=context%>/ReportsServlet?op=startReport#";
                document.SEARCH_MAINTENANCE_FORM.submit();
            }

            function compareDate()
            {
                return Date.parse(document.getElementById("endDate").value) >= Date.parse(document.getElementById("beginDate").value);
            }

            function textChange(textBox){
                document.getElementById(textBox).value = "";
            }

            function getEquipment(){
                var formName = document.getElementById('SEARCH_MAINTENANCE_FORM').getAttribute("name");
                var name = document.getElementById('unitName').value;
                var res = "";
                for (i=0;i < name.length; i++) {
                    res += name.charCodeAt(i) + ',';
                }
                res = res.substr(0, res.length - 1);
                openCustom('ReportsServlet?op=listEquipment&unitName='+res+'&formName='+formName);
            }

            function openCustom(url)
            {
                openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
            }

            function showHide(eleId,radioId){
                document.getElementById(eleId).style.display = 'block';
                document.getElementById('reportType').value = radioId;
                if(radioId == 'mainTypeRadio'){
                    document.getElementById('department').style.display = 'none';
                    document.getElementById('brand').style.display = 'none';
                    document.getElementById('production').style.display = 'none';
                    document.getElementById('divUnit').style.display = 'none';
                    document.getElementById('reportData').disabled = false;
                    document.getElementById('with2').disabled = false;
                    document.getElementById('with3').disabled = true;
                    document.getElementById('with4').disabled = true;
                }else if(radioId == 'DepartmentRadio'){
                    document.getElementById('maintype').style.display = 'none';
                    document.getElementById('brand').style.display = 'none';
                    document.getElementById('production').style.display = 'none';
                    document.getElementById('divUnit').style.display = 'none';
                    document.getElementById('reportData').disabled = false;
                    document.getElementById('with2').disabled = false;
                    document.getElementById('with3').disabled = false;
                    document.getElementById('with4').disabled = true;
                }else if(radioId == 'brandRadio'){
                    document.getElementById('maintype').style.display = 'none';
                    document.getElementById('department').style.display = 'none';
                    document.getElementById('production').style.display = 'none';
                    document.getElementById('divUnit').style.display = 'none';
                    document.getElementById('reportData').disabled = false;
                    document.getElementById('with2').disabled = true;
                    document.getElementById('with3').disabled = false;
                    document.getElementById('with4').disabled = true;
                }else if(radioId == 'ProductionRadio'){
                    document.getElementById('maintype').style.display = 'none';
                    document.getElementById('department').style.display = 'none';
                    document.getElementById('brand').style.display = 'none';
                    document.getElementById('divUnit').style.display = 'none';
                    document.getElementById('reportData').disabled = false;
                    document.getElementById('with2').disabled = false;
                    document.getElementById('with3').disabled = false;
                    document.getElementById('with4').disabled = false;
                }else if(radioId == 'unit'){
                    document.getElementById('maintype').style.display = 'none';
                    document.getElementById('department').style.display = 'none';
                    document.getElementById('brand').style.display = 'none';
                    document.getElementById('production').style.display = 'none';
                    document.getElementById('reportData').disabled = true;
                    document.getElementById('reportData').checked = false;
                    document.getElementById('options').style.display = 'none';
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
                }
            }

            function displayOptions(){
                if(document.getElementById("reportData").checked){
                    document.getElementById("options").style.display = "block";
                }
                else
                {
                    document.getElementById("options").style.display = "none";
                }



            }



       function openWindow(url) {

            openCustomDialog(url, "toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=750, height=400");
        }

          function getFormDetails() {
            openWindow('ReportsServletThree?op=getFormDetails&formCode=SPARE-PARTS');
        }
        </script>
        <style type="css/text">
            .backStyle{
                border-bottom-width:0px;
                border-left-width:0px;
                border-right-width:0px;
                border-top-width:0px
            }
        </style>
    </HEAD>
    <BODY STYLE="background-color:#E8E8E8">
        <FORM NAME="SEARCH_MAINTENANCE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;padding-left: 5%; padding-bottom: 10px">
                <input type="button"  value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button onclick="JavaScript:back();" class="button"><%=back%></button>
                &ensp;
                <button name="formDetails" class="button" onclick="getFormDetails()" >
                <%=show%>
                </button>
            </DIV>
                    <div dir="left">
                                  <table>
                                      <tr>
                                          <td>
                                              <font color="#FF385C" size="4"  >
                                                  <a id="mainLink"  onmouseover="Tip('<%=pageTitleTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=pageTitleTip%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=pageTitle%></a>
                                              </font>
                                          </td>
                                      </tr>
                                  </table>
                         </div>

            <CENTER>
                <FIELDSET class="set" style="width:90%;border-color: #006699;" >
                    <TABLE class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD dir="<%=dir%>" style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><font color="#F3D596" size="4"><%=title%></font></TD>
                        </TR>
                    </TABLE>
                    <TABLE id="Others" BGCOLOR="#E8E8E8" ALIGN="center" DIR="<%=dir%>" WIDTH="90%" CELLSPACING=5 CELLPADDING=0 BORDER="0" style="display: block;">
                        
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black">
                                 <input type="radio" id="unit" value="divUnit" name="selectType" onclick="JavaScript:showHide(this.value,this.id);" /><%=nameEquip%></font></b>
                   
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <DIV ID="divUnit" style="display: none;">
                                    <input type="text" name="unitName" id="unitName" onchange="JavaScript:textChange('unitId')" style="width:60%;text-align:center" />

                                    <input class="button" type="button" name="search" id="search" value="<%=select%>" onclick="JavaScript:getEquipment()" STYLE="height: 25px;font-size:15px;color:black;font-weight:bold;width:60px" />
                                    <input type="hidden" name="unitId" id="unitId" />
                                </DIV>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" WIDTH="2%">
                                &ensp;
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b><font size=3 color="black"><%= beginDate%></font></b>
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <input readonly id="beginDate" name="beginDate" type="text" value="<%=nowTime%>" style="width:90%" /><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'black', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" />
                            </TD>
                            <TD class="backgroundHeader" STYLE="text-align:center;padding:5px" WIDTH="13%">
                                <b> <font size=3 color="black"><%= endDate%></font> </b>
                            </TD>
                            <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <input readonly id="endDate" name="endDate" type="text" value="<%=nowTime%>" style="width:90%" /><img alt=""  src="images/showcalendar.gif" onmouseover="Tip('<%=calenderTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#FFFF99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7, TITLE ,'Display Calender Help',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'black', TITLEBGCOLOR ,'#6699FF')" onmouseout="UnTip()" />
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>

                        <TR id="options" style="display: none;">
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" colspan="5">
                                <input checked type="radio" id="with1" name="with" value="units" />&nbsp;<b style="font-size: small;"><%=unit%></b>
                                &nbsp;
                                <input type="radio" name="with" id="with2" value="brands" />&nbsp;<b style="font-size: small;"><%=withBrand%></b>
                                &nbsp;
                                <input disabled type="radio" name="with" id="with3" value="mainTypes" />&nbsp;<b style="font-size: small;"><%=withMainType%></b>
                                &nbsp;
                                <input disabled type="radio" name="with" id="with4" value="departments" />&nbsp;<b style="font-size: small;"><%=withDepartments%></b>
                            </TD>
                        </TR>
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" COLSPAN="5" >
                                &ensp;
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <TABLE BGCOLOR="#E8E8E8" ALIGN="center" DIR="<%=dir%>" WIDTH="90%" CELLSPACING=10 CELLPADDING=0 BORDER="0" style="display: block;">
                        <TR>
                            <TD style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#E8E8E8"  valign="MIDDLE" >
                                <button onclick="JavaScript: submitForm();" class="button" STYLE="font-size:15px;font-weight:bold; width: 150px"><%=search%></button>
                                &ensp;
                                <button class="button" onclick="JavaScript: back();" STYLE="font-size:15px;font-weight:bold; "><%=cancel%></button>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>
