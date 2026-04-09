<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.contractor.db_access.MaintainableMgr" %>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
   
    WebBusinessObject wboIssue = (WebBusinessObject) request.getAttribute("wboIssue");
    WebBusinessObject wboEquipment = (WebBusinessObject) request.getAttribute("wboEquipment");
    ArrayList arrayCrewCodeList = (ArrayList) request.getAttribute("arrayCrewCodeList");
    String issueId = (String) request.getAttribute(IssueConstants.ISSUEID);
    String issueTitle = (String) request.getAttribute(IssueConstants.ISSUETITLE);
    String projectName = (String) request.getAttribute("projectName");
    String filterName = (String) request.getAttribute("filter");
    String filterValue = (String) request.getAttribute("filterValue");
    String uID = (String) request.getAttribute("uID");
    String scheduleId = (String) request.getAttribute("scheduleId");
    String averageUnitId = (String) request.getAttribute("averageUnitId");
    String readingNote = (String) request.getAttribute("readingNote");
    String longLastDateReading = (String) request.getAttribute("longLastDateReading");
    String dateReading = (String) request.getAttribute("dateReading");
    String existRowInAvgUnit = (String) request.getAttribute("existRowInAvgUnit");
    long lastReading = (Long) request.getAttribute("lastReading");
    long prvReading = (Long) request.getAttribute("prvReading");

    String status = (String) request.getAttribute("status");
    if(status == null) status = "";

    String cReading = request.getParameter("currentReading");
    if(cReading == null) cReading = "";
    
    // get current date and Time
    Calendar cal = Calendar.getInstance();
    SimpleDateFormat sdfTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String nowTime = sdfTime.format(cal.getTime());
    String hr = nowTime.substring(nowTime.length() - 8, nowTime.length() - 6);
    String min = nowTime.substring(nowTime.length() - 5, nowTime.length() - 3);

    String expectedBDate = (String) wboIssue.getAttribute("expectedBeginDate");
    expectedBDate = expectedBDate.replaceAll("-","/");
    
    if(request.getAttribute("case") != null){
        filterName="StatusProjctListTitle";
    }
    /* end */
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String BackToList, save, lang, langCode, title, site, M_Name, crew, ATask;
    String sdate, Time, sConfirm, eqpStatus ,working, outOfWorking, updateEquipment, imgPathCollaps, moreDetails, hideDetails, fStatus;
    String reading, cominte, cominteLastReading, defaultComite, currentReading, strLastReading,addTaskNote, diffReading, dateLastReading, equipmentName, summaryLastReading;
    if(stat.equals("En")) {
        Time="Time";
        align="left";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        BackToList = "Back";
        save = "    Save   ";
        title="Schedule title";
        fStatus="Fail To Save";
        ATask="Assign Task";
        site="Site";
        M_Name="Machine name";
        crew="Assign to Crew Mission";
        sConfirm="Technical Inspection";
        sdate="Begin Date";
        eqpStatus="Equipment Status";
        working="Working";
        outOfWorking="Out Of Working";
        updateEquipment = "Update Equipment Reading";
        reading = "Counter Reading";
        cominte = "Note";
        cominteLastReading = "Note Last Reading";
        defaultComite = "Update By Job Order Code " + (String) wboIssue.getAttribute("businessID");
        currentReading = "Current Reading";
        strLastReading = "Previous Reading";
        diffReading = "Difference Reading";
        dateLastReading = "Date Reading";
        equipmentName = "Equipment Name";
        summaryLastReading = "Summary Last Reading";
        moreDetails = "More Details ...";
        hideDetails = "Hide Details ...";
        imgPathCollaps = "images/arrow_right_white.png";
          addTaskNote = "You must add maintenance item";
    } else {
        sdate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577;";
        Time="&#1575;&#1604;&#1608;&#1602;&#1578; ";
        align="right";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        BackToList = "&#1593;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1608;&#1583;&#1577;";
        save = " &#1573;&#1587;&#1606;&#1583; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; ";
        title="&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
        site=" &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        M_Name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1575;&#1604;&#1607;";
        ATask="&#1573;&#1587;&#1606;&#1575;&#1583; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        crew="&#1578;&#1587;&#1606;&#1583; &#1573;&#1604;&#1609; &#1601;&#1585;&#1610;&#1602; &#1575;&#1604;&#1593;&#1605;&#1604;";
        sConfirm="الفحص الفني";
        eqpStatus="&#1581;&#1575;&#1604;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1607;";
        working="&#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;";
        outOfWorking="&#1582;&#1575;&#1585;&#1580; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;";
        updateEquipment = "&#1578;&#1581;&#1600;&#1600;&#1583;&#1610;&#1579; &#1602;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1605;&#1593;&#1600;&#1600;&#1583;&#1577;";
        reading = "&#1602;&#1600;&#1600;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1593;&#1600;&#1600;&#1583;&#1575;&#1583;";
        cominte = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        cominteLastReading = "&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578; &#1571;&#1582;&#1585; &#1602;&#1600;&#1600;&#1585;&#1575;&#1569;&#1577;";
        defaultComite = "&#1578;&#1581;&#1583;&#1610;&#1579; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1585;&#1602;&#1605;" + (String) wboIssue.getAttribute("businessID");
        currentReading = "&#1575;&#1604;&#1602;&#1600;&#1600;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1600;&#1600;&#1577;";
        strLastReading = "&#1575;&#1604;&#1602;&#1600;&#1600;&#1585;&#1575;&#1569;&#1577; &#1575;&#1604;&#1587;&#1575;&#1576;&#1602;&#1600;&#1600;&#1577;";
        diffReading = "&#1601;&#1600;&#1600;&#1600;&#1600;&#1600;&#1585;&#1602; &#1575;&#1604;&#1602;&#1600;&#1600;&#1585;&#1575;&#1569;&#1577;";
        dateLastReading = "&#1578;&#1575;&#1585;&#1610;&#1600;&#1600;&#1582; &#1571;&#1582;&#1585; &#1602;&#1600;&#1600;&#1585;&#1575;&#1569;&#1577;";
        equipmentName = "&#1575;&#1587;&#1600;&#1600;&#1605; &#1575;&#1604;&#1605;&#1593;&#1600;&#1600;&#1583;&#1577;";
        summaryLastReading = "&#1605;&#1604;&#1600;&#1600;&#1582;&#1589; &#1571;&#1582;&#1600;&#1600;&#1585; &#1602;&#1600;&#1600;&#1585;&#1575;&#1569;&#1577;";
        moreDetails = "&#1578;&#1601;&#1600;&#1600;&#1589;&#1610;&#1604; &#1571;&#1603;&#1579;&#1600;&#1600;&#1585; ...";
        hideDetails = "&#1571;&#1582;&#1601;&#1600;&#1600;&#1575;&#1569; &#1575;&#1604;&#1578;&#1601;&#1600;&#1600;&#1589;&#1610;&#1604; ...";
        imgPathCollaps = "images/arrow_left_white.png";
         addTaskNote = "&#1610;&#1580;&#1576; &#1573;&#1590;&#1575;&#1601;&#1577; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1571;&#1608;&#1604;&#1575;&#1611;";
    }
    IssueTasksMgr issueTasksMgr = IssueTasksMgr.getInstance();
    
       Vector checkTasksVec = new Vector();
    checkTasksVec = issueTasksMgr.getOnArbitraryKey(issueId, "key1");
    ExternalJobMgr externalJobMgr = ExternalJobMgr.getInstance();
    WebBusinessObject externalWbo = externalJobMgr.getOnSingleKey("key2", issueId);
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Agricultural Maintenance - work shop order</TITLE>
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
     	var dp_cal;
        window.onload = function () {
            dp_cal  = new Epoch('epoch_popup','popup',document.getElementById('popup_container'));
        };
            
        function submitForm() {
           if (!validateData("req", this.WORKSHOP_FORM.empName, "Please, enter Crew.")){
               this.ISSUE_FORM.empName.focus();
            } else if (!validateData("req", this.WORKSHOP_FORM.end, "Please, enter date.")){
               this.ISSUE_FORM.end.focus();
            } else if(!validateData("req", this.WORKSHOP_FORM.currentReading, "Please, enter counter reading.")) {
                this.WORKSHOP_FORM.currentReading.focus();
            } else if(!validateData("num", this.WORKSHOP_FORM.currentReading, "Erorr in Reading.")) {
                this.WORKSHOP_FORM.currentReading.select();
                this.WORKSHOP_FORM.currentReading.focus();
            } else if(parseInt(document.getElementById("lastReading").value) > parseInt(document.getElementById("currentReading").value)) {
                alert("Erorr in Reading.\n Current Reading Must Be Larger Than Or Equal To Last Reading\n Current Reading Is : " + document.getElementById("currentReading").value + "\n Last Reading Id : " + document.getElementById("lastReading").value);
                this.WORKSHOP_FORM.currentReading.select();
                this.WORKSHOP_FORM.currentReading.focus();
            } else { 
               document.WORKSHOP_FORM.action = "<%=context%>/AssignedIssueServlet?op=save&projectID=<%=wboIssue.getAttribute("projectName").toString()%>&uID=<%=uID%>&filterName=<%=filterName%>&filteValue=<%=filterValue%>";
               document.WORKSHOP_FORM.submit();
            }
        }
        
        function cancelForm() {    
            document.WORKSHOP_FORM.action ="<%=context%>/AssignedIssueServlet?op=VIEWDETAILS&issueId=<%=issueId%>&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
            document.WORKSHOP_FORM.submit();  
        }
        
        function checkNote(input, defaultComite) {
            if(input.innerHTML == "") {
                input.style.color = "#6F787F";
                input.innerHTML = defaultComite;
            }
        }
        
        function clearContent(input) {
            input.style.color = "black";
            input.innerHTML = "";
        }

        function showHideDetails(image, lable, hideOrShow) {
            var rows = document.getElementsByName(hideOrShow);
            var length = rows.length;

            if(length > 0) {
                var flag = rows[0].style.display;

                if(flag == "block") {
                    for(var i = 0; i < length; i++) {
                        rows[i].style.display = "none";
                    }

                    document.getElementById(lable).innerHTML = "<%=moreDetails%>";
                    document.getElementById(image).src = "<%=imgPathCollaps%>";
                } else {
                    for(var i = 0; i < length; i++) {
                        rows[i].style.display = "block";
                    }

                    document.getElementById(lable).innerHTML = "<%=hideDetails%>";
                    document.getElementById(image).src = "images/arrow_down_white.png";
                }

            }
        }
    </SCRIPT>

    <style type="text/css">
        textarea {
            width: 100%;
            color: black;
            font-weight: bold;
            font-size: 12px
        }
    </style>
            
    <BODY onload="document.getElementById('currentReading').focus();">
        <FORM NAME="WORKSHOP_FORM" METHOD="POST" action="">
            <DIV align="left" STYLE="color:blue; padding-bottom: 10px; padding-left: 2.5%">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="Button">
                &ensp;
                <button  onclick="JavaScript: cancelForm();" class="Button"><%=BackToList%></button>
                &ensp;
                <button  onclick="JavaScript:  submitForm();" class="Button"><%=save%></button>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="border-color: #006699; width: 95%">
                    <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <FONT color='#F3D596' SIZE="5"><%=ATask%></FONT>
                            </TD>
                        </TR>
                    </TABLE>
                    <BR>
                 
                  
                    <% if(!status.equals("") && status.equalsIgnoreCase("no")) { %>
                    <TABLE ALIGN="center" WIDTH="90%" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="2" BORDER="0">
                        <TR>
                            <TD title="<%=title%>" STYLE="text-align:center" class="backgroundTable">
                                <b><font size="3" color="red"><%=fStatus%></font></b>
                            </TD>
                        </TR>
                    </TABLE>
                    <% } %>
                    <DIV align="<%=align%>" style="margin-<%=align%>: 5%;color: blue">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:28.5%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><%=ATask%></b></p>
                    </DIV>
                    <TABLE ALIGN="center" WIDTH="90%" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="2" BORDER="0">
                        <TR>
                            <TD title="<%=title%>" WIDTH="30%" STYLE="text-align:<%=align%>; padding-<%=align%>:10px" class="backgroundTable">
                                <b><font size="3" color="black"><%=title%></font></b>
                            </TD>
                            <TD STYLE="<%=style%>"  class="td" colspan="3"  width="40%">
                                <input readonly type="TEXT"  name="maintenanceTitle" value="<%=issueTitle%>" ID="<%=issueTitle%>" size="33"  maxlength="50" style="width: 100%; color: black; font-weight: bold; font-size: 12px">
                            </TD>
                            <TD style="border: none" width="40%">
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD title="<%=site%>" STYLE="text-align:<%=align%>; padding-<%=align%>:10px" class="backgroundTable">
                                <b><font size="3" color="black"><%=site%></font></b>
                            </TD>
                            <TD STYLE="<%=style%>" class="td" colspan="3"  width="40%">
                                <input readonly type="TEXT" name="workShop" value="<%=projectName%>" ID="workShop" size="33"  maxlength="50" style="width: 100%; color: black; font-weight: bold; font-size: 12px">
                            </TD>
                            <TD style="border: none" width="40%">
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD title="<%=M_Name%>" STYLE="text-align:<%=align%>; padding-<%=align%>:10px" class="backgroundTable">
                                <b><font size="3" color="black"><%=M_Name%></font></b>
                            </TD>
                            <TD STYLE="<%=style%>" class="td" colspan="3"  width="40%">
                                <input readonly type="TEXT" name="machineName" value="<%=wboEquipment.getAttribute("unitName").toString()%>" ID="machineName" size="33"  maxlength="50" style="width: 100%; color: black; font-weight: bold; font-size: 12px">
                            </TD>
                            <TD style="border: none" width="40%">
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD title="<%=eqpStatus%>" STYLE="text-align:<%=align%>; padding-<%=align%>:10px" class="backgroundTable">
                                <b><font size="3" color="black"><%=eqpStatus%></font></b>
                            </TD>
                            <TD STYLE="<%=style%>" class="td" colspan="3"  width="40%">
                                <% if(wboEquipment.getAttribute("equipmentStatus").toString().equals("1")) { %>
                                <input readonly type="TEXT" name="eqpStatus" value="<%=working%>" ID="eqpStatus" size="33"  maxlength="50" style="width: 100%; color: black; font-weight: bold; font-size: 12px">
                                <% } else { %>
                                <input readonly type="TEXT" name="eqpStatus" value="<%=outOfWorking%>" ID="eqpStatus" size="33"  maxlength="50" style="width: 100%; color: black; font-weight: bold; font-size: 12px">
                                <% } %>
                            </TD>
                            <TD style="border: none" width="40%">
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD title="<%=crew%>" STYLE="text-align:<%=align%>; padding-<%=align%>:10px" class="backgroundTable">
                                <b><font size="3" color="black"><%=crew%></font></b>
                            </TD>
                            <TD STYLE="<%=style%>" class="td" colspan="3"  width="40%">
                                <SELECT name="empName" style="width: 100%; color: black; font-weight: bold; font-size: 12px">
                                    <sw:WBOOptionList wboList='<%=arrayCrewCodeList%>' displayAttribute = "crewName" valueAttribute="crewID"/>
                                </SELECT>
                                <input type="hidden" name="assignToName" value="admin" size="33" maxlength="50"/>
                                <input type="hidden" name="assignTo" value="1">
                            </TD>
                            <TD style="border: none" width="40%">
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD title="<%=sdate%>" STYLE="text-align:<%=align%>; padding-<%=align%>:10px" class="backgroundTable">
                                <b><font size="3" color="black"><%=sdate%></font></b>
                            </TD>
                            <TD STYLE="<%=style%>" class="td" colspan="3"  width="40%">
                                <input id="popup_container" name="end" type="text" value="<%=expectedBDate%>" style="width: 94%; color: black; font-weight: bold; font-size: 12px"><img alt=""  src="images/showcalendar.gif">
                            </TD>
                            <TD style="border: none" width="40%">
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD title="<%=Time%>" STYLE="text-align:<%=align%>; padding-<%=align%>:10px; height: 15px" class="backgroundTable">
                                <b><font size="3" color="black"><%=Time%></font></b>
                            </TD>
                            <TD class="td" width="15%" style="height: 15px">
                                <select name="m" style="width: 100%; color: black; font-weight: bold; font-size: 12px">
                                    <sw:CustomOptionList start="0" stop="59" scrollTo="<%=min%>" />
                                </select>
                            </TD>
                            <TD class="td" width="15%" style="height: 15px">
                                <select name="h" style="width: 100%; color: black; font-weight: bold; font-size: 12px">
                                    <sw:CustomOptionList start="0" stop="23" scrollTo="<%=hr%>" />
                                </select>
                            </TD>
                            <TD class="td backgroundTable" width="10%" style="text-align: center; border: 1px solid #C3C6C8; height: 15px">
                                <font color="red"><b>HH : MM</b></font>
                            </TD>
                            <TD style="border: none" width="40%">
                                &ensp;
                            </TD>
                        </TR>
                        <TR>
                            <TD title="<%=sConfirm%>" STYLE="text-align:<%=align%>; padding-<%=align%>:10px" class="backgroundTable">
                                <b><font size="3" color="black"><%=sConfirm%></font></b>
                            </TD>
                            <TD STYLE="<%=style%>" class="td" colspan="3"  width="40%">
                                <TEXTAREA rows="3" name="assignNote" ID="assignNote" cols="28"></TEXTAREA>
                            </TD>
                            <TD style="border: none" width="40%">
                                &ensp;
                            </TD>
                        </TR>
                    </TABLE>
                    <BR>
                    <DIV align="<%=align%>" style="margin-<%=align%>: 5%;color: blue">
                        <p dir="<%=dir%>" align="divAlign" style="background-color: #E6E6FA;width:28.5%;font-weight: bold;font-size: 16px;padding-top: 2px;padding-bottom: 2px;padding-left: 5px;padding-right: 5px"><b><%=updateEquipment%></b></p>
                    </DIV>
                    <TABLE ALIGN="center" WIDTH="90%" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                        <TR>
                            <TD WIDTH="49%" style="border: none">
                                <TABLE ALIGN="center" WIDTH="100%" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="2" BORDER="0">
                                    <TR>
                                        <TD WIDTH="35%" title="<%=equipmentName%>" STYLE="text-align:<%=align%>; padding-<%=align%>:10px" class="backgroundTable">
                                            <b><font size="3" color="black"><%=equipmentName%></font></b>
                                        </TD>
                                        <TD STYLE="<%=style%>"  class="td"  width="65%">
                                            <input type="TEXT" name="unitName" ID="unitName" readonly style="width:100%; color: black; font-weight: bold; font-size: 12px" size="33" value="<%=wboEquipment.getAttribute("unitName")%>" maxlength="9">
                                            <input type="hidden" name="averageUnitId" ID="averageUnitId" value="<%=averageUnitId%>">
                                            <input type="hidden" name="unitId" ID="unitId" value="<%=wboEquipment.getAttribute("id")%>">
                                            <input type="hidden" name="longLastDateReading" ID="longLastDateReading" value="<%=longLastDateReading%>">
                                            <input type=hidden name=existRowInAvgUnit value="<%=existRowInAvgUnit%>">
                                            <input type=hidden name=scheduleId value="<%=scheduleId%>">
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD WIDTH="35%" title="<%=reading%>" STYLE="text-align:<%=align%>; padding-<%=align%>:10px" class="backgroundTable">
                                            <b><font size="3" color="black"><%=reading%></font></b>
                                        </TD>
                                        <TD STYLE="<%=style%>"  class="td"  width="65%">
                                            <input type="TEXT" name="currentReading" ID="currentReading" style="width:100%; color: black; font-weight: bold; font-size: 12px" size="33" value="<%=lastReading%>" maxlength="9">
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD WIDTH="35%" title="<%=cominte%>" STYLE="text-align:<%=align%>; padding-<%=align%>:10px" class="backgroundTable">
                                            <b><font size="3" color="black"><%=cominte%></font></b>
                                        </TD>
                                        <TD STYLE="<%=style%>"  class="td"  width="65%">
                                            <TEXTAREA cols=""  name="description" ID="description" onblur="JavaScript: checkNote(this, '<%=defaultComite%>');" onfocus="JavaScript: clearContent(this);" STYLE="width:100%; color: #6F787F; font-weight: bold; font-size: 12px" ROWS="5"><%=defaultComite%></TEXTAREA>
                                        </TD>
                                    </TR>
                                </TABLE>
                            </TD>
                            <TD WIDTH="2%" style="border: none">
                                &ensp;
                            </TD>
                            <TD WIDTH="49%" style="border: none">
                                <TABLE ALIGN="center" WIDTH="100%" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="2" BORDER="0">
                                    <TR>
                                        <TD WIDTH="100%" colspan="2" title="<%=summaryLastReading%>" STYLE="text-align:center" class="backgroundTable">
                                            <b><font size="3" color="black"><%=summaryLastReading%></font></b>
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD WIDTH="50%" title="<%=currentReading%>" STYLE="text-align:<%=align%>; padding-<%=align%>:10px; padding-bottom: 0px; padding-top: 0px" class="backgroundTable">
                                            <b><font size="3" color="black"><%=currentReading%></font></b>
                                        </TD>
                                        <TD STYLE="<%=style%>" class="td" width="50%">
                                            <input readonly type="text" ID="lastReading" name="lastReading" value="<%=lastReading%>" size="33"  maxlength="50" style="width: 100%; color: black; font-weight: bold; font-size: 12px">
                                        </TD>
                                    </TR>
                                    <TR>
                                        <TD WIDTH="100%" colspan="2" title="<%=currentReading%>" STYLE="text-align:<%=align%>; border: none; height: 30px">
                                            <a href="JavaScript: showHideDetails('imgDetails', 'details', 'summary');" ><img alt="" id="imgDetails" src="<%=imgPathCollaps%>" align="middle" /><font size="3" color="blue">&ensp;<b id="details" style="vertical-align: middle" ><%=moreDetails%></b></font></a>
                                        </TD>
                                    </TR>
                                    <TR id="summary" style="display: none">
                                        <TD WIDTH="50%" title="<%=strLastReading%>" STYLE="text-align:<%=align%>; padding-<%=align%>:10px" class="backgroundTable">
                                            <b><font size="3" color="black"><%=strLastReading%></font></b>
                                        </TD>
                                        <TD STYLE="<%=style%>" class="td" width="50%">
                                            <input readonly type="text" ID="prevRead" name="prevRead" value="<%=prvReading%>" size="33"  maxlength="50" style="width: 100%; color: black; font-weight: bold; font-size: 12px">
                                        </TD>
                                    </TR>
                                    <TR id="summary" style="display: none">
                                        <TD WIDTH="50%" title="<%=diffReading%>" STYLE="text-align:<%=align%>; padding-<%=align%>:10px" class="backgroundTable">
                                            <b><font size="3" color="black"><%=diffReading%></font></b>
                                        </TD>
                                        <TD STYLE="<%=style%>" class="td" width="50%">
                                            <input readonly type="text" ID="diffReading" name="diffReading" value="<%=(lastReading - prvReading)%>" size="33"  maxlength="50" style="width: 100%; color: black; font-weight: bold; font-size: 12px">
                                        </TD>
                                    </TR>
                                    <TR id="summary" style="display: none">
                                        <TD WIDTH="50%" title="<%=dateLastReading%>" STYLE="text-align:<%=align%>; padding-<%=align%>:10px" class="backgroundTable">
                                            <b><font size="3" color="black"><%=dateLastReading%></font></b>
                                        </TD>
                                        <TD STYLE="<%=style%>" class="td" width="50%">
                                            <input readonly type="text" value="<%=dateReading%>" size="33"  maxlength="50" style="width: 100%; color: black; font-weight: bold; font-size: 12px">
                                        </TD>
                                    </TR>
                                    <TR id="summary" style="display: none">
                                        <TD WIDTH="50%" title="<%=cominteLastReading%>" STYLE="text-align:<%=align%>; padding-<%=align%>:10px" class="backgroundTable">
                                            <b><font size="3" color="black"><%=cominteLastReading%></font></b>
                                        </TD>
                                        <TD STYLE="<%=style%>" class="td" width="50%">
                                            <TEXTAREA cols=""  name="readingNote" ID="readingNote" STYLE="width:100%; font-weight: bold; font-size: 12px" ROWS="3"><%=readingNote%></TEXTAREA>
                                        </TD>
                                    </TR>
                                </TABLE>
                            </TD>
                        </TR>
                    </TABLE>
           
                    <BR>
                </FIELDSET>
            </CENTER>
            <!-- hidden input -->
            <input type=hidden name=issueId value="<%=issueId%>" >
            <input type=hidden name=filterName value="<%=filterName%>" >
            <input type=hidden name=filterValue value="<%=filterValue%>">
            <input type=hidden name=issueTitle value="<%=issueTitle%>">
            <% if(request.getAttribute("case") != null) { %>
            <INPUT TYPE="hidden" NAME="case" VALUE="<%=(String)request.getAttribute("case")%>">
            <INPUT TYPE="hidden" NAME="title" VALUE="<%=(String)request.getAttribute("title")%>">
            <INPUT TYPE="hidden" NAME="unitName" VALUE="<%=(String)request.getAttribute("unitName")%>">
            <% } %>
        </FORM>
    </BODY>
</HTML>     
