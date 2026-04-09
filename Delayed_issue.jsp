<%@ page import="com.tracker.common.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.tracker.engine.IssueStatusFactory, com.tracker.engine.*,com.docviewer.db_access.*, com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %> 
<%@ page pageEncoding="UTF-8"%>
<HTML>
    <meta HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <meta HTTP-EQUIV="Expires" CONTENT="0">
    <head>
        <title>Weekly Manager Agenda</title>
        <link REL="stylesheet" TYPE="text/css" HREF="css/CSS.css">
    </head>
    
    <%
    
    IssueMgr unitScheduleMgr = IssueMgr.getInstance();
    DelayReasonsMgr delayReasonsMgr =DelayReasonsMgr.getInstance();
    Vector reasons=new Vector();
    AppConstants appCons = new AppConstants();
    WebBusinessObject wbo=new WebBusinessObject();
    WebBusinessObject wbo2=null;
    WebBusinessObject wbo3=null;
    Vector issues = new Vector();
    issues = (Vector) unitScheduleMgr.getIssue();
    ProjectMgr projectMgr=ProjectMgr.getInstance();
    UnitScheduleMgr maintMgr=UnitScheduleMgr.getInstance();
    
    %>        
    <LINK REL="stylesheet" TYPE="text/css" HREF="css/Button.css">
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function changePage(url){
                window.navigate(url);
        }

       function changeicon(name,image1){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
                document.getElementById(image1).src ="images/-.jpg";

            }
              else if(document.getElementById(name).style.display == 'block'){
                document.getElementById(name).style.display = 'none';
                document.getElementById(image1).src ="images/+.jpg";
            }
        }
        
        
        function changeMode(image1){
    document.getElementById(image1).src ="images/lft.png";
    }
    
    function changeMode2(image1){
    document.getElementById(image1).src ="images/aro.png";
    }
        
        
    </SCRIPT>
    <script src='js/ChangeLang.js' type='text/javascript'></script>
    <BODY >
        
        
        <fieldset align="center" class="set" >
            <legend align="center">
                <table dir="rtl" align="center">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">   &#1575;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604; &#1575;&#1604;&#1605;&#1578;&#1571;&#1582;&#1585;&#1577; &#1593;&#1606; &#1605;&#1610;&#1593;&#1575;&#1583; &#1578;&#1606;&#1601;&#1610;&#1584;&#1607;&#1575;
                                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            <table align="center" width="100%" dir="rtl" border="0">
                <tr bgcolor="#D25A0B"><td>
                        <font color="white" size="4">&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;</font>
                        
                    </td>
                    <td>
                        <font color="white" size="4">  &#1578;&#1575;&#1585;&#1610;&#1582; &#1575;&#1604;&#1573;&#1606;&#1578;&#1607;&#1575;&#1569;</font>
                        
                    </td>
                    <td>
                        <font color="white" size="4">   &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1588;&#1585;&#1608;&#1593;</font>
                        
                    </td>
                    <td>
                        <font color="white" size="4">  &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; </font>
                    </td>
                    <td>
                        <font color="white" size="4">  &#1575;&#1587;&#1576;&#1575;&#1576; &#1575;&#1604;&#1578;&#1571;&#1582;&#1610;&#1585; </font>
                    </td>
                    <td>
                        <font color="white" size="4">  &#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1587;&#1576;&#1575;&#1576; &#1575;&#1604;&#1578;&#1571;&#1582;&#1610;&#1585; </font>
                    </td>
                </tr>
                
                <%  
                
                for(int j=0;j<issues.size();j++){
        wbo2=(WebBusinessObject)issues.get(j);
        WebBusinessObject temp=(WebBusinessObject)projectMgr.getOnSingleKey((String) wbo2.getAttribute("projectName"));
        WebBusinessObject temp2=(WebBusinessObject)maintMgr.getOnSingleKey((String) wbo2.getAttribute("unitScheduleID"));
        
        String endD=(String)wbo2.getAttribute("expectedEndDate");
        String [] da=endD.split("-");
        
        //java.util.Date d=new  java.util.Date(endD);
        java.util.Date date=new  java.util.Date(Integer.parseInt(da[0])-1900,Integer.parseInt(da[1]),Integer.parseInt(da[2]));
        int x=date.getDate();
        int y=date.getMonth();
        
        Date dd=java.util.Calendar.getInstance().getTime();
        
        int x1=dd.getDate();
        int y1=dd.getMonth()+1;
        
        String color="white";
        
        if(y==y1 && x1-x>1)
            color="yellow";
        if((x1>x && y1>=y)||(x1<x && y1>y)||y1>y)
            color="yellow";
         String tempvar=(String)temp2.getAttribute("id");
         reasons=delayReasonsMgr.getDelayReasons(tempvar);       
                %>
                
                <tr bgcolor=<%=color%>>
                    <td > <font size="3"> <%=wbo2.getAttribute("issueTitle")%>  </font></td>
                    <td> <font size="3"> <%=wbo2.getAttribute("expectedEndDate")%> </font></td>
                    <td>
                        <font size="3"> <%=temp.getAttribute("projectName")%></font>
                    </td>
                    <td>
                        <%=temp2.getAttribute("unitName")%>
                        
                    </td>
                    <td bgcolor="#ffffff">                     
                        <a href="EquipmentServlet?op=addDelayReason&issueId=<%=temp2.getAttribute("id")%>"><b> &#1575;&#1590;&#1601; &#1587;&#1576;&#1576; &#1578;&#1571;&#1582;&#1610;&#1585;</b></a>
                    </td>
                    <%if(reasons.size()>0){%>
                    <td bgcolor="#ffffff">                     
                    <a href="EquipmentServlet?op=viewDelayReasons&issueId=<%=temp2.getAttribute("id")%>"><font size="2"><b> &#1605;&#1588;&#1575;&#1607;&#1583;&#1607; &#1575;&#1587;&#1576;&#1575;&#1576; &#1575;&#1604;&#1578;&#1571;&#1582;&#1610;&#1585;</b></font></a>
                    </td>
                    <%}else{%>
                    <td bgcolor="#ffffff">                     
                        <font color="red"><b>&#1604;&#1575; &#1578;&#1608;&#1580;&#1583; &#1575;&#1587;&#1576;&#1575;&#1576; &#1575;&#1604;&#1578;&#1571;&#1582;&#1610;&#1585;</b></font>
                    </td>
                    <%}%>
                </tr>
                
                <%}%>
            </table>
            
        </fieldset>
        
    </BODY>
</HTML>