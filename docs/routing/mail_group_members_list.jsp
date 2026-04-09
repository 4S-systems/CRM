<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Users List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script src='ChangeLang.js' type='text/javascript'></script>
    </HEAD>
    <%
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    AppConstants appCons = new AppConstants();
    
    String[] userAttributes = appCons.getUserAttributes();
//    String[] userListTitles = appCons.getUserHeaders();
    
    int s = userAttributes.length;
    int t = s+2;
    int iTotal = 0;
    
    String attName = null;
    String attValue = null;   
    
    
    Vector  usersList = (Vector) request.getAttribute("data");
//    long  numberOfUsers = (Long) request.getAttribute("numberOfUsers");
    
    
    WebBusinessObject wbo = null;
    int flipper = 0;
    String bgColor = null;
    String bgColorm = null;
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,tit,save,cancel,TT,IG,AS,QS,BO,CD,sUsersTotal,NAS,sUsersList,name,projectName;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        tit="Delete Schedule - Are you Sure ?";
        save="Delete";
        cancel="Back To List";
        TT="Task Title ";
        IG="Indicators guide ";
        AS="Active Site by Equipment";
        NAS="Non Active Site";
        QS="Quick Summary";
        BO="Basic Operations";
        name="User Name";
        //userListTitles[1]="Password";
//        userListTitles[1]="View";
//        userListTitles[2]="Edit";
//        userListTitles[3]="Delete";
        CD="Can't Delete Site";
        sUsersTotal="Total Users";
        sUsersList="Users List";
//        viewUserLabel = "Basic Info.";
        projectName="Project Name";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        tit=" &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
        save=" &#1573;&#1581;&#1584;&#1601;";
        cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        TT="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        IG="&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
        AS="&#1605;&#1608;&#1602;&#1593; &#1578;&#1593;&#1605;&#1604; &#1576;&#1607; &#1605;&#1593;&#1583;&#1575;&#1578;";
        NAS="&#1605;&#1608;&#1602;&#1593; &#1604;&#1575; &#1578;&#1593;&#1605;&#1604; &#1576;&#1607; &#1605;&#1593;&#1583;&#1575;&#1578;";
        QS="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        BO="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        name="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
       // userListTitles[1]="&#1603;&#1604;&#1605;&#1577; &#1575;&#1604;&#1605;&#1585;&#1608;&#1585;";
//        userListTitles[1]="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
//        userListTitles[2]="&#1578;&#1581;&#1585;&#1610;&#1585;";
//        userListTitles[3]="&#1581;&#1584;&#1601;";
        CD=" &#1604;&#1575; &#1578;&#1587;&#1578;&#1591;&#1610;&#1593; &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        sUsersTotal="&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1587;&#1578;&#1582;&#1583;&#1605;&#1610;&#1606;";
        sUsersList="عرض أعضاء مجموعة البريد";

        //viewUserLabel = "&#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1575;&#1604;&#1571;&#1587;&#1575;&#1587;&#1610;&#1577;.";
        projectName="الإداره";
    }
    %>
    
    <body>
        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
        </DIV> 
        <fieldset align=center class="set">
            <legend align="center">
                
                <TABLE dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"><%=sUsersList%> 
                            </font>
                        </td>
                    </tr>
                </TABLE>
            </legend >
            <br>
            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>
                
            </TABLE>
            
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
               
                <TR >
                    <%
                    String columnColor = new String("");
                    String columnWidth = new String("100");
                    String font = new String("12");
                    for(int i = 0;i<t;i++) {
                        if(i == 0){
                            columnColor = "#9B9B00";
                        } else {
                            columnColor = "#7EBB00";
                        }
                    }
                    %>
                    
                    <TD nowrap CLASS="silver_header" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:<%=font%>;" nowrap>
                        <B><%=name%></B>
                    </TD>
                    
                    <TD nowrap CLASS="silver_header" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:<%=font%>;" nowrap>
                        <B><%=projectName%></B>
                    </TD>
                </TR>  
                <%
                
                Enumeration e = usersList.elements();
                
                
                while(e.hasMoreElements()) {
                    iTotal++;
                    wbo = (WebBusinessObject) e.nextElement();
                    flipper++;
                         if((flipper%2) == 1) {
                        bgColor="silver_odd";
                        bgColorm = "silver_odd_main";
                    } else {
                        bgColor= "silver_even";
                         bgColorm = "silver_even_main";
                    }
                %>
                
                <TR>
                    <%
                    //for(int i = 0;i<usersList.size();i++) {
                        attValue = (String) wbo.getAttribute("memberName");                        
                    %>
                    
                    <TD STYLE="<%=style%>" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                        <DIV >
                            
                            <b> <%=attValue%> </b>
                        </DIV>
                    </TD>
                    
                     <TD STYLE="<%=style%>" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                        <DIV >
                            
                            <b> <%=wbo.getAttribute("projectName").toString()%> </b>
                        </DIV>
                    </TD>
                    
                    <%
                   // }
                    %>
                    
                </TR>
                
                
                <%
                
                }
                
                %>
                <TR>
                    <TD CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="1" STYLE="<%=style%>;padding-right:5;border-right-width:1;font-size:16;">
                        <B><%=sUsersTotal%></B>
                    </TD>
                    <TD CLASS="silver_footer" BGCOLOR="#808080" STYLE="<%=style%>;padding-left:5;font-size:16;">
                        <B><%=iTotal%></B>
                    </TD>
                </TR>
            </TABLE>
            <BR><BR>
            
        </fieldset>
        
    </body>
</html>
