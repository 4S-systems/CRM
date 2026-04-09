<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*,com.maintenance.db_access.TradeMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Projects List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    <%
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    //AppConstants appCons = new AppConstants();
    
    String[] tradeAttributes = {"tradeName"};
    String[] tradeListTitles =new String[4];
    
    int s = tradeAttributes.length;
    int t = s+3;
    int iTotal = 0;
    
    String attName = null;
    String attValue = null;
    String cellBgColor = null;
    
    
    
    Vector  tradesList = (Vector) request.getAttribute("data");
    
    
    WebBusinessObject wbo = null;
    int flipper = 0;
    String bgColor = null;
     String bgColorm = null;
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    TradeMgr tradeMgr=TradeMgr.getInstance();
    
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
        AS="Active Trade by User";
        NAS="Non Active Trade";
        QS="Quick Summary";
        BO="Basic Operations";
        tradeListTitles[0]="Trade Name";
        tradeListTitles[1]="View";
        tradeListTitles[2]="Edit";
        tradeListTitles[3]="Delete";
        CD="Can't Delete Trade";
        PN="Trades No.";
        PL="Trades List";
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
        AS="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1605;&#1601;&#1593;&#1604;&#1577; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577; &#1605;&#1587;&#1578;&#1582;&#1583;&#1605;";
        NAS="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1594;&#1610;&#1585; &#1605;&#1601;&#1593;&#1604;&#1577;";
        QS="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        BO="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        tradeListTitles[0]="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
        tradeListTitles[1]="&#1605;&#1588;&#1575;&#1607;&#1583;&#1607;";
        tradeListTitles[2]="&#1578;&#1581;&#1585;&#1610;&#1585;";
        tradeListTitles[3]="&#1581;&#1584;&#1601;";
        CD="&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
        PN="&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1575;&#1578;";
        PL="&#1593;&#1585;&#1590; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1575;&#1578; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577; &#1608;&#1575;&#1604;&#1573;&#1583;&#1575;&#1585;&#1610;&#1577;";
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
        
        
        <table align="<%=align%>" border="0" width="100%">
            <tr>
                <td STYLE="border:0px;">
                    <div STYLE="width:75%;border:2px solid gray;background-color:#90a5b6;color:white;" bgcolor="#F3F3F3" align="center">
                        <div ONCLICK="JavaScript: changeMode('menu1');" STYLE="width:100%;background-color:#90a5b6;color:white;cursor:hand;font-size:16;">
                            <b>
                                <%=IG%>  
                            </b>
                            <img src="images/arrow_down.gif">
                        </div>
                        <div ALIGN="center" STYLE="width:100%;background-color:#FFFFCC;color:white;display:none;<%=style%>;border-top:2px solid gray;" ID="menu1">
                            <table align="<%=align%>" border="0" dir="<%=dir%>" width="100%" cellspacing="2">
                                <tr>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="50%"><IMG SRC="images/active.jpg" ALT="Active Site by Equipment" ALIGN="<%=align%>"> <b><%=AS%></b></td>
                                    <td CLASS="indicator" bgcolor="white" STYLE="<%=style%>" width="50%"><IMG SRC="images/nonactive.jpg" ALT="Non Active Site" ALIGN="<%=align%>"> <b><%=NAS%></b></td>
                                </tr>
                            </table>
                        </div>
                    </div>
                </td>
            </tr>
        </table>
        
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
            
            <center> <b> <font size="3" color="red"> <%=PN%> : <%=tradesList.size()%> </font></b></center> 
            <br>
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="400" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                
                <TR>
                    <TD CLASS="blueBorder blueHeaderTD" COLSPAN="1" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:18">
                        <B><%=QS%></B>
                    </TD>
                    <TD CLASS="blueBorder blueHeaderTD" COLSPAN="3" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:18">
                        <B><%=BO%></B>
                    </TD>
                    <TD CLASS="blueBorder blueHeaderTD" COLSPAN="1" bgcolor="#CC9900" STYLE="text-align:center;color:white;font-size:18">
                        <B><%=IG%> </b>
                    </TD>
                </tr>
                
                <TR >
                 
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
                        if(tradeListTitles[i].equalsIgnoreCase("")){
                            columnWidth = "1";
                            columnColor = "black";
                            font = "1";
                        } else {
                            columnWidth = "100";
                            font = "12";
                        }
                    %>                
                    <TD nowrap CLASS="silver_header" WIDTH="<%=columnWidth%>" bgcolor="<%=columnColor%>" STYLE="border-WIDTH:0; font-size:<%=font%>;" nowrap>
                        <B><%=tradeListTitles[i]%></B>
                    </TD>
                    <%
                    }
                    %>
                    <TD nowrap CLASS="silver_header" BGCOLOR="#FFBF00" WIDTH="135" STYLE="border-WIDTH:0; font-size:12" COLSPAN="3" nowrap>
                        &nbsp;
                        </TD>
                </TR>
                
                <%
                
                Enumeration e = tradesList.elements();
                
                
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
                
                <TR >
                    <%
                    for(int i = 0;i<s;i++) {
                        attName = tradeAttributes[i];
                        attValue = (String) wbo.getAttribute(attName);
                    %>
                    
                    <TD  nowrap STYLE="<%=style%>"  BGCOLOR="#DDDD00" CLASS="<%=bgColorm%>" >
                        <DIV >
                            
                            <b> <%=attValue%> </b>
                        </DIV>
                    </TD>
                    <%
                    }
                    %>
                    
                    <TD nowrap CLASS="<%=bgColor%>" STYLE="padding-left:10;<%=style%>" BGCOLOR="#D7FF82">
                        <DIV ID="links">
                            <A HREF="<%=context%>/TradeServlet?op=ViewTrade&tradeId=<%=wbo.getAttribute("tradeId")%>">
                                
                                <%= tradeListTitles[1]%>
                            </A>
                        </DIV>
                    </TD>
                    
                    <TD nowrap CLASS="<%=bgColor%>" STYLE="padding-left:10;<%=style%>;" BGCOLOR="#D7FF82" >
                        <DIV ID="links">
                            <A HREF="<%=context%>/TradeServlet?op=GetUpdateForm&tradeId=<%=wbo.getAttribute("tradeId")%>">
                                <%= tradeListTitles[2]%>
                            </A>
                        </DIV>
                    </TD>
                    <%
                    if(tradeMgr.getActiveTrade(wbo.getAttribute("tradeId").toString())) {
                    %>
                    <TD nowrap CLASS="<%=bgColor%>" STYLE="padding-left:10;<%=style%>" BGCOLOR="#D7FF82" >
                        <DIV ID="links">
                            
                            <%=CD%>  
                            
                        </DIV>
                    </TD>
                    
                    <%
                    } else {
                    %> 
                    <TD nowrap CLASS="<%=bgColor%>" STYLE="padding-left:10;<%=style%>" BGCOLOR="#D7FF82" >
                        <DIV ID="links">
                            <A HREF="<%=context%>/TradeServlet?op=ConfirmDelete&tradeId=<%=wbo.getAttribute("tradeId")%>&tradeName=<%=wbo.getAttribute("tradeName")%>">
                                <%= tradeListTitles[3]%>
                            </A>
                        </DIV>
                    </TD>
                    
                    <% } %>
                    
                    <TD WIDTH="20px" nowrap CLASS="<%=bgColor%>" BGCOLOR="#FFE391">
                        <%
                        if(tradeMgr.getActiveTrade(wbo.getAttribute("tradeId").toString())) {
                        %>
                        <IMG SRC="images/active.jpg"  ALT="Active Site by Equipment"> 
                        
                        
                        <%
                        } else {
                        %> 
                        
                        <IMG SRC="images/nonactive.jpg"  ALT="Non Active Site">
                        <% } %>
                    </TD>               
                    
                    
                    
                </TR>
                
                
                <%
                
                }
                
                %>
                <TR>
                    <TD CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="4" STYLE="<%=style%>;padding-right:5;border-right-width:1;font-size:16;">
                        <b><%=PN%></b>
                    </TD>  
                    <TD CLASS="silver_footer" BGCOLOR="#808080" COLSPAN="1" STYLE="<%=style%>;padding-left:5;font-size:16;">
                        
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
