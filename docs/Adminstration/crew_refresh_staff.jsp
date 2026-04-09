<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
StaffCodeMgr staffCodeMgr = StaffCodeMgr.getInstance();
CrewMissionMgr crewMissionMgr = CrewMissionMgr.getInstance();
EmployeeMgr employeeMgr = EmployeeMgr.getInstance();
Vector manager = new Vector();

String context = metaMgr.getContext();


String status = (String) request.getAttribute("Status");
String crewCodeName = (String) request.getAttribute("crewCodeName");
String staffCode = (String) request.getAttribute("staffCode");

String crewID = (String) request.getAttribute("crewID");

WebBusinessObject wbo = null;
TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
//WebBusinessObject crewWBO = (WebBusinessObject) request.getAttribute("crewWBO");
ArrayList employeeList = (ArrayList) request.getAttribute("employeeList");
Vector designation = new Vector();
String sDesignation;
for(int i = 0; i < employeeList.size(); i++){
    wbo = (WebBusinessObject) employeeList.get(i);
    sDesignation = (String) wbo.getAttribute("designation");
    if(!designation.contains(sDesignation)){
        designation.add(sDesignation);
    }
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
        document.USERS_FORM.action = "<%=context%>/CrewMissionServlet?op=UpdateStaff&staffCode=<%=staffCode%>&crewCodeName=<%=crewCodeName%>";
        document.USERS_FORM.submit();
        }
        
        function refreshData(){
        document.USERS_FORM.action = "<%=context%>/CrewMissionServlet?op=GetRefreshUpdateStaffForm&crewCodeName=<%=crewCodeName%>&staffCode=<%=staffCode%>";
        document.USERS_FORM.submit();	
        }

    </SCRIPT>
    
    
    
    <BODY>
        <left>
        <FORM NAME="USERS_FORM" METHOD="POST">
            
            <%
            if(null!=status) {
            
            %>
            <% if(status.equals("Ok")) {%>
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/user.gif">
                        Create Staff
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                        
                        <A HREF="<%=context%>/main.jsp">
                            <%//=tGuide.getMessage("backtolist")%>
                            back to main page
                        </A>
                    </TD>
                </TR>
            </TABLE>
            
            <h3>  Updating status: <font color="#FF0000"><%=status%></font> </h3>
            
            <%
            
            } else if(status.equals("Double")) {
            
            %>
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/user.gif">
                        Update Staff
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                        
                        <A HREF="<%=context%>/main.jsp">
                            <%=tGuide.getMessage("cancel")%>
                        </A>
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <A HREF="JavaScript: submitForm();">
                            Update Staff
                        </A>
                    </TD>
                </TR>
            </TABLE>
            <p><font color="#800000"><span style="font-family: Times New Roman">Saving 
                        status doesn't complete, Crew Code duplicate with Staff, change select Crew Code.</span></font></p>
            
            <!-- Begin -->
            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>    
                
                
                 <TR>
                    <TD class='td'>
                        <h3>Updating Staff for Staff Code '<font color="red"><%=crewCodeName%></font>'</h3>
                    </TD>
                </TR>
                
                <TR>
                        <TD class='td'>
                        <LABEL FOR="empNO">
                            <p><b><font color="#FF0000">*</font>Crew Leader:</b>
                        </LABEL>
                    </TD>
                        <%
                        ArrayList arrayEmpList = new ArrayList();
                        //maintainableMgr.cashData();
                        arrayEmpList = employeeMgr.getCashedTableAsBusObjects();
                        %>
                        
                        <td class='td'>
                             <%
                        if(request.getParameter("manager") != null){
        LiteWebBusinessObject managerWbo = employeeMgr.getOnSingleKey(request.getParameter("manager"));
                        %>
                        <SELECT name="manager" onchange="refreshData();">
                            <sw:WBOOptionList wboList='<%=arrayEmpList%>' displayAttribute = "empName" valueAttribute="empId" scrollTo="<%=managerWbo.getAttribute("empName").toString()%>"/>
                            
                        </SELECT>
                        <%
                        } else {
                        %>
                        <SELECT name="manager" onchange="refreshData();">
                            <sw:WBOOptionList wboList='<%=arrayEmpList%>' displayAttribute = "empName" valueAttribute="empId"/>
                        </SELECT>
                        <%
                        }
                        %>
                        
                    </TD>
                    
                </TR>
                
            </TABLE>
            
            
            
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                <TR CLASS="head">
                    <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12">
                        Emploee Name
                    </TD>
                    <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="33">
                        <B>
                            &nbsp;Select&nbsp;
                        </B>
                    </TD>
                </TR>       
                <%
                for(int j = 0; j < designation.size(); j++){
                            sDesignation = (String) designation.get(j);
                %>
                <TR>
                    <TD  CLASS="cell" STYLE="padding-left:20;text-align:left;">
                        <DIV ID="links">
                            <A HREF="alert('');">
                                <b><%=sDesignation%></b>
                                <SPAN>
                                </SPAN>
                            </A>
                        </DIV>
                    </TD>
                    <TD  CLASS="cell" style="border-left">
                        &nbsp;
                    </TD>
                </TR>
                 <%
            if(request.getParameter("manager") != null){
        manager = employeeMgr.getOnArbitraryKey(request.getParameter("manager"), "key");
            
            } else if(arrayEmpList != null){
        manager = employeeMgr.getOnArbitraryKey(((WebBusinessObject) arrayEmpList.get(0)).getAttribute("empId").toString(), "key");
            
            } else {
        manager = null;
            }
    %>
    <%
     if(manager != null){
            %>
    
                    <%
                for(int x = 0; x < manager.size(); x++){
                    WebBusinessObject empWbo = (WebBusinessObject) manager.elementAt(x);
                %>
                
                <%
                for(int i = 0; i < employeeList.size(); i++) {
                                wbo = (WebBusinessObject) employeeList.get(i);
                                if(sDesignation.equalsIgnoreCase(wbo.getAttribute("designation").toString())){
                %>
                <% if (empWbo.getAttribute("empName").toString().equals(wbo.getAttribute("empName").toString())){ %>
                
                <TR>
                    <TD  CLASS="cell" STYLE="padding-left:80;text-align:left;">
                        <DIV ID="links">
                            <A HREF="alert('');">
                                <%=wbo.getAttribute("empName")%> &nbsp;&nbsp;<B><font color="red"> Leader  </font></B>
                                
                                <SPAN>
                                </SPAN>
                            </A>
                        </DIV>
                    </TD>
                    
                    <TD  CLASS="cell" style="border-left">
                        <INPUT DISABLED TYPE="CHECKBOX" NAME="staff" value ="<%=wbo.getAttribute("empId")%>" CHECKED>
                    <input type="hidden" name="staff" value="<%=wbo.getAttribute("empId")%>">
                    </TD>
                    <input type="hidden" name="leader" value="1">
                </TR>
                <% } else { %>
                <TR>
                    <TD  CLASS="cell" STYLE="padding-left:80;text-align:left;">
                        <DIV ID="links">
                            <A HREF="alert('');">
                                <%=wbo.getAttribute("empName")%> &nbsp;&nbsp; <B><font color="blue">Staff </font></b>
                                <SPAN>
                                </SPAN>
                            </A>
                        </DIV>
                    </TD>
                    <TD  CLASS="cell" style="border-left">
                        <INPUT TYPE="CHECKBOX" NAME="staff" value ="<%=wbo.getAttribute("empId")%>">
                    </TD>
                    <input type="hidden" name="leader" value="0">
                </TR>
                <% } %>
                
                <%
                                }
                }
                }
                            }
                %>
                <%} %>
            </TABLE>   
       
            <!-- End  -->
            
            <% } %>
            <% } else { %>
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
                <TR VALIGN="MIDDLE">
                    <TD COLSPAN="2" CLASS="tabletitle" STYLE="border-left-WIDTH: 1;text-align:left;">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/user.gif">
                        Update Staff
                    </TD>
                    <TD CLASS="tabletitle" STYLE="">
                        <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
                    </TD>
                    <TD CLASS="tableright" colspan="3">
                        
                        <A HREF="<%=context%>/main.jsp">
                            <%=tGuide.getMessage("cancel")%>
                        </A>
                        <IMG VALIGN="BOTTOM" HEIGHT="10" WIDTH="1" SRC="images/line.gif">
                        <A HREF="JavaScript: submitForm();">
                            Update Staff
                        </A>
                    </TD>
                </TR>
            </TABLE>
            
            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>    
                
                
                <TR>
                    <TD class='td'>
                        <h3>Updating Staff for Staff Code '<font color="red"><%=crewCodeName%></font>'</h3>
                    </TD>
                </TR>
                
                <TR>
                        <TD class='td'>
                        <LABEL FOR="str_Level_Name">
                            <p><b><font color="#FF0000">*</font>Leader Crew :</b>&nbsp;
                        </LABEL>
                    
                        <%
                        ArrayList arrayEmpList = new ArrayList();
                        //maintainableMgr.cashData();
                        arrayEmpList = employeeMgr.getCashedTableAsBusObjects();
                        %>
                        
                        
                             <%
                        if(request.getParameter("manager") != null){
        LiteWebBusinessObject managerWbo = employeeMgr.getOnSingleKey(request.getParameter("manager"));
                        %>
                        <SELECT name="manager" onchange="refreshData();">
                            <sw:WBOOptionList wboList='<%=arrayEmpList%>' displayAttribute = "empName" valueAttribute="empId" scrollTo="<%=managerWbo.getAttribute("empName").toString()%>"/>
                            
                        </SELECT>
                        <%
                        } else {
                        %>
                        <SELECT name="manager" onchange="refreshData();">
                            <sw:WBOOptionList wboList='<%=arrayEmpList%>' displayAttribute = "empName" valueAttribute="empId"/>
                        </SELECT>
                        <%
                        }
                        %>
                        
                    </TD>
                    
                </TR>
                
            </TABLE>
            
            
            
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                <TR CLASS="head">
                    <TD nowrap CLASS="firstname" WIDTH="100" STYLE="border-top-WIDTH:0; font-size:12">
                        Emploee Name
                    </TD>
                    <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="33">
                        <B>
                            &nbsp;Select&nbsp;
                        </B>
                    </TD>
                </TR>       
                <%
                for(int j = 0; j < designation.size(); j++){
                            sDesignation = (String) designation.get(j);
                %>
                <TR>
                    <TD  CLASS="cell" STYLE="padding-left:20;text-align:left;">
                        <DIV ID="links">
                            <A HREF="alert('');">
                                <b><%=sDesignation%></b>
                                <SPAN>
                                </SPAN>
                            </A>
                        </DIV>
                    </TD>
                    <TD  CLASS="cell" style="border-left">
                        &nbsp;
                    </TD>
                </TR>
                 <%
            if(request.getParameter("manager") != null){
        manager = employeeMgr.getOnArbitraryKey(request.getParameter("manager"), "key");
            
            } else if(arrayEmpList != null){
        manager = employeeMgr.getOnArbitraryKey(((WebBusinessObject) arrayEmpList.get(0)).getAttribute("empId").toString(), "key");
            
            } else {
        manager = null;
            }
    %>
    <%
     if(manager != null){
            %>
    
                    <%
                for(int x = 0; x < manager.size(); x++){
                    WebBusinessObject empWbo = (WebBusinessObject) manager.elementAt(x);
                %>
                
                <%
                for(int i = 0; i < employeeList.size(); i++) {
                                wbo = (WebBusinessObject) employeeList.get(i);
                                if(sDesignation.equalsIgnoreCase(wbo.getAttribute("designation").toString())){
                %>
                <% if (empWbo.getAttribute("empName").toString().equals(wbo.getAttribute("empName").toString())){ %>
                
                <TR>
                    <TD  CLASS="cell" STYLE="padding-left:80;text-align:left;">
                        <DIV ID="links">
                            <A HREF="alert('');">
                                <%=wbo.getAttribute("empName")%> &nbsp;&nbsp;<B><font color="red"> Leader  </font></B>
                                
                                <SPAN>
                                </SPAN>
                            </A>
                        </DIV>
                    </TD>
                    
                    <TD  CLASS="cell" style="border-left">
                        <INPUT DISABLED  TYPE="CHECKBOX"  NAME="staff" value ="<%=wbo.getAttribute("empId")%>" CHECKED>
                        <input type="hidden" name="staff" value="<%=wbo.getAttribute("empId")%>">
                    </TD>
                    <input type="hidden" name="leader" value="1">
                </TR>
                <% } else { %>
                <TR>
                    <TD  CLASS="cell" STYLE="padding-left:80;text-align:left;">
                        <DIV ID="links">
                            <A HREF="alert('');">
                                <%=wbo.getAttribute("empName")%> &nbsp;&nbsp; <B><font color="blue">Staff </font></b>
                                <SPAN>
                                </SPAN>
                            </A>
                        </DIV>
                    </TD>
                    <TD  CLASS="cell" style="border-left">
                        <INPUT TYPE="CHECKBOX" NAME="staff" value ="<%=wbo.getAttribute("empId")%>">
                    </TD>
                    <input type="hidden" name="leader" value="0">
                </TR>
                <% } %>
                
                <%
                                }
                }
                }
                            }
                %>
                <%} %>
            </TABLE>   
            <input type="hidden" name="crewID" value="<%//=crewWBO.getAttribute("crewID").toString()%>">
            <%
            }
            %>
        </FORM>
    </BODY>
</HTML>     
