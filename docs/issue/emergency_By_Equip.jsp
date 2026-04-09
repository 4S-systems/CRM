<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants,com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <%
    
    WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
    
    Vector tradeList = (Vector) user.getAttribute("vecTradeList");
    ArrayList listTrade = new ArrayList();
    
    for(int i = 0; i < tradeList.size(); i++){
        WebBusinessObject tradeWbo = (WebBusinessObject) tradeList.get(i);
        
        listTrade.add(tradeWbo.getAttribute("tradeName").toString());
        
    }
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    MaintenanceMgr maintenanceMgr = MaintenanceMgr.getInstance();
    IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();
    UrgencyMgr urgencyMgr = UrgencyMgr.getInstance();
    IssueMgr issueMgr=IssueMgr.getInstance();
    EmployeeMgr empMgr = EmployeeMgr.getInstance();
    FailureCodeMgr failureCodeMgr=FailureCodeMgr.getInstance();
    DepartmentMgr deptMgr = DepartmentMgr.getInstance();
    
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    ArrayList arrUrgency = urgencyMgr.getCashedTableAsBusObjects();
    ArrayList arrDep = deptMgr.getCashedTableAsBusObjects();
    
    ArrayList groupList = new ArrayList();
    groupList.add("A");
    groupList.add("B");
    groupList.add("C");
    groupList.add("D");
    
    ArrayList ShiftList = new ArrayList();
    ShiftList.add("1");
    ShiftList.add("2");
    ShiftList.add("3");
    
    //ArrayList Urgency = new ArrayList();
    //Urgency.add("High  ");
    //Urgency.add("Med  ");
    //Urgency.add("Low ");
    
    int trade = tradeList.size();
    ArrayList arrayListTemp = new ArrayList();
    arrayListTemp = maintainableMgr.getCashedTableAsBusObjects();
    ArrayList arrayList = new ArrayList();
    for(int i = 0; i < arrayListTemp.size(); i++){
        WebBusinessObject wbo = (WebBusinessObject) arrayListTemp.get(i);
        if(wbo.getAttribute("isMaintainable").toString().equalsIgnoreCase("1")){
            arrayList.add(wbo.getAttribute("unitName").toString());
        }
    }
    String equipmentID = (String) request.getAttribute("equipmentID");
    String status = (String) request.getAttribute("Status");
    Vector vec = new Vector();
    Vector vec1 = new Vector();
    
    String UnitName=request.getParameter("unitName");
    String ScheduleTitle=request.getParameter("maintenanceTitle");
    
    String UnitId=issueMgr.getUnitId(UnitName);
    String ScheduleId=issueMgr.getScheduleId(ScheduleTitle);
    
    String equId=(String) request.getAttribute("UnitId");
    
    String sID=(String) request.getAttribute("sID");
    
    String ScheduleUnitId=(String) request.getAttribute("ScheduleUnitId");
    String issueTitle=(String) request.getAttribute("issueTitle");
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    // String ScheduleId=request.getParameter("ScheduleId");
    
    //  ArrayList listTrade = new ArrayList();
    //  listTrade.add(tradeList);
    //listTrade.add("Electrical");
    // listTrade.add("Civil");
    // listTrade.add("Instrument");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,cancel,save,Titel,sTitel,MUnit,ReceivedBY,Fcode,WorkType,uLevel,
            eTime,eBDate,eEDate,pDesc,sStatus,canCon,configNow,configure, sNoData,group,shift,jobNo;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        
        cancel="Cancel";
        save="Create";
        Titel="New Emergency Task ";
        sTitel="Schedule Title ";
        MUnit="Maintained Unit ";
        ReceivedBY="Required By";
        Fcode="Failure Code ";
        WorkType="Work Order Trade ";
        uLevel="Urgency Level Type ";
        
        eTime="Estimated Duration ";
        eBDate="Expected Begin Date ";
        eEDate="Expected End Date ";
        pDesc="Problem Description ";
        sStatus="Save Status ";
        canCon="You Can't bind That task with spare parts ";
        configNow="If You Want To Configure That Task now ";
        configure="Press Here";
        sNoData = "No Data are available for";
        group = "Group";
        shift = "Shift";
        jobNo="Job Order NO";
        
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        cancel=tGuide.getMessage("cancel");
        Titel=" &#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1591;&#1575;&#1585;&#1609;&#1569;";
        sStatus="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        canCon="&#1604;&#1575; &#1578;&#1587;&#1578;&#1591;&#1610;&#1593; &#1585;&#1576;&#1591; &#1607;&#1584;&#1575; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604; &#1576;&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        configNow="&#1607;&#1604; &#1578;&#1585;&#1610;&#1583; &#1585;&#1576;&#1591; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1570;&#1606; &#1567;";
        configure="&#1573;&#1590;&#1594;&#1591; &#1607;&#1606;&#1575; ";
        sTitel=" &#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
        MUnit="&#1575;&#1604;&#1608;&#1581;&#1583;&#1607; &#1575;&#1604;&#1605;&#1589;&#1575;&#1606;&#1607;";
        ReceivedBY="&#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1577; &#1575;&#1604;&#1591;&#1575;&#1604;&#1576;&#1577;";
        Fcode=" &#1575;&#1604;&#1603;&#1608;&#1583;";
        WorkType=" &#1606;&#1608;&#1593; &#1571;&#1605;&#1585; &#1575;&#1604;&#1593;&#1605;&#1604;";
        uLevel=" &#1583;&#1585;&#1580;&#1577; &#1575;&#1604;&#1571;&#1607;&#1605;&#1576;&#1607;";
        save=" &#1587;&#1580;&#1604;";
        eTime="&#1575;&#1604;&#1605;&#1583;&#1607; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;&#1607; &#1604;&#1578;&#1606;&#1601;&#1610;&#1584; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        eBDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
        eEDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1607; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
        pDesc=" &#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1588;&#1603;&#1604;&#1607;";
        sNoData = "&#1604;&#1610;&#1587; &#1607;&#1606;&#1575;&#1603; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607; &#1604;";
        group= "&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
        shift = "&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1577;";
        jobNo="&#1585;&#1602;&#1605; &#1573;&#1584;&#1606; &#1575;&#1604;&#1588;&#1594;&#1604; :";
    }
    
    if(arrayList.size() == 0){
        sNoData = sNoData + " '" + MUnit + "'";
    }
    
    if(arrUrgency.size() == 0){
        sNoData = sNoData + " '" + uLevel + "'";
    }
    
    if(arrDep.size() == 0){
        sNoData = sNoData + " '" + ReceivedBY + "'";
    }
    WebBusinessObject wboEquip= (WebBusinessObject) maintainableMgr.getOnSingleKey(equipmentID);
    
    // get current date
    Calendar cal = Calendar.getInstance();
    WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
    String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowDate=sdf.format(cal.getTime());
    
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new Schedule</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
    </HEAD>
    <script src='silkworm_validate.js' type='text/javascript'></script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
            if (!validateData("req", this.ISSUE_FORM.estimatedduration, "Please, enter Estimated Duration Number.") || !validateData("numeric", this.ISSUE_FORM.estimatedduration, "Please, enter a valid Number for Estimated Duration Number.")){
                this.ISSUE_FORM.estimatedduration.focus(); 
            } else if (!validateData("req", this.ISSUE_FORM.issueDesc, "Please, enter Problem Description.")){
                this.ISSUE_FORM.issueDesc.focus();
            } else {
                document.ISSUE_FORM.action = "<%=context%>/IssueServlet?op=CreateEmgByEquip&equipmentID=<%=equipmentID%>&currentMode=<%=cMode%>";
                document.ISSUE_FORM.submit();  
            }
        }
        
        function refreshData(){
        document.ISSUE_FORM.submit();	
        }
        
         function clearValue(no){
        document.getElementById('Quantity' + no).value = '0';
        total();
    }
function cancelForm()
        {    
        document.ISSUE_FORM.action ="<%=context%>/UnitDocReaderServlet?op=ViewImages&equipmentID=<%=equipmentID%>";
        document.ISSUE_FORM.submit();  
        }
        
        var dp_cal1,dp_cal2; 
        window.onload = function () {
            dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
            dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));

        }
        
    </SCRIPT>
    
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    
    <BODY>
        <left>     
        
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"> <%=cancel%> <IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <%
                if(null==status){
        if(arrayList.size() > 0 && arrDep.size() > 0 && arrUrgency.size() > 0){
                %>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save%><IMG HEIGHT="15" SRC="images/save.gif"></button>
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
                                <font color="blue" size="6">  <%=Titel%>  
                                </font>
                                
                            </td>
                        </tr>
                    </table>
                </legend>
                <%
                if(arrayList.size() == 0 || arrUrgency.size() == 0 || arrDep.size() == 0) {
                %>
                <BR><center><font color="red"><B><%=sNoData%></B></font></center>
                <%
                }
                %>
                <%    if(null!=status) {
                
                %>
                
                <table align="<%=align%>" dir="<%=dir%>">
                    <tr>
                        
                        <td  class="td" align="<%=align%>"> <b><font size=4 > <%=sStatus%>:<%=status%>  <b></td>
                        
                    </tr>
                </table>
                <br><br>
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>">
                    <TR>
                        <TD class='td'>
                            <input  type=HIDDEN name=UnitId size="30" value="<%=UnitId%>" maxlength="255">
                            <input  type=HIDDEN name=ScheduleId size="30" value="<%=ScheduleId%>" maxlength="255">
                            <input  type=HIDDEN name=maintenanceTitle size="30" value="Emergency" maxlength="255">
                            <% if (status.equals("Failed"))  {%>
                            <b><%=canCon%></b> &nbsp; 
                            <% } else { %>
                            
                            <%
                            //if(issueMgr.getActiveUnit(equId)) {
                            %>
                            <td class='td'>
                                <b><font size="3"> <%=jobNo%></font>
                                    
                            </b> &nbsp; </td>
                            <td class='td'> <b><font color="red" size="3"><%=sID%></font></b> </td>
                            <!--b> <%//=configNow%>
                            </b> &nbsp;
                            <a href="<%//=context%>/ScheduleServlet?op=configureEmg&machineId=<%=UnitId%>&scheduleId=<%=ScheduleId%>&periodicMntnce=<%=ScheduleUnitId%>&issueTitle=<%=issueTitle%>"><b><font color="red" size="2pt"> <%=configure%></font></b></a-->
                            <% //} else {%>        
                            <!-- <b> &#1604;&#1575; &#1578;&#1587;&#1578;&#1591;&#1610;&#1593; &#1585;&#1576;&#1591; &#1607;&#1584;&#1575; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604; &#1604;&#1571;&#1606; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591;&#1607;&nbsp; &#1576;&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;</body>
    </b> &nbsp;-->
    
                            <% //}
                            } %>
                        </TD>
                    </TR>
                </TABLE>
                <%
                }else{
                %>    
                
                
                
                
                <br><br>
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    
                    <TR>
                        <!--TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="ISSUE_TITLE">
                        <p><b><font color="#FF0000">*</font><font color="#003399"><%=sTitel%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="text" size="33" value="Emergency" maxlength="255" style="width:230px">
                            
                            
                        </TD-->
                        <input  type=HIDDEN name=maintenanceTitle size="33" value="Emergency" maxlength="255">
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="unitName">
                                <p><b><font color="#FF0000">*</font><font color="#003399"><%=MUnit%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            
                            <INPUT TYPE="text" name="unitName" id="unitName" name="failurecode" value="<%=wboEquip.getAttribute("unitName").toString()%>" READONLY>
                            </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="assign_to">
                                <p><b><font color="#003399"><%=ReceivedBY%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                            <SELECT name="receivedby" style="width:230px">
                                <sw:WBOOptionList wboList='<%=arrDep%>' displayAttribute = "departmentName" valueAttribute="departmentID"/>
                            </SELECT>
                            
                        </TD>
                        
                        <TD STYLE="<%=style%>" class='td' >
                            <!--<LABEL FOR="assign_to">
                            <p><b><font color="#FF0000">*</font><font color="#003399"><%//=Fcode%></font></b>&nbsp;
                            </LABEL>-->
                        </TD>
                        <TD STYLE="<%=style%>" class='td' WIDTH="33">
                            <INPUT TYPE="hidden" name="failurecode" value="1">
                            <!--<SELECT name="failurecode" style="width:230px">
                            <//sw:WBOOptionList wboList='<%//=failureCodeMgr.getCashedTableAsBusObjects()%>' displayAttribute = "title" valueAttribute="id"/>
                            </SELECT>-->
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="trade">
                                <p><b><font color="#FF0000">*</font><font color="#003399"><%=WorkType%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td' WIDTH="33">
                            <!--input type="TEXT" name="itemUnit" ID="itemUnit" size="33" value="" maxlength="255"-->
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
                        
                        
                        <input type=HIDDEN name=issueTitle value="Emergency" size="33">
                        <%
                        
                        ArrayList arrList = maintenanceMgr.getCashedTableAsArrayList();
                        %>
                        
                        <!--input type=HIDDEN name=FAName value="Emergency" size="33"-->
                        
                        
                        <!--TR-->
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Urgency_Name">
                                <p><b><font color="#FF0000">*</font><font color="#003399"><%=uLevel%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td' WIDTH="33">
                            <SELECT name="urgencyName" style="width:230px">
                                <sw:WBOOptionList wboList='<%=arrUrgency%>' displayAttribute = "urgencyName" valueAttribute="urgencyName"/>
                            </SELECT>
                        </TD>
                    </TR>
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="trade">
                                <p><b><font color="#FF0000">*</font><font color="#003399"><%=group%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td' WIDTH="33">
                            <!--input type="TEXT" name="itemUnit" ID="itemUnit" size="33" value="" maxlength="255"-->
                            <select name="FAName" ID="FAName" style="width:230px">
                                <%
                                for(int i = 0; i < groupList.size(); i++){
                                %>
                                <option value="<%=groupList.get(i)%>"><%=groupList.get(i)%>
                                <%
                                }
                                %>
                            </select>
                        </TD>
                        
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="trade">
                                <p><b><font color="#FF0000">*</font><font color="#003399"><%=shift%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td' WIDTH="33">
                            <!--input type="TEXT" name="itemUnit" ID="itemUnit" size="33" value="" maxlength="255"-->
                            <select name="groupNum" ID="groupNum" style="width:230px">
                                <%
                                for(int i = 0; i < ShiftList.size(); i++){
                                %>
                                <option value="<%=ShiftList.get(i)%>"><%=ShiftList.get(i)%>
                                <%
                                }
                                %>
                            </select>
                        </TD>
                    </TR>
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    
                    <!--TR>
                        <TD STYLE="<!%=style%>" class='td' >
                            <LABEL FOR="estimatedduration">
                                <p><b><font color="#FF0000">*</font><font color="#003399"><!%=eTime%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<!%=style%>" class='td' WIDTH="4">
                            
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR-->
                    <input type="hidden" style="width:230px" name="estimatedduration" ID="estimatedduration" value="0">
                    <input type=HIDDEN name=totalCost value="0" >
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
                    <tr>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="EXPECTED_B_DATE">
                                <b><font color="#FF0000">*</font><font color="#003399"><%=eBDate%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <td STYLE="<%=style%>"class="td">
                            
                            <input name="beginDate" id="beginDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" > 
                        </td>
                        <%
                        if(request.getParameter("endDate") != null){
                        String[] arDate = request.getParameter("endDate").split("/");
                        TimeServices.setDate(arDate[2] + "-" + arDate[0] + "-" + arDate[1]);
                        c.setTimeInMillis(TimeServices.getDate());
                        }
                        %>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="EXPECTED_E_DATE">
                                <p><b><font color="#FF0000">*</font><font color="#003399"><%=eEDate%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <td STYLE="<%=style%>" class="td">
                            <input name="endDate" id="endDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" >
                        </td>
                    </tr>
                    
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Maintenance_Desc">
                                <p><b><font color="#FF0000">*</font><font color="#003399"><%=pDesc%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>"  class='td'>
                            <%
                            if(request.getParameter("issueDesc") != null){
                            %>
                            <TEXTAREA rows="5" name="issueDesc" ID="issueDesc" cols="28" style="width:230px"><%=request.getParameter("issueDesc")%></TEXTAREA>
                            <%
                            } else {
                            %>
                            <TEXTAREA rows="5" name="issueDesc" cols="28" style="width:230px"></TEXTAREA>
                            <%
                            }
                            %>
                            
                        </TD>
                    </TR>
                    
                </TABLE>
                <% } %>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
