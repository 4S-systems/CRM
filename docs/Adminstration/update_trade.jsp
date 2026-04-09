<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>

<%


MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

String status = (String) request.getAttribute("Status");
System.out.print("***********************s"+status);

WebBusinessObject tradeWbo = (WebBusinessObject) request.getAttribute("tradeWbo");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

String OldTradeName=null;
OldTradeName= (String) tradeWbo.getAttribute("tradeName");

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,tit,save,cancel,TT,SNA,SNO,DESC,STAT,Dupname,fStatus,sStatus;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    tit="Update Trade";
    save="Save";
    cancel="Back To List";
    TT="Task Title ";
    SNA="Trade Name";
    SNO="Trade No.";
    DESC="Description";
    STAT="Update Status";
    Dupname = "Name is Duplicated Chane it";
    sStatus="Group Data Updated Successfully";
    fStatus="Fail To update Group";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    tit=" &#1578;&#1593;&#1583;&#1610;&#1604; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
    save="&#1578;&#1587;&#1580;&#1610;&#1604; ";
    cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    TT="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
    SNA="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
    SNO="&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
    DESC="&#1575;&#1604;&#1608;&#1589;&#1601;";
    STAT=" &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
    fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
    sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
}

String doubleName = (String) request.getAttribute("name");

%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new project</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {
            if (!validateData("req", this.PROJECTS_FORM.tradeName, "Please, enter Trade Name.") || !validateData("minlength=3", this.PROJECTS_FORM.tradeName, "Please, enter a valid Trade Name.")){
                this.PROJECTS_FORM.tradeName.focus();
            } else if (!validateData("req", this.PROJECTS_FORM.tradeNO, "Please, enter Trade Number.") || !validateData("alphanumeric", this.PROJECTS_FORM.tradeNO, "Please, enter a valid Number for Trade Number.")){
                this.PROJECTS_FORM.tradeNO.focus();
            } else{
                document.PROJECTS_FORM.action = "<%=context%>/TradeServlet?op=UpdateTrade&OldTradeName=<%=OldTradeName%>";
                document.PROJECTS_FORM.submit();  
            }
        }
        
           function IsNumeric(sText)
    {
        var ValidChars = "0123456789.";
        var IsNumber=true;
        var Char;

 
        for (i = 0; i < sText.length && IsNumber == true; i++) 
        { 
            Char = sText.charAt(i); 
            if (ValidChars.indexOf(Char) == -1) 
            {
                IsNumber = false;
            }
        }
        return IsNumber;

    }
    
    function clearValue(no){
        document.getElementById('Quantity' + no).value = '0';
        total();
    }
    
     function cancelForm()
        {    
        document.PROJECTS_FORM.action = "<%=context%>/TradeServlet?op=ListTrades";
        document.PROJECTS_FORM.submit();  
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
        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
            <button    onclick="submitForm()" class="button"><%=save%>    <IMG SRC="images/save.gif"></button>
        </DIV> 
        <br>
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
            <FORM NAME="PROJECTS_FORM" METHOD="POST">
                <%
                if(null!=doubleName) {
                
                %>
                
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        <td class="td">
                            <font size=4 > <%=Dupname%> </font> 
                        </td>
                        
                </tr> </table>
                <%
                
                }
                
                %>    
                <%
                if(null!=status) {
    if(status.equalsIgnoreCase("ok")){
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
                <%}
                }
                
                %>
                <br>
                <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=SNA%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input  type="TEXT" name="tradeName" ID="tradeName" size="33" value="<%=tradeWbo.getAttribute("tradeName")%>" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=SNO%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="TEXT" STYLE="width:230px" name="tradeNO" ID="tradeNO" size="33" value="<%=tradeWbo.getAttribute("tradeCode")%>" maxlength="255">
                        </TD>
                    </TR>
                    
                    
                </TABLE>
                <input type="hidden" name="tradeId" ID="tradeId" value="<%=tradeWbo.getAttribute("tradeId")%>">
            </FORM>
            <br>
        </fieldset>
    </BODY>
</HTML>     
