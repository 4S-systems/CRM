<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,java.text.DecimalFormat"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr,com.maintenance.db_access.*"%>
<%--
The taglib directive below imports the JSTL library. If you uncomment it,
you must also add the JSTL library to the project. The Add Library... action
on Libraries node in Projects view can be used to add the JSTL 1.1 library.
--%>
<%--
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%> 
--%>
<%
MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
String context = metaDataMgr.getContext();
String[] itemTitle ={"Code","Name","Count","Note"};
String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,indGuid,active,show,overTyp,nonActive,schTo,addPart,AddItem,updatePart,updateItem,vLabor,title,vConf,frequency,taskView,viewOP,status,plusOp,backtolist,frequencyType1,cancel,dur,EqCat,des,notCon,viewDe,totCost,trade,eqp,name,textAlign,viewParts;
if(stat.equals("En")){
    
    String[] itemAtt = {"itemId","itemQuantity", "note"};
    indGuid=" Indicators guide ";
    textAlign="left";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    show="Search";
    title="Schedule Title";
    frequency="Frequency";
    frequencyType1="Frequency Type";
    dur="Duration";
    trade="Schedule Trade";
    EqCat="Equipment Category";
    eqp="Equipment";
    des="Description";
    cancel="Cancel";
    viewOP=" Viewing Operations";
    plusOp= "Addition Operations";
    status="Status";
    notCon="No Spare Parts for this schedule";
    viewDe="View Schedule Details";
    totCost="Total Schedule Cost";
    taskView=" Shedule Details ";
    backtolist="Back To List";
    viewParts="Designed Spare Parts";
    vConf="View Configuration";
    vLabor="View Labor";
    addPart="Add Spare Parts";
    AddItem="Add Maintenance Items";
    updatePart="Update Spare Parts";
    updateItem="Update Maintenance Items";
    active = "Schedule has Spare Parts";
    schTo="Scheduled To";
    overTyp="schedule Type";
    nonActive = "Schedule has no Spare Parts";
}else{
    textAlign="right";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    overTyp="&#1605;&#1580;&#1583;&#1608;&#1604; &#1593;&#1604;&#1610; &#1606;&#1608;&#1593;";
    show="&#1576;&#1581;&#1579;";
    indGuid= "&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
    title=" &#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
    frequency=" &#1610;&#1603;&#1585;&#1585; &#1603;&#1604;";
    frequencyType1=" &#1606;&#1608;&#1593; &#1575;&#1604;&#1578;&#1603;&#1585;&#1575;&#1585;";
    dur="&#1575;&#1604;&#1605;&#1583;&#1607;";
    trade="&#1606;&#1608;&#1593; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
    EqCat="&#1589;&#1606;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    eqp="&#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    des="&#1575;&#1604;&#1608;&#1589;&#1601;";
    status="&#1575;&#1604;&#1581;&#1575;&#1604;&#1577;";
    viewOP="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
    plusOp="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1573;&#1590;&#1575;&#1601;&#1577;";
    viewOP="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1605;&#1588;&#1575;&#1607;&#1583;&#1577;";
    notCon="&#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585; &#1604;&#1580;&#1583;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    viewDe=" &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
    totCost="&#1573;&#1580;&#1605;&#1575;&#1604;&#1610; &#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1607;";
    taskView="&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
    String[] itemTitleAr ={"&#1575;&#1604;&#1603;&#1608;&#1583;","&#1575;&#1604;&#1573;&#1587;&#1605;","&#1575;&#1604;&#1603;&#1605;&#1610;&#1607;","&#1605;&#1604;&#1575;&#1581;&#1592;&#1575;&#1578;"};
    itemTitle=itemTitleAr;
    backtolist="&#1575;&#1604;&#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607;";
    viewParts="&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1605;&#1582;&#1591;&#1591; &#1604;&#1607;&#1575;";
    vConf="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
    vLabor="&#1593;&#1585;&#1590; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    
    addPart="&#1578;&#1593;&#1610;&#1610;&#1606; &#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    AddItem="&#1573;&#1590;&#1575;&#1601;&#1607; &#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1607;";
    updatePart="&#1578;&#1593;&#1583;&#1610;&#1604; &#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585; &#1575;&#1604;&#1605;&#1590;&#1575;&#1601;&#1607;";
    updateItem="&#1578;&#1593;&#1583;&#1610;&#1604; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607; &#1575;&#1604;&#1605;&#1590;&#1575;&#1601;&#1607;";
    schTo="&#1605;&#1580;&#1583;&#1608;&#1604; &#1604;";
    active = "&#1580;&#1583;&#1608;&#1604; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
    nonActive = "&#1580;&#1583;&#1608;&#1604; &#1594;&#1610;&#1585; &#1605;&#1585;&#1578;&#1576;&#1591;&#1577; &#1576;&#1602;&#1591;&#1593; &#1594;&#1610;&#1575;&#1585;";
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">   
    function showResult(){
    
    var name=document.getElementsByName('schName');
    if(name[0].value=="")
    return;
        var url = "<%=context%>/ScheduleServlet?op=getSchduleByName&Sname="+name[0].value;
            if (window.XMLHttpRequest)
            { 
                req = new XMLHttpRequest(); 
            } 
               else if (window.ActiveXObject)
            { 
                req = new ActiveXObject("Microsoft.XMLHTTP"); 
            } 
            req.open("Post",url,true); 
            req.onreadystatechange =  callbackres;
       
            req.send(null);
      
      }

         function callbackres( ) {
             if (req.readyState==4) {
                 if (req.status == 200) {
                   
                     var resul= req.responseText;
                     var arr=resul.split("!=");
                    
                     size=arr[0];
                     if(size==0){                       
                  
                    alert("not found schedule");
                    
                      var input1=document.getElementsByName('maintenanceTitle');
                    input1[0].value=" ";
                   
                     var input2=document.getElementsByName('unitName');
                     var input0=document.getElementsByName('resType');
                    
                       input2[0].value=" ";
                       input0[0].value=" ";
                       
                    var input3=document.getElementsByName('frequency');
                    input3[0].value=" ";
                    
                    var input4=document.getElementsByName('duration');
                    input4[0].value=" ";
                    var input5=document.getElementsByName('tradeName');
                     input5[0].value=" ";
                    var input6=document.getElementsByName('description');
                    input6[0].value=" ";
                    
                    return;
                    }
                    
                    if(size>1)
                        alert("There is more one schedule with the same name");
                    var input1=document.getElementsByName('maintenanceTitle');
                    input1[0].value=arr[1];
                   
                     var input2=document.getElementsByName('unitName');
                   
                    var input22=document.getElementsByName('catName');
                    var input21=document.getElementsByName('eqName');
                     var input0=document.getElementsByName('resType');
                    if(arr[2]=="cat"){
                       input2[0].value=input22[0].value+"      "+arr[3];
                       input0[0].value="ON  "+input22[0].value;
                       }
                       else{
                       input2[0].value=input21[0].value+"      "+arr[3];
                       input0[0].value="ON  "+input21[0].value;
                       }
                    var input3=document.getElementsByName('frequency');
                    input3[0].value=arr[4]+"    "+arr[5];
                    
                    var input4=document.getElementsByName('duration');
                    input4[0].value=arr[6]+"     Hour";
                    var input5=document.getElementsByName('tradeName');
                     input5[0].value=arr[7];
                    var input6=document.getElementsByName('description');
                    input6[0].value=arr[8];
                }
        }
    }


</SCRIPT>
<script src='silkworm_validate.js' type='text/javascript'></script>
<script src='ChangeLang.js' type='text/javascript'></script>
<link rel="stylesheet" type="text/css" href="Button.css" />
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>JSP Page</title>
</head>
<BODY>
<DIV align="left" STYLE="color:blue;">
    <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
    
</DIV>
<center>
<table>
<tr>
    <td><input type="text" name="schName" id="schName" size="33"></td>
    <td>
        <DIV align="left" STYLE="color:blue;">
            <input type="button" value="   <%=show%>         " onclick="showResult();">
        </DIV>
    </td>
</tr>

<tr>
<input type="hidden" name="catName" value="<%=EqCat%>">
<input type="hidden" name="eqName" value="<%=eqp%>">



<br>

<TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" WIDTH="600">
<TR>
    <TD CLASS="cell" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16" COLSPAN="3">
        <B><%=taskView%></B>                   
    </TD>
</TR>

<TR>
    <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:<%=textAlign%>;color:white;font-size:14" WIDTH="150"><B><%=overTyp%></B></TD>
    <TD CLASS="cell" COLSPAN="2" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><input type="text" name="resType" id="resType" readonly size="50"></TD>
</TR>
<TR>
    <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:<%=textAlign%>;color:white;font-size:14" WIDTH="150"><B><%=title%></B></TD>
    <TD CLASS="cell" COLSPAN="2" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><input type="text" name="maintenanceTitle" id="maintenanceTitle" size="50" readonly></TD>
</TR>

<TR>
    
    <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:<%=textAlign%>;color:white;font-size:14" WIDTH="150"><b><%=schTo%></b></TD>
    <TD CLASS="cell" COLSPAN="2" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><input type="text" name="unitName" id="unitName" size="50" readonly></TD>
</TR>

<TR>
    <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:<%=textAlign%>;color:white;font-size:14" WIDTH="150"><B><%=frequency%></B></TD>
    <TD CLASS="cell" COLSPAN="2" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14" ><input type="text" name="frequency" id="frequency" size="50" readonly></TD>
</TR>

<TR>
<TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:<%=textAlign%>;color:white;font-size:14" WIDTH="150"><B><%=dur%></B></TD>
<TD CLASS="cell" COLSPAN="2" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14" ><input type="text" name="duration" id="duration" size="50" readonly></FONT></TD>
</TR>

<TR>
    <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:<%=textAlign%>;color:white;font-size:14" WIDTH="150"><B><%=trade%></B></TD>
    <TD CLASS="cell" COLSPAN="2" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><input type="text" name="tradeName" id="tradeName" size="50" readonly></TD>
</TR>

<TR>
    <TD CLASS="cell" bgcolor="#9B9B00" STYLE="text-align:<%=textAlign%>;color:white;font-size:14" WIDTH="150"><B><%=des%></B></TD>
    <TD CLASS="cell" COLSPAN="2" bgcolor="#EEE8AA" STYLE="text-align:center;font-size:14"><input type="text" name="description" id="description" size="50" readonly></TD>
</TR>


</TABLE>

<br>



<br>

</tr>

</table>

</body>
</html>
