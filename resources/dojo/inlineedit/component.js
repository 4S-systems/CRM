dojo.require("dojo.widget.*");
dojo.require("dojo.widget.InlineEditBox");
dojo.require("dojo.event.*");

dojo.widget.createWidget(widget.uuid);

var editable = dojo.widget.byId(widget.uuid);
editable.onSave = function() {
    var id = widget.uuid;
    alert("saving " + id);
};

jmaki.attributes.put(widget.uuid, editable);
