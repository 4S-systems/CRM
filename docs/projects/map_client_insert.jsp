<%@page import="com.silkworm.business_objects.secure_menu.MenuElement"%>
<%@page import="com.silkworm.business_objects.secure_menu.OneDimensionMenu"%>
<%@page import="com.silkworm.business_objects.secure_menu.TwoDimensionMenu"%>
<%@ page import="com.silkworm.business_objects.*,java.util.*,java.util.regex.Matcher,java.util.regex.Pattern,com.silkworm.common.*,com.silkworm.util.*,com.silkworm.common.bus_admin.*"%>
<%@ page import="com.silkworm.international.TouristGuide,com.maintenance.db_access.*"%>
<%@ page import="com.silkworm.business_objects.*,com.silkworm.common.*,com.silkworm.common.bus_admin.*, java.util.*"%>
<%@ page import="com.silkworm.international.TouristGuide, com.contractor.db_access.MaintainableMgr"%>
<%@ page import="com.silkworm.util.DateAndTimeConstants"%>
<%@ page import="com.silkworm.common.TimeServices,com.silkworm.jsptags.*"%>
<%@taglib prefix="sw" uri="/WEB-INF/swtaglib.tld" %>
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>

<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");

    MetaDataMgr metaMgr = MetaDataMgr.getInstance();
    String context = metaMgr.getContext();
    String clientID = (String)request.getAttribute("clientID");
    String type = (String)request.getAttribute("type");
    

    String coordinate = (String) request.getAttribute("coordinate");
    Pattern pattern = Pattern.compile("\\(.*\\)$");
    String cord = "(21.422949491565994, 39.82664388997273)";
    if (!(coordinate == null || coordinate.equals(""))) {
        Matcher matcher = pattern.matcher(coordinate);

        if (matcher.find()) {
            cord = coordinate;
        }
    }
    String cMode = (String) request.getSession().getAttribute("currentMode");
    String stat = cMode;
    String align = null;
    String dir = null;
    String style = null;
    String message = null;
    String lang, langCode, treelang, title, Show, mainData, EquipmentRow, selectMain, link1, link2, link3, link4, link5, M1, M2, Dupname;
    String locName;
    if (stat.equals("En")) {
        align = "center";
        treelang = "nameEn";
        dir = "LTR";
        style = "text-align:left";
        lang = "   &#1593;&#1585;&#1576;&#1610;    ";
        langCode = "Ar";
        title = "Equipment Tree";
        Show = "Show Tree";
        EquipmentRow = "Equipment Categories";
        selectMain = "Select Main Type";
        link1 = "Equipment Details";
        link2 = "Last Job Order";
        link3 = "Schedules";
        link4 = "Equipment Plan";
        link5 = "Related Parts";
        M1 = "The Saving Successed";
        M2 = "The Saving Successed Faild";
        Dupname = "Name is Duplicated Chane it";
        locName="Location Name";
    } else {
        align = "center";
        treelang = "nameAr";
        dir = "RTL";
        style = "text-align:Right";
        lang = "English";
        langCode = "En";
        title = "&#1588;&#1580;&#1585;&#1577; &#1575;&#1604;&#1605;&#1593;&#1583;&#1575;&#1578;";
        Show = "&#1593;&#1585;&#1590; &#1575;&#1604;&#1588;&#1580;&#1585;&#1607;";
        EquipmentRow = " &#1575;&#1604;&#1606;&#1608;&#1593; &#1575;&#1604;&#1575;&#1587;&#1575;&#1587;&#1610;";
        selectMain = "&#1571;&#1582;&#1578;&#1585; &#1606;&#1608;&#1593; &#1585;&#1574;&#1610;&#1587;&#1610;";
        link1 = "&#1578;&#1601;&#1575;&#1589;&#1610;&#1604; &#1575;&#1604;&#1605;&#1593;&#1583;&#1607;";
        link2 = "&#1593;&#1585;&#1590; &#1571;&#1582;&#1585; &#1571;&#1605;&#1585; &#1588;&#1594;&#1604;";
        link3 = "&#1575;&#1604;&#1580;&#1583;&#1575;&#1608;&#1604;";
        link4 = "&#1575;&#1604;&#1582;&#1591;&#1607;";
        link5 = "&#1602;&#1591;&#1593; &#1575;&#1604;&#1594;&#1610;&#1575;&#1585;";
        M1 = "&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604; &#1576;&#1606;&#1580;&#1575;&#1581; ";
        M2 = "&#1604;&#1605; &#1610;&#1578;&#1605; &#1575;&#1604;&#1578;&#1587;&#1580;&#1610;&#1604;";
        Dupname = "&#1607;&#1584;&#1575; &#1575;&#1604;&#1575;&#1587;&#1605; &#1587;&#1580;&#1604; &#1605;&#1606; &#1602;&#1576;&#1604; &#1610;&#1580;&#1576; &#1578;&#1587;&#1580;&#1610;&#1604; &#1575;&#1587;&#1605; &#1570;&#1582;&#1585;";
        locName="اسم العنوان";
    }

    ArrayList treeMenu = metaMgr.getTreeMenu();
//TMD this is my treee     
    TwoDimensionMenu TMD = (TwoDimensionMenu) treeMenu.get(0);
//menu Info is root of my tree     
    WebBusinessObject menuInfo = (WebBusinessObject) TMD.getMenuInfo();
//nodMenuList is list of nodes of tree       
    ArrayList nodMenulist = TMD.getContents();
//    

    System.out.println("$$$$$$$$$$$$$$$$$$$$$$$$" + menuInfo.getAttribute(treelang).toString());
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
        <style type="text/css">
            html { height: 100% }
            body { height: 100%; margin: 20; padding: 0 }
            #map_canvas { height: 540px; width:100%; }
        </style>
        <script type="text/javascript"src="http://maps.googleapis.com/maps/api/js?key=AIzaSyBF6bzM0-thal8DDuQuuMrPXUW5JLOGTUY&sensor=true&language=ar&region=ES">
        </script>
        <script type="text/javascript">
   
            var map;
            var markersArray = [];
            var marker;
            var locati='';
            function initialize() {
                var haightAshbury = new google.maps.LatLng<%=cord%>;
                //alert(haightAshbury);
                var mapOptions = {
                    zoom: 10,
                    center: haightAshbury,
                    radius: 25000,
                    mapTypeId: google.maps.MapTypeId.HYBRID
                };
                map =  new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
                marker = new google.maps.Marker({
                    position: haightAshbury,
                    title:"click on location!"
                });

                // To add the marker to the map, call setMap();
                marker.setAnimation(google.maps.Animation.BOUNCE);
                marker.setMap(map);
                google.maps.event.addListener(map, 'click', function(event) {
                    //alert(event.latLng.lat());
                    addMarker(event.latLng,event.latLng.lat(),event.latLng.lng());
                });
            }

            function addMarker(location,lat,lng) {
                marker.setMap(null);
                if (markersArray) {
                    for (i in markersArray) {
                        markersArray[i].setMap(null);
                    }
                    markersArray.length = 0;
                }
                marker = new google.maps.Marker({
                    position: location,
                    map: map
                });
                locati=location;
                marker.setAnimation(google.maps.Animation.BOUNCE);
                markersArray.push(marker);
                document.getElementById('coordinate').value="[ "+lat+" , "+lng+" ]";
  
                //alert(locati);
            }

            // Removes the overlays from the map, but keeps them in the array
            function clearOverlays() {
                if (markersArray) {
                    for (i in markersArray) {
                        markersArray[i].setMap(null);
                    }
                }
            }

            // Shows any overlays currently in the array
            function showOverlays() {
                if (markersArray) {
                    for (i in markersArray) {
                        markersArray[i].setMap(map);
                    }
                }
            }

            // Deletes all markers in the array by removing references to them
            function deleteOverlays() {
                marker.setMap(null);
                if (markersArray) {
                    for (i in markersArray) {
                        markersArray[i].setMap(null);
                    }
                    markersArray.length = 0;
                }
            }  </script>
    </head>
    <body onload="initialize()">

        <form method="POST" action="<%=context%>/ProjectServlet?op=insertClientLocation&type=add">
           
            <table dir="<%=dir%>">
                <tr>
                    <td><%=locName%></td>
                    <td><input type="text" name="locName" id="locName"/></td>
                </tr>
            </table>
            <input type="submit" value="   حفظ المكان  " onclick="window.close();window.opener.location.reload();"  class="button">
            <input name="coordinate" type="hidden" id="coordinate" value="<%=coordinate%>" size="92">
            <input name="clientID" type="hidden"  id="clientID" value="<%=clientID%>" size="92">
        </form>
        <div id="map_canvas"></div>
    </body>
</html>
