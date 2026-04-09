<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.tracker.engine.*,com.silkworm.common.*, com.tracker.common.*, java.util.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.util.*,java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<html>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    Hashtable logos=(Hashtable)session.getAttribute("logos");
    
    WebBusinessObject taskPartWbo=new WebBusinessObject();
    WebBusinessObject taskToolWbo=new WebBusinessObject();
    WebBusinessObject taskWbo=new WebBusinessObject();
    WebBusinessObject taskNote=new WebBusinessObject();
    
    Vector taskParts=new Vector();
    Vector taskTools=new Vector();
    Vector taskNotes=new Vector();
    Vector taskLightToolsVec=new Vector();
    
    taskWbo=(WebBusinessObject)request.getAttribute("taskWbo");
    taskParts=(Vector)request.getAttribute("taskParts");
    taskNotes=(Vector)request.getAttribute("taskNotes");
    taskTools=(Vector)request.getAttribute("taskTools");
    taskLightToolsVec=(Vector)request.getAttribute("taskLightToolsVec");
    
    
    String classStyle="tRow";
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String padding=null;
    String dir=null;
    String style=null;
    String lang,langCode,sBackToList;
    String taskTitle,partsTitle,notesTitle,toolsTitle,taskName,taskCode,taskType,trade,category,
            job,duration,engDesc,partName,partCode,partQuan,partPrice,totlaPrice,partNotes,
            toolName,toolCode,toolNotes,taskExecNote,title,noParts,noExecNotes,noTools,EstimatedHours,lightToolsStr,noLightTools ,sMinute ,sHour, sDay ;
    if(stat.equals("En")){
        
        align="center";
        padding="padding-left:";
        dir="LTR";
        style="text-align:right";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        sBackToList = "Back";
        
        title="View Maintenance Item Data";
        
        taskTitle="Maintenance Item Details";
        taskName="Item Name";
        taskCode="Item Code";
        category="Category";
        taskType="Task Type";
        trade="Trade Name";
        job="Reqiured Jop";
        duration="Expected Duration";
        engDesc="English Description ";
        
        partsTitle="Maintenance Item Parts";
        partName="Part Name";
        partCode="Part Code";
        partQuan="Quantitiy";
        partPrice="Price";
        partNotes="Notes";
        totlaPrice="Total Price";
        
        toolsTitle="Maintenance Item Tools";
        toolName="Tool Name";
        toolCode="Tool Code";
        toolNotes="Notes";
        
        notesTitle="Maintenance Item Execution Notes";
        taskExecNote="Execution Notes";
        
        noParts="No Parts On  This Item";
        noExecNotes="No Execution Notes on this item";
        noTools="No Heavy Tools On This Item";
        
        lightToolsStr="Task Light Tools";
        noLightTools="No Light Tools on This Item";
         sMinute = "Minute";
        sHour = "Hour";
        sDay = "Day";
          EstimatedHours="Expected Duration";
    }else{
        
        style="style";
        dir="RTL";
        style="text-align:center";
        padding="padding-right:";
        lang="English";
        langCode="En";
        sBackToList = "&#1593;&#1608;&#1583;&#1607;";
        
        title="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        
        taskTitle="&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        taskName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1576;&#1606;&#1583;";
        taskCode="&#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583;";
        category="&#1575;&#1604;&#1589;&#1606;&#1601;";
        taskType="&#1606;&#1608;&#1593; &#1575;&#1604;&#1576;&#1606;&#1583;";
        trade="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1607; &#1575;&#1604;&#1601;&#1606;&#1610;&#1607;";
        job="&#1575;&#1604;&#1605;&#1607;&#1606;&#1607; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        duration="&#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1605;&#1583;&#1607;";
        engDesc="&#1575;&#1604;&#1608;&#1589;&#1601; &#1575;&#1604;&#1575;&#1606;&#1580;&#1604;&#1610;&#1586;&#1609;";
        
        partsTitle="&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1604;&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        partName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
        partCode="&#1603;&#1608;&#1583; &#1575;&#1604;&#1602;&#1591;&#1593;&#1607;";
        partQuan="&#1575;&#1604;&#1603;&#1605;&#1610;&#1607;";
        partPrice="&#1575;&#1604;&#1587;&#1593;&#1585;";
        partNotes="&#1575;&#1604;&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        totlaPrice="&#1573;&#1580;&#1605;&#1575;&#1604;&#1609; &#1575;&#1604;&#1587;&#1593;&#1585;";
        
        toolsTitle="&#1575;&#1604;&#1571;&#1583;&#1608;&#1575;&#1578; &#1575;&#1604;&#1579;&#1602;&#1610;&#1604;&#1607; &#1604;&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        toolName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1571;&#1583;&#1575;&#1607;";
        toolCode="&#1603;&#1608;&#1583; &#1575;&#1604;&#1571;&#1583;&#1575;&#1607;";
        toolNotes="&#1575;&#1604;&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;";
        
        notesTitle="&#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1578;&#1606;&#1601;&#1610;&#1584; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        taskExecNote="&#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1575;&#1604;&#1578;&#1606;&#1601;&#1610;&#1584;";
        
        noParts="&#1604;&#1575;&#1578;&#1608;&#1580;&#1583; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1604;&#1607;&#1584;&#1575; &#1575;&#1604;&#1576;&#1606;&#1583;";
        noExecNotes="&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1578;&#1608;&#1589;&#1610;&#1575;&#1578; &#1578;&#1606;&#1601;&#1610;&#1584; &#1604;&#1607;&#1584;&#1575; &#1575;&#1604;&#1576;&#1606;&#1583;";
        noTools="&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1571;&#1583;&#1608;&#1575;&#1578; &#1604;&#1607;&#1584;&#1575; &#1575;&#1604;&#1576;&#1606;&#1583;";
        
        lightToolsStr="&#1575;&#1604;&#1571;&#1583;&#1608;&#1575;&#1578; &#1575;&#1604;&#1582;&#1601;&#1610;&#1601;&#1607; &#1604;&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
        noLightTools="&#1604;&#1575;&#1578;&#1608;&#1580;&#1583; &#1571;&#1583;&#1608;&#1575;&#1578; &#1582;&#1601;&#1610;&#1601;&#1607; &#1604;&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
          EstimatedHours="&#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1605;&#1583;&#1607;";
    sMinute = "&#1583;&#1602;&#1610;&#1602;&#1577;";
    sHour = "&#1587;&#1575;&#1593;&#1577;";
    sDay = "&#1610;&#1608;&#1605;";
    }
    
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <TITLE>Equipment Data</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/headers.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
        <style>
            td{
            font-size:14;
            color:black;
            border-right-width:1px;
            height:25;
            }
        </style>
          
    </head>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript"></script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
   
    function cancelForm()
        {    
        document.Equipment_FORM.action ="main.jsp";
        document.Equipment_FORM.submit();  
        }
    </script>
   
  
    
    <body>
        
        <FORM NAME="Equipment_FORM" METHOD="POST">
            <table class="table_style" border="0"  dir="LTR">
                <button  onclick="JavaScript: cancelForm();"><%=sBackToList%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"> </button>
            </table> 
            
          <fieldset align="center" class="set" style="width:80%">
                <br>     
              <table  border="0" align="center" dir="<%=dir%>" class="table_style" id="table1">
                  <tr >
                      <td colspan="2" style=" font-size: 20px;font-weight: bold;color: #0000FF; text-align:center;border-width:0px;width: 340px;">
                          <b> صحيفة بند الصيانه</b>
                          <br>
                          <b style="font-size: 16px;" > Maintenance Item Data Sheet</b>
                          
                      </td>
                        
                      <td colspan="2" style="text-align:center;border-width:0px;width: 234px;">
                          <img border="0" src="images/Leha_Logo.jpg" width="200" height="120"/>
                      </td>
                  </tr>
                    
                  <tr>
                      <td colspan="4" class="td">
                          <hr  style="color:blue;size:2;"/>
                          <br>
                      </td>    
                  </tr>
                                  
                    
                  <tr >
                      <td   class="tRow"  bgcolor="#CCCCCC" style=" align:left;font-size:14;<%=padding%>0.75cm">
                          <b>
                              <%=taskName%>
                          </b>
                      </td>
                      <td style="width: 150px;">
                          <b>
                              <%=taskWbo.getAttribute("name").toString()%>
                          </b>        
                      </td>
                        
                      <td  class="tRow"  bgcolor="#CCCCCC" style="align:left;font-size:14;<%=padding%>0.75cm">
                          <b>
                              <%=taskCode%>
                      </b></td>
                      <td style="width: 140px;">
                          <b>
                              <%=taskWbo.getAttribute("title").toString()%>
                          </b>
                      </td>
                  </tr>
                    
                  <tr >
                      <td  class="tRow"  bgcolor="#CCCCCC" style="align:left;font-size:14;<%=padding%>0.75cm">
                          <b>
                              <%=job%>  
                          </b>
                      </td>
                      <td style="width: 150px;">
                          <b>
                              <%=taskWbo.getAttribute("empName").toString()%>
                          </b>
                      </td>
                        
                      <td  class="tRow"  bgcolor="#CCCCCC" style="<%=style%>;font-size:14;<%=padding%>0.75cm">
                          <b>
                              <%=trade%>  
                          </b>
                      </td>
                      <td style="width: 140px;">
                          <b>
                              <%=taskWbo.getAttribute("trade").toString()%>
                          </b>
                      </td>
                  </tr>
                    
                  <tr >
                      <td  class="tRow" bgcolor="#CCCCCC" style="align:left;font-size:14;<%=padding%>0.75cm">
                          <b>
                              <%=category%>  
                          </b>
                      </td>
                      <td style="width: 150">
                          <b>
                              <%=taskWbo.getAttribute("eqpName").toString()%>
                          </b>
                      </td>
                        
                      <td  class="tRow"  bgcolor="#CCCCCC" style="<%=style%>;width: 100px; font-size:14;<%=padding%>0.75cm">
                          <b>
                              <%=taskType%>  
                          </b>
                      </td>
                      <td style="width: 140">
                          <b>
                              <%=taskWbo.getAttribute("taskType").toString()%>
                          </b>
                      </td>
                  </tr>
                    
                  <tr >
                        
         <td  class="tRow" bgcolor="#CCCCCC" style="<%=style%>;font-size:14;<%=padding%>0.75cm">
            <LABEL FOR="str_Function_Desc">
                <p><b> <%=EstimatedHours%><font color="#FF0000">*</font></b>&nbsp;
            </LABEL>
        </TD>
        <td style="width: 150">
            <table   align="center" DIR="<%=dir%>" >
                            <tr>
                                <td style="border-right-width:1px;border-left-width:1px"><font color="red"><b><%=sMinute%></b></font></td>
                                <td ><font color="red"><b><%=sHour%></b></font></td>
                                <td style="border-right-width:1px;border-left-width:1px"><font color="red"><b><%=sDay%></b></font></td>
                            </tr>
                            <%
                                    
                                int day =0;
                                int minute=0;
                                int hour =0;
                                String exeHours = taskWbo.getAttribute("executionHrs").toString();
                                int exehour = Integer.parseInt(exeHours);
                                day = (exehour/ 60)/24;
                                hour =( exehour - day*24*60)/60;
                                minute = exehour - day*24*60 - hour*60;
                            %>
                            <tr style="width: 588;">
                                <td style="border-right-width:1px;border-left-width:1px">
                                    <% if (minute> 0) {%>
                                      <input readonly style="width:40px" name="minute" value="<%=minute%>" ID="minute" >
                                      
                                    <% } else {%>
                                    <input readonly style="width:40px" name="minute" value=<%=""%> ID="minute" >
                                    <% }%>
                                </td>
                                <td >
                                    <% if ( hour> 0) {%>
                                    <input readonly style="width:40px" name="hour" value="<%=hour%>" ID="hour" >
                                    <% } else {%>
                                    <input readonly style="width:40px" name="hour" value="<%=""%>" ID="hour" >
                                    <% }%>
                                </td>
                                <td  style="border-right-width:1px;border-left-width:1px">
                                    <% if (day > 0) {%>
                                   <input readonly style="width:40px" name="day" value="<%=day%>" ID="day" >
                                    <% } else {%>
                                    <input readonly style="width:40px" name="day" value="<%=""%>" ID="day" >
                                    <% }%>
                                </td>
                            </tr>
                          
                        </table>
        </td>
        
        
                    
                      <td  class="tRow" bgcolor="#CCCCCC" style="<%=style%>;font-size:14;<%=padding%>0.75cm" >
                          <b>
                              <%=engDesc%>
                          </b>
                      </td>
                      <td style="width: 140px;" >
                          <b>
                              <%=taskWbo.getAttribute("engDesc").toString()%>
                          </b>
                      </td>
                  </tr>
                    
              </table>
                
              <br>
               
                
                
                <table class="table_style" align="center" border="0" dir="<%=dir%>" align="center" width="85%">
                    <tr >
                        <td class="header" style="text-align:center;" colspan="6">
                            <%=partsTitle%>
                        </td>
                    </tr>
                    
                    <tr >
                        <td class="bar" style="text-align:center;font-size:15;">
                            <%=partCode%>
                        </td>
                        <td class="bar" style="text-align:center;font-size:15;">
                            <%=partName%>
                        </td>
                        <td class="bar" style="text-align:center;font-size:15;">
                            <%=partPrice%>
                        </td>
                        <td class="bar" style="text-align:center;font-size:15;">
                            <%=partQuan%>
                        </td>
                        <td class="bar" style="text-align:center;font-size:15;">
                            <%=totlaPrice%>
                        </td>
                        <td class="bar" style="text-align:center;font-size:15;">
                            <%=partNotes%>
                        </td>
                    </tr>
                    <%
                    if(taskParts.size()>0){
        for(int i=0;i<taskParts.size();i++){
            taskPartWbo=new WebBusinessObject();
            taskPartWbo=(WebBusinessObject)taskParts.get(i);
            if((i%2)==1){
                classStyle="tRow2";
            }else{
                classStyle="tRow";
            }
                    %>
                    <TR>
                        <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:12;height:30;" WIDTH="100" id="code">
                            <%=taskPartWbo.getAttribute("itemId").toString()%>
                        </TD>
                        <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:12;height:30;" WIDTH="250" id="name1">
                            <%=taskPartWbo.getAttribute("itemName").toString()%>
                        </TD>
                        <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:12;height:30;" WIDTH="50" id="price">
                            <%=taskPartWbo.getAttribute("itemPrice").toString()%>
                        </TD>
                        <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:12;height:30;" WIDTH="50">
                            <%=taskPartWbo.getAttribute("itemQuantity").toString()%>
                        </TD>
                        <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:12;height:30;" WIDTH="50" id="cost">
                            <%=taskPartWbo.getAttribute("totalCost").toString()%>
                        </TD>
                        <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:12;height:30;" WIDTH="200">
                            <%=taskPartWbo.getAttribute("note").toString()%>
                        </TD>
                        
                    </tr>
                    <%}}else{%>
                    <tr >
                        <td style="text-align:center;" colspan="6">
                            <font color="red" size="4"> <%=noParts%></font>
                        </td>
                    </tr>
                    <%}%>
                </table>
                
                <br>
                
                <table class="table_style" border="0" dir="<%=dir%>" align="center" width="85%">
                    <tr >
                        <td class="header" style="text-align:center;" colspan="3">
                            <%=toolsTitle%>
                        </td>
                    </tr>
                    
                    <tr >
                        <td class="bar" style="text-align:center;font-size:15;">
                            <%=toolCode%>
                        </td>
                        <td class="bar" style="text-align:center;font-size:15;">
                            <%=toolName%>
                        </td>
                        <td class="bar" style="text-align:center;font-size:15;">
                            <%=toolNotes%>
                        </td>
                    </tr>
                    <%
                    if(taskTools.size()>0){
        for(int i=0;i<taskTools.size();i++){
            taskToolWbo=new WebBusinessObject();
            taskToolWbo=(WebBusinessObject)taskTools.get(i);
            if((i%2)==1){
                classStyle="tRow";
            }else{
                classStyle="tRow2";
            }
                    %>
                    <TR>
                        <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:12;height:30;" WIDTH="25%" id="code">
                            <%=taskToolWbo.getAttribute("toolCode").toString()%>
                        </TD>
                        <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:12;height:30;" WIDTH="25%" id="name1">
                            <%=taskToolWbo.getAttribute("toolName").toString()%>
                        </TD>
                        <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:12;height:30;" WIDTH="50%" id="price">
                            <%=taskToolWbo.getAttribute("notes").toString()%>
                        </TD>
                        
                    </tr>
                    <%}}else{%>
                    <tr >
                        <td style="text-align:center;" colspan="3">
                            <font color="red" size="4"> <%=noTools%></font>
                        </td>
                    </tr>
                    <%}%>
                </table>
                
                <br>
                
                <table class="table_style" border="0" dir="<%=dir%>" align="center" width="85%">
                    <tr >
                        <td style="text-align:center;" class="header" colspan="3">
                            <%=lightToolsStr%>
                        </td>
                    </tr>
                    <tr >
                        <td class="bar" style="text-align:center;font-size:15;">
                            <%=toolCode%>
                        </td>
                        <td class="bar" style="text-align:center;font-size:15;">
                            <%=toolName%>
                        </td>
                        <td class="bar" style="text-align:center;font-size:15;">
                            <%=toolNotes%>
                        </td>
                    </tr>
                    
                    <%
                    if(taskLightToolsVec.size()>0){
        for(int i=0;i<taskLightToolsVec.size();i++){
            taskToolWbo=new WebBusinessObject();
            taskToolWbo=(WebBusinessObject)taskLightToolsVec.get(i);
            if((i%2)==1){
                classStyle="tRow";
            }else{
                classStyle="tRow2";
            }
                    %>
                    <TR>
                        <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:12;height:30;" WIDTH="25%" id="code">
                            <%=taskToolWbo.getAttribute("toolCode").toString()%>
                        </TD>
                        <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:12;height:30;" WIDTH="25%" id="name1">
                            <%=taskToolWbo.getAttribute("toolName").toString()%>
                        </TD>
                        <TD CLASS="<%=classStyle%>" bgcolor="goldenrod" STYLE="text-align:center;color:black;font-size:12;height:30;" WIDTH="50%" id="price">
                            <%=taskToolWbo.getAttribute("notes").toString()%>
                        </TD>
                        
                    </tr>
                    <%}}else{%>
                    <tr >
                        <td style="text-align:center;" colspan="3">
                            <font color="red" size="4"> <%=noLightTools%></font>
                        </td>
                    </tr>
                    <%}%>
                    
                    
                </table>
                
                <br>
                
                <table class="table_style" border="0" dir="<%=dir%>" align="center" width="85%">
                    <tr >
                        <td class="header" style="text-align:center;">
                            <%=notesTitle%>
                        </td>
                    </tr>
                    
                    <tr >
                        <td class="bar" style="text-align:center;font-size:15;">
                            <%=taskExecNote%>
                        </td>
                    </tr>
                    <%
                    if(taskNotes.size()>0){
        for(int i=0;i<taskNotes.size();i++){
            taskNote=new WebBusinessObject();
            taskNote=(WebBusinessObject)taskNotes.get(i);
            if((i%2)==1){
                classStyle="tRow2";
            }else{
                classStyle="tRow";
            }
                    %>
                    <TR>
                        <TD CLASS="<%=classStyle%>" STYLE="text-align:center;height:30;">
                            <textarea style="width:100%" readonly rows="2"><%=taskNote.getAttribute("notes").toString()%></textarea>
                        </TD>
                    </tr>
                    <%}}else{%>
                    <tr >
                        <td style="text-align:center;" colspan="3">
                            <font color="red" size="4"> <%=noExecNotes%></font>
                        </td>
                    </tr>
                    <%}%>
                </table>
                <br><br>
                
            </fieldset>
        </FORM>
    </body>
</html>
