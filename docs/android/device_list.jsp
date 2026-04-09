
<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<!DOCTYPE html>

<%
    String stat = (String) request.getSession().getAttribute("currentMode");
    String tit = "  ";
    String name, mac, people, transport, view;
    if (stat.equals("En")) {
        tit = "Employee Tracking ";
        name = "Name";
        mac = "Mac";
        people = "Clients";
        transport = "Transports";
        view = "View Loactions";
    } else {
        tit = "متابعة العمال";
        name = "الأسم";
        mac = "عنوان الجهاز";
        people = "العمال";
        transport = "النقل";
        view = "المواقع";
    }
    ArrayList<LiteWebBusinessObject> lst = (ArrayList<LiteWebBusinessObject>) request.getAttribute("deviceList");

%>

<html>
    <head>
        <link href="js/select2.min.css" rel="stylesheet"/>
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css"/>
        <link rel="stylesheet" href="css/demo_table.css"/>
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script src="js/select2.min.js"></script>
        <style>
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
                background: -moz-linear-gradient(top, #7abcff 0%, #4096ee 100%); /* FF3.6+ */
                background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#7abcff), color-stop(100%,#4096ee)); /* Chrome,Safari4+ */
                background: -webkit-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Chrome10+,Safari5.1+ */
                background: -o-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* Opera 11.10+ */
                background: -ms-linear-gradient(top, #7abcff 0%,#4096ee 100%); /* IE10+ */
                background: linear-gradient(to bottom, #7abcff 0%,#4096ee 100%); /* W3C */
                filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7abcff', endColorstr='#4096ee',GradientType=0 ); /* IE6-8 */
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
            .remove{
                width:20px;
                height:20px;
                margin: 4px;
                background-repeat: no-repeat;
                cursor: pointer;
                background-image:url(images/icons/icon-32-remove.png);
            }
            .smallDialog {
                width: 320px;
                display: none;
                position: fixed;
                z-index: 1100;
            }
            .mediumDialog {
                width: 90%;
                display: none;
                position: fixed;
                z-index: 1100;
                left: 5%;
            }
            .overlayClass {
                width: 100%;
                height: 100%;
                display: none;
                background-color: rgb(0, 85, 153);
                opacity: 0.4;
                z-index: 1000;
                top: 0px;
                left: 0px;
                position: fixed;
            }
            .img:hover{
                cursor: pointer ;
            }
            #container{
                font-family:Arial, Helvetica, sans-serif;
                position:absolute;
                top:0;
                left:0;
                background: #005778;
                width:100%;
                height:100%;
            }
            .hot-container p { margin-top: 10px; }
            a { text-decoration: none; margin: 0 10px; }

            .hot-container {
                min-height: 100px;
                margin-top: 100px;
                width: 100%;
                text-align: center;
            }

            a.btn {
                display: inline-block;
                color: #666;
                background-color: #eee;
                text-transform: uppercase;
                letter-spacing: 2px;
                font-size: 12px;
                padding: 10px 30px;
                border-radius: 5px;
                -moz-border-radius: 5px;
                -webkit-border-radius: 5px;
                border: 1px solid rgba(0,0,0,0.3);
                border-bottom-width: 3px;
            }

            a.btn:hover {
                background-color: #e3e3e3;
                border-color: rgba(0,0,0,0.5);
            }

            #mypopup{
                padding-top: 20%;
            }

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
                -webkit-transition-duration: 0.4s; /* Safari */
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

            * > *{
                vertical-align: middle;
            }

        </style>
        <script>$(document).ready(function () {
                $('#assetrep').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                });

                $('#assetdata').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[-1], [""]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true
                });

                $(".branch").select2();

            });
        </script>

    </head>
    <body>
        <div style="padding-bottom: 10px;">
            <fieldset align=center class="set" style="width: 90%; padding-bottom: 5px;">
                <legend align="center">
                    <table >
                        <tr>

                            <td class="td">
                                <font color="blue" size="5"><%=tit%> 
                                </font>
                            </td>
                        </tr>
                    </table>
                </legend>
                <div style="width: 90%;margin-left: auto;margin-right: auto;margin-bottom: 7px;">
                    <TABLE style="width: 100%"  id="assetrep"dir=<fmt:message key="direction" style="width:100%;display: none; "/>   
                        <thead>
                            <tr>
                                <th style="width: 15%; color: #000000 !important;   "><font size="2"> <%=name%> </font></th>
                                <th style="width: 8%; color: #000000 !important;  "><font size="2"><%=mac%></font></th>
                                <th style="width: 15%; color: #000000 !important; "><font size="2"><%=people%></font></th>
                                <th style="width: 15%; color: #000000 !important; "><font size="2"><%=transport%></font></th>
                            </tr>
                        <thead>
                        <tbody>  

                            <%for (int i = 0; i < lst.size(); i++) {
                                    LiteWebBusinessObject myWbo = lst.get(i);
                            %>
                            <tr>
                                <td><%=myWbo.getAttribute("vNm")%> </td>
                                <td><%=myWbo.getAttribute("macAddress")%></td>
                                <td><a href="AndroidServlet?op=location&deviceId=<%=myWbo.getAttribute("id")%>&empName=<%=myWbo.getAttribute("vNm")%>"><%=view%></a></td>
                                <td><a href="AndroidServlet?op=locationWithStatus&deviceId=<%=myWbo.getAttribute("id")%>&empName=<%=myWbo.getAttribute("vNm")%>"><%=view%></a></td>
                            </tr>
                            <%}%>
                        </tbody>  

                    </TABLE>
                </div>

            </fieldset>
        </div>
    </body>
</html>
