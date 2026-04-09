<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<HTML>

<%
ProjectMgr projectMgr = ProjectMgr.getInstance();
IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();


MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
String op = (String) request.getAttribute("op");
String ts = (String) request.getAttribute("ts");
String inframe = (String) request.getAttribute("inframe");

System.out.println("target op is " + op );

// get current date and Time
Calendar cal = Calendar.getInstance();
WebBusinessObject loggedUser=(WebBusinessObject)session.getAttribute("loggedUser");
String jDateFormat=loggedUser.getAttribute("javaDateFormat").toString();
SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
String nowDate=sdf.format(cal.getTime());

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align="center";
String dir=null;
String style=null;
String lang,langCode,cancel,save,site,tit,st,ed,pageTitle,pageTitleTip;
if(stat.equals("En")){
    
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    cancel="Cancel";
    save="View";
    site="Site";
    tit="Select Site";
    st="Start Date";
    ed="End Date";
    pageTitle="RPT-STAT-SITE-1";
    pageTitleTip="Site Status Report ";
    
}else{
    
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    cancel="&#1593;&#1608;&#1583;&#1607;";
    save="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
    site="&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    tit="&#1573;&#1582;&#1578;&#1575;&#1585; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    st="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1607;";
    ed="&#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1607;";
    pageTitle="RPT-STAT-SITE-1";
    pageTitleTip="&#1575;&#1581;&#1589;&#1575;&#1574;&#1610;&#1575;&#1578; &#1571;&#1608;&#1575;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604; &#1591;&#1576;&#1602;&#1575; &#1604;&#1604;&#1605;&#1608;&#1602;&#1593;";
}
%>


<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>Select Equipment</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    <link rel="stylesheet" type="text/css" href="css/epoch_styles.css" />
    <script type="text/javascript" src="js/epoch_classes.js"></script>
</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

         var dp_cal1,dp_cal12;      
         window.onload = function () {
   	    dp_cal1  = new Epoch('epoch_popup','popup',document.getElementById('beginDate'));
            dp_cal12  = new Epoch('epoch_popup','popup',document.getElementById('endDate'));
          };
    
        function submitForm()
        {    
        <%
        if(op.equalsIgnoreCase("StatusReport")){
        %>    
        if (compareDate())
            {
            <%
            }
    %>
                document.ISSUE_FORM.action = "<%=context%>/SearchServlet?op=<%=op%>" + "&inframe=<%=inframe%>";
                document.ISSUE_FORM.submit(); 
                <%
                if(op.equalsIgnoreCase("StatusReport")){
        %>
            } else {
                alert('End Date must be greater than or equal Begin Date');
            }
             <%
                }
    %>
        }
        
         function cancelForm()
        {    
        document.ISSUE_FORM.action = "<%=context%>/ReportsServlet?op=mainPage";
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

        function compareDate()
        {
            return Date.parse(document.getElementById("endDate").value) >= Date.parse(document.getElementById("beginDate").value);
        }
</SCRIPT>
<BODY>
     <script type="text/javascript" src="js/wz_tooltip.js"></script>
    <FORM NAME="ISSUE_FORM" METHOD="POST">
        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG SRC="images/cancel.gif"></button>
            <button    onclick="submitForm()" class="button"><%=save%> <IMG SRC="images/search.gif"></button>
        </DIV> 
        
        <fieldset align=center style="width:80%;border-color:blue">
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

         <div dir="left">
                            <table>
                                <tr>
                                    <td>
                                        <font color="#FF385C" size="3">
                                            <a id="mainLink"  onmouseover="Tip('<%=pageTitleTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=pageTitleTip%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=pageTitle%></a>
                                        </font>
                                    </td>
                                </tr>
                            </table>
                        </div>


        <br>
        
        <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
            <TR>
                <TD class='td'>
                    <LABEL FOR="Project_Name">
                        <p><b><%=site%><font color="#FF0000">*</font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD class='td'>
                    <SELECT name="projectName" style="width:230px">
                        <sw:WBOOptionList wboList='<%=projectMgr.getCashedTableAsBusObjects()%>' displayAttribute = "projectName" valueAttribute="projectID"/>
                        <%
                        if(op.equalsIgnoreCase("ProjectStcs")) {
                        %>
                        <OPTION value="All">All</OPTION>
                        <%
                        }
                        %>
                    </SELECT>
                </TD>
            </TR>                         
        </TABLE>
        <INPUT TYPE="hidden" name="filterValue" value="">
        <br><br>
        <%
        if(op.equalsIgnoreCase("StatusReport")) {
        %>
        <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
            <TR>
                
                <TD CLASS="datetitle" STYLE="border-left-WIDTH: 1;<%=style%>">
                    <b><%=st%></b>
                </TD>
                <TD CLASS="datetitle" STYLE="border-left-WIDTH: 1;<%=style%>">
                    <b><%=ed%> </b>
                </TD>
            </TR>
            <TR>
                
                <TD CLASS="datetitle" STYLE="border-left-WIDTH: 1;<%=style%>">
                    
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
                    <input id="beginDate" name="beginDate" type="text" value="<%=nowDate%>"><img src="images/showcalendar.gif" > 
                </td>
                
                <td CLASS="datetitle" STYLE="border-left-WIDTH: 1;<%=style%>">
                    <!--SELECT name="endMonth" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getMonthsList()%>' scrollTo="<!%=TimeServices.getCurrentMonth()%>"/>
                                    </SELECT>
                                    <SELECT name="endDay" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getNumberSequenceListList(31)%>' scrollTo="<!%=TimeServices.getCurrentDay()%>"/>
                                    </SELECT>
                                    <SELECT name="endYear" size=1>
                                    <!sw:OptionList optionList='<!%= DateAndTimeConstants.getYearList()%>' scrollTo="<!%=TimeServices.getCurrentYear()%>"/>
                                    </SELECT-->
                    <input id="endDate" name="endDate" type="text" value="<%=nowDate%>"><img src="images/showcalendar.gif" > 
                </td>
            </tr>
        </table>
        <%
        }
if(request.getAttribute("chart") != null){
        %>
        <input name="chart" type="hidden" value="<%=request.getAttribute("chart").toString()%>">
        <%
        }
        %>
        
    </FORM>
    <br><br>
    </fieldset>
</BODY>
</HTML>     
