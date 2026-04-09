<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@page pageEncoding="UTF-8" %>


<HTML>
    <%
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        String stat = (String) request.getSession().getAttribute("currentMode");

        Vector clients = new Vector();
        clients = (Vector) request.getAttribute("clientsVec");
        String align = null;
        String dir = null;
        String sTitle, allClients;

        if (stat.equals("En")) {
            align = "center";
            dir = "LTR";
            sTitle = "Search";
            allClients = "All Clients";
        } else {
            align = "center";
            dir = "RTL";
            sTitle = "أختار عميل";
            allClients = "كل العملاء";
        }
    %>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Doc Viewer- Select Project and Status</TITLE>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link rel="stylesheet" href="css/demo_table.css">
        <script type="text/javascript" src="jquery-ui/jquery-1.6.2.js"></script>

        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="js/jshaker.js"></script>
    </HEAD>
    <script type="text/javascript">
     
        var oTable;
        var users = new Array();
        $(document).ready(function() {
            $("#clients").css("display", "none");
            oTable = $('#clients').dataTable({
                bJQueryUI: true,
                sPaginationType: "full_numbers",
                "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                iDisplayLength: 25,
                iDisplayStart: 0,
                "bPaginate": true,
                "bProcessing": true
            }).fadeIn(2000);
        });
        
        $(function(){
            $("input[name=search]").change(function(){
                var value=$("input[name=search]:checked").attr("id");
                if (value == 'clientNo') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder","رقم العميل") ;
                    //                alert(searchByValue);
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#info").html("");
                    $("#msgNa").html("");
              
                    $("#searchValue").css("border","");
                    $("#showClients").css("display","none");
                } else if (value == 'clientTel') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder","رقم التليفون") ;
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#msgNa").html("");
                    $("#info").html("");
                    $("#searchValue").css("border","");
                    $("#showClients").css("display","none");
                }
                else if (value == 'clientMobile') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder","رقم الموبايل") ;
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#msgNa").html("");
                    $("#info").html("");
                    $("#searchValue").css("border","");
                    $("#showClients").css("display","none");
                }  else if (value == 'clientName') {
                    $("#searchValue").val("");
                    $("#searchValue").attr("placeholder"," إسم العميل") ;
                    $("#msgT").html("");
                    $("#msgM").html("");
                    $("#msgNo").html("");
                    $("#info").html("");
                    $("#msgNa").html("");
                    $("#searchValue").css("border","");
                   
                }
            })
       
        })
        function clearAlert(){
            $("#msgT").html("");
            $("#msgM").html("");
            $("#msgNo").html("");
            $("#info").html("");
            $("#msgNa").html("");
            $("#searchValue").css("border","");
            $("#showClients").css("display","none");
        }
    </script>
    <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
        
        function submitForm(clientId)
        {
            var url = "<%=context%>/ReportsServlet?op=exportClientReport&clientId=" + clientId;
            openWindow(url);
        }
      
        function openWindow(url) {
            window.open(url,"_blank","toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=no, copyhistory=no, width=750, height=400");
        }

        function cancelForm()
        {
            document.CLIENT_FORM.action = "main.jsp";
            document.CLIENT_FORM.submit();
        }
    </SCRIPT>
    <style>

        label{
            font: Georgia, "Times New Roman", Times, serif;
            font-size:14px;
            font-weight:bold;
            color:#005599;
            margin-right: 5px;
        }
        #row:hover{
            background-color: #EEEEEE;
        }
        .client_btn {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/addclient.png);
        }
        .company_btn {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/addCompany.png);
        }
        .enter_call {
            width:145px;
            height:31px;
            margin: 4px;
            background-repeat: no-repeat;
            cursor: pointer;
            border: none;
            background-position: right top ;
            display: inline-block;
            background-color: transparent;
            background-image:url(images/buttons/Number.png);
        }
        .titlebar {
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
    </style>
    <script src='ChangeLang.js' type='text/javascript'></script>
    <BODY>
        <FORM NAME="CLIENT_FORM" METHOD="POST">
            <div style="margin-left: auto;margin-right: auto;width: 96%" class="set">
                <div style="width: 100%;">
                    <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                        <tr>
                            <td width="100%" class="titlebar">
                                <font color="#005599" size="4"><%=sTitle%></font>
                            </td>
                        </tr>
                    </table>
                    <br>
                </div>
        </FORM>
        <%if (clients != null && !clients.isEmpty()) {%>
        <br />
        <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
            <button onclick="submitForm('all'); return false;" class="button">
                <%=allClients%><img src="<%=context%>/images/pdf_icon.gif" HEIGHT="20">
            </button>
        </div>
        <br />
        <div style="width: 85%;margin-right: auto;margin-left: auto;" id="showClients">
            <TABLE ALIGN="<%=align%>" dir="<%=dir%>" WIDTH="100%" id="clients" style="">
                <thead>
                    <tr>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">رقم العميل</th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">إسم العميل</th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">رقم الموبايل</th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">البريد الإلكترونى</th>
                    </tr>
                <thead>
                <tbody >  
                    <%
                        Enumeration e = clients.elements();
                        WebBusinessObject wbo;
                        while (e.hasMoreElements()) {
                            wbo = (WebBusinessObject) e.nextElement();
                    %>
                    <tr  onclick="submitForm(<%=wbo.getAttribute("id")%>);" style="cursor: pointer" id="row">
                        <TD>
                            <%if (wbo.getAttribute("clientNO") != null) {%>
                            <b><%=wbo.getAttribute("clientNO")%></b>
                            <% }%>
                        </TD>

                        <TD >
                            <%if (wbo.getAttribute("name") != null) {%>
                            <b><%=wbo.getAttribute("name")%></b>
                            <%}%>
                        </TD>
                        <TD >
                            <%if (wbo.getAttribute("mobile") != null) {%>
                            <b><%=wbo.getAttribute("mobile")%></b>
                            <%}%>
                        </TD>
                        <TD >
                            <%if (wbo.getAttribute("email") != null) {%>
                            <b><%=wbo.getAttribute("email")%></b>
                            <%}%>
                        </TD>
                    </tr>
                    <% }%>
                </tbody>  

            </TABLE>
        </div>
        <br />
        <br />
        <% } else {%>   
        <% }%>
    </div>
</BODY>
</HTML>     
