<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>

<%@ page import="java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    WebBusinessObject webIssue = (WebBusinessObject) request.getAttribute("webIssue");
    
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    MaintenanceMgr maintenanceMgr = MaintenanceMgr.getInstance();
    IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();
    UrgencyMgr urgencyMgr = UrgencyMgr.getInstance();
    //ArrayList processAreas = new ArrayList();
    //processAreas.add("Project Planning");
    //processAreas.add("Configuration Management");
    //processAreas.add("Project Monitoring & Control");
    //processAreas.add("Process & Product Quality Assurance");
    //processAreas.add("Measurements & Analysis");
    //processAreas.add("Requirements Management");
    //processAreas.add("Supplier Agreement Management");
    String status = (String) request.getAttribute("Status");
    
    //ArrayList isRisk = new ArrayList();
    //isRisk.add("No");
    //isRisk.add("Yes");
    
    String filterName = (String) request.getAttribute("filterName");
    String filterValue = (String) request.getAttribute("filterValue");
    
    long lToday = TimeServices.getDate();
    
    // get current date
    Calendar cal = Calendar.getInstance();
    WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
    String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
    SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
    String nowDate=sdf.format(cal.getTime());
    
    Vector vec = new Vector();
    Vector vec1 = new Vector();
    
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align="center";
    String dir=null;
    String style=null;
    String lang,langCode,cancel,save,site,tit,st,ed,sta,afr,ST,S,M,ULT,desc;
    if(stat.equals("En")){
        
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        cancel="Cancel";
        save="Update Schedule";
        site="Site";
        tit=" Update Schedule";
        st="Start Date";
        ed="End Date";
        sta="Schedule Updating Status ";
        afr="All fields are required";
        ST="Schedule Title";
        S="Site";
        M="Maintenance";
        ULT="Urgency Level Type";
        desc="Schedule Description";
        
    }else{
        
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        cancel="&#1573;&#1606;&#1607;&#1575;&#1569;";
        save="&#1587;&#1580;&#1604; &#1575;&#1604;&#1578;&#1581;&#1583;&#1610;&#1579;";
        site="&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        tit="&#1578;&#1581;&#1583;&#1610;&#1579; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
        st="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607;";
        ed="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1607;";
        sta="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        afr="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        ST="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
        S="&#1575;&#1604;&#1605;&#1608;&#1602;&#1593; ";
        M="&#1589;&#1610;&#1575;&#1606;&#1577;";
        ULT="&#1583;&#1585;&#1580;&#1577; &#1575;&#1604;&#1571;&#1607;&#1605;&#1610;&#1577;";
        desc="&#1575;&#1604;&#1608;&#1589;&#1601;";
    }
    
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new issue</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
        <script type="text/javascript" src="js/epoch_classes.js"></script>
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        var dp_cal1,dp_cal2; 
        window.onload = function () {
            dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
            dp_cal2  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));

        }
        
        function submitForm()
        {    
        if (this.ISSUE_FORM.issueTitle.value =="")
        { 
        alert ("You must enter a value to the Schedule Title ");
        }
        else if (this.ISSUE_FORM.project_name.value == "")
        {
        alert ("You must select a value to the Site ");
        }
        else if (this.ISSUE_FORM.FAName.value == "")
        {
        alert ("You must select a value to the Maintenance ");
        }
        else
        {
        document.ISSUE_FORM.action = "<%=context%>/IssueServlet?op=Update&filterName=<%=filterName%>&filterValue=<%=filterValue%>";
        document.ISSUE_FORM.submit();
        }
        }
        
        function refreshData(){
        document.ISSUE_FORM.submit();	
        }
        
         function cancelForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/SearchServlet?op=<%=filterName%>&filterValue=<%=filterValue%>";
        document.ISSUE_FORM.submit();  
        }
        
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
        
    </SCRIPT>
    
    <BODY>
        
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            
            
            <%    if(null!=status) {
            
            %>
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG SRC="images/cancel.gif"></button>
                
            </DIV> 
            
            <fieldset >
                <legend align="center">
                    
                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6"><%=tit%> 
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend >
                
                <b><FONT color='black'><%=sta%>:</font><FONT color='red'> <%=status%></font></b>
                <TABLE>
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                </TABLE>
            </fieldset>
            <%
            } else {
            %>
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG SRC="images/cancel.gif"></button>
                
                <button    onclick="submitForm()" class="button"><%=save%>    <IMG SRC="images/save.gif"></button>
            </DIV> 
            
            <fieldset align=center style="width:80%">
            <legend align="center">
                
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"><%=tit%> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
            
            
            <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                <TR  ALIGN="CENTER">
                    <TD COLSPAN="2" STYLE="text-align:center" class='td'>
                        <b><FONT color='red' SIZE="3" ><%=afr%></FONT></B> 
                        <br><br>
                    </TD>
                    
                </tr>
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="ISSUE_TITLE">
                            <p><b><font color="#FF0000">*</font><%=ST%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <%
                        if(request.getParameter("issueTitle") != null){
                        %>
                        <input disabled type="TEXT" name="issueTitle" ID="issueTitle" size="30" value="<%=request.getParameter("issueTitle")%>" maxlength="255">
                        <%
                        } else {
                        %>
                        <input disabled type="TEXT" name="issueTitle" ID="issueTitle" size="30" value="<%= (String) webIssue.getAttribute("issueTitle")%>" maxlength="255">
                        <%
                        }
                        %>
                        
                    </TD>
                    <TD class='td'>
                    </TD>
                </TR>
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>
                <%
                ArrayList arrList = new ArrayList();
                arrList = projectMgr.getCashedTableAsArrayList();
                %>
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="Project_Name">
                            <p><b><font color="#FF0000">*</font><%=S%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <SELECT name="project_name" onchange="refreshData();">   
                            <%
                            if(request.getParameter("project_name") != null){
                            %>
                            <sw:OptionList optionList = '<%=arrList%>' scrollTo = "<%=request.getParameter("project_name")%>"/>                            
                            <%
                            } else {
                            %>
                            <sw:OptionList optionList = '<%=arrList%>' scrollTo = "<%= (String) webIssue.getAttribute("projectName")%>"/>
                            <%
                            }
                            %>                                             
                        </SELECT>
                    </TD>
                    <TD class='td'>
                    </TD>
                    
                </TR>
                
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>
                <%
                if(request.getParameter("project_name") != null){
                    vec = projectMgr.getOnArbitraryKey(request.getParameter("project_name"), "key1");
                    if(vec.size() > 0){
                        vec1 = maintenanceMgr.getOnArbitraryKey(((WebBusinessObject)vec.elementAt(0)).getAttribute("projectID").toString(),"key1");
                        arrList = new ArrayList();
                        for(int i = 0; i < vec1.size(); i++){
                            arrList.add(((WebBusinessObject) vec1.elementAt(i)).getAttribute("maintenanceName").toString());
                        }
                    } else {
                        arrList = null;
                    }
                    
                } else if(arrList != null){
                    vec = projectMgr.getOnArbitraryKey(arrList.get(0).toString(), "key1");
                    if(vec.size() > 0){
                        vec1 = maintenanceMgr.getOnArbitraryKey(((WebBusinessObject)vec.elementAt(0)).getAttribute("projectID").toString(),"key1");
                        arrList = new ArrayList();
                        for(int i = 0; i < vec1.size(); i++){
                            arrList.add(((WebBusinessObject) vec1.elementAt(i)).getAttribute("maintenanceName").toString());
                        }
                    } else {
                        arrList = null;
                    }
                } else {
                    arrList = null;
                }
                %>
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Maintenance_Name">
                            <p><b><font color="#FF0000">*</font><%=M%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <%
                        if(arrList != null){
                        %>
                        <select name="FAName" size="1"">
                                <%
                                if(request.getParameter("FAName") != null){
                                %>
                                <sw:OptionList optionList='<%=arrList%>' scrollTo = "<%=request.getParameter("FAName").toString()%>"/>
                                <%
                                } else {
                                %>
                                <sw:OptionList optionList='<%=arrList%>' scrollTo = "<%= (String) webIssue.getAttribute("faId")%>"/>
                                <%
                                }
                                %>
                                </select>
                        <%
                        } else {
                        %>
                        <select name="FAName" size="1">
                        </select>
                        <%
                        }
                        %>
                    </TD>
                    <TD class='td'>
                    </TD>
                </TR>
                
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>
                <!--
                <TR>
                <TD class='td'>
                <LABEL FOR="str_IssueType_Name">
                <p><b><font color="#FF0000">*</font>Task Type:</b>&nbsp;
                </LABEL>
                </TD>
                <TD class='td'>
                <SELECT name="typeName">
                <sw//:OptionList optionList='<%//=issueTypeMgr.getCashedTableAsArrayList()%>' scrollTo = "<%= (String) webIssue.getAttribute("issueType")%>"/>
                </SELECT>
                </TD>
                <TD class='td'>
                </TD>
                </TR>
                -->
                <input type=HIDDEN name=typeName value="issue" >
                
                <!--
                <TR>
                <TD class='td'>
                &nbsp;
                </TD>
                </TR>
                -->
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Urgency_Name">
                            <p><b><font color="#FF0000">*</font><%=ULT%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <SELECT name="urgencyName">
                            <%
                            if(request.getParameter("urgencyName") != null){
                            %>
                            <sw:OptionList optionList='<%=urgencyMgr.getCashedTableAsArrayList()%>' scrollTo = "<%=request.getParameter("urgencyName")%>"/>
                            <%
                            } else {
                            %>
                            <sw:OptionList optionList='<%=urgencyMgr.getCashedTableAsArrayList()%>' scrollTo = "<%= (String) webIssue.getAttribute("urgencyId")%>"/>
                            <%
                            }
                            %>
                        </SELECT>
                    </TD>
                    <TD class='td'>
                    </TD>
                </TR>
                <!--
                
                <TR>
                <TD class='td'>
                &nbsp;
                </TD>
                </TR>
                
                <TR>
                <TD class='td'>
                <LABEL FOR="str_Is_Risk">
                <p><b><font color="#FF0000">*</font>Risk:</b>&nbsp;
                </LABEL>
                </TD>
                <TD class='td'>
                <SELECT name="isRisk">
                <sw//:OptionList optionList='<%//=isRisk%>' scrollTo = "<%//= (String) webIssue.getAttribute("isRisk")%>"/>
                </SELECT>
                </TD>
                </TR>
                -->
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>
                
                <input type=HIDDEN name=isRisk value="NO" >
                <tr>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="EXPECTED_B_DATE">
                            <p><b><font color="#FF0000">*</font><%=st%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <%
                    String url = request.getRequestURL().toString();
                    String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                    Calendar c = Calendar.getInstance();
                    if(request.getParameter("beginDate") != null){
                        String[] arDate = request.getParameter("beginDate").split("/");
                        TimeServices.setDate(arDate[2] + "-" + arDate[0] + "-" + arDate[1]);
                        c.setTimeInMillis(TimeServices.getDate());
                    } else {
                        TimeServices.setDate((String) webIssue.getAttribute("expectedBeginDate"));
                        c.setTimeInMillis(TimeServices.getDate());
                    }
                    %>
                    <td STYLE="<%=style%>" class="td">
                        <!--SELECT name="beginMonth" size=1>
                        <!sw:OptionList optionList='<!%= DateAndTimeConstants.getMonthsList()%>' scrollTo="<!%=TimeServices.getCurrentMonth()%>"/>
                        </SELECT>
                        <SELECT name="beginDay" size=1>
                        <!sw:OptionList optionList='<!%= DateAndTimeConstants.getNumberSequenceListList(31)%>' scrollTo="<!%=TimeServices.getCurrentDay()%>"/>
                        </SELECT>
                        <SELECT name="beginYear" size=1>
                        <!sw:OptionList optionList='<!%= DateAndTimeConstants.getYearList()%>' scrollTo="<!%=TimeServices.getCurrentYear()%>"/>
                        </SELECT-->
                        <input name="beginDate" id="beginDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" >
                    </td>
                    <TD class='td'>
                    </TD>
                </tr>
                
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>
                <tr>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="EXPECTED_E_DATE">
                            <p><b><font color="#FF0000">*</font><%=ed%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <%
                    if(request.getParameter("endDate") != null){
                        String[] arDate = request.getParameter("endDate").split("/");
                        TimeServices.setDate(arDate[2] + "-" + arDate[0] + "-" + arDate[1]);
                        c.setTimeInMillis(TimeServices.getDate());
                    } else {
                        TimeServices.setDate((String) webIssue.getAttribute("expectedEndDate"));
                        c.setTimeInMillis(TimeServices.getDate());
                    }
                    %>
                    <td STYLE="<%=style%>" class="td">
                        <!--SELECT name="endMonth" size=1>
                        <!sw:OptionList optionList='<!%= DateAndTimeConstants.getMonthsList()%>' scrollTo="<!%=TimeServices.getCurrentMonth()%>"/>
                        </SELECT>
                        <SELECT name="endDay" size=1>
                        <!sw:OptionList optionList='<!%= DateAndTimeConstants.getNumberSequenceListList(31)%>' scrollTo="<!%=TimeServices.getCurrentDay()%>"/>
                        </SELECT>
                        <SELECT name="endYear" size=1>
                        <!sw:OptionList optionList='<!%= DateAndTimeConstants.getYearList()%>' scrollTo="<!%=TimeServices.getCurrentYear()%>"/>
                        </SELECT-->
                        <input name="endDate" id="endDate" type="text" value="<%=nowDate%>" ><img src="images/showcalendar.gif" >
                    </td>
                    <TD class='td'>
                    </TD>
                </tr>
                
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Maintenance_Desc">
                            <p><b><font color="#FF0000">*</font><%=desc%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <%
                        if(request.getParameter("issueDesc") != null){
                        %>
                        <TEXTAREA rows="5" name="issueDesc" cols="25"><%=request.getParameter("issueDesc")%></TEXTAREA>
                        <%
                        } else {
                        %>
                        <TEXTAREA disabled rows="5" name="issueDesc" cols="25"><%= (String) webIssue.getAttribute("issueDesc")%></TEXTAREA>
                        <%
                        }
                        %>
                    </TD>
                    <TD class='td'>
                    </TD>
                </TR>
                
            </TABLE>
            <input type="hidden" name="id" ID="id" size="30" value="<%= (String) webIssue.getAttribute("id")%>" maxlength="255">
            <%
            System.out.println("Today = " + lToday);
            TimeServices.setDate(lToday);
            }
            %>
        </FORM>
    </BODY>
</HTML>     
