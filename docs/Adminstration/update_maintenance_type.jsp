<%@ page import="com.silkworm.business_objects.*,com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*"%>
<%@ page import="com.contractor.db_access.*"%>  
<%@ page import="com.silkworm.international.TouristGuide"%> 
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%
MetaDataMgr metaMgr = MetaDataMgr.getInstance();
String context = metaMgr.getContext();
MaintainableMgr maintainableMgr =MaintainableMgr.getInstance();


WebBusinessObject maintenanceType = (WebBusinessObject) request.getAttribute("maintenanceType");
TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");


String status = (String) request.getAttribute("Status");
String typeId = (String) request.getAttribute("typeId");
String categoryId = (String) request.getAttribute("categoryId");
%>



<HTML>
    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Document Viewer - view Maintenance Type</TITLE>
        <LINK REL="stylesheet" TYPE="text/css" HREF="CSS.css">
    </HEAD>
    
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">

        function submitForm()
        { 
       if (this.PROJECT_VIEW_FORM.typeName.value ==""){
        alert ("Enter Maintenance Type");
        this.PROJECT_VIEW_FORM.typeName.focus();
    
     } else { 
       
        document.PROJECT_VIEW_FORM.action = "<%=context%>/EquipMaintenanceTypeServlet?op=UpdateMainType";
        document.PROJECT_VIEW_FORM.submit();  
        }
        }
        
    </SCRIPT>
    
    <BODY>
        <left>
        <FORM NAME="PROJECT_VIEW_FORM" METHOD="POST">
            <TABLE WIDTH="600" CELLPADDING="0" CELLSPACING="0" STYLE="right-WIDTH:1px;">
    <TR VALIGN="MIDDLE">
        <TD COLSPAN="2" CLASS="tabletitle" STYLE="left-WIDTH: 1;text-align:left;">
            Update Maintenance Type
        </TD>
        <TD CLASS="tabletitle" STYLE="">
            <IMG WIDTH="20" HEIGHT="20" SRC="images/corner.gif">
        </TD>
        <TD CLASS="tableright" colspan="3">
            <A HREF="<%=context%>//EquipMaintenanceTypeServlet?op=ListMainType">
                <%=tGuide.getMessage("cancel")%>
            </A>
            <IMG VALIGN="BOTTOM"  HEIGHT="15" SRC="images/cancel.gif">
            <IMG VALIGN="BOTTOM" HEIGHT="15" WIDTH="1" SRC="images/line.gif">
            <IMG SRC="images/save.gif">                        
            <A HREF="JavaScript: submitForm();">
                Update Maintenance Type
            </A>
        </TD>
    </TR>
</TABLE>
<%    if(null!=status) {

%>

<table> 
    <tr><td>
    </td></tr>
    <tr><td  align=center>  <H4> Updateing Maintenance Type Status : <%=status%></td></tr></H4>
</table>
<%
}
%>


            <TABLE CELLPADDING="0" CELLSPACING="0" BORDER="0">
                <TR>
                    <TD class='td'>
                        &nbsp;
                    </TD>
                </TR>

        
                <TR>
                    <TD class='td'>
                        <LABEL FOR="str_Function_Name">
                            <p><b>Maintenace Type :</b>&nbsp;
                        </LABEL>
                    </TD>
                    <TD class='td'>
                        <input  type="TEXT" name="typeName" ID="typeName" size="33" value="<%=maintenanceType.getAttribute("typeName")%>" maxlength="255">
                    </TD>
                </TR>
                
                <TR>
                        <TD class='td'>
                        <LABEL FOR="empNO">
                            <p><b>Equipment Category Name:</b>&nbsp;
                        </LABEL>
                    </TD>
                        <%
                        ArrayList arrayList = new ArrayList();
                        maintainableMgr.cashData();
                        arrayList = maintainableMgr.getCategoryAsBusObjects();
                        %>
                        
                        <td class='td'>
                             <%
                        if(request.getParameter("categoryId") != null){
        WebBusinessObject wbo = maintainableMgr.getOnSingleKey(request.getParameter("categoryId"));
                        %>
                        <SELECT name="categoryId">
                            <sw:WBOOptionList wboList='<%=arrayList%>' displayAttribute = "unitName" valueAttribute="id" scrollTo="<%=wbo.getAttribute("unitName").toString()%>"/>
                            
                        </SELECT>
                        <%
                        } else {
                        %>
                        <SELECT name="categoryId">
                            <sw:WBOOptionList wboList='<%=arrayList%>' displayAttribute = "unitName" valueAttribute="id"/>
                        </SELECT>
                        <%
                        }
                        %>
                        
                    </TD>
                    
                </TR>
                <input type="hidden" name="typeId" ID="typeId" value="<%=typeId%>">
            </TABLE>
        </FORM>
    </BODY>
</HTML>     
                    