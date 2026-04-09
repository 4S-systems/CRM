<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Projects List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <%
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    TaskMgr taskMgr = TaskMgr.getInstance();
    
    String context = metaMgr.getContext();
    
    String[] taskAttributes = {"title"};
    String[] taksListTitles = new String[4];
    
    /***************** Next Links Data *********************/
    
    int noOfLinks=0;
    int count=0;
    String searchType=(String)request.getAttribute("searchType");
    String tempcount=(String)request.getAttribute("count");
    String taskName = (String)request.getAttribute("taskName");
    
    if(tempcount!=null)
        count=Integer.parseInt(tempcount);
    String tempLinks=(String)request.getAttribute("noOfLinks");
    if(tempLinks!=null)
        noOfLinks=Integer.parseInt(tempLinks);
    String fullUrl=(String)request.getAttribute("fullUrl");
    String url=(String)request.getAttribute("url");

    /********************** End *****************************/
    
    String total=(String)request.getAttribute("total");
    
    int s = taskAttributes.length;
    int t = s+3;
    int iTotal = 0;
    
    String attName = null;
    String attValue = null;
    String cellBgColor = null;
    
    Vector  taskList = (Vector) request.getAttribute("data");
    
    WebBusinessObject wbo = null;
    int flipper = 0;
    String bgColor = null;
    String bgColorm = null;
    
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
        AS="Active Task by job order";
        NAS="Non Active Task";
        QS="Quick Summary";
        BO="Basic Operations";
        taksListTitles[0]="Maintenance Item Code";
        taksListTitles[1]="View";
        taksListTitles[2]="Edit";
        taksListTitles[3]="Delete";
        CD="Can't Delete Task";
        PN="Maintenance Item No.";
        PL="Maintenance Items List";
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
        AS="&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
        NAS="&#1576;&#1606;&#1583; &#1589;&#1610;&#1575;&#1606;&#1577; &#1594;&#1610;&#1585; &#1606;&#1588;&#1591;";
        QS="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        BO="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        taksListTitles[0]="&#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        taksListTitles[1]="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
        taksListTitles[2]="&#1578;&#1581;&#1585;&#1610;&#1585;";
        taksListTitles[3]="&#1581;&#1584;&#1601;";
        CD="&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1581;&#1584;&#1601; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        PN=" &#1593;&#1583;&#1583; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        PL="&#1593;&#1585;&#1590; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    }
    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
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
        
            
     function getUnitTop(){
           var x =document.getElementById("selectIdTop").value;
           x = parseInt(x);
           var name =document.getElementById("taskName").value;
           var res = ""
           for (i=0;i < name.length; i++) {
                res += name.charCodeAt(i) + ',';
           }
           res = res.substr(0, res.length - 1);
           var tempurl="<%=context%>/<%=url%>&count=";
           var taskType='<%=searchType%>';
           
           if(taskType=="code")
                tempurl=tempurl+x+"&taskCode="+res+"&searchType=<%=searchType%>";
           else
                tempurl=tempurl+x+"&taskName="+res+"&searchType=<%=searchType%>";
           
           window.navigate(tempurl);

       }
       
       function getUnitDown(){
           var x =document.getElementById("selectIdDown").value;
           x = parseInt(x);
           var name =document.getElementById("taskName").value;
           var res = ""
           for (i=0;i < name.length; i++) {
                res += name.charCodeAt(i) + ',';
           }
           res = res.substr(0, res.length - 1);
           
           var tempurl="<%=context%>/<%=url%>&count=";
           var taskType='<%=searchType%>';
           
           if(taskType=="code")
                tempurl=tempurl+x+"&taskCode="+res+"&searchType=<%=searchType%>";
           else
                tempurl=tempurl+x+"&taskName="+res+"&searchType=<%=searchType%>";
           
           window.navigate(tempurl);
       }
        
    </script>
    <body>
        <form name="tasksBuSub_form">
           <%-- <table align="<%=align%>" border="0" width="100%">
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
            </table> --%>
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
                
                <center> <b> <font size="3" color="red"> <%=PN%> : <%=total%> </font></b></center> 
                <br>
                
                <%if(noOfLinks>0){%>
                <table align="center">
                    <tr>
                        <td class="td" >
                            <b><font size="2" color="red">page No:</font><font size="2" color="black"><%=count+1%></font><font size="2" color="red">from</font><font size="2" color="black"> <%=noOfLinks%></font></b>
                            <input type="hidden" name="taskName" id="taskName" value="<%=taskName%>">
                        </td>
                        <td class="td"  >
                            <select id="selectIdTop" onchange="javascript:getUnitTop();">
                                <%for(int i=0;i<noOfLinks;i++){%>
                                <option value="<%=i%>" <%if(i==count){%> selected <% } %> ><%=i+1%></option>
                                <% } %>
                            </select>
                        </td>
                    </tr>
                </table>
                <BR>
                <%}%>
                
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                    
                    <TR>
                        <TD CLASS="blueHeaderTD" COLSPAN="1" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:16">
                            <B><%=QS%></B>
                        </TD>
                        <TD CLASS="blueHeaderTD" COLSPAN="3" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:16">
                            <B><%=BO%></B>
                        </TD>
                      <%--  <TD CLASS="td" COLSPAN="1" bgcolor="#CC9900" STYLE="text-align:center;color:white;font-size:16">
                            <B><%=IG%> </b>
                        </TD> --%>
                    </TR>
                    
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
                            if(taksListTitles[i].equalsIgnoreCase("")){
                                columnWidth = "1";
                                columnColor = "black";
                                font = "1";
                            } else {
                                columnWidth = "100";
                                font = "12";
                            }
                        %>                
                        <TD nowrap CLASS="silver_header" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:<%=font%>;" nowrap>
                            <B><%=taksListTitles[i]%></B>
                        </TD>
                        <%
                        }
                        %>
                       <%-- <TD nowrap CLASS="firstname" BGCOLOR="#FFBF00" WIDTH="135" STYLE="border-WIDTH:0; font-size:12" COLSPAN="1" nowrap>
                            &nbsp;
                            </TD> --%>
                        
                    </TR>
                    <%
                    
                    Enumeration e = taskList.elements();
                    String categoryId="";
                    
                    while(e.hasMoreElements()) {
                        iTotal++;
                        categoryId="";
                        wbo = (WebBusinessObject) e.nextElement();
                        categoryId=wbo.getAttribute("parentUnit").toString();
                        flipper++;
                     if((flipper%2) == 1) {
                        bgColor="silver_odd";
                        bgColorm = "silver_odd_main";
                    } else {
                        bgColor= "silver_even";
                         bgColorm = "silver_even_main";
                    }
                    %>
                    
                    <TR bgcolor="<%=bgColor%>">
                        <%
                        for(int i = 0;i<s;i++) {
                            attName =taskAttributes[i];
                            attValue = (String) wbo.getAttribute(attName);
                        %>
                        
                        <TD  STYLE="<%=style%>" BGCOLOR="#DDDD00" nowrap  CLASS="<%=bgColorm%>" >
                            <DIV >
                                
                                <b> <%=attValue%> </b>
                            </DIV>
                        </TD>
                        <%
                        }
                        %>
                        
                        <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="<%=style%>">
                            <DIV ID="links">
                                <%if(categoryId.equalsIgnoreCase("no")||categoryId.equalsIgnoreCase("")){%>
                                <A HREF="<%=context%>/TaskServlet?op=viewTaskMain&taskId=<%=wbo.getAttribute("id")%>">
                                    <%=taksListTitles[1]%>
                                </A>
                                <%}else{%>
                                <A HREF="<%=context%>/TaskServlet?op=view&taskId=<%=wbo.getAttribute("id")%>">
                                    <%=taksListTitles[1]%>
                                </A>
                                <%}%>
                            </DIV>
                        </TD>
                        
                        <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="<%=style%>">
                            <DIV ID="links">
                                <%if(categoryId.equalsIgnoreCase("no")||categoryId.equalsIgnoreCase("")){%>
                                <A HREF="<%=context%>/TaskServlet?op=GetTaskMainUpdate&taskId=<%=wbo.getAttribute("id")%>">
                                    <%=taksListTitles[2]%>
                                </A>
                                <%}else{%>
                                <A HREF="<%=context%>/TaskServlet?op=GetTaskUpdate&taskId=<%=wbo.getAttribute("id")%>">
                                    <%=taksListTitles[2]%>
                                </A>
                                <%}%>
                            </DIV>
                        </TD>
                        
                        <%
                       // if(taskMgr.getActiveTask(wbo.getAttribute("id").toString())) {
                        
                        %>
                        <!--
                        <TD nowrap CLASS="cell"  BGCOLOR="#D7FF82" STYLE="<%=style%>">
                            <DIV ID="links">
                                <%=CD%>
                                
                            </DIV>
                        </td> -->
                        <%
                        //} else {
                        %> 
                        <TD nowrap CLASS="<%=bgColor%>"  BGCOLOR="#D7FF82" STYLE="<%=style%>">
                            
                            <DIV ID="links">
                                <% if(securityUser.verifyDelete()) { %>
                                ---<!--A HREF="<%=context%>/TaskServlet?op=confdel&taskId=<%=wbo.getAttribute("id")%>&taskTitle=<%=wbo.getAttribute("title")%>">
                                    <%//=taksListTitles[3]%>
                                </A-->
                                <%}else {%>
                                -----
                                <%}%>
                            </DIV>
                        </TD>
                       
                        <% } %>
                        
                    </TR>
                    
                    <TR >
                        <TD class="silver_footer" COLSPAN="3" STYLE="<%=style%>;padding-right:5;border-right-width:1;font-size:16;">
                            <B><%=PN%></B>
                        </TD>
                        <TD class="silver_footer"  colspan="1" STYLE="<%=style%>;padding-left:5;font-size:16;">
                            
                            <DIV NAME="" ID="">
                                <B><%=iTotal%></B>
                            </DIV>
                        </TD>
                    </TR>
                </TABLE>
                <br>
                <table align="center">
                    
                    <input type="hidden" name="url" value="<%=url%>" id="url" >
                    <input type="hidden" name="taskName" id="taskName" value="<%=taskName%>">
                    <%if(noOfLinks>0){%>
                    <tr >
                        <td >
                            <b><font size="2" color="red">page No:</font><font size="2" color="black"><%=count+1%></font><font size="2" color="red">from</font><font size="2" color="black"> <%=noOfLinks%></font></b>
                        </td>
                        <td >
                            <select id="selectIdDown" onchange="javascript:getUnitDown();">
                                <%for(int i=0;i<noOfLinks;i++){%>
                                <option value="<%=i%>" <%if(i==count){%> selected <% } %> ><%=i+1%></option>
                                <% } %>
                            </select>
                        </td>
                    </tr>
                    <%}%>
                </table>
            </fieldset>
        </form>
    </body>
</html>
