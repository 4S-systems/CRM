
// load library dependencies
jmaki.loadStyle("/resources/yahoo/calendar/assets/calendar.css");
jmaki.loadScript("/resources/yahoo/dom/dom.js");
jmaki.loadScript("/resources/yahoo/calendar/calendar.js");


var cal1;
cal1 = new YAHOO.widget.Calendar("jmaki.attributes.get('" + widget.uuid + "')", widget.uuid);
cal1.render();

// add to the instance map for later refernece
jmaki.attributes.put(widget.uuid, cal1);

