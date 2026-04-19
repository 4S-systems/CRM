<%@page import="java.util.ArrayList"%>
<%@page import="com.silkworm.system_events.WebAppStartupEvent"%>
<%@ page import="com.silkworm.business_objects.*,com.tracker.db_access.*,com.silkworm.common.*, com.tracker.common.*,com.tracker.business_objects.*, java.util.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<HTML>

    <%
        ArrayList objectTypes = (ArrayList) request.getAttribute("objectTypes");
        Vector<WebBusinessObject> logger = (Vector<WebBusinessObject>) request.getAttribute("logger");
        String cMode = (String) request.getSession().getAttribute("currentMode");
        MetaDataMgr metaMgr = MetaDataMgr.getInstance();
        String context = metaMgr.getContext();

        ArrayList<WebBusinessObject> busObjectTypeList = (ArrayList<WebBusinessObject>) request.getAttribute("busObjectTypeList");
        ArrayList<WebBusinessObject> eventTypeList = (ArrayList<WebBusinessObject>) request.getAttribute("eventTypeList");
        
        String selectedObjectType = "";
        if (request.getAttribute("selectedObjectType") != null) {
            selectedObjectType = (String) request.getAttribute("selectedObjectType");
        }
        String selectedEventType = "";
        if (request.getAttribute("selectedEventType") != null) {
            selectedEventType = (String) request.getAttribute("selectedEventType");
        }
        String fromDate = "";
        if(request.getAttribute("fromDate") != null) {
            fromDate = (String) request.getAttribute("fromDate");
        }
        String toDate = "";
        if(request.getAttribute("toDate") != null) {
            toDate = (String) request.getAttribute("toDate");
        }
        String content = "";
        if(request.getAttribute("content") != null) {
            content = (String) request.getAttribute("content");
        }
        //String stat = (String) request.getSession().getAttribute("currentMode");
        String stat = cMode;
        String align = null;
        String dir = null;
        String style = null;
        String objectId, loggerMessage, eventName, objectName, eventTime, userName, clntData;
        
        align = "center";
        dir = "RTL";
        style = "text-align:left";
        objectId = "Object Id";
        objectName = "Object Name";
        eventTime = "Date";
        eventName = "Action";
        loggerMessage = "Log Message";
        userName = "User Name";
        clntData = "Detailed Info";
       
    %>
    <style type="text/css" >
        .hideStyle{
            visibility:hidden
        }
        .borderStyle{
            border-bottom:black solid 1px;
            border-left-width:0px;
            border-right-width:0px;
            border-top-width:0px
        }
    </style>

    <script src='ChangeLang.js' type='text/javascript'></script>

    <META HTTP-EQUIV="Pragma" CONTENT="no-cache">
    <META HTTP-EQUIV="Expires" CONTENT="0">

    <HEAD>
        <TITLE>Customize-Issue</TITLE>
        <script type="text/javascript" src="jquery-ui/ui/jquery.ui.core.js"></script>
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
        
        <script type="text/javascript">
            $(function() {
                $("#fromDate,#toDate").datepicker({
                    maxDate: "+d",
                    changeMonth: true,
                    changeYear: true,
                    dateFormat: 'yy-mm-dd'
                });

            });
            
            function viewXmlObjectData(xml){
                $("#changedTbl").remove();
                //var xmlObj = $("#objXml").val();
                var xmlObj = xml;
                console.log("xmlObj "+xmlObj);
                var parseXml;
                if (window.DOMParser) {
                    parseXml = function(str) {
                        return ( new window.DOMParser() ).parseFromString(str, "text/xml");
                    };
                } else if (typeof window.ActiveXObject != "undefined" && new window.ActiveXObject("Microsoft.XMLDOM")) {
                    parseXml = function(str) {
                        var xmlDoc = new window.ActiveXObject("Microsoft.XMLDOM");
                        xmlDoc.async = "false";
                        xmlDoc.loadXML(str);
                        return xmlDoc;
                    };
                } else {
                    parseXml = function() { return null; }
                }
                var xmlDoc = parseXml(xmlObj);
                if (xmlDoc) {
                    var x = xmlDoc.getElementsByTagName("code");
                    //var y = x[0].childNodes[0].nodeValue;
                    //console.log("y = " +y);
                    
                    var content = "<table id='changedTbl' style='width: 70%; margin-left: 15%; border:2px solid;'>";
                    content += "<tr style='background-color:lightblue;'><td style='color:grey; border:2px solid;'>property</td><td style='color:grey;border:2px solid;'>value</td></tr>"
                    //clean(xmlDoc);
                    x = xmlDoc.documentElement.childNodes;
                    console.log("x = " + x.length);
                    //x = xmlDoc.getElementsByTagName("code");
                    for (var i = 0; i < x.length; i++) {
                        if(x[i].nodeName == "#text"){
                         continue;   
                        }else {
                            var xn = xmlDoc.getElementsByTagName(x[i].nodeName);
                            if (xn[0].childNodes.length == 0) {
                                xn[0].nodeValue = " ";
                                xn[0].childNodes = " ";
                                xn[0].childNodes[0] = " ";
                                console.log("unknown null");
                            }
                            console.log("xn = " +xn[0].childNodes[0].nodeValue);
                            
                            if(xn[0].childNodes[0].nodeValue != null && xn[0].childNodes[0].nodeValue != "" && xn[0].childNodes[0].nodeValue != " "){
                                content += '<tr><td>' + x[i].nodeName + '</td><td>' + xn[0].childNodes[0].nodeValue + '</td></tr>';
                            }
                            
                        }
                        //content += '<tr><td>' + x[i].nodeName + '</td><td>' + x[i].childNodes[i].nodeValue + '</td></tr>';
                    }
                    content += "</table>"

                    $('#objectXml').append(content);
                    popupXmlTable();
                    //window.alert(xmlDoc.documentElement.getElementsByTagName("birthDate"));
                    //console.log(xmlDoc.getElementsByTagName("code"));
                }
            }
                
                
                function clean(node)
                {
                  for(var n = 0; n < node.childNodes.length; n ++)
                  {
                    var child = node.childNodes[n];
                    if
                    (
                      child.nodeType === 8 
                      || 
                      (child.nodeType === 3 && !/\S/.test(child.nodeValue))
                    )
                    {
                      node.removeChild(child);
                      n --;
                    }
                    else if(child.nodeType === 1)
                    {
                      clean(child);
                    }
                  }
                }
            function closePopup(obj) {
                $(obj).parent().parent().bPopup().close();
            }    
            function popupXmlTable() {
                $('#objectXml').css("display", "block");
                $('#objectXml').bPopup({
                    easing: 'easeInOutSine', //uses jQuery easing plugin
                    speed: 400,
                    transition: 'slideDown'});
            }    
        </script>
        <STYLE>
            .login {
                direction: LTR;
                margin-left: 15px;
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

                color: black;

                text-shadow: 0 1px rgba(255, 255, 255, 0.3);
                background: #FFBB00;
                /*background: #cc0000;*/
                background-clip: padding-box;
                border: 1px solid #284473;
                border-bottom-color: #223b66;
                border-radius: 4px;
                cursor: pointer;
            }
        </style>
    </HEAD>

    <BODY STYLE="background-color:#F5F5F5">
        <FIELDSET class="set" STYLE="width:80%; padding-left: 50px; padding-right: 50px;">
            <legend align="center">
                <table ALIGN="<%=align%>" dir="<%=dir%>">
                    <tr>
                        <td class="td">
                            <font color="#616D7E" style="font-weight:bolder;" size="5">Logs Report</font>
                        </td>
                    </tr>
                </table>
            </legend>
            <br />
            <form id="client_form" action="<%=context%>/DatabaseControllerServlet" method="post">
                <TABLE ALIGN="center" DIR="RTL" WIDTH=570 CELLSPACING=2 CELLPADDING=1>
                    <TR>

                        <TD class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="33%">
                            <b><font size=3 color="white">Type</b>
                        </TD>
                        <TD   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="33%">
                            <b> <font size=3 color="white">Action</b>
                        </TD>
                    </TR>
                    <TR>

                        <TD style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                            <select style="font-size: 14px;font-weight: bold;" id="busObjectType" name="busObjectType" >
                                <option value="">All</option>
                                <sw:WBOOptionList wboList='<%=busObjectTypeList%>' displayAttribute = "name" valueAttribute="id" scrollToValue="<%=selectedObjectType%>"/>
                            </select>
                            <input type="hidden" name="op" value="viewLog"/>
                        </TD>

                        <td bgcolor="#dedede" style="text-align:center" valign="middle">
                            <select style="font-size: 14px;font-weight: bold;" id="eventType" name="eventType">
                                <option value="">All</option>
                                <sw:WBOOptionList wboList='<%=eventTypeList%>' displayAttribute = "name" valueAttribute="id" scrollToValue="<%=selectedEventType%>"/>
                            </select>
                        </td>
                    </TR>
                    <TR>

                        <TD class="blueBorder blueHeaderTD" style="font-size:18px;" WIDTH="33%">
                            <b><font size=3 color="white">From</b>
                        </TD>
                        <TD   class="blueBorder blueHeaderTD" style="font-size:18px;"WIDTH="33%">
                            <b> <font size=3 color="white">To</b>
                        </TD>
                    </TR>
                    <TR>

                        <TD style="text-align:center" bgcolor="#dedede"  valign="MIDDLE" >
                            <input type="TEXT" name="fromDate" ID="fromDate" value="<%=fromDate%>" readonly />
                        </TD>

                        <td bgcolor="#dedede" style="text-align:center" valign="middle">
                            <input type="TEXT" name="toDate" ID="toDate" value="<%=toDate%>" readonly />
                        </td>
                    </TR>
                    <TR>

                        <TD class="blueBorder blueHeaderTD" style="font-size:18px;" colspan="2">
                            <b><font size=3 color="white">Content</b>
                        </TD>
                    </TR>
                    <TR>

                        <TD style="text-align:center" bgcolor="#dedede" colspan="2">
                            <input type="TEXT" name="content" ID="content" value="<%=content%>" style="width: 350px;" />
                        </TD>
                    </TR>
                    <tr>
                        <TD STYLE="text-align:center" CLASS="td" colspan="3">  
                            <button type="submit" STYLE="color: #27272A;font-size:15;margin-top: 20px;font-weight:bold; ">Search<IMG HEIGHT="15" SRC="images/search.gif" ></button>  

                        </TD>
                    </tr>
                </table>
            </form>
            <br />
            <TABLE id="logs" CELLPADDING="0" CELLSPACING="0" BORDER="0" dir="<%=dir%>" width="100%">
                <THEAD>
                    <tr>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            #
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            <%=eventName%>
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            <%=objectName%>
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            <%=objectId%>
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            <%=eventTime%>
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            <%=loggerMessage%>
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                            <%=userName%>
                        </th>
                        <th style="color: #005599 !important;font: 14px; font-weight: bold;">
                        </th>
                    </tr>
                </THEAD>
                <TBODY>
                    <%
                        int index = 0;
                        for (WebBusinessObject wbo : logger) {
                            index++;
                    %>
                    <TR STYLE="padding-top:5px;padding-bottom:3px">
                        <TD>
                            <%=index%>
                        </TD>
                        <TD title="<%=wbo.getAttribute("unused")%>"><!--ip For Client-->
                            <%=wbo.getAttribute("eventName")%>
                        </TD>
                        <TD>
                            <%=wbo.getAttribute("objectName")%>
                        </TD>
                        <TD>
                            <%=wbo.getAttribute("realObjectId")%>
                        </TD>
                        <TD>
                            <%=wbo.getAttribute("eventTime")%>
                        </TD>
                        <TD>
                            <%=wbo.getAttribute("loggerMessage")%>
                        </TD>
                        <TD title="<%=wbo.getAttribute("objectXml")%>" >
                            <%=wbo.getAttribute("userName")%>
                            <input type="hidden" value="<%=wbo.getAttribute("objectXml")%>" id="objXml"/>
                        </TD>
                        <TD title="<%=wbo.getAttribute("objectXml")%>" >
                            <img src="images/icons/info.png" style="width:20px; height: 20px;"  title="<%=wbo.getAttribute("objectXml")%>" onclick="viewXmlObjectData(this.title)"/>
                        </TD>
                    </TR>
                    <% }%>
                </TBODY>
            </TABLE>
            <div class="login" id="objectXml"  style="width: 40% ;margin-right: auto ;margin-left: auto;display: none;position: fixed;top: 0%;">
                <div style="clear: both;margin-left: 88%;margin-bottom: -38px;z-index: -10000000;">
                    <img src="images/close_popup.png" width="32" height="32" style="background-repeat: no-repeat;   -webkit-box-shadow: 0px 0px 17px rgba(255, 255, 255, 1.0);
                         -moz-box-shadow:    0px 0px 17px rgba(255, 255, 255, 1.0);
                         box-shadow:         0px 0px 17px rgba(255, 255, 255, 1.0);
                         -webkit-border-radius: 100px;
                         -moz-border-radius: 100px;
                         border-radius: 100px;" onclick="closePopup(this)"/>
                </div>
                <h1><%=clntData%></h1>
            </div>   
            <br>
            <br>
        </FIELDSET>
        <script type="text/javascript">
            var oTable;
            var oTable1;
            var users = new Array();
            $(document).ready(function() {
                oTable = $('#logs').dataTable({
                    bJQueryUI: true,
                    sPaginationType: "full_numbers",
                    "aLengthMenu": [[25, 50, 100, -1], [25, 50, 100, "All"]],
                    iDisplayLength: 25,
                    iDisplayStart: 0,
                    "bPaginate": true,
                    "bProcessing": true,
                    "aaSorting": [[0, "asc"]]
                }).fadeIn(2000);
            });
        </script>
    </BODY>
</HTML>
