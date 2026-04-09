<%@page import="com.tracker.db_access.ProjectMgr"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<!DOCTYPE html>

<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String stat = (String) request.getSession().getAttribute("currentMode");
    ArrayList<WebBusinessObject> TreeItems=(ArrayList<WebBusinessObject>)request.getAttribute("TreeItems");
    ProjectMgr projectMgr=ProjectMgr.getInstance(); 
    
    String dir,title,align,TranType,code,name; 
    
    if (stat.equals("En")) {
            dir = "ltr";
            title="View Financial Tree";
            align="right"; 
            TranType="Transaction Type";
            code="Item Code";
            name="Item Name";
            
        } else {
            dir = "rtl";
            title="عرض الشجرة الماليه";
            align="left";
            TranType="نوع الحركه"; 
           code="كود العنصر";
           name="أسم العنصر";
    }
%>
    
<html>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>  <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script src="js/silkworm_validate.js" type="text/javascript"></script>
        <script type="text/javascript" src="js/jquery-1.10.2.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <SCRIPT LANGUAGE="JavaScript" SRC="js/validator.js" TYPE="text/javascript" />
        <script type="text/javascript" src="jquery-ui/ui/jquery.effects.core.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.datepicker.js"></script>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <script type="text/javascript" src="js/jquery-ui.js"></script>
        <script src='ChangeLang.js' type='text/javascript'></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.easing.1.3.js"></script>
      
        <style>
            .button2{
                font-size: 15px;
                font-style: normal;
                font-variant: normal;
                font-weight: bold;
                line-height: 20px;
                width: 150px;
                height: 30px;
                text-decoration: none;
                display: inline-block;
                margin: 4px 2px;
                -webkit-transition-duration: 0.4s;
                transition-duration: 0.8s;
                cursor: pointer;
                border-radius: 12px;
                border: 1px solid #008CBA;
                padding-left:2%;
                text-align: center;
            }

            .button2:hover {
                background-color: #afdded;
                padding-top: 0px;
            }

            *>*{
                vertical-align: middle;
            }
        </style>
         <script language="JavaScript" type="text/javascript">
            $(document).ready(function () {
                var oTable;
                oTable = $('#itemTable').dataTable({
                   bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[3, "asc"]]

                }).fadeIn(2000);
            });
            
            
            </script>
    </head>
    <body>
        <form id="MappingForm" name="MappingForm" method="POST" style="width: 95%; padding-bottom: 20px;">
            <fieldset class="set" >
                <legend >
                      <font color="blue" size="5">
                         <%=title%>
                       </font>
                </legend>
                <br/>
                <br/>
                <div style="width:80%">
                <table align="<%=align%>" dir="<%=dir%>" width="100%"  id="itemTable">
                    <thead>
                        <tr>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                                <%=code%>
                            </th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                                <%=name%>
                            </th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                                <%=TranType%>
                            </th>
                            <th style="color: #005599 !important;font: 14px; font-weight: bold;display: none">
                                &emsp;
                            </th>
                        </tr>
                    </thead>
                        <%if(TreeItems!=null){%>
                          <tbody>
                              <%
                            for(WebBusinessObject itemWbo :TreeItems){
                                String colr[]={"#BC8F8F", "#DEB887","#FFE4C4","#FFF8DC","#FFF0F5","#FFFAFA"}; 
                               int level=Integer.parseInt(itemWbo.getAttribute("level").toString());
                               String color=(colr.length<level)?"white":colr[level]; 
                            
                            %>
                          
                            <tr>
                                <td style="background-color: white" >
                                    <%=itemWbo.getAttribute("code")%>
                                </td>
                                <td style="text-align:right;background-color: <%=color%>">
                                     <% 
                                        for(int j=0;j<level;j++){
                                        
                                        %>
                                        &emsp;
                                        <%}%>
                                    <%=itemWbo.getAttribute("projectName")%>
                                </td>
                                <td style="background-color: white">
                                    
                                    <%if(!itemWbo.getAttribute("type").equals("UL")){
                                        WebBusinessObject typeWb=projectMgr.getOnSingleKey("key", itemWbo.getAttribute("type").toString());

                                     %>
                                     <%=typeWb.getAttribute("projectName")%>
                                     <%}%>
                                </td>
                                <td style="display: none">
                                    &emsp;
                                </td>
                            </tr>
                            
                           <%}%>
                           </tbody>
                           <tfoot>
                               
                        </tfoot>
                        <%}%>
                     
                </table>             
                </div>  
            </fieldset>
        </form>
    </body>
</html>
