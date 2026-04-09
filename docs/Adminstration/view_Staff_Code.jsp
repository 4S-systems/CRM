<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>  
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();


WebBusinessObject staff = (WebBusinessObject) request.getAttribute("staff");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,tit,save,cancel,TT,SNA,SNO,DESC,CRM,CRC,DU,CO,desc;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    tit="View Staff Code";
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
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    tit="  &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1603;&#1608;&#1583; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
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
}
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - view Staff Code</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <script language="havascript" type="text/javascript">
         function cancelForm()
        {    
        document.PROJECT_VIEW_FORM.action = "<%=context%>//StaffCodeServlet?op=ListStaffCode";
        document.PROJECT_VIEW_FORM.submit();  
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
    </script>
    <BODY>
        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            <button    onclick="cancelForm()" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
            
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
            <FORM NAME="PROJECT_VIEW_FORM" METHOD="POST">
                
                <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Function_Name">
                                <p><b><%=CO%> </b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD  STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" STYLE="width:230px" name="title" ID="title" size="33" value="<%=staff.getAttribute("crewStaffName")%>" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD  STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Function_Desc">
                                <p><b><%=desc%></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD  STYLE="<%=style%>"class='td'>
                            <TEXTAREA DISABLED STYLE="width:230px" rows="5" name="description" ID="description" cols="25"><%=staff.getAttribute("description")%></TEXTAREA>
                            
                        </TD>
                    </TR>
                </TABLE>
            </FORM>
        </FIELDSET>
    </BODY>
</HTML>     
