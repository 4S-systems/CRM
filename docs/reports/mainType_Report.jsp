<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.tracker.db_access.*,com.tracker.business_objects.*"%>
<%@ page import="java.util.*,com.maintenance.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,java.text.SimpleDateFormat"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
com.maintenance.common.AppConstants headers = new AppConstants();

MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

//get equipment headers

//Get request data
ArrayList mainCategories=(ArrayList)request.getAttribute("data");
WebBusinessObject catWbo=new WebBusinessObject();
Vector mainCategoriesVec=new Vector();
String[] excelHeaders = {"Category Name", "Appreviation", "Description"};
String[] attributes = {"typeName", "appreviation", "notes"};
// get report pictures
Hashtable logos=new Hashtable();
logos=(Hashtable)session.getAttribute("logos");
for(int m=0;m<mainCategories.size();m++)
    mainCategoriesVec.add((WebBusinessObject)mainCategories.get(m));

request.getSession().setAttribute("data",mainCategoriesVec);
request.getSession().setAttribute("headers",excelHeaders);
request.getSession().setAttribute("attributes",attributes);

String cMode = (String) request.getSession().getAttribute("currentMode");
String stat = cMode;
String align = "center";
String dir = null;
String style = null;
String headerItem = null;
String bgColor="#c8d8f8";
String lang,langCode, cancel, title;
String catName,total,catDesc,appr,excel,pageTitle , pageTitleTip;
if(stat.equals("En")){
    dir = "LTR";
    style = "text-align:right";
    lang = "&#1593;&#1585;&#1576;&#1610;";
    langCode = "Ar";
    cancel = "Cancel";
    catName="Category Name";
    total="Number Of Categories";
    title="Main Categories Reprot";
    appr="Appreviation";
    catDesc="Category Description";
    excel="Excel";
     pageTitle="RPT-EQP-MAINTYPE-1";
     pageTitleTip="Equip Maint Type Report";
}else{
    dir = "RTL";
    style = "text-align:Right";
    lang = "English";
    langCode = "En";
    cancel = "&#1593;&#1608;&#1583;&#1607;";
    catName="&#1575;&#1604;&#1575;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1575;&#1587;&#1575;&#1587;&#1610;&#1607;";
    total="&#1593;&#1583;&#1583; &#1575;&#1604;&#1575;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1575;&#1587;&#1575;&#1587;&#1610;&#1607;";
    title="&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1575;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1575;&#1587;&#1575;&#1587;&#1610;&#1607;";
    appr="&#1575;&#1604;&#1575;&#1582;&#1578;&#1589;&#1575;&#1585;";
    catDesc="&#1575;&#1604;&#1608;&#1589;&#1601;";
    excel="&#1575;&#1603;&#1587;&#1604;";
       pageTitle="RPT-EQP-MAINTYPE-1";
       pageTitleTip="&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1575;&#1606;&#1608;&#1575;&#1593; &#1575;&#1604;&#1575;&#1587;&#1575;&#1587;&#1610;&#1607; &#1604;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
}
%>

<SCRIPT LANGUAGE="JavaScript" SRC="js/ChangeLang.js" TYPE="text/javascript">  </SCRIPT>

<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

     function cancelForm()
        {
           document.EQP_REPORT_FORM.action = "<%=context%>/ReportsServlet?op=mainPage";
           document.EQP_REPORT_FORM.submit();
        }

    function changePage(url){
            window.navigate(url);
    }
</script>

<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
        <META HTTP-EQUIV="Expires" CONTENT="0">
        <script src="js/sorttable.js"></script>
        <style>
            .th{text-align:Center;padding:.2em;border:1px solid #000;background:#328aa4 url(tr_back.gif) repeat-x;color:#fff;}
            .even{background:#e5f1f4;}
            .odd{background:#f8fbfc;}
            td{border:0px;padding:.3em;}
        </style>
    </head>
    
    <body>
        <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <FORM NAME="EQP_REPORT_FORM" METHOD="POST">
            <table border="0" width="100%" dir="LTR">
                <button  onclick="JavaScript: cancelForm();" width="50"><%=cancel%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif"></button>
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                <!--button    dir="<%=dir%> " onclick="changePage('<%=context%>/EquipmentServlet?op=extractToExcelCategories')" class="button"><%=excel%> <img src="<%=context%>/images/xlsicon.gif"></button-->
            </table> 
            
             <table border="0" width="100%" id="table1">
                <tr>
                    <td width="48%" align="center">
                        <img border="0" src="images/<%=logos.get("comLogo1").toString()%>" width="300" height="120">
                    </td>
                    <td width="50%" align="center">
                        <img border="0" src="images/<%=logos.get("comTitle").toString()%>" width="386" height="57">
                    </td>
                </tr>
            </table>

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


            <center>
                <table dir="<%=dir%>" align="<%=align%>">
                    <tr>
                        <td bgcolor="#FFFFFF">
                            <b><font size="5" color="blue"><%=title%></font>
                        </td>
                    </tr>
                </table>
                <br>
                <table width="90%" bgcolor="#E6E6FA">
                    <tr>                        
                        <td width="30%" align="center" style="border-style: ridge;border-width: 1px;border-color: black;">
                            <b><font color="black" size="3"> <%=mainCategories.size()%></font></b>
                        </td>
                        <td width="30%" align="center" style="border-style: ridge;border-width: 1px;border-color: black;">
                            <b><font color="black" size="3"> <%=total%></font></b>
                        </td>
                    </tr>
                </table>
                <br>
                <table class='sortable' dir="<%=dir%>" align="<%=align%>" width="90%">
                   
                        <tr >
                            <td align="center" bgcolor="gray" width="10" style="cursor:pointer;border-style: ridge;border-width: 1px;border-color: black;">
                                <b><Font size="3">#</FONT></B>
                            </td>
                            <td align="center" bgcolor="gray" style="cursor:pointer;border-style: ridge;border-width: 1px;border-color: black;">
                                <b><Font size="3"><%=catName%></FONT></B>
                            </td>
                            <td align="center" bgcolor="gray" style="cursor:pointer;border-style: ridge;border-width: 1px;border-color: black;">
                                <b><Font size="3"><%=appr%></FONT></B>
                            </td>
                            <td align="center" bgcolor="gray" style="cursor:pointer;border-style: ridge;border-width: 1px;border-color: black;">
                                <b><Font size="3"><%=catDesc%></FONT></B>
                            </td>
                        </tr>
                    
                    
                    <%
                    if(mainCategories.size()>0){
    for(int j=0; j<mainCategories.size(); j++){
        WebBusinessObject category = (WebBusinessObject) mainCategories.get(j);
        if(bgColor.equalsIgnoreCase("#c8d8f8"))
            bgColor="white";
        else
            bgColor="#c8d8f8";
                    %>
                    
                        <tr bgcolor="<%=bgColor%>">
                            <td class="td" style="border-width:1px;" align="center"  width="10" style="border-style: ridge;border-width: 1px;border-color: black;">
                                <%=j+1%>
                            </td>
                            <td class="td" align="center" style="border-style: ridge;border-width: 1px;border-color: black;">
                                <%=category.getAttribute("typeName")%>
                            </td>
                            <td class="td" align="center" style="border-style: ridge;border-width: 1px;border-color: black;">
                                <%=category.getAttribute("appreviation")%>
                            </td>
                            <td class="td" align="center" style="border-style: ridge;border-width: 1px;border-color: black;">
                                <%=category.getAttribute("notes")%>
                            </td>
                        </tr>
                   
                    <%}}else{%>
                    <TR>
                        <TD BGCOLOR="<%=bgColor%>" ALIGN="<%=align%>" style="border-style: ridge;border-width: 1px;border-color: black;">
                            <b><font color="red">No Equipments related to this Main category</font></b>
                        </TD>           
                    </TR>
                    <%
                    }
                    %>
                     
                </table>
                
            </center>
        </FORM>
    </body>
</html>