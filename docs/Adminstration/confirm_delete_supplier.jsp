<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>
    <%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    
    String supplierID = (String) request.getAttribute("supplierID");
    String supplierName = (String) request.getAttribute("supplierName");
    String supplierNo = (String) request.getAttribute("supplierNo");
    boolean canDelete = (Boolean) request.getAttribute("canDelete");
    
    String cMode= (String) request.getSession().getAttribute("currentMode");
    String  stat=cMode;
    String align=null;
    String dir=null;
    String style=null;
    String lang,langCode;
    String sup_number, save, sup_name, TT;
    String title_1,title_2;
    String cancel_button_label;
    if(stat.equals("En")){
        align="center";
        dir="LTR";
        style="text-align:left";
        lang="   &#1593;&#1585;&#1576;&#1610;    ";
        sup_name = "Supplier name";
        sup_number = "Supplier number";
        TT="Cannot Delete This Supplier Because Is Linked With External Job Order";
        title_1="Delete supplier";
        title_2="Delete Supplier - <font color=#F3D596>Are you Sure ?</font>";
        cancel_button_label="Back To List ";
        langCode="Ar";
        save="Delete";
    }else{
        align="center";
        dir="RTL";
        style="text-align:Right";
        lang="English";
        save=" &#1573;&#1581;&#1584;&#1601;";
        sup_name = "&#1573;&#1587;&#1605; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;";
        sup_number = "&#1585;&#1602;&#1605; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583;";
        title_1="&#1581;&#1600;&#1600;&#1600;&#1600;&#1584;&#1601; &#1605;&#1600;&#1600;&#1600;&#1600;&#1608;&#1585;&#1583;";
        title_2="&#1581;&#1600;&#1600;&#1600;&#1600;&#1584;&#1601; &#1605;&#1600;&#1600;&#1600;&#1600;&#1608;&#1585;&#1583; - <font color=#F3D596>&#1607;&#1600;&#1600;&#1604; &#1571;&#1606;&#1600;&#1600;&#1578; &#1605;&#1600;&#1600;&#1578;&#1600;&#1600;&#1571;&#1603;&#1600;&#1600;&#1600;&#1600;&#1583; &#1567;</font>";
        cancel_button_label="&#1575;&#1604;&#1593;&#1608;&#1583;&#1577; &#1573;&#1604;&#1609; &#1575;&#1604;&#1602;&#1575;&#1574;&#1605;&#1577; ";
        langCode="En";
        TT="&#1604;&#1575; &#1610;&#1605;&#1603;&#1606; &#1581;&#1584;&#1601; &#1607;&#1584;&#1575; &#1575;&#1604;&#1605;&#1608;&#1585;&#1583; &#1604;&#1571;&#1606;&#1607; &#1605;&#1585;&#1578;&#1576;&#1591; &#1576;&#1600;&#1600; &#1571;&#1608;&#1575;&#1605;&#1585; &#1588;&#1594;&#1604; &#1582;&#1575;&#1585;&#1580;&#1610;&#1577;";  
    }
    
    %>
    
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">
    
    <HEAD>
        <TITLE></TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    <script language="javascript" type='text/javascript'>
        function submitForm() {
          document.DELETE_SUPPLIER_FORM.action = "<%=context%>/SupplierServlet?op=delete&supplierId=<%=supplierID%>&supplierName=<%=supplierName%>&supplierNo=<%=supplierNo%>";
          document.DELETE_SUPPLIER_FORM.submit();
       }

        function cancelForm() {
            document.DELETE_SUPPLIER_FORM.action = "<%=context%>/SupplierServlet?op=ListSuppliers";
            document.DELETE_SUPPLIER_FORM.submit();
        }
    </script>
    <BODY>
        <FORM action=""  NAME="DELETE_SUPPLIER_FORM" METHOD="POST">
            <DIV align="left" STYLE="color:blue; padding-bottom: 10px; padding-left: 5%">
                <input type="button" value="<%=lang%>" onclick="reloadAE('<%=langCode%>')" class="button">
                &ensp;
                <button  onclick="JavaScript: cancelForm()" class="button"><%=cancel_button_label%></button>
                <% if(canDelete) { %>
                    &ensp;
                    <button onclick="submitForm()" class="button"><%=save%></button>
                <% } %>
            </DIV>
            <CENTER>
                <FIELDSET class="set" style="border-color: #006699; width: 90%">
                    <TABLE class="blueBorder" dir="<%=dir%>" align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <TR>
                            <TD style="text-align:center;border-color: #006699;" width="100%" class="blueBorder blueHeaderTD">
                                <FONT color='white' SIZE="+1">
                                    <% if(canDelete) { %>
                                        <%=title_2%>
                                    <% } else  { %>
                                        <%=title_1%>
                                    <% } %>
                                </FONT>
                            </TD>
                        </TR>
                    </TABLE>
                    <BR>
                    <% if(canDelete) { %>
                    <TABLE class="backgroundTable" CELLPADDING="0" CELLSPACING="5" width="60%" BORDER="0" ALIGN="<%=align%>" DIR="<%=dir%>">
                        <TR>
                            <TD STYLE="<%=style%>; padding: 5px;" class='backgroundHeader' width="30%">
                                <p><b><%=sup_number%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>; padding: 5px" class='TD' width="70%">
                                <input readonly type="TEXT" style="width:100%" name="supplierNO" ID="supplierNO" value="<%=supplierNo%>">
                                <input type="hidden" name="supplierId" ID="supplierId" value="<%=supplierID%>">
                            </TD>
                        </TR>
                        <TR>
                            <TD STYLE="<%=style%>; padding: 5px" class='backgroundHeader' width="30%">
                                <p><b><%=sup_name%></b></p>
                            </TD>
                            <TD STYLE="<%=style%>; padding: 5px" class='TD' width="70%">
                                <input readonly type="TEXT" style="width:100%" name="supplierName" ID="supplierName" value="<%=supplierName%>">
                            </TD>
                        </TR>
                    </TABLE>
                    <% } else { %>
                    <TABLE class="blueBorder" cellspacing="0" cellpadding="0" align="<%=align%>" dir="<%=dir%>" width="90%">
                        <TR>
                            <TD class="backgroundTable">
                                <b><font size=4 color='red'><%=TT%></font></b>
                            </TD>
                        </TR>
                    </TABLE>
                    <% } %>
                    <BR>
                </FIELDSET>
            </CENTER>
        </FORM>
    </BODY>
</HTML>     
