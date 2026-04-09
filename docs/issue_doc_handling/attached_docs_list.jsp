<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.docviewer.common.*,com.docviewer.business_objects.*,java.math.*,com.silkworm.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.docviewer.db_access.DocTypeMgr"%>
<%@ page import="com.sw.constants.*,java.text.DateFormat,java.text.SimpleDateFormat"%>
<%@page pageEncoding="UTF-8" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<HTML>
    <c:set var="loc" value="en"/>
    <c:if test="${!(empty sessionScope.currentMode)}">
      <c:set var="loc" value="${sessionScope.currentMode}"/>
    </c:if>
<fmt:setLocale value="${loc}"  />
<fmt:setBundle basename="Languages.Units.Units"  />

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE><fmt:message key="listdocs" />  </TITLE>
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.widget.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.drop.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.fold.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.mouse.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.slider.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
        <link rel="stylesheet" href="css/demo_table.css">     

        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
    </HEAD>
    <script type="text/javascript">
    $(document).ready(function() {
        $('#indextable').dataTable({
            bJQueryUI: true,
            sPaginationType: "full_numbers",
            "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
            iDisplayLength: 25,
            iDisplayStart: 0,
            "bPaginate": true,
            "bProcessing": true



        })
    });
    //          
</script>
    <%

        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        FileMgr fileMgr = FileMgr.getInstance();
        WebBusinessObject fileDescriptor = null;
        String context = metaMgr.getContext();


        DVAppConstants appCons = new DVAppConstants();
        System.out.println(" then I am here .......    ");

        String[] docAttributes = {"typeName", "businessCompID", "documentTitle", "documentDate"};
        String[] docTitles = appCons.getDocHeaders();

        int s = docAttributes.length;
        int t = s + 5;
        WebBusinessObject waUser = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        String loggedUserId = (String) waUser.getAttribute("userId");
        String attName = null;
        String attValue = null;
        String businessID = "";
        String businessIdByDate = "";
        Vector docList = (Vector) request.getAttribute("data");
        WebBusinessObject issue = (WebBusinessObject) request.getAttribute("issue");
        if(issue != null){
            businessID = (String) issue.getAttribute("businessID");
            businessIdByDate = (String) issue.getAttribute("businessIDbyDate");
        }
        WebBusinessObject doc = null;
        
        UserMgr userMgr = UserMgr.getInstance();

        String issueId = (String) request.getAttribute("issueId");

        String cMode = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String lang, langCode, cancel, PN, title, noDataDis;
        String sDate, sTime = null;
        String sat, sun, mon, tue, wed, thu, fri, today, cannot;
        if (stat.equals("En")) {

            align = "center";
            dir = "LTR";
            style = "text-align:left";
            lang = "   &#1593;&#1585;&#1576;&#1610;    ";
            langCode = "Ar";
            cancel = "Cancel";
            docTitles[0] = "Type";
            docTitles[1] = "Number";
            docTitles[2] = "Document Title";
            docTitles[3] = "Date";
            docTitles[4] = "User Name";
            docTitles[5] = "View";
            docTitles[6] = "Edit";
            docTitles[7] = "View Details";
            docTitles[8] = "Delete";
            PN = "Documents No.";
            title = "Documents Relating to Follow-Up No.";
            noDataDis = "No Data To Display";
            sat = "Sat";
            sun = "Sun";
            mon = "Mon";
            tue = "Tue";
            wed = "Wed";
            thu = "Thu";
            fri = "Fri";
            today = "Today";
            cannot = "Can not";
        } else {
            align = "center";
            dir = "RTL";
            style = "text-align:Right";
            lang = "English";
            langCode = "En";
            noDataDis = " &#1604;&#1575;&#1610;&#1608;&#1580;&#1583; &#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578;";
            cancel = "&#1573;&#1604;&#1594;&#1575;&#1569;";
            docTitles[0] = "\u0627\u0644\u0646\u0648\u0639";
            docTitles[1] = "\u0627\u0644\u0631\u0642\u0645";
            docTitles[2] = "\u0639\u0646\u0648\u0627\u0646 \u0627\u0644\u0645\u0633\u062a\u0646\u062f";
            docTitles[3] = "&#1575;&#1604;&#1578;&#1575;&#1585;&#1610;&#1582;";
            docTitles[4] = "\u0627\u0633\u0645 \u0627\u0644\u0645\u0633\u062a\u062e\u062f\u0645";
            docTitles[5] = "\u0645\u0634\u0627\u0647\u062f\u0629";
            docTitles[6] = "&#1578;&#1581;&#1585;&#1610;&#1585;";
            docTitles[7] = "&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1571;&#1603;&#1579;&#1585;";
            docTitles[8] = "&#1581;&#1584;&#1601;";
            PN = "&#1593;&#1583;&#1583; &#1575;&#1604;&#1605;&#1587;&#1578;&#1606;&#1583;&#1575;&#1578;";
            title = "\u0627\u0644\u0645\u0633\u062a\u0646\u062f\u0627\u062a \u0627\u0644\u0645\u062a\u0639\u0644\u0642\u0629 \u0628\u0631\u0642\u0645 \u0627\u0644\u0645\u062a\u0627\u0628\u0639\u0629";
            sat = "&#1575;&#1604;&#1587;&#1576;&#1578;";
            sun = "&#1575;&#1604;&#1575;&#1581;&#1583;";
            mon = "&#1575;&#1604;&#1575;&#1579;&#1606;&#1610;&#1606;";
            tue = "&#1575;&#1604;&#1579;&#1604;&#1575;&#1579;&#1575;&#1569;";
            wed = "&#1575;&#1604;&#1575;&#1585;&#1576;&#1593;&#1575;&#1569;";
            thu = "&#1575;&#1604;&#1582;&#1605;&#1610;&#1587;";
            fri = "&#1575;&#1604;&#1580;&#1605;&#1593;&#1577;";
            today = "\u0627\u0644\u064a\u0648\u0645";
            cannot = "غير مسموح";
        }
        String type = (String) request.getAttribute("type");
    %>

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
        function cancelForm(url)
        {    
            close();
        
     
        }
        //]]></script> 

    <script src='ChangeLang.js' type='text/javascript'></script>
    <input type="hidden" name="type" value="<%=type%>">
    <body>
        <DIV align="left" STYLE="color:blue;">
            
            <button    onclick="cancelForm('ProjectServlet?op=ListProjects');" class="button"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
        </DIV>

        <fieldset align=center class="set">
            <legend align="center">

                <table dir=" <%=dir%>" align="<%=align%>">
                    <tr>

                        <td class="td">
                            <font color="blue" size="6"><%=title%> <font color="red"><%=businessID%></font>/<%=businessIdByDate%>
                            </font>
                        </td>
                    </tr>
                </table>

            </legend >
        
           <!--//  <center> <b> <font size="3" color="red"> <%=PN%> : <%= docList.size()%> </font></b></center>--> 
            <br>   
            <table id="indextable" ALIGN="center" dir="<%=dir%>" CELLPADDING="0" CELLSPACING="0" STYLE="width: 100%;text-align: center">

                <thead>
                    <TR >

                        <%
                            String columnColor = new String("");
                            String columnWidth = new String("");
                            String font = new String("");
                            for (int i = 0; i < t - 1; i++) {
                                
                        %>     
                        <TD >
                            <B><%=docTitles[i]%></B>
                        </TD>
                        <%
                            }
                        %>

                    </TR>  
                </thead>
                <tbody >

                    <%
                        if (null != docList) {
                            Enumeration e = docList.elements();


                            while (e.hasMoreElements()) {
                                doc = (WebBusinessObject) e.nextElement();
                                fileDescriptor = fileMgr.getObjectFromCash((String) doc.getAttribute("documentType"));
                                
                                WebBusinessObject userWbo = null;
                                if(doc.getAttribute("createdById") != null){
                                    userWbo = userMgr.getOnSingleKey(doc.getAttribute("createdById").toString());
                                }
                                String userName = "";
                                if(userWbo != null){
                                    userName = (String) userWbo.getAttribute("fullName");
                                }
                    %>
                    <TR >
                        <%
                            for (int i = 0; i < s; i++) {
                                attName = docAttributes[i];
                                attValue = (String) doc.getAttribute(attName);


                        %>

                        <TD  >
                            <DIV >
                                <%
                                    if (attName.equalsIgnoreCase("total") && attValue.equalsIgnoreCase("0.00")) {
                                        attValue = new String("none");
                                    }
                                    if(attName.equalsIgnoreCase("documentDate")){
                                        Calendar c = Calendar.getInstance();
                                        DateFormat formatter;
                                        formatter = new SimpleDateFormat("dd/MM/yyyy");
                                        String[] arrDate = attValue.split(" ");
                                        Date date = new Date();
                                        sDate = arrDate[0];
                                        sTime = arrDate[1];
                                        String[] arrTime = sTime.split(":");
                                        sTime = arrTime[0] + ":" + arrTime[1];
                                        sDate = sDate.replace("-", "/");
                                        arrDate = sDate.split("/");
                                        sDate = arrDate[2] + "/" + arrDate[1] + "/" + arrDate[0];
                                        c.setTime((Date) formatter.parse(sDate));
                                        int dayOfWeek = c.get(Calendar.DAY_OF_WEEK);
                                        String currentDate = formatter.format(date);
                                        String sDay = null;
                                        if (dayOfWeek == 7) {
                                            sDay = sat;
                                        } else if (dayOfWeek == 1) {
                                            sDay = sun;
                                        } else if (dayOfWeek == 2) {
                                            sDay = mon;
                                        } else if (dayOfWeek == 3) {
                                            sDay = tue;
                                        } else if (dayOfWeek == 4) {
                                            sDay = wed;
                                        } else if (dayOfWeek == 5) {
                                            sDay = thu;
                                        } else if (dayOfWeek == 6) {
                                            sDay = fri;
                                        }
                                        if (currentDate.equals(sDate)) {
                                %>
                                <b><font color="red"><%=today%> - </font><b><%=sTime%></b>
                                <%} else {%>
                                    <b><font color="red"><%=sDay%> - </font><b><%=sDate + " " + sTime%></b>
                                <%
                                    }
                                } else {
                                    if(attValue == null) {
                                        attValue = "---";
                                    }
                                %>
                        <b> <%=attValue%> </b>
                        <% } %>
                            </DIV>
                        </TD>
                        <%

                            }
                        %>
                        <TD >
                            <DIV ID="links">
                                <B><%=userName%></B>
                            </DIV>
                        </TD>
                        <TD >
                            <DIV ID="links">

                                <A HREF='<%=context%>/IssueDocServlet?op=ViewDocument&docType=<%=(String) doc.getAttribute("documentType")%>&docID=<%=(String) doc.getAttribute("documentID")%>&metaType=<%=(String) doc.getAttribute("metaType")%>&issueId=<%=issueId%>&docName=<%=(String) doc.getAttribute("documentID")%>'>
                                    <%=docTitles[5]%>  
                                </A>
                                <IMG SRC="images/<%=fileDescriptor.getAttribute("iconFile")%>"  ALT="Document Image"> 

                            </DIV>
                        </TD>                     
                        
                        <TD>
                            <DIV ID="links">
                                <A HREF="<%=context%>/IssueDocServlet?op=UpdateDocumentDetails&docID=<%=doc.getAttribute("documentID")%>&metaType=<%=doc.getAttribute("metaType")%>&issueId=<%=issueId%>"
                                   style="display: <%=((String) doc.getAttribute("createdById")).equals(loggedUserId)?"block":"none"%>">
                                    <%=docTitles[6]%>
                                </A>
                                <LABEL style="display: <%=((String) doc.getAttribute("createdById")).equals(loggedUserId)?"none":"block"%>"><%=cannot%></LABEL>
                            </DIV>
                        </TD>

                        <TD >
                            <DIV ID="links">
                                <A HREF="<%=context%>/IssueDocServlet?op=AttachedDocsDetails&docID=<%=doc.getAttribute("documentID")%>&metaType=<%=doc.getAttribute("metaType")%>&issueId=<%=issueId%>">
                                    <%=docTitles[7]%>...
                                </A>
                            </DIV>
                        </TD>



                        <!--TD >
                            <DIV ID="links">
                                <A HREF="<%=context%>/IssueDocServlet?op=ConfirmDeleteAttachFile&docID=<%=(String) doc.getAttribute("documentID")%>&issueId=<%=issueId%>&docTitle=<%=(String) doc.getAttribute("documentTitle")%>"
                                   style="display: <%=((String) doc.getAttribute("createdById")).equals(loggedUserId)?"block":"none"%>">
                                    <%=docTitles[8]%>
                                </A>
                                <LABEL style="display: <%=((String) doc.getAttribute("createdById")).equals(loggedUserId)?"none":"block"%>"><%=cannot%></LABEL>
                            </DIV>
                        </TD-->

                        <%
                            }
                        %>
                </tbody>



            </table>

            <%
            } else {
            %>

            <%=noDataDis%>

            <%
                }
            %>

    </body>
</html>
