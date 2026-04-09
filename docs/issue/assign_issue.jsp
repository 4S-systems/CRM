<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@ page import="com.contractor.db_access.MaintainableMgr" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<HTML>
    <%
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    EmployeeMgr empMgr = EmployeeMgr.getInstance();
    StaffCodeMgr staffCodeMgr = StaffCodeMgr.getInstance();
    CrewMissionMgr crewMissionMgr = CrewMissionMgr.getInstance();
    
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    FailureCodeMgr failureCodeMgr=FailureCodeMgr.getInstance();
    String context = metaMgr.getContext();
    ArrayList arrFailure = failureCodeMgr.getCashedTableAsBusObjects();
    
    
    UserMgr userMgr = UserMgr.getInstance();
    String issueId = (String) request.getAttribute(IssueConstants.ISSUEID);
    String issueTitle = (String) request.getAttribute(IssueConstants.ISSUETITLE);
    
    String filterName = (String) request.getAttribute("filter");
    String filterValue = (String) request.getAttribute("filterValue");
    String uID = (String) request.getAttribute("uID");
    System.out.println("filterValue IN JSP _______"+filterValue);
    System.out.println("filterName IN JSP  _______"+filterName);
    AssignedIssueState ais = (AssignedIssueState) request.getAttribute("state");
    
    String workShop = (String) request.getAttribute("workShop");
    
    /* added */
    
    AppConstants appCons = new AppConstants();
    WebIssue webIssue = null;
    
    String[] itemAtt = appCons.getItemScheduleAttributes();
    String[] itemTitle = appCons.getItemScheduleHeaders();
    
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    Vector  itemList = (Vector) request.getAttribute("data");
    System.out.println("Vector Count = "+itemList.size());
    
    // get current date and Time
    Calendar cal = Calendar.getInstance();
    WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
    String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    SimpleDateFormat sdfTime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String nowDate=sdf.format(cal.getTime());
    String nowTime=sdfTime.format(cal.getTime());
    String hr=nowTime.substring(nowTime.length()-8,nowTime.length()-6);
    String min=nowTime.substring(nowTime.length()-5,nowTime.length()-3);
    
    
    int s = itemAtt.length;
    int t = s;
    int iTotal = 0;
    
    String attName = null;
    String attValue = null;
    String cellBgColor = new String("#FF00FF");
    String bgColor = null;
    int flipper = 0;
    
    
    MaintainableMgr maintainableMgr=MaintainableMgr.getInstance();
    WebBusinessObject wbo = IssueMgr.getInstance().getOnSingleKey(issueId);
    WebBusinessObject wboTemp = maintainableMgr.getOnSingleKey(wbo.getAttribute("unitId").toString());
    //    WebBusinessObject wboTemp = UnitScheduleMgr.getInstance().getOnSingleKey(wbo.getAttribute("unitScheduleID").toString());
    WebBusinessObject wboFcode = failureCodeMgr.getOnSingleKey(wbo.getAttribute("failureCode").toString());
    String failureCode = wboFcode.getAttribute("title").toString();
    
    String addToURL="";
    if(request.getAttribute("case")!=null){
        addToURL="&title="+(String)request.getAttribute("title")+"&unitName="+(String)request.getAttribute("unitName");
        filterName="StatusProjctListTitle";
    }
    
    String expectedBDate=(String)wbo.getAttribute("expectedBeginDate");
    expectedBDate=expectedBDate.replaceAll("-","/");
    
    String beginDate=(String)request.getSession().getAttribute("beginDate");
    String endDate=(String)request.getSession().getAttribute("endDate");
    String planUnitId=(String)request.getSession().getAttribute("planUnitId");
    String planType=(String)request.getAttribute("planType");
    
    
    String CancelForm="";
    if(planType!=null){
        if(planType.equalsIgnoreCase("late")){
            CancelForm="op=ListLateJO&unitId="+planUnitId+"&beginDate="+beginDate+"&endDate="+endDate;
        }else{
            CancelForm="op="+filterName+"&filterValue="+filterValue;
            CancelForm+=addToURL;
            CancelForm=CancelForm.replace(' ','+');
        }
    }else{
        CancelForm="op="+filterName+"&filterValue="+filterValue;
        CancelForm+=addToURL;
        CancelForm=CancelForm.replace(' ','+');
    }
    
    /* end */
    TechMgr techMgr = TechMgr.getInstance();
    
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String endTask,BackToList,save,lang,langCode,AllRequired,title,Fcode,site,M_Name,crew,ATask,print,actualTime;
    String sdate,search,Time,AddCode,add,AddName,addNew,tCost,code,name,price,count,cost,Mynote,del,scr,sConfirm, sOutOfLine,
            eqpStatus,working,outOfWorking;
    if(stat.equals("En")){
        Time="Time";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        endTask = "End that task";
        BackToList = "Back to list";
        save = "    Save   ";
        AllRequired="(*) All Data Must Be Filled";
        title="Schedule title";
        Fcode="Failure code";
        print="Print order";
        ATask="Assign task";
        site="Site";
        add="   Add   ";
        search="Auto search";
        M_Name="Machine name";
        crew="Assign to Crew Mission";
        AddCode="Add using Part Code";
        AddName="Add using Part Name";
        addNew="Add new part";
        tCost="Total cost  ";
        code="Code";
        name="Name";
        price="Price";
        count="countity";
        cost="Cost";
        Mynote="Note";
        del="Delete";
        scr="images/arrow1.swf";
        sConfirm="Execution Approval Notes";
        sOutOfLine = "Out of Line";
        sdate="Begin Date";
        eqpStatus="Equipment Status";
        working="Working";
        outOfWorking="Out Of Working";
        
    }else{
        sdate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577;";
        Time="&#1575;&#1604;&#1608;&#1602;&#1578; ";
        add="  &#1571;&#1590;&#1601;  ";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        endTask =  " &#1573;&#1606;&#1578;&#1607;&#1575;&#1569; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
        save = " &#1573;&#1587;&#1606;&#1583; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; ";
        AllRequired="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607; (*)";
        title="&#1606;&#1608;&#1593; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        Fcode="&#1603;&#1608;&#1583; &#1575;&#1604;&#1593;&#1591;&#1604; ";
        
        site=" &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        M_Name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1575;&#1604;&#1607;";
        
        print="&#1573;&#1591;&#1576;&#1593; &#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;";
        ATask="&#1573;&#1587;&#1606;&#1575;&#1583; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        crew="&#1578;&#1587;&#1606;&#1583; &#1573;&#1604;&#1609; &#1601;&#1585;&#1610;&#1602; &#1575;&#1604;&#1593;&#1605;&#1604;";
        search="&#1576;&#1581;&#1579; &#1584;&#1575;&#1578;&#1610;";
        AddCode="&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1585;&#1602;&#1605;";
        AddName="&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;";
        addNew="  &#1571;&#1590;&#1601; &#1602;&#1591;&#1593;&#1577; &#1580;&#1583;&#1610;&#1583;&#1607; ";
        tCost="&#1573;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1607;   ";
        code="&#1575;&#1604;&#1603;&#1608;&#1583;";
        name="&#1575;&#1604;&#1573;&#1587;&#1605;";
        price="&#1575;&#1604;&#1587;&#1593;&#1585; ";
        count="&#1575;&#1604;&#1603;&#1605;&#1610;&#1607;";
        cost=" &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1607;";
        Mynote="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        del="&#1581;&#1584;&#1601; ";
        scr="images/arrow2.swf";
        sConfirm="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578; &#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
        sOutOfLine = "&#1582;&#1575;&#1585;&#1580; &#1575;&#1604;&#1582;&#1583;&#1605;&#1577;";
        eqpStatus="&#1581;&#1575;&#1604;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1607;";
        working="&#1583;&#1575;&#1582;&#1604; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;";
        outOfWorking="&#1582;&#1575;&#1585;&#1580; &#1575;&#1604;&#1582;&#1583;&#1605;&#1607;";
    }
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Agricultural Miantenance - work shop order</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <link rel="stylesheet" type="text/css" href="css/headers.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
        
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        
     	var dp_cal,dp2;      
          window.onload = function () {
   	 dp_cal  = new Epoch('epoch_popup','popup',document.getElementById('popup_container'));
            };
            
   var count=0;
        function submitForm()
        {    
          
    
    // var q=document.getElementsByName('qun');
     
     // for(var x=0;x<count;x++){
     
     // var check=q[x].value;
      //if(check == "0" || check=="" ){
        //    alert("enter the quantity more than zero or delete the un used row");
        //    return;
     // }
     
    //  }
       if (!validateData("req", this.WORKSHOP_FORM.empName, "Please, enter Crew.")){
           this.ISSUE_FORM.empName.focus();
        } else if (!validateData("req", this.WORKSHOP_FORM.end, "Please, enter date.")){
           this.ISSUE_FORM.end.focus();
       } else {
           document.WORKSHOP_FORM.action = "<%=context%>/AssignedIssueServlet?op=save&projectID=<%=wbo.getAttribute("projectName").toString()%>&uID=<%=uID%>&filterName=StatusProjectListAll&filteValue=<%=filterValue%>&issueId=<%=issueId%>";
           document.WORKSHOP_FORM.submit();  
       }
       
    }
        
        function cancelForm(filter)
        {
            if(filter=="null"){
                document.WORKSHOP_FORM.action ="main.jsp";
            }else{
                var searchtype=filter.substring(filter.indexOf(">")+1,filter.indexOf(":"));
                if(searchtype.match("begin")||searchtype.match("end")){
                       document.WORKSHOP_FORM.action ="<%=context%>/SearchServlet?op=getByoneDate&filterValue=" + filter;

                }else   
                {
                    document.WORKSHOP_FORM.action ="<%=context%>/SearchServlet?<%=CancelForm%>";
                }
            }
            document.WORKSHOP_FORM.submit();  
         }    
                          </script>
    
    <script src='js/silkworm_validate.js' type='text/javascript'></script>
    <script src='js/ChangeLang.js' type='text/javascript'></script>
    
    <link rel="stylesheet" type="text/css" href="autosuggest.css" />
    
    
    <BODY>
        
        <FORM NAME="WORKSHOP_FORM" METHOD="POST">
            <%
            if(request.getAttribute("case")!=null){
            %>
            <INPUT TYPE="HIDDEN" NAME="case" VALUE="<%=(String)request.getAttribute("case")%>">
            <INPUT TYPE="HIDDEN" NAME="title" VALUE="<%=(String)request.getAttribute("title")%>">
            <INPUT TYPE="HIDDEN" NAME="unitName" VALUE="<%=(String)request.getAttribute("unitName")%>">
            <%
            
            }
            %>
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="Button">
                <button  onclick="JavaScript: cancelForm('<%=filterValue%>');" class="Button"><%=BackToList%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="Button"><%=save%> <IMG HEIGHT="15" SRC="images/save.gif"></button>
                
            </DIV> 
            
            <fieldset align="center" style="border-color:blue;width:90%">
                <legend align="center">
                    <table dir="rtl" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6"> <%=ATask%>                 
                                </font>
                                
                            </td>
                        </tr>
                    </table>
                </legend>       
                <table align="<%=align%>" >
                    <TR COLSPAN="2" ALIGN="<%=align%>">
                        <TD STYLE="<%=style%>" class='td'>
                            <FONT color='red' size='+1'><%=AllRequired%></FONT> 
                        </TD>
                    </TR>
                </table>
                <br>
                
                <TABLE ALIGN="CENTER" WIDTH="80%" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <tr>
                        <td align="<%=align%>" width="60%" style="border-width:0px;">
                            
                            <TABLE ALIGN="<%=align%>" WIDTH="100%" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                                
                                <TR>
                                    <TD WIDTH="35%" STYLE="<%=style%>;padding-right:20;" class='bar'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b><%=title%><font color="#FF0000"> </font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>"  class='td'>
                                        <input readonly type="TEXT"  name="maintenanceTitle" value="<%=issueTitle%>" ID="<%=issueTitle%>" size="33"  maxlength="50">
                                    </TD>
                                </TR>
                                
                                <TR>
                                    <TD STYLE="<%=style%>;padding-right:20;"  class='bar'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b><%=site%><font color="#FF0000"> </font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>"  class='td'>
                                        <input readonly type="TEXT" name="workShop" value="<%=projectMgr.getOnSingleKey(wbo.getAttribute("projectName").toString()).getAttribute("projectName").toString()%>" ID="workShop" size="33"  maxlength="50">
                                    </TD>
                                </TR>
                                
                                <TR>
                                    <TD STYLE="<%=style%>;padding-right:20;" class='bar'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b><%=M_Name%><font color="#FF0000"> </font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <input readonly type="TEXT" name="machineName" value="<%=wboTemp.getAttribute("unitName").toString()%>" ID="machineName" size="33"  maxlength="50">
                                    </TD>
                                </TR>
                                
                                <TR>
                                    <TD STYLE="<%=style%>;padding-right:20;" class='bar'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b><%=eqpStatus%><font color="#FF0000"> </font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <%if(wboTemp.getAttribute("equipmentStatus").toString().equals("1")){%>
                                        <input readonly type="TEXT" name="eqpStatus" value="<%=working%>" ID="eqpStatus" size="33"  maxlength="50">
                                        <%}else{%>
                                        <input readonly type="TEXT" name="eqpStatus" value="<%=outOfWorking%>" ID="eqpStatus" size="33"  maxlength="50">
                                        <%}%>
                                    </TD>
                                </TR>
                                
                                <TR>
                                    <TD STYLE="<%=style%>;padding-right:20;" class='bar'>
                                        <LABEL FOR="assign_to">
                                            <p><b><%=crew%><font color="#FF0000"></font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <%
                                    ArrayList arrayCrewCodeList = new ArrayList();
                                    crewMissionMgr.cashData();
                                    arrayCrewCodeList = crewMissionMgr.getCashedTableAsBusObjects();
                                    %>
                                    
                                    <TD STYLE="<%=style%>" class='td'>
                                        <SELECT name="empName"  STYLE="width:230px;">
                                            <sw:WBOOptionList wboList='<%=arrayCrewCodeList%>' displayAttribute = "crewName" valueAttribute="crewID"/>
                                        </SELECT>
                                        <input type="hidden" name="assignToName" value="admin" size="33" maxlength="50"/><input type="hidden" name="assignTo" value="1">
                                    </TD>
                                </TR>
                                
                                <%--
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=Fcode%> </b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <SELECT name="failurecode" style="width:230px">
                                <sw:WBOOptionList wboList='<%=arrFailure%>' displayAttribute = "title" valueAttribute="id" scrollTo="<%=failureCode%>"/>
                            </SELECT>
                        </TD>
                    </tr>
                    --%>
                    
                                <TR>
                                    <TD STYLE="<%=style%>;padding-right:20;" class='bar'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b> <%=Time%> :<font color="#FF0000"> </font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <table>
                                            <tr>
                                                <td class="td">
                                                    
                                                    
                                                    <select name="m">
                                                    <option value="<%=min%>" selected><%=min%>
                                                                                      <option value="00">00
                                                    <option value="01">01
                                                    <option value="02">02
                                                    <option value="03">03
                                                    <option value="04">04
                                                    <option value="05">05
                                                    <option value="06">06
                                                    <option value="07">07
                                                    <option value="08">08
                                                    <option value="09">09
                                                    <option value="10">10
                                                    <option value="11">11
                                                    <option value="12">12
                                                    <option value="13">13
                                                    <option value="14">14
                                                    <option value="15">15
                                                    <option value="16">16
                                                    <option value="17">17
                                                    <option value="18">18
                                                    <option value="19">19
                                                    <option value="20">20
                                                    <option value="21">21
                                                    <option value="22">22
                                                    <option value="23">23
                                                    
                                                    <option value="24">24
                                                    <option value="25">25
                                                    <option value="26">26
                                                    <option value="27">27
                                                    <option value="28">28
                                                    <option value="29">29
                                                    <option value="30">30
                                                    <option value="31">31
                                                    <option value="32">32
                                                    <option value="33">33
                                                    <option value="34">34
                                                    <option value="35">35
                                                    <option value="36">36
                                                    <option value="37">37
                                                    <option value="38">38
                                                    <option value="39">39
                                                    <option value="40">40
                                                    <option value="41">41
                                                    <option value="42">42
                                                    <option value="43">43
                                                    <option value="44">44
                                                    <option value="45">45
                                                    <option value="46">46
                                                    
                                                    <option value="47">47
                                                    <option value="48">48
                                                    <option value="49">49
                                                    <option value="50">50
                                                    <option value="51">51
                                                    <option value="52">52
                                                    <option value="53">53
                                                    <option value="54">54
                                                    <option value="55">55
                                                    <option value="56">56
                                                    <option value="57">57
                                                    <option value="58">58
                                                    <option value="59">59
                                                </td>
                                                <td class="td"><font color="red"><b>:</b></font></td>
                                                <td class="td">
                                                    
                                                    <select name="h">
                                                    <option value="<%=hr%>" selected><%=hr%>
                                                                                     <option value="00">00
                                                    <option value="01">01
                                                    <option value="02">02
                                                    <option value="03">03
                                                    <option value="04">04
                                                    <option value="05">05
                                                    <option value="06">06
                                                    <option value="07">07
                                                    <option value="08">08
                                                    <option value="09">09
                                                    <option value="10">10
                                                    <option value="11">11
                                                    <option value="12">12
                                                    <option value="13">13
                                                    <option value="14">14
                                                    <option value="15">15
                                                    <option value="16">16
                                                    <option value="17">17
                                                    <option value="18">18
                                                    <option value="19">19
                                                    <option value="20">20
                                                    <option value="21">21
                                                    <option value="22">22
                                                    <option value="23">23
                                                    
                                                    
                                                </td>
                                                <td class="td">
                                                    <font color="red"> <b>  HH : MM </b></font>
                                                </td> 
                                                
                                            </tr>
                                        </table>
                                        
                                    </TD>
                                </TR> 
                                
                                <TR>
                                    <TD STYLE="<%=style%>;padding-right:20;" class='bar'>
                                        <LABEL FOR="ISSUE_TITLE">
                                            <p><b> <%=sdate%> :<font color="#FF0000"> </font></b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>" class='td'>
                                        <input id="popup_container" name="end" type="text" value="<%=expectedBDate%>"> <img src="images/showcalendar.gif">
                                    </TD>
                                </TR> 
                                
                                <TR>
                                    <TD STYLE="<%=style%>;padding-right:20;" class='bar'>
                                        <LABEL FOR="str_Function_Desc">
                                            <p><b><%=sConfirm%> </b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>"  class='td'>
                                        <TEXTAREA rows="3" name="assignNote" ID="assignNote" cols="28" style="width:230px"></TEXTAREA>
                                    </TD>
                                </TR>
                                
                                <TR>
                                    <TD STYLE="<%=style%>;padding-right:20;" class='bar'>
                                        <LABEL FOR="str_Function_Desc">
                                            <p><b><%=sOutOfLine%> </b>&nbsp;
                                        </LABEL>
                                    </TD>
                                    <TD STYLE="<%=style%>"  class='td'>
                                        <%if(wboTemp.getAttribute("equipmentStatus").toString().equals("1")){%>
                                        <input type="checkbox" id="changeState" name="changeState" checked>
                                            <%}else{%>
                                            <input type="checkbox" id="changeState" disabled name="changeState">
                                        <%}%>
                                    </TD>
                                </TR>
                                
                                <tr>
                                    <td class="td">     
                                        <input type=HIDDEN name=issueId value="<%=issueId%>" >
                                        <input type=HIDDEN name=filterName value="<%=filterName%>" >
                                        <input type=HIDDEN name=filterValue value="<%=filterValue%>" >
                                        <input type=HIDDEN name=issueTitle value="<%=issueTitle%>">
                                    </td>
                                </tr>
                                
                            </TABLE>
                            
                        </td>
                        
                        <td class="td" align="right" style="text-align:center;border-width:0px;">
                            <TABLE ALIGN="RIGHT" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                                <tr>
                                    <td class="td" style="text-align:center;border-width:0px;">
                                        <div style="OVERFLOW: auto; display:block; WIDTH: 150px; HEIGHT: 150px;" id="imageDiv">
                                            <%if(wboTemp.getAttribute("equipmentStatus").toString().equals("1")){%>
                                            <img src="images/workingEq.gif" alt="Working Equipment">
                                            <%}else{%>
                                            <img src="images/stoppedEq.gif" alt="Out Of Working Equipment">
                                            <%}%>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                
                <BR>
                <br>
                <input type="hidden" name="totale"  readonly ID="totale" value="0">
                <br><br>
            </FIELDSET>
            
            <%            
            Enumeration e = itemList.elements();
            String status = null;
            
            while(e.hasMoreElements()) {
                iTotal++;
                wbo = (WebBusinessObject) e.nextElement();
                //webIssue = (WebIssue) wbo;
                flipper++;
                if((flipper%2) == 1) {
                    bgColor="#c8d8f8";
                } else {
                    bgColor="white";
                }
                //issueID = (String) wbo.getAttribute("id");
                DecimalFormat format = new DecimalFormat("0.00");
                
                attName = itemAtt[0];
                attValue = (String) wbo.getAttribute(attName);
                
                //MaintenanceItemMgr maintenanceItemMgr = MaintenanceItemMgr.getInstance();
                //DistributedItemsMgr distItemsMgr=DistributedItemsMgr.getInstance();

                ItemsMgr  itemsMgr = ItemsMgr.getInstance();
                WebBusinessObject itemListWbo = new WebBusinessObject();
                String [] itemCode = (String[]) wbo.getAttribute("itemId").toString().split("-");
                if(itemCode.length > 1){
                    itemListWbo = itemsMgr.getOnSingleKey(wbo.getAttribute("itemId").toString());
                    }else{
                    itemListWbo = itemsMgr.getOnObjectByKey(wbo.getAttribute("itemId").toString());
                    }
            
            %>
            <%--
            <input type="hidden" name="code" id="code" value="<%=maintenanceItemMgr.getOnSingleKey(attValue).getAttribute("itemCode").toString()%>">
            <input type="hidden" name="name1" id="name1" value="<%=maintenanceItemMgr.getOnSingleKey(attValue).getAttribute("itemDscrptn").toString()%>">
            --%>
            <input type="hidden" name="code" id="code" value="<%=itemListWbo.getAttribute("itemCodeByItemForm")%>">
            <input type="hidden" name="name1" id="name1" value="<%=itemListWbo.getAttribute("itemDscrptn")%>">
            <input type="hidden" name="isDirectPrch" id="isDirectPrch" value="0">
            <input type="hidden" name="attachedOn" id="attachedOn" value="<%=(String)wbo.getAttribute("attachedOn")%>">
            
            <%
            attName = itemAtt[1];
            attValue = (String) wbo.getAttribute(attName);
            attValue = format.format(new Float(attValue));
            %>
            <input type="hidden"  name="qun" id="qun" value="<%=attValue%>" onblur='checNumeric()'>
            <%
            attName = itemAtt[2];
            attValue = (String) wbo.getAttribute(attName);
            
            attValue = format.format(new Float(attValue));
            %>
            <input type="hidden" name="price" id="price" value="<%=attValue%>">
            <%
            attName = itemAtt[3];
            attValue = (String) wbo.getAttribute(attName);
            
            attValue = format.format(new Float(attValue));
            %>
            <input type="hidden" name="cost" id="cost" value="<%=attValue%>">
            
            <%
            attName = itemAtt[4];
            attValue = (String) wbo.getAttribute(attName);
            %>
            <input type="hidden" name="note" id="note" value=" <%=attValue%>">
            <input type="hidden" name="Hid" id="Hid" value="<%=(String) wbo.getAttribute(itemAtt[0])%>">
            
            
            <%
            }
            %>           
            
            
            
        </FORM>
    </BODY>
</HTML>     
