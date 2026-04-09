<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    
    
    <%
    
    String status = (String) request.getAttribute("Status");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    TradeMgr tradeMgr = TradeMgr.getInstance();
    String context = metaMgr.getContext();
    
    ArrayList gruopFcodeList = tradeMgr.getCashedTableAsBusObjects();
    
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String failure_title, failre_desc,Dupname,goupFCode;
    String title_1,title_2;
    String cancel_button_label;
    String save_button_label;
    String fStatus;
    String sStatus;
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        failure_title="Title";
        failre_desc="Description";
        title_1="New code failure";
        title_2="All information are needed";
        cancel_button_label="Cancel ";
        save_button_label="Save ";
        langCode="Ar";
        Dupname = "Name is Duplicated Chane it";
        goupFCode="Group of Failure code";
        sStatus="Faliure Code Saved Successfully";
        fStatus="Fail To Save This Faliure Code";
        
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        failure_title="&#1575;&#1604;&#1593;&#1606;&#1608;&#1575;&#1606;";
        failre_desc="&#1575;&#1604;&#1608;&#1589;&#1601; ";
        
        title_1="&#1603;&#1608;&#1583; &#1593;&#1591;&#1604; &#1580;&#1583;&#1610;&#1583;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
        langCode="En";
        Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
        goupFCode="&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1603;&#1608;&#1583; &#1575;&#1604;&#1593;&#1591;&#1604;";
        fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
        sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
    }
    String doubleName = (String) request.getAttribute("name");
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new Failure Code</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
        <style type="text/css">
             #toolsData{
                border: 3px ridge #777788 ;
                background:#E8E8E8;
                -moz-border-radius: 15px;
                -webkit-border-radius: 15px;
                border-radius: 20px;
          
           }
        </style>
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        { 
            if (!validateData("req", this.ITEM_FORM.title, "Please, enter Title Failure.") || !validateData("minlength=3", this.ITEM_FORM.title, "Please, enter a valid Title Failure.")){
                this.ITEM_FORM.title.focus();
            } else if (!validateData("req", this.ITEM_FORM.description, "Please, enter Failure description.")){
                this.ITEM_FORM.description.focus(); 
            } else {
                document.ITEM_FORM.action = "<%=context%>/FailureCodeServlet?op=SaveFailure";
                document.ITEM_FORM.submit();  
            }
        }
        
       function checkEmail(email) {
        if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){
            return (true)
        }
            return (false)
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
        document.ITEM_FORM.action = "main.jsp";
        document.ITEM_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="ITEM_FORM" METHOD="POST">
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV> 
            <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="center">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">    <%=title_1%>                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
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
            
            
            
            <table align="<%=align%>" dir=<%=dir%>>
                <TR COLSPAN="2" ALIGN="<%=align%>">
                    <TD STYLE="<%=style%>" class='td'>
                        <FONT color='red' size='+1'><%=title_2%></FONT> 
                    </TD>
                    
                </TR>
            </table>
            <br><br>
            
            <TABLE id="toolsData" align="<%=align%>" dir='<%=dir%>' CELLPADDING="0" CELLSPACING="6" BORDER="0">
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="assign_to">
                            <p><b><font color="#003399"><%=goupFCode%></font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'  WIDTH="33">
                        <SELECT name="tradeName" id="tradeName" style="width:230px">
                            <sw:WBOOptionList wboList='<%=gruopFcodeList%>' displayAttribute = "tradeName" valueAttribute="tradeId"/>
                        </SELECT>
                        
                    </TD>
                </TR>
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b><%=failure_title%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"class='td'>
                        <input type="TEXT" style="width:230px" name="title" ID="title" size="33" value="" maxlength="255">
                    </TD>
                </TR>
                
                
                
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b> <%=failre_desc%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"  class='td'>
                        <TEXTAREA style="width:230px" name="description" ID="description" ROWS="5"></textarea>
                    </TD>
                    
                </TR>
                
                
                
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
