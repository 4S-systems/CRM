<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <%
    String status = (String) request.getAttribute("Status");
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    WebBusinessObject crewWBO = (WebBusinessObject) request.getAttribute("crewWBO");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String message=null;
    String lang,langCode,tit,sstat,fstat,save,cancel,TT,SNA,SNO,DESC,CRM,CRC,DU,CO,desc,ST,Dupname;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        tit="Update Crew";
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
        CO="Typical Cost";
        desc="Description";
        ST="Update Status";
         Dupname = "Name is Duplicated Chane it";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        tit=" &#1578;&#1581;&#1583;&#1610;&#1579; &#1601;&#1585;&#1610;&#1602; &#1575;&#1604;&#1593;&#1605;&#1604;";
         fstat="&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        sstat= "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581; ";
        
        save="&#1587;&#1580;&#1604;";
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
        ST="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
         Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
 
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
        
        if (!validateData("req", this.CREW_FORM.crewName, "Please, enter Crew Name.") || !validateData("minlength=3", this.CREW_FORM.crewName, "Please, enter a valid Crew Name.")){
                this.CREW_FORM.crewName.focus();
            //} else if (!validateData("req", this.CREW_FORM.crewCode, "Please, enter Crew Code.") || !validateData("minlength=3", this.CREW_FORM.crewCode, "Please, enter a valid Crew Code.")){
              //  this.CREW_FORM.crewCode.focus();
            } else if (!validateData("req", this.CREW_FORM.typicalDuration, "Please, enter Typical Duration.") || !validateData("numeric", this.CREW_FORM.typicalDuration, "Please, enter a valid number for Typical Duration.")){
                this.CREW_FORM.typicalDuration.focus();
            } else if (!validateData("req", this.CREW_FORM.missionDesc, "Please, enter Crew Mission Description.")){
                this.CREW_FORM.missionDesc.focus();
            //} else if (!validateData("req", this.CREW_FORM.typicalCost, "Please, enter Typical Cost.") || !validateData("numeric", this.CREW_FORM.typicalCost, "Please, enter a valid number for Typical Cost.")){
             //   this.CREW_FORM.typicalCost.focus();
            } else{
                document.CREW_FORM.action = "<%=context%>/CrewMissionServlet?op=UpdateCrew";
                document.CREW_FORM.submit();  
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
        document.CREW_FORM.action = "<%=context%>/CrewMissionServlet?op=ListCrew";
        document.CREW_FORM.submit();  
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
            <FORM NAME="CREW_FORM" METHOD="POST">
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
                            message  = sstat;
                        } else {
                            message = fstat;
                        }
                    %>
                <br>
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font size=4 color="red"> <%=message%> </font> 
                        </td>
                        
                </tr> </table>
                <%
                
                }
                
                %>
                <br>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="crewName">
                                <p><b><%=CRM%> <font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input  type="TEXT" style="width:230px" name="crewName" ID="crewName" size="33" value="<%=crewWBO.getAttribute("crewName").toString()%>" maxlength="255">
                        </TD>
                    </TR>
                    <!--TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="crewCode">
                                <p><b><%=CRC%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>"class='td'>
                            <input type="TEXT" style="width:230px" name="crewCode" ID="crewCode" size="33" value="<%=crewWBO.getAttribute("crewCode").toString()%>" maxlength="255">
                        </TD>
                    </TR-->
                    <input type="hidden" style="width:230px" name="crewCode" ID="crewCode" size="33" value="<%=crewWBO.getAttribute("crewCode").toString()%>" maxlength="255">
                    <input type="hidden" style="width:230px" name="typicalDuration" ID="typicalDuration" size="33" value="<%=crewWBO.getAttribute("typicalDuration").toString()%>" maxlength="255">
                      
                    <!--TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="typicalDuration">
                                <p><b><%=DU%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input type="TEXT" style="width:230px" name="typicalDuration" ID="typicalDuration" size="33" value="<%//=crewWBO.getAttribute("typicalDuration").toString()%>" maxlength="255">
                        </TD>
                    </TR-->
                    <!--TR>
                        <TD STYLE="<%//=style%>" class='td'>
                            <LABEL FOR="typicalCost">
                                <p><b><%//=CO%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%//=style%>" class='td'>
                            <input type="TEXT" style="width:230px" name="typicalCost" ID="typicalCost" size="33" value="<%=crewWBO.getAttribute("typicalCost").toString()%>" maxlength="255">
                        </TD>
                    </TR-->
                    <input type="hidden" style="width:230px" name="typicalCost" ID="typicalCost" size="33" value="<%=crewWBO.getAttribute("typicalCost").toString()%>" maxlength="255">
                    
                    <TR>
                        <TD STYLE="<%=style%>"class='td'>
                            <LABEL FOR="missionDesc">
                                <p><b><%=desc%><font color="#FF0000">*</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <TEXTAREA type="TEXT" STYLE="width:230px" name="missionDesc" ID="missionDesc" ROWS="4" COLS="25" size="33" value="" maxlength="255"><%=crewWBO.getAttribute("missionDesc").toString()%></textarea>
                        </TD>
                        <input type="hidden" name="crewID" value="<%=crewWBO.getAttribute("crewID").toString()%>">
                    </TR>
                </TABLE>
            </FORM>
        </fieldset>
    </BODY>
</HTML>     
