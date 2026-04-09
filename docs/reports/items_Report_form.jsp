<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.contractor.db_access.MaintainableMgr;"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

MaintainableMgr maintainableMgr=MaintainableMgr.getInstance();

ArrayList categories=(ArrayList)request.getAttribute("data");

WebBusinessObject wbo = null;
TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
String cMode = (String) request.getSession().getAttribute("currentMode");
String stat = cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;
String category,subTitle,title,save_button_label,cancel_button_label,itemName,itemCode,requiredJob,tradeName,typeOfTask,workingType,duration,engDesc;
String eqName,allBrand ,pageTitle , pageTitleTip;
    if(stat.equals("En")){
    
    align="center";
    dir="RTL";
    langCode = "Ar";
    style="text-align:Right";
    lang="&#1593;&#1585;&#1576;&#1610;";
    cancel_button_label="Cancel";
    save_button_label="Generate Report";
    itemCode="Item Code";
    itemName="Item Name";
    requiredJob="Required Job";
    tradeName="Trade Name";
    typeOfTask="Type Of Task";
    workingType="Working Type";
    duration="Execution Duration";
    title="Select Fields Of Item Reprot";
    subTitle="Report Fields";
    category="Category Name";
    engDesc="English Description";
    eqName="Brand Name";
    allBrand = "ALL";
    pageTitle="RPT-MNTNCE-ITEM-MAKE-MO-2";
    pageTitleTip="Maintenance Item For The Model Report";
}else{
    
    align="center";
    dir="LTR";
    langCode = "En";
    style="text-align:left";
    lang="English";
    save_button_label="&#1575;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
    cancel_button_label="&#1593;&#1608;&#1583;&#1607;";
    
    itemCode="&#1603;&#1608;&#1583; &#1575;&#1604;&#1576;&#1606;&#1583;";
    itemName="&#1608;&#1589;&#1601; &#1575;&#1604;&#1576;&#1606;&#1583;";
    requiredJob="&#1575;&#1604;&#1605;&#1607;&#1606;&#1607; &#1575;&#1604;&#1605;&#1591;&#1604;&#1608;&#1576;&#1607;";
    tradeName="&#1575;&#1604;&#1605;&#1580;&#1605;&#1608;&#1593;&#1577; &#1575;&#1604;&#1601;&#1606;&#1610;&#1577;";
    typeOfTask="&#1606;&#1608;&#1593; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1577;";
    workingType="&#1581;&#1580;&#1605; &#1575;&#1604;&#1593;&#1605;&#1604;";
    duration="&#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1587;&#1575;&#1593;&#1575;&#1578;";
    title="&#1575;&#1582;&#1578;&#1610;&#1575;&#1585; &#1593;&#1606;&#1575;&#1589;&#1585; &#1578;&#1602;&#1585;&#1610;&#1585; &#1576;&#1606;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607;";
    subTitle="&#1593;&#1606;&#1575;&#1589;&#1585; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
    category="&#1575;&#1587;&#1605; &#1575;&#1604;&#1589;&#1606;&#1601;";
    engDesc="&#1575;&#1604;&#1608;&#1589;&#1601; &#1576;&#1575;&#1604;&#1575;&#1606;&#1580;&#1604;&#1610;&#1586;&#1609;";
    eqName="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1575;&#1585;&#1603;&#1577;";
    allBrand = "&#1575;&#1604;&#1603;&#1604;";
    pageTitle="RPT-MNTNCE-ITEM-MAKE-MO-2";
    pageTitleTip="&#1578;&#1602;&#1585;&#1610;&#1585; &#1593;&#1585;&#1590; &#1576;&#1606;&#1608;&#1583; &#1575;&#1604;&#1589;&#1610;&#1575;&#1606;&#1607; &#1576;&#1575;&#1604;&#1606;&#1587;&#1576;&#1607; &#1604;&#1605;&#1575;&#1585;&#1603;&#1577; &#1605;&#1593;&#1583;&#1607;";

    }
%>

<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE>Document Viewer - add new user</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
        <script src='ChangeLang.js' type='text/javascript'></script>
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        {    
           document.USERS_FORM.action = "<%=context%>/ReportsServlet?op=itemReportdata";
           document.USERS_FORM.submit();
           
        }
        
        function cancelForm()
        {
           document.USERS_FORM.action = "<%=context%>/ReportsServlet?op=mainPage";
           document.USERS_FORM.submit();
        }
    </SCRIPT>
    
    <BODY>
         <script type="text/javascript" src="js/wz_tooltip.js"></script>
        <FORM NAME="USERS_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue;">
                <input type="button"  value="<%=lang%>"  onclick="reloadAE('<%=langCode%>')" class="button">
                <button    onclick="cancelForm()" class="button"><%=cancel_button_label%> <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/leftarrow.gif"></button>
                <button  onclick="JavaScript:  submitForm();" class="button"><%=save_button_label%><IMG HEIGHT="15" SRC="images/save.gif"></button>
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
                    
                    <TR>
                        <TD class='td' >
                            <b><font size="2" color="red"><%=eqName%> </font></b>
                        </TD>
                        <TD class='td'>
                            <SELECT name="categoryId" ID="categoryId" STYLE="width:233;">
                                <option value="all" selected="selected"><%=allBrand%>
                                <sw:WBOOptionList wboList='<%=categories%>' displayAttribute = "unitName" valueAttribute="id"/>                                
                            </SELECT>
                        </TD>
                    </TR>
                </TABLE>
                
                <BR>
                
                <TABLE WIDTH="600" STYLE="border-right-WIDTH:1px;" ALIGN="<%=align%>" DIR="<%=dir%>">
                    <tr>
                        <td class="head" align="cenetr" colspan="2"><%=subTitle%></td>
                    </tr>
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=itemName%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="itemData" value="TASK_NAME" checked disabled>
                            </TD>
                    </TR>
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=itemCode%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="itemData" value="CODE" checked disabled>
                        </TD>
                    </TR> 
                    
                    
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=duration%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="itemData" value="EXECUTION_HRS" checked>
                            </TD>
                    </TR> 
                    
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=typeOfTask%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="itemData" value="TASK_TITLE" checked>
                            </TD>
                    </TR> 
                    
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=workingType%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="itemData" value="REPAIR_TYPE" checked>
                            </TD>
                    </TR> 
                    
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=engDesc%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="itemData" value="ENG_DESC" checked>
                            </TD>
                    </TR> 
                    
                </TABLE>     
                <br>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
