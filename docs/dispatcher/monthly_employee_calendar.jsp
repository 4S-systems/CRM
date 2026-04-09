<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.contractor.db_access.MaintainableMgr;"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    MaintainableMgr maintainableMgr = MaintainableMgr.getInstance();

    ArrayList categories = (ArrayList) request.getAttribute("data");
    Vector<WebBusinessObject> regions = new Vector();
    regions = (Vector) request.getAttribute("regions");
    WebBusinessObject wbo = null;
    TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String lang, langCode;
    String category, subTitle, title, save_button_label, cancel_button_label, itemName, itemCode, requiredJob, tradeName, typeOfTask, workingType, duration, engDesc;
    String theMonth, theYear, pageTitle, pageTitleTip;
    if (stat.equals("En")) {

        align = "center";
        dir = "LTR";
        langCode = "Ar";
        style = "text-align:Right";
        lang = "&#1593;&#1585;&#1576;&#1610;";
        cancel_button_label = "Cancel";
        save_button_label = "Generate Report";
        itemCode = "Item Code";
        itemName = "Item Name";
        requiredJob = "Required Job";
        tradeName = "Trade Name";
        typeOfTask = "Type Of Task";
        workingType = "Working Type";
        duration = "Execution Duration";
        title = "Select brand of equipment";
        subTitle = "Report Fields";
        category = "Category Name";
        engDesc = "English Description";
        theMonth = "The Month";
        theYear = "The Year";
        pageTitle = "RPT-RQUIRED-MNTHLY-JO-MAKE-MO-3";
        pageTitleTip = "Monthly Maintenance By Model Report";
    } else {

        align = "center";
        dir = "RTL";
        langCode = "En";
        style = "text-align:left";
        lang = "English";
        save_button_label = "&#1575;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
        cancel_button_label = "&#1593;&#1608;&#1583;&#1607;";

        itemCode = "&#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583;";
        itemName = "&#1608;&#1589;&#1601; &#1575;&#1604;&#1576;&#1606;&#1583;";
        requiredJob = "&#1575;&#1604;&#1605;&#1607;&#1606;&#1607; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
        tradeName = "&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
        typeOfTask = "&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
        workingType = "&#1581;&#1580;&#1605; &#1575;&#1604;&#1593;&#1605;&#1604;";
        duration = "&#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1587;&#1575;&#1593;&#1575;&#1578;";
        title = "&#1571;&#1582;&#1578;&#1575;&#1585; &#1605;&#1575;&#1585;&#1603;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
        subTitle = "&#1593;&#1606;&#1575;&#1589;&#1585; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
        category = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;";
        engDesc = "&#1575;&#1604;&#1608;&#1589;&#1601; &#1576;&#1575;&#1604;&#1575;&#1606;&#1580;&#1604;&#1610;&#1586;&#1609;";
        theMonth = "&#1575;&#1604;&#1588;&#1607;&#1585; ";
        theYear = "&#1575;&#1604;&#1587;&#1606;&#1577;";
        pageTitle = "RPT-RQUIRED-MNTHLY-JO-MAKE-MO-3";
        pageTitleTip = "&#1593;&#1585;&#1590; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607; &#1575;&#1604;&#1588;&#1607;&#1585;&#1610;&#1607; &#1591;&#1576;&#1602;&#1575; &#1604;&#1605;&#1575;&#1585;&#1603;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";

    }
    ArrayList monthsList = (ArrayList) request.getAttribute("monthsList");
    ArrayList yearsList = (ArrayList) request.getAttribute("yearsList");
    WebBusinessObject monthWbo = (WebBusinessObject) request.getAttribute("month");
    WebBusinessObject yearWbo = (WebBusinessObject) request.getAttribute("year");




%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - add new user</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script src='js/ChangeLang.js' type='text/javascript'></script>
    </HEAD>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        
        function getReport()
        {
                 
            var regionId = document.getElementById('region').value;
            var month = document.getElementById('month').value;
            var yearNo = document.getElementById('yearNo').value;

            var url = "<%=context%>/ReportsServlet?op=employeesCalendar&regionId="+regionId+"&month="+month+"&yearNo="+yearNo;
            openWindow(url);
        }
        
        function openWindow(url)
        {
            window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=yes, scrollbars=yes, resizable=yes, copyhistory=no, width=1100, height=650");
        }
        function cancelForm()
        {
            document.USERS_FORM.action = "<%=context%>/ReportsServlet?op=mainPage";
            document.USERS_FORM.submit();
        }
    </SCRIPT>

    <BODY>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <FORM NAME="CLIEN_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button    onclick="cancelForm()" class="button"><%=cancel_button_label%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
                <button  onclick="JavaScript:  getReport();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
            </DIV>
            <fieldset class="set" align="center">
                <legend align="center">
                    <table align="<%=align%>" dir=<%=dir%>>
                        <tr>

                            <td class="td">
                                <font color="blue" size="6">    <%=title%>                
                                </font>

                            </td>
                        </tr>
                    </table>
                </legend>
                <div dir="left">
                    <table>
                        <tr>
                            <td>
                                <font color="#FF385C" size="3">
                                <a id="mainLink"  onmouseover="Tip('<%=pageTitleTip%>',CENTERMOUSE, true, OFFSETX, 0, BGCOLOR, '#ffff99' , FONTCOLOR, 'BLACK', FONTSIZE, '10pt', FONTWEIGHT ,'BOLD', SHADOW, true, SHADOWWIDTH, 7,TEXTALIGN ,'CENTER', TITLE ,'<%=pageTitleTip%>',TITLEALIGN ,'center' ,TITLEFONTCOLOR ,'White', TITLEBGCOLOR ,'#FF9900')"  onmouseout="UnTip()"><%=pageTitle%></a>
                                </font>
                            </td>
                        </tr>
                    </table>
                </div>

                <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" ALIGN="CENTER" DIR="<%=dir%>">


                    <tr>
                        <td style="text-align:center; font-weight: bold; font-size: 16px; color: black;" class="excelentCell formInputTag" width="35%">
                            <LABEL FOR="region">
                                <p><b><font color="#FF0000">المنطقة</font></b>&nbsp;
                            </LABEL>

                        </td>
                        <td  style="<%=style%>"class='td'>

                            <input type="text" name="clientRegion" id="clientRegion" />
                            <input type="hidden" name="region" id="region" />

                            <input type="button" onclick="window.open('<%=context%>/EquipmentServlet?op=getAllBranches', '_blank', 'status=1,scrollbars=1,width=400')"  value="search">
                        </td>
                    </tr>
                    <TR>
                        <TD CLASS="cell" bgcolor="#99cccc" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="100">
                            <LABEL FOR="assign_to">
                                <p><b><font><%=theMonth%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD  CLASS="cell" bgcolor="#99cccc" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="100">
                            <SELECT name="month" id="month" STYLE="width:200px; z-index:-1;">
                                <sw:WBOOptionList wboList='<%=monthsList%>' displayAttribute = "name" valueAttribute="id" scrollTo='<%=monthWbo.getAttribute("name").toString()%>'/>
                            </SELECT>
                        </TD>
                        <TD CLASS="cell" bgcolor="#99cccc" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="100">
                            <LABEL FOR="assign_to">
                                <p><b><font><%=theYear%></font></b>&nbsp;
                            </LABEL>
                        </TD>
                        <TD  CLASS="cell" bgcolor="#99cccc" STYLE="text-align:center;font-size:14;border-width:1px;border-color:white" WIDTH="100">

                            <SELECT name="yearNo" id="yearNo" STYLE="width:200px; z-index:-1;">               
                                <sw:WBOOptionList wboList='<%=yearsList%>'  displayAttribute = "name" valueAttribute="id" scrollTo='<%=yearWbo.getAttribute("name").toString()%>' />
                            </SELECT>
                        </TD>
                    </TR>
                </TABLE>

                <BR>

            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
