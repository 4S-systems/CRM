
<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.maintenance.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
StaffCodeMgr staffCodeMgr = StaffCodeMgr.getInstance();
CrewMissionMgr crewMissionMgr = CrewMissionMgr.getInstance();


String context = metaMgr.getContext();

String status = (String) request.getAttribute("Status");

String crewID = (String) request.getAttribute("crewID");

WebBusinessObject wbo = null;
WebBusinessObject wbobasic = null;

TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
//WebBusinessObject crewWBO = (WebBusinessObject) request.getAttribute("crewWBO");
ArrayList employeeList = (ArrayList) request.getAttribute("employeeList");
ArrayList empbasicList = (ArrayList) request.getAttribute("empbasicList");
Vector designation = new Vector();
String sDesignation;
for(int i = 0; i < employeeList.size(); i++){
    wbo = (WebBusinessObject) employeeList.get(i);
    sDesignation = (String) wbo.getAttribute("designation");
    if(!designation.contains(sDesignation)){
        designation.add(sDesignation);
    }
}

ArrayList arrayList = new ArrayList();
staffCodeMgr.cashData();
arrayList = staffCodeMgr.getEmptyCrewCode();

String cMode= (String) request.getSession().getAttribute("currentMode");
String  stat=cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;

String er_mes="Saving didn't completed - code is repeated with other staff - choose another code";
String saving_status;
String field_1,field_2,field_3,staff_code;
String title_1,title_2;
String cancel_button_label;
String save_button_label, sNoCode;
if(stat.equals("En")){
    
    saving_status="Saving status";
    align="center";
    dir="LTR";
    style="text-align:left";
    lang="   &#1593;&#1585;&#1576;&#1610;    ";
    
    staff_code="Staff code";
    field_1="Choose";
    field_2="Employee name";
    title_1="Create crew staff";
    title_2="All information are needed";
    cancel_button_label="Cancel ";
    save_button_label="Save ";
    langCode="Ar";
    sNoCode = "No Data are available for " + staff_code;
    field_3 = "Employee Code";
}else{
    
    saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
    align="center";
    dir="RTL";
    style="text-align:Right";
    lang="English";
    
    er_mes="&#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1604;&#1605; &#1610;&#1603;&#1578;&#1605;&#1604; - &#1575;&#1604;&#1603;&#1608;&#1583; &#1605;&#1578;&#1603;&#1585;&#1585; &#1605;&#1593; &#1601;&#1585;&#1610;&#1602; &#1570;&#1582;&#1585; - &#1571;&#1582;&#1578;&#1575;&#1585; &#1603;&#1608;&#1583; &#1570;&#1582;&#1585;";
    staff_code="&#1603;&#1608;&#1583; &#1575;&#1604;&#1601;&#1585;&#1610;&#1602;";
    field_1="&nbsp&#1573;&#1582;&#1578;&#1575;&#1585;&nbsp;";
    field_2="&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;";
    
    title_1="&#1578;&#1603;&#1608;&#1610;&#1606; &#1601;&#1585;&#1610;&#1602; &#1593;&#1605;&#1604; ";
    title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    cancel_button_label="&#1573;&#1606;&#1607;&#1575;&#1569; ";
    save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604; ";
    langCode="En";
    sNoCode = "&#1604;&#1610;&#1587; &#1607;&#1606;&#1575;&#1603; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1578;&#1575;&#1581;&#1607; &#1604;" + staff_code;
    field_3="&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1608;&#1592;&#1601;";
    }

%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new user</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css"><LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {
        document.USERS_FORM.action = "<%=context%>/CrewMissionServlet?op=SaveStaff";
        document.USERS_FORM.submit();
        }

        function cancelForm()
        {    
        document.USERS_FORM.action = "main.jsp";
        document.USERS_FORM.submit();  
        }
    </SCRIPT>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        
        <FORM NAME="USERS_FORM" METHOD="POST">
            
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=cancel_button_label%><IMG VALIGN="BOTTOM"   SRC="images/cancel.gif"> </button>
                <%
                if(arrayList.size() > 0){
                %>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
                <%
                }
                %>
            </DIV> 
            <fieldset class="set" align="center">
            <legend align="center">
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        
                        <td class="td">
                            <font color="blue" size="6">    <%=title_1%>                
                            </font>
                            
                        </td>
                    </tr>
                </table>
            </legend>
            
            <%
            if(arrayList.size() == 0) {
            %>
            <BR><center><font color="red"><B><%=sNoCode%></B></font></center>
            <%
            }
            %>
            <%
            if(null!=status) {
            
            %>
            <% if(status.equals("Ok")) {%>
            
            
            <table dir="<%=dir%>" align="<%=align%>">
                <tr>
                    
                    <td  CLASS="td" style="<%=style%>">  <b><font size=4 > <%=saving_status%> : <%=status%> </font></b></td>
                    
            </tr> </table>
            <br><br>
            <TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                
                <TR>
                    <TD dir="<%=dir%>" STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Level_Name">
                            <p><b><%=staff_code%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                        <SELECT STYLE="width:230px;<%=style%>" name="staffCode">
                            <sw:WBOOptionList wboList='<%=arrayList%>' displayAttribute = "crewStaffName" valueAttribute="id"/>
                            
                        </SELECT>
                    </TD>
                </TR>
                
            </TABLE>
            
            <br><br>
            <%/*starting of the info table is here ----> amr*/%>
            <TABLE  dir="<%=dir%>" align="<%=align%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                <TR CLASS="head">
                    <TD DIR="<%=dir%>" nowrap CLASS="firstname" WIDTH="100" STYLE="<%=style%>; border-top-WIDTH:0; font-size:12">
                        <%=field_2%>
                    </TD>
                    <TD DIR="<%=dir%>" nowrap CLASS="firstname" WIDTH="100" STYLE="<%=style%>; border-top-WIDTH:0; font-size:12">
                        <%=field_3%>
                    </TD>
                    <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="33">
                        <B>
                            <%=field_1%>
                        </B>
                    </TD>
                </TR>       
                <%
               // for(int j = 0; j < designation.size(); j++){
                  //  sDesignation = (String) designation.get(j);
                %>
                <!--TR>
                    <TD  CLASS="cell" STYLE="<%//=style%>;" BGCOLOR="ffffcc">
                        
                        <b><%//=sDesignation%></b>
                        <SPAN>
                        </SPAN>
                        
                    </TD>
                    <TD BGCOLOR="ffffcc" CLASS="cell" style="border-left">
                        &nbsp;
                    </TD>
                </TR-->
                <%
               // for(int i = 0; i < employeeList.size(); i++) {
                    //    wbo = (WebBusinessObject) employeeList.get(i);
                          %>
                <!--TR>
                    <TD  CLASS="cell" STYLE="<%//=style%>;" >
                        
                        <%//=wbo.getAttribute("empName")%>
                        <SPAN>
                        </SPAN>
                        
                    </TD>
                    <TD  CLASS="cell" STYLE="<%//=style%>;" >
                        
                        <%//=wbo.getAttribute("empId")%>
                        <SPAN>
                        </SPAN>
                        
                    </TD>
                    <TD  CLASS="cell" WIDTH="7%" style="<%//=style%>" ALIGN="<%//=align%>" >
                        <INPUT TYPE="CHECKBOX" NAME="staff" value ="<%//=wbo.getAttribute("empId")%>">
                        
                    </TD>
                </TR-->
                <%
                     
               // }
               
                %>
                <%
                for(int i = 0; i < empbasicList.size(); i++) {
                        wbobasic = (WebBusinessObject) empbasicList.get(i);
                        //if(sDesignation.equalsIgnoreCase(wbo.getAttribute("designation").toString())){
                %>
                <TR>
                    <TD  CLASS="cell" STYLE="<%=style%>;" >
                        
                        <%=wbobasic.getAttribute("empName")%>
                        <SPAN>
                        </SPAN>
                        
                    </TD>
                    <TD  CLASS="cell" STYLE="<%=style%>;" >
                        
                        <%=wbobasic.getAttribute("empId")%>
                        <SPAN>
                        </SPAN>
                        
                    </TD>
                    <TD  CLASS="cell" WIDTH="7%" style="<%=style%>" ALIGN="<%=align%>" >
                        <INPUT TYPE="CHECKBOX" NAME="staff" value ="<%=wbobasic.getAttribute("empId")%>">
                        
                    </TD>
                </TR>
                <%
                     //   }
                }
                //}
                %>
            </TABLE>
            
            <%
            
            } else if(status.equals("Double")) {
            
            %>
            
            <table dir="<%=dir%>" align="<%=align%>" ><tr><td style="<%=style%>" class="td">
                        <p><font color="#800000"><span style="font-family: Times New Roman"><%=er_mes%></span></font></p>
            </td></tr></table>
            <!-- Begin -->
            <br><br>
            <TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                
                <TR>
                    <TD dir="<%=dir%>" STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Level_Name">
                            <p><b><%=staff_code%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                        <SELECT STYLE="width:230px;<%=style%>" name="staffCode">
                            <sw:WBOOptionList wboList='<%=arrayList%>' displayAttribute = "crewStaffName" valueAttribute="id"/>
                            
                        </SELECT>
                    </TD>
                </TR>
                
            </TABLE>
            
            <br><br>
            <%/*starting of the info table is here ----> amr*/%>
            <TABLE  dir="<%=dir%>" align="<%=align%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                <TR CLASS="head">
                    <TD DIR="<%=dir%>" nowrap CLASS="firstname" WIDTH="100" STYLE="<%=style%>; border-top-WIDTH:0; font-size:12">
                        <%=field_2%>
                    </TD>
                    <TD DIR="<%=dir%>" nowrap CLASS="firstname" WIDTH="100" STYLE="<%=style%>; border-top-WIDTH:0; font-size:12">
                        <%=field_3%>
                    </TD>
                    <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="33">
                        <B>
                            <%=field_1%>
                        </B>
                    </TD>
                </TR>       
                <%
                //for(int j = 0; j < designation.size(); j++){
                   // sDesignation = (String) designation.get(j);
                %>
                <!--TR>
                    <TD  CLASS="cell" STYLE="<%//=style%>;" BGCOLOR="ffffcc">
                        
                        <b><%//=sDesignation%></b>
                        <SPAN>
                        </SPAN>
                        
                    </TD>
                    <TD BGCOLOR="ffffcc" CLASS="cell" style="border-left">
                        &nbsp;
                    </TD>
                </TR-->
                <%
              //  for(int i = 0; i < employeeList.size(); i++) {
                 //       wbo = (WebBusinessObject) employeeList.get(i);
                           %>
                <!--TR>
                    <TD  CLASS="cell" STYLE="<%//=style%>;" >
                        
                        <%//=wbo.getAttribute("empName")%>
                        <SPAN>
                        </SPAN>
                        
                    </TD>
                    <TD  CLASS="cell" STYLE="<%//=style%>;" >
                        
                        <%//=wbo.getAttribute("empId")%>
                        <SPAN>
                        </SPAN>
                        
                    </TD>
                    <TD  CLASS="cell" WIDTH="7%" style="<%//=style%>" ALIGN="<%//=align%>" >
                        <INPUT TYPE="CHECKBOX" NAME="staff" value ="<%//=wbo.getAttribute("empId")%>">
                        
                    </TD>
                </TR-->
                <%
                    
              //  }
                
                %>
                <%
                for(int i = 0; i < empbasicList.size(); i++) {
                        wbobasic = (WebBusinessObject) empbasicList.get(i);
                        //if(sDesignation.equalsIgnoreCase(wbo.getAttribute("designation").toString())){
                %>
                <TR>
                    <TD  CLASS="cell" STYLE="<%=style%>;" >
                        
                        <%=wbobasic.getAttribute("empName")%>
                        <SPAN>
                        </SPAN>
                        
                    </TD>
                    <TD  CLASS="cell" STYLE="<%=style%>;" >
                        
                        <%=wbobasic.getAttribute("empId")%>
                        <SPAN>
                        </SPAN>
                        
                    </TD>
                    <TD  CLASS="cell" WIDTH="7%" style="<%=style%>" ALIGN="<%=align%>" >
                        <INPUT TYPE="CHECKBOX" NAME="staff" value ="<%=wbobasic.getAttribute("empId")%>">
                        
                    </TD>
                </TR>
                <%
                     //   }
                }
                //}
                %>
            </TABLE>     
            <input type="hidden" name="crewID" value="<%//=crewWBO.getAttribute("crewID").toString()%>">
            
            <!-- End  -->
            
            <% } %>
            <% } else {/* begin of starting the page from business admin menu       amr*/ %>
            
            <br><br>
            <TABLE dir="<%=dir%>" align="<%=align%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                
                <TR>
                    <TD dir="<%=dir%>" STYLE="<%=style%>" class='td'>
                        <LABEL FOR="str_Level_Name">
                            <p><b><%=staff_code%><font color="#FF0000">*</font></b>&nbsp;
                        </LABEL>
                        <SELECT STYLE="width:230px;<%=style%>" name="staffCode">
                            <sw:WBOOptionList wboList='<%=arrayList%>' displayAttribute = "crewStaffName" valueAttribute="id"/>
                            
                        </SELECT>
                    </TD>
                </TR>
                
            </TABLE>
            
            <br><br>
            <%/*starting of the info table is here ----> amr*/%>
            <TABLE  dir="<%=dir%>" align="<%=align%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                <TR CLASS="head">
                    <TD DIR="<%=dir%>" nowrap CLASS="firstname" WIDTH="100" STYLE="<%=style%>; border-top-WIDTH:0; font-size:12">
                        <%=field_2%>
                    </TD>
                    <TD DIR="<%=dir%>" nowrap CLASS="firstname" WIDTH="100" STYLE="<%=style%>; border-top-WIDTH:0; font-size:12">
                        <%=field_3%>
                    </TD>
                    <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="33">
                        <B>
                            <%=field_1%>
                        </B>
                    </TD>
                </TR>       
                <%
                //for(int j = 0; j < designation.size(); j++){
                    //sDesignation = (String) designation.get(j);
                %>
                <!--TR>
                    <TD  CLASS="cell" STYLE="<%//=style%>;" BGCOLOR="ffffcc">
                        
                        <b><%//=sDesignation%></b>
                        <SPAN>
                        </SPAN>
                        
                    </TD>
                    <TD BGCOLOR="ffffcc" CLASS="cell" style="border-left">
                        &nbsp;
                    </TD>
                </TR-->
                <%
               // for(int i = 0; i < employeeList.size(); i++) {
               //         wbo = (WebBusinessObject) employeeList.get(i);
                            %>
                <!--TR>
                    <TD  CLASS="cell" STYLE="<%//=style%>;" >
                        
                        <%//=wbo.getAttribute("empName")%>
                        <SPAN>
                        </SPAN>
                        
                    </TD>
                    <TD  CLASS="cell" STYLE="<%//=style%>;" >
                        
                        <%//=wbo.getAttribute("empId")%>
                        <SPAN>
                        </SPAN>
                        
                    </TD>
                    <TD  CLASS="cell" WIDTH="7%" style="<%//=style%>" ALIGN="<%//=align%>" >
                        <INPUT TYPE="CHECKBOX" NAME="staff" value ="<%//=wbo.getAttribute("empId")%>">
                        
                    </TD>
                </TR-->
                <%
                    
               // }
                
                %>
                
                 <%
                for(int i = 0; i < empbasicList.size(); i++) {
                        wbobasic = (WebBusinessObject) empbasicList.get(i);
                        //if(sDesignation.equalsIgnoreCase(wbo.getAttribute("designation").toString())){
                %>
                <TR>
                    <TD  CLASS="cell" STYLE="<%=style%>;" >
                        
                        <%=wbobasic.getAttribute("empName")%>
                        <SPAN>
                        </SPAN>
                        
                    </TD>
                    <TD  CLASS="cell" STYLE="<%=style%>;" >
                        
                        <%=wbobasic.getAttribute("empId")%>
                        <SPAN>
                        </SPAN>
                        
                    </TD>
                    <TD  CLASS="cell" WIDTH="7%" style="<%=style%>" ALIGN="<%=align%>" >
                        <INPUT TYPE="CHECKBOX" NAME="staff" value ="<%=wbobasic.getAttribute("empId")%>">
                        
                    </TD>
                </TR>
                <%
                     //   }
                }
                //}
                %>
                
            </TABLE>   
            <input type="hidden" name="crewID" value="<%//=crewWBO.getAttribute("crewID").toString()%>">
            <%
            }
            %>
        </FORM>
        <br><br><br>
    </BODY>
</HTML>     

