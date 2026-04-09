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
    ArrayList<WebBusinessObject> FAccountType=(ArrayList<WebBusinessObject>)request.getAttribute("FAccountType");
    ArrayList<WebBusinessObject> nodes=(ArrayList<WebBusinessObject>)request.getAttribute("nodes");
    ArrayList<WebBusinessObject> childList=(ArrayList<WebBusinessObject>)request.getAttribute("childList");
    String nodeId= request.getAttribute("nodeID")==null?" ":(String) request.getAttribute("nodeID");
    ProjectMgr projectMgr=ProjectMgr.getInstance(); 
    String transType=request.getAttribute("transType")==null?" ":(String)request.getAttribute("transType");
    String status=(String)request.getAttribute("status"); 
    String status1=(String)request.getAttribute("status1"); 
    String dir,title,TransType,chooseNode,align,save,saved,demap,Type,done;
    
    if (stat.equals("En")) {
            dir = "ltr";
            title="Map Financial Tree with Financial Transaction";
            TransType="Choose Transaction Type";
            chooseNode="Choose Node";
            align="right"; 
            save="Save";
            saved="Saved";
            demap="detach";
            Type="Transaction Type";
            done="Done";
        } else {
            dir = "rtl";
            title="ربط الشجرة الماليه بالحركات المحاسبيه ";
            TransType="اختر نوع الحركه المحاسبيه";
            chooseNode="اختر الأصل";
            align="left";
            save="حفظ";
            saved="تم الحفظ";
            demap="فك الربط";
            Type="نوع الحركة";
            done="تم فك الربط"; 
    }
%>
    
<html>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery-ui-timepicker-addon.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>

        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" src="jquery-ui/ui/jquery-ui-timepicker-addon.js"></script>
               <script type="text/javascript" src="js/jquery.dataTables.js"></script>

        <script type="text/javascript" src="js/buttons.flash.min.js"></script>

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
                <%if(status!=null && status.equals("ok")) {%>
                        alert('<%=saved%>');
                  <%}%>
                      
                $('#rootID').on('change', function() {
                   document.MappingForm.action = "<%=context%>/FinancialServlet?op=AttachTreeWithTransaction" ;
                  document.MappingForm.submit();
                  }); 
            });
            
            function submitFunction()
            {
                  document.MappingForm.action = "<%=context%>/FinancialServlet?op=AttachTreeWithTransaction&save=true" ;
                  document.MappingForm.submit();
            }
            
            function detechItem(itemID)
            {
                 $.ajax({
                    type: "post",
                    url: "<%=context%>/FinancialServlet?op=detechItemTree",
                    data: {
                       itemID:itemID
                    }
                    ,
                    success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status === 'ok') {
                             alert('<%=done%>');
                             reload();
                         }  
                    }
                });
                 document.MappingForm.action = "<%=context%>/FinancialServlet?op=AttachTreeWithTransaction&detech=true&itemID="+itemID ;
                  document.MappingForm.submit(); 
            }
            
            </script>
    </head>
    <body>
        <form id="MappingForm" name="MappingForm" method="POST">
            <fieldset class="set" style="width: 95%; padding-bottom: 20px;">
                <legend >
                      <font color="blue" size="5">
                         <%=title%>
                       </font>
                </legend>
                       <table align="center" style="direction: <%=dir%>; width: 50%;">
                           <tr>
                               <td class="blueBorder blueHeaderTD" style="font-size: 15px; font-weight:bold; width: 45%;">
                                   <font size=3 color="white">
                                   <%=TransType%>
                                   </font>
                               </td>
                               <td class="blueBorder blueHeaderTD" style="font-size: 15px; font-weight:bold; width: 45%;">
                                   <font size=3 color="white">
                                   <%=chooseNode%>
                                   </font>
                               </td>
                           </tr>
                           <tr>
                               <td style="text-align: center; border: none;" bgcolor="#F7F6F6" valign="middle" >
                                   <select style="width: 322px;height: 30px; font-weight: bold; font-size: 13px;" id="transType" name="transType">
                                       <sw:WBOOptionList displayAttribute="projectName" valueAttribute="projectID" wboList="<%=FAccountType%>" scrollToValue="<%=transType%>"  />
                                   </select>
                               </td>
                               <td style="text-align: center; border: none;" bgcolor="#F7F6F6" valign="middle" >
                                   <select style="width: 322px;height: 30px; font-weight: bold; font-size: 13px;" id="rootID" name="rootID">
                                       <sw:WBOOptionList displayAttribute="projectName" valueAttribute="projectID" wboList="<%=nodes%>" scrollToValue="<%=nodeId%>" />
                                   </select>
                               </td>
                           </tr>
                       </table>
                                   <br/>
                                   <br/>
                                   
                        <%if(childList!=null&&childList.size()>0){ 
                         
                        %>
                        <button type="button" onclick="submitFunction();" style="align: <%=align%>" class="button2" ><%=save%></button>
                        <table align="center" style="direction: <%=dir%>; width: 60%;border: none">
                            <thead>
                            <th class="blueBorder blueHeaderTD" style="font-size: 15px; font-weight:bold; ">
                                &emsp; 
                            </th>
                            <th class="blueBorder blueHeaderTD" style="font-size: 15px; font-weight:bold; width:70%">
                                <%
                                  WebBusinessObject rootWbo= projectMgr.getOnSingleKey("key", nodeId); 
                                %>
                                <%=rootWbo.getAttribute("projectName")%>
                             </th>
                             <th class="blueBorder blueHeaderTD" style="font-size: 15px; font-weight:bold;width:10% ">
                                 <%=Type%>
                             </th>
                              <th class="blueBorder blueHeaderTD" style="font-size: 15px; font-weight:bold;width:10% ">
                                 <%=demap%>
                             </th>
                            </thead>
                            <tbody>
                                <% for(WebBusinessObject wbo5:childList){
                                      String colr[]={"#BC8F8F", "#DEB887","#FFE4C4","#FFF8DC","#FFF0F5","#FFFAFA"}; 
                               int level=Integer.parseInt(wbo5.getAttribute("level").toString());
                               String color=(colr.length<level)?"white":colr[level]; 
                                %>
                                <tr>
                                    <td >
                                        <input type="checkbox" name="ids" id="<%=wbo5.getAttribute("projectID")%>" value="<%=wbo5.getAttribute("projectID")%>"  <%if(!wbo5.getAttribute("type").equals("UL")){%> disabled="true" checked=true"<%}%>/>
                                    </td>
                                    <td style="text-align:right;background-color: <%=color%>">
                                        <% 
                                        for(int j=1;j<level;j++){
                                        
                                        %>
                                        &emsp;
                                        <%}%>
                                        <%=wbo5.getAttribute("projectName")%>
                                    </td>
                                    <td>
                                        <%if(!wbo5.getAttribute("type").equals("UL")){
                                           WebBusinessObject typeWb=projectMgr.getOnSingleKey("key", wbo5.getAttribute("type").toString());
                                           
                                        %>
                                        <%=typeWb.getAttribute("projectName")%>
                                        <%}%>
                                    </td>
                                    <td>
                                        <%if(!wbo5.getAttribute("type").equals("UL")){
                                            
                                        %>
                                        <img src="images/seperate.png" onclick="JavaScript: detechItem('<%=wbo5.getAttribute("projectID")%>');" style="cursor: pointer; width: 30px; height: 30px; display: block;" title="فك الربط">
                                         <%}%>
                                    </td>
                                </tr>
                                <%}%>
                            </tbody>
                        </table>
                        <%}%>
                           
            </fieldset>
        </form>
    </body>
</html>
