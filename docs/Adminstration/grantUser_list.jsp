

<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Departments List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    <%
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    //AppConstants appCons = new AppConstants();
    
    String[] departmentAttributes = {"grantName"};
    String[] departmentListTitles = new String[4];
    
    int s = departmentAttributes.length;
    int t = s+3;
    int iTotal = 0;
    
    String attName = null;
    String attValue = null;
    String cellBgColor = null;
    
    
    
    Vector  grantsList = (Vector) request.getAttribute("data");
    
    
    WebBusinessObject wbo = null;
    int flipper = 0;
    String bgColor = null;
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,tit,save,cancel,TT,IG,AS,QS,BO,CD,PN,NAS,PL;
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
        departmentListTitles[0]="Grant Name";
        departmentListTitles[1]="View";
        departmentListTitles[2]="Edit";
        departmentListTitles[3]="Delete";
        CD="Can't Delete Site";
        PN="Grants  No.";
        PL="Grants List";
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
        departmentListTitles[0]="&#1575;&#1587;&#1605; &#1575;&#1604;&#1589;&#1604;&#1575;&#1581;&#1610;&#1577;";
        departmentListTitles[1]="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
        departmentListTitles[2]="&#1578;&#1581;&#1585;&#1610;&#1585;";
        departmentListTitles[3]="&#1581;&#1584;&#1601;";
        CD=" &#1604;&#1575; &#1578;&#1587;&#1578;&#1591;&#1610;&#1593; &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        PN=" &#1593;&#1583;&#1583; &#1575;&#1604;&#1589;&#1604;&#1575;&#1581;&#1610;&#1575;&#1578;";
        PL="&#1593;&#1585;&#1590; &#1575;&#1604;&#1589;&#1604;&#1575;&#1581;&#1610;&#1575;&#1578;";
    }
    %>
    <script language="javascript" type="text/javascript">
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
       
           function changeMode(name){
            if(document.getElementById(name).style.display == 'none'){
                document.getElementById(name).style.display = 'block';
            } else {
                document.getElementById(name).style.display = 'none';
            }
        }
    </script>
    <body>
        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
        </DIV> 
        
        <fieldset align=center class="set">
            <legend align="center">
                
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"><%=PL%> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
            <br>
            
            <center> <b> <font size="3" color="red"> <%=PN%> : <%=grantsList.size()%> </font></b></center>
            <br>   
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                
                <TR>
                    <TD CLASS="td" COLSPAN="1" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
                        <B><%=QS%></B>
                    </TD>
                    <TD CLASS="td" COLSPAN="3" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:16">
                        <B><%=BO%></B>
                    </TD>
                  
                </tr>
                
                <TR CLASS="head">
                    
                    <%
                    String columnColor = new String("");
                    String columnWidth = new String("");
                    String font = new String("");
                    for(int i = 0;i<t;i++) {
                        if(i == 0 ){
                            columnColor = "#9B9B00";
                        } else {
                            columnColor = "#7EBB00";
                        }
                        if(departmentListTitles[i].equalsIgnoreCase("")){
                            columnWidth = "1";
                            columnColor = "black";
                            font = "1";
                        } else {
                            columnWidth = "100";
                            font = "12";
                        }
                    %>                
                    <TD nowrap CLASS="firstname" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:<%=font%>;color:white;" nowrap>
                        <B><%=departmentListTitles[i]%></B>
                    </TD>
                    <%
                    }
                    %>
                   
                </TR>  
                <%
                
                Enumeration e = grantsList.elements();
                
                
                while(e.hasMoreElements()) {
                    iTotal++;
                    wbo = (WebBusinessObject) e.nextElement();
                    
                    flipper++;
                    if((flipper%2) == 1) {
                        bgColor="#c8d8f8";
                    } else {
                        bgColor="white";
                    }
                %>
                
                <TR bgcolor="<%=bgColor%>">
                    <%
                    for(int i = 0;i<s;i++) {
                        attName = departmentAttributes[i];
                        attValue = (String) wbo.getAttribute(attName);
                    %>
                    
                    <TD  STYLE="<%=style%>"  nowrap  BGCOLOR="#DDDD00"  CLASS="cell" >
                        <DIV >
                            
                            <b> <%=attValue%> </b>
                        </DIV>
                    </TD>
                    <%
                    }
                    %>
                    
                    <TD nowrap CLASS="cell" BGCOLOR="#D7FF82" STYLE="padding-left:10;<%=style%>">
                        <DIV ID="links">
                            <A HREF="<%=context%>/GrantsServlet?op=ViewGrant&grant_id=<%=wbo.getAttribute("id")%>">
                                <%=departmentListTitles[1]%>
                            </A>
                        </DIV>
                    </TD>
                    
                    <TD nowrap CLASS="cell" BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>">
                        <DIV ID="links">
                            <A HREF="<%=context%>/GrantsServlet?op=GetUpdateForm&grant_id=<%=wbo.getAttribute("id")%>">
                                <%=departmentListTitles[2]%>
                            </A>
                        </DIV>
                    </TD>
                    <TD nowrap CLASS="cell" BGCOLOR="#D7FF82" STYLE="padding-right:10;<%=style%>">
                        <DIV ID="links">
                            <A HREF="<%=context%>/GrantsServlet?op=ConfirmDelete&grant_id=<%=wbo.getAttribute("id")%>&grant_name=<%=wbo.getAttribute("grantName")%>">
                                <%=departmentListTitles[3]%>
                            </A>
                        </DIV>
                    </TD>
                    
                    
                </TR>
                
                
                <%
                
                }
                
                %>
                <TR>
                    <TD CLASS="cell" BGCOLOR="#808080" COLSPAN="3" STYLE="<%=style%>;padding-right:5;border-right-width:1;color:white;font-size:14;">
                        <b><%=PN%></b>
                    </TD>
                    <TD CLASS="cell" BGCOLOR="#808080" colspan="1" STYLE="<%=style%>;padding-left:5;;color:white;font-size:14;">
                        
                        <DIV NAME="" ID="">
                            <b><%=iTotal%></b>
                        </DIV>
                    </TD>
                </TR>
            </table>
            <br><br>    
        </fieldset>
        
        
        
    </body>
</html>
