
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
        sTitle="Search for Spare Part";
    }else{
        
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        sCancel = tGuide.getMessage("cancel");
        sTitle = "&#1576;&#1581;&#1579; &#1593;&#1606; &#1602;&#1591;&#1593;&#1577; &#1594;&#1610;&#1575;&#1585;";
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
                var url = "<%=context%>/ItemsServlet?op=GetXML&key=" + escape(key.value);
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
                    var val = dom.getElementsByTagName("categoryName");
                    document.getElementById('categoryName').value = val[0].childNodes[0].nodeValue;
                    var val2 = dom.getElementsByTagName("itemDscrptn");
                    document.getElementById('itemDscrptn').value = val2[0].childNodes[0].nodeValue;
                    var val3 = dom.getElementsByTagName("itemCode");
                    document.getElementById('itemCode').value = val3[0].childNodes[0].nodeValue;
                    var val4 = dom.getElementsByTagName("itemUnit");
                    document.getElementById('itemUnit').value = val4[0].childNodes[0].nodeValue;
                    var val5 = dom.getElementsByTagName("storeName");
                    document.getElementById('storeName').value = val5[0].childNodes[0].nodeValue;
                    var val6 = dom.getElementsByTagName("itemUnitPrice");
                    document.getElementById('itemUnitPrice').value = val6[0].childNodes[0].nodeValue;
                    document.getElementById('message').innerHTML = "";
                } else {
                    document.getElementById('categoryName').value = "";
                    document.getElementById('workTrade').value = "";
                    document.getElementById('estimatedduration').value = "";
                    document.getElementById('issueDesc').value = "";
                    document.getElementById('typeName').value = "";
                    document.getElementById('id').value = "";
                    document.getElementById('message').innerHTML = "&#1602;&#1591;&#1593;&#1577; &#1594;&#1610;&#1575;&#1585; &#1594;&#1610;&#1585; &#1605;&#1608;&#1580;&#1608;&#1583;&#1577;";
                }
            }
            
            function msPopulate( ) {
                var resp = req.responseText;
                var xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
                xmlDoc.async="false";
                xmlDoc.loadXML(resp);
                if(xmlDoc.documentElement != null){
                    nodes=xmlDoc.documentElement.childNodes;
                    var val = xmlDoc.getElementsByTagName("categoryName");
                    document.getElementById('categoryName').value = val[0].firstChild.data;
                    var val2 = xmlDoc.getElementsByTagName("itemDscrptn");
                    document.getElementById('itemDscrptn').value = val2[0].firstChild.data;
                    var val3 = xmlDoc.getElementsByTagName("itemCode");
                    document.getElementById('itemCode').value = val3[0].firstChild.data;
                    var val4 = xmlDoc.getElementsByTagName("itemUnit");
                    document.getElementById('itemUnit').value = val4[0].firstChild.data;
                    var val5 = xmlDoc.getElementsByTagName("storeName");
                    document.getElementById('storeName').value = val5[0].firstChild.data;
                    var val6 = xmlDoc.getElementsByTagName("itemUnitPrice");
                    document.getElementById('itemUnitPrice').value = val6[0].firstChild.data;
                    document.getElementById('message').innerHTML = "";
                } else {
                    document.getElementById('categoryName').value = "";
                    document.getElementById('itemDscrptn').value = "";
                    document.getElementById('itemCode').value = "";
                    document.getElementById('itemUnit').value = "";
                    document.getElementById('storeName').value = "";
                    document.getElementById('itemUnitPrice').value = "";
                    document.getElementById('message').innerHTML = "&#1602;&#1591;&#1593;&#1577; &#1594;&#1610;&#1575;&#1585; &#1594;&#1610;&#1585; &#1605;&#1608;&#1580;&#1608;&#1583;&#1577;";
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
            
            <table dir="<%=dir%>">
                <tr>
                    <td class="td"  align=center>
                        <H4><font color="red"><%=message%></font></H4>
                    </td>
                </tr>
            </table>
            <br><br>
            <%
            }
            %>
            <br><br>
            <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                <TR>
                    <TD STYLE="<%=style%>" class='td' >
                        <LABEL FOR="Project_Name">
                            <p><b>Search by Item Code / &#1576;&#1581;&#1579; &#1576;&#1603;&#1608;&#1583; &#1602;&#1591;&#1593;&#1577; &#1594;&#1610;&#1575;&#1585;</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <table border="0">
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
            <br><br>
            <INPUT ALIGN="RIGHT" DIR="RTL" TYPE="hidden" name="filterValue" value="">
            <TABLE  ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
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
            
            <TABLE ALIGN="<%=align%>" DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" BORDER="0">
                
                
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="ISSUE_TITLE">
                            <p><b><font color="#003399">Category Name / &#1575;&#1604;&#1589;&#1606;&#1601;</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input readonly type="TEXT" name="categoryName" ID="categoryName" size="20" value="<%//= (String) webIssue.getAttribute("id")%>" maxlength="255">
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="ISSUE_TITLE">
                            <p><b><font color="#003399">Part Name / &#1575;&#1587;&#1605; &#1575;&#1604;&#1602;&#1591;&#1593;&#1577;</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input readonly type="TEXT" name="itemDscrptn" ID="itemDscrptn" size="20" value="<%//=MaintenanceTitle%>" maxlength="255">
                    </TD>
                </TR>
                <TD class='td'>
                    &nbsp;
                </TD>
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="ISSUE_TITLE">
                            <p><b><font color="#003399">Part Code / &#1575;&#1604;&#1603;&#1608;&#1583;</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input readonly type="TEXT" name="itemCode" ID="itemCode" size="20" value="<%//=Receivedby%>" maxlength="255">
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="ISSUE_TITLE">
                            <p><b><font color="#003399">Part Unit / &#1608;&#1581;&#1583;&#1577; &#1575;&#1604;&#1602;&#1610;&#1575;&#1587;</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input readonly type="TEXT" name="itemUnit" ID="itemUnit" size="20" value="<%//= (String) webIssue.getAttribute("workTrade")%>" maxlength="255">
                    </TD>
                </TR>
                <TD class='td'>
                    &nbsp;
                </TD>
                <TR>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="ISSUE_TITLE">
                            <p><b><font color="#003399">Store Name / &#1575;&#1587;&#1600;&#1600;&#1600;&#1605; &#1575;&#1604;&#1605;&#1582;&#1600;&#1600;&#1600;&#1586;&#1606;</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input readonly type="TEXT" name="storeName" ID="storeName" size="20" value="<%//=FailureCode%>" maxlength="255">
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <LABEL FOR="Project_Name">
                            <p><b><font color="#003399">Part Price / &#1575;&#1604;&#1587;&#1593;&#1585;</font></b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD STYLE="<%=style%>" class='td'>
                        <input readonly type="TEXT" name="itemUnitPrice" ID="itemUnitPrice" size="20" value="<%//=SiteName%>" maxlength="255">
                    </TD>
                </TR>
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
