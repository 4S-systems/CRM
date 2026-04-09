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
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="treemenu/script/jquery-1.2.6.min.js"></script>
        <script src="js/sorttable.js"></script>
    </HEAD>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String searchBy = (String) request.getAttribute("searchBy");
        int iTotal = 0;
        String status = (String) request.getAttribute("status");
        Integer updatedEquips = (Integer) request.getAttribute("updatedEquips");
        Vector equipmentsWithReading = (Vector) request.getAttribute("data");
        Vector vecTypeOfRate = (Vector) request.getAttribute("typeOfRate");
        String filterType = (String) request.getAttribute("filterType");
        Vector filterValue = (Vector) request.getAttribute("filterValue");
        Vector siteValue = (Vector) request.getAttribute("siteValue");
        String cancel_button_label, save_button_label;
        Hashtable logos = new Hashtable();
        logos = (Hashtable) session.getAttribute("logos");
        String bgColor = null;

        //////////////////////////////////////////////////////////////////////////////////
        int count = Integer.valueOf((String) request.getAttribute("count")).intValue();
        String sNoOfLinks = (String) request.getAttribute("noOfLinks");
        int noOfLinks = Integer.valueOf(sNoOfLinks).intValue();
        String fullUrl = (String) request.getAttribute("fullUrl");
        String url = (String) request.getAttribute("url");
        String source = (String) request.getAttribute("source");
        String sites = (String) request.getAttribute("sites");
        String interval = String.valueOf((Integer) request.getAttribute("interval"));
        String typeOfRateValues = (String) request.getAttribute("typeOfRateValues");
        String type = (String) request.getAttribute("type");
        String brand = (String) request.getAttribute("brand");
        String ids = (String) request.getAttribute("ids");
        String siteAll = (String) request.getAttribute("siteAll");
        String mainFilter = (String) request.getAttribute("mainFilter");
        ////////////////////////////////////////////////////////////////////////////////////

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, title, equipName, sTitle, updateReading, equipCode, PL, begin, sbrand, last, dateOfLast, selectAll, day, stype, equip, site, equipTypeOfRate, equipKm, equipHr, rate, excel, sStatus, fStatus;
        if (stat.equals("En")) {
            begin = "Not Updated Since";
            sbrand = "Brand";
            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            PL = "Total Equipment";
            title = "Report presented the equipment has not been updated in a period of time";
            equipName = "Equipment Name";
            equipCode = "Equipment Code";
            last = "Last Reading";
            dateOfLast = "Date of Last Reading";
            selectAll = "All";
            day = "Day";
            stype = "Main Type";
            equip = "Equipments";
            site = "Site";
            equipTypeOfRate = "Equipment By";
            equipKm = "Kilo Meter";
            equipHr = "Hour";
            rate = "Type Of Rate";
            excel = "Excel";
            updateReading = "New Reading";
            cancel_button_label = "Cancel";
            save_button_label = "Save";
            sTitle = "Update Readings of Equipments";
            sStatus = "Number of Updated Equipments: ";
            fStatus = "Update Failed";
        } else {

            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            PL = " &#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
            title = "&#1578;&#1602;&#1585;&#1610;&#1585; &#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1575;&#1604;&#1578;&#1609; &#1604;&#1605; &#1610;&#1578;&#1605; &#1578;&#1581;&#1583;&#1610;&#1579;&#1607;&#1575; &#1605;&#1606; &#1601;&#1578;&#1585;&#1577; &#1586;&#1605;&#1606;&#1610;&#1577;";
            begin = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1581;&#1583;&#1610;&#1579; &#1605;&#1606;&#1584;";
            sbrand = "&#1605;&#1575;&#1585;&#1603;&#1575;&#1578;";
            equipName = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
            equipCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
            last = "&#1575;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;";
            dateOfLast = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1582;&#1585; &#1602;&#1585;&#1575;&#1569;&#1577;";
            selectAll = "&#1575;&#1604;&#1603;&#1604;";
            day = "&#1610;&#1608;&#1605;";
            stype = "&#1606;&#1608;&#1593; &#1575;&#1587;&#1575;&#1587;&#1609;";
            equip = "&#1605;&#1593;&#1583;&#1575;&#1578;";
            site = "&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
            equipTypeOfRate = "&#1575;&#1604;&#1605;&#1593;&#1583;&#1577; &#1576;&#1600;&#1600;&#1600;";
            equipKm = "&#1603;&#1610;&#1604;&#1608;&#1605;&#1578;&#1585;";
            equipHr = "&#1587;&#1575;&#1593;&#1577;";
            rate = "&#1606;&#1608;&#1593; &#1593;&#1605;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
            excel = "&#1575;&#1603;&#1587;&#1604;";
            updateReading = "&#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1580;&#1583;&#1610;&#1583;&#1577;";
            cancel_button_label = "&#1573;&#1606;&#1607;&#1575;&#1569;";
            save_button_label = "&#1578;&#1587;&#1580;&#1610;&#1604;";
            sTitle = "&#1578;&#1581;&#1583;&#1610;&#1579; &#1602;&#1585;&#1575;&#1569;&#1575;&#1578; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
            sStatus = "&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1575;&#1604;&#1578;&#1609; &#1578;&#1605; &#1578;&#1581;&#1583;&#1610;&#1579;&#1607;&#1575;: ";
            fStatus = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1581;&#1610;&#1579;";
        }
    %>
    <script language="javascript" type="text/javascript">

        var lastReadings = [];

        function submitForm()
        {
            
            if(checkUpdate()) {
                document.UPDATE_READINGS.action = "<%=context%>/HoursWorkingEquipmentServlet?op=updateReadingsOfEquipments";
                document.UPDATE_READINGS.submit();
            }
            else document.UPDATE_READINGS.updateR.checked=false;
        }

        function cancelForm()
        {
            document.UPDATE_READINGS.action = "<%=context%>/HoursWorkingEquipmentServlet?op=getUpdateReadingsOfEquipmentsForm";
            document.UPDATE_READINGS.submit();
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

        function enableUpdate(i) {
            var update = document.UPDATE_READINGS.updateReading[i];
            if ( update.checked == true ){
                document.UPDATE_READINGS.newReading[i].disabled = false;
                document.UPDATE_READINGS.newReading[i].focus();
               
            } else {
                document.UPDATE_READINGS.newReading[i].value = '';
                document.UPDATE_READINGS.newReading[i].disabled = true;
            }
        }

        function isInteger(s)
        {
            var i;
            s = s.toString();
            if(s.length==0)
                return 1;
            for (i = 0; i < s.length; i++)
            {
                var c = s.charAt(i);
                if (isNaN(c)){

                    return 2;
                 
                }
            }
            return 3;
        }

        function checkNewReading(i) {
            
            var lastReading = lastReadings[i];
            var newReading = document.UPDATE_READINGS.newReading[i].value;
            var l="massege"+i;
            if(isInteger(newReading)==3) {
                if(lastReading >= newReading) {
                    document.UPDATE_READINGS.updateReading[i].checked = false;
                    document.UPDATE_READINGS.newReading[i].value = '';
                    document.UPDATE_READINGS.newReading[i].disabled = true;   
                    $('#me'+i).html("new data less than old data");
                    return false;
                }
                else $('#me'+i).html(" ");
            } else  {
                document.UPDATE_READINGS.updateReading[i].checked = false;
                document.UPDATE_READINGS.newReading[i].value = '';
                document.UPDATE_READINGS.newReading[i].disabled = true;
                if(isInteger(newReading)==1)
                    $('#me'+i).html(" ");
                else
                    $('#me'+i).html("invalid entry");
                return false;
            }
            return true;
        }

        function getTasksTop(){
            var count =document.getElementById("selectIdTop").value;
            document.UPDATE_READINGS.action = "<%=context%>/<%=fullUrl%>&count="+count;
            document.UPDATE_READINGS.submit();
        }

        function getTasksDown(){
           
            var count =document.getElementById("selectIdDown").value;
            document.UPDATE_READINGS.action = "<%=context%>/<%=fullUrl%>&count="+count;
            document.UPDATE_READINGS.submit();
            
        }

        function checkUpdate(){
            var arr = new Array();
            var flag=true;
            var list1=document.UPDATE_READINGS.newReading;   
            var list2=document.UPDATE_READINGS.updateReading;
            for (var i = 0; i < list1.length; i++)
            {
                if(list2[i].checked == true)
                    if(!checkNewReading(i))
                        flag=false;
            }
              
            
            return flag;
        }
        
        function checkUpdateall(){
            var list1=document.UPDATE_READINGS.newReading;
            var list2=document.UPDATE_READINGS.updateReading;
            var update = document.UPDATE_READINGS.updateR;
            if ( update.checked == true ){
                for (var i = 0; i < list1.length; i++)
                {
                    list1[i].disabled = false;
                    list2[i].checked = true;
                    $('#me'+i).html(" ");
                }}else{
              
                for (var i = 0; i < list1.length; i++)
                {
                    list1[i].disabled = true;
                    list2[i].checked = false;
                    $('#me'+i).html(" ");
                }
              
            }
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
            color:black;
            font:12px;
            height:25px;
            text-align:center;
            border-color:black;
            border-width:1px;
            font-weight:bold;
            padding:2px;
        }
    </style>
    <body>
        <FORM NAME="UPDATE_READINGS" METHOD="POST">
            <!-- Hidden -->
            <input type="hidden" id="sNoOfLinks" name="sNoOfLinks" value="<%=sNoOfLinks%>" />
            <input type="hidden" id="fullUrl" name="fullUrl" value="<%=fullUrl%>" />
            <input type="hidden" id="url" name="url" value="<%=url%>" />
            <input type="hidden" id="source" name="source" value="<%=source%>" />
            <input type="hidden" id="sites" name="sites" value="<%=sites%>" />
            <input type="hidden" id="interval" name="interval" value="<%=interval%>" />
            <input type="hidden" id="typeOfRateValues" name="typeOfRateValues" value="<%=typeOfRateValues%>" />
            <input type="hidden" id="type" name="type" value="<%=type%>" />
            <input type="hidden" id="brand" name="brand" value="<%=brand%>" />
            <input type="hidden" id="ids" name="ids" value="<%=ids%>" />
            <input type="hidden" id="siteAll" name="siteAll" value="<%=siteAll%>" />
            <input type="hidden" id="mainFilter" name="mainFilter" value="<%=mainFilter%>" />
            <input type="hidden" id="searchBy" name="searchBy" value="<%=searchBy%>" /> <%-- used when updating
            readings of equipments --%>
            <!-- End Hidden -->

            <DIV align="left" STYLE="color:blue; margin-left: 30px;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button    onclick="JavaScript:cancelForm();" class="button"><%=cancel_button_label%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
                <button type="button" onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV>
            <br>

            <FIELDSET class="set" align="center" style="width: 90%">
                <legend align="center">
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"><%=sTitle%></font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <center>
                    <table align="center">
                        <%
                            if (null != status) {
                        %>
                        <TR BGCOLOR="FBE9FE">
                            <TD STYLE="<%=style%>"  colspan="3" class="td">
                                <%
                                if (status.equalsIgnoreCase("ok")) {%>
                                <B><FONT FACE="tahoma" color='blue'><%=sStatus%><%=updatedEquips%></FONT></B>
                                    <%} else {%>
                                <B><FONT FACE="tahoma" color='blue'><%=fStatus%></FONT></B>
                                    <%}%>
                            </TD>
                        </TR>
                        <%
                        }

                        if (noOfLinks > 1) {%>

                        <tr>
                            <td class="td" >
                                <b><font size="2" color="red">Page No:</font><font size="2" color="black">&nbsp; <%=count + 1%>&nbsp;</font><font size="2" color="red">of&nbsp;</font><font size="2" color="black"> <%=noOfLinks%></font></b>
                            </td>
                            <td class="td"  >
                                <select id="selectIdTop" onchange="javascript:getTasksTop();">
                                    <%for (int i = 0; i < noOfLinks; i++) {%>
                                    <option value="<%=i%>" <%if (i == count) {%> selected <% }%> ><%=i + 1%></option>
                                    <% }%>
                                </select>
                            </td>
                        </tr>
                    </table>
                    <%}%>

                    <br>
                    <div style="border:0px solid black;width:95%" >
                        <TABLE class="sortable row" ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="90%" CELLPADDING="0" CELLSPACING="0">
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
                                    <B><%=last%> </B>
                                </TD>
                                <TD CLASS="thead" nowrap WIDTH="20%">
                                    <input type="checkbox" name="updateR" id="updateR" onclick="checkUpdateall();" value="123" ><B><%=updateReading%></B>
                                </TD>
                                <TD CLASS="thead" nowrap WIDTH="20%">
                                    <B><%=dateOfLast%></B>
                                </TD>
                            </TR>
                            <%
                                WebBusinessObject wboDetails;
                                int lastReading, prevReading, diffReading, temp;
                                long timeByMilleSecond;
                                Date dateOfLastReading;
                                String strDateOfLastReading, typeOfRate;
                                for (int i = 0; i < equipmentsWithReading.size(); i++) {
                                    wboDetails = (WebBusinessObject) equipmentsWithReading.get(i);
                                    iTotal++;

                                    typeOfRate = (String) wboDetails.getAttribute("typeOfRate");
                                    if (typeOfRate.equals("fixed")) {
                                        typeOfRate = equipHr;
                                        wboDetails.setAttribute("typeOfRate", "Hour");
                                    } else {
                                        typeOfRate = equipKm;
                                        wboDetails.setAttribute("typeOfRate", "Kilo Meter");
                                    }

                                    lastReading = Integer.valueOf((String) wboDetails.getAttribute("lastReading")).intValue();
                                    prevReading = Integer.valueOf((String) wboDetails.getAttribute("previousReading")).intValue();

                                    // to resolve Old Entry data
                                    if (lastReading < prevReading) {
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

                            <script>
                        lastReadings.push(<%=lastReading%>);
                            </script>

                            <TR bgcolor="<%=bgColor%>">

                                <TD CLASS="row" >
                                    <%=iTotal%>
                                </TD>

                                <TD CLASS="row" >
                                    <b><%=wboDetails.getAttribute("unitNo")%> </b>
                                </TD>

                                <TD CLASS="row" >
                                    <b><%=wboDetails.getAttribute("unitName")%> </b>
                                </TD>
                                <TD CLASS="row" >
                                    <b> <%=typeOfRate%> </b>
                                </TD>
                                <TD CLASS="row" >
                                    <b> <%=lastReading%> </b>
                                </TD>
                                <TD CLASS="row" >
                                    <input type="checkbox" name="updateReading" id="updateReading<%=i%>" onclick="enableUpdate(<%=i%>);" value="<%=wboDetails.getAttribute("unitId")%>" >&ensp;
                                    <input type="text" name="newReading" id="newReading<%=i%>" maxlength="9" style="width:80px" onblur="checkNewReading(<%=i%>);" disabled/>
                                </TD>
                                <TD CLASS="row"  nowrap>
                                    <b> <%=strDateOfLastReading%> <div STYLE="color:red" id="me<%=i%>"></div> </b>
                                </TD>
                            </TR>

                            <%
                                }
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
                <BR><BR>
            </FIELDSET>
        </FORM>
    </body>
</html>
