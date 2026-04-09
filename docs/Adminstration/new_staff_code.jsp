<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    
    
    <%
    
    String status = (String) request.getAttribute("Status");
    CrewMissionMgr crewMissionMgr = CrewMissionMgr.getInstance();
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    
    
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    ArrayList arrayCrewList = new ArrayList();
    crewMissionMgr.cashData();
    arrayCrewList = crewMissionMgr.getCashedTableAsBusObjects();
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status,Dupname;
    String crew_name, crew_code,  crew_description;
    String title_1,title_2;
    String cancel_button_label;
    String save_button_label, sNoTeam;
    String fStatus;
    String sStatus;
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        
        crew_name="Staff name";
        crew_code="Staff code";
        // crew_typcalDuration="Typical duration";
        crew_description="Staff description";
        
        title_1="New Staff Code";
        title_2="All information are needed";
        cancel_button_label="Cancel ";
        save_button_label="Save ";
        langCode="Ar";
        sNoTeam = "No Data are available for " + crew_name;
        Dupname = "Code for Crew is Duplicated Chane it";
        sStatus="Staff Code Saved Successfully";
        fStatus="Fail To Save This Staff Code";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        crew_name="&#1573;&#1587;&#1605; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
        crew_code="&#1603;&#1608;&#1583; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
        //crew_typcalDuration="&#1575;&#1604;&#1601;&#1578;&#1585;&#1607; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;&#1607;";
        crew_description="&#1575;&#1604;&#1608;&#1589;&#1601;";
        
        
        title_1="&#1603;&#1608;&#1583; &#1580;&#1583;&#1610;&#1583; &#1604;&#1601;&#1585;&#1610;&#1602;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
        langCode="En";
        sNoTeam = "&#1604;&#1610;&#1587; &#1607;&#1606;&#1575;&#1603; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607; &#1604;" + crew_name;
        Dupname ="&#1578;&#1604;&#1603; &#1575;&#1604;&#1603;&#1608;&#1585; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1604;&#1578;&#1604;&#1603; &#1575;&#1604;&#1601;&#1585;&#1602; &#1610;&#1580;&#1576; &#1578;&#1594;&#1610;&#1610;&#1585; &#1575;&#1604;&#1603;&#1608;&#1583;";
        fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
        sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
    }
    String doubleName = (String) request.getAttribute("name");
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new Staff Code</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"> <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        { 
            if (!validateData("req", this.ITEM_FORM.code, "Please, enter Staff Code.") || !validateData("minlength=3", this.ITEM_FORM.code, "Please, enter a valid Staff Code.")){
                this.ITEM_FORM.code.focus();
            } else if (!validateData("req", this.ITEM_FORM.description, "Please, enter Staff description.")){
                this.ITEM_FORM.description.focus(); 
            } else {
                document.ITEM_FORM.action = "<%=context%>/StaffCodeServlet?op=SaveStaffCode";
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
        <left>
        <FORM NAME="ITEM_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <%
                if(arrayCrewList.size() > 0){
                %>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                <%
                }
                %>
            </DIV> 
            <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="<%=align%>">
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
            <%
            if(arrayCrewList.size() == 0) {
            %>
            <BR><center><font color="red"><B><%=sNoTeam%></B></font></center>
            <%
            }
            %>
            <TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR COLSPAN="2" ALIGN="<%=align%>">
                    
                    <TD STYLE="<%=style%>" class='td'>
                        <FONT color='red' size='+1'><%=title_2%></FONT> 
                    </TD>
                    
                </TR>
            </TABLE>
            <br><br>
            <TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="crewID">
                            <p><b><%=crew_name%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </td>   
                    <TD STYLE="<%=style%>" class='td'>
                        <SELECT name="crewID" style="width:230px">
                            <sw:WBOOptionList wboList='<%=arrayCrewList%>' displayAttribute = "crewName" valueAttribute="crewID"/>
                            
                        </SELECT>
                    </TD>
                    
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="catCode">
                            <p><b><%=crew_code%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>"class='td'>
                        <input type="TEXT" style="width:230px" name="code" ID="code" size="33" value="" maxlength="255">
                    </TD>
                </TR>
                
                
                
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="Note">
                            <p><b><%=crew_description%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <TEXTAREA style="width:230px" name="description" ID="description" size="33" ROWS="5"></textarea>
                    </TD>
                    
                </TR>
                
            </TABLE>
            <br><br>
        </FORM>
    </BODY>
</HTML>     
