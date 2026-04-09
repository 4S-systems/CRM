<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.contractor.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>
<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    <HEAD>
        <TITLE>System Projects List</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script src="js/sorttable.js"></script>
        <script type="text/javascript" src="js/jquery-1.5.min.js"></script>
        <script type="text/javascript" src="js/jquery.tablesorter.js"></script>
        <style>
            .th{text-align:Center;padding:.2em;border:1px solid #000;background:#328aa4 url(tr_back.gif) repeat-x;color:#fff;}
            .even{background:#e5f1f4;}
            .odd{background:#f8fbfc;}
            td{border:0px;padding:.3em;}

            /* Extra selectors needed to override the default styling */
/*            table.tablesorter tbody tr.normal-row td {
              background: #e3e3e3;
              color: #000000;
            }
            table.tablesorter tbody tr.alt-row td {
              background: #f3f3f3;
              color: #000000;
            }*/

            table.tablesorter tbody tr.normal-row td {
              background: #eaeaea;
              color: #000000;
            }
            table.tablesorter tbody tr.alt-row td {
              background: #ffffff;
              color: #000000;
            }

        </style>
    </HEAD>
    <%

    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    MaintainableMgr maintainableMgr=MaintainableMgr.getInstance();

    //AppConstants appCons = new AppConstants();

    String[] categoryAttributes = {"unitName"};
    String[] categoryListTitles = {"Model Name", "Total Machines", "View Machines"};

    int s = categoryAttributes.length;
    int t = s+2;
    int iTotal = 0;

    String attName = null;
    String attValue = null;
    String cellBgColor = null;



    Vector  categoryList = (Vector) request.getAttribute("data");


    WebBusinessObject wbo = null;
    int flipper = 0;
    String bgColor = null;
    String bgColorm = null;

    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    String categoryId=null;
    String Total =null;

    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String cl="even";
    String lang,langCode,listCat,noParCat,noEqCat,viewEq,Quick,Basic,back;
    if(stat.equals("En")){

        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        viewEq="View Equipments";
        listCat="List Equipments By Make/Model";
        noParCat="No Parts Under That Category";
        noEqCat="No Equipment Under That Category";
        Quick="Quick Summary";
        Basic="Basic Oprations";
        back="Weekly Diary";

    }else{

        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        langCode="En";
        viewEq="&#1605;&#1600;&#1588;&#1600;&#1575;&#1607;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1583;&#1607; &#1575;&#1604;&#1600;&#1605;&#1600;&#1575;&#1603;&#1600;&#1610;&#1600;&#1606;&#1600;&#1600;&#1600;&#1600;&#1575;&#1578;";
        listCat=" عرض المعدات حسب الماركة/الموديل ";
        noParCat=" &#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1602;&#1591;&#1593; &#1578;&#1581;&#1578; &#1607;&#1584;&#1575; &#1575;&#1604;&#1600;&#1606;&#1600;&#1608;&#1593; ";
        noEqCat=" &#1604;&#1575; &#1610;&#1608;&#1580;&#1583; &#1605;&#1575;&#1603;&#1610;&#1606;&#1575;&#1578; &#1604;&#1607;&#1584;&#1575; &#1575;&#1604;&#1600;&#1606;&#1600;&#1608;&#1593; ";
        String[] categoryListTitlesAr = {"&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1583;&#1610;&#1604; ", " &#1593;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1583;&#1583; &#1575;&#1604;&#1600;&#1605;&#1600;&#1575;&#1603;&#1600;&#1610;&#1600;&#1606;&#1600;&#1600;&#1600;&#1600;&#1575;&#1578;", " &#1605;&#1600;&#1588;&#1600;&#1575;&#1607;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1600;&#1583;&#1607; &#1575;&#1604;&#1600;&#1605;&#1600;&#1575;&#1603;&#1600;&#1610;&#1600;&#1606;&#1600;&#1600;&#1600;&#1600;&#1575;&#1578;"};
        categoryListTitles=categoryListTitlesAr;
        Quick="&#1605;&#1593;&#1604;&#1608;&#1605;&#1575;&#1578; &#1587;&#1585;&#1610;&#1593;&#1577;";
        Basic="&#1593;&#1605;&#1604;&#1610;&#1575;&#1578; &#1571;&#1587;&#1575;&#1587;&#1610;&#1577;";
        back="&#1575;&#1604;&#1575;&#1580;&#1606;&#1583;&#1607; &#1575;&#1604;&#1575;&#1587;&#1576;&#1608;&#1593;&#1610;&#1607;";
    }

    %>

    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

    $(document).ready(function() {
        $("#modelTable").tablesorter({
            widgets: ["zebra"],
            widgetZebra: { css: [ "normal-row", "alt-row" ] },
            sortList : [[0,0]],
            headers: {
                // assign the secound column (we start counting zero)
                1: {
                    // disable it by setting the property sorter to false
                    sorter: false
                },
                // assign the third column (we start counting zero)
                2: {
                    // disable it by setting the property sorter to false
                    sorter: false
                }
            }

        });
    });

     function cancelForm(url)
        {
        window.navigate(url);
        }
    </SCRIPT>

    <script src='ChangeLang.js' type='text/javascript'></script>
    <LINK REL="stylesheet" TYPE="text/css" HREF="Button.css">
    <body>

        <DIV align="left" STYLE="color:blue;">
            <input type="button" value="<%=lang%>"
                   onclick="reloadAE('<%=langCode%>')" class="button">
            <button onclick="cancelForm('<%=context%>/main.jsp')" class="homebutton"><%=back%><IMG VALIGN="BOTTOM"   SRC="images/diary16.gif" WIDTH="20" HEIGHT="16"> </button>
        </DIV>

        <fieldset align="center" class="set" >
            <legend align="center">
                <table dir="rtl" align="center" >
                    <tr>

                        <td class="td">
                            <font color="blue" size="6">    <%=listCat%>
                            </font>

                        </td>
                    </tr>
                </table>
            </legend>
            <br>
            <table  ALIGN="CENTER" dir="<%=dir%>" WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="border-right-WIDTH:1px;">

                <TR>
                    <Th CLASS="blueBorder blueHeaderTD" COLSPAN="2" bgcolor="#808000" STYLE="text-align:center;color:white;font-size:18">
                        <B><%=Quick%></B>
                    </Th>
                    <Th CLASS="blueBorder blueHeaderTD" COLSPAN="1" bgcolor="#669900" STYLE="text-align:center;color:white;font-size:18">
                        <B><%=Basic%></B>
                    </Th>

                </TR>
            </table>
            <table id="modelTable" WIDTH="800" border="0" ALIGN="center" CELLPADDING="1" CELLSPACING="0" dir="<%=dir%>" class="tablesorter">
                <thead>
                <TR class="silver_header" >
                    <%
                    for(int i = 0;i<t;i++) {

        String columnColor="#9B9B00";
        if(i>1)
            columnColor="#7EBB00";
                    %>

                    <Th width="81" COLSPAN="1" nowrap  CLASS="silver_header" nowrap="nowrap"STYLE="text-align:center;font-size:16px;border-right:0px solid #666666 ;"  >
                        <font ><%=categoryListTitles[i]%></font>
                    </Th>



                    <%
                    }
                    %>
                </TR>
                </thead>
                <tbody>
                <%

                Enumeration e = categoryList.elements();


                while(e.hasMoreElements()) {
                    iTotal++;
                    wbo = (WebBusinessObject) e.nextElement();

                   flipper++;
                    if((flipper%2) == 1) {
                        bgColor = "silver_odd";
                        bgColorm = "silver_odd_main";
                    } else {
                       bgColor = "silver_even";
                       bgColorm = "silver_even_main";
                    }

                    categoryId = (String) wbo.getAttribute("id");
                %>

                <TR>
                    <%
                    for(int i = 0;i<s;i++) {
                        attName = categoryAttributes[i];
                        attValue = (String) wbo.getAttribute(attName);
                    %>

                    <TD STYLE="<%=style%>" nowrap>
                    <DIV >
                            <font size="3">
                                <b> <%=attValue%> </b>
                            </font>
                        </DIV>
                    </TD>
                    <%
                    }
                    %>

                    <%
                    Total=maintainableMgr.getTotalEquipment(categoryId);
                    if (Total!=null){
                    %>
                    <TD DIR="ltr" STYLE="padding-left:10;text-align:center;">
                        <DIV ID="links">
                            <font color="blue" size="3"><b> <%=Total%></b></font>
                        </DIV>
                        <%  } else { %>

                        <DIV ID="links">
                            <%=noParCat%>
                        </DIV>
                        <% } %>
                    </TD>

                    <TD STYLE="padding-left:10;<%=style%>;">
                        <% if(Total.equals("0")) { %>
                        <DIV ID="links">
                            <center> <font color="red"> <b> <%=noEqCat%> </b></font></center>
                        </DIV>
                        <% } else {  %>

                        <DIV ID="links">
                            <A HREF="<%=context%>/EquipmentServlet?op=ViewUnits&categoryId=<%=wbo.getAttribute("id")%>&categoryName=<%=wbo.getAttribute("unitName")%>&url=EquipmentServlet?op=ViewUnits&count=0">
                                <center><font size="2"> <b> <%=viewEq%></b></font></center>
                            </A>
                        </DIV>
                        <% } %>
                    </TD>
                </TR>


                <%

                }

                %>
                </tbody>
            </table>
            <br><br>
        </fieldset>


    </body>
</html>
