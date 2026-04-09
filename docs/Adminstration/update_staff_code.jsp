<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    
    
    <%
    
    String status = (String) request.getAttribute("Status");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    CrewMissionMgr crewMissionMgr = CrewMissionMgr.getInstance();
    String staffCodeId = (String) request.getAttribute("staffCodeId");
    
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    WebBusinessObject staff = (WebBusinessObject) request.getAttribute("staff");
    //String crewName = staff.getAttribute("crewStaffName").toString();
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String message=null;
    String lang,langCode,tit,save,cancel,sstat,fstat,TT,SNA,SNO,DESC,CRM,CRC,DU,CO,desc,CR,STAT,IN,Dupname;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        tit="Update Staff Code";
        sstat="Saving successfully";        
         fstat="saving failed";
        save="Save";
        cancel="Back To List";
        TT="Task Title ";
        SNA="Department Name";
        SNO="Site No.";
        DESC="Description";
        CRM="Crew Name";
        CRC="Crew Code";
        DU="Duration";
        CO="Staff Code";
        desc="Description";
        STAT="Update Status";
        CR="Crew Name";
        IN="All Information Are Needed";
        Dupname = "Code for Crew is Duplicated Chane it";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        tit="             &#1578;&#1581;&#1583;&#1610;&#1579; &#1603;&#1608;&#1583; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
        save=" &#1578;&#1587;&#1580;&#1610;&#1604;";
        cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        TT="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
        SNA="&#1573;&#1587;&#1605; &#1575;&#1604;&#1602;&#1587;&#1605;";
        SNO="&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        DESC="&#1575;&#1604;&#1608;&#1589;&#1601;";
        CRM="&#1573;&#1587;&#1605; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
        CRC="&#1603;&#1608;&#1583; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
        DU="&#1575;&#1604;&#1605;&#1583;&#1607;";
        CO="&#1603;&#1608;&#1583; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
        desc="&#1608;&#1589;&#1601; &#1601;&#1585;&#1610;&#1602; &#1575;&#1604;&#1593;&#1605;&#1604;";
         fstat="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        sstat= "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581; ";  
       STAT="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        CR="&#1573;&#1587;&#1605; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
        IN="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        Dupname ="&#1578;&#1604;&#1603; &#1575;&#1604;&#1603;&#1608;&#1585; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1604;&#1578;&#1604;&#1603; &#1575;&#1604;&#1601;&#1585;&#1602; &#1610;&#1580;&#1576; &#1578;&#1594;&#1610;&#1610;&#1585; &#1575;&#1604;&#1603;&#1608;&#1583;";
      
        }
    
    String doubleName = (String) request.getAttribute("name");
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>DebugTracker-update Staff Code</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        { 
            if (!validateData("req", this.ITEM_FORM.code, "Please, enter Staff Code.") || !validateData("minlength=3", this.ITEM_FORM.code, "Please, enter a valid Staff Code.")){
                this.ITEM_FORM.code.focus();
            } else if (!validateData("req", this.ITEM_FORM.description, "Please, enter Staff description.")){
                this.ITEM_FORM.description.focus(); 
            } else { 
                document.ITEM_FORM.action = "<%=context%>/StaffCodeServlet?op=UpdateStaffCode&staffCodeId=<%=staffCodeId%>";
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
        document.ITEM_FORM.action = "<%=context%>//StaffCodeServlet?op=ListStaffCode";
        document.ITEM_FORM.submit();  
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
            <FORM NAME="ITEM_FORM" METHOD="POST">
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
                if(status.equalsIgnoreCase("ok"))
                    
                    {
                    message=sstat;
                    }else
                        {
                        message=fstat;
                        }
                
                %>
                
                <center><b><font size=4 color="red" dir="<%=dir%>"> <%=message%></font> </center></b>
                
                <%
                
                }
                
                %>
                <br><br>  
                <center><b><font size=4 color="red"><%=IN%></font> </center></b>
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <tr>
                        
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="crewID">
                                <p><b><%=CR%><font color="#FF0000"></font></b>&nbsp;
                            </LABEL>
                        </td>   
                        <TD  STYLE="<%=style%>" class='td'>
                            <%
                            ArrayList arrayCrewList = new ArrayList();
                            crewMissionMgr.cashData();
                            arrayCrewList = crewMissionMgr.getCashedTableAsBusObjects();
                            %>
                            
                            <%
                            //if(request.getParameter("crewID") != null){
                            WebBusinessObject wbo = crewMissionMgr.getOnSingleKey(staff.getAttribute("crewID").toString());
                            String  crewName = wbo.getAttribute("crewName").toString();
                            %>
                            <SELECT name="crewID" STYLE="width:230px">
                                <sw:WBOOptionList wboList='<%=arrayCrewList%>' displayAttribute = "crewName" valueAttribute="crewID" scrollTo="<%=crewName%>"/>
                                
                            </SELECT>
                            <%
                            //} //else {
                            %>
                            <!--SELECT name="categoryId">
                            <//sw:WBOOptionList wboList='<%//=arrayCrewList%>' displayAttribute = "crewName" valueAttribute="crewID"/>
                        </SELECT-->
                            <%
                            // }
                            %>
                            
                            <!--SELECT name="crewID">
                            <//sw:WBOOptionList wboList='<%//=arrayCrewList%>' displayAttribute = "crewName" valueAttribute="crewID"/>
                
            </SELECT-->
                        </TD>
                        
                    </TR>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=CO%> </b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="TEXT" STYLE="width:230px" name="code" ID="code" size="33" value="<%=staff.getAttribute("code")%>" maxlength="255">
                        </TD>
                    </TR>
                    
                    
                    <TR>
                        <TD  STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=desc%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD  STYLE="<%=style%>" class='td'>
                            <TEXTAREA  rows="5" STYLE="width:230px" name="description" ID="description" cols="25"><%=staff.getAttribute("description")%></TEXTAREA>
                            
                        </TD>
                        
                    </TR>
                    
                    
                </TABLE>
            </FORM>
            <br>
        </fieldset>
    </BODY>
</HTML>     
