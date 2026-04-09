<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    String tradeId = (String) request.getAttribute("tradeId");
    String tradeName = (String) request.getAttribute("tradeName");
    
    ProjectMgr projectMgr=ProjectMgr.getInstance();
    TradeMgr tradeMgr = TradeMgr.getInstance();
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,tit,save,cancel,TT,SNA;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        tit="Delete Trade - Are you Sure ?";
        save="Delete";
        cancel="Back To List";
        TT="Task Title ";
        SNA="Trade Name";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        tit="&#1581;&#1584;&#1601; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583; &#1567;";
        save=" &#1573;&#1581;&#1584;&#1601;";
        cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        TT="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        SNA="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
    }
    
    
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <MEeTA HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - Confirm Deletion</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

   function submitForm()
   {    
      document.PROJECT_DEL_FORM.action = "<%=context%>/TradeServlet?op=Delete&tradeId=<%=tradeId%>&tradeName=<%=tradeName%>";
      document.PROJECT_DEL_FORM.submit();  
   }
function cancelForm()
        {    
        document.PROJECT_DEL_FORM.action = "<%=context%>/TradeServlet?op=ListTrades";
        document.PROJECT_DEL_FORM.submit();  
        }
        
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
    </SCRIPT>
    
    <BODY>
      
        
        
        <FORM NAME="PROJECT_DEL_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
                <button    onclick="submitForm()" class="button"><%=save%>    </button>
            </DIV> 
            <br><br>
            <fieldset align=center class="set">
                <legend align="center">
                    
                    <table dir=" <%=dir%>" align="<%=align%>">
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6"><%=tit%> 
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend >
                   <br><br>
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=SNA%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <input disabled type="TEXT" name="tradeName" value="<%=tradeName%>" ID="<%=tradeName%>" size="33"  maxlength="50">
                        </TD>
                    </TR>
                    
                    <input  type="HIDDEN" name="tradeId" value="<%=tradeId%>">
                    
                    
                    
                </TABLE>
                <br><br>
            </fieldset>
        </FORM>
        
    </BODY>
</HTML>     
