<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld"%>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
CrewEmployeeMgr crewEmployeeMgr = CrewEmployeeMgr.getInstance();
EmployeeMgr employeeMgr = EmployeeMgr.getInstance();

String status = (String) request.getAttribute("Status");

String crewCodeName = (String) request.getAttribute("crewCodeName");
String staffCode = (String) request.getAttribute("staffCode");
//String idCode = (String) request.getAttribute("idCode");
Vector manager = new Vector();

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
String lang,langCode,tit,save,cancel,TT,SNA,SNO,DESC,TTT,EmpCode;
String fStatus;
String sStatus;
if(stat.equals("En")){
    
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    langCode="Ar";
    tit="Update Staff";
    save="Save";
    cancel="Back To List";
    TT="Updating Status  ";
    SNA="Employee Name";
    SNO="Select";
    DESC="There Is No Employee Related To This Staff";
    TTT="Update Staff To Code";
    EmpCode="Employee Code";
    sStatus="Crew Staff Updated Successfully";
    fStatus="Fail To Update This Crew Staff";
    
}else{
    
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    langCode="En";
    tit="  &#1578;&#1581;&#1583;&#1610;&#1579; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
    save="&#1587;&#1580;&#1604;";
    cancel=" &#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
    TT="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    SNA=" &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601; ";
    SNO="&#1573;&#1582;&#1578;&#1575;&#1585;";
    DESC="&#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1608;&#1592;&#1601;&#1610;&#1606; &#1578;&#1575;&#1576;&#1593;&#1610;&#1606; &#1604;&#1607;&#1584;&#1575; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
    TTT="&#1578;&#1581;&#1583;&#1610;&#1579; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602; &#1604;&#1604;&#1603;&#1608;&#1583;";
    EmpCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;";
    fStatus="&#1604;&#1600;&#1605; &#1610;&#1600;&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604;";
    sStatus="&#1578;&#1600;&#1600;&#1605; &#1575;&#1604;&#1600;&#1578;&#1600;&#1587;&#1600;&#1580;&#1600;&#1610;&#1600;&#1604; &#1576;&#1600;&#1606;&#1600;&#1580;&#1600;&#1575;&#1581;";
}
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new user</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {
         var checked=false;
	var elements = document.getElementsByName("staff");
        for(var i=0; i < elements.length; i++){
		if(elements[i].checked) {
                checked = true;
        document.USERS_FORM.action = "<%=context%>/CrewMissionServlet?op=UpdateStaff&staffCode=<%=staffCode%>&crewCodeName=<%=crewCodeName%>&staffSize=1";
        document.USERS_FORM.submit();
        }
        }
        if (!checked) {
        document.USERS_FORM.action = "<%=context%>/CrewMissionServlet?op=UpdateStaff&staffCode=<%=staffCode%>&crewCodeName=<%=crewCodeName%>&staffSize=0";
        document.USERS_FORM.submit();
	}
        }
         function refreshData(){
        document.USERS_FORM.action = "<%=context%>/CrewMissionServlet?op=GetUpdateStaffForm&crewCodeName=<%=crewCodeName%>&staffCode=<%=staffCode%>";
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
        
        <FORM NAME="USERS_FORM" METHOD="POST">
            
            <%
            if(null!=status) {
            
            %>
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
                <br>
                <%
                if(status.equalsIgnoreCase("ok")){
                %>  
                <center><b>  <font size=4 dir="<%=dir%>"><%=sStatus%></font></b></center> 
                <%
                }else{%>
                <center><b>  <font color="red" size=4 dir="<%=dir%>"> <%=fStatus%></font></b></center> 
                <%}%>
                
                <br>
            </fieldset>
            <%
            
            } else {
            
            %>
            
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
                                <font color="blue" size="6"><%=tit%> <IMG WIDTH="20" HEIGHT="20" SRC="images/user.gif"> 
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend >
                
                
                <br>
                <TABLE DIR="<%=dir%>"  ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                        
                        <TR>
                            <TD class='td'>
                                <h3><%=TTT%> '<font color="red"><%=crewCodeName%> </font>'</h3>
                            </TD>
                            
                        </TR>
                    </TABLE>                             
                    
                </TABLE>
                <br>
                
                
                <TABLE ALIGN="<%=align%>"  WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                    <TR CLASS="head">
                    <TR CLASS="head">
                        <TD nowrap  CLASS="firstname"  STYLE="<%=style%>">
                            <%=SNA%>
                        </TD>
                        <TD nowrap  CLASS="firstname"  STYLE="<%=style%>">
                            <%=EmpCode%>
                        </TD>
                        
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="33">
                            <B>
                                <%=SNO%> 
                            </B>
                        </TD>
                    </TR>       
                    <%
                    //for(int j = 0; j < designation.size(); j++){
                    //sDesignation = (String) designation.get(j);
                    %>
                    <!--TR>
                    <TD  CLASS="cell" STYLE="padding-left:20;<%//=style%>">
            <DIV ID="links">
                
                
                    <b><%//=sDesignation%></b>
                
                </A>
            </DIV>
            </TD>
            <TD  CLASS="cell" style="border-left">
                &nbsp;
            </TD>
            </TR-->
                    <%
                    // if(request.getParameter("manager") != null){
                    // manager = employeeMgr.getOnArbitraryKey(request.getParameter("manager"), "key");
                    
                    ///    } else if(arrayEmpList != null){
                    //  manager = employeeMgr.getOnArbitraryKey(((WebBusinessObject) arrayEmpList.get(0)).getAttribute("empId").toString(), "key");
                    
                    //  } else {
                    //  manager = null;
                    //        }
                    %>
                    <%
                    // if(manager != null){
                    %>
                    
                    <%
                    //for(int x = 0; x < manager.size(); x++){
                    //    WebBusinessObject empWbo = (WebBusinessObject) manager.elementAt(x);
                    %>
                    
                    
                    <%
                    for(int i = 0; i < employeeList.size(); i++) {
                        wbo = (WebBusinessObject) employeeList.get(i);
                    %>
                    
                    
                    <TR>
                        
                        
                        <TD  CLASS="cell" STYLE="padding-left:80;<%=style%>">
                            <DIV ID="links">
                                
                                
                                <%=wbo.getAttribute("empName")%> 
                                
                                
                            </DIV>
                        </TD>
                        <TD  CLASS="cell" STYLE="padding-left:80;<%=style%>">
                            <DIV ID="links">
                                
                                
                                <%=wbo.getAttribute("empId")%> 
                                
                                
                            </DIV>
                        </TD>
                        <TD STYLE="<%=style%>">
                            <INPUT TYPE="CHECKBOX" NAME="staff" id="staff" value ="<%=wbo.getAttribute("empId")%>"<%if(vecStaff.contains(wbo.getAttribute("empId").toString())){%> CHECKED <%}%>>
                                
                                
                            </TD>
                    </TR>
                    
                    
                    <%
                    
                    }
                    
                    %>
                    
                    <%
                    for(int i = 0; i < empbasicList.size(); i++) {
                        wbobasic = (WebBusinessObject) empbasicList.get(i);
                        //if(sDesignation.equalsIgnoreCase(wbo.getAttribute("designation").toString())){
                    %>
                    
                    <% //if(crewEmployeeMgr.getActiveLeader(staffCode,empWbo.getAttribute("empId").toString())){%>
                    
                    <TR>
                        <%// }else { %>
                        <TD  CLASS="cell" STYLE="padding-left:80;<%=style%>">
                            <DIV ID="links">
                                
                                
                                <%=wbobasic.getAttribute("empName")%> 
                                
                                
                            </DIV>
                        </TD>
                        <TD  CLASS="cell" STYLE="padding-left:80;<%=style%>">
                            <DIV ID="links">
                                
                                
                                <%=wbobasic.getAttribute("empId")%> 
                                
                                
                            </DIV>
                        </TD>
                        <TD STYLE="<%=style%>">
                            <INPUT TYPE="CHECKBOX" NAME="staff" id="staff" value ="<%=wbobasic.getAttribute("empId")%>"<%if(vecStaff.contains(wbobasic.getAttribute("empId").toString())){%> CHECKED <%}%>>
                                
                                <%// } %>
                            </TD>
                    </TR>
                    
                    
                    <%
                    //}
                    }
                    // }
                    //}
                    // }
                    %>
                    
                </TABLE>   
                <input type="hidden" name="crewID" value="<%//=crewWBO.getAttribute("crewID").toString()%>">
                <br><br>
            </fieldset>
            <%
            }
            %>
        </FORM>
        
        
    </BODY>
</HTML>     
