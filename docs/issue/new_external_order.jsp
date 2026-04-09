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
FailureCodeMgr failureCodeMgr=FailureCodeMgr.getInstance();
UrgencyMgr urgencyMgr = UrgencyMgr.getInstance();
IssueMgr issueMgr=IssueMgr.getInstance();

String context = metaMgr.getContext();
String status = (String) request.getAttribute("Status");
String message = "";

String UnitName=request.getParameter("unitName");
String ScheduleTitle=request.getParameter("maintenanceTitle");
String UnitId=issueMgr.getUnitId(UnitName);
String ScheduleId=issueMgr.getScheduleId(ScheduleTitle);
String equId=(String) request.getAttribute("UnitId");
String ScheduleUnitId=(String) request.getAttribute("ScheduleUnitId");
String issueTitle=(String) request.getAttribute("issueTitle");
ArrayList arrUrgency = urgencyMgr.getCashedTableAsBusObjects();
ArrayList arrFailure = failureCodeMgr.getCashedTableAsBusObjects();
ArrayList arrSupplier = supplierMgr.getCashedTableAsBusObjects();

ArrayList arrayListTemp = new ArrayList();
arrayListTemp = maintainableMgr.getCashedTableAsBusObjects();
ArrayList arrayList = new ArrayList();
for(int i = 0; i < arrayListTemp.size(); i++){
    WebBusinessObject wbo = (WebBusinessObject) arrayListTemp.get(i);
    if(wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")){
        arrayList.add(wbo.getAttribute("unitName").toString());
    }
}

ArrayList listTrade = new ArrayList();
listTrade.add("Mechanical");
listTrade.add("Electrical");
listTrade.add("Civil");
listTrade.add("Instrument");

// get current date
Calendar cal = Calendar.getInstance();
WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowDate=sdf.format(cal.getTime());

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,cancel,save,Titel,sTitel,MUnit,ReceivedBY,Fcode,WorkType,uLevel,
        eTime,eBDate,eEDate,pDesc,sStatus,canCon,configNow,configure,M1,M2, sNoData;
if(stat.equals("En")){
    
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    
    cancel="Cancel";
    save="Create";
    Titel="New External Task ";
    sTitel="Schedule Title ";
    MUnit="Maintained Unit ";
    ReceivedBY="To Importer ";
    Fcode="Failure Code ";
    WorkType="Work Order Trade ";
    uLevel="Urgency Level Type ";
    M1="Success";
    M2="There Is a problem In Creation";
    eTime="Estimated Duration ";
    eBDate="Expected Begin Date ";
    eEDate="Expected End Date ";
    pDesc="Problem Description ";
    sStatus="Save Status ";
    canCon="You Can't bind That task with spare parts ";
    configNow="If You Want To Configure That Task now ";
    configure="Press Here";
    sNoData = "No Data are available for";
    save="Create";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    cancel=tGuide.getMessage("cancel");
    Titel="   &#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1582;&#1575;&#1585;&#1580;&#1610;";
    M1="&#1578;&#1605; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1576;&#1606;&#1580;&#1575;&#1581; ";
    M2="&#1607;&#1606;&#1575;&#1603; &#1605;&#1588;&#1603;&#1604;&#1577; &#1601;&#1609; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    sStatus="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    canCon="&#1604;&#1575; &#1578;&#1587;&#1578;&#1591;&#1610;&#1593; &#1585;&#1576;&#1591; &#1607;&#1584;&#1575; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604; &#1576;&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
    configNow="&#1607;&#1604; &#1578;&#1585;&#1610;&#1583; &#1585;&#1576;&#1591; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1570;&#1606; &#1567;";
    configure="&#1573;&#1590;&#1594;&#1591; &#1607;&#1606;&#1575; ";
    sTitel=" &#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
    MUnit="&#1575;&#1604;&#1608;&#1581;&#1583;&#1607; &#1575;&#1604;&#1605;&#1589;&#1575;&#1606;&#1607;";
    ReceivedBY=" &#1604;&#1604;&#1605;&#1608;&#1585;&#1583;";
    Fcode=" &#1575;&#1604;&#1603;&#1608;&#1583;";
    WorkType=" &#1606;&#1608;&#1593; &#1571;&#1605;&#1585; &#1575;&#1604;&#1593;&#1605;&#1604;";
    uLevel=" &#1583;&#1585;&#1580;&#1577; &#1575;&#1604;&#1571;&#1607;&#1605;&#1576;&#1607;";
    save=" &#1587;&#1580;&#1604; &#1575;&#1604;&#1602;&#1585;&#1575;&#1569;&#1607; ";
    eTime="&#1575;&#1604;&#1605;&#1583;&#1607;";
    eBDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
    eEDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1607; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
    pDesc=" &#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1588;&#1603;&#1604;&#1607;";
    sNoData = "&#1604;&#1610;&#1587; &#1607;&#1606;&#1575;&#1603; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607; &#1604;";
    save=" &#1587;&#1580;&#1604;";
}

if(arrayList.size() == 0){
    sNoData = sNoData + " '" + MUnit + "'";
}

if(arrUrgency.size() == 0){
    sNoData = sNoData + " '" + uLevel + "'";
}

if(arrFailure.size() == 0){
    sNoData = sNoData + " '" + Fcode + "'";
}

if(arrSupplier.size() == 0){
    sNoData = sNoData + " '" + ReceivedBY + "'";
}

%>

<script src='silkworm_validate.js' type='text/javascript'></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function submitForm(){
        if (!validateData("req", this.EXTERNAL_ORDER_FORM.estimatedduration, "Please, enter Estimated Duration Number.") || !validateData("numeric", this.EXTERNAL_ORDER_FORM.estimatedduration, "Please, enter a valid Number for Estimated Duration Number.")){
                this.EXTERNAL_ORDER_FORM.estimatedduration.focus(); 
        } else if (!validateData("req", this.EXTERNAL_ORDER_FORM.issueDesc, "Please, enter Problem Description.")){
            this.EXTERNAL_ORDER_FORM.issueDesc.focus();
        } else {
            document.EXTERNAL_ORDER_FORM.action = "<%=context%>/IssueServlet?op=saveExternalOrder";
            document.EXTERNAL_ORDER_FORM.submit();  
        }
    }
    function cancelForm()
        {    
        document.EXTERNAL_ORDER_FORM.action = "<%=context%>/main.jsp";
        document.EXTERNAL_ORDER_FORM.submit();  
        }
        
        var dp_cal1,dp_cal2; 
        window.onload = function () {
            dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
            dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
        }
        
</SCRIPT>

<script src='ChangeLang.js' type='text/javascript'></script>

<HTML>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>New External Job Order</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
    <script type="text/javascript" src="js/epoch_classes.js"></script>
</HEAD>

<BODY>
    
    <FORM NAME="EXTERNAL_ORDER_FORM" METHOD="POST">
        
        
        
        <DIV align="left" STYLE="color:blue;">
            <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"> <%=cancel%> <IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
            <%
            if(null==status){
    if(arrayList.size() > 0 && arrFailure.size() > 0 && arrUrgency.size() > 0 && arrSupplier.size() > 0){
            %>
            <button  onclick="JavaScript:  submitForm();" class="button"><%=save%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
            <%
            }
            }
            %>
        </DIV>    
        
        <fieldset >
            <legend align="center">
                <table dir="rtl" align="center">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">    <%=Titel%>
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            <%
            if(arrayList.size() == 0 || arrUrgency.size() == 0 || arrFailure.size() == 0 || arrSupplier.size() == 0) {
            %>
            <BR><center><font color="red"><B><%=sNoData%></B></font></center>
            <%
            }
            %>
            <%    
            if(null!=status) {
            %>
            
            <br>
            
            <%
            if(status.equalsIgnoreCase("ok")){
                message  = M1;
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
                <TR>
                    <% 
                    if(status.equals("Failed")){
                    %>
                    <TD STYLE="<%=style%>" CLASS="shaded">
                        <Font FACE="tahoma" COLOR="red"><B><%=canCon%></B></FONT>
                    </TD>
                    <%
                    }else{
                    %>
                    <TD CLASS="shaded">
                        <Font FACE="tahoma"><B><%=configNow%></B></FONT>
                        <a href="<%=context%>/ScheduleServlet?op=configureEmg&machineId=<%=UnitId%>&scheduleId=<%=ScheduleId%>&periodicMntnce=<%=ScheduleUnitId%>&issueTitle=<%=issueTitle%>&type=extr"><b><font color="red" size="2pt" FACE="tahoma"><%=configure%></font></b></a>
                    </TD>
                    <%
                    }
                    %>
                </TR>
            </TABLE>
            <br><br>
            <%
            } else {
            %>
            
            <br>
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                <TR>
                    <TD STYLE="<%=style%>" class="td"><FONT FACE="tahoma"><b><%=sTitel%></b></font></TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input disabled type="text" size="25" value="External" maxlength="255" style="width:230px">
                    </TD>
                </TR>
                <TR>
                    <TD STYLE="<%=style%>" class="td"><FONT FACE="tahoma"><b><%=MUnit%><font color="#FF0000">*</font>&nbsp;</b></font></TD>
                    <TD STYLE="<%=style%>" class='td' WIDTH="30">
                        <SELECT name="unitName" style="width:230px">
                            <%
                            if(request.getParameter("unitName") != null){
                            %>
                            <sw:OptionList optionList = '<%=arrayList%>' scrollTo = "<%=request.getParameter("unitName")%>"/>                            
                            <%
                            } else {
                            %>
                            <sw:OptionList optionList = '<%=arrayList%>' scrollTo = ""/>
                            <%
                            }
                            %>
                        </SELECT>
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>" class="td"><FONT FACE="tahoma"><b><%=ReceivedBY%><font color="#FF0000">*</font>&nbsp;</b></font></TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <SELECT name="receivedby" style="width:230px">
                            <sw:WBOOptionList wboList='<%=arrSupplier%>' displayAttribute = "name" valueAttribute="id"/>
                        </SELECT>     
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>" class="td"><FONT FACE="tahoma"><b><%=Fcode%><font color="#FF0000">*</font>&nbsp;</b></font></TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <SELECT name="failurecode" style="width:230px">
                            <sw:WBOOptionList wboList='<%=arrFailure%>' displayAttribute = "title" valueAttribute="id"/>
                        </SELECT>
                    </TD>
                    
                    <TD STYLE="<%=style%>" class="td"><FONT FACE="tahoma"><b><%=WorkType%><font color="#FF0000">*</font>&nbsp;</b></font></TD> 
                    <TD STYLE="<%=style%>" class='td'>
                        <select name="workTrade" ID="workTrade" style="width:230px">
                            <%
                            for(int i = 0; i < listTrade.size(); i++){
                            %>
                            <option value="<%=listTrade.get(i)%>"><%=listTrade.get(i)%>
                            <%
                            }
                            %>
                        </select>
                        
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>" class="td"><FONT FACE="tahoma"><b><%=uLevel%><font color="#FF0000">*</font>&nbsp;</b></font></TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <SELECT name="urgencyName" style="width:230px">
                            <sw:WBOOptionList wboList='<%=arrUrgency%>' displayAttribute = "urgencyName" valueAttribute="urgencyName"/>
                        </SELECT>
                    </TD>
                    
                    <TD STYLE="<%=style%>"  class="td"><FONT FACE="tahoma"><b><%=eTime%><font color="#FF0000">*</font>&nbsp;</b></font></TD>
                    <TD STYLE="<%=style%>"  class='td'>
                        <input type="TEXT" style="width:230px" size="5" name="estimatedduration" ID="estimatedduration" value="" onblur="JavaScript: validatePhone(this, 'Not a valid Number');">
                    </TD>
                </TR>
                
                <%
                String url = request.getRequestURL().toString();
                String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                Calendar c = Calendar.getInstance();
                if(request.getParameter("beginDate") != null){
                    String[] arDate = request.getParameter("beginDate").split("/");
                    TimeServices.setDate(arDate[2] + "-" + arDate[0] + "-" + arDate[1]);
                    c.setTimeInMillis(TimeServices.getDate());
                }
                %>
                <TR>
                    <TD STYLE="<%=style%>"  class="td"><FONT FACE="tahoma"><b><%=eBDate%><font color="#FF0000">*</font>&nbsp;</b></font></TD>
                    <td STYLE="<%=style%>"  class="calender">
                        <input name="beginDate" id="beginDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" >                        
                    </td>
                    
                    <%
                    if(request.getParameter("endDate") != null){
                    String[] arDate = request.getParameter("endDate").split("/");
                    TimeServices.setDate(arDate[2] + "-" + arDate[0] + "-" + arDate[1]);
                    c.setTimeInMillis(TimeServices.getDate());
                    }
                    %>
                    <TD STYLE="<%=style%>" class="td"><FONT FACE="tahoma"><b><%=eEDate%><font color="#FF0000">*</font>&nbsp;</b></font></TD>
                    <td STYLE="<%=style%>" class="calender">
                        <input name="endDate" id="endDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" >
                    </td>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>" class="td"><FONT FACE="tahoma"><b><%=pDesc%><font color="#FF0000">*</font>&nbsp;</b></font></TD>
                    <TD STYLE="<%=style%>"class='td' COLSPAN="3">
                        <%
                        if(request.getParameter("issueDesc") != null){
                        %>
                        <TEXTAREA rows="5" style="width:230px" name="issueDesc" ID="issueDesc" cols="80"><%=request.getParameter("issueDesc")%></TEXTAREA>
                        <%
                        } else {
                        %>
                        <TEXTAREA rows="5" style="width:230px" name="issueDesc" cols="80"></TEXTAREA>
                        <%
                        }
                        %>  
                    </TD>
                </TR>
                
                <TR>
                    <TD class="td">
                        <input type="HIDDEN" name="maintenanceTitle" size="30" value="External" maxlength="255">
                        <input type="HIDDEN" name="issueTitle" value="External">
                        <input type="HIDDEN" name="FAName" value="External">
                        <input type="HIDDEN" name="typeName" value="External">
                        <input type="HIDDEN" name="totalCost" value="0">
                    </TD>
                </TR>
            </TABLE>
            <%
            }
            %>
        </fieldset>
    </FORM>
    </LEFT>
</BODY>
</html>