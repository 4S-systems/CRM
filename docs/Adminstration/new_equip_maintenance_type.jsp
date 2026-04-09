<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*,com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    
    
    <%
    
    String status = (String) request.getAttribute("Status");
    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    String categoryId = (String) request.getAttribute("categoryId");
    
    
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    WebBusinessObject categoryWbo = (WebBusinessObject) maintainableMgr.getOnSingleKey(categoryId);
    
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String fStatus;
    String sStatus;
    String lang,langCode,viewTitel,viewData,back,eqCat,mType,save,saveSt,newMType,saveMType
            ;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        viewTitel="Update Category Data";
        viewData=" Viewing Data";
        back="Back To List";
        eqCat="Equipment Category ";
        mType="Maintenance Type ";
        save="Save Update";
        saveSt="Saving Status";
        newMType="New Maintenance Type";
        saveMType="Save New Type";
        sStatus="Saved Successfully";
        fStatus="Fail To Save";
        
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        
        viewTitel="  &#1578;&#1581;&#1583;&#1610;&#1579; &#1589;&#1606;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        viewData=" &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1576;&#1610;&#1575;&#1606;&#1575;&#1578;";
        back="&#1575;&#1604;&#1593;&#1608;&#1583;&#1607; &#1575;&#1604;&#1610; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1607;";
        eqCat=" &#1589;&#1606;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        mType="&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        save="&#1587;&#1580;&#1604; &#1575;&#1604;&#1578;&#1581;&#1583;&#1610;&#1579;";
        saveSt=" &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; ";
        newMType= " &#1606;&#1608;&#1593; &#1589;&#1610;&#1575;&#1606;&#1577; &#1580;&#1583;&#1610;&#1583; &#1604;&#1605;&#1593;&#1583;&#1607;";
        saveMType="  &#1587;&#1580;&#1604; &#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
        sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
        
    }
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-add new Maintenance Type</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        { 
       if (this.ITEM_FORM.typeName.value ==""){
        alert ("Enter Maintenance Type");
        this.ITEM_FORM.typeName.focus();
    
     } else { 
       
        document.ITEM_FORM.action = "<%=context%>/EquipMaintenanceTypeServlet?op=SaveMainType";
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
    
      function back(url)
        {    
        window.navigate(url);
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="ITEM_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="     <%=lang%>     " onclick="reloadAE('<%=langCode%>')" class="button">
                <input type="button" value="     <%=back%>     " onclick="back('<%=context%>/EquipmentServlet?op=ListCategory')" class="button">
                <input type="button" value="     <%=saveMType%>     " onclick="submitForm()" class="button">
            </DIV>
            
            <fieldset align="<%=align%>" class="set" >
                <legend align="center">
                    <table dir="rtl" align="center">
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6"> <%=newMType%>       
                                </font>
                                
                                
                            </td>
                        </tr>
                        
                    </table>
                </legend>
                
                <br><br>
                <table align="<%=align%>" dir="<%=dir%>"> 
                    <%    if(null!=status) {
        
        if(status.equalsIgnoreCase("ok")){
                    %>  
                    <tr>
                        <table align="<%=align%>" dir=<%=dir%>>
                            <tr>                    
                                <td class="td">
                                    <font size=4 color="black"><%=sStatus%></font> 
                                </td>
                                <td class="td">
                                    <IMG VALIGN="BOTTOM" HEIGHT="20"  SRC="images/aro.JPG">
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
                                <td class="td">
                                    <IMG VALIGN="BOTTOM" HEIGHT="20"  SRC="images/aro.JPG">
                                </td>  
                        </tr> </table>
                    </tr>
                    <%}
                    }
                    %>
                    <!--TR COLSPAN="2" ALIGN="RIGHT">
                    <TD STYLE="<%=style%>" class='td'>
                        <FONT color='red' size='+1'>&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;</FONT> 
                    </TD>
                    <td STYLE="<%=style%>" class="td"><IMG VALIGN="BOTTOM"  HEIGHT="30" SRC="images/note.JPG"></td>
                </TR-->
                </table>
                <%    if(null!=status) {
                
                %>
                <br>
                <%
                }
                %>
                <TABLE align="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="catCode">
                                <p><b><%=mType%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD  STYLE="<%=style%>" class='td'>
                            <input type="TEXT" name="typeName" ID="typeName" size="33" value="" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD  STYLE="<%=style%>" class='td'>
                            <LABEL FOR="crewID">
                                <p><b><%=eqCat%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </td>   
                        
                        
                        <TD  STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="categoryId" ID="categoryId" size="33" value="<%=categoryWbo.getAttribute("unitName").toString()%>" maxlength="255">
                            <input type="hidden" name="categoryId" ID="categoryId" size="33" value="<%=categoryWbo.getAttribute("id").toString()%>" maxlength="255">
                        </TD>
                        
                    </TR>
                    
                    
                    
                </TABLE>
                <br><br>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
