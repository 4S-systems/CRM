// Define a container object
var accordion = {};

accordion.ds = new Spry.Data.XMLDataSet("getResource.do?url=employees-01.xml", "/employees/employee");

//
// Step 2: Define an observer callback function.
//
//
// Step 3: Register the callback function as an observer on the region so that it
//         can auto-attach the Accordion behaviors.
//


Spry.Data.Region.addObserver(widget.uuid, "myCallback", function (rgnName, rgnState) {

	if (rgnState ==  Spry.Data.Region.RS_PostUpdate)
		var acc = new Spry.Widget.Accordion(widget.uuid);
        accordion.impl = acc;
        
});

jmaki.attributes.put(widget.uuid, accordion);
var container  = document.getElementById(widget.uuid);
// intialize only the necesarry region
Spry.Data.initRegions(container);


