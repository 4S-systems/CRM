<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>  
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();


WebBusinessObject department = (WebBusinessObject) request.getAttribute("department");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,tit,save,cancel,TT,SNA,SNO,DESC;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    tit="View Department";
    save="Delete";
    cancel="Back To List";
    TT="Task Title ";
    SNA="Department Name";
    SNO="Site No.";
    DESC="Description";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    tit="  &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1602;&#1587;&#1605;";
    save=" &#1573;&#1581;&#1584;&#1601;";
    cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    TT="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1605;&#1607;&#1605;&#1607;";
    SNA="&#1573;&#1587;&#1605; &#1575;&#1604;&#1602;&#1587;&#1605;";
    SNO="&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    DESC="&#1575;&#1604;&#1608;&#1589;&#1601;";
}
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new Department</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    <script language="javascript" type="text/javascript" >
        
         function cancelForm()
        {    
        document.DEPARTMENT_VIEW_FORM.action = "<%=context%>//DepartmentServlet?op=ListDepartments";
        document.DEPARTMENT_VIEW_FORM.submit();  
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
    <BODY>
        
        <FORM  NAME="DEPARTMENT_VIEW_FORM" METHOD="POST">
            
            
            <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                   
                   <TR>
                   <TD STYLE="<%=style%>" class='td'>
                   <LABEL FOR="str_Function_Name">
                   <p><b> <%=SNA%></b>&nbsp;
                   </LABEL>
                   </TD>
                   <TD STYLE="<%=style%>" class='td'>
                   <input disabled type="TEXT" style="width:230px" name="departmentName" ID="departmentName" size="33" value="<%=department.getAttribute("departmentName")%>" maxlength="255">
                </TD>
                </TR>
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Function_Desc">
                            <p><b><%=DESC%></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <TEXTAREA DISABLED STYLE="width:230px" rows="5" name="department_desc" cols="25"><%=department.getAttribute("departmentDesc")%></TEXTAREA>
                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
