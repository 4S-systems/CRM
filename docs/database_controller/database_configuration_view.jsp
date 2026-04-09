<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.DatabaseController.db_access.DatabaseConfigurationMgr"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<HTML>

    <%
        String userFound = "images/user_accept.png";
        String userNotFound = "images/delete_user.png";

        WebBusinessObject basicUrlInfo = (WebBusinessObject) request.getAttribute("basicUrlInfo");
        String basicHosting = (String) basicUrlInfo.getAttribute(DatabaseConfigurationMgr.HOSTING);
        String basicPort = (String) basicUrlInfo.getAttribute(DatabaseConfigurationMgr.PORT);
        String basicServiceId = (String) basicUrlInfo.getAttribute(DatabaseConfigurationMgr.SERVICE_ID);

        MetaDataMgr metaDataMgr = MetaDataMgr.getInstance();
        String url = metaDataMgr.getDataBaseErpUrl();

        int indexOf_1 = url.indexOf("@");
        url = url.substring(indexOf_1);
        int indexOf_2 = url.indexOf(":");
        int indexOf_3 = url.lastIndexOf(":");

        String StoresHost = url.substring(1, indexOf_2);
        String StoresPort = url.substring(indexOf_2 + 1, indexOf_3);
        String StoresService = url.substring(indexOf_3 + 1);

        WebBusinessObject erpUrlInfo = (WebBusinessObject) request.getAttribute("erpUrlInfo");
        String erpHosting = (String) erpUrlInfo.getAttribute(DatabaseConfigurationMgr.HOSTING);
        String erpPort = (String) erpUrlInfo.getAttribute(DatabaseConfigurationMgr.PORT);
        String erpServiceId = (String) erpUrlInfo.getAttribute(DatabaseConfigurationMgr.SERVICE_ID);

        String basicUser = (String) request.getAttribute("basicUser");

        String erpGerneralLedgerUser = (String) request.getAttribute("erpGerneralLedgerUser");
        boolean statusErpGerneralLedgerUser = (Boolean) request.getAttribute("statusErpGerneralLedgerUser");
        String erpStoreUser = (String) request.getAttribute("erpStoreUser");
        boolean statusErpStoreUser = (Boolean) request.getAttribute("statusErpStoreUser");
        String erpPayrollUser = (String) request.getAttribute("erpPayrollUser");
        boolean statusErpPayrollUser = (Boolean) request.getAttribute("statusErpPayrollUser");
        
        boolean statusAsset = (Boolean) request.getAttribute("statusAsset");
        boolean statusStores = (Boolean) request.getAttribute("statusStores");

        String imageSuccess = "images/ok_white.png";
        String imageFail = "images/cancel_white.png";
    %>

    <script type="text/javascript" language="JAVASCRIPT">
        function cancelForm(){
            DATABASE_CONFIGURATION_VIEW.action = "CustomizationServlet?op=saveIssueForm";
            DATABASE_CONFIGURATION_VIEW.submit();
        }
    </script>

    <style type="text/css">
        .mainHeaderNormal {
            background-color: #E6E6FA;
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
        <FORM action=""  NAME="DATABASE_CONFIGURATION_VIEW" METHOD="POST">
            <CENTER>
                <BR/>
                <BR/>
                <FIELDSET class="set" style="width:90%;border-color: #006699" >
                    <table class="blueBorder" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <font color="#F3D596" size="4">Databases Configuration</font>
                            </td>
                        </tr>
                    </table>
                    <br/>
                    <TABLE WIDTH="90%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER">
                        <TR>
                            <TD style="border: none" align="center" width="30%">
                                <img alt="Database Configuration" src="images/DatabaseConfiguration.png" width="256" height="256" style="border: none; vertical-align: middle;" />
                            </TD>
                            <TD style="border: none" width="70%">
                                <TABLE CLASS="blueBorder" style="border-color: silver" WIDTH="100%" CELLPADDING="0" CELLSPACING="0" ALIGN="CENTER">
                                    <TR style="cursor: pointer;" class="mainHeaderNormal" onmousemove="this.className='rowHilight'" onmouseout="this.className='mainHeaderNormal'">
                                        <TD colspan="3" STYLE="text-align:left;border-top-width: 0px;padding-left: 10px;font-size: 14px; height: 25px">
                                            <%="Maintenance Schema"%>
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer" onmousemove="this.className='rowHilight'" onmouseout="this.className=''">
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px;color: blue; font-size: 12px; height: 20px">
                                            <%="Hosting"%>
                                        </TD>
                                        <TD colspan="2" STYLE="text-align:left;border-top-width: 0px;padding-left: 40px; font-size: 12px; height: 20px">
                                            <%=basicHosting%>
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer" onmousemove="this.className='rowHilight'" onmouseout="this.className=''">
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px;color: blue; font-size: 12px; height: 20px">
                                            <%="Port"%>
                                        </TD>
                                        <TD colspan="2" STYLE="text-align:left;border-top-width: 0px;padding-left: 40px; font-size: 12px; height: 20px">
                                            <%=basicPort%>
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer" onmousemove="this.className='rowHilight'" onmouseout="this.className=''">
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px;color: blue; font-size: 12px; height: 20px">
                                            <%="Service ID"%>
                                        </TD>
                                        <TD colspan="2" STYLE="text-align:left;border-top-width: 0px;padding-left: 40px; font-size: 12px; height: 20px">
                                            <%=basicServiceId%>
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer" class="act_sub_heading" onmousemove="this.className='rowHilight'" onmouseout="this.className='act_sub_heading'">
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px;color: blue; font-size: 12px; height: 20px">
                                            <%="User"%>
                                        </TD>
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px; font-size: 12px; height: 20px">
                                            <%=basicUser%>
                                        </TD>
                                        <TD STYLE="text-align:center;border-top-width: 0px;; font-size: 12px; height: 20px">
                                            <img alt="user found" src="<%=userFound%>" align="middle" />
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer;" class="mainHeaderNormal" onmousemove="this.className='rowHilight'" onmouseout="this.className='mainHeaderNormal'">
                                        <TD colspan="3" STYLE="text-align:left;border-top-width: 0px;padding-left: 10px;font-size: 14px; height: 25px">
                                            <%="ERP Schemas"%>
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer" onmousemove="this.className='rowHilight'" onmouseout="this.className=''">
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px;color: blue; font-size: 12px; height: 20px">
                                            <%="Hosting"%>
                                        </TD>
                                        <TD colspan="2" STYLE="text-align:left;border-top-width: 0px;padding-left: 40px; font-size: 12px; height: 20px">
                                            <%=erpHosting%>
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer" onmousemove="this.className='rowHilight'" onmouseout="this.className=''">
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px;color: blue; font-size: 12px; height: 20px">
                                            <%="Port"%>
                                        </TD>
                                        <TD colspan="2" STYLE="text-align:left;border-top-width: 0px;padding-left: 40px; font-size: 12px; height: 20px">
                                            <%=erpPort%>
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer" onmousemove="this.className='rowHilight'" onmouseout="this.className=''">
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px;color: blue; font-size: 12px; height: 20px">
                                            <%="Service ID"%>
                                        </TD>
                                        <TD colspan="2" STYLE="text-align:left;border-top-width: 0px;padding-left: 40px; font-size: 12px; height: 20px">
                                            <%=erpServiceId%>
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer" class="act_sub_heading" onmousemove="this.className='rowHilight'" onmouseout="this.className='act_sub_heading'">
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px;color: blue; font-size: 12px; height: 20px">
                                            <%="Gerneral Ledger User"%>
                                        </TD>
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px; font-size: 12px; height: 20px">
                                            <%=erpGerneralLedgerUser%>
                                        </TD>
                                        <TD STYLE="text-align:center;border-top-width: 0px; font-size: 12px; height: 20px">
                                            <% if (statusErpGerneralLedgerUser) {%>
                                            <img alt="user found" src="<%=userFound%>" align="middle" />
                                            <% } else {%>
                                            <img alt="user found" src="<%=userNotFound%>" align="middle" />
                                            <% }%>
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer" class="act_sub_heading" onmousemove="this.className='rowHilight'" onmouseout="this.className='act_sub_heading'">
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px;color: blue; font-size: 12px; height: 20px">
                                            <%="Payroll User"%>
                                        </TD>
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px; font-size: 12px; height: 20px">
                                            <%=erpPayrollUser%>
                                        </TD>
                                        <TD STYLE="text-align:center;border-top-width: 0px; font-size: 12px; height: 20px">
                                            <% if (statusErpPayrollUser) {%>
                                            <img alt="user found" src="<%=userFound%>" align="middle" />
                                            <% } else {%>
                                            <img alt="user found" src="<%=userNotFound%>" align="middle" />
                                            <% }%>
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer" class="act_sub_heading" onmousemove="this.className='rowHilight'" onmouseout="this.className='act_sub_heading'">
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px;color: blue; font-size: 12px; height: 20px">
                                            <%="Store User"%>
                                        </TD>
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px; font-size: 12px; height: 20px">
                                            <%=erpStoreUser%>
                                        </TD>
                                        <TD STYLE="text-align:center;border-top-width: 0px; font-size: 12px; height: 20px">
                                            <% if (statusErpStoreUser) {%>
                                            <img alt="user found" src="<%=userFound%>" align="middle" />
                                            <% } else {%>
                                            <img alt="user found" src="<%=userNotFound%>" align="middle" />
                                            <% }%>
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer;" class="mainHeaderNormal" onmousemove="this.className='rowHilight'" onmouseout="this.className='mainHeaderNormal'">
                                        <TD colspan="3" STYLE="text-align:left;border-top-width: 0px;padding-left: 10px;font-size: 14px; height: 25px">
                                            <%="Stores Schema"%>
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer" onmousemove="this.className='rowHilight'" onmouseout="this.className=''">
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px;color: blue; font-size: 12px; height: 20px">
                                            <%="Hosting"%>
                                        </TD>
                                        <TD colspan="2" STYLE="text-align:left;border-top-width: 0px;padding-left: 40px; font-size: 12px; height: 20px">
                                            <%=StoresHost%>
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer" onmousemove="this.className='rowHilight'" onmouseout="this.className=''">
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px;color: blue; font-size: 12px; height: 20px">
                                            <%="Port"%>
                                        </TD>
                                        <TD colspan="2" STYLE="text-align:left;border-top-width: 0px;padding-left: 40px; font-size: 12px; height: 20px">
                                            <%=StoresPort%>
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer" onmousemove="this.className='rowHilight'" onmouseout="this.className=''">
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px;color: blue; font-size: 12px; height: 20px">
                                            <%="Service ID"%>
                                        </TD>
                                        <TD colspan="2" STYLE="text-align:left;border-top-width: 0px;padding-left: 40px; font-size: 12px; height: 20px">
                                            <%=StoresService%>
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer" class="act_sub_heading" onmousemove="this.className='rowHilight'" onmouseout="this.className='act_sub_heading'">
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px;color: blue; font-size: 12px; height: 20px">
                                            <%="Asset ERP User"%>
                                        </TD>
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px; font-size: 12px; height: 20px">
                                            <%=metaDataMgr.getAssetErpName()%>
                                        </TD>
                                        <TD STYLE="text-align:center;border-top-width: 0px;; font-size: 12px; height: 20px">
                                            <% if (statusAsset) {%>
                                            <img alt="user found" src="<%=userFound%>" align="middle" />
                                            <% } else {%>
                                            <img alt="user found" src="<%=userNotFound%>" align="middle" />
                                            <% }%>
                                        </TD>
                                    </TR>
                                    <TR style="cursor: pointer" class="act_sub_heading" onmousemove="this.className='rowHilight'" onmouseout="this.className='act_sub_heading'">
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px;color: blue; font-size: 12px; height: 20px">
                                            <%="Stores ERP User"%>
                                        </TD>
                                        <TD STYLE="text-align:left;border-top-width: 0px;padding-left: 40px; font-size: 12px; height: 20px">
                                            <%=metaDataMgr.getStoreErpName()%>
                                        </TD>
                                        <TD STYLE="text-align:center;border-top-width: 0px;; font-size: 12px; height: 20px">
                                            <% if (statusStores) {%>
                                            <img alt="user found" src="<%=userFound%>" align="middle" />
                                            <% } else {%>
                                            <img alt="user found" src="<%=userNotFound%>" align="middle" />
                                            <% }%>
                                        </TD>
                                    </TR>
                                </TABLE>
                            </TD>
                        </TR>
                    </TABLE>
                    <br>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>
