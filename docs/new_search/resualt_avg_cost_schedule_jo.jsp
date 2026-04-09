<%@page import="com.maintenance.common.Tools"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.maintenance.common.ConfigFileMgr,com.tracker.db_access.ProjectMgr" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>Maintenance Details Report</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/headers.css">
        <script src="js/sorttable.js"></script>
    </HEAD>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    int iTotal = 0;

    Vector  allMaintenanceInfo = (Vector) request.getAttribute("data");
    String beginDate = (String) request.getAttribute("beginDate");
    String endDate = (String) request.getAttribute("endDate");

    String unitName = (String) request.getAttribute("unitName");
    String taskName = (String) request.getAttribute("taskName");
    String itemName = (String) request.getAttribute("itemName");


    String siteAll = (String) request.getAttribute("siteAll");
    String tradeAll = (String) request.getAttribute("tradeAll");
    String mainTypeAll = (String) request.getAttribute("mainTypeAll");

    Vector arrSite = (Vector) request.getAttribute("site");
    String trade = (String) request.getAttribute("trade");
    Vector arrMainType = (Vector) request.getAttribute("mainType");

    Hashtable logos=new Hashtable();
    logos=(Hashtable)session.getAttribute("logos");
    String bgColor = null;

    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,title,tempTotal, itemsNo, status, currentStatusSince,jobNo,accordingTo,PL,item,begin,task ,end,search,tradeName,nameEquip,mainType,site,brand,open,closed,costing,empty,selectAll,equip;
    if(stat.equals("En")){
        task = "Tasks";
        item = "Items";
        begin="From Date";
        end="To Date";
        tradeName = "Maintenance Type";
        nameEquip = "Equipment Name";
        site = "Site";
        mainType = "Main Type";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode= "Ar";
        tempTotal= "Total";
        itemsNo="Quantity";
        status= "Status";
        currentStatusSince = "Status Date";
        jobNo="Job Order No.";
        PL="Total Result";
        accordingTo = "According To Schedule";
        title = "Costing avrage schedule job order ";
        brand = "Brand";
        costing = "Costing";
        open = "Open";
        closed = "Closed";
        empty = "---";
        selectAll = "All";
        equip = "Equipment";
    }else{

        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        tempTotal= "&#1575;&#1604;&#1571;&#1580;&#1605;&#1575;&#1604;&#1609;";
        itemsNo="&#1575;&#1604;&#1603;&#1605;&#1610;&#1577;";
        currentStatusSince = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
        status = "&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
        jobNo="&#1585;&#1602;&#1605; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        PL=" &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1605;&#1578;&#1608;&#1587;&#1591;&#1577; &#1604;&#1578;&#1604;&#1603; &#1575;&#1604;&#1601;&#1578;&#1585;&#1577;";
        accordingTo="&#1576;&#1606;&#1575;&#1569; &#1593;&#1604;&#1609; &#1580;&#1583;&#1608;&#1604;";
        title = "&#1578;&#1603;&#1604;&#1601;&#1577; &#1605;&#1578;&#1608;&#1587;&#1591;&#1577; &#1604;&#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1605;&#1580;&#1583;&#1608;&#1604;&#1577;";
        task = "&#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        item = "&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        begin="&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        end="&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        tradeName = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        nameEquip = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        site = "&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        mainType = "&#1606;&#1608;&#1593; &#1585;&#1574;&#1610;&#1587;&#1609;";
        brand = "&#1575;&#1604;&#1605;&#1575;&#1585;&#1603;&#1577;";
        open = "&#1601;&#1578;&#1581;&#1607;";
        closed = "&#1571;&#1594;&#1604;&#1575;&#1602;&#1577;";
        costing = "&#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577;";
        empty = "---";
        selectAll = "&#1575;&#1604;&#1603;&#1604;";
        equip = "&#1605;&#1593;&#1583;&#1577;";
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

    </script>
    <style>
        .thead
           {
                color:black;
                font:14px;
                border-left-width:1px;
                height:50px;
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
        <DIV align="left" STYLE="color:blue;" ID="btnDiv">
            <input type="button" style="width:100px"  value="&#1575;&#1591;&#1576;&#1593;"  onclick="JavaScript:printWindow();" class="button">
                &ensp;
            <input type="button" style="width:100px"  value="&#1594;&#1604;&#1602;"  onclick="window.close()" class="button">
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
                                    <b><font size="5" color="blue"><%=title%></font></b>
                                </td>
                            </TR>
                            <TR>
                                <td class="td" colspan="4" style="text-align:center;border:0">
                                    &ensp;
                                </td>
                            </TR>
                            <TR>
                                <TD CLASS="thead" nowrap WIDTH="3%" STYLE="height:15px" bgcolor="#D0D0D0">
                                    <B><%=begin%></B>
                                </TD>
                                <TD CLASS="row" >
                                    <%=beginDate%>
                                </TD>
                                <TD CLASS="thead" nowrap WIDTH="3%" STYLE="height:15px" bgcolor="#D0D0D0">
                                    <B><%=end%></B>
                                </TD>
                                <TD CLASS="row" >
                                    <%=endDate%>
                                </TD>
                            </TR>
                            <TR>
                                <TD CLASS="thead" nowrap WIDTH="3%" STYLE="height:15px" bgcolor="#D0D0D0">
                                    <%if(unitName != null){%>
                                        <B><%=equip%></B>
                                    <%}else{%>
                                        <B><%=mainType%></B>
                                    <%}%>
                                </TD>
                                <TD CLASS="row" >
                                    <%if(unitName != null){%>
                                        <B><%=unitName%></B>
                                    <%}else{
                                        if(mainTypeAll.equals("yes")){
                                        %>
                                        <B><%=selectAll%></B>
                                        <%}else{
                                            for(int i = 0; i< arrMainType.size(); i++){
                                    %>
                                        <B><%=arrMainType.get(i)%></B><br>
                                    <%}  }  }%>
                                </TD>
                                <TD CLASS="thead" nowrap WIDTH="3%" STYLE="height:15px" bgcolor="#D0D0D0">
                                    <B><%=site%></B>
                                </TD>
                                <TD CLASS="row" >
                                    <%if(siteAll.equals("yes")){%>
                                        <B><%=selectAll%></B>
                                    <%}else{%>
                                        <%for(int i = 0; i< arrSite.size(); i++){%>
                                        <B><%=arrSite.get(i)%></B><br>
                                    <%} }%>
                                </TD>
                            </TR>
                            <TR>
                                <TD CLASS="thead" nowrap WIDTH="3%" STYLE="height:15px" bgcolor="#D0D0D0">
                                    <B><%=tradeName%></B>
                                </TD>
                                <TD CLASS="row" >
                                    <%if(tradeAll.equals("yes")){%>
                                        <B><%=selectAll%></B>
                                    <%}else{%>
                                        <B><%=trade%></B>
                                    <%}%>
                                </TD>
                                <%if(taskName != null){%>
                                <TD CLASS="thead" nowrap WIDTH="3%" STYLE="height:15px" bgcolor="#D0D0D0">
                                    <B><%=task%></B>
                                </TD>
                                <TD CLASS="row" >
                                    <%=taskName%>
                                </TD>
                                <%}%>
                            </TR>
                            <TR>
                                <%if(itemName != null){%>
                                <TD CLASS="thead" nowrap WIDTH="3%" STYLE="height:15px" bgcolor="#D0D0D0">
                                    <B><%=item%></B>
                                </TD>
                                <TD CLASS="row" >
                                    <%=itemName%>
                                </TD>
                                <%}%>
                            </TR>
                        </TABLE>
                    </td>
                </tr>
        </table>
        <br>
        <div style="border:1px solid black;width:95%" >
            <TABLE class="sortable" ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="1500" CELLPADDING="0" CELLSPACING="0">
                <TR bgcolor="#D0D0D0">
                    <TD CLASS="thead" nowrap WIDTH="2%">
                            <B>#</B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="4%">
                            <B><%=jobNo%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="6%">
                            <B><%=site%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="18%">
                            <B><%=nameEquip%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="10%">
                            <B><%=status%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="10%">
                            <B><%=currentStatusSince%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="10%">
                            <B><%=brand%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="25%">
                            <B><%=task%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="21%">
                            <B><%=item%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="7%">
                            <B><%=itemsNo%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="7%">
                            <B><%=costing%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="6%">
                            <B><%=tempTotal%></B>
                    </TD>
                </TR>
                <%
                WebBusinessObject wboDetails,wboTask,wboItem;
                Vector allTask,allItem;
                String strTotal;
                float total = 0.0f,cost = 0.0f;
                for(int i = 0; i< allMaintenanceInfo.size(); i++){
                    wboDetails = (WebBusinessObject) allMaintenanceInfo.get(i);

                    allItem = (Vector) wboDetails.getAttribute("items");
                    allTask = (Vector) wboDetails.getAttribute("tasks");
                    
                    iTotal++;
                    total = 0;
                %>

                <TR bgcolor="<%=bgColor%>">
                    <TD CLASS="row" >
                        <%=iTotal%>
                    </TD>
                    <TD CLASS="row">
                        <b> <font color="red"><%=wboDetails.getAttribute("issueCode")%></font></b>
                    </TD>
                    <TD CLASS="row">
                        <b><%=wboDetails.getAttribute("siteName")%></b>
                    </TD>
                    <TD CLASS="row">
                        <b> <%=wboDetails.getAttribute("unitName")%> </b>
                    </TD>
                    <TD CLASS="row">
                        <b> <%=wboDetails.getAttribute("currentStatus")%> </b>
                    </TD>
                    <TD CLASS="row">
                        <%if(wboDetails.getAttribute("currentStatus").toString().equalsIgnoreCase("Schedule")){%>
                        <b><%=wboDetails.getAttribute("currentStatusSince")%></b>
                        <%}
                        else if(wboDetails.getAttribute("currentStatus").toString().equalsIgnoreCase("Assigned")){%>
                        <b>opened - <%=wboDetails.getAttribute("ActualBeginDate")%></b>
                        <%}
                        else if(wboDetails.getAttribute("currentStatus").toString().equalsIgnoreCase("Finished")){%>
                        <b>opened - <%=wboDetails.getAttribute("ActualBeginDate")%></b><br>
                        <b>closed - <%=wboDetails.getAttribute("ActualEndDate")%></b>
                        <%}
                        else {%>
                        <b><%=wboDetails.getAttribute("currentStatusSince")%></b>
                        <%}%>
                    </TD>
                    <TD CLASS="row">
                        <b> <%=wboDetails.getAttribute("parentName")%> </b>
                    </TD>

                    <TD CLASS="row" >
                        <TABLE ALIGN="<%=align%>" dir="<%=dir%>" style="height:100%;border-bottom-width:0px;border-left-width:0px;border-right-width:0px;border-top-width:0px;" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                            <%for(int j = 0; j<allTask.size(); j++){
                                wboTask = (WebBusinessObject) allTask.get(j);
                            %>
                                <TR bgcolor="<%=bgColor%>">
                                    <TD CLASS="row">
                                        <b><%=wboTask.getAttribute("name")%> </b>
                                    </TD>
                                </TR>
                            <%
                            }
                            if(allTask.size() == 0){
                            %>
                            <TR bgcolor="<%=bgColor%>">
                                    <TD CLASS="row">
                                        <%=empty%>
                                    </TD>
                                </TR>
                            <%}%>
                        </TABLE>
                    </TD>
                    <TD CLASS="row" COLSPAN="3">
                       <TABLE ALIGN="<%=align%>" dir="<%=dir%>" style="height:100%;" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                            <%for(int k = 0; k<allItem.size(); k++){
                                wboItem = (WebBusinessObject) allItem.get(k);

                                strTotal = (String) wboItem.getAttribute("total");
                                if(strTotal != null && !strTotal.equals("")){
                                    total += Float.valueOf(strTotal).floatValue();
                                }else{
                                    strTotal = "0.0";
                                }
                                if(wboItem.getAttribute("itemDesc") != null && !wboItem.getAttribute("itemDesc").toString().equals("")){
                            %>
                                <TR bgcolor="<%=bgColor%>">
                                    <TD CLASS="row" WIDTH="64%">
                                        <b><%=wboItem.getAttribute("itemDesc")%></b>
                                        <br>
                                        <b>( <%=wboItem.getAttribute("itemId")%> )</b>
                                    </TD>
                                    <TD CLASS="row" WIDTH="18%">
                                        <b><%=wboItem.getAttribute("itemQuantity")%> </b>
                                    </TD>
                                    <TD CLASS="row" WIDTH="18%">
                                        <b><%=Tools.getCurrency(strTotal)%></b>
                                    </TD>
                                </TR>
                            <%}else{%>
                                <TR bgcolor="<%=bgColor%>">
                                    <TD CLASS="row" COLSPAN="3">
                                        <%=empty%>
                                    </TD>
                                </TR>
                            <%
                                }
                            }
                            if(allItem.size() == 0){
                            %>
                            <TR bgcolor="<%=bgColor%>">
                                    <TD CLASS="row" COLSPAN="3">
                                        <%=empty%>
                                    </TD>
                                </TR>
                            <%}%>
                       </TABLE>
                    </TD>

                    <TD CLASS="row" >
                        <b> <%=Tools.getCurrency(String.valueOf(total))%> </b>
                    </TD>
                <%
                cost += total;
                }
                %>
            </TABLE>
            </div>
                    <br>
        <table width="1500" bgcolor="#E6E6FA">
            <tr>
                <td width="30%" align="center">
                    <b><font color="black" size="3"> <%=Tools.getCurrency(String.valueOf(cost))%> </font></b>
                </td>
                <td width="30%" align="center">
                    <b><font color="black" size="3"><%=PL%></font></b>
                </td>
            </tr>
        </table>
         </center>
            <br>
    </body>
</html>
