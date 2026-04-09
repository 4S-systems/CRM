
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <%
    UserMgr userMgr = UserMgr.getInstance();
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    String message = (String) request.getAttribute("message");
    String stat = (String) request.getSession().getAttribute("currentMode");
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode, sTitle, sCancel;
    if(stat.equals("En")){
        
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        sCancel="Cancel";
        sTitle="Search for Job Order";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        sCancel = tGuide.getMessage("cancel");
        sTitle = "&#1576;&#1581;&#1579; &#1593;&#1606; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
    }
    
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <SCRIPT language="JavaScript" type="text/javascript">
            var req;
            function convertToXML( ) {
                var key = document.getElementById("searchID");
                var url = "<%=context%>/IssueServlet?op=GetXML&key=" + escape(key.value);
                if (window.XMLHttpRequest) {
                    req = new XMLHttpRequest( );
                }
                else if (window.ActiveXObject) {
                    req = new ActiveXObject("Microsoft.XMLHTTP");
                }
                req.open("Get",url,true);
                req.onreadystatechange = callback;
                req.send(null);
            }
            
            function nonMSPopulate( ) {
                xmlDoc = document.implementation.createDocument("","", null);
                var resp = req.responseText;
                var parser = new DOMParser( );
                var dom = parser.parseFromString(resp,"text/xml");
                if(dom != null){
                    var val = dom.getElementsByTagName("issueTitle");
                    document.getElementById('issueTitle').value = val[0].childNodes[0].nodeValue;
                    var val0 = dom.getElementsByTagName("workTrade");
                    document.getElementById('workTrade').value = val0[0].childNodes[0].nodeValue;
                    var val5 = dom.getElementsByTagName("estimatedduration");
                    document.getElementById('estimatedduration').value = val5[0].childNodes[0].nodeValue;
                    var val6 = dom.getElementsByTagName("issueDesc");
                    document.getElementById('issueDesc').value = val6[0].childNodes[0].nodeValue;
                    var val1 = dom.getElementsByTagName("issueType");
                    document.getElementById('typeName').value = val1[0].childNodes[0].nodeValue;
                    var val2 = dom.getElementsByTagName("businessID");
                    document.getElementById('id').value = val2[0].childNodes[0].nodeValue;
                    var val3 = dom.getElementsByTagName("currentStatus");
                    document.getElementById('currentStatus').value = val3[0].childNodes[0].nodeValue;
                    var val4 = dom.getElementsByTagName("expectedEndDate");
                    document.getElementById('expectedEndDate').value = val4[0].childNodes[0].nodeValue;
                    var val7 = dom.getElementsByTagName("assignedBy");
                    if(val7[0].childNodes[0].nodeValue == 'UL')
                    {
                        document.getElementById('assignedByName').value = 'Has not been specified';
                    } else {
                        document.getElementById('assignedByName').value = val7[0].childNodes[0].nodeValue;
                    }
                    var val8 = dom.getElementsByTagName("receivedBy");
                    document.getElementById('Receivedby').value = val8[0].childNodes[0].nodeValue;
                    var val9 = dom.getElementsByTagName("creationTime");
                    document.getElementById('CREATION_TIME').value = val9[0].childNodes[0].nodeValue;
                    var val10 = dom.getElementsByTagName("expectedBeginDate");
                    document.getElementById('expectedBeginDate').value = val10[0].childNodes[0].nodeValue;
                    var val11 = dom.getElementsByTagName("finishTime");
                    document.getElementById('finishTime').value = val11[0].childNodes[0].nodeValue;
                    var val12 = dom.getElementsByTagName("createdByName");
                    document.getElementById('createdBy').value = val12[0].childNodes[0].nodeValue;
                    var val13 = dom.getElementsByTagName("failureCode");
                    document.getElementById('failureCode').value = val13[0].childNodes[0].nodeValue;
                    var val14 = dom.getElementsByTagName("urgencyLevel");
                    document.getElementById('urgencyLevel').value = val14[0].childNodes[0].nodeValue;
                    var val15 = dom.getElementsByTagName("siteName");
                    document.getElementById('siteName').value = val15[0].childNodes[0].nodeValue;
                    document.getElementById('message').innerHTML = "";
                } else {
                    document.getElementById('issueTitle').value = "";
                    document.getElementById('workTrade').value = "";
                    document.getElementById('estimatedduration').value = "";
                    document.getElementById('issueDesc').value = "";
                    document.getElementById('typeName').value = "";
                    document.getElementById('id').value = "";
                    document.getElementById('currentStatus').value = "";
                    document.getElementById('expectedEndDate').value = "";
                    document.getElementById('assignedByName').value = "";
                    document.getElementById('Receivedby').value = "";
                    document.getElementById('CREATION_TIME').value = "";
                    document.getElementById('expectedBeginDate').value = "";
                    document.getElementById('finishTime').value = "";
                    document.getElementById('createdBy').value = "";
                    document.getElementById('failureCode').value = "";
                    document.getElementById('urgencyLevel').value = "";
                    document.getElementById('siteName').value = "";
                    document.getElementById('message').innerHTML = "&#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1594;&#1610;&#1585; &#1605;&#1608;&#1580;&#1608;&#1583;";
                }
            }
            
            function msPopulate( ) {
                var resp = req.responseText;
                var xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
                xmlDoc.async="false";
                xmlDoc.loadXML(resp);
                if(xmlDoc.documentElement != null){
                //alert("not null");
                    nodes=xmlDoc.documentElement.childNodes;
                    dec = xmlDoc.getElementsByTagName('decimal');
                    var val = xmlDoc.getElementsByTagName("issueTitle");
                    document.getElementById('issueTitle').value = val[0].firstChild.data;
                    var val0 = xmlDoc.getElementsByTagName("workTrade");
                    
                    document.getElementById('workTrade').value = val0[0].firstChild.data;
                   
                    var val1 = xmlDoc.getElementsByTagName("issueType");
                    document.getElementById('typeName').value = val1[0].firstChild.data;
                    var val2 = xmlDoc.getElementsByTagName("businessID");
                    document.getElementById('id').value = val2[0].firstChild.data;
                    var val3 = xmlDoc.getElementsByTagName("currentStatus");
                    document.getElementById('currentStatus').value = val3[0].firstChild.data;
                    var val4 = xmlDoc.getElementsByTagName("expectedEndDate");
                    document.getElementById('expectedEndDate').value = val4[0].firstChild.data;
                    
                     var val5 = xmlDoc.getElementsByTagName("estimatedduration");
                    document.getElementById('estimatedduration').value = val5[0].firstChild.data;
                    var val6 = xmlDoc.getElementsByTagName("issueDesc");
                    document.getElementById('issueDesc').value = val6[0].firstChild.data;
                    
                    var val7 = xmlDoc.getElementsByTagName("assignedBy");
                    if(val7[0].firstChild.data == 'UL')
                    {
                        document.getElementById('assignedByName').value = 'Has not been specified';
                    } else {
                        document.getElementById('assignedByName').value = val7[0].firstChild.data;
                    }
                    var val8 = xmlDoc.getElementsByTagName("receivedBy");
                    //alert("dddddddddddddd"+ val8[0].firstChild.data);
                    
                    document.getElementById('Receivedby').value = val8[0].firstChild.data;
                    var val9 = xmlDoc.getElementsByTagName("creationTime");
                    document.getElementById('CREATION_TIME').value = val9[0].firstChild.data;
                    var val10 = xmlDoc.getElementsByTagName("expectedBeginDate");
                    document.getElementById('expectedBeginDate').value = val10[0].firstChild.data;
                    var val11 = xmlDoc.getElementsByTagName("finishTime");
                    document.getElementById('finishTime').value = val11[0].firstChild.data;
                    var val12 = xmlDoc.getElementsByTagName("createdByName");
                    document.getElementById('createdBy').value = val12[0].firstChild.data;
                    var val13 = xmlDoc.getElementsByTagName("failureCode");
                    //alert( val8[0].firstChild.data);
                    document.getElementById('failureCode').value = val13[0].firstChild.data;
                    var val14 = xmlDoc.getElementsByTagName("urgencyLevel");
                    document.getElementById('urgencyLevel').value = val14[0].firstChild.data;
                    var val15 = xmlDoc.getElementsByTagName("siteName");
                    document.getElementById('siteName').value = val15[0].firstChild.data;
                    document.getElementById('message').innerHTML = "";
                } else {
                                //alert("null null null null");
                    document.getElementById('issueTitle').value = "";
                    document.getElementById('workTrade').value = "";
                    document.getElementById('estimatedduration').value = "";
                    document.getElementById('issueDesc').value = "";
                    document.getElementById('typeName').value = "";
                    document.getElementById('id').value = "";
                    document.getElementById('currentStatus').value = "";
                    document.getElementById('expectedEndDate').value = "";
                    document.getElementById('assignedByName').value = "";
                    document.getElementById('Receivedby').value = "";
                    document.getElementById('CREATION_TIME').value = "";
                    document.getElementById('expectedBeginDate').value = "";
                    document.getElementById('finishTime').value = "";
                    document.getElementById('createdBy').value = "";
                    document.getElementById('failureCode').value = "";
                    document.getElementById('urgencyLevel').value = "";
                    document.getElementById('siteName').value = "";
                    document.getElementById('message').innerHTML = " &#1571;&#1605;&#1585; &#1588;&#1594;&#1604; &#1594;&#1610;&#1585; &#1605;&#1608;&#1580;&#1608;&#1583;";
                }
            }
            
            function callback( ) {
                if (req.readyState==4) {
                    if (req.status == 200) {
                        if (window.ActiveXObject) {
                            msPopulate( );
                        }
                        else if (window.XMLHttpRequest) {
                            nonMSPopulate( );
                        }
                    }
                }
                clear( );
            }
            
            function clear( ) {
                var key = document.getElementById("searchID");
                key.value="";
            }
            
            function populateJSON( ) {
                var jsonData = req.responseText;
                var myJSONObject = eval('(' + jsonData + ')');
                var decimal = document.getElementById('decimal');
                decimal.value=myJSONObject.conversion.decimal;
                var hexadecimal = document.getElementById('hexadecimal');
                hexadecimal.value=myJSONObject.conversion.hexadecimal;
                var octal = document.getElementById('octal');
                octal.value=myJSONObject.conversion.octal;
                var binary = document.getElementById('bin');
                binary.value=myJSONObject.conversion.binary;
                var hyper = document.getElementById('hyper');
                hyper.value=myJSONObject.conversion.hyper;
            }
            
            function cancelForm()
            {    
                document.ISSUE_FORM.action = "main.jsp";
                document.ISSUE_FORM.submit();  
            }
    </SCRIPT>
    
    <script src='ChangeLang.js' type='text/javascript'></script>
    
    
    
    <BODY>
        
        
        <FORM NAME="ISSUE_FORM" METHOD="POST">
            
            
            
            <DIV align="left" STYLE="color:blue;">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"> </button>
            </DIV> 
            <BR>
            <fieldset class="set" align="center">
                <legend align="center">
                    <table dir="<%=dir%>" align="center">
                        <tr>
                            <td class="td">
                                <font color="blue" size="6">
                                    <%=sTitle%>
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <%    
                if(message != null) {
                %>
                
                <table  dir="<%=dir%>">
                    <tr>
                        <td class="td"  align="<%=align%>">
                            <H4><font color="red"><%=message%></font></H4>
                        </td>
                    </tr>
                </table>
                <br><br>
                <%
                }
                %>
                <TABLE ALIGN="<%=align%>" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td' >
                            <LABEL FOR="Project_Name">
                                <p><b>Search by Job Order ID / &#1576;&#1581;&#1579; &#1576;&#1585;&#1602;&#1605; &#1571;&#1605;&#1585; &#1575;&#1604;&#1588;&#1594;&#1604;</b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <table border="0" dir="<%=dir%>">
                                <tr>
                                    <td class="td">
                                        <input type="TEXT" value="" id="searchID" name="searchID" onchange="convertToXML( );">
                                    </td>
                                    <td class="td">
                                        <div style="cursor: hand"><font size="4">&#1604;&#1604;&#1576;&#1581;&#1579; &#1575;&#1590;&#1594;&#1591; &#1607;&#1606;&#1575;</font></div>
                                    </td>
                                </tr>
                            </table>
                        </TD>
                    </TR>                         
                </TABLE>
                <INPUT ALIGN="<%=align%>" dir="<%=dir%>" TYPE="hidden" name="filterValue" value="">
                <TABLE  ALIGN="<%=align%>"dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                    <TR>
                        <TD class="td">
                            &nbsp;
                            <div id="message" style="color:red; font-size:18"></div>
                        </TD>
                    </TR>
                </TABLE>
                
                <br><br>
                <hr>
                <center ><b> Result / &#1575;&#1604;&#1606;&#1578;&#1610;&#1580;&#1607; </b></center>
                <hr>
                
                <TABLE ALIGN="<%=align%>"  CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="<%=dir%>">
                    
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="ISSUE_TITLE">
                                <p><b><font color="#003399">Maintenance No# / &#1585;&#1602;&#1605; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="id" ID="id" size="20" value="<%//= (String) webIssue.getAttribute("id")%>" maxlength="255">
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="ISSUE_TITLE">
                                <p><b><font color="#003399">Task Name / &#1573;&#1587;&#1605; &#1580;&#1583;&#1608;&#1604; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="issueTitle" ID="issueTitle" size="20" value="<%//=MaintenanceTitle%>" maxlength="255">
                        </TD>
                    </TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="ISSUE_TITLE">
                                <p><b><font color="#003399">Received by /&#1571;&#1587;&#1578;&#1604;&#1605;&#1578; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="Receivedby" ID="Receivedby" size="20" value="<%//=Receivedby%>" maxlength="255">
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="ISSUE_TITLE">
                                <p><b><font color="#003399">Work Order Trade / &#1571;&#1605;&#1585; &#1575;&#1604;&#1593;&#1605;&#1604;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="workTrade" ID="workTrade" size="20" value="<%//= (String) webIssue.getAttribute("workTrade")%>" maxlength="255">
                        </TD>
                    </TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="ISSUE_TITLE">
                                <p><b><font color="#003399">Failure Code / &#1575;&#1604;&#1603;&#1608;&#1583;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="failureCode" ID="failureCode" size="20" value="" maxlength="255">
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="Project_Name">
                                <p><b><font color="#003399">Site Name / &#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="siteName" ID="siteName" size="20" value="" maxlength="255">
                        </TD>
                    </TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="Project_Name">
                                <p><b><font color="#003399">Urgency Level / &#1583;&#1585;&#1580;&#1577; &#1575;&#1604;&#1571;&#1607;&#1605;&#1610;&#1607;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="urgencyLevel" ID="urgencyLevel" size="20" value="<%//=UrgencyLevel%>" maxlength="255">
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="estimated_duration">
                                <p><b><font color="#003399">Estimated Duration/Hours /&#1575;&#1604;&#1608;&#1602;&#1578; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593; &#1576;&#1575;&#1604;&#1587;&#1575;&#1593;&#1607;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="estimatedduration" ID="estimatedduration" size="5" value="<%//= (String) webIssue.getAttribute("estimatedduration")%>" maxlength="255">
                        </TD>
                    </TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_IssueType_Name">
                                <p><b><font color="#003399">Job Type / &#1606;&#1608;&#1593; &#1575;&#1604;&#1593;&#1605;&#1604;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="typeName" ID="typeName" size="20" value="<%//= (String) webIssue.getAttribute("issueType")%>" maxlength="255">
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_User_Name">
                                <p><b><font color="#003399"><%=tGuide.getMessage("createdby")%> / &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <%
                        //createdBy= issueMgr.getCreateBy(createdBy);
                        %>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="createdBy" ID="createdBy" size="20" value="<%//= createdBy%>" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TD class='td'>
                        &nbsp;
                    </TD>
                    
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_current_status">
                                <p><b><font color="#003399"><%=tGuide.getMessage("currentstatus")%> / &#1575;&#1604;&#1581;&#1575;&#1604;&#1607; &#1575;&#1604;&#1581;&#1575;&#1604;&#1610;&#1577;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="currentStatus" ID="currentStatus" size="20" value="<%//= (String) webIssue.getAttribute("currentStatus")%>" maxlength="255">
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_creation_time">
                                <p><b><font color="#003399"><%=tGuide.getMessage("creationtime")%> / &#1608;&#1602;&#1578; &#1575;&#1604;&#1573;&#1606;&#1588;&#1575;&#1569;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="CREATION_TIME" ID="CREATION_TIME" size="20" value="<%//= (String) webIssue.getAttribute("currentStatusSince")%>" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TD class='td'>
                        &nbsp;
                    </TD>
                    
                    <TR>
                        
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_assigned_by">
                                <p><b><font color="#003399"><%=tGuide.getMessage("assignedby")%> / &#1587;&#1604;&#1605; &#1576;&#1608;&#1575;&#1587;&#1591;&#1577;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <%
                        //if(! AssignByName.equals("UL")){
                        
                        %>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="assignedByName" ID="assignedByName" size="20" value="<%//=AssignByName%>" maxlength="255">
                        </TD>
                        <%// } else {
                        //  AssignByName="Not assigned";
                        %>
                        <!--TD class='td'>   
                        <input disabled type="TEXT" name="assignedByName" ID="assignedByName" size="20" value="<%//=AssignByName%>" maxlength="255">
                        <% //}%>
                        
                    </TD-->
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="EXPECTED_B_DATE">
                                <p><b><font color="#003399"><%=tGuide.getMessage("expectedbdate")%> /&#1608;&#1602;&#1578; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593; </font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="expectedBeginDate" ID="expectedBeginDate" size="20" value="<%//= (String) webIssue.getAttribute("expectedBeginDate")%>" maxlength="255">
                        </TD>
                    </TR>
                    
                    <TD class='td'>
                        &nbsp;
                    </TD>
                    
                    <TR>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="EXPECTED_E_DATE">
                                <p><b><font color="#003399"><%=tGuide.getMessage("expectededate")%> / &#1608;&#1602;&#1578; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1607; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="expectedEndDate" ID="expectedEndDate" size="20" value="<%//= (String) webIssue.getAttribute("expectedEndDate")%>" maxlength="255">
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_finshed_time">
                                <p><b><font color="#003399"><%=tGuide.getMessage("finishedtime")%>/Hours / &#1608;&#1602;&#1578; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1607; &#1576;&#1575;&#1604;&#1587;&#1575;&#1593;&#1607;</font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <%
                        //if(! FinishTime.equals("0")){
                        %>
                        <TD STYLE="<%=style%>" class='td'>
                            <input disabled type="TEXT" name="finishTime" ID="finishTime" size="20" value="<%//=FinishTime%>" maxlength="255">
                        </TD>
                        
                        <% //}else {
                        // FinishTime="Has not been specified ";
                        
                        %>
                        
                        <!--TD class='td'>
                        <input disabled type="TEXT" name="finishedTime" ID="finishedTime" size="20" value="<%//=FinishTime%>" maxlength="255">
                    </TD-->
                    </TR>
                    <% //}%>
                    
                    <TD class='td'>
                        &nbsp;
                    </TD>
                    <TR>
                        
                        <TD STYLE="<%=style%>" class='td'>
                            <LABEL FOR="str_Maintenance_Desc">
                                <p><b><font color="#003399">Problem Description / &#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1588;&#1603;&#1604;&#1577;</font> </b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD STYLE="<%=style%>" class='td'>
                            <TEXTAREA disabled rows="5" name="issueDesc" cols="25"> <%//= (String) webIssue.getAttribute("issueDesc")%></TEXTAREA>
                        </TD>
                        
                    </TR>
                </TABLE>
                <BR>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
