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
ConfigFileMgr configFileMgr = new ConfigFileMgr();
String defualtDay = configFileMgr.getUpdateEquipmentSince();
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

String source = (String) request.getAttribute("source");
boolean popUp = true;
if(source != null) {
    if(!source.equalsIgnoreCase("null") && !source.equalsIgnoreCase("")) {
        popUp = false;
    }
}

// get all need data
Vector allSites = (Vector) request.getAttribute("allSites");
ArrayList allBrand = (ArrayList) request.getAttribute("allBrand");
ArrayList allMainType = (ArrayList) request.getAttribute("allMainType");

//get session logged user and his trades
WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

// get current date
Calendar cal = Calendar.getInstance();
String jDateFormat=user.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowTime=sdf.format(cal.getTime());

String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
String lang,langCode,back,search,cancel,calenderTip,selectAll,addEquip,site,type,
            brand,equip,title,align,dir,equipCode,equipName,selectEquip,defualt,custom,day,equipKm,equipHr,delete,divAlign , pageTitle , pageTitleTip;

    if (stat.equals("En")) {
            lang="   &#1593;&#1585;&#1576;&#1610;    ";
            langCode= "Ar";
            back = "Back";
            divAlign = "right";
            align="center";
            dir="LTR";
            search="Export Report";
            cancel="Cancel";
            calenderTip = "click inside text box to opn calender window";
            selectAll = "All";
            addEquip = "Add Equipments";
            site = "By Site";
            equip = "Equipments";
            brand = "By Brand";
            title = "Report View Equipments With Reading";
            equipCode = "Equipment Code";
            equipName = "Equipment Name";
            selectEquip = "Selective Equipments";
            type = "By Main Type";
            defualt = "Defualt Interval";
            custom = "Custom Value for Interval";
            equipHr = "Equipment Hr";
            equipKm = "Equipment Km";
            day = "Day";
            delete = "Delete";
            pageTitle="RPT-EQP-RDNG-13";
            pageTitleTip="Equipment Reading Report";

        }else{
            lang="English";
            langCode="En";
            back = "&#1585;&#1580;&#1608;&#1593;";
            divAlign = "left";
            align="center";
            dir="RTL";
            search="&#1575;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
            calenderTip="&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
            cancel="&#1593;&#1608;&#1583;&#1607;";
            selectAll = "&#1575;&#1604;&#1603;&#1604;";
            addEquip = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1605;&#1593;&#1583;&#1575;&#1578;";
            site = "&#1576;&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
            equip = "&#1605;&#1593;&#1583;&#1575;&#1578;";
            brand = "&#1576;&#1575;&#1604;&#1605;&#1575;&#1585;&#1603;&#1577;";
            title = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1593;&#1585;&#1590; &#1602;&#1585;&#1575;&#1569;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
            equipName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
            equipCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
            selectEquip = "&#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1575;&#1604;&#1605;&#1582;&#1578;&#1575;&#1585;&#1577;";
            type = "&#1576;&#1575;&#1604;&#1606;&#1608;&#1593; &#1575;&#1587;&#1575;&#1587;&#1609;";
            defualt = "&#1575;&#1604;&#1601;&#1578;&#1585;&#1577; &#1575;&#1604;&#1571;&#1601;&#1578;&#1585;&#1575;&#1590;&#1610;&#1577;";
            day = "&#1610;&#1608;&#1605;";
            equipHr = "&#1605;&#1593;&#1583;&#1577; &#1576;&#1575;&#1604;&#1587;&#1575;&#1593;&#1577;";
            equipKm = "&#1605;&#1593;&#1583;&#1577; &#1576;&#1575;&#1604;&#1603;&#1610;&#1604;&#1608;&#1605;&#1578;&#1585;";
            custom = "&#1602;&#1610;&#1605;&#1577; &#1575;&#1582;&#1578;&#1610;&#1575;&#1585;&#1610;&#1577; &#1604;&#1604;&#1601;&#1578;&#1585;&#1577;";
            delete = "&#1581;&#1584;&#1601;";
            pageTitle="RPT-EQP-RDNG-13";
            pageTitleTip="&#1578;&#1602;&#1585;&#1610;&#1585; &#1593;&#1585;&#1590; &#1602;&#1585;&#1575;&#1569;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; ";

        }

%>

<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>Doc Viewer - Select Maintenance Details</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
    <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
    <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
    <script type="text/javascript" src="js/epoch_classes.js"></script>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <script type="text/javascript" src="js/wz_tooltip.js"></script>
    <script type="text/javascript" src="js/tip_centerwindow.js"></script>
    <script type="text/javascript" src="js/tip_balloon.js"></script>
    <script type="text/javascript" src="js/tip_followscroll.js"></script>
</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    window.onload = function (){
        showHide('typeRadio');
    }

    function reloadAE(nextMode){
        var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;

        if (window.XMLHttpRequest){
            req = new XMLHttpRequest();
        } else if (window.ActiveXObject) {
            req = new ActiveXObject("Microsoft.XMLHTTP");
        }

        req.open("Post",url,true);
        req.onreadystatechange =  callbackFillreload;
        req.send(null);
    }

    function callbackFillreload(){
        if (req.readyState==4) {
            if (req.status == 200) {
                window.location.reload();
            }
        }
    }

    function submitForm() {
        var sitesValues = getSites();
        var idsValues = getIds();
        var brandValues = getBrands();
        var maintypeValues = getMaintype();
        var typeOfRateValues = getTypes();
        var interval = "";
        var brandAll = "no";
        var siteAll = "no";
        var mainTypeAll = "no";

        if( document.getElementById('custom').checked && !validateData("req", document.SEARCH_MAINTENANCE_FORM.customDay, "Must Enter Interval")){
            document.SEARCH_MAINTENANCE_FORM.customDay.focus();
        } else if (!validateData("num", document.SEARCH_MAINTENANCE_FORM.customDay, "Error Number")){
            document.SEARCH_MAINTENANCE_FORM.customDay.focus();
        } else if(document.getElementById('equipRadio').checked && idsValues == ""){
            alert("Must Enter Equipments");
        } else if(typeOfRateValues == ""){
            alert("Must Select Type Of Reate"+typeOfRateValues+" #");
        } else {
            if(document.getElementById('brand').options[0].selected){
                    brandAll = "yes";
            }
            if(document.getElementById('maintype').options[0].selected){
                mainTypeAll = "yes";
            }

            var url = "<%=context%>/ReportsServletThree?op=resultSearchEquipmentsNotUpdated&typeOfRateValues=" + typeOfRateValues + "&sites=" + sitesValues;
            
            if(document.getElementById('custom').checked){
                interval = document.getElementById('customDay').value;
            }else{
                interval = document.getElementById('defualtDay').value;
            }
            
            url = url + "&interval=" + interval + "&siteAll=" + siteAll;
            
            if(document.getElementById('typeRadio').checked){
                url = url + "&type=" + maintypeValues + "&mainFilter=" + mainTypeAll;
            }else if(document.getElementById('brandRadio').checked){
                url = url + "&brand=" + brandValues + "&mainFilter=" + brandAll;
            }else{
                url = url + "&ids=" + idsValues + "&mainFilter=no";
            }
            if(<%=popUp%>) {
            //var setting = "dialogHeight:600px;dialogWidth:800px;resizable:yes";
            //window.showModalDialog(url,"", setting);
            openWindow(url);
            } else {
                document.SEARCH_MAINTENANCE_FORM.action = url;
                document.SEARCH_MAINTENANCE_FORM.submit();

            }
        }
    }
     function cancelForm()
    {
        document.SEARCH_MAINTENANCE_FORM.action = "<%=context%>/main.jsp;";
        document.SEARCH_MAINTENANCE_FORM.submit();
    }

    function back()
    {
        document.SEARCH_MAINTENANCE_FORM.action = "<%=context%>/ReportsServlet?op=mainPage";
        document.SEARCH_MAINTENANCE_FORM.submit();
    }

    function textChange(textBox){
        textBox.value = "";
    }

    function getTypes(){
       
         var typeOfRateValues = "";
            var type = document.SEARCH_MAINTENANCE_FORM.type;
            
            for(var i = 0; i < type.length; i++){
                if(type[i].checked){    
                   typeOfRateValues = typeOfRateValues + type[i].value + " ";
                }
            }
            return typeOfRateValues;
     }

     function getEquipment(){
        var sitesValues = getSites();
        var idsValues = getIds();
       if(sitesValues != ""){
            var formName = document.getElementById('SEARCH_MAINTENANCE_FORM').getAttribute("name");
            openWindow('ReportsServletThree?op=selectEquipments&formName='+formName+'&sites='+sitesValues+'&idsValues='+idsValues);
        }else{
            alert("Must select at least one Site");
        }

     }

     function getIds(){
         var idsValues = "";
         var ids = document.getElementsByName('unitId');
         if(ids != null){
                for(var i = 0; i < ids.length; i++){
                    idsValues = idsValues + ids[i].value + " ";
                }
            }
            return idsValues;
     }

 

     function getBrands(){
            var brandValues = "";
            var brans = document.getElementById('brand');
               for(var i = 0 ;i<brans.options.length;i++){
                    if(brans.options[i].selected){
                        brandValues = brandValues  + brans.options[i].value + " ";
                    }
                }
            return brandValues;
     }
     
     function getMaintype(){
            var maintypeValues = "";
            var maintype = document.getElementById('maintype');
            if(maintype.options[0].selected){
                
                return getAllMaintype();
                
            }
               for(var i = 0 ;i<maintype.options.length;i++){
                    if(maintype.options[i].selected){
                        maintypeValues = maintypeValues  + maintype.options[i].value + " ";
                    }
                }
            return maintypeValues;
     }
     
    function getAllMaintype(){
            var maintypeValues = "";
            var maintype = document.getElementById('maintype');
               for(var i = 1 ;i<maintype.options.length;i++){
                        maintypeValues = maintypeValues  + maintype.options[i].value + " ";
                }

            return maintypeValues;
     }



    function openWindow(url)
    {
        window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
    }
    
    function showHide(id){
        var divUnit = document.getElementById('divEquip');
        var divMainType = document.getElementById('divType');
        var divBrand = document.getElementById('divBrand');
        if(id == 'typeRadio'){
            divMainType.style.display = "block";
            divUnit.style.display = "none";
            divBrand.style.display = "none";
        } else if(id == 'brandRadio'){
            divBrand.style.display = "block";
            divMainType.style.display = "none";
            divUnit.style.display = "none";
        } else{
            divUnit.style.display = "block";
            divMainType.style.display = "none";
            divBrand.style.display = "none";
        }
    }

    function enable(id){
        if(id == 'defualt'){
            document.getElementById("customDay").disabled = true;
            document.getElementById("customDay").value = "";
        }else{
            document.getElementById("customDay").disabled = false;
            document.SEARCH_MAINTENANCE_FORM.customDay.focus();
        }
    }

    function trim(str) {
        return str.replace(/^\s+|\s+$/g,"");
    }

    function checkAll(){
        var checkAll = document.getElementById('checkA');
        if(checkAll.checked){
            selectAll();
        }else{
            deSelectAll();
        }
    }

    function selectAll(){
        var check = document.getElementsByName('check');
        if(check != null){
            for(var i = 0; i<check.length; i++){
                check[i].checked = true;
            }
        }
    }

    function deSelectAll(){
        var check = document.getElementsByName('check');
        if(check != null){
            for(var i = 0; i<check.length; i++){
                check[i].checked = false;
            }
        }
    }

    function Delete(){
        var table = document.getElementById('equipmentList');
        var check = document.getElementsByName('check');
        if(check != null){
            for(var i = 0; i<check.length; i++){
               // alert("table length = " + table.rows.length + "check length = " + check.length + "\n i = " + i)
                 if(check[i].checked){
                     table.deleteRow(i + 2);
                     i--;
                 }
            }
            if(check.length == 0){
                document.getElementById('checkA').checked = false;
            }
        }
    }

 </SCRIPT>
<style type="css/text" >
    .backStyle{
        border-bottom-width:0px;
        border-left-width:0px;
        border-right-width:0px;
        border-top-width:0px
    }
    .thead
       {
            color:black;
            font:14px;
            border-left-width:1px;
            height:50px;
            border-color:black;
            font-weight:bold;
            padding:5px
       }
       .row
        {
            background:white;
            color:black;
            font:12px;
            height:25px;
            text-align:center;
            border-color:black;
            font-weight:lighter;
            padding:2px;
            border-bottom-width:1px;border-left-width:0px;border-right-width:0px;border-top-width:0px
        }
    .noBorders{
        border-bottom-width:1px;
        border-left-width:0px;
        border-right-width:0px;
        border-top-width:0px
    }
    
</style>
<BODY STYLE="background-color:#F8F8F8">
    <script type="text/javascript" src="js/wz_tooltip.js"></script>
    <FORM NAME="SEARCH_MAINTENANCE_FORM" METHOD="POST">
    <input type="hidden" name="search" value="search" />
    <input type="hidden" name="source" value="<%=source%>" />
    <DIV DIR="LTR" style="padding-left:50px;padding-right:50px" >
        <input type="button" class="button"  value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
           
        <button onclick="JavaScript:back();" class="button" > <%=back%> </button>
    </DIV>
    <br>
       <div dir="left">
        <table>
            <tr>
                <td>
                    <font color="#FF385C" size="3">
                        <a id="mainLink"  onmouseover="Tip('<%=pageTitleTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=pageTitleTip%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=pageTitle%></a>
                    </font>
                </td>
            </tr>
        </table>
          </div>
    <CENTER>
        <fieldset class="set" style="border-color:teal">
            <legend align="center" >
                <table dir="rtl" align="center">
                    <tr>
                        <td class="td">
                            <font color="blue" style="font-weight:bold;font-size:22px"><%=title%></font>
                        </td>
                    </tr>
                </table>
            </legend>

                     


            <TABLE ALIGN="center" DIR="<%=dir%>" WIDTH="83%" CELLSPACING=0 CELLPADDING=0 BORDER="0">
                <TR>
                    <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#F8F8F8"  valign="MIDDLE" COLSPAN="5" >
                        &ensp;
                    </TD>
                </TR>
                <TR>
                    <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#F8F8F8"  valign="MIDDLE" WIDTH="2%">
                        &ensp;
                    </TD>
                    <TD BGCOLOR="#D0D0D0" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="15%">
                        <input type="radio" name="radioMain" id="typeRadio" value="0" onclick="JavaScript:showHide(this.id);" checked /><b><font size=3 color="blue"><%=type%></font></b>
                    </TD>
                    <TD BGCOLOR="#F8F8F8" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="35%">
                        <DIV ID="divType">
                            <select name="mainType" id="maintype" multiple size="5" style="font-size:12px;font-weight:bold;width:200px">
                                    <option value="selectAll" selected style="color:silver;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                    <sw:WBOOptionList wboList="<%=allMainType%>" displayAttribute="typeName" valueAttribute="id" />
                            </select>
                        </DIV>
                    </TD>
                    <TD BGCOLOR="#D0D0D0" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="15%" ROWSPAN="2">
                        <b><font size=3 color="blue"><%=site%></font></b>
                    </TD>
                    <TD BGCOLOR="#F8F8F8" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="35%" ROWSPAN="2">
                        <div id='projectScroll' style="width:103%; height: 200px; overflow:auto;">
                                <jsp:include page="/docs/new_search/project_checkbox_list.jsp" flush="true"/>
                        </div>
                    </TD>
                </TR>
                <TR>
                    <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#F8F8F8"  valign="MIDDLE" WIDTH="2%">
                        &ensp;
                    </TD>
                    <TD BGCOLOR="#D0D0D0" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="15%">
                        <input type="radio" name="radioMain" id="brandRadio" value="1" onclick="JavaScript:showHide(this.id);" /><b><font size=3 color="blue"><%=brand%></font></b>
                    </TD>
                    <TD BGCOLOR="#F8F8F8" STYLE="border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;text-align:center;padding:5px" WIDTH="35%">
                        <DIV ID="divBrand">
                            <select name="brand" id="brand" multiple size="10" style="font-size:12px;font-weight:bold;width:200px">
                                    <option value="selectAll" selected style="color:silver;font-weight:bold;font-size:16px"><%=selectAll%></option>
                                    <sw:WBOOptionList wboList="<%=allBrand%>" displayAttribute="parentName" valueAttribute="parentId" />
                            </select>
                        </DIV>
                    </TD>
                </TR>
                <TR>
                    <TD CLASS="backStyle" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#F8F8F8"  valign="MIDDLE" COLSPAN="5" >
                        &ensp;
                    </TD>
                </TR>
                <TR>
                    <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#F8F8F8"  valign="MIDDLE" >
                        &ensp;
                    </TD>
                    <TD BGCOLOR="#D0D0D0" STYLE="border-left-WIDTH:1px;text-align:center;padding:5px" WIDTH="15%">
                        <input type="radio" name="radioMain" id="equipRadio" value="2" onclick="JavaScript:showHide(this.id);" /><B><font size=3 color="blue"><%=selectEquip%></font></B>
                    </TD>
                    <TD style="text-align:center;font:bold 15px;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#F8F8F8"  valign="MIDDLE" COLSPAN="3" >
                        &ensp;
                    </TD>
                </TR>
                <TR>
                    <TD BGCOLOR="#F8F8F8" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px">
                        &ensp;
                    </TD>
                    <TD BGCOLOR="#F8F8F8" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" COLSPAN="3">
                        <DIV ID="divEquip" >
                            <TABLE ID="equipmentList" BGCOLOR="#F8F8F8" ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" CELLPADDING="0px" >
                                <TR STYLE="background-color:#F8F8F8">
                                    <TD nowrap STYLE="font-weight:bold;color:blue;font-size:18px;text-align:center;border-bottom-width:0px;border-left-width:0px;border-top-width:0px" COLSPAN="2" >
                                        <br><B><%=selectEquip%></B>
                                    </TD>
                                </TR>
                                <TR STYLE="background-color:#D0D0D0">
                                    <TD nowrap STYLE="font-weight:bold;color:blue;font-size:16px" >
                                        <B><%=equipCode%></B>
                                    </TD>
                                    <TD  nowrap STYLE="font-weight:bold;color:blue;font-size:16px" >
                                        <B><%=equipName%></B>
                                    </TD>
                                    <TD  nowrap STYLE="font-weight:bold;color:blue;font-size:16px;width:100px" >
                                        <input type="checkbox" name="checkA" id="checkA" onclick="JavaScript:checkAll();" />
                                    </TD>
                                </TR>
                            </TABLE>
                            <DIV align="<%=divAlign%>">
                                <input type="button" name="delete" id="delete" value="<%=delete%>" onclick="JavaScript:Delete()" STYLE="background:#989898;font-size:15;color:blue;font-weight:bold;width:100px;padding-top:2px;width:100px" />
                            </DIV>
                            <div align="center">
                                <input type="button" name="search" id="search" value="<%=addEquip%>" onclick="JavaScript:getEquipment()" STYLE="background:#989898;font-size:15;color:blue;font-weight:bold;width:150px;padding-top:2px" />
                            </div>
                        </DIV>
                    </TD>
                    <TD BGCOLOR="#F8F8F8" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px">
                        &ensp;
                    </TD>
                </TR>
                <TR>
                    <TD dir="<%=dir%>" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#F8F8F8"  valign="MIDDLE" COLSPAN="3" >
                        <DIV ALIGN="RIGHT" STYLE="padding-left:10px;padding-bottom:5px;padding-right:25px">
                            <font size=3 color="blue" style="font-weight:bold"><%=equipHr%></font><input type="checkbox" name="equipHr" id="type" value="fixed" checked />
                            &ensp;
                            <font size=3 color="blue" style="font-weight:bold"><%=equipKm%></font><input type="checkbox" name="equipKm" id="type" value="odometer" checked />
                        </DIV>
                    </TD>
                    <TD dir="<%=dir%>" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" bgcolor="#F8F8F8"  valign="MIDDLE" COLSPAN="2" >
                        <input type="radio" name="interval" id="defualt" onclick="JavaScript:enable(this.id);" checked  /><B><font size=3 color="blue"><%=defualt%></font></B>&ensp;<input type="text" id="defualtDay" name="defualtDay" value="<%=defualtDay%>" size="5" disabled />&ensp;
                        <B><font size=3 color="red"><%=day%></font></B><br><BR>
                        <input type="radio" name="interval" id="custom" onclick="JavaScript:enable(this.id);" /><B><font size=3 color="blue"><%=custom%></font>&ensp;<input type="text" id="customDay" name="customDay" size="5" disabled >&ensp;<font size=3 color="red"><%=day%></font></B>
                    </TD>
                </TR>
                <TR>
                    <TD STYLE="text-align:center" CLASS="td" colspan="5">
                        <br><br>
                        <button  onclick="JavaScript: submitForm();" class="button"><%=search%><IMG HEIGHT="15" SRC="images/search.gif"> </button>
                            &ensp;
                        <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel%><IMG HEIGHT="15" SRC="images/cancel.gif"></button>
                    </TD>
                </TR>
                </TABLE>
                <br>
                    <br>
        </fieldset>
    </CENTER>        
</FORM>
</BODY>
</HTML>

