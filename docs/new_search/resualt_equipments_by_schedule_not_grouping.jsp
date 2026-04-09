<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.maintenance.common.ConfigFileMgr,com.tracker.db_access.ProjectMgr" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Projects List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/headers.css">
        <script src="js/sorttable.js"></script>
    </HEAD>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    Vector  allEquipments = (Vector) request.getAttribute("data");
    String ids = (String) request.getAttribute("ids");

    Hashtable logos=new Hashtable();
    logos=(Hashtable)session.getAttribute("logos");
    String bgColor = null;

    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,title,scheduleName, equipCode,PL,begin ,end,last,prev,diff,dateOfLast,deserveDate,deserve,equipKm,equipHr,frec,equip,notFondSchedule,code;
    if(stat.equals("En")){
        begin="From Date";
        end="To Date";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode= "Ar";
        PL="Schedule No.";
        title = "Report View Equipments With Schedule";
        scheduleName = "Schedule Name";
        equipCode = "Equipment Code";
        last = "Last Reading";
        prev = "Preious Reading";
        diff = "Difference in Reading";
        dateOfLast = "Date of Last Reading";
        equipKm = "Kilo Meter";
        equipHr = "Hour";
        frec = "Frequency";
        equip = "Equipment";
        code = "Code";
        deserveDate = "Equipment By";
        deserve = "Deserve ";
        deserveDate = "Date Deserve";
        notFondSchedule = "Not Found Schedule";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        PL=" &#1593;&#1583;&#1583; &#1575;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604;";
        title = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1576;&#1580;&#1583;&#1575;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        begin="&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        end="&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        scheduleName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
        equipCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        last = "&#1575;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;";
        prev = "&#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1587;&#1575;&#1576;&#1602;&#1577;";
        diff = "&#1601;&#1585;&#1602; &#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1577;";
        dateOfLast = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;";
        equipKm = "&#1603;&#1610;&#1604;&#1608;&#1605;&#1578;&#1585;";
        equipHr = "&#1587;&#1575;&#1593;&#1577;";
        frec = "&#1610;&#1603;&#1585;&#1585; &#1603;&#1604;";
        equip = "&#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        code = "&#1575;&#1604;&#1603;&#1608;&#1583;";
        deserve = "&#1578;&#1587;&#1578;&#1581;&#1602;";
        deserveDate = "&#1578;&#1575;&#1585;&#1610;&#1581; &#1575;&#1604;&#1571;&#1587;&#1578;&#1581;&#1602;&#1575;&#1602;";
        notFondSchedule = "&#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1580;&#1583;&#1575;&#1608;&#1604; &#1589;&#1610;&#1575;&#1606;&#1577;";
    }

    %>
    <script language="javascript" type="text/javascript">
        function reloadAE(nextMode){

       var url = "<%=context%>/ajaxGetItrmName?key="+nextMode;
            if (window.XMLHttpRequest)
            {
                req = new XMLHttpRequest();
            }
               else if (window.ActiveXObject)
            {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            }
            req.open("Post",url,true);
            req.onreadystatechange =  callbackFillreload;
            req.send(null);

      }

       function callbackFillreload(){
         if (req.readyState==4)
            {
               if (req.status == 200)
                {
                     window.location.reload();
                }
            }
       }

           function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }

        function printWindow(){
            document.getElementById('btnDiv').style.display = "none";
            window.print();
            document.getElementById('btnDiv').style.display = "block";
        }
        
        function changePreview(){
            document.Equipments_Schedule.action = "<%=context%>/ReportsServletThree?op=resultEquipmentsBySchedule";
            document.Equipments_Schedule.submit();
        }

    </script>
    <style>
        .thead
           {
                color:black;
                font:14px;
                border-width:1px;
                height:20px;
                border-color:black;
                font-weight:bold;
                padding:5px;
                cursor:pointer
           }
           .row
            {
                background:white;
                color:black;
                font:12px;
                height:25px;
                text-align:center;
                border-color:black;
                font-weight:bold;
                padding:2px;
            }
    </style>
    <body>
        <form name="Equipments_Schedule" method="post">
            <input type="hidden" id="pageName" name="pageName" value="result_equipments_by_schedule_grouping" />
            <%if(ids != null){%>
                <input type="hidden" id="ids" name="ids" value="<%=ids%>" />
            <%}%>
        <DIV align="left" STYLE="color:blue;width:100%" ID="btnDiv">
            <input type="button" style="width:80px;height:30px;font-weight:bold" onclick="reloadAE('<%=langCode%>')" value="<%=lang%>" >
                &ensp;
            <input type="button" style="width:80px;height:30px;font-weight:bold"  value="&#1575;&#1591;&#1576;&#1593;"  onclick="JavaScript:printWindow();" class="button">
                &ensp;
            <input type="button" style="width:80px;height:30px;font-weight:bold"  value="&#1594;&#1604;&#1602;"  onclick="window.close()" class="button">
                &ensp;&ensp;&ensp;&ensp;&ensp;
            <input type="button" style="width:100px;height:30px;font-weight:bold;color:blue"  value="&#1578;&#1594;&#1610;&#1610;&#1585; &#1591;&#1585;&#1610;&#1602;&#1577; &#1575;&#1604;&#1593;&#1585;&#1590;"  onclick="JavaScript:changePreview()" class="button">
        </DIV>
        <br>
        <center>
        <table border="0" width="95%" id="table1" dir="LTR">
                <tr>
                    <td class="td" width="35%" colspan="2">
                        <img border="0" src="images/<%=logos.get("headReport3").toString()%>" width="180" height="200" align="left">
                    </td>
                    <td class="td" width="65%" colspan="2">
                        <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                            <TR>
                                <td class="td" colspan="4" bgcolor="#D0D0D0" style="text-align:center;border:0">
                                    <b><font size="5px" color="blue"><%=title%></font></b>
                                </td>
                            </TR>
                        </TABLE>
                    </td>
                </tr>
        </table>
        <br>
        <div style="width:95%" >
            <TABLE class="sortable thead" ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                <TR bgcolor="#D0D0D0">
                    <TD CLASS="thead" nowrap WIDTH="5%">
                            <B>#</B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="30%">
                            <B><%=equip%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="5%">
                            <B><%=code%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="25%">
                            <B><%=scheduleName%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="15%">
                            <B><%=frec%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="15%">
                            <B><%=deserveDate%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="5%">
                            <B><%=deserve%></B>
                    </TD>
                </TR>
                <%
                WebBusinessObject wboSchedule,wboEquipment;
                Vector allSchedules;
                String type,frequencyType,beginDate,strRate,strCaneclRate,strJORate;
                int rate,cancelRate,joRate;
                boolean Deserve;
                for(int i = 0; i< allEquipments.size(); i++){
                    wboEquipment = (WebBusinessObject) allEquipments.get(i);
                    allSchedules = (Vector) wboEquipment.getAttribute("allSchedules");
                %>
                <TR>
                 <TD CLASS="row" >
                            <%=i + 1%>
                 </TD>
                 <TD CLASS="row" >
                            <%=wboEquipment.getAttribute("unitName")%>
                 </TD>
                 <TD CLASS="row" >
                            <%=wboEquipment.getAttribute("unitNo")%>
                 </TD>
                 <TD CLASS="row" COLSPAN="4">
                     <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" style="height:100%">
                        <%
                        for(int j = 0; j<allSchedules.size(); j++){
                            wboSchedule = (WebBusinessObject) allSchedules.get(j);

                            strRate = (String) wboSchedule.getAttribute("rateNo");
                            strCaneclRate = (String) wboSchedule.getAttribute("cancelRateNo");
                            strJORate = (String) wboSchedule.getAttribute("jobOrderRateNo");

                            if(strRate != null){
                                rate = Integer.valueOf(strRate).intValue();
                                cancelRate = Integer.valueOf(strCaneclRate).intValue();
                                joRate = Integer.valueOf(strJORate).intValue();

                                if(rate > cancelRate && rate > joRate){
                                    Deserve = true;
                                    beginDate = (String) wboSchedule.getAttribute("beginDate");
                                } else {
                                    Deserve = false;
                                    beginDate = "---";
                                }
                            }else{
                                Deserve = false;
                                beginDate = "---";
                            }

                            frequencyType = (String) wboSchedule.getAttribute("frequencyType");

                            if (frequencyType.equals("1")) {
                                type = new String("Day");
                            } else if (frequencyType.equals("2")) {
                                type = new String("Week");
                            } else if (frequencyType.equals("3")) {
                                type = new String("Month");
                            } else if (frequencyType.equals("4")) {
                                type = new String("Year");
                            } else if(frequencyType.equals("5")){
                                type = new String("kilometer");
                            }else {
                                type = new String("Hour");
                            }
                        %>
                            <TR>
                                <TD CLASS="row" WIDTH="41.7%">
                                    <b><%=wboSchedule.getAttribute("maintenanceTitle")%> </b>
                                </TD>
                                <TD CLASS="row" WIDTH="25%">
                                    <b><%=wboSchedule.getAttribute("frequency")%>&ensp;<font color="red"><%=type%></font></b>
                                </TD>
                                <TD CLASS="row" WIDTH="25%">
                                    <b><%=beginDate%> </b>
                                </TD>
                                <TD CLASS="row" WIDTH="8.3%">
                                    <input type="checkbox"  <%if(Deserve){%> checked <%}%> />
                                </TD>
                            </TR>

                        <%
                        }
                        if(allSchedules.size() == 0){
                        %>
                        <TR>
                            <TD CLASS="row" COLSPAN="4" >
                                <font color="red" style="font-weight:bold"><%=notFondSchedule%></font>
                            </TD>
                        </TR>
                        <%
                        }
                        %>
                    </TABLE>
                </TD>
                </TR>
                <%
                }
                %>
            </TABLE>
            </div>
         </center>
            <br>
      </form>
    </body>
</html>
