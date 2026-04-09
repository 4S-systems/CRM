<%@page import="com.maintenance.common.Tools"%>
<%@page import="com.silkworm.util.DateAndTimeControl"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.common.MetaDataMgr"%>
<%@page import="com.silkworm.international.TouristGuide"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page pageEncoding="UTF-8"%>
<%
    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();

    ArrayList countyClients = (ArrayList) request.getAttribute("countyClients");
    List<WebBusinessObject> data = (ArrayList<WebBusinessObject>) request.getAttribute("data");

    String stat = "Ar";
    String dir = null;
    String title, internationalCode, country, clientsNo;
    if (stat.equals("En")) {
        dir = "LTR";
        title = "International Clients without Comments and Appointments";
        internationalCode = "International Code";
        country = "Country";
        clientsNo = "Clients Number";
    } else {
        dir = "RTL";
        title = "العملاء الدوليين بدون تعليقات او مقابلات";
        internationalCode = "الكود الدولي";
        country = "الدولة";
        clientsNo = "عدد العملاء";
    }
%>
<HTML>
    <head>
        <META HTTP-EQUIV="Pragma" CONTENT="no-cache"/>
        <META HTTP-EQUIV="Expires" CONTENT="0"/>   

        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.structure.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.structure.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.theme.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery-ui.theme.min.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/api/jquery.datetimepicker.css" />
        <link rel="stylesheet" type="text/css" href="js/jquery/datatable/dataTables.jqueryui.css" />
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-ui.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery.datetimepicker.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/jquery.dataTables.min.js"></script>
        <script type="text/javascript" language="javascript" src="js/jquery/datatable/dataTables.jqueryui.js"></script>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
            $(document).ready(function () {
                $("#requests").dataTable({
                    "order": [[4, "desc"]],
                    "language": {
                        "url": "js/datatable/Arabic.json"
                    },
                    "destroy": true
                }).fadeIn(2000);
            });
        </script>

        <style type="text/css">
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
            }/* loading progress bar*/
            .container {width: 100px; margin: 0 auto; overflow: hidden;}
            .contentBar {width:100px; margin:0 auto; padding-top:0px; padding-bottom:0px;}
            .barlittle {
                background-color:#2187e7;  
                background-image: -moz-linear-gradient(45deg, #2187e7 25%, #a0eaff); 
                background-image: -webkit-linear-gradient(45deg, #2187e7 25%, #a0eaff);
                border-left:1px solid #111; border-top:1px solid #111; border-right:1px solid #333; border-bottom:1px solid #333; 
                width:10px;
                height:10px;
                float:left;
                margin-left:5px;
                opacity:0.1;
                -moz-transform:scale(0.7);
                -webkit-transform:scale(0.7);
                -moz-animation:move 1s infinite linear;
                -webkit-animation:move 1s infinite linear;
            }
            #block_1{
                -moz-animation-delay: .4s;
                -webkit-animation-delay: .4s;
            }
            #block_2{
                -moz-animation-delay: .3s;
                -webkit-animation-delay: .3s;
            }
            #block_3{
                -moz-animation-delay: .2s;
                -webkit-animation-delay: .2s;
            }
            #block_4{
                -moz-animation-delay: .3s;
                -webkit-animation-delay: .3s;
            }
            #block_5{
                -moz-animation-delay: .4s;
                -webkit-animation-delay: .4s;
            }
            @-moz-keyframes move{
                0%{-moz-transform: scale(1.2);opacity:1;}
                100%{-moz-transform: scale(0.7);opacity:0.1;}
            }
            @-webkit-keyframes move{
                0%{-webkit-transform: scale(1.2);opacity:1;}
                100%{-webkit-transform: scale(0.7);opacity:0.1;}
            }
        </style>
    </head>
    <body>
        <form name="COMP_FORM" method="post">
            <table align="center" width="98%">
                <tr>
                    <td class="td">
                        <FIELDSET class="set" style="width:98%;border-color: #006699">
                            <table align="center" width="100%" cellpadding="0" cellspacing="0" style="">
                                <tr>
                                    <td class="titlebar" style="text-align: center">
                                        <font color="#005599" size="4"><%=title%></font>
                                    </td>
                                </tr>
                            </table>
                            </br>

                            <table align="center" dir="rtl" width="100%" cellspacing="2" cellpadding="1">
                                <TR>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="15%" colspan="2"><b> <font size=3 color="white"> <%=country%> </b></TD>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="15%" colspan="2"><b> <font size=3 color="white"> <%=country%> </b></TD>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="15%" colspan="2"><b> <font size=3 color="white"> <%=country%> </b></TD>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="15%" colspan="2"><b> <font size=3 color="white"> <%=country%> </b></TD>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="15%" colspan="2"><b> <font size=3 color="white"> <%=country%> </b></TD>
                                    <td class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="15%" colspan="2"><b> <font size=3 color="white"> <%=country%> </b></TD>
                                </tr>
                                <%
                                    for(int j = 0; j < (countyClients.size() / 6); j++) {
                                %>
                                <TR>
                                    <%
                                        for (int i = j * 6; i < (j + 1) * 6; i++) {
                                            WebBusinessObject wbo = (WebBusinessObject) countyClients.get(i);
                                    %>
                                    <td style="text-align:center;"  WIDTH="3%" bgcolor="#dedede"  valign="MIDDLE">
                                        <img id="meetingDateIcon" src="images/countryFlags/<%=wbo.getAttribute("Country_Flag")%>" alt=<%=wbo.getAttribute("Country_Flag")%> width="45"/>
                                    </td>
                                    <td style="text-align:center" bgcolor="#dedede"  valign="MIDDLE">
                                        <a href="<%=context%>/ClientServlet?op=getInterClientsNoCommApp&interCode=<%=wbo.getAttribute("Country_Code")%>"><b><%=wbo.getAttribute("Country_Code")%></b></a>
                                    </td>
                                    <%}%>
                                </TR>
                                <%
                                    }
                                %>
                                
                            </TABLE>
                            <br>

                            <% if (data != null) {%>
                            <center>
                                <br/>
                                <div style="width: 99%">
                                    <table class="display" id="requests" align="center" DIR="<%=dir%>" WIDTH="100%" CELLPADDING="0" cellspacing="0">
                                        <thead>
                                            <tr>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="10%">رقم العميل</TH>  
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="45%"><b>اسم العميل</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="15%"><b>التليفون</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="15%"><b>المحمول</b></TH>
                                                <TH STYLE="text-align:center;font-size:<%=(stat.equals("En")) ? "14px" : "16px"%>; font-weight: bold" width="15%"><b>الرقم الدولى</b></TH>              
                                            </tr>
                                        </thead> 
                                        <tbody>
                                            <%
                                                for (WebBusinessObject wbo : data) {   
                                            %>
                                            <tr id="row">
                                                <td><b><%=wbo.getAttribute("CustomerNo")%></b></td>    
                                                <td><b><%=wbo.getAttribute("customerName")%></b></td>                                       
                                                <td><b><%=wbo.getAttribute("clientPhone")%></b></td>  
                                                <td><b><%=wbo.getAttribute("clientMobile")%></b></td>  
                                                <td><b><%=wbo.getAttribute("interPhone")%></b></td>                                                                                      
                                            </tr>
                                            <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            </center>
                            <br/>
                            <br/>
                            <% }%>
                        </FIELDSET>
                    </td>
                </tr>
            </table>
        </FORM>
    </body>
</html>     
