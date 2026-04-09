<%@page import="java.util.List"%>
<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>  
<!DOCTYPE html>

<%
    String tit, back;

    String stat = (String) request.getSession().getAttribute("currentMode");
    String empName = request.getParameter("empName");
    if (stat.equals("En")) {
        tit = "Movments of Employee " + empName;
        back = "back to employees list";
    } else {
        tit = "حركات العامل : " + empName;
        back = "رجوع الى قائمة العمال";
    }
    List<LiteWebBusinessObject> lst = (ArrayList<LiteWebBusinessObject>) request.getAttribute("locations");
%>

<html>
    <head>

        <title><%=tit%></title>
        <link rel="stylesheet" href="css/demo_table.css">
        <link rel="stylesheet" href="jquery-ui/themes/base/jquery.ui.all.css">
        <link href="js/select2.min.css" rel="stylesheet">
        <script type="text/javascript" language="javascript" src="js/jquery/api/jquery-1.10.2.min.js"></script>
        <script type="text/javascript" src="js/jquery.bpopup.min.js"></script>
        <script type="text/javascript" src="js/jquery.dataTables.js"></script>
        <script type="text/javascript" src="//code.jquery.com/ui/1.9.2/jquery-ui.js"></script>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyCaOW0zZZnfIj0jMqR0RPe9gJAIywqj6UI&callback=initMap"  async defer></script>
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
            /* Outer */
            .popup {
                width:100%;
                height:100%;
                display:none;
                position:fixed;
                top:0px;
                left:0px;
                background:rgba(0,0,0,0.75);
            }
            /* Inner */
            .popup-inner {
                max-width:700px;
                width:90%;
                padding:40px;
                position:absolute;
                top:50%;
                left:50%;
                -webkit-transform:translate(-50%, -50%);
                transform:translate(-50%, -50%);
                box-shadow:0px 2px 6px rgba(0,0,0,1);
                border-radius:3px;
                background:#fff;
            }
            /* Close Button */
            .popup-close {
                width:30px;
                height:30px;
                padding-top:4px;
                display:inline-block;
                position:absolute;
                top:0px;
                right:0px;
                transition:ease 0.25s all;
                -webkit-transform:translate(50%, -50%);
                transform:translate(50%, -50%);
                border-radius:1000px;
                background:rgba(0,0,0,0.8);
                font-family:Arial, Sans-Serif;
                font-size:20px;
                text-align:center;
                line-height:100%;
                color:#fff;
            }
            .popup-close:hover {
                -webkit-transform:translate(50%, -50%) rotate(180deg);
                transform:translate(50%, -50%) rotate(180deg);
                background:rgba(0,0,0,1);
                text-decoration:none;
            }
            #canvasMap {
                height: 100%;
                width: 100%;
                margin: 0px;
                padding: 0px
            }

        </style>
        <script>
            $(document).ready(function () {
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
            $(function () {
//----- OPEN
                $('[data-popup-open]').on('click', function (e) {
                    var targeted_popup_class = jQuery(this).attr('data-popup-open');
                    $('[data-popup="' + targeted_popup_class + '"]').fadeIn(350);
                    e.preventDefault();
                });
//----- CLOSE
                $('[data-popup-close]').on('click', function (e) {
                    var targeted_popup_class = jQuery(this).attr('data-popup-close');
                    $('[data-popup="' + targeted_popup_class + '"]').fadeOut(350);
                    e.preventDefault();
                });
            });


            function viewMap(x, y)
            {
                // debugger;
                $("#dialog").dialog({
                    modal: true,
                    title: "Location",
                    width: 600,
                    height: 450,
                    buttons: {
                        Close: function () {
                            $(this).dialog('close');
                        }
                    },
                    open: function () {
                        initMap(x, y);

                    }
                });
            }
            function initMap(x, y) {
                var map;
                map = new google.maps.Map(document.getElementById('canvasMap'), {
                    center: {lat: x, lng: y},
                    zoom: 15
                });
                var marker = new google.maps.Marker({
                    position: new google.maps.LatLng(x, y),
                    map: map,
                    title: 'Hello World!'
                });
                marker.setMap(map);
            }
        </script>


    </head>
    <body>
        <button style="float: left;margin-left: 63px; " onclick="window.history.back();" class="button"> <%=back%> </button>
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
                                <th style="width: 15%; color: #000000 !important;   "><font size="2"> Address </font></th>
                                <th style="width: 8%; color: #000000 !important;  "><font size="2">Date</font></th>
                                <th style="width: 5%; color: #000000 !important; "><font size="2">state</font></th>
                                <th style="width: 5%; color: #000000 !important; "><font size="2"></font></th>
                            </tr>
                        <thead>
                        <tbody>  

                            <%
                                String t = "";
                                String time = "";
                                String address = "";
                                String state = "";
                                for (int i = 0; i < lst.size(); i++) {
                                    LiteWebBusinessObject myWbo = lst.get(i);
                                    time = (myWbo.getAttribute("creationTime") + "").substring(0, (myWbo.getAttribute("creationTime") + "").length() - 2);
                                    address = myWbo.getAttribute("option1") + "";
                                    state = myWbo.getAttribute("option2") + "";
                            %>
                            <tr>
                                <td><%=address%> </td>
                                <td><%=time%></td>
                                <td><%=state%></td>
                                <td><a href="javascript:void(0)" onclick="viewMap(<%=myWbo.getAttribute("lat")%>,<%=myWbo.getAttribute("lng")%>)" ><img style="width: 25px;" src="img/map_marker-512.png" alt="View Location" /></a></td>
                            </tr>
                            <%}%>
                        </tbody>  

                    </TABLE>
                </div>


                <div id="dialog" hidden="true">
                    <div id="canvasMap"></div>
                </div>

            </fieldset>
        </div>
    </body>
</html>
