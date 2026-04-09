<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
int flipper=0;
String bgColor=null;
String bgColorm=null;

String status = (String) request.getAttribute("Status");

String crewCodeName = (String) request.getAttribute("crewCodeName");
String staffCode = (String) request.getAttribute("staffCode");

WebBusinessObject wbo = null;
WebBusinessObject wbobasic = null;

TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
//WebBusinessObject crewWBO = (WebBusinessObject) request.getAttribute("crewWBO");

ArrayList employeeList = (ArrayList) request.getAttribute("employeeList");
ArrayList empbasicList = (ArrayList) request.getAttribute("empbasicList");

Vector vecStaff = (Vector) request.getAttribute("vecStaff");
Vector designation = new Vector();
String sDesignation;
for(int i = 0; i < employeeList.size(); i++){
    wbo = (WebBusinessObject) employeeList.get(i);
    sDesignation = (String) wbo.getAttribute("designation");
    if(!designation.contains(sDesignation)){
        designation.add(sDesignation);
    }
}

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode,tit,save,cancel,TT,SNA,SNO,DESC,EmpCode;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    tit="View Staff";
    save="Delete";
    cancel="Back To List";
    TT="View Staff To Code ";
    SNA="Employee Name";
    SNO="Site No.";
    DESC="There Is No Employee Related To This Staff";
    EmpCode="Employee Code";
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    tit="  &#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
    save=" &#1573;&#1581;&#1584;&#1601;";
    cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    TT="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602; &#1575;&#1604;&#1584;&#1610; &#1603;&#1608;&#1583;&#1607;";
    SNA=" &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601; ";
    SNO="&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
    DESC="&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1608;&#1592;&#1601;&#1610;&#1606; &#1578;&#1575;&#1576;&#1593;&#1610;&#1606; &#1604;&#1607;&#1584;&#1575; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
    EmpCode="&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;";
   
    }
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new user</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {
        document.USERS_FORM.action = "<%=context%>/CrewMissionServlet?op=UpdateStaff";
        document.USERS_FORM.submit();
        }
        
         function cancelForm()
        {    
        document.USERS_FORM.action = "<%=context%>/CrewMissionServlet?op=ShowStaff";
        document.USERS_FORM.submit();  
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
            
        </DIV> 
        <br><br>
        <fieldset align=center class="set">
            <legend align="center">
                
                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6"><%=tit%> <IMG WIDTH="20" HEIGHT="20" SRC="images/user.gif"> 
                            </font>
                        </td>
                    </tr>
                </table>
            </legend >
            <FORM NAME="USERS_FORM" METHOD="POST">
                
                <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    <TR>
                        <TD class='td'>
                            <h3><%=TT%> '<font color="red"><%=crewCodeName%> </font>'</h3>
                        </TD>
                        
                    </TR>
                </TABLE>
                <br>
                
                <TABLE ALIGN="<%=align%>"   WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                    <TR CLASS="head">
                        <TD nowrap  CLASS="silver_header"  STYLE="<%=style%>">
                            <%=SNA%>
                        </TD>
                        <TD nowrap  CLASS="silver_header"  STYLE="<%=style%>">
                            <%=EmpCode%>
                        </TD>
                    </TR>       
                    <%
                    //for(int j = 0; j < designation.size(); j++){
                   // sDesignation = (String) designation.get(j);
                    %>
                    <!--TR>
                        <TD  CLASS="cell" STYLE="<%//=style%>">
                            <DIV ID="links">
                              
                                    <b><%//=sDesignation%></b>
                                    
                                </A>
                            </DIV>
                        </TD>
                    </TR-->
                    
                    <%
                    boolean hasChild = false;
                    for(int i = 0; i < employeeList.size(); i++) {
                    wbo = (WebBusinessObject) employeeList.get(i);
                   // if(sDesignation.equalsIgnoreCase(wbo.getAttribute("designation").toString())){
                    
                    
                    for(int x = 0; x < vecStaff.size(); x++){
                    WebBusinessObject empWbo = (WebBusinessObject) vecStaff.elementAt(x);
                    if(empWbo.getAttribute("employeeID").toString().equals(wbo.getAttribute("empId").toString())){
                    //if(vecStaff.contains(wbo.getAttribute("empId").toString())){
                    hasChild = true;
                    flipper++;
                    if((flipper%2) == 1) {
                        bgColor = "silver_odd";
                        bgColorm = "silver_odd_main";
                    } else {
                       bgColor = "silver_even";
                       bgColorm = "silver_even_main";
                    }
                    %>
                    <TR>
                        <TD  class="<%=bgColorm%>" STYLE="<%=style%>">
                            <DIV ID="links">
                                <table dir="<%=dir%>" >
                                    <tr>
                                        <td class="td" style="<%=style%>">
                                            <%=wbo.getAttribute("empName")%>
                                        </td>
                                    </tr>
                                </table>
                                
                            </DIV>
                        </TD>
                        <TD  class="<%=bgColor%>" STYLE="<%=style%>">
                            <DIV ID="links">
                                <table dir="<%=dir%>" >
                                    <tr>
                                        <td class="td" style="<%=style%>">
                                            <%=wbo.getAttribute("empId")%>
                                        </td>
                                    </tr>
                                </table>
                                
                            </DIV>
                        </TD>
                    </TR>
                    <%} %>
                    
                    <%
                    }
                   // }
                    //}
                   // if(!hasChild){
                    %>
                    
                    <!--TR>
                        <TD  CLASS="cell" STYLE="<%//=style%>">
                            <DIV ID="links">
                                <table dir="<%//=dir%>" align="<%//=align%>">
                                    <tr>
                                        <td class="td" style="<%//=style%>">
                                            <%//=DESC%>
                                        </td>
                                </tr> </table>
                            </DIV>
                        </TD>
                    </TR-->
                    <%
                    //}
                    }
                    %>
                    
                    <%
                    boolean hasChild2 = false;
                    for(int i = 0; i < empbasicList.size(); i++) {
                    wbobasic = (WebBusinessObject) empbasicList.get(i);
                   // if(sDesignation.equalsIgnoreCase(wbo.getAttribute("designation").toString())){
                    
                    
                    for(int x = 0; x < vecStaff.size(); x++){
                    WebBusinessObject empbasicWbo = (WebBusinessObject) vecStaff.elementAt(x);
                    if(empbasicWbo.getAttribute("employeeID").toString().equals(wbobasic.getAttribute("empId").toString())){
                    //if(vecStaff.contains(wbo.getAttribute("empId").toString())){
                    hasChild2 = true;
                    %>
                    <TR>
                        <TD  class="<%=bgColor%>" STYLE="<%=style%>">
                            <DIV ID="links">
                                <table dir="<%=dir%>" >
                                    <tr>
                                        <td class="td" style="<%=style%>">
                                            <%=wbobasic.getAttribute("empName")%>
                                        </td>
                                    </tr>
                                </table>
                                
                            </DIV>
                        </TD>
                        <TD  class="<%=bgColor%>" STYLE="<%=style%>">
                            <DIV ID="links">
                                <table dir="<%=dir%>" >
                                    <tr>
                                        <td class="td" style="<%=style%>">
                                            <%=wbobasic.getAttribute("empId")%>
                                        </td>
                                        
                                    </tr>
                                </table>
                                
                            </DIV>
                        </TD>
                    </TR>
                    <%} %>
                    
                    <%
                    }
                   // }
                    //}
                   // if(!hasChild2){
                    %>
                    
                    <!--TR>
                        <TD  CLASS="cell" STYLE="<%=style%>">
                            <DIV ID="links">
                                <table dir="<%=dir%>" align="<%=align%>">
                                    <tr>
                                        <td class="td" style="<%=style%>">
                                            <%=DESC%>
                                        </td>
                                </tr> </table>
                            </DIV>
                        </TD>
                    </TR-->
                    <%
                    //}
                    }
                    %>
                </TABLE>   
                <input type="hidden" name="crewID" value="<%//=crewWBO.getAttribute("crewID").toString()%>">
            </FORM>
            <br>
        </FIELDSET>
    </BODY>
</HTML>     
