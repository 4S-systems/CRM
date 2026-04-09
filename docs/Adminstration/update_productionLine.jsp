<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <%
    String status = (String) request.getAttribute("Status");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    WebBusinessObject productionLineWbo = (WebBusinessObject) request.getAttribute("productionLineWbo");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String saving_status;
    String lang,langCode,tit,save,cancel,TT,SNA,SNO,DESC,CRM,CRC,DU,CO,desc,code,description,Dupname;
    String save_button_label;
    String fStatus;
    String sStatus;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        saving_status="Saving status";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        tit="Update Production Line";
        save="Delete";
        cancel="Back To List";
        TT="Task Title ";
        SNA="Department Name";
        SNO="Site No.";
        DESC="Description";
        CRM="Crew Name";
        CRC="Crew Code";
        DU="Duration";
        CO="Typical Cost";
        desc="Description";
        code="Production code";
        description="Production description";
        save_button_label="Save ";
        Dupname = "Name is Duplicated Chane it";
        sStatus="Production Line Saved Successfully";
        fStatus="Fail To Save Production Line";
    }else{
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        tit="&#1578;&#1593;&#1583;&#1610;&#1604; &#1576;&#1610;&#1575;&#1606;&#1575;&#1578; &#1582;&#1591; &#1575;&#1604;&#1573;&#1606;&#1578;&#1575;&#1580;";
        save=" &#1573;&#1581;&#1584;&#1601;";
        cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        TT="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        SNA="&#1573;&#1587;&#1605; &#1575;&#1604;&#1602;&#1587;&#1605;";
        SNO="&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        DESC="&#1575;&#1604;&#1608;&#1589;&#1601;";
        CRM="&#1573;&#1587;&#1605; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
        CRC="&#1603;&#1608;&#1583; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
        DU="&#1575;&#1604;&#1605;&#1583;&#1607;";
        CO="&#1575;&#1604;&#1578;&#1603;&#1604;&#1601;&#1607; &#1575;&#1604;&#1601;&#1593;&#1604;&#1610;&#1607;";
        desc="&#1608;&#1589;&#1601; &#1601;&#1585;&#1610;&#1602; &#1575;&#1604;&#1593;&#1605;&#1604;";
        code="&#1603;&#1608;&#1583; &#1582;&#1591; &#1575;&#1604;&#1573;&#1606;&#1578;&#1575;&#1580;";
        description="&#1575;&#1604;&#1608;&#1589;&#1601;";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
        Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
        fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
        sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
    }
    String doubleName = (String) request.getAttribute("name");
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new Employee</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

         function submitForm()
        {
            if (!validateData("req", this.production_FORM.code, "Please, enter Code for production Line.") || !validateData("minlength=3", this.production_FORM.code, "Please, enter a valid Code.")){
                this.production_FORM.crewName.focus();
            } else if (!validateData("req", this.production_FORM.Desc, "Please, enter Production Line Description.")){
                this.production_FORM.Desc.focus();
            } else{
                document.production_FORM.action = "<%=context%>/ProductionLineServlet?op=UpdateProductionLine";
                document.production_FORM.submit();  
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
    
    function checkEmail(email) {
        if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){
            return (true)
        }
            return (false)
    }
    
    function clearValue(no){
        document.getElementById('Quantity' + no).value = '0';
        total();
    }
    
    function cancelForm()
        {    
        document.production_FORM.action = "<%=context%>/ProductionLineServlet?op=ListProductionLine";
        document.production_FORM.submit();  
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
            <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            
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
            
            <FORM NAME="production_FORM" METHOD="POST">
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="lablecode">
                                <p><b><%=code%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>"class='td'>
                            <input type="TEXT" style="width:230px" name="code" ID="code" size="33" value="<%=productionLineWbo.getAttribute("code").toString()%>" maxlength="255">
                        </TD>
                    </TR>
                    <input name="id" type="hidden" value="<%=productionLineWbo.getAttribute("id").toString()%>">
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="Desc">
                                <p><b><%=description%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <TEXTAREA type="TEXT" style="width:230px" name="Desc" ID="Desc" ROWS="4" COLS="25" size="33" value="" maxlength="255"><%=productionLineWbo.getAttribute("Desc").toString()%></textarea>
                        </TD>
                    </TR>
                </TABLE>
            </FORM>
        </fieldset>
    </BODY>
</HTML>     
