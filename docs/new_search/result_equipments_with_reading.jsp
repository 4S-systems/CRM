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

    int iTotal = 0;

    Vector  equipmentsWithReading = (Vector) request.getAttribute("data");
    Vector  equipments = (Vector) request.getAttribute("equipments");
    String allEquipments = (String) request.getAttribute("allEquipments");
    Vector  vecTypeOfRate = (Vector) request.getAttribute("typeOfRate");
    Vector  sites = (Vector) request.getAttribute("sites");
    String siteAll = (String) request.getAttribute("siteAll");
    String beginDate = (String) request.getAttribute("beginDate");
    String endDate = (String) request.getAttribute("endDate");

    Hashtable logos=new Hashtable();
    logos=(Hashtable)session.getAttribute("logos");
    String bgColor = null;

    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,title,equipName, equipCode,PL,begin ,end,last,prev,diff,dateOfLast,equipTypeOfRate,equipKm,equipHr,equip ,selectAll,site,rate,excel;
    if(stat.equals("En")){
        begin="From Date";
        end="To Date";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode= "Ar";
        PL="Total Equipment";
        title = "Report View Equipments With Reading";
        equipName = "Equipment Name";
        equipCode = "Equipment Code";
        last = "Last Reading";
        prev = "Previous Reading";
        diff = "Difference in Reading";
        dateOfLast = "Date of Last Reading";
        equipTypeOfRate = "Equipment By";
        equipKm = "Kilo Meter";
        equipHr = "Hour";
        equip = "Equipment";
        selectAll = "All";
        site = "Site";
        rate = "Type Of Rate";
        excel="Excel";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        PL=" &#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
        title = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1593;&#1585;&#1590; &#1602;&#1585;&#1575;&#1569;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
        begin="&#1605;&#1606; &#1578;&#1575;&#1585;&#1610;&#1582;";
        end="&#1575;&#1604;&#1609; &#1578;&#1575;&#1585;&#1610;&#1582;";
        equipName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        equipCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        last = "&#1575;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;";
        prev = "&#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1587;&#1575;&#1576;&#1602;&#1577;";
        diff = "&#1601;&#1585;&#1602; &#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1577;";
        dateOfLast = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;";
        equipTypeOfRate = "&#1575;&#1604;&#1605;&#1593;&#1583;&#1577; &#1576;&#1600;&#1600;&#1600;";
        equipKm = "&#1603;&#1610;&#1604;&#1608;&#1605;&#1578;&#1585;";
        equipHr = "&#1587;&#1575;&#1593;&#1577;";
        equip = "&#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
        selectAll = "&#1575;&#1604;&#1603;&#1604;";
        site = "&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        rate = "&#1606;&#1608;&#1593; &#1593;&#1605;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
        excel="&#1575;&#1603;&#1587;&#1604;";
    }

    // set parameter to Export to Excel
    String[] headers = new String[7];
            headers[0] = "Equipment Code";
            headers[1] = "Equipment Name";
            headers[2] = "Equipment By";
            headers[3] = "Last Reading";
            headers[4] = "Previous Reading";
            headers[5] = "Difference in Reading";
            headers[6] = "Date of Last Reading";

    String[] attributeType = new String[7];
            for(int i = 0; i < attributeType.length; i++){
                attributeType[i] = "String";
            }
    String[] attribute = new String[7];
            attribute[0] = "unitNo";
            attribute[1] = "unitName";
            attribute[2] = "typeOfRate";
            attribute[3] = "lastReading";
            attribute[4] = "previousReading";
            attribute[5] = "diffReading";
            attribute[6] = "dateOfLastReading";

	WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

	GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
	Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");

	ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
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
       
       function resetSession(){
        var url = "<%=context%>/ReportsServletThree?op=clearSession";
            if (window.XMLHttpRequest)
            {
                req = new XMLHttpRequest();
            }
               else if (window.ActiveXObject)
            {
                req = new ActiveXObject("Microsoft.XMLHTTP");
            }
            req.open("Post",url,true);
            req.onreadystatechange =  closeWindow;
            req.send(null);
      }

       function closeWindow(){
         if (req.readyState==4)
            {
               if (req.status == 200)
                {
                    window.close();
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

        function changePage(url){
            window.navigate(url);
        }

    </script>
    <style>
        .thead
           {
                color:black;
                font:14px;
                border-width:1px;
                height:50px;
                border-color:black;
                font-weight:bold;
                padding:5px;
                cursor:pointer
           }
           .row
            {
                background:white;
                border-width:1px;
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
        <FORM NAME="Equipments_With_Reading" METHOD="POST" >
        <DIV align="left" STYLE="color:blue;" ID="btnDiv">
            <input type="button" style="width:80px;height:30px;font-weight:bold" onclick="reloadAE('<%=langCode%>')" value="<%=lang%>" >
                &ensp;
            <input type="button" style="width:80px;height:30px;font-weight:bold"  value="&#1575;&#1591;&#1576;&#1593;"  onclick="JavaScript:printWindow();" class="button">
                &ensp;
            <input type="button" style="width:80px;height:30px;font-weight:bold"  value="&#1594;&#1604;&#1602;"  onclick="JavaScript:resetSession();" class="button">
                &ensp;
            <button class="button" style="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>; width:80px;height:30px;font-weight:bold" onclick="changePage('<%=context%>/ReportsServletThree?op=extractReadingToExcel&filename=Equipments_with_Reading.xls')" ><%=excel%>&ensp;<img src="<%=context%>/images/xlsicon.gif" ></img></button>
        </DIV>
        <br>
        <center>
        <table border="0" width="95%" id="table1" dir="LTR">
                <tr>
                    <td class="td" width="35%">
                        <img border="0" src="images/<%=logos.get("headReport3").toString()%>" width="180" height="200" align="left">
                    </td>
                    <td class="td" width="65%">
                        <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                            <TR>
                                <td class="td" bgcolor="#D0D0D0" style="text-align:center;border:0">
                                    <b><font size="5" color="blue"><%=title%></font></b>
                                </td>
                            </TR>
                            <TR>
                                <td class="td" style="text-align:center;border:0">
                                    &ensp;
                                </td>
                            </TR>
                            <TR>
                                <TD>
                                    <TABLE ALIGN="<%=align%>" border="1" CLASS="thead" dir="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
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
                                                <B><%=equip%></B>
                                            </TD>
                                            <TD CLASS="row" >
                                                    <%if(allEquipments != null && allEquipments.equals("all")){%>
                                                        <B><%=selectAll%></B>
                                                    <%}else{
                                                        for(int i = 0; i< equipments.size(); i++){
                                                    %>
                                                    <B><%=equipments.get(i)%></B><br>
                                                <%} }%>
                                            </TD>
                                            <TD CLASS="thead" nowrap WIDTH="3%" STYLE="height:15px" bgcolor="#D0D0D0">
                                                <B><%=site%></B>
                                            </TD>
                                            <TD CLASS="row" >
                                                <%if(siteAll.equals("yes")){%>
                                                    <B><%=selectAll%></B>
                                                <%}else{%>
                                                    <%for(int i = 0; i< sites.size(); i++){%>
                                                    <B><%=sites.get(i)%></B><br>
                                                <%} }%>
                                            </TD>
                                        </TR>
                                        <TR>
                                            <TD COLSPAN="2" CLASS="thead" nowrap WIDTH="3%" STYLE="height:15px" bgcolor="#D0D0D0">
                                                <B><%=rate%></B>
                                            </TD>
                                            <TD COLSPAN="2" CLASS="row" >
                                                <%for(int i = 0; i< vecTypeOfRate.size(); i++){%>
                                                    <B><%=vecTypeOfRate.get(i)%></B>
                                                    <%if(i < vecTypeOfRate.size() - 1){%>
                                                        &ensp; , &ensp;
                                                    <%}%>
                                                <%}%>
                                            </TD>
                                        </TR>
                                    </TABLE>
                                </TD>
                            </TR>
                        </TABLE>
                    </td>
                </tr>
        </table>
        <br>
        <div style="border:1px solid black;width:95%" >
            <TABLE class="sortable" ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" CELLPADDING="0" CELLSPACING="0">
                <TR bgcolor="#D0D0D0">
                    <TD CLASS="thead" nowrap WIDTH="3%">
                            <B>#</B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="17%">
                            <B><%=equipCode%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="25%">
                            <B><%=equipName%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="5%">
                            <B><%=equipTypeOfRate%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="10%">
                            <B><%=last%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="10%">
                            <B><%=prev%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="10%">
                            <B><%=diff%></B>
                    </TD>
                    <TD CLASS="thead" nowrap WIDTH="20%">
                            <B><%=dateOfLast%></B>
                    </TD>
                </TR>
                <%
                WebBusinessObject wboDetails;
                int lastReading,prevReading,diffReading,temp;
                long timeByMilleSecond;
                Date dateOfLastReading;
                String strDateOfLastReading,typeOfRate;
                for(int i = 0; i< equipmentsWithReading.size(); i++){
                    wboDetails = (WebBusinessObject) equipmentsWithReading.get(i);
                    iTotal++;
                    
                    lastReading = Integer.valueOf((String) wboDetails.getAttribute("lastReading")).intValue();
                    prevReading = Integer.valueOf((String) wboDetails.getAttribute("previousReading")).intValue();

                    typeOfRate = (String) wboDetails.getAttribute("typeOfRate");
                    if(typeOfRate.equals("fixed")){
                        typeOfRate = equipHr;
                        wboDetails.setAttribute("typeOfRate", "Hour");
                    }else{
                        typeOfRate = equipKm;
                        wboDetails.setAttribute("typeOfRate", "Kilo Meter");
                    }

                    // to resolve Old Entry data
                    if(lastReading < prevReading){
                        temp = lastReading;
                        lastReading = prevReading;
                        prevReading = temp;
                    }

                    diffReading = lastReading - prevReading;
                    
                    timeByMilleSecond = Long.valueOf((String) wboDetails.getAttribute("entryTime")).longValue();
                    dateOfLastReading = new Date(timeByMilleSecond);
                    strDateOfLastReading = dateOfLastReading.getDate() + "/" + (dateOfLastReading.getMonth() + 1) + "/" + (dateOfLastReading.getYear() + 1900);

                    wboDetails.setAttribute("diffReading", diffReading);
                    wboDetails.setAttribute("dateOfLastReading", strDateOfLastReading);
                    
                %>

                <TR bgcolor="<%=bgColor%>">

                    <TD CLASS="row" >
                        <%=iTotal%>
                    </TD>

                    <TD CLASS="row" >
                        <b><%=wboDetails.getAttribute("unitNo")%> </b>
                    </TD>

                    <TD CLASS="row" >
                        <b> <%=wboDetails.getAttribute("unitName")%> </b>
                    </TD>
                    <TD CLASS="row" >
                        <b> <%=typeOfRate%> </b>
                    </TD>
                    <TD CLASS="row" >
                        <b> <%=lastReading%> </b>
                    </TD>

                    <TD CLASS="row" >
                        <b> <%=prevReading%> </b>
                    </TD>

                    <TD CLASS="row" >
                        <b> <%=diffReading%> </b>
                    </TD>
                    <TD CLASS="row" >
                        <b> <%=strDateOfLastReading%> </b>
                    </TD>
                </TR>

                <%
                }
                // remove all parameter in session to export report to excel
                session.removeAttribute("data");
                session.removeAttribute("headers");
                session.removeAttribute("attributeType");
                session.removeAttribute("attribute");
                // set all parameter in session to export this report to excel
                session.setAttribute("data", equipmentsWithReading);
                session.setAttribute("headers", headers);
                session.setAttribute("attributeType", attributeType);
                session.setAttribute("attribute", attribute);
                %>
            </TABLE>
            </div>
                    <br>
        <table width="95%" bgcolor="#E6E6FA">
            <tr>
                <td width="30%" align="center">
                    <b><font color="black" size="3"> <%=equipmentsWithReading.size()%> </font></b>
                </td>
                <td width="30%" align="center">
                    <b><font color="black" size="3"><%=PL%> </font></b>
                </td>
            </tr>
        </table>
         </center>
            <br>
        </FORM>
    </body>
</html>
