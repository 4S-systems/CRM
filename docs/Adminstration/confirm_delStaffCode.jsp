<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    
    <%
    String staffCodeId = (String) request.getAttribute("staffCodeId");
    String staffTitle = (String) request.getAttribute("staffTitle");
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    FailureCodeMgr failureCodeMgr=FailureCodeMgr.getInstance();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode,tit,save,cancel,TT,SNA,SNO,DESC,CRM,CRC,DU,CO,desc,CR,STAT,IN;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        tit="Delete Staff Code - Are You Sure ?";
        save="Delete";
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
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        tit="&#1581;&#1584;&#1601; &#1603;&#1608;&#1583; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602; - &#1607;&#1604; &#1571;&#1606;&#1578; &#1605;&#1578;&#1571;&#1603;&#1583;&#1567;";
        save=" &#1573;&#1581;&#1584;&#1601;";
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
        STAT="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        CR="&#1573;&#1587;&#1605; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
        IN="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
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
      document.TECH_DEL_FORM.action = "<%=context%>/StaffCodeServlet?op=Delete&staffCodeId=<%=staffCodeId%>&staffTitle=<%=staffTitle%>";
      document.TECH_DEL_FORM.submit();  
   }
  
   function cancelForm()
        {    
        document.TECH_DEL_FORM.action = "<%=context%>//StaffCodeServlet?op=ListStaffCode";
        document.TECH_DEL_FORM.submit();  
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
            <button    onclick="submitForm()" class="button"><%=save%>    <IMG SRC="images/del.gif"></button>
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
            <FORM NAME="TECH_DEL_FORM" METHOD="POST">
                <br>
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=CO%> </b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="code" value="<%=staffTitle%>" ID="<%=staffTitle%>" size="33"  maxlength="50">
                        </TD>
                    </TR>
                    <input  type="HIDDEN" name="staffCodeId" value="<%=staffCodeId%>">
                    
                </TABLE>
            </FORM>
        </FIELDSET>
    </BODY>
</HTML>     
