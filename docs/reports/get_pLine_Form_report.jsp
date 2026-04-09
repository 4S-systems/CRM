<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.contractor.db_access.MaintainableMgr;"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>

<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();

MaintainableMgr maintainableMgr=MaintainableMgr.getInstance();

ArrayList pLines=(ArrayList)request.getAttribute("pLines");

WebBusinessObject wbo = null;
TouristGuide tGuide = new TouristGuide("/com/silkworm/international/BasicForms");
String cMode = (String) request.getSession().getAttribute("currentMode");
String stat = cMode;
String align=null;
String dir=null;
String style=null;
String lang,langCode;
String pLName,name, modelNo,serialNo,subTitle,serviceEntryDate,enginNo,manufacturer,typeOfRate,desc,eqStatus,title,save_button_label,cancel_button_label,typeOfOperation,noOfHours,unitNo;
String allProLine , pageTitle , pageTitleTip;
    if(stat.equals("En")){
    
    align="center";
    dir="RTL";
    langCode = "Ar";
    style="text-align:Right";
    lang="&#1593;&#1585;&#1576;&#1610;";
    pLName="Production Line Name";
    enginNo="Engine Number";
    modelNo="Moder Number";
    serialNo="Serial Number";
    eqStatus="Equipment Status";
    manufacturer="Manufacturer";
    typeOfOperation="Type Of Rate";
    title="Select Fields Of Equipment Reprot According <br> To Production Line";
    cancel_button_label="Cancel";
    save_button_label="Generate Report";
    typeOfRate="Operation Type";
    desc="Equipment Description";
    noOfHours="No Of Hours";
    subTitle="Report Items";
    name = "Equipment Name";
    serviceEntryDate="Service Entry Date";
    unitNo="Equipment Code";
    allProLine = "ALL";
    pageTitle="RPT-EQP-PLINE-9";
    pageTitleTip="Equipment By The Production Line";
}else{
    
    align="center";
    dir="LTR";
    langCode = "En";
    style="text-align:left";
    lang="English";
    pLName="&#1582;&#1591; &#1575;&#1604;&#1575;&#1606;&#1578;&#1575;&#1580;";
    enginNo="&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1578;&#1608;&#1585;";
    modelNo="&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1583;&#1610;&#1604;";
    serialNo="&#1585;&#1602;&#1605; &#1575;&#1604;&#1587;&#1585;&#1610;&#1575;&#1604;";
    eqStatus="&#1581;&#1575;&#1604;&#1607; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    manufacturer="&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1589;&#1606;&#1593;";
    typeOfOperation="&#1606;&#1608;&#1593; &#1593;&#1605;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    title="&#1575;&#1582;&#1578;&#1610;&#1575;&#1585; &#1593;&#1606;&#1575;&#1589;&#1585; &#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;<br> &#1581;&#1587;&#1576; &#1582;&#1591;&#1608;&#1591; &#1575;&#1604;&#1575;&#1606;&#1578;&#1575;&#1580;";
    save_button_label="&#1575;&#1587;&#1578;&#1582;&#1585;&#1575;&#1580; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
    cancel_button_label="&#1593;&#1608;&#1583;&#1607;";
    typeOfRate="&#1606;&#1608;&#1593; &#1575;&#1604;&#1593;&#1605;&#1604;&#1610;&#1607;";
    desc="&#1608;&#1589;&#1601; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    noOfHours="&#1605;&#1578;&#1608;&#1587;&#1591; &#1575;&#1604;&#1593;&#1605;&#1604; &#1575;&#1604;&#1610;&#1608;&#1605;&#1610;";
    subTitle="&#1593;&#1606;&#1575;&#1589;&#1585; &#1575;&#1604;&#1578;&#1602;&#1585;&#1610;&#1585;";
    name = "&#1575;&#1587;&#1605; &#1575;&#1604;&#1605;&#1593;&#1583;&#1577;";
    serviceEntryDate="&#1578;&#1575;&#1585;&#1610;&#1582; &#1583;&#1582;&#1608;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607; &#1575;&#1604;&#1608;&#1585;&#1588;&#1607;";
    unitNo="&#1603;&#1608;&#1583; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
    allProLine = "&#1575;&#1604;&#1603;&#1604;";
    pageTitle="RPT-EQP-PLINE-9";
    pageTitleTip="&#1578;&#1602;&#1585;&#1610;&#1585; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578; &#1581;&#1587;&#1576; &#1582;&#1591;&#1608;&#1591; &#1575;&#1604;&#1575;&#1606;&#1578;&#1575;&#1580;";
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
           document.USERS_FORM.action = "<%=context%>/ReportsServlet?op=ProductionLineEqpsReport";
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
                            <b><font size="2" color="red"><%=pLName%></font></b>
                        </TD>
                        <TD class='td'>
                            <SELECT name="productLineId" ID="productLineId" STYLE="width:233;">
                                <sw:WBOOptionList wboList='<%=pLines%>' displayAttribute = "code" valueAttribute="id"/>
                                <option value="ALL"><%=allProLine%>
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
                            <%=name%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="equipmentData" value="UNIT_NAME" checked disabled>
                            </TD>
                    </TR>
                    
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=unitNo%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="equipmentData" value="UNIT_NO" checked disabled>
                            </TD>
                    </TR> 
                    
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=enginNo%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="equipmentData" value="ENGINE_NUMBER" checked>
                            </TD>
                    </TR> 
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=modelNo%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="equipmentData" value="MODEL_NO" checked>
                            </TD>
                    </TR> 
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=serialNo%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="equipmentData" value="SERIAL_NO" checked>
                            </TD>
                    </TR> 
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=manufacturer%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="equipmentData" value="MANUFACTURER" checked>
                            </TD>
                    </TR> 
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=eqStatus%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="equipmentData" value="STATUS" checked>
                            </TD>
                    </TR> 
                    
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=typeOfRate%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="equipmentData" value="TYPE_OF_RATE" checked>
                            </TD>
                    </TR> 
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=typeOfOperation%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="equipmentData" value="TYPE_OF_OPERATION" checked>
                            </TD>
                    </TR> 
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=noOfHours%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="equipmentData" value="NO_OF_HOURS" checked>
                            </TD>
                    </TR> 
                    
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=serviceEntryDate%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="equipmentData" value="SERVICE_ENTRY_DATE" checked>
                            </TD>
                    </TR> 
                    
                    <TR class='td' >
                        <TD nowrap CLASS="firstname" WIDTH="570" STYLE="border-top-WIDTH:0; font-size:12;">
                            <%=desc%>
                        </TD>
                        <TD VALIGN="BOTTOM" STYLE="border-top-WIDTH:0;" WIDTH="30">
                            <input type="checkbox" name="equipmentData" value="DESCRIPTION" checked>
                            </TD>
                    </TR> 
                </TABLE>     
                <br>
            </FIELDSET>
        </FORM>
    </BODY>
</HTML>     
