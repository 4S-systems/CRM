<%@ page import="com.silkworm.business_objects.secure_menu.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>

<HTML>
    
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    int iTotal = 0;
    %>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>New Group</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script src='ChangeLang.js' type='text/javascript'></script>
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function cancelForm()
        {    
        document.GROUP_FORM.action = "<%=context%>/GroupServlet?op=ListAll";
        document.GROUP_FORM.submit();  
        }
    </SCRIPT>
    
    <%
    TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
    
    HttpSession thisSession = request.getSession();
    ServletContext thisContext = thisSession.getServletContext();
    
    ThreeDimensionsContainer tdc = (ThreeDimensionsContainer) thisContext.getAttribute("myMenu");
    TwoDimensionMenu twoDContainer = new TwoDimensionMenu();
    
    
    ArrayList headers = tdc.getContents();
    ListIterator headersIterator = headers.listIterator();
    ListIterator contentsIterator = null;
    ArrayList contents = null;
    WebBusinessObjectsContainer wboc = null;
    WebBusinessObject wbo = null;
    
    WebBusinessObject group = (WebBusinessObject) request.getAttribute("group");
    String gMenu = (String) group.getAttribute("groupMenu");
    
    String check = null;
    String onOff = null;
    String pos = null;
    int intPos;
    int flipper = 0;
    String bgColor = null;
    
    UserGroupMgr ugMgr = UserGroupMgr.getInstance();
    Vector mem =  ugMgr.getGroupMembers((String) group.getAttribute("groupName"));
    String stat= (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    
    String saving_status;
    String sTitle,title_2;
    String sGroupName,sGroupDesc,sGroupType;
    String cancel_button_label;
    String save_button_label, sPadding, sMenu, sSelect;
    if(stat.equals("En")){
        
        saving_status="Saving status";
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        
        sGroupName="Group Name";
        sGroupDesc="Group Description";
        sTitle="View Group";
        title_2="All information are needed";
        cancel_button_label="Back To List";
        save_button_label="Save";
        langCode="Ar";
        sPadding = "left";
        sMenu = "Menu";
        sSelect = "Select";
        sGroupType="Type";
    }else{
        
        saving_status="&#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        
        
        
        sGroupName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
        sGroupDesc="&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
        sTitle="&#1605;&#1588;&#1575;&#1607;&#1583;&#1577; &#1605;&#1580;&#1605;&#1608;&#1593;&#1577;";
        title_2="&#1603;&#1604; &#1575;&#1604;&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        cancel_button_label="&#1593;&#1608;&#1583;&#1577;";
        save_button_label="&#1578;&#1587;&#1580;&#1610;&#1604;";
        langCode="En";
        sPadding = "right";
        sMenu = "&#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577;";
        sSelect = "&#1575;&#1582;&#1578;&#1575;&#1585;";
        sGroupType="&#x0627;&#x0644;&#x0645;&#x062C;&#x0645;&#x0648;&#x0639;&#x0647; &#x0627;&#x0644;&#x0625;&#x062F;&#x0627;&#x0631;&#x064A;&#x0647;";
    }
    %>
    
    <BODY>
        <FORM NAME="GROUP_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <!--<input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">-->
                <button    onclick="cancelForm()" class="button"><%=cancel_button_label%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
            </DIV>
            <fieldset class="set" align="center">
                <legend align="center">
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>
                            
                            <td class="td">
                                <font color="blue" size="6">    <%=sTitle%>                
                                </font>
                                
                            </td>
                        </tr>
                    </table>
                </legend>
                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" ALIGN="CENTER" DIR="<%=dir%>">
                    <TR>
                        <TD class='td'>
                            &nbsp;
                        </TD>
                    </TR>
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Group_Name">
                                <p><b><%=sGroupName%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <input disabled type="TEXT" name="groupName" ID="groupName" size="36" value="<%=group.getAttribute("groupName")%>" maxlength="255" style="width:230px;">
                        </TD>
                    </TR>
                    <%String type="";
                    if(group.getAttribute("defaultPage").equals("administrator.jsp")){
                        type="Administrator";
                    }else if(group.getAttribute("defaultPage").equals("manager_agenda.jsp")){
                        type="Middle Manager";
                    }else if(group.getAttribute("defaultPage").equals("employee_agenda.jsp")){
                        type="Employee";
                    }else if(group.getAttribute("defaultPage").equals("call_center.jsp")){
                        type="Call Center";
                    } else if (group.getAttribute("defaultPage").equals("marketing.jsp")) {
                        type = "Units";
                    } else if (group.getAttribute("defaultPage").equals("sub_div_manager_monitor.jsp")) {
                        type = "Sub Department Monitor";
                    } else if (group.getAttribute("defaultPage").equals("contracts_agenda.jsp")) {
                        type = "Contracts";
                    } else if (group.getAttribute("defaultPage").equals("global_notify_agenda.jsp")) {
                        type = "Global Notifications";
                    } else if (group.getAttribute("defaultPage").equals("purchase_agenda.jsp")) {
                        type = "Purchase";
                    } else if (group.getAttribute("defaultPage").equals("general_task_agenda.jsp")) {
                        type = "General Task";
                    } else if (group.getAttribute("defaultPage").equals("sla_agenda.jsp")) {
                        type = "Service Level Agreement";
                    } else if (group.getAttribute("defaultPage").equals("global_sla_agenda.jsp")) {
                        type = "Global Service Level Agreement";
                    } else if (group.getAttribute("defaultPage").equals("quality_agenda.jsp")) {
                        type = "Quality Manager";
                    } else if (group.getAttribute("defaultPage").equals("quality_assistant_agenda.jsp")) {
                        type = "Quality Assistant";
                    } else if (group.getAttribute("defaultPage").equals("site_tech_office_agenda.jsp")) {
                        type = "Site Tech Office";
                    } else if (group.getAttribute("defaultPage").equals("tech_office_request_agenda.jsp")) {
                        type = "Tech Office Request View";
                    } else if (group.getAttribute("defaultPage").equals("non_distributed_agenda.jsp")) {
                        type = "Non Distributed View";
                    } else if (group.getAttribute("defaultPage").equals("procurement_agenda.jsp")) {
                        type = "Procurement";
                    } else if (group.getAttribute("defaultPage").equals("procurement_requests.jsp")) {
                        type = "Procurement Requests";
                    } else if (group.getAttribute("defaultPage").equals("store_transactions.jsp")) {
                        type = "Store Transactions";
                    } else if (group.getAttribute("defaultPage").equals("general_complaint_agenda.jsp")) {
                        type = "General Complaint Form";
                    }else if (group.getAttribute("defaultPage").equals("customer_servies_agenda.jsp")) {
                        type = "CS Secretary";
                    } else if (group.getAttribute("defaultPage").equals("CHD_agenda.jsp")) {
                        type = "Client Help Desk";
                    } else if (group.getAttribute("defaultPage").equals("CHD_Manager.jsp")) {
                        type = "Client Help Desk Manager";
                    } else if (group.getAttribute("defaultPage").equals("jobOrderTrack.jsp")) {
                        type = "Customer Job Order Tracking";
                    } else if (group.getAttribute("defaultPage").equals("jOQualityAssurance.jsp")) {
                        type = "JO Quality Assurance";
                    } else if (group.getAttribute("defaultPage").equals("generic_contracts_agenda.jsp")) {
                        type = "Contracts Notifications";
                    } else if (group.getAttribute("defaultPage").equals("dep_contracts_agenda.jsp")) {
                        type = "Department's Contracts";
                    } else if (group.getAttribute("defaultPage").equals("client_class_2.jsp")) {
                        type = "Client Classifications";
                    } else if (group.getAttribute("defaultPage").equals("EmployeeSheet.jsp")) {
                        type = "Employee Affairs";
                    }
                    %>
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_Group_Type">
                                <p><b><%=sGroupType%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD class='td'>
                            <input disabled type="TEXT" name="type" ID="type" size="36" value="<%=type%>" maxlength="255" style="width:230px;">
                        </TD>
                    </TR>
                    
                    <TR>
                        <TD class='td'>
                            <LABEL FOR="str_group_Desc">
                                <p><b><%=sGroupDesc%>:</b>&nbsp;
                            </LABEL>
                        </TD>
                        <td class='td'>
                            <DIV class="textview" style="width:230px;<%=style%>">
                                <%=group.getAttribute("groupDesc")%>
                            </DIV>
                        </td>
                    </TR>
                </TABLE>
                <BR>
                <TABLE WIDTH="80%" ALIGN="center" DIR="<%=dir%>">
                    <TR>
                        <td class="td">
                            <TABLE  WIDTH="600"  CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;" ALIGN="CENTER" DIR="<%=dir%>">
                                <TR CLASS="head" STYLE="background:#9B9B00;">
                                    <TD CLASS="silver_header"  STYLE="border-top-WIDTH:0; font-size:14">
                                        <%=sMenu%>
                                    </TD>
                                    <TD CLASS="silver_header" VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;font-size:14" WIDTH="33">
                                        <B>
                                            &nbsp;<%=sSelect%>&nbsp;
                                        </B>
                                    </TD>
                                </TR>
                                <%
                                    com.silkworm.business_objects.secure_menu.MenuBuilder menuBuilder = new com.silkworm.business_objects.secure_menu.MenuBuilder();
                                    menuBuilder.setXslFile(metaMgr.getWebInfPath() + "/menu_view_group" + (stat.equalsIgnoreCase("Ar") ? "" : "_en") + ".xsl");
                                    menuBuilder.setFileURL(metaMgr.getWebInfPath() + "/menu.xml");
                                %>
                                <%=group.getAttribute("groupMenu") != null ? menuBuilder.buildMenu((String) group.getAttribute("groupMenu")) : ""%>
                                <input type="hidden" name="total" id="total" value="<%=iTotal%>">
                            </TABLE>
                        </td>
                        
                        <% if(mem!=null && mem.size() > 0 ){ %> 
                        <TD style="vertical-align:top;" nowrap class="td">
                            <TABLE  WIDTH="200"  CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;<%=style%>">
                                <TR CLASS="head" STYLE="background:#9B9B00;">
                                    <TD CLASS="silver_header"  STYLE="border-top-WIDTH:0; font-size:14;">
                                        <%=tGuide.getMessage("groupmembers")%>
                                    </TD>
                                </TR>
                                <%
                                Enumeration e = mem.elements();
                                while(e.hasMoreElements()) {
                                    wbo = (WebBusinessObject) e.nextElement();
                                    flipper++;
                                    if((flipper%2)==1)
                                        bgColor="silver_odd";
                                    else
                                        bgColor="silver_even";
                                %>
                                <TR bgcolor="#DDDD00">
                                    <TD nowrap  CLASS="<%=bgColor%>" STYLE="<%=style%>">
                                        <b><%=wbo.getAttribute("userName")%> </b>
                                    </TD>
                                </TR>
                                <%
                                
                                }
                                %>
                            </TABLE>
                        </TD>
                        <%
                        }
                        %>
                    </TR>
                </TABLE>
                <BR><BR>
            </fieldset>
        </FORM>
    </BODY>
</HTML>     
