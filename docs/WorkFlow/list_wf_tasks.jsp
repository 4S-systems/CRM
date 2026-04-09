<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Projects List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="css/headers.css">
    </HEAD>
    <%
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    
    String context = metaMgr.getContext();
    
    int iTotal = 0;
    
    Vector  wfTaskList = (Vector) request.getAttribute("data");
    
    String status = (String) request.getAttribute("status");
    
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
    String name,sStatus,fStatus;
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
        AS="Active Task by job order";
        NAS="Non Active Task";
        QS="Quick Summary";
        BO="Basic Operations";
        CD="Can't Delete Task";
        PN="Work Flow Tasks Number";
        PL="Work Flow Tasks List";
        name=" Task Name ";
        
        sStatus="Task Deleted Successfully";
        fStatus="Fail To Delete Task";
        
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        tit=" &#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1607;&#1575;&#1605;";
        save=" &#1573;&#1581;&#1584;&#1601;";
        cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        TT="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        IG="&#1575;&#1604;&#1605;&#1585;&#1588;&#1583; &#1575;&#1604;&#1605;&#1589;&#1608;&#1585;";
        AS="&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
        NAS="&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1594;&#1610;&#1585; &#1606;&#1588;&#1591;";
        QS="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        BO="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        CD="&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1581;&#1584;&#1601; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        PN=" &#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1607;&#1575;&#1605; ";
        PL="&#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1607;&#1575;&#1605;";
        name=" &#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; ";
        
        sStatus="&#1578;&#1605; &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607; &#1576;&#1606;&#1580;&#1575;&#1581;";
        fStatus="&#1604;&#1605; &#1610;&#1578;&#1605; &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        
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
        
        function deleteWFTask(id,title){
        
            var result=confirm("Are You sure that you need to delete task --> "+title);
            if(result==true){
                var url="<%=context%>/WFTaskServlet?op=deleteWFTask&wfTaskId="+id;
                window.navigate(url);
            }else{
                return;
            }
        
        }
        
    </script>
    <body>
        
        <%--
        <table align="<%=align%>" border="0" width="100%">
            <tr>
                <td STYLE="border:0px;">
                    <div STYLE="width:75%;border:2px solid gray;background-color:#808000;color:white;" bgcolor="#F3F3F3" align="center">
                        <div ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#808000;color:white;cursor:hand;font-size:16;">
                            <b>
                                <%=IG%>  
                            </b>
                            <img src="images/arrow_down.gif">
                        </div>
                        <div ALIGN="center" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;<%=style%>;border-top:2px solid gray;" ID="menu1">
                            <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                                <tr>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="50%"><IMG SRC="images/active.jpg" ALT="<%=AS%>" ALIGN="<%=align%>"> <b><%=AS%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="50%"><IMG SRC="images/nonactive.jpg" ALT="<%=NAS%>" ALIGN="<%=align%>"> <b><%=NAS%></b></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
        --%>
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
            
            <center> <b> <font size="3" color="red"> <%=PN%> : <%=wfTaskList.size()%> </font></b></center> 
            <br>
            
            
            <%    if(null!=status) {%>
            <table dir="<%=dir%>" align="<%=align%>"> 
                <%if(status.equalsIgnoreCase("ok")){
                %>  
                <tr>
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>                    
                            <td class="td">
                                <font size=4 color="black"><%=sStatus%></font> 
                            </td>                    
                    </tr> </table>
                </tr>
                <%
                }else{%>
                <tr>
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>                    
                            <td class="td">
                                <font size=4 color="red" ><%=fStatus%></font> 
                            </td>                    
                    </tr> </table>
                </tr>
                
                <%}%>
            </table>   
            <br>
            <%}
            %>
            
            
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                
                <TR>
                    <TD CLASS="header" COLSPAN="2" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:18">
                        <B><%=QS%></B>
                    </TD>
                    <TD CLASS="header" COLSPAN="3" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:18">
                        <B><%=BO%></B>
                    </TD>
                </tr>
                
                <TR CLASS="head">
                    
                    <TD nowrap HEIGHT="25" CLASS="bar" STYLE="border-WIDTH:0;" nowrap>
                        <font color="black" size="3">    
                            <B>#</B>
                        </FONT>
                    </TD> 
                    <TD HEIGHT="25" CLASS="bar" STYLE="border-WIDTH:0;" nowrap>
                        <font color="black" size="3">  
                            <B><%=name%></B>
                        </FONT>
                    </TD> 
                    <TD COLSPAN="3" nowrap CLASS="bar" STYLE="border-WIDTH:0; font-size:12;color:white;" nowrap>
                        &nbsp;
                        </TD> 
                </TR>
                <%
                
                Enumeration e = wfTaskList.elements();
                String classStyle="tRow2";
                while(e.hasMoreElements()) {
                    iTotal++;
                    wbo = (WebBusinessObject) e.nextElement();
                    flipper++;
                    if((flipper%2) == 1) {
                        classStyle="tRow2";
                    } else {
                        classStyle="tRow";
                    }
                %>
                
                <TR bgcolor="<%=bgColor%>">
                    
                    <TD HEIGHT="30" STYLE="<%=style%>" BGCOLOR="#DDDD00" nowrap  CLASS="<%=classStyle%>" >
                        <%=iTotal%>
                    </TD>
                    
                    <TD HEIGHT="30" STYLE="<%=style%>" BGCOLOR="#DDDD00" nowrap  CLASS="<%=classStyle%>" >
                        <b> <%=(String) wbo.getAttribute("title")%> </b>
                    </TD>
                    
                    <TD nowrap HEIGHT="30" CLASS="<%=classStyle%>"  BGCOLOR="#D7FF82" STYLE="<%=style%>">
                        <A HREF="<%=context%>/WFTaskServlet?op=viewWFTask&wfTaskId=<%=wbo.getAttribute("id")%>">
                            View
                        </A>
                        
                    </TD>
                    
                    <TD nowrap HEIGHT="30" CLASS="<%=classStyle%>"  BGCOLOR="#D7FF82" STYLE="<%=style%>">
                        
                        <A HREF="<%=context%>/WFTaskServlet?op=GetWFTaskUpdate&wfTaskId=<%=wbo.getAttribute("id")%>">
                            update
                        </A>
                        
                    </TD>
                    
                    <TD nowrap HEIGHT="30" CLASS="<%=classStyle%>"  BGCOLOR="#D7FF82" STYLE="<%=style%>">
                        <A HREF="javascript:deleteWFTask('<%=wbo.getAttribute("id").toString()%>','<%=wbo.getAttribute("title").toString()%>')">
                            delete
                        </A>
                    </TD>
                    
                </TR>
                
                <%}%>
                
                <TR>
                    <TD CLASS="bar" HEIGHT="30" COLSPAN="4" STYLE="<%=style%>;padding-right:5;border-right-width:1;">
                        <font color="black" size="3">
                            <B><%=PN%></B>
                        </FONT>
                    </TD>
                    <TD CLASS="bar" HEIGHT="30" colspan="1" STYLE="<%=style%>;padding-left:5;">
                        <font color="black" size="3">
                        <B><%=iTotal%></B></FONT>
                    </TD>
                </TR>
            </table>
            <br>
        </fieldset>
    </body>
</html>
