<%-- 
    Document   : wrkrOrMsuLocation
    Created on : Dec 4, 2017, 3:13:35 PM
    Author     : fatma
--%>

<%@page import="com.android.business_objects.LiteWebBusinessObject"%>
<%@page import="com.silkworm.international.TouristGuide"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="com.silkworm.business_objects.WebBusinessObject"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    TouristGuide tGuide = new TouristGuide("/com/tracker/international/BasicOps");
    
    ArrayList<LiteWebBusinessObject> locations=(ArrayList<LiteWebBusinessObject>)request.getAttribute("LocationsVector");
    ArrayList latList = new ArrayList();
    ArrayList lngList = new ArrayList();
    for(int i=0;i<locations.size();i++)
    {
        latList.add((String)(locations.get(i)).getAttribute("lat"));
        lngList.add((String)(locations.get(i)).getAttribute("lng"));
    }
    JSONArray jsonLatList = new JSONArray();
    jsonLatList.addAll(latList);
    JSONArray jsonLngList = new JSONArray();
    jsonLngList.addAll(lngList);
    String latJson=jsonLatList.toJSONString();
    String lngJson=jsonLngList.toJSONString();
    
    String vName = request.getAttribute("vName") != null ? " Locations Of " + (String) request.getAttribute("vName") : "";
    
%>

<!DOCTYPE html>
<html>
    <head>
        <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
        <title> GPS lOCATION </title>
    </head>
    
    <script type="text/javascript"src="http://maps.googleapis.com/maps/api/js?key=AIzaSyBF6bzM0-thal8DDuQuuMrPXUW5JLOGTUY&language=ar&region=ES"></script>
    
    <style type="text/css">
        #map_canvas {
	    height: 540px;
	    width: 100%;
	    background-color: grey;
	}
    </style>
        
    <script type="text/javascript">
	var map;
	function initialize() {
	    var latPos = JSON.parse('<%=latJson%>');
	    var lngPos = JSON.parse('<%=lngJson%>');
	    
	    var haightAshbury1 = new google.maps.LatLng(latPos[latPos.length - 1], lngPos[lngPos.length - 1]);
	    
	    var mapOptions = {
		zoom: 10,
		center: haightAshbury1,
		radius: 25000,
		mapTypeId: google.maps.MapTypeId.HYBRID,
		styles: [
		    {elementType: 'geometry', stylers: [{color: '#242f3e'}]},
		    {elementType: 'labels.text.stroke', stylers: [{color: '#242f3e'}]},
		    {elementType: 'labels.text.fill', stylers: [{color: '#746855'}]},
		    {
		      featureType: 'administrative.locality',
		      elementType: 'labels.text.fill',
		      stylers: [{color: '#d59563'}]
		    },
		    {
		      featureType: 'poi',
		      elementType: 'labels.text.fill',
		      stylers: [{color: '#d59563'}]
		    },
		    {
		      featureType: 'poi.park',
		      elementType: 'geometry',
		      stylers: [{color: '#263c3f'}]
		    },
		    {
		      featureType: 'poi.park',
		      elementType: 'labels.text.fill',
		      stylers: [{color: '#6b9a76'}]
		    },
		    {
		      featureType: 'road',
		      elementType: 'geometry',
		      stylers: [{color: '#38414e'}]
		    },
		    {
		      featureType: 'road',
		      elementType: 'geometry.stroke',
		      stylers: [{color: '#212a37'}]
		    },
		    {
		      featureType: 'road',
		      elementType: 'labels.text.fill',
		      stylers: [{color: '#9ca5b3'}]
		    },
		    {
		      featureType: 'road.highway',
		      elementType: 'geometry',
		      stylers: [{color: '#746855'}]
		    },
		    {
		      featureType: 'road.highway',
		      elementType: 'geometry.stroke',
		      stylers: [{color: '#1f2835'}]
		    },
		    {
		      featureType: 'road.highway',
		      elementType: 'labels.text.fill',
		      stylers: [{color: '#f3d19c'}]
		    },
		    {
		      featureType: 'transit',
		      elementType: 'geometry',
		      stylers: [{color: '#2f3948'}]
		    },
		    {
		      featureType: 'transit.station',
		      elementType: 'labels.text.fill',
		      stylers: [{color: '#d59563'}]
		    },
		    {
		      featureType: 'water',
		      elementType: 'geometry',
		      stylers: [{color: '#17263c'}]
		    },
		    {
		      featureType: 'water',
		      elementType: 'labels.text.fill',
		      stylers: [{color: '#515c6d'}]
		    },
		    {
		      featureType: 'water',
		      elementType: 'labels.text.stroke',
		      stylers: [{color: '#17263c'}]
		    }
		]
	    };
	    
	    map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
	    for (var i = 0; i < latPos.length; i++)
	    {
		var haightAshbury1 = new google.maps.LatLng(latPos[i], lngPos[i]);
		var marker = new google.maps.Marker({
		    position: haightAshbury1,
		    title: ""
		});

		// To add the marker to the map, call setMap();
		marker.setAnimation(google.maps.Animation.BOUNCE);
		marker.setMap(map);
	    }
	}
    </script>
    
    <body onload="initialize();">
	<fieldset style="border-width: thick; border-style: double; background-color: grey;">
	    <legend style="text-align: center; font-size: 5; font-weight: bold;">
		 <%=vName%> 
	    </legend>
	    
	    <div id="map_canvas">
		
	    </div>
	</fieldset>
    </body>
</html>
