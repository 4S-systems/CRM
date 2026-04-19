<%-- 
    Document   : classifiedClientsLastComments
    Created on : Apr 5, 2018, 9:27:12 AM
    Author     : fatma
--%>

<%@page import="com.maintenance.db_access.GroupPrevMgr"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.maintenance.db_access.UnitDocMgr"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.tracker.db_access.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<%@page pageEncoding="UTF-8" %>

<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();
        String stat = (String) request.getSession().getAttribute("currentMode");
        ArrayList<WebBusinessObject>clientsList=( ArrayList<WebBusinessObject>)request.getAttribute("clientList");
        String align, xAlign, dir;
        String clientNo,clientName,disputeDate,disputeNote,clientPhone,ClientMail,confirmed,realese,title;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            clientNo="Client No";
            clientName="Client Name";
            disputeDate="Dispute Date";
            disputeNote="Dispute Resons";
            clientPhone="Client Phone";
            ClientMail="Client Mail";
            realese="Release";
            title="Show Clients With Legal Dispute"; 
           confirmed="Confirmed"; 

            
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
             clientNo="رقم العميل";
            clientName="أسم العميل";
            disputeDate="تاريخ النزاع";
            disputeNote="سبب النزاع";
            clientPhone="تليفون العميل";
            ClientMail="ايميل العميل";
            realese="فك النزاع";
            title="عرض النزاعات القانونيه ";
            confirmed="تم التأكيد";

           
            
        }
        
        WebBusinessObject userWbo = (WebBusinessObject) request.getSession().getAttribute("loggedUser");
        GroupPrevMgr groupPrevMgr = GroupPrevMgr.getInstance();
        Vector groupPrev = groupPrev = groupPrevMgr.getOnArbitraryKey(userWbo.getAttribute("groupID").toString(), "key1");
        ArrayList<String> userPrevList = new ArrayList<String>();
        WebBusinessObject wbo;
        for (int i = 0; i < groupPrev.size(); i++) {
            wbo = (WebBusinessObject) groupPrev.get(i);
            userPrevList.add((String) wbo.getAttribute("prevCode"));
        }
    %>
    <HEAD>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" type="text/css" href="css/msdropdown/dd.css" />
        
        <link rel="stylesheet" type="text/css" href="css/tooltip.css"/>
        
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/msdropdown/jquery.dd.min.js"></script>
        
        <script src="js/select2.min.js"></script>
        <link href="js/select2.min.css" rel="stylesheet">
        
        <script type="text/javascript">
            $(document).ready(function () {
                oTable = $('#clients').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[-1], ["All"]],
                    iDisplayLength: -1,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[2, "asc"]]
                }).fadeIn(2000);
            });
             function release (clientID){
   
                $.ajax({
                    type: "post",
                    url:"<%=context%>/SearchServlet?op=ReleaseClientLegalDispute",
                    data: {
                         clientID: clientID,
                    }, success: function (jsonString) {
                        var info = $.parseJSON(jsonString);
                        if (info.status == 'ok') {
                            alert('<%=confirmed%>');
                            location.reload();
                          
                            
                    }
                }});
           
            }
          
        </script>
        
        <style type="text/css">
            .login {
                direction: rtl;
                margin: 20px auto;
                padding: 10px 5px;
                background: #3f65b7;
                background-clip: padding-box;
                border: 1px solid #ffffff;
                border-bottom-color: #ffffff;
                border-radius: 5px;
                color: #ffffff;
                background: #7abcff; /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
                -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 0.67);
                -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 0.67);
                box-shadow:         0px 0px 17px rgba(255, 255, 255, 0.67);
                -webkit-border-radius: 20px;
                -moz-border-radius: 20px;
                border-radius: 20px;
            }
            
            .remove__{
                width:20px;
                height:20px;
                background-image:url(images/icons/remove1.png);
                background-position: bottom;
                background-repeat: no-repeat;
                cursor: pointer;
                margin-right: auto;
                margin-left: auto;
            }
            
            .login  h1 {
                font-size: 16px;
                font-weight: bold;
                padding-top: 10px;
                padding-bottom: 10px;
                text-shadow: 0 -1px rgba(0, 0, 0, 0.4);
                text-align: center;
                width: 96%;
                margin-left: auto;
                margin-right: auto;
                text-height: 30px;
                color: #ffffff;
                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #cc0000;
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
            
            #hideANDseek{
                display: none;
            }       
            
            .appointment_table {
                padding: 10px 20px;
                color: white;
                border-radius: 20px;
                font: bold 16px "Helvetica Neue", Sans-Serif;
                box-shadow: 0 0 7px black;
            }
            
            .appointment_header {
                background-color: #d18080;
                padding: 5px;
            }
            
            .appointment_title {
                background-color: #abc0e5;
                padding: 5px;
            }
            
            .appointment_data {
                background-color: white;
                padding: 5px;
            }
            
            .login-input {
                width: 100%;
                height: 23px;
                padding: 0 9px;
                color: #27272A;
                font-size: 13px;
                cursor: auto;
                text-shadow: 0 1px black;
                background: #2b3e5d;
                border: 1px solid #ffffff;
                border-top-color: #0d1827;
                border-radius: 4px;
                background: rgb(249,252,247); /* Old browsers */
                /* IE9 SVG, needs conditional override of 'filter' to 'none' */
                background: -moz-linear-gradient(top, rgba(249,252,247,1) 0%, rgba(245,249,240,1) 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(249,252,247,1)), color-stop(100%,rgba(245,249,240,1))); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* IE10+ */
                background: linear-gradient(to bottom, rgba(249,252,247,1) 0%,rgba(245,249,240,1) 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f9fcf7', endColorstr='#f5f9f0',GradientType=0 ); /* IE6-8 */
            }
            
            .ddlabel {
                float: left;
            }
            
            .fnone {
                margin-right: 5px;
            }
            
            .ddChild, .ddTitle {
                text-align: right;
            }
            
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
            
            .titleRow {
                background-color: orange;
            }
            
            .ahmed-gamal {
                width:40px;
                height: 40px;
                float:right;
                margin: 0px;
                padding: 0px;
            }
            
            .icon {
                vertical-align: middle;
            }
            
            .confirmed {
                background-color: #EBB462;
                color: black;
                font-size: 14px;
                font-weight: bold;
                -ms-filter: "progid:DXImageTransform.Microsoft.Shadow(Strength=2, Direction=135, Color='#999999')";
                filter: progid:DXImageTransform.Microsoft.Shadow(Strength=2,Direction=135,Color='#999999');
                -webkit-border-radius: 6px 6px 6px 6px;
                -moz-border-radius: 6px 6px 6px 6px;
            }
        </style>
    </HEAD>
    
    <body>
        
        <fieldset align=center class="set" style="width: 90%">
            <LEGEND>
                <font style="color:blue" size="4"> <%=title%></font>
            </LEGEND>
            <form name="CLASSIFICATION_FORM" method="POST">
                <br/>
                <div style="width: 90%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <TABLE ALIGN="<%=align%>" dir="<%=dir%>" id="clients" style="width:100%;">
                        <thead>
                            <tr>
                                <th>
                                    <%=clientNo%>
                                </th>
                                 <th>
                                    <%=clientName%>
                                </th>
                              
                                
                                 <th>
                                    <%=ClientMail%>
                                </th>
                                 <th>
                                    <%=clientPhone%>
                                </th>
                                   <th>
                                    <%=disputeDate%>
                                </th>
                                 <th>
                                    <%=disputeNote%>
                                </th>
                                 <th>
                                    <%=realese%>
                                </th>
                                

                            </tr>
                        </thead>
                        
                        <tbody>
                            <% if(clientsList!=null){
                                 for (WebBusinessObject clientWbo : clientsList) {
                            %>
                                    <tr>
                                        <td>
                                            <%=clientWbo.getAttribute("clientNO")%>
                                        </td>
                                         <td>
                                            <%=clientWbo.getAttribute("name")%>
                                        </td>
                                         <td>
                                            <%=clientWbo.getAttribute("EMAIL")%>
                                        </td>
                                         <td>
                                            <%=clientWbo.getAttribute("mobile")%>
                                        </td>
                                         <td>
                                            <%=clientWbo.getAttribute("BEGIN_DATE")%>
                                        </td>
                                         <td>
                                            <%=clientWbo.getAttribute("STATUS_NOTE")%>
                                        </td>
                                        <td align="center">
                                            <img src="images/seperate.png" onclick="JavaScript: release('<%=clientWbo.getAttribute("id")%>');" style="cursor: pointer; width: 30px; height: 30px; display: block;align:center" title="<%=realese%>">
                                        </td>
                                    </tr>
                            <%
                                }
}
                            %>
                        </tbody>
                    </table>
                </div>
                        
                <br/><br/>
            </form>
        </fieldset>
                 
    </body>
</html>