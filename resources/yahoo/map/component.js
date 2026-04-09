// these are the defaults 
var zoom = 7;

// default location to Yahoo
var centerLat = 37.4041960114344;
var centerLon = -122.008194923401;

var mapType = YAHOO_MAP_REG;

var mapW = 400;
var mapH = 400;

// pull in args
if (typeof widget.args != 'undefined') {
    if (widget.args.zoom != 'undefined') {
        zoom = Number(widget.args.zoom);
    }

    if (widget.args.centerLat != 'undefined') {
        centerLat = Number(widget.args.centerLat);
    }
    if (widget.args.centerLon != 'undefined') {
        centerLon = Number(widget.args.centerLon);
    }

    if (widget.args.mapType != 'undefined') {
        if (widget.args.mapType == 'YAHOO_MAP_REG') {
           mapType = YAHOO_MAP_REG;
        } else if (widget.args.mapType == 'YAHOO_MAP_SAT') {
            mapType = YAHOO_MAP_SAT;
        } else if (widget.args.mapType == 'YAHOO_MAP_HYB') {
            mapType = YAHOO_MAP_HYB;
        }
    }

    if (typeof widget.args.height != 'undefined') {
        mapH = Number(widget.args.height);
    }

    if (typeof widget.args.width != 'undefined') {
        mapW = Number(widget.args.width);
    }  
}

var containerDiv = document.getElementById(widget.uuid);
var mapSize = new YSize(mapW,mapH);

var centerPoint = new YGeoPoint(centerLat,centerLon);
var map = new YMap(containerDiv, mapType, mapSize);
// Display the map centered on a latitude and longitude
map.drawZoomAndCenter(centerPoint, zoom);

// Add map type control
map.addTypeControl();

// map zoomer
map.addZoomLong();

// Set map type to either of: YAHOO_MAP_SAT YAHOO_MAP_HYB YAHOO_MAP_REG
map.setMapType(mapType);

// add to the instance map for later refernece
jmaki.attributes.put(widget.uuid, map);