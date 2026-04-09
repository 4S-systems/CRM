<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.silkworm.util.*,com.maintenance.db_access.*,com.tracker.db_access.*,com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
DateAndTimeControl dateAndTime = new DateAndTimeControl();

WebBusinessObject task = (WebBusinessObject) request.getAttribute("taskWbo");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

String searchType=(String)request.getAttribute("searchType");
String taskName = (String)request.getAttribute("taskName");
String taskCode = (String)request.getAttribute("taskCode");
String popup = (String)request.getAttribute("popup");

String sTrade = new String("");

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String saving_status;
String code, code_name;
String title_1,title_2;
String cancel_button_label,taskData;
String save_button_label,Jops,EstimatedHours,Houre,tradeName,taskType,Category,eng_Desc,mainCat;
String sMinute,sHour,sDay;
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    code="Maintenance Item Code";
    code_name="Maintenance Item Name";
    title_1="View Maintenance Item";
    title_2="All information are needed";
    cancel_button_label=" Back To List ";
    save_button_label="Save ";
    langCode="Ar";
    Jops="Reqiured Jop";
    EstimatedHours="Expected Duration";
    Houre="  Hour";
    tradeName="Trade Name";
    taskType="Type Of Task";
    Category="Category";
    eng_Desc="English Description";
    
    taskData="Data Of Maintenance Item";
    mainCat="Main Type Category";
    sMinute = "Minute";
    sHour = "Hour";
    sDay = "Day";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    code="&#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583; ";
    code_name="&#1608;&#1589;&#1601; &#1575;&#1604;&#1576;&#1606;&#1583; ";
    title_1=" &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label="&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
    langCode="En";
    Jops="&#1575;&#1604;&#1605;&#1607;&#1606;&#1607; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1607; ";
    EstimatedHours="&#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1587;&#1575;&#1593;&#1575;&#1578;";
    Houre="   &#1587;&#1575;&#1593;&#1607;";
    tradeName="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
    taskType="&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    Category=" &#1575;&#1604;&#1589;&#1606;&#1601;";
    eng_Desc="&#1575;&#1604;&#1608;&#1589;&#1601; &#1576;&#1575;&#1604;&#1575;&#1606;&#1580;&#1604;&#1610;&#1586;&#1609;";
    
    taskData="&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    mainCat="&#1575;&#1604;&#1606;&#1608;&#1593; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1609;";
    sMinute = "&#1583;&#1602;&#1610;&#1602;&#1577;";
    sHour = "&#1587;&#1575;&#1593;&#1577;";
    sDay = "&#1610;&#1608;&#1605;";
}
%>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - view Failure Code</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/headers.css">
  
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
    function cancelForm()
    {
        //window.close();id
        //document.PROJECT_VIEW_FORM.action = "main.jsp";
        //document.PROJECT_VIEW_FORM.submit();

         var popup = '<%=popup%>';

         if('<%=searchType%>'=='code') {
             if(popup == "no"){
                 document.PROJECT_VIEW_FORM.action = "<%=context%>/TaskServlet?op=getSearchTaskNotPopup&searchType=<%=searchType%>&taskCode=<%=taskCode%>";
             }else{
                 document.PROJECT_VIEW_FORM.action = "<%=context%>/TaskServlet?op=searchTaskResult&searchType=<%=searchType%>&taskCode=<%=taskCode%>";
             }
            document.PROJECT_VIEW_FORM.submit();
          }
        else if('<%=searchType%>'=='name') {
            if(popup=="no"){
                document.PROJECT_VIEW_FORM.action = "<%=context%>/TaskServlet?op=getSearchTaskNotPopup&searchType=<%=searchType%>&taskName=<%=taskName%>";
            }else{
                document.PROJECT_VIEW_FORM.action = "<%=context%>/TaskServlet?op=searchTaskResult&searchType=<%=searchType%>&taskName=<%=taskName%>";
            }
            document.PROJECT_VIEW_FORM.submit();
          }
    }
    
    
    </SCRIPT>
    </HEAD>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="PROJECT_VIEW_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
                
            </DIV> 
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6">    <%=title_1%>                
                                </font>
                                
                            </td>
                        </tr>
                    </table>
                </legend>
                <br>
                
                <TABLE STYLE="border-style:solid;border-width:1px;border-color:black;" DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" WIDTH="80%">
                    
                    <tr>
                        <td colspan="2" class="header" style="text-align:center">
                            <%=taskData%><%=task.getAttribute("title").toString()%>
                        </td>
                    </tr>
                    
                    <TR>
                        <TD WIDTH="40%" STYLE="<%=style%>;padding-right:30;font-size:14;color:black;height:25;" class='bar'>
                            <%
                            String isMain=task.getAttribute("isMain").toString();
                            if(isMain.equalsIgnoreCase("no")){%>
                            <%=Category%>
                            <%}else{%>
                            <%=mainCat%>
                            <%}%>
                        </TD>
                        
                        <TD WIDTH="60%" STYLE="<%=style%>;padding-right:30;" class='tRow'>
                            <%=task.getAttribute("catName")%>
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD WIDTH="40%" STYLE="<%=style%>;padding-right:30;font-size:14;color:black;height:25;" class='bar'>
                            <%=code%>            
                        </TD>
                        
                        <TD WIDTH="60%" STYLE="<%=style%>;padding-right:30;" class='tRow2'>
                            <%=task.getAttribute("title")%>
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD WIDTH="40%" STYLE="<%=style%>;padding-right:30;font-size:14;color:black;height:25;" class='bar'>
                            <%=code_name%>
                        </TD>
                        
                        <TD WIDTH="60%" STYLE="<%=style%>;padding-right:30;" class='tRow'>
                            <%=task.getAttribute("name")%>
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD WIDTH="40%" STYLE="<%=style%>;padding-right:30;font-size:14;color:black;height:25;" class='bar'>
                            <%=Jops%>            
                        </TD>
                        
                        <TD WIDTH="60%" STYLE="<%=style%>;padding-right:30;" class='tRow2'>
                            <%=task.getAttribute("empName")%>
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD WIDTH="40%" STYLE="<%=style%>;padding-right:30;font-size:14;color:black;height:25;" class='bar'>
                            <%=tradeName%>
                        </TD>
                        
                        <TD WIDTH="60%" STYLE="<%=style%>;padding-right:30;" class='tRow'>
                            <%=task.getAttribute("tradeName")%>
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD WIDTH="40%" STYLE="<%=style%>;padding-right:30;font-size:14;color:black;height:25;" class='bar'>
                            <%=taskType%>
                        </TD>
                        
                        <TD WIDTH="60%" STYLE="<%=style%>;padding-right:30;" class='tRow2'>
                            <%=task.getAttribute("taskTypeName")%>
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD WIDTH="40%" STYLE="<%=style%>;padding-right:30;font-size:14;color:black;height:25;" class='bar'>
                            <%=EstimatedHours%>
                        </TD>
                        
                        <TD WIDTH="60%" STYLE="<%=style%>;padding-right:30;" class='tRow'>
                             <%
                                String time = null;
                                String exeHours = task.getAttribute("executionHrs").toString();
                                Double execHr = 0.0;
                                int execIntHr = 0;
                                execHr = new Double(exeHours).doubleValue();
                                if(execHr<1){
                                    execHr =1.0;
                                    }
                                execIntHr = execHr.intValue();
                                time = dateAndTime.getDaysHourMinute(execIntHr);
                                %>
                                <b><font size="2"><%=time%></font></b>
                            
                        </TD>
                        
                    </TR>
                    
                    <TR>
                        <TD WIDTH="40%" STYLE="<%=style%>;padding-right:30;font-size:14;color:black;height:25;" class='bar'>
                            <%=eng_Desc%>
                        </TD>
                        
                        <TD WIDTH="60%" STYLE="<%=style%>;padding-right:30;" class='tRow2'>
                            <%
                            if(task.getAttribute("engDesc")!=null){%>
                            <%=(String)task.getAttribute("engDesc")%>
                            <%}else{%>
                            No Description
                            <%}%>
                            
                        </TD>
                        
                    </TR>
                    
                </TABLE>
                <br>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
