<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <%
    
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    TouristGuide tGuide = new TouristGuide("/com/silkworm/international/Messages");
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, view, sOk, sMessage;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        view="Security Violation";
        sMessage = "Your login credentials don't permit you to use this option";
        sOk = "Ok";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        view = "&#1575;&#1606;&#1578;&#1607;&#1575;&#1603; &#1571;&#1605;&#1606;&#1610;";
        lang="English";
        langCode="En";
        sOk = "&#1605;&#1608;&#1575;&#1601;&#1602;";
        sMessage = "&#1589;&#1604;&#1575;&#1581;&#1610;&#1575;&#1578;&#1603; &#1604;&#1575; &#1578;&#1587;&#1605;&#1581; &#1604;&#1603; &#1576;&#1573;&#1587;&#1578;&#1582;&#1583;&#1575;&#1605; &#1607;&#1584;&#1607; &#1575;&#1604;&#1582;&#1575;&#1589;&#1610;&#1577;";
    }
    %>
    <head>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function cancelForm()
        {    
            window.location = "<%=context%>/main.jsp";
        }
        </SCRIPT>
        <script src='ChangeLang.js' type='text/javascript'></script>
    </head>
    <body> 
        <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>"
                   onclick="reloadAE('<%=langCode%>')" class="button">
            <button  onclick="JavaScript: cancelForm();" class="button"> <%=sOk%> <IMG VALIGN="BOTTOM"   SRC="images/leftarrow.gif"> </button>
        </DIV> 
        <fieldset align="center" class="set" >
            <legend align="center">
                <table dir="rtl" align="center">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"> <%=view%>  
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            <div style="text-align:center;" dir="<%=dir%>">
                <IMG SRC="images/other.gif">  &nbsp; &nbsp;
                <b>  <%=sMessage%>  </B>
                <br>&nbsp;
            </div>
        </fieldset>
    </body>
</html>
