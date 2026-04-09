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

        String telJson = (String) request.getAttribute("telJson");
        String phn = (String) request.getAttribute("phn");

        String align = null, xAlign, mobileNum, UL, fromDate, toDate, srch;
        String dir = null;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
            mobileNum = " Client with Mobile Number ";
            UL = " Client without Mobile Number ";
            fromDate = "From Date";
            toDate = "To Date";
            srch = " Search ";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
            mobileNum = " رقم الموبايل ";
            UL = " بدون رقم الموبايل ";
            fromDate = "من تاريخ";
            toDate = "ألي تاريخ";
            srch = " بحث ";
        }
        
        WebBusinessObject user = (WebBusinessObject) session.getAttribute("loggedUser");
        Calendar cal = Calendar.getInstance();
        String jDateFormat=user.getAttribute("javaDateFormat").toString();
        SimpleDateFormat sdf = new SimpleDateFormat(jDateFormat);
        String nowDate=sdf.format(cal.getTime());
        
        
        String phoneVal = (String) request.getAttribute("phoneVal") != null ? (String) request.getAttribute("phoneVal") : "mobileNum";
    %>
    <HEAD>
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.structure.min.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.css">
        <link rel="stylesheet" href="js/jquery/api/jquery-ui.theme.min.css">
        <link rel="stylesheet" href="js/rateit/rateit.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.rowsGroup.js"></script>
        <script type="text/javascript" language="javascript" src="js/rateit/jquery.rateit.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery.bpopup.min.js"></script>

        <script type="text/javascript" language="javascript">
            $(document).ready(function () {
                var data = <%=telJson%>
                var table = $('#clients').DataTable({
                    bJQueryUI: true,
                    "aLengthMenu": [[5, 10, 25, 50, 100, -1], [5, 10, 25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    <%
                        if(phn != null && phn.equals("1")){
                    %>
                            "columns": [
                                {
                                    title: 'رقم التليفون',
                                    name: 'telNo',
                                },
                                {
                                    title: 'كود العميل',
                                    name: 'clientCode',
                                },
                                {
                                    title: 'اسم العميل',
                                    name: 'clientName',
                                }
                                ,
                                {
                                    title: 'الرقم الدولي',
                                    name: 'interPhomne',
                                }
                                ,
                                {
                                    title: 'البريد الألكتروني',
                                    name: 'email',
                                }
                                ,
                                {
                                    title: 'التفاصيل',
                                    name: 'ViewDetails',
                                }
                                ,
                                {
                                    title: 'حذف',
                                    name: 'Delete'
                                }
                            ],
                            data: data,
                            rowsGroup: [
                                'telNo:name'
                            ],
                    <%
                        } else if(phn != null && phn.equals("0")){
                    %>
                             "columns": [
                                {
                                    title: 'اسم العميل',
                                    name: 'clientName',
                                },
                                {
                                    title: 'رقم التليفون',
                                    name: 'telNo',
                                },
                                {
                                    title: 'كود العميل',
                                    name: 'clientCode',
                                }
                                ,
                                {
                                    title: 'الرقم الدولي',
                                    name: 'interPhomne',
                                }
                                ,
                                {
                                    title: 'البريد الألكتروني',
                                    name: 'email',
                                }
                                ,
                                {
                                    title: 'التفاصيل',
                                    name: 'ViewDetails',
                                }
                                ,
                                {
                                    title: 'حذف',
                                    name: 'Delete'
                                }
                            ],
                            data: data,
                            rowsGroup: [
                                'clientName:name'
                            ],
                    <%
                        }
                    %>
                    pageLength: '20'
                });
                
                var id = $("#phoneValRadio").val();
                $("#" + id).prop("checked", true);
                
                $('input[type=radio][name=phoneVal]').change(function() {
                    var phoneVal = $('input[name=phoneVal]:checked').val();
                    document.CLIENTS_FORM.action = "ClientServlet?op=repeatedClientsByTelephone&phoneVal=" + phoneVal;
                    document.CLIENTS_FORM.submit();
                });
                
                $("#fromDate,#toDate").datepicker({
                    maxDate: "d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });
            });
            
            function gtRprt(){
                var phn = '<%=phn%>';
                document.CLIENTS_FORM.action = "<%=context%>/ClientServlet?op=repeatedClientsByTelephone&phn=" + phn;
                document.CLIENTS_FORM.submit();
            }
        </script>
        <style type="text/css">
            .table td{
                padding:5px;
                text-align:center;
                font-family:Georgia, "Times New Roman", Times, serif;
                font-size:14px;
                font-weight: bold;
                border: none;
                margin-bottom: 30px;
            }
        </style>
    </HEAD>
    <body>
        <fieldset align=center class="set" style="width: 90%">
            
            <form name="CLIENTS_FORM" action="" method="POST">
                <table class="blueBorder" align="center" dir="rtl" id="code" cellpadding="0" cellspacing="0" width="650" style="border-width: 1px; border-color: white; display: none;" >
                    <tr>
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b>
                                <font size=3 color="white">
                                     <%=fromDate%> 
                            </b>
                        </td>
                        
                        <td class="blueBorder blueHeaderTD" style="font-size:18px;" width="325px">
                            <b>
                                <font size=3 color="white">
                                     <%=toDate%>
                            </b>
                        </td>
                    </tr>
                    
                    <tr>
                        <td bgcolor="#dedede" valign="middle">
                            <input type="text" style="width:190px" id="fromDate" name="fromDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("fromDate") == null ? nowDate : request.getAttribute("fromDate")%>"/>
                        </td>
                        
                        <td bgcolor="#dedede" valign="middle">
                            <input type="text" style="width:190px" id="toDate" name="toDate" size="20" maxlength="100" readonly="true"
                                   value="<%=request.getAttribute("toDate") == null ? nowDate : request.getAttribute("toDate")%>"/>
                        </td>
                    </tr>
                    
                    <tr>
                        <td bgcolor="#dedede" valign="middle" colspan="2">
                            <input type="button" style="width: 25%;" id="search" name="search" value="<%=srch%>" onchange="gtRprt();"/>
                        </td>
                    </tr>
                </TABLE>
                        
                <br/>

                <div style="width: 80%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <TABLE WIDTH="100%" ALIGN="<%=align%> " DIR="<%=dir%>" CELLPADDING="0" CELLSPACING="0" id="clients">                    
                    </table>
                </div>
                <br/><br/>
            </form>
        </fieldset>
    </body>
</html>



