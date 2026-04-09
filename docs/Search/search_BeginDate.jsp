<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.maintenance.db_access.UnitMgr"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>

<HTML>
<%
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

UnitMgr unitMgr=UnitMgr.getInstance();

WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
String projectId=loggedUser.getAttribute("projectID").toString();
Vector eqps=unitMgr.getEquipment(projectId);

WebBusinessObject wbo=new WebBusinessObject();

// get current date
Calendar cal = Calendar.getInstance();
String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowTime=sdf.format(cal.getTime());

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();


%>

<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>Doc Viewer- Select Project and Status</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    <%-----------------------------------------%>
    <script src="js/dhtmlxcommon.js"></script>
    <script src="js/dhtmlxcombo.js"></script>
    <link rel="STYLESHEET" type="text/css" href="css/dhtmlxcombo.css">
    <%-----------------------------------------%>
    <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
    <script type="text/javascript" src="js/epoch_classes.js"></script>
</HEAD>


<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

    
    var dp_cal1;      
        window.onload = function () {
   	    dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
        };
    
    window.dhx_globalImgPath="images/";
    var z=dhtmlXComboFromSelect("projectName");
    
    function submitForm()
    {  
        document.ISSUE_FORM.action = "<%=context%>/SearchServlet?op=getByoneDate&searchType=begin";
        document.ISSUE_FORM.submit();
        
        
    }
     function cancelForm()
    {    
        document.ISSUE_FORM.action = "<%=context%>/main.jsp;";
        document.ISSUE_FORM.submit();  
    }
    
</SCRIPT>



<BODY>


<FORM NAME="ISSUE_FORM" METHOD="POST">



<table align="center" width="80%">
    <tr><td class="td">
        <fieldset >
            <legend align="center">
                <table dir="rtl" align="center">
                    <tr>
                        <td class="td">  
                            <IMG WIDTH="80" HEIGHT="80" SRC="images/Search.png">
                        </td>
                        <td class="td">
                            <font color="blue" size="6"> &#1576;&#1581;&#1579; &#1593;&#1606; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604;
                                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            
            <%--
            <TABLE ALIGN="center" DIR="RTL" WIDTH=570 CELLPADDING="0" CELLSPACING="0" BORDER="0"
                   <TR>
                    <TD STYLE="text-align:center"  BGCOLOR="#cc6699" WIDTH="50%">
                        
                        <LABEL FOR="Project_Name">
                            
                            <p><b> <font size=3 color="white">&#1575;&#1587;&#1600;&#1600;&#1605; &#1575;&#1604;&#1605;&#1593;&#1600;&#1600;&#1583;&#1577;<font color="#FF0000"></font></b>&nbsp;
                            
                        </LABEL>
                        
                    </TD>
                    <TD STYLE="text-align:center"  BGCOLOR="#cc6699" WIDTH="50%">
                        <LABEL FOR="statusName">
                            <p><b><font size=3 color="white"> &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;<font color="#FF0000"></font></b>&nbsp;
                        </LABEL>
                    </TD>
                    
                </tr>
                <tr>
                    <TD STYLE="text-align:center"  bgcolor="#F0D5E2" align= "right" >
                        
                       
                        <SELECT   name="projectName">
                            <option value="ALL">ALL</option>
                            <sw:WBOOptionList wboList='<%=maintainableMgr.getMaintenanbleEquAsBusObjects()%>' displayAttribute="unitName" valueAttribute="id"/>
                        </SELECT>
                        
                    </TD>
                    <TD STYLE="text-align:center" bgcolor="#F0D5E2">
                        <SELECT   name="statusName"  >
                            <option value="ALL">ALL</option>
                            <option value="Schedule">Schedule</option>
                            <option value="Canceled">Canceled</option>
                            <option value="Assigned">Assigned</option>
                            <option value="Rejected">Rejected</option>
                            <option value="Onhold">Onhold</option>
                            <option value="Finished">Finshed</option>
                            
                        </SELECT>
                    </TD>
                </tr>
                
            </TABLE>
            --%>
            <TABLE ALIGN="CENTER" DIR="RTL" ID="code" CELLPADDING="0" CELLSPACING="0" width="650" STYLE="border-width:1px;border-color:white;">
                
                <TR>
                    <TD STYLE="text-align:center"  class="silver_header" WIDTH="50%">
                        
                        <LABEL FOR="Project_Name">
                            
                            <p><b> <font size=3 >&#1575;&#1587;&#1600;&#1600;&#1605; &#1575;&#1604;&#1605;&#1593;&#1600;&#1600;&#1583;&#1577;<font color="#FF0000"></font></b>&nbsp;
                            
                        </LABEL>
                        
                    </TD>
                    <TD STYLE="text-align:center"  class="silver_header" WIDTH="50%">
                        <LABEL FOR="statusName">
                            <p><b><font size=3 > &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;<font color="#FF0000"></font></b>&nbsp;
                        </LABEL>
                    </TD>
                    
                </tr>
                
                <TR>
                    <TD CLASS="silver_odd" bgcolor="#F0D5E2" ROWSPAN="2" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;" ID="data">
                        
                        <select style='width:200px;'  id="projectName" name="projectName">
                            <option value="All">All</option>
                            <%for(int i=0;i<eqps.size();i++)
                            {
                            wbo=(WebBusinessObject)eqps.get(i);
                            %>                            
                            <option value="<%=wbo.getAttribute("id").toString()%>"><%=wbo.getAttribute("unitName").toString()%></option>
                            <%}%>
                        </select>
                        
                        <script>
			var z=dhtmlXComboFromSelect("projectName");
                        z.enableFilteringMode(true);
                        </script>
                    </TD>
                    <%--
                    <TD CLASS="cell" bgcolor="#F0D5E2" ROWSPAN="2" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white;" ID="data">
                        
                        <input type="text" dir="ltr" autocomplete="off" value="All" onkeydown="JavaScript: checkKey(event);" ONCLICK="JavaScript: f();" id="projectName" name="projectName">
                    </TD>
                    --%>
                    
                    <TD CLASS="silver_odd" STYLE="text-align:center" bgcolor="#F0D5E2">
                        <SELECT   name="statusName"  >
                            <option value="ALL">ALL</option>
                            <option value="Schedule">Schedule</option>
                            <option value="Canceled">Canceled</option>
                            <option value="Assigned">Assigned</option>
                            <option value="Rejected">Rejected</option>
                            <option value="Onhold">Onhold</option>
                            <option value="Finished">Finshed</option>
                            
                        </SELECT>
                    </TD>
                </TR>
                
            </TABLE>
            
            
            <TABLE ALIGN="center" DIR="RTL" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                <TR>
                    
                    <TD  CLASS="silver_header" STYLE="border-left-WIDTH: 1;text-align:center;" WIDTH="50%">
                        <b><font size=3 > &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577;</b>
                    </TD>
                </TR>
                <TR>
                    
                    <TD CLASS="silver_odd" style="text-align:right" bgcolor="#F0D5E2"  valign="MIDDLE" >
                    
                    
                    <%
                    String url = request.getRequestURL().toString();
                    String subURL = url.substring(0, url.indexOf(metaMgr.getContext()));
                    Calendar c = Calendar.getInstance();
                    %>
                    
                    
                    
                    <!--SELECT name="startMonth" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getMonthsList()%>' scrollTo="<!%=TimeServices.getCurrentMonth()%>"/>
                                    </SELECT>

                                    <SELECT name="startDay" size=1 >
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getNumberSequenceListList(31)%>' scrollTo="<!%=TimeServices.getCurrentDay()%>"/>/>
                                    </SELECT>

                                    <SELECT name="startYear" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getYearList()%>' scrollTo="<!%=TimeServices.getCurrentYear()%>"/>
                                    </SELECT-->
                    <input id="beginDate" name="beginDate" type="text" value="<%=nowTime%>" ><img src="images/showcalendar.gif" >
                    <br><br>
                </TR>
                
                <tr>
                    <br><br>
                    <TD STYLE="text-align:center" CLASS="td" colspan="3">  
                        <button  onclick="JavaScript: submitForm();"   STYLE="background:#f3f3f3;font-size: 15;font-weight:bold; ">  &#1576;&#1581;&#1579;  <IMG HEIGHT="15" SRC="images/search.gif"> </button>          
                        <button  onclick="JavaScript: cancelForm();" STYLE="background:#f3f3f3;font-size:15;font-weight:bold; "><%=tGuide.getMessage("cancel")%>  <IMG HEIGHT="15" SRC="images/cancel.gif"></button>
                        
                    </TD>
                </tr>
            </table>
            
        </fieldset>
        
</tr></td ></table>
</FORM>
</BODY>
</HTML>     
