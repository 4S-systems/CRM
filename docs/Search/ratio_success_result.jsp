<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
<%
MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String lang, langCode, sCancel,search,bDate,eDate,sTitle ,pageTitle , pageTitleTip;
if(stat.equals("En")){
            bDate="from";
            eDate="to";
            lang="   &#1593;&#1585;&#1576;&#1610;    ";
            sCancel="Cancel";
            langCode="Ar";
            search="Search";
            sTitle="Attributed the success of the plans scheduled maintenance of equipment";
             pageTitle="RPT-STAT-SUCS-PLAN-8";
            pageTitleTip="Ration Success Plan Report";
} else {
            bDate="&#1605;&#1606;";
            eDate="&#1575;&#1604;&#1609;";
            lang="English";
            sCancel = "&#1593;&#1608;&#1583;&#1607;";
            langCode="En";
            search="&#1576;&#1581;&#1579;";
            sTitle="&#1606;&#1587;&#1576; &#1606;&#1580;&#1575;&#1581; &#1582;&#1591;&#1591; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577; &#1575;&#1604;&#1605;&#1580;&#1583;&#1608;&#1604;&#1577; &#1604;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; ";
   pageTitle="RPT-STAT-SUCS-PLAN-8";
             pageTitleTip="&#1593;&#1585;&#1590; &#1576;&#1610;&#1575;&#1606; &#1578;&#1582;&#1591;&#1610;&#1591; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";

}

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
Vector vecResult = (Vector) request.getAttribute("vecResult");
String context = metaMgr.getContext();


String sTotal = new String("");
String sFinshed = new String("");
String sOther = new String("");
String sLabels = new String("");

%>

<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>Doc Viewer- Select Project and Status</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
</HEAD>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

     function cancelForm()
    {    
        document.ISSUE_FORM.action = "<%=context%>/SearchServlet?op=RatioSuccess";
        document.ISSUE_FORM.submit();  
    }
    
    function compareDate()
    {
        return Date.parse(document.getElementById("endDate").value) >= Date.parse(document.getElementById("beginDate").value);
    }
    
</SCRIPT>
<BODY>

 <script type="text/javascript" src="js/wz_tooltip.js"></script>
<FORM NAME="ISSUE_FORM" METHOD="POST">

<input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
<button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"> </button> <br>


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
<table align="center" width="80%">
    <tr><td class="td">
        <fieldset >
            <legend align="center">
                <table dir="rtl" align="center">
                    <tr>
                        <td class="td">  
                           
                        </td>
                        <td class="td">
                            <font color="blue" size="5"> <%=sTitle%>
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            <% 
            for(int i = 0; i < vecResult.size(); i++){
    WebBusinessObject wboTemp = (WebBusinessObject) vecResult.get(i);
            int iIndex =  i + 1;
            sLabels = sLabels + " " + iIndex;
            sTotal = sTotal + " " + (String) wboTemp.getAttribute("total");
            sFinshed = sFinshed + " " + (String) wboTemp.getAttribute("totalEmergency");
            %>
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" ALIGN="center">
                <TR  bgcolor="#C8D8F8">
                    <TD>
                        <b> Month </b>
                    </TD>
                    <TD>
                        <b> Interval Date </b>
                    </TD>
                    <TD>
                        <b> Total Job Order </b>
                    </TD>
                    <TD>
                        <b> Finished </b>
                    </TD>
                </TR>
                
                <TR>
                    <TD BGCOLOR="#FFFF99" >
                       <b> <%=i + 1%> </b>
                    </TD>
                    <TD BGCOLOR="#FFFF99" >
                        <font color="blue"><b>date From : </b></font><font color="red"><%=wboTemp.getAttribute("expectedBeginDate")%></font> &nbsp; <font color="blue"><b>date To : </b></font><font color="red"><%=wboTemp.getAttribute("expectedEndDate")%></font>
                    </TD>
                    
                    <TD BGCOLOR="#FFFF99" >
                        <font color="red"><b><%=wboTemp.getAttribute("total")%></b></font>
                    </TD>
                    
                    <TD BGCOLOR="#FFFF99" >
                        <font color="red"><b><%=wboTemp.getAttribute("totalEmergency")%></b></font>
                    </TD>
                </TR>      
                
            </TABLE>
            <br><br>
            
            <%
            }
            %>
            <center>
                <APPLET ALIGN="center" CODE="SoftMultiBarJApplet.class" width=540 height=360 ARCHIVE="docs/ChartDirector.jar">
                    <PARAM NAME="Total" VALUE="<%=sTotal%>">
                    <PARAM NAME="Finished" VALUE="<%=sFinshed%>">
                    <PARAM NAME="labels" VALUE="<%=sLabels%>">
                </APPLET>
            </center>
        </fieldset>
        
</tr></td ></table>
</FORM>
</BODY>
</HTML>     
