<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>

<HTML>


<%
String status = (String) request.getAttribute("Status");
WebBusinessObject unit = (WebBusinessObject) request.getAttribute("unit");
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");


String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String saving_status,Dupname;
String unit_name, unit_desc;
String title_1,title_2;
String cancel_button_label;
String save_button_label;
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    unit_desc="Descritption";
    unit_name="Unit name";
    title_1="Update unit";
    title_2="All information are needed";
    cancel_button_label="Cancel ";
    save_button_label="Save ";
    langCode="Ar";
    Dupname = "Name is Duplicated Chane it";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    unit_desc="&#1575;&#1604;&#1608;&#1589;&#1601; ";
    unit_name="&#1573;&#1587;&#1605; &#1608;&#1581;&#1583;&#1577; &#1575;&#1604;&#1602;&#1610;&#1575;&#1587;";
    title_1="&#1578;&#1581;&#1583;&#1610;&#1579; &#1608;&#1581;&#1583;&#1577; &#1575;&#1604;&#1602;&#1610;&#1575;&#1587;";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
    save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
    langCode="En";
     Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
   
}
    String doubleName = (String) request.getAttribute("name");
%>

<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Expires" CONTENT="0">

<HEAD>
    <TITLE>DebugTracker-add new function area</TITLE>
    <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
</HEAD>
<script src='silkworm_validate.js' type='text/javascript'></script>
<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {
            if (!validateData("req", this.PROJECT_FORM.unitName, "Please, enter Unit Name.") || !validateData("minlength=3", this.PROJECT_FORM.unitName, "Please, enter a valid Unit Name.")){
                    this.PROJECT_FORM.unitName.focus();
            } else if (!validateData("req", this.PROJECT_FORM.unitDesc, "Please, enter Unit Description.")){
                    this.PROJECT_FORM.unitDesc.focus();
            } else{
                document.PROJECT_FORM.action = "<%=context%>/ItemsServlet?op=UpdateUnit";
                document.PROJECT_FORM.submit();  
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
        document.PROJECT_FORM.action = "<%=context%>/ItemsServlet?op=ListUnits";
        document.PROJECT_FORM.submit();  
        }
</SCRIPT>
<script src='ChangeLang.js' type='text/javascript'></script>
<BODY>
    
    <FORM NAME="PROJECT_FORM" METHOD="POST">
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
        
        %>
        
        <table align="<%=align%>" dir=<%=dir%>>
            <tr>
                
                <td class="td">
                    <font size=4 color="red" ><%=saving_status%>:<%=status%></font> 
                </td>
                
        </tr> </table>
        <%
        
        }
        
        %>
        <center> <font size=4 color="red" ><b><%=title_2%></b></font> </center>
        <br>
        <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
            
            <TR>
                <TD STYLE="<%=style%>" class='td'>
                    <LABEL FOR="str_unitName">
                        <p><b><%=unit_name%> <font color="#FF0000">*</font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD  STYLE="<%=style%>"class='td'>
                    <input type="TEXT" name="unitName" ID="unitName" size="34" value="<%=unit.getAttribute("unitName").toString()%>" maxlength="255">
                </TD>
            </TR>
            
            <TR>
                <TD STYLE="<%=style%>"class='td'>
                    <LABEL FOR="str_Function_Desc">
                        <p><b><%=unit_desc%> <font color="#FF0000">*</font></b>&nbsp;
                    </LABEL>
                </TD>
                <TD STYLE="<%=style%>" class='td'>
                    <TEXTAREA rows="5" name="unitDesc" ID="unitDesc" cols="27"><%=unit.getAttribute("unitDesc").toString()%></TEXTAREA>
                </TD>
            </TR>
        </TABLE>
        <input type="hidden" name="unitID" id="unitID" value="<%=unit.getAttribute("unitID").toString()%>">
    </FORM>
    <br>
    </fieldset>
</BODY>
</HTML>     
