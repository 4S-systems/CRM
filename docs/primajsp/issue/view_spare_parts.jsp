<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>  
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

Vector actualItems = (Vector) request.getAttribute("actualItems");
Vector quantifiedItems = (Vector) request.getAttribute("quantifiedItems");
Vector configureItems = (Vector) request.getAttribute("configureItems");
WebBusinessObject wbo = (WebBusinessObject) request.getAttribute("wbo");
String currentStatus = new String("");
if(wbo.getAttribute("currentStatus") != null){
    currentStatus = (String) wbo.getAttribute("currentStatus");
}
String bgColor;
double iConfigureTotal = 0;
double iQuantifiedTotal = 0;
double iActualTotal = 0;


String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;

String align=null;
String dir=null;
String style=null;
String lang,langCode,ViewSpars,BackToList,schduled,finished,categlog,ToCost,
        Begined,Finished,Canceled,Holded,Rejected,status,cost,count,price,name,code,onCreate,viewTaskSpar
        ;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    ViewSpars="View Spare Parts";
    BackToList = "Back to list";
    schduled="Scheduled";
    Begined="Begined";
    Finished="Finished";
    Canceled="Canceled";
    Holded="on Hold";
    Rejected="Rejected";
    status="Status";
    code="Code";
    name="Name";
    price="Price";
    count="countity";
    cost="Cost";
    finished="After Execution Spare Parts";
    categlog="Planned Spare Parts";
    onCreate="During Execution Spare Parts";
    ToCost="Total Cost";
    viewTaskSpar="View Spare Parts";
    
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    ViewSpars=" &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
    BackToList = "&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
    schduled="&#1605;&#1580;&#1583;&#1608;&#1604;&#1577;";
    Begined="&#1576;&#1583;&#1571;&#1578;";
    Finished="&#1573;&#1606;&#1578;&#1607;&#1578;";
    Canceled="&#1605;&#1604;&#1594;&#1575;&#1577;";
    Holded="&#1605;&#1608;&#1602;&#1608;&#1601;&#1577;";
    Rejected="&#1605;&#1585;&#1601;&#1608;&#1590;&#1577;";
    status="&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
    code="&#1603;&#1608;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;&#1577;";
    name="&#1575;&#1587;&#1605; &#1575;&#1604;&#1602;&#1591;&#1593;&#1577;";
    price="&#1587;&#1593;&#1585; &#1575;&#1604;&#1608;&#1581;&#1583;&#1577;";
    count="&#1575;&#1604;&#1603;&#1605;&#1610;&#1577;";
    cost="&#1573;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1587;&#1593;&#1585;";
    finished="&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1576;&#1593;&#1583; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
    categlog="&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1605;&#1582;&#1591;&#1591;&#1577;";
    onCreate="&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1582;&#1604;&#1575;&#1604; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
    ToCost="&#1573;&#1580;&#1605;&#1575;&#1604;&#1610;";
    viewTaskSpar="&#1593;&#1585;&#1590; &#1605;&#1585;&#1581;&#1604;&#1610; &#1604;&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
    
}

	WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");

	GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
	Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");

	ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wboPrev;
        for (int i = 0; i < groupPrev.size(); i++) {
            wboPrev = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wboPrev.getAttribute("prevCode"));
        }
%>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

  function cancelForm()
        {    
        document.PROJECT_VIEW_FORM.action = "<%=context%>/AssignedIssueServlet?op=viewdetails&issueId=<%=(String) request.getAttribute("issueId")%>&filterValue=<%=(String) request.getAttribute("filterValue")%>&filterName=<%=(String) request.getAttribute("filterName")%>";
        document.PROJECT_VIEW_FORM.submit();  
        }
       function changeMode(name){
        if(document.getElementById(name).style.display == 'none'){
            document.getElementById(name).style.display = 'block';
        } else {
            document.getElementById(name).style.display = 'none';
        }
    }                              
    
    function changePage(url){
        window.navigate(url);
    }
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>
<HTML>
    
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new Project</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <BODY>
        
        <FORM NAME="PROJECT_VIEW_FORM" METHOD="POST">
            <%if(request.getAttribute("Tap")==null){%>
            <table align="<%=align%>" border="0" width="100%">
                <tr>
                <td STYLE="border:0px;">
                <div STYLE="width:50%;border:2px solid gray;background-color:#808000;color:white;" bgcolor="#F3F3F3" align="<%=align%>">
                    <div ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:14;">
                        <b>
                            <%=status%> 
                        </b>
                        <img src="images/arrow_down.gif">
                    </div>
                    <div ALIGN="center" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;<%=style%>;border-top:2px solid gray;" ID="menu1">
                        <table align="center" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                            <tr>
                                <td style="text-align:center" CLASS="cell" width="16%" bgcolor="#EEE8AA" STYLE="color:black;<%=style%>;"><b><%=schduled%></b></td>
                                <td style="text-align:center" CLASS="cell" width="16%" bgcolor="#EEE8AA" STYLE="color:black;<%=style%>;"><b><%=Begined%></b></td>
                                <td style="text-align:center" CLASS="cell" width="16%" bgcolor="#EEE8AA" STYLE="color:black;<%=style%>;"><b><%=Finished%></b></td>
                                <td style="text-align:center" CLASS="cell" width="16%" bgcolor="#EEE8AA" STYLE="color:black;<%=style%>;"><b><%=Canceled%></b></td>
                                <td style="text-align:center" CLASS="cell" width="16%" bgcolor="#EEE8AA" STYLE="color:black;<%=style%>;"><b><%=Holded%></b></td>
                                <td style="text-align:center" CLASS="cell" width="16%" bgcolor="#EEE8AA" STYLE="color:black;<%=style%>;"><b><%=Rejected%></b></td>
                            </tr>
                            <tr>
                                <td style="text-align:center" CLASS="cell" bgcolor="#F3F3F3"><%if(currentStatus.equalsIgnoreCase("Schedule")){%><IMG SRC="images/don.gif" ALT="" ><%} else {%>&nbsp;<%}%></td>
                                <td style="text-align:center" CLASS="cell" bgcolor="#F3F3F3"><%if(currentStatus.equalsIgnoreCase("Assigned")){%><IMG SRC="images/don.gif" ALT="" ><%} else {%>&nbsp;<%}%></td>
                                <td style="text-align:center"CLASS="cell" bgcolor="#F3F3F3"><%if(currentStatus.equalsIgnoreCase("Finished")){%><IMG SRC="images/don.gif" ALT="" ><%} else {%>&nbsp;<%}%></td>
                                <td style="text-align:center"CLASS="cell" bgcolor="#F3F3F3"><%if(currentStatus.equalsIgnoreCase("Canceled")){%><IMG SRC="images/don.gif" ALT="" ><%} else {%>&nbsp;<%}%></td>
                                <td style="text-align:center"CLASS="cell" bgcolor="#F3F3F3"><%if(currentStatus.equalsIgnoreCase("Onhold")){%><IMG SRC="images/don.gif" ALT="" ><%} else {%>&nbsp;<%}%></td>
                                <td style="text-align:center"CLASS="cell" bgcolor="#F3F3F3"><%if(currentStatus.equalsIgnoreCase("Rejected")){%><IMG SRC="images/don.gif" ALT="" ><%} else {%>&nbsp;<%}%></td>
                            </tr>
                            
                        </table>
                    </DIV>
                </div>
            </table>
            <DIV align="left" STYLE="color:blue;">
                <input type="button" class="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')">
                <button  class="button" onclick="JavaScript: cancelForm();"><%=BackToList%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                <button style="display: <%=userPrevList.contains("EXCEL") ? "" : "none"%>;" class="button" onclick="JavaScript: changePage('<%=context%>/ItemDocReaderServlet?op=ViewPartsExcel&issueId=<%=request.getParameter("issueId")%>');"><IMG VALIGN="BOTTOM"   SRC="images/xlsicon.gif"> </button>
            </DIV>
            
            <%}%>
            <fieldset align="center" style="border-color:blue" >
            <legend align="<%=align%>">
                
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">   <%=viewTaskSpar%>
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend >
            
            <br><br><br>
            <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%">
                
                <tr>
                    <TD CLASS="td" VALIGN="top">
                        <table ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%">
                            <TR>
                                <TD STYLE="border:1px solid black" width ="33%" VALIGN="top" COLSPAN="2">
                                    <table border="0" ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%" cellpadding="0" cellspacing="1">
                                        <TR>
                                            <TD style="text-align:center" CLASS="head" bgcolor="#F3F3F3" width="33%" COLSPAN="6">
                                                <b><%=categlog%></b>
                                            </TD>
                                        </TR>
                                        <TR bgcolor="#808080">
                                            <TD STYLE="border:0px;color:white">
                                                <b><%=code%></b>
                                            </TD>
                                            <TD STYLE="border:0px;color:white">
                                                <b><%=name%></b>
                                            </TD>
                                            <TD STYLE="border:0px;color:white">
                                                <b><%=count%></b>
                                            </TD>
                                            <!--TD STYLE="border:0px;color:white">
                                                <b><%=price%></b>
                                            </TD>
                                            <TD STYLE="border:0px;color:white">
                                                <b><%=cost%></b>
                                            </TD-->
                                        </TR>
                                        <%
                                        for(int i = 0; i < configureItems.size(); i++){
    WebBusinessObject tempWbo = (WebBusinessObject) configureItems.get(i);
    if((i%2) == 1) {
        bgColor="#FFFFCC";
    } else {
        bgColor="#CCCC00";
    }
    if(((String) tempWbo.getAttribute("totalCost")) != null){
        Double iTemp = new Double(((String) tempWbo.getAttribute("totalCost")));
        iConfigureTotal = iConfigureTotal + iTemp.doubleValue();
    }
                                        %>
                                        <TR BGCOLOR="<%=bgColor%>">
                                            <TD STYLE="border:0px">
                                                <%=(String) tempWbo.getAttribute("itemCode")%>
                                            </TD>
                                            <TD STYLE="border:0px">
                                                <%=(String) tempWbo.getAttribute("itemDscrptn")%>
                                            </TD>
                                            <TD STYLE="border:0px">
                                                <%=(String) tempWbo.getAttribute("itemQuantity")%>
                                            </TD>
                                            <!--TD STYLE="border:0px">
                                                <%=(String) tempWbo.getAttribute("itemPrice")%>
                                            </TD>
                                            <TD STYLE="border:0px">
                                                <%=(String) tempWbo.getAttribute("totalCost")%>
                                            </TD-->
                                        </TR>
                                        <%
                                        }
                                        %>
                                    </TABLE>
                                </TD>
                                <TD STYLE="border:1px solid black" width ="33%" VALIGN="top" COLSPAN="2">
                                    <table border="0" ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%" cellpadding="0" cellspacing="1">
                                        <TR>
                                            <TD style="text-align:center" CLASS="head" bgcolor="#F3F3F3" width="33%" COLSPAN="6">
                                                <b><%=onCreate%></b>
                                            </TD>
                                        </TR>
                                        <TR bgcolor="#808080">
                                            <TD STYLE="border:0px;color:white">
                                                <b><%=code%></b>
                                            </TD>
                                            <TD STYLE="border:0px;color:white">
                                                <b><%=name%></b>
                                            </TD>
                                            <TD STYLE="border:0px;color:white">
                                                <b><%=count%></b>
                                            </TD>
                                            <!--TD STYLE="border:0px;color:white">
                                                <b><%=price%></b>
                                            </TD>
                                            <TD STYLE="border:0px;color:white">
                                                <b><%=cost%></b>
                                            </TD-->
                                        </TR>
                                        <%
                                        for(int i = 0; i < quantifiedItems.size(); i++){
    WebBusinessObject tempWbo = (WebBusinessObject) quantifiedItems.get(i);
    if((i%2) == 1) {
        bgColor="#FFFFCC";
    } else {
        bgColor="#CCCC00";
    }
    if(((String) tempWbo.getAttribute("totalCost")) != null){
        Double iTemp = new Double(((String) tempWbo.getAttribute("totalCost")));
        iQuantifiedTotal = iQuantifiedTotal + iTemp.doubleValue();
    }
                                        %>
                                        <TR BGCOLOR="<%=bgColor%>">
                                            <TD STYLE="border:0px">
                                                <%=(String) tempWbo.getAttribute("itemCode")%>
                                            </TD>
                                            <TD STYLE="border:0px">
                                                <%=(String) tempWbo.getAttribute("itemDscrptn")%>
                                            </TD>
                                            <TD STYLE="border:0px">
                                                <%=(String) tempWbo.getAttribute("itemQuantity")%>
                                            </TD>
                                            <!--TD STYLE="border:0px">
                                                <%=(String) tempWbo.getAttribute("itemPrice")%>
                                            </TD>
                                            <TD STYLE="border:0px">
                                                <%=(String) tempWbo.getAttribute("totalCost")%>
                                            </TD-->
                                        </TR>
                                        <%
                                        }
                                        %>
                                    </TABLE>
                                </TD>
                                <TD STYLE="border:1px solid black" width ="33%" VALIGN="top" COLSPAN="2">
                                    <table border="0" ALIGN="<%=align%>" DIR="<%=dir%>" width ="100%" cellpadding="0" cellspacing="1">
                                        <TR>
                                            <TD style="text-align:center" CLASS="head" bgcolor="#F3F3F3" width="33%" COLSPAN="6">
                                                <B><%=finished%></B>
                                            </TD>
                                        </TR>
                                        <TR bgcolor="#808080">
                                            <TD STYLE="border:0px;color:white">
                                                <b><%=code%></b>
                                            </TD>
                                            <TD STYLE="border:0px;color:white">
                                                <b><%=name%></b>
                                            </TD>
                                            <TD STYLE="border:0px;color:white">
                                                <b><%=count%></b>
                                            </TD>
                                            <!--TD STYLE="border:0px;color:white">
                                                <b><%=price%></b>
                                            </TD>
                                            <TD STYLE="border:0px;color:white">
                                                <b><%=cost%></b>
                                            </TD-->
                                        </TR>
                                        <%
                                        for(int i = 0; i < actualItems.size(); i++){
    WebBusinessObject tempWbo = (WebBusinessObject) actualItems.get(i);
    if((i%2) == 1) {
        bgColor="#FFFFCC";
    } else {
        bgColor="#CCCC00";
    }
    if(((String) tempWbo.getAttribute("totalCost")) != null){
        Double iTemp = new Double(((String) tempWbo.getAttribute("totalCost")));
        iActualTotal = iActualTotal + iTemp.doubleValue();
    }
                                        %>
                                        <TR BGCOLOR="<%=bgColor%>">
                                            <TD STYLE="border:0px">
                                                <%=(String) tempWbo.getAttribute("itemCode")%>
                                            </TD>
                                            <TD STYLE="border:0px">
                                                <%=(String) tempWbo.getAttribute("itemDscrptn")%>
                                            </TD>
                                            <TD STYLE="border:0px">
                                                <%=(String) tempWbo.getAttribute("itemQuantity")%>
                                            </TD>
                                            <!--TD STYLE="border:0px">
                                                <%=(String) tempWbo.getAttribute("itemPrice")%>
                                            </TD>
                                            <TD STYLE="border:0px">
                                                <%=(String) tempWbo.getAttribute("totalCost")%>
                                            </TD-->
                                        </TR>
                                        <%
                                        }
                                        %>
                                    </TABLE>
                                </TD>
                            </TR>
                            <!--TR bgcolor="#808080">
                                <TD STYLE="border:1px solid black;color:white" VALIGN="top">
                                    <b><%=ToCost%></b>
                                </TD>
                                <TD STYLE="border:1px solid black;color:white" width ="10%" VALIGN="top">
                                    <%=iConfigureTotal%>
                                </TD>
                                <TD STYLE="border:1px solid black;color:white" VALIGN="top">
                                    <b><%=ToCost%></b>
                                </TD>
                                <TD STYLE="border:1px solid black;color:white" width ="10%" VALIGN="top">
                                    <%=iQuantifiedTotal%>
                                </TD>
                                <TD STYLE="border:1px solid black;color:white" VALIGN="top">
                                    <b><%=ToCost%></b>
                                </TD>
                                <TD STYLE="border:1px solid black;color:white" width ="10%" VALIGN="top">
                                    <%=iActualTotal%>
                                </TD>
                            </TR-->
                        </TABLE>
                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
