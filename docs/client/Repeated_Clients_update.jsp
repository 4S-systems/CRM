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

        String align = null, xAlign;
        String dir = null;
        if (stat.equals("En")) {
            align = "center";
            xAlign = "right";
            dir = "LTR";
        } else {
            align = "center";
            xAlign = "left";
            dir = "RTL";
        }
    %>

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <title>update client numbers</title>
        <link rel="stylesheet" href="jqwidgets.4.5/jqwidgets/styles/jqx.base.css" type="text/css" />
        <link rel="stylesheet" href="examples.css" type="text/css"/>
        <style>
            .cell-title {
                font-weight: bold;
            }
            .cell-effort-driven {
                text-align: center;
            }
        </style>
        <script type="text/javascript" src="jqwidgets.4.5/scripts/jquery-1.11.1.min.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxcore.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxbuttons.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxscrollbar.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxlistbox.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxmenu.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxgrid.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxgrid.selection.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxgrid.edit.js"></script>  
        <script type = "text/javascript" src = "jqwidgets.4.5/jqwidgets/jqxgrid.filter.js" ></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxgrid.sort.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxdata.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxgrid.pager.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/jqwidgets/jqxdropdownlist.js"></script>
        <script type="text/javascript" src="jqwidgets.4.5/scripts/demos.js"></script>
        <script type="text/javascript">
            $(document).ready(function () {
                var data = <%=telJson == null || telJson.isEmpty() ? "\'\'" : telJson%>;

                var source = {
                    loadonce: true,
                    datafields: [{
                            name: 'phone',
                            type: 'string'
                        }, {
                            name: 'mobile',
                            type: 'string'
                        }, {
                            name: 'interPhone',
                            type: 'string'
                        }
                        , {
                            name: 'clientNO',
                            type: 'string'
                        }, {
                            name: 'name',
                            type: 'string'
                        }],
                    localdata: data
                };

                var dataadapter = new $.jqx.dataAdapter(source);

                // initialize jqxGrid
                $("#jqxgrid").jqxGrid({
                    width: 700,
                    source: dataadapter,
                    sortable: true,
                    autoheight: true,
                    pageable: true,
                    pagesize: 25,
                    pagesizeoptions: ['25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35'],
                    editable: true,
                    filterable: true,
                    columns: [{
                            text: 'رقم التليفون',
                            datafield: 'phone',
                            width: 100,
                            index: 'phone',
                            columntype: 'textbox',
                            align: 'center',
                            validation: function (cell, value) {
                                if (value.length != 11) {
                                    return {result: false, message: "Phone Number Should be 11 Numbers"};
                                } else if (IsNumeric(value) != true) {
                                    return {result: false, message: "Phone Number Should be Numbers only"};
                                }

                                return true;
                            }
                        }
                        , {
                            text: 'الموبايل',
                            datafield: 'mobile',
                            width: 120,
                            align: 'center',
                            validation: function (cell, value) {
                                if (value.length != 11) {
                                    return {result: false, message: "Mobile Number Should be 11 Numbers"};
                                } else if (IsNumeric(value) != true) {
                                    return {result: false, message: "Mobile Number Should be Numbers only"};
                                }

                                return true;
                            }
                        }, {
                            text: 'التليفون الدولي',
                            datafield: 'interPhone',
                            width: 120,
                            align: 'center',
                            validation: function (cell, value) {
                                if (IsNumeric(value) != true) {
                                    return {result: false, message: "International Number Should be Numbers only"};
                                }

                                return true;
                            }
                        }, {
                            text: 'رقم المتعامل',
                            datafield: 'clientNO',
                            width: 180,
                            cellbeginedit: 'false',
                            align: 'center'
                        }, {
                            text: 'اسم المتعامل',
                            datafield: 'name',
                            width: 180,
                            cellbeginedit: 'false',
                            align: 'center'
                        }]
                });

                $('#jqxgrid').on('cellendedit', function (event) {
                    var args = event.args;
                    // column data field.
                    var dataField = event.args.datafield;
                    // row's data.
                    var rowData = args.row;

                    var mobile;
                    var phone;
                    var interPhone;
                    var clientNO;
                    if (dataField == "phone") {
                        phone = event.args.value;
                        mobile = $('#jqxgrid').jqxGrid('getcellvalue', rowData.uid, 'mobile');
                        interPhone = $('#jqxgrid').jqxGrid('getcellvalue', rowData.uid, 'interPhone');
                        clientNO = $('#jqxgrid').jqxGrid('getcellvalue', rowData.uid, 'clientNO');
                    } else if (dataField == "mobile") {
                        mobile = event.args.value;
                        phone = $('#jqxgrid').jqxGrid('getcellvalue', rowData.uid, 'phone');
                        interPhone = $('#jqxgrid').jqxGrid('getcellvalue', rowData.uid, 'interPhone');
                        clientNO = $('#jqxgrid').jqxGrid('getcellvalue', rowData.uid, 'clientNO');
                    } else if (dataField == "interPhone") {
                        interPhone = event.args.value;
                        phone = $('#jqxgrid').jqxGrid('getcellvalue', rowData.uid, 'phone');
                        mobile = $('#jqxgrid').jqxGrid('getcellvalue', rowData.uid, 'mobile');
                        clientNO = $('#jqxgrid').jqxGrid('getcellvalue', rowData.uid, 'clientNO');
                    }

                    $.ajax({
                        type: "post",
                        url: "<%=context%>/ClientServlet?op=updateClientMobile",
                        data: {
                            mobile: mobile,
                            phone: phone,
                            clientNo: clientNO,
                            interPhone: interPhone
                        },
                        success: function ()
                        {
                            //alert("عمليــة تحديــث ناجـحـه");
                        },
                        error: function ()
                        {
                            alert("عملية تحديث غير ناجـحـه");
                        }
                    });
                });
            });

            function IsNumeric(sText)
            {
                var ValidChars = "0123456789.";
                var IsNumber = true;
                var Char;


                for (i = 0; i < sText.length && IsNumber == true; i++)
                {
                    Char = sText.charAt(i);
                    if (ValidChars.indexOf(Char) == -1)
                    {
                        IsNumber = false;
                    }
                }
                return IsNumber;

            }
        </script>
    </head>
    <body>
        <div id="jqxgrid">
        </div>
    </body>
</html>