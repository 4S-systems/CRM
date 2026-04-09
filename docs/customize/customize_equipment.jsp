<%@page import="com.customization.common.CustomizeEquipmentMgr"%>
<%@page import="com.customization.model.Customization"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*,com.tracker.business_objects.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page import="com.maintenance.db_access.*" %>
<HTML>

    <%
    CustomizeEquipmentMgr customizeEquipmentMgr = CustomizeEquipmentMgr.getInstance();
    Customization customizationProductionLine = customizeEquipmentMgr.getCustomization(CustomizeEquipmentMgr.PRODUCTION_LINE_ELEMENT);

    String message = (String) request.getAttribute("message");
        if(message == null) message = "";

    String[] shifts = new String[4];
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang, langCode, ProductionLine;
  //  if(stat.equals("En")){

        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        langCode="Ar";
        shifts[0]="Shift 1";
        shifts[1]="Shift 2";
        shifts[2]="shift 3";
        shifts[3]="Daylight";
        ProductionLine = "Production Line";
  //  }else{
//
    //    align="center";
    //    dir="RTL";
      //  style="text-align:Right";
    //    lang="English";
    //    langCode="En";
    //    shifts[0]="&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607; : 1";
   //     shifts[1]="&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607; : 2";
   //     shifts[2]="&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607; : 3";
   //     shifts[3]="&#1606;&#1607;&#1575;&#1585;&#1609;";
     //   shift="&#1575;&#1604;&#1608;&#1585;&#1583;&#1610;&#1607;";
   //     trade="&#1606;&#1608;&#1593; &#1575;&#1605;&#1585; &#1575;&#1604;&#1593;&#1605;&#1604;";
   // }
    %>

    <script type="text/javascript" language="JAVASCRIPT">
        function submitForm(){
            EQUIPMENT_CUSTOMIZATION_FORM.action = "CustomizationServlet?op=saveEquipmentForm";
            EQUIPMENT_CUSTOMIZATION_FORM.submit();
        }
    </script>

    <style>
        .hideStyle{
            visibility:hidden
        }
        .borderStyle{
            border-bottom:black solid 1px;
            border-left-width:0px;
            border-right-width:0px;
            border-top-width:0px
        }
    </style>

    <script src='ChangeLang.js' type='text/javascript'></script>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Customize-Issue</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>

    <BODY STYLE="background-color:#F5F5F5">
        <FORM NAME="EQUIPMENT_CUSTOMIZATION_FORM" METHOD="POST" action="">
            <DIV align="left" STYLE="color:blue;padding-left:2.5%; padding-bottom: 10px">
                <input type="button" value="Save Status" onclick="JavaScript:submitForm()" STYLE="font-size:15px;color:black;font-weight:bold;width:150px">
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="border-color: #006699; width: 95%">
                    <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <FONT color='#F3D596' SIZE="4">Customize Equipment Screen</FONT>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <%if(message.equals("saveComplete")){%>
                    <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="LTR" align="<%=align%>" width="80%">
                        <TR>
                            <TD CLASS="td" BGCOLOR="#657383" STYLE="color:white;font-weight:bold;font-style:oblique;font-size:16px;text-align:center">
                                 Process Save Complete
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                    <%}%>
                    <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="RTL" align="<%=align%>" width="80%">
                        <TR>
                            <TD STYLE="color:white;font-weight:bold;font-style:oblique;font-size:18px; height:30px" BGCOLOR="#696565">
                                <b>Hide</b>
                            </TD>
                            <TD STYLE="color:white;font-weight:bold;font-style:oblique;font-size:18px" BGCOLOR="#696565">
                                <b>Name of Field</b>
                            </TD>
                        </TR>
                        <TR STYLE="padding-top:5px;padding-bottom:3px; cursor: pointer" onmouseover="this.className = 'rowHilight'" onmouseout="this.className = ''">
                            <TD class='borderStyle' STYLE="padding-left:20px;padding-right:20px">
                                <input type="checkbox" align="middle" id="checkProductionLine" name="checkProductionLine" <%if(!customizationProductionLine.display()){%> checked <%}%>/>
                            </TD>
                            <TD class='borderStyle' STYLE="font-weight:bold;text-align:center">
                                <%=ProductionLine%>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>
