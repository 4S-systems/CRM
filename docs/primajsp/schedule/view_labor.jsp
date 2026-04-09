<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<html>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Create New Schedule</title>
        <link REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </head>
    
    <%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    MaintainableMgr unitMgr  = MaintainableMgr.getInstance();
    
    String context = metaMgr.getContext();
    
    String message;
    String schId = (String) request.getAttribute("schId");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,AllRequired,pri, BackToList,save, AddCode,AddName,saving,TC,TN,TH,TJ,TaskDesc,M,M2,tit,add,del,title,scr,search;
    String CancelForm=context+"/ScheduleServlet?op=CancelBindMaintanbleItems&schId="+schId;
    if(session.getAttribute("urlBackToView")!=null)
        CancelForm=context+"/ScheduleServlet?"+(String)session.getAttribute("urlBackToView");
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        BackToList = "Cancel";
        save = "    Save   ";
        AllRequired="(*) All Data Must Be Filled";
        TC="Maintenance Item Code";
        TN="Maintenance Item  Name";
        TH="Estimated Time";
        TJ="Trade";
        TaskDesc="Description";
        M="Data Had Been Saved Successfully";
        M2="Saving Failed ";
        tit="Maintenance Item ";
        add="Add";
        del="delete";
        pri="priority";
        title="View Maintenance Items";
        scr="images/arrow1.swf";
        search="Auto Search";
        AddCode="Add using Part Code";
        AddName="Add using Part Name";
        
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:right";
        lang="   English    ";
        langCode="En";
        pri="&#1583;&#1585;&#1580;&#1607;";
        AddCode="&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1585;&#1602;&#1605;";
        AddName="&#1576;&#1581;&#1579; &#1576;&#1575;&#1604;&#1575;&#1587;&#1605;";
        BackToList = "&#1573;&#1606;&#1607;&#1575;&#1569;";
        save = " &#1585;&#1576;&#1591; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607; ";
        AllRequired=" &#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607; (*)";
        TC="&#1603;&#1608;&#1583; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        TN="&#1573;&#1587;&#1605; &#1575;&#1604;&#1576;&#1606;&#1583;";
        TH="&#1575;&#1604;&#1587;&#1575;&#1593;&#1575;&#1578; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;&#1607;";
        TJ="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
        TaskDesc="&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        M="&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581;";
        M2="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        tit="&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        add="&#1571;&#1590;&#1601;";
        del="&#1581;&#1584;&#1601;";
        title="&#1593;&#1585;&#1590; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        scr="images/arrow2.swf";
        search="&#1576;&#1581;&#1579; &#1584;&#1575;&#1578;&#1610;";
    }
    
    
    
    %>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
   
   function cancelForm()
        {    
       
       history.back(0);
        }
    </SCRIPT>
    <script src='silkworm_validate.js' type='text/javascript'></script>
    
    
    <link rel="stylesheet" type="text/css" href="autosuggest.css" />
    
    
    <BODY>
        
        <FORM NAME="SCHDULE_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=BackToList%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"> </button>

            </DIV> 
            
            <fieldset >
            <legend align="center">
                
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font color="blue" size="6">  <%=title%>
                            </font>
                        </td>
                    </tr>
                    
                </table>
            </legend >
            
            <br><br>
            
            
            <TABLE ALIGN="<%=align%>" DIR="<%=dir%>"  border="0"   ID="listTable">
                
                <TR>
                    
                    <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250"  > <b><%=TC%></b></TD>
                    <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250" ><b><%=TN%> </b></TD>        
                    <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250" ><b><%=TJ%> </b></TD>
                    <!--TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250" ><b><%=TH%> </b></TD-->
                    <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250" ><b><%=TaskDesc%> </b></TD>
                    <TD CLASS="cell" bgcolor="goldenrod" STYLE="text-align:center;color:white;font-size:14" WIDTH="250" ><b><%=pri%> </b></TD>
                    
                    
                    
                    <%
                    ScheduleTasksMgr scheduleTasksMgr = ScheduleTasksMgr.getInstance();
                    TaskMgr taskMgr=TaskMgr.getInstance();
                    Vector items= scheduleTasksMgr.getOnArbitraryKey(schId,"key1");
                    TradeMgr trade=TradeMgr.getInstance();
                    %>
                    <td>
                        <input type="hidden" name="con" id="con" value="<%=items.size()%>">
                    </td>
                </TR>
                <%
                for(int i=0;i<items.size();i++){
                        WebBusinessObject web=( WebBusinessObject)items.get(i);
                        
                        WebBusinessObject web2=taskMgr.getOnSingleKey((String)web.getAttribute("codeTask"));
      WebBusinessObject web3= trade.getOnSingleKey((String)web2.getAttribute("trade"));
                %>
                <tr>
                    
                    <td  CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14"><%=(String)web2.getAttribute("title")%></td>
                    <td  CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14"><%=(String)web2.getAttribute("name")%></td>
                    
                    <td  CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14"><%=(String)web3.getAttribute("tradeName")%></td>
                    <!--td  CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14"><%=(String)web2.getAttribute("executionHrs")%></td-->
                    <td  CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14"><%=(String)web.getAttribute("desc")%></td>
                    <td  CLASS="cell" bgcolor="#FFE391" STYLE="text-align:center;font-size:14"><%=(String)web.getAttribute("priority")%></td>
                    
                </tr>
                <%}%>
                
            </TABLE>
        </FORM>
    </BODY>
</html>