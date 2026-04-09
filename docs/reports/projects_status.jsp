<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants, com.silkworm.persistence.relational.*"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<HTML>
    <%
    ProjectMgr projectMgr = ProjectMgr.getInstance();
    IssueTypeMgr issueTypeMgr = IssueTypeMgr.getInstance();
    com.tracker.common.AppConstants appCons = new com.tracker.common.AppConstants();
    
    String[] projectStatusAtt = appCons.getProjectStatusAtt();
    int s = projectStatusAtt.length;
    String[] projectStatusTitle = new String[4];
    
    
    
    String attName = null;
    String attValue = null;
    
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String ts = (String) request.getAttribute("ts");
    
    Vector  projectStatusList = (Vector) request.getAttribute("data");
    WebBusinessObject wbo = null;
    
    Enumeration e = projectStatusList.elements();
    Double iTemp = new Double(0);
    int iTotal = 0;
    String issueID = null;
    
    String projectName = null;
    Vector filterValue = (Vector) request.getAttribute("filterValue");
    String sFilterValue = null;
    if(filterValue.size() > 0) {
        sFilterValue = (String) filterValue.get(0);
    }
    projectName = sFilterValue.substring(sFilterValue.indexOf(">") + 1);
    WebBusinessObject projectWbo = (WebBusinessObject) projectMgr.getOnSingleKey(projectName);
    //} else {
    //    projectName = request.getParameter("projectName");
    //}
    
    boolean canDelete = false;
    request.getSession().setAttribute("data", projectStatusList);
    TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align="center";
    String dir=null;
    String style=null;
    String lang,langCode,cancel,save,site,tit,note,red,green,im,tail,ed,del,tot,sCancel;
    if(stat.equals("En")){
        
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        cancel="Cancel";
        save="Excel Sheet";
        site="Site";
        tit="Report About Site '<font color='red' size='6'>" + projectWbo.getAttribute("projectName") + "</font>'";
       
        note="Note";
        red="The Table Have Red Color is Late";
        green="The Table Have Green Color Had Been Finished";
        im="image";
        tail="To Allow Change Person Who is Responsable For Table";
        projectStatusTitle[0]="Title";
        projectStatusTitle[1]="Expected Begin Date";
        projectStatusTitle[2]="Expected End Date";
        projectStatusTitle[3]="Status";
        del="delete";
        ed="edit";
        tot="Schedule No.";
        sCancel="Cancel";
        
    }else{
        
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        cancel="&#1573;&#1606;&#1607;&#1575;&#1569;";
        save=" &#1573;&#1603;&#1587;&#1604; ";
        site="&#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";
        tit = "'<font color='red' size='6'>" + projectWbo.getAttribute("projectName") + "</font>' &#1578;&#1602;&#1585;&#1610;&#1585; &#1593;&#1606; &#1581;&#1575;&#1604;&#1577; &#1575;&#1604;&#1605;&#1608;&#1602;&#1593;";

        note="&#1604;&#1575;&#1581;&#1592; ";
        red="&#1575;&#1604;&#1580;&#1583;&#1608;&#1604; &#1575;&#1604;&#1592;&#1575;&#1607;&#1585; &#1576;&#1575;&#1604;&#1604;&#1608;&#1606; &#1575;&#1604;&#1571;&#1581;&#1605;&#1585; &#1605;&#1578;&#1571;&#1582;&#1585;. ";
        green="&#1575;&#1604;&#1580;&#1583;&#1608;&#1604; &#1575;&#1604;&#1592;&#1575;&#1607;&#1585; &#1576;&#1575;&#1604;&#1604;&#1608;&#1606;&#1575;&#1604;&#1571;&#1582;&#1590;&#1585; &#1573;&#1606;&#1578;&#1607;&#1609;.";
        im="&#1575;&#1604;&#1589;&#1608;&#1585;&#1607; ";
        tail="&#1578;&#1592;&#1607;&#1585; &#1601;&#1609; &#1575;&#1604;&#1581;&#1575;&#1604;&#1607;  &#1604;&#1573;&#1605;&#1603;&#1575;&#1606;&#1610;&#1607; &#1578;&#1594;&#1610;&#1610;&#1585; &#1575;&#1604;&#1588;&#1582;&#1589; &#1575;&#1604;&#1605;&#1587;&#1574;&#1608;&#1604; &#1593;&#1606; &#1607;&#1584;&#1575; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;.";
        projectStatusTitle[0]="&#1593;&#1606;&#1608;&#1575;&#1606; &#1575;&#1604;&#1580;&#1583;&#1608;&#1604;";
        projectStatusTitle[1]="&#1608;&#1602;&#1578; &#1575;&#1604;&#1576;&#1583;&#1575;&#1610;&#1577; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
        projectStatusTitle[2]="&#1608;&#1602;&#1578; &#1575;&#1604;&#1606;&#1607;&#1575;&#1610;&#1577; &#1575;&#1604;&#1605;&#1578;&#1608;&#1602;&#1593;";
        projectStatusTitle[3]="&#1575;&#1604;&#1581;&#1575;&#1604;&#1607;";
        del="&#1581;&#1584;&#1601;";
        ed="&#1578;&#1581;&#1585;&#1610;&#1585;";
        tot="&#1593;&#1583;&#1583; &#1575;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604;";
        sCancel = tGuide.getMessage("cancel");
    }
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Equipment Statistics</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    </HEAD>
    
    
    
    <script type="text/javascript">//<![CDATA[

    function sortTable2(col) {

    // Get the table section to sort.
    var tblEl = document.getElementById("planetData2");

    // Set up an array of reverse sort flags, if not done already.
    if (tblEl.reverseSort == null)
    tblEl.reverseSort = new Array();

    // If this column was the last one sorted, reverse its sort direction.
    if (col == tblEl.lastColumn)
    tblEl.reverseSort[col] = !tblEl.reverseSort[col];

    // Remember this column as the last one sorted.
    tblEl.lastColumn = col;

    // Set the table display style to "none" - necessary for Netscape 6 
    // browsers.
    var oldDsply = tblEl.style.display;
    tblEl.style.display = "none";

    // Sort the rows based on the content of the specified column using a
    // selection sort.

    var tmpEl;
    var i, j;
    var minVal, minIdx;
    var testVal;
    var cmp;

    for (i = 0; i < tblEl.rows.length - 1; i++) {

    // Assume the current row has the minimum value.
    minIdx = i;
    minVal = getTextValue(tblEl.rows[i].cells[col]);

    // Search the rows that follow the current one for a smaller value.
    for (j = i + 1; j < tblEl.rows.length; j++) {
    testVal = getTextValue(tblEl.rows[j].cells[col]);
    cmp = compareValues(minVal, testVal);
    // Reverse order?
    if (tblEl.reverseSort[col])
    cmp = -cmp;
    // If this row has a smaller value than the current minimum, remember its
    // position and update the current minimum value.
    if (cmp > 0) {
    minIdx = j;
    minVal = testVal;
    }
    }

    // By now, we have the row with the smallest value. Remove it from the
    // table and insert it before the current row.
    if (minIdx > i) {
    tmpEl = tblEl.removeChild(tblEl.rows[minIdx]);
    tblEl.insertBefore(tmpEl, tblEl.rows[i]);
    }
    }

    // Restore the table's display style.
    tblEl.style.display = oldDsply;

    return false;
    }

    //-----------------------------------------------------------------------------
    // Functions to get and compare values during a sort.
    //-----------------------------------------------------------------------------

    // This code is necessary for browsers that don't reflect the DOM constants
    // (like IE).
    if (document.ELEMENT_NODE == null) {
    document.ELEMENT_NODE = 1;
    document.TEXT_NODE = 3;
    }

    function getTextValue(el) {

    var i;
    var s;

    // Find and concatenate the values of all text nodes contained within the
    // element.
    s = "";
    for (i = 0; i < el.childNodes.length; i++)
    if (el.childNodes[i].nodeType == document.TEXT_NODE)
    s += el.childNodes[i].nodeValue;
    else if (el.childNodes[i].nodeType == document.ELEMENT_NODE &&
    el.childNodes[i].tagName == "BR")
    s += " ";
    else
    // Use recursion to get text within sub-elements.
    s += getTextValue(el.childNodes[i]);

    return normalizeString(s);
    }

    function compareValues(v1, v2) {

    var f1, f2;

    // If the values are numeric, convert them to floats.

    f1 = parseFloat(v1);
    f2 = parseFloat(v2);
    if (!isNaN(f1) && !isNaN(f2)) {
    v1 = f1;
    v2 = f2;
    }

    // Compare the two values.
    if (v1 == v2)
    return 0;
    if (v1 > v2)
    return 1
    return -1;
    }

    // Regular expressions for normalizing white space.
    var whtSpEnds = new RegExp("^\\s*|\\s*$", "g");
    var whtSpMult = new RegExp("\\s\\s+", "g");

    function normalizeString(s) {

    s = s.replace(whtSpMult, " ");  // Collapse any multiple whites space.
    s = s.replace(whtSpEnds, "");   // Remove leading or trailing white space.

    return s;
    }
     function changePage(url){
                window.navigate(url);
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

    function cancelForm()
        {
           document.USERS_FORM.action = "<%=context%>/SearchServlet?op=Projects&type=Status";
           document.USERS_FORM.submit();
        }
    //]]></script>
    
    
    <BODY>
         <FORM NAME="USERS_FORM" METHOD="POST">
        <DIV align="left" STYLE="color:blue;">
            <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
            <!--button    dir="<%=dir%> " onclick="changePage('<%=context%>/SearchServlet?op=ExcelStatusReport&projectName=<%=projectName%>')" class="button"><%=save%> <img src="<%=context%>/images/xlsicon.gif"></button-->
            <button  onclick="JavaScript: cancelForm();" class="button"><%=sCancel%> <IMG VALIGN="BOTTOM" SRC="images/cancel.gif"> </button>

        </DIV>
        
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
            
            <TABLE DIR="<%=dir%>" ALIGN="<%=align%>" CELLPADDING=0 CELLSPACING=0 STYLE="border-right-WIDTH:0px;border-left-WIDTH:0px;border-top-WIDTH:0px;border-bottom-WIDTH:0px;<%=style%>" width="80%">
                <th style="<%=style%>"> <font size="1">
                        * <%=note%>
                    </font>
                </th>
                <TR>
                    <TD width="50" STYLE="border-right-WIDTH:0px;border-left-WIDTH:0px;border-top-WIDTH:0px;border-bottom-WIDTH:0px;<%=style%>">
                        &nbsp;
                    </TD>
                    <TD width="750" STYLE="border-right-WIDTH:0px;border-left-WIDTH:0px;border-top-WIDTH:0px;border-bottom-WIDTH:0px;<%=style%>">
                        <font color="red" size="1">
                            1. <%=red%>
                        </font>
                    </TD>
                </TR>
                <TR>
                    <TD width="50" STYLE="border-right-WIDTH:0px;border-left-WIDTH:0px;border-top-WIDTH:0px;border-bottom-WIDTH:0px;<%=style%>">
                        &nbsp;
                    </TD>
                    <TD width="750" STYLE="border-right-WIDTH:0px;border-left-WIDTH:0px;border-top-WIDTH:0px;border-bottom-WIDTH:0px;<%=style%>">
                        <font color="green" size="1">
                            2.<%=green%>
                        </font>
                    </TD>
                </TR>
                
            </Table>
            <br><br><br>
            <TABLE ALIGN="<%=align%>" dir=<%=dir%> WIDTH="95%" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">
                <TR  bgcolor="#C8D8F8">
                    <% for(int i = 0;i<4;i++) {
                    %>
                    <TD>
                        <a href="" onclick="return sortTable2(<%=i%>)"><B><%=projectStatusTitle[i]%></B></a>
                    </TD>
                    <%
                    }
                    %>
                </TR>
                
                <tbody id="planetData2">
                    
                    
                    <%while(e.hasMoreElements()) {
                    wbo = (WebBusinessObject) e.nextElement();
                    iTotal++;
                    issueID = (String) wbo.getAttribute("id");
                    %>
                    <TR bgcolor="<%=wbo.getAttribute("color")%>">
                        <% for(int i = 0;i<4;i++) {
                        attName = projectStatusAtt[i];
                        attValue = (String) wbo.getAttribute(attName);
                        if(i == 3) {
                            if(attValue.equalsIgnoreCase("Schedule") || attValue.equalsIgnoreCase("Rejected") || attValue.equalsIgnoreCase("Assigned") || attValue.equalsIgnoreCase("Reassigned")) {
                                canDelete = true;
                            } else {
                                canDelete = false;
                            }
                        }
                        %>
                        <TD>
                            <B><%=attValue%></B>
                            <%
                            if(attValue.equalsIgnoreCase("Assigned") || attValue.equalsIgnoreCase("Reassigned")) {
                            %>
                            <!--A href="<%=context%>/AssignedIssueServlet?op=reassign&state=RESOLVED&issueId=<%=issueID%>&issueTitle=<%=(String) wbo.getAttribute("issueTitle")%>&direction=backward&filterName=<%=request.getParameter("op")%>&filterValue=<%=sFilterValue%>">
                                <img src="<%=context%>/images/WB01740_.GIF" width="12" alt="Reassign this Schedule to another person">
                            </A-->
                            <%
                            }
                            %>
                        </TD>
                        <%
                        }
                        %>
                    </TR>      
                    <%
                    }
                    %>
                    
                </tbody>
                
                <TR>
                    <TD bgcolor="#C8D8F8" COLSPAN="3" STYLE="<%=style%>;padding-right:5;border-right-width:1;">
                        <B> <%=tot%> </B>
                    </TD>
                    <TD bgcolor="#C8D8F8" colspan="1" STYLE="<%=style%>;padding-left:5;">
                        <B><%=iTotal%></B>
                    </TD>
                </TR>
            </TABLE>
            <BR>
        </fieldset>
        </FORM>
    </BODY>
</HTML>     
