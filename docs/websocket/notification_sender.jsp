<%-- 
    Document   : notification_sender
    Created on : Mar 14, 2015, 12:14:30 PM
    Author     : walid
--%>

<%@page import="com.silkworm.util.DateAndTimeControl.TimeType"%>
<%@page import="com.crm.common.CRMConstants"%>
<%@page import="com.maintenance.db_access.IssueDocumentMgr"%>
<%@page import="com.maintenance.db_access.ProjectsByGroupMgr"%>
<%@page import="com.clients.db_access.ClientComplaintsMgr"%>
<%@page import="com.maintenance.db_access.IssueByComplaintAllCaseMgr"%>
<%@page import="java.text.DateFormat"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*,com.tracker.app_constants.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*,com.contractor.db_access.MaintainableMgr"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page pageEncoding="UTF-8"%>
<%
    List<ApplicationSessionRegistery.SessionRegistery> sessions = (List<ApplicationSessionRegistery.SessionRegistery>) request.getAttribute("sessions");
    SecurityUser securityUser = (SecurityUser) session.getAttribute("securityUser");
    String stat = "Ar";
    String dir = null;
    String title, title2;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "Current Users In System";
        title2 = "Send Notification";
    } else {
        dir = "RTL";
        title = "المستخدمين الحاليين";
        title2 = "إرسال إعلام";
    }
%>
<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   

        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" type="text/css" href="css/blueStyle.css" />
        <link rel="stylesheet" type="text/css" href="css/w3.css" />
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>

        <SCRIPT>
        </script>
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        function updateDataTableSelectAllCtrl(table){
              //  console.log("updateDataTableSelectAllCtrl");
   var $table             = table.table().node();
   var $chkbox_all        = $('tbody input[type="checkbox"]', $table);
   var $chkbox_checked    = $('tbody input[type="checkbox"]:checked', $table);
   var chkbox_select_all  = $('thead input[name="select_all"]', $table).get(0);

   // If none of the checkboxes are checked
   if($chkbox_checked.length === 0){
      chkbox_select_all.checked = false;
      if('indeterminate' in chkbox_select_all){
         chkbox_select_all.indeterminate = false;
      }

   // If all of the checkboxes are checked
   } else if ($chkbox_checked.length === $chkbox_all.length){
      chkbox_select_all.checked = true;
      if('indeterminate' in chkbox_select_all){
         chkbox_select_all.indeterminate = false;
      }

   // If some of the checkboxes are checked
   } else {
      chkbox_select_all.checked = true;
      if('indeterminate' in chkbox_select_all){
         chkbox_select_all.indeterminate = true;
      }
   }
}
 var rows_selected = [];
            $(document).ready(function() {
                 
               var table= $("#onlineusers").DataTable({
                 "paging":   true,
                  "aLengthMenu": [[10, 25, 50, 100, -1], [10, 25, 50, 100, "All"]],
                 columns: [
            { "data" : "name" }
        ],
                     'columnDefs': [{
         'targets': 1,
         'searchable':false,
         'orderable':false,
          'className': 'dt-body-center',
         'render': function (data, type, full, meta){
           console.log("render");
            $("#selectallbox").attr("disabled",false);
             return '<input type="checkbox" align="center" >';
         }
      }
  
            ],
        "ordering": false,
        "info":     false,
        "searching": false,
         'rowCallback': function(row, data, dataIndex){
         // Get row ID
        // console.log("rowCallback");
         var rowId = data[0];

         // If row ID is in the list of selected row IDs
         if($.inArray(rowId, rows_selected) !== -1){
            $(row).find('input[type="checkbox"]').prop('checked', true);
            $(row).addClass('selected');
         }
      }
        
                });
           
                                
   // Handle click on checkbox
   $('#onlineusers tbody').on('click', 'input[type="checkbox"]', function(e){
      var $row = $(this).closest('tr');

      // Get row data
      var data = table.row($row).data();

console.log("data");
console.log(data["name"]);

      // Get row ID
      var rowId = data["name"] ; //data[0];
   
      // Determine whether row ID is in the list of selected row IDs 
      var index = $.inArray(rowId, rows_selected);

      // If checkbox is checked and row ID is not in list of selected row IDs
      if(this.checked && index === -1){
         rows_selected.push(data["name"]);

      // Otherwise, if checkbox is not checked and row ID is in list of selected row IDs
      } else if (!this.checked && index !== -1){
         rows_selected.splice(index, 1);
      }

      if(this.checked){
         $row.addClass('selected');
      } else {
         $row.removeClass('selected');
      }

      // Update state of "Select all" control
      updateDataTableSelectAllCtrl(table);

      // Prevent click event from propagating to parent
      e.stopPropagation();
   });

   // Handle click on table cells with checkboxes
   $('#onlineusers').on('click', 'tbody td, thead th:first-child', function(e){
      $(this).parent().find('input[type="checkbox"]').trigger('click');
   });

   // Handle click on "Select all" control
   $('thead input[name="select_all"]', table.table().container()).on('click', function(e){
      if(this.checked){
         $('#onlineusers tbody input[type="checkbox"]:not(:checked)').trigger('click');
      } else {
         $('#onlineusers tbody input[type="checkbox"]:checked').trigger('click');
      }

      // Prevent click event from propagating to parent
      e.stopPropagation();
   });

   // Handle table draw event
   table.on('draw', function(){
      // Update state of "Select all" control
      updateDataTableSelectAllCtrl(table);
   });
    get_Online_Users();        
    });

               
          
        </script>

        <style type="text/css">
            .titlebar {
                height: 30px;
                background-image: url(images/title_bar.png);
                background-position-x: 50%;
                background-position-y: 50%;
                background-size: initial;
                background-repeat-x: repeat;
                background-repeat-y: no-repeat;
                background-attachment: initial;
                background-origin: initial;
                background-clip: initial;
                background-color: rgb(204, 204, 204);
            }
            #row:hover{
                cursor: pointer;
                background-color: #D3E3EB !important;
            }
            
            #refresh {
  background: url("images/icons/refresh3.png") no-repeat ;
 cursor : pointer;
 width : 32px;
 height: 32px;
 float: right;
 margin-right:  10%; 
}
 </style>
    </head>
    <body>
               
                    <FIELDSET align="center" class="set" style="width:90%;border-color: #006699; margin-bottom: 5px">
                        <div class="titlebar" style="text-align: center ; width: 100% ; height: 45px">
                                    &nbsp;<font color="#005599" size="5"><%=title2%></font>
                                </div>
                            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="" dir="rtl">
                             
                            <tr>
                                <td style="width: 30%;">
                                    <br>
                                     <font color="#005599" size="3"><%=title%></font>
                                     <div id="refresh" title="تحديث المستحدمين الحاليين"  onclick="Javascript: get_Online_Users()" > </div>
                                  <br><br>
                                    <TABLE id="onlineusers" style="width: 100%">
                                        <THEAD>
                                            <tr>
                                                <th>الاسم </th>
                                                <th> <input id="selectallbox" name="select_all" value="1" type="checkbox" align="center" disabled="true"></th>
                                            </tr>    
                                        </THEAD>
                                        
                                    </TABLE>
                                </td>
                                <td style="width: 70%;">
                                 <br>
                                 <textarea id="message" style="width: 95%;border: 1px solid rgba(255,205,112,1);background-color: rgba(255,237,204,1);" rows="5" maxlength="8190" placeholder="Enter your message"></textarea>
                            <br> <br> 
                                 <button type="button" onclick="Javascript: sendMessage()" style=" vertical-align: middle; padding-bottom: 8px; padding-top: 2px; font-size: 16px;">أرسال&ensp;<img src="images/icons/distribute.png" alt="" height="24" width="24" /></button>
                                 <button type="button" onclick="Javascript: redirect('<%=securityUser.getFullName() != null ? securityUser.getFullName() : ""%>')" style=" vertical-align: middle; padding-bottom: 8px; padding-top: 2px; font-size: 16px;">توجيه&ensp;<img src="images/call_client.ico" alt="" height="24" width="24" /></button>
                            <br>   <br> 
                                </td>
                            </tr>
                        </table>
                        <br/>
                    </FIELDSET>
                  
    </body>
</html>     
