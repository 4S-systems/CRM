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
//get session logged user and his trades
WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");

String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;

    String lang,langCode,back,beginDate ,endDate,search,cancel,calenderTip,selectAll,addEquip,site,
            equipKm,equipHr,title,align,dir,equipCode,equipName,selectEquip,delete,pageTitle ,  pageTitleTip;

    if (stat.equals("En")) {
            lang="   &#1593;&#1585;&#1576;&#1610;    ";
            langCode= "Ar";
            back = "Back";
            align="center";
            dir="LTR";
            beginDate="From Date";
            endDate="To Date";
            search="Export Report";
            cancel="Cancel";
            calenderTip = "click inside text box to open calender window";
            selectAll = "All";
            addEquip = "Add Equipments";
            site = "By Site";
            equipHr = "Equipment Hr";
            equipKm = "Equipment Km";
            title = "Report View Equipments With Reading";
            equipCode = "Equipment Code";
            equipName = "Equipment Name";
            selectEquip = "Selective Equipments";
            delete = "Delete";
            pageTitle="RPT-SCH-MNTNC-EQP-1";
            pageTitleTip="Equipments By Maintenance Schedule Report";

        }else{
            lang="English";
            langCode="En";
            back = "&#1585;&#1580;&#1608;&#1593;";
            align="center";
            dir="RTL";
            beginDate="&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
            endDate="&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
            search="&#1575;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
            calenderTip="&#1575;&#1590;&#1594;&#1591; &#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1605;&#1587;&#1578;&#1591;&#1610;&#1604; &#1604;&#1603;&#1609; &#1610;&#1592;&#1607;&#1585; &#1604;&#1603; &#1606;&#1575;&#1601;&#1584;&#1607; &#1604;&#1571;&#1582;&#1578;&#1610;&#1575;&#1585; &#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
            cancel=tGuide.getMessage("cancel");
            selectAll = "&#1575;&#1604;&#1603;&#1604;";
            addEquip = "&#1573;&#1590;&#1575;&#1601;&#1577; &#1605;&#1593;&#1583;&#1575;&#1578;";
            site = "&#1576;&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
            equipHr = "&#1605;&#1593;&#1583;&#1577; &#1576;&#1575;&#1604;&#1587;&#1575;&#1593;&#1577;";
            equipKm = "&#1605;&#1593;&#1583;&#1577; &#1576;&#1575;&#1604;&#1603;&#1610;&#1604;&#1608;&#1605;&#1578;&#1585;";
            title = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1593;&#1585;&#1590; &#1602;&#1585;&#1575;&#1569;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
            equipName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
            equipCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
            delete = "&#1581;&#1584;&#1601;";
            selectEquip = "&#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1575;&#1604;&#1605;&#1582;&#1578;&#1575;&#1585;&#1577;";
            pageTitle="RPT-SCH-MNTNC-EQP-1";
            pageTitleTip="&#1578;&#1602;&#1585;&#1610;&#1585; &#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1576;&#1580;&#1583;&#1575;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
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

    function submitForm()
    {
        var idsValues = getIds();

            var url = "<%=context%>/ReportsServletThree?op=resultEquipmentsBySchedule&ids=" + idsValues;
           // var setting = "dialogHeight:600px;dialogWidth:800px;resizable:yes";
           // window.showModalDialog(url, "", setting);
           openWindow(url);
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

     function getEquipment(){
            var idsValues = getIds();
            var formName = document.getElementById('SEARCH_MAINTENANCE_FORM').getAttribute("name");
            openWindow('ReportsServletThree?op=selectEquipments&formName='+formName+"&idsValues="+idsValues);

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

    function openWindow(url)
    {
        window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, copyhistory=no, width=850, height=400");
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
    
<FORM NAME="SEARCH_MAINTENANCE_FORM" METHOD="POST">
    <input type="hidden" name="search" value="search" />
    <DIV DIR="LTR" style="padding-left:50px;padding-right:50px" >
        <input type="button" style="background:#989898;font-size:15px;color:blue;font-weight:bold"  value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
            &ensp;
        <button onclick="JavaScript:back();" class="button" style="background:#989898;font-size:15px;color:blue;font-weight:bold"> <%=back%> <IMG VALIGN="BOTTOM" SRC="images/backward.gif"></button>
    </DIV>

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

    <br>
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
                    <TD BGCOLOR="#F8F8F8" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px">
                        &ensp;
                    </TD>
                    <TD BGCOLOR="#F8F8F8" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px" COLSPAN="3">
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
                        <div align="left">
                            <input type="button" name="delete" id="delete" value="<%=delete%>" onclick="JavaScript:Delete()" STYLE="background:#989898;font-size:15;color:blue;font-weight:bold;width:100px;padding-top:2px;width:100px" />
                        </div>
                        <div align="center">
                            <input type="button" name="search" id="search" value="<%=addEquip%>" onclick="JavaScript:getEquipment()" STYLE="background:#989898;font-size:15;color:blue;font-weight:bold;width:100px;padding-top:2px" />
                        </div>
                    </TD>
                    <TD BGCOLOR="#F8F8F8" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px">
                        &ensp;
                    </TD>
                </TR>
                <TR>
                    <TD COLSPAN="5" BGCOLOR="#F8F8F8" style="text-align:center;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px">
                        &ensp;
                    </TD>
                </TR>
                <TR>
                    <TD STYLE="text-align:center" CLASS="td" colspan="5">
                        <br><br>
                        <button  onclick="JavaScript: submitForm();" STYLE="background:#D0D0D0;font-size:15px;color:blue;font-weight:bold; ">   <%=search%><IMG HEIGHT="15" SRC="images/search.gif"> </button>
                            &ensp;
                        <button  onclick="JavaScript: cancelForm();" STYLE="background:#D0D0D0;font-size:15px;color:blue;font-weight:bold; "> <%=cancel%>  <IMG HEIGHT="15" SRC="images/cancel.gif"></button>
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
