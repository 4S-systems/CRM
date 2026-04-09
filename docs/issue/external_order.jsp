<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants,com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>

<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    SupplierMgr supplierMgr = SupplierMgr.getInstance();
    FailureCodeMgr failureCodeMgr = FailureCodeMgr.getInstance();
    UrgencyMgr urgencyMgr = UrgencyMgr.getInstance();
    String issueId = request.getParameter("issueId");
    String filterName = request.getParameter("filterName");
    String filterValue = request.getParameter("filterValue");

    String context = metaMgr.getContext();
    String status = (String) request.getAttribute("Status");
    String message = "";
    
    ArrayList arrUrgency = urgencyMgr.getCashedTableAsBusObjects();
    ArrayList arrFailure = failureCodeMgr.getCashedTableAsBusObjects();
    ArrayList arrSupplier = supplierMgr.getCashedTableAsBusObjects();

    ArrayList arrayListTemp = new ArrayList();
    arrayListTemp = maintainableMgr.getCashedTableAsBusObjects();
    ArrayList arrayList = new ArrayList();
    for (int i = 0; i < arrayListTemp.size(); i++) {
        WebBusinessObject wbo = (WebBusinessObject) arrayListTemp.get(i);
        if (wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")) {
            arrayList.add(wbo.getAttribute("unitName").toString());
        }
    }

    // get current date and Time
    Calendar cal = Calendar.getInstance();
    WebBusinessObject loggedUser = (WebBusinessObject) session.getAttribute("loggedUser");
    String jDateFormat = loggedUser.getAttribute("javaDateFormat").toString();
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowDate = sdf.format(cal.getTime());

    String issueStatus = (String) request.getAttribute("issueStatus");
    
    
    
    ArrayList listTrade = new ArrayList();
    listTrade.add("Mechanical");
    listTrade.add("Electrical");
    listTrade.add("Civil");
    listTrade.add("Instrument");

    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode, cancel, cost, maint, save, reason1, reason2, reason3, Titel, addTaskNote,sTitel, MUnit, ReceivedBY, Fcode, uLevel, eBDate, pDesc, M1, M2, sNoData, sLaborCost, sPartCost, attache, externalType, part, total, noTaskNote;
    if (stat.equals("En")) {
        align = "center";
        dir = "LTR";
        style = "text-align:left";
        lang = "&#1593;&#1585;&#1576;&#1610;";
        langCode = "Ar";

        cancel = "Cancel";
        save = "Create";
        Titel = "New External Task ";
        sTitel = "Schedule Title ";
        MUnit = "Maintained Unit ";
        ReceivedBY = "To Importer ";
        Fcode = "Failure Code ";
        uLevel = "Urgency Level Type ";
        M1 = "Success";
        M2 = "There Is a problem In Creation";
        eBDate = "Conversion Date";
        pDesc = "Warranty Detail";
        sNoData = "No Data are available for";
        save = "Create";
        sLaborCost = "Labor Cost";
        sPartCost = "Part Cost";
        attache = "Attach Copy of the Invoice";
        part = "Part";
        externalType = "External Type";
        total = "Totaly";
        reason1 = "Resources Needed Not Found";
        reason2 = "Under Warranty";
        reason3 = "Others";
        maint = " Maintenance View ";
        cost = "Cost";
        addTaskNote = "You must Start The JobOrder ";
        noTaskNote = "You must add maintenance item";
    } else {
        align = "center";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        cancel = tGuide.getMessage("cancel");
        Titel = "&#1578;&#1581;&#1608;&#1610;&#1604; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1575;&#1604;&#1609; &#1575;&#1604;&#1608;&#1603;&#1610;&#1604;";
        M1 = "&#1578;&#1605; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1576;&#1606;&#1580;&#1575;&#1581; ";
        M2 = "&#1607;&#1606;&#1575;&#1603; &#1605;&#1588;&#1603;&#1604;&#1577; &#1601;&#1609; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        sTitel = " &#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
        MUnit = "&#1575;&#1604;&#1608;&#1581;&#1583;&#1607; &#1575;&#1604;&#1605;&#1589;&#1575;&#1606;&#1607;";
        ReceivedBY = " &#1604;&#1604;&#1605;&#1608;&#1585;&#1583;";
        Fcode = " &#1575;&#1604;&#1603;&#1608;&#1583;";
        uLevel = " &#1583;&#1585;&#1580;&#1577; &#1575;&#1604;&#1571;&#1607;&#1605;&#1576;&#1607;";
        save = " &#1587;&#1580;&#1604; &#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1607; ";
        eBDate = "&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1578;&#1581;&#1608;&#1610;&#1604;";
        pDesc = "&#1578;&#1601;&#1589;&#1610;&#1604; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
        sNoData = "&#1604;&#1610;&#1587; &#1607;&#1606;&#1575;&#1603; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607; &#1604;";
        save = " &#1587;&#1580;&#1604;";
        sLaborCost = "&#1578;&#1603;&#1604;&#1601;&#1577; &#1575;&#1604;&#1593;&#1605;&#1575;&#1604;&#1577;";
        sPartCost = "&#1578;&#1603;&#1604;&#1601;&#1577; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        attache = "&#1575;&#1585;&#1601;&#1575;&#1602; &#1589;&#1608;&#1585;&#1577; &#1575;&#1604;&#1601;&#1575;&#1578;&#1608;&#1585;&#1577;";
        total = "&#1603;&#1604;&#1610;";
        externalType = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1578;&#1581;&#1608;&#1610;&#1604;";
        part = "&#1580;&#1586;&#1574;&#1610;";
        reason1 = "&#1593;&#1583;&#1605; &#1578;&#1608;&#1601;&#1585; &#1575;&#1604;&#1605;&#1608;&#1575;&#1585;&#1583;";
        reason2 = "&#1578;&#1581;&#1578; &#1575;&#1604;&#1590;&#1605;&#1575;&#1606;";
        reason3 = "&#1571;&#1582;&#1585;&#1609;";
        maint = "&#1576;&#1610;&#1575;&#1606; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        cost = "&#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1577;";
        addTaskNote="&#1610;&#1580;&#1576; &#1576;&#1583;&#1569; &#1578;&#1606;&#1601;&#1610;&#1584; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        noTaskNote = "\u064A\u062C\u0628 \u0625\u0636\u0627\u0641\u0629 \u0628\u0646\u0648\u062F \u0635\u064A\u0627\u0646\u0629 \u0623\u0648\u0644\u0627";
    }

    if (arrayList.size() == 0) {
        sNoData = sNoData + " '" + MUnit + "'";
    }

    if (arrUrgency.size() == 0) {
        sNoData = sNoData + " '" + uLevel + "'";
    }

    if (arrFailure.size() == 0) {
        sNoData = sNoData + " '" + Fcode + "'";
    }

    if (arrSupplier.size() == 0) {
        sNoData = sNoData + " '" + ReceivedBY + "'";
    }

    Vector checkTasksVec = new Vector();
    IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
    checkTasksVec = issueTasksMgr.getOnArbitraryKey(issueId, "key1");
    IssueMgr issueMgr = IssueMgr.getInstance();
%>

<script src='silkworm_validate.js' type='text/javascript'></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    var dp_cal1;
    window.onload = function () {
        dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('conversionDate'));
    };
    function compareDate()
    {
        return Date.parse(document.getElementById("conversionDate").value) >= Date.parse(document.getElementById("actualBeginDate").value) ;
    }

    function submitForm(){

        var type = document.getElementsByName("type");
        var length = type.length;
        for(var i = 0; i < length; i++){
            if(type[i].checked == true){
                if(type[i].getAttribute("id") == "part"){
                    if(<%=checkTasksVec.size()%> == 0){
                    
                        alert("<%=noTaskNote%>");
                        return;
                    }
                }
            }
        }
        if (!compareDate()){
            if(<%=stat.equals("En")%>){
                alert('ConversionDate Date ('+document.getElementById('conversionDate').value+') must be greater than Actual Begin Date (' + document.getElementById("actualBeginDate").value + ')');
            }else{
                alert('\u062A\u0627\u0631\u064A\u062E \u0627\u0644\u062A\u062D\u0648\u064A\u0644 '+document.getElementById('conversionDate').value+' \u064A\u062C\u0628 \u0623\u0646 \u064A\u0643\u0648\u0646 \u0623\u0643\u0628\u0631 \u0645\u0646 \u0623\u0648 \u064A\u0633\u0627\u0648\u064A \u062A\u0627\u0631\u064A\u062E \u0627\u0644\u0628\u062F\u0621 \u0627\u0644\u0641\u0639\u0644\u064A ' + document.getElementById("actualBeginDate").value);
            }
            document.getElementById('conversionDate').focus();
            return false;
        }
        if(document.getElementById('conversionDate').value==""){
            alert("Please, enter Date.");
            document.getElementById('conversionDate').focus();
            return;
        }else if(document.getElementById('reason').value==""){
            alert("Please, enter Conversion Reason.");
            document.getElementById('reason').focus();
            return;
        }else if(!IsNumeric(document.getElementById('laborCost').value) || document.getElementById('laborCost').value==""){
            alert("Please, enter Cost.");
            document.getElementById('laborCost').focus();
            return;
        }else if(document.getElementById('maintView').value=="" ){
            alert("Please fill needed fields.");
            return;
        }else if("<%=request.getAttribute("tasks")%>" == "true" ){
            if(document.getElementById("total").checked){
                alert("Some Tasks Assigned to this Job Order Please Delete them First");
                return;
            }
        }
        if(document.getElementById("imageName").value == "") {
            var reply = confirm("Submit Order with out Photo ?");
            if(reply == true)
            {
                document.EXTERNAL_ORDER_FORM.action = "<%=context%>/IssueServlet?op=SaveExternalJob&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
                document.EXTERNAL_ORDER_FORM.submit();
            }
        }
        else
        {
            document.EXTERNAL_ORDER_FORM.action = "<%=context%>/IssueServlet?op=SaveExternalJob&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
            document.EXTERNAL_ORDER_FORM.submit();
        }
    }

    function cancelForm() {
        document.EXTERNAL_ORDER_FORM.action = "<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.EXTERNAL_ORDER_FORM.submit();  
    }

    function changePic() {
        var fileName = document.getElementById("file1").value;
        if(fileName.length > 0){
            if(fileName.indexOf("jpg") > -1 || fileName.indexOf("JPG") > -1){
                document.getElementById("imageName").value = fileName;
                //getLoadingImage();
                document.getElementById("file1").value = '';
                //getImage('<%=context%>', fileName, 200, 200);
            } else {
                alert("Invalid Image type, required JPG Image.");
                document.getElementById("file1").focus();
                //getNoImage();
                document.getElementById("imageName").value = "";
            }
        } else {
            //getNoImage();
            document.getElementById("imageName").value = "";
        }
    }
</SCRIPT>

<script src='js/ChangeLang.js' type='text/javascript'></script>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>New External Job Order</TITLE>
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
        <script type="text/javascript" src="js/epoch_classes.js"></script>
    </HEAD>

    <BODY>
        <FORM action=""  NAME="EXTERNAL_ORDER_FORM" METHOD="POST" ENCTYPE="multipart/form-data">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"> <%=cancel%> <IMG alt="" SRC="images/cancel.gif"></button>
                    <%
                        if (null == status) {
                            if (arrayList.size() > 0 && arrFailure.size() > 0 && arrUrgency.size() > 0 && arrSupplier.size() > 0) {
                             %>
                <button  onclick="JavaScript: submitForm();" class="button"><%=save%> <IMG alt="" HEIGHT="15" SRC="images/save.gif"></button>
                    <%
                            }
                        }
                    %>
            </DIV>
            <br>
            <center>
                <fieldset class="set" style="width:95%;border-color: #006699;" >
                    <table class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD"><FONT color="#F3D596" size="4"><%=Titel%></FONT></td>
                        </tr>
                    </table>
                        
                        

                    <%
                        if (arrayList.size() == 0 || arrUrgency.size() == 0 || arrFailure.size() == 0 || arrSupplier.size() == 0) {
                    %>
                    <BR><center><font color="red"><B><%=sNoData%></B></font></center>
                        <%
                            }
                        %>
                        <%
                            if (null != status) {
                        %>

                    <br>

                    <%
                        if (status.equalsIgnoreCase("ok")) {
                            message = M1;
                        } else {
                            message = M2;
                        }
                    %>

                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                        <TR BGCOLOR="FBE9FE">
                            <TD STYLE="<%=style%>" class="td">
                                <B><FONT FACE="tahoma" color='blue'><%=message%></FONT></B>
                            </TD>
                        </TR>
                    </TABLE>
                    <br><br>
                    <%
                    } else {
                    %>
                    <%--if (checkTasksVec.size() > 0  ) { --%>
                    <%if(!(issueStatus.equalsIgnoreCase("Schedule"))){%>
                    
                    <br>
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                        <TR>
                            <TD class="td" width="50%">
                                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                                    <TR>
                                        <TD STYLE="<%=style%>;font-size: 15px" class="td"><b><%=sTitel%></b></TD>
                                        <TD STYLE="<%=style%>" class='td'>
                                            <input disabled type="text" size="25" value="External" maxlength="255" style="width:230px">
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD STYLE="<%=style%>;font-size: 15px" class="td"><b><%=ReceivedBY%></b></TD>
                                        <TD STYLE="<%=style%>" class='td'>
                                            <SELECT name="receivedby" style="width:230px">
                                                <sw:WBOOptionList wboList='<%=arrSupplier%>' displayAttribute = "name" valueAttribute="id"/>
                                            </SELECT>
                                        </TD>
                                    </TR>

                                    <TR>
                                        <TD STYLE="<%=style%>" class="td"><FONT FACE="tahoma"><b><%=externalType%><font color="#FF0000">*</font>&nbsp;</b></font></TD>
                                        <TD STYLE="<%=style%>" class='td'>
                                            <input checked type="radio" name="type" id="part" value="<%=ExternalJobMgr.PART%>" />&nbsp;<%=part%>
                                            &nbsp;&nbsp;&nbsp;
                                            <input type="radio" id="total" name="type" value="<%=ExternalJobMgr.TOTAL%>" />&nbsp;<%=total%>
                                        </TD>
                                    </TR>

                                    <%
                                        String actualBeginDate = issueMgr.getActualBeginDateFormat(issueId);
                                        actualBeginDate = actualBeginDate.substring(0, 10);
                                        actualBeginDate = actualBeginDate.replaceAll("-", "/");
                                        Calendar c = Calendar.getInstance();
                                        if (request.getParameter("conversionDate") != null) {
                                            String[] arDate = request.getParameter("conversionDate").split("/");
                                            TimeServices.setDate(arDate[2] + "-" + arDate[0] + "-" + arDate[1]);
                                            c.setTimeInMillis(TimeServices.getDate());
                                        }
                                    %>
                                    <TR>
                                        <TD STYLE="<%=style%>;font-size: 15px" class="td"><b><%=eBDate%></b></TD>
                                        <td STYLE="<%=style%>"  class="calender">
                                            <input id="conversionDate" name="conversionDate" type="text" value="<%=nowDate%>"><img alt="" src="images/showcalendar.gif" >
                                            <input id="actualBeginDate" name="actualBeginDate" type="hidden" value="<%=actualBeginDate%>" />
                                        </td>
                                    </TR>

                                    <!-- External Cost -->
                                    <TR>
                                        <TD STYLE="<%=style%>"  class="td"><FONT FACE="tahoma"><b><%=cost%><font color="#FF0000">*</font>&nbsp;</b></font></TD>
                                        <td STYLE="<%=style%>"  class="td">
                                            <input type="text" name="laborCost" id="laborCost" value="">
                                        </td>
                                    </TR>
                                    <!-- end -->

                                    <TR style="display: none;">
                                        <TD STYLE="<%=style%>;font-size: 15px"  class="td"><b><%=sPartCost%></b></TD>
                                        <td STYLE="<%=style%>"  class="td">
                                            <input type="text" name="partCost" id="partCost" value="0">
                                        </td>
                                    </TR>

                                    <TR>
                                        <TD STYLE="<%=style%>" class="td"><FONT FACE="tahoma"><b><%=pDesc%><font color="#FF0000">*</font>&nbsp;</b></font></TD>
                                        <TD STYLE="<%=style%>"class='td' COLSPAN="3">
                                            <SELECT name="reason" style="width:230px">
                                                <option selected value="<%=reason1%>"><%=reason1%></option>
                                                <option value="<%=reason2%>"><%=reason2%></option>
                                                <option value="<%=reason3%>"><%=reason3%></option>
                                            </SELECT>
                                        </TD>
                                    </TR>

                                    <TR>
                                        <TD STYLE="<%=style%>" class="td"><FONT FACE="tahoma"><b><%=maint%><font color="#FF0000">*</font>&nbsp;</b></font></TD>
                                        <TD STYLE="<%=style%>"class='td' COLSPAN="3">
                                            <TEXTAREA rows="5" style="width:230px" name="maintStatment" id="maintView" cols="80"></TEXTAREA>
                                        </TD>
                                    </TR>

                                    <TR>
                                        <TD STYLE="<%=style%>;font-size: 15px" class="td"><b><%=attache%></b></TD>
                                        <TD STYLE="<%=style%>"class='td' COLSPAN="3">
                                            <input type="file" name="file1" style="height: 25px" id="file1" accept="*.jpg" onchange="JavaScript: changePic();">
                                            <input type="hidden" name="imageName" id="imageName" value="">
                                        </TD>
                                    </TR>

                                    <TR>
                                        <TD class="td">
                                            <input type="hidden" name="issueId" value="<%=issueId%>">
                                            <input type="HIDDEN" name="maintenanceTitle" size="30" value="External" maxlength="255">
                                            <input type="HIDDEN" name="issueTitle" value="External">
                                            <input type="HIDDEN" name="FAName" value="External">
                                            <input type="HIDDEN" name="typeName" value="External">
                                            <input type="HIDDEN" name="totalCost" value="0">
                                        </TD>
                                    </TR>
                                </TABLE>
                            </TD>
                            <TD class="td" width="5%">
                                &ensp;
                            </TD>
                            <TD class="td" width="45%">
                                <img width="250px" name='image' id='image' alt='invoice image' src='images/no_image.jpg' style="vertical-align: middle" align="middle" border="2">
                            </TD>
                        </TR>
                    </TABLE>
                                            
                    <%
                        }else{
                    
                    %>
                      <br>

                <table ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <tr>
                        <td nowrap>
                            <font size="3" color="red"><b> <%=addTaskNote%></b></font>
                        </td>
                    </tr>
                </table>
                <%
                        }
    }%>
                        <%--
                   }else{

                    %>
                      <br>

                <table ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <tr>
                        <td nowrap>
                            <font size="3" color="red"><b> <%=noTaskNote%></b></font>
                        </td>
                    </tr>
                </table>
                <%}}--%>
                
                    
                </fieldset>
            </center>
        </FORM>
    </BODY>
</HTML>