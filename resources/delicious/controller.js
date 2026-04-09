/* Copyright 2006 Sun Microsystems, Inc. All rights reserved. You may not modify, use, reproduce, or distribute this software except in compliance with the terms of the License at: http://developer.sun.com/berkeley_license.html
$Id: controller.js,v 1.2 2006/05/26 09:04:01 gmurray71 Exp $ */

var _global = this;

var controller;

function initScrollers() {
    controller = new CatalogController();
    controller.initialize();
    var is = new ImageScroller("ItemBrowser", 450, 300);
    var is2 = new ImageScroller("ItemBrowser2", 195, 195);
    var is3 = new ImageScroller("ItemBrowser3", 195,195);
    // wire the ImageScrollers to use the controller.handleEvent for event processing
    is.callbackHandler = controller.handleEvent;
    is2.callbackHandler = controller.handleEvent;
    is3.callbackHandler = controller.handleEvent;
    controller.loadJSON("reptiles.js", is2);
    controller.loadJSON("birds.js", is3);
    controller.loadFlickr(["theKt"], is);
}

function CatalogController() {
  
  // this object structure contains a list of the groups and chunks that have been loaded
  var pList = new GroupList();
  
  var CHUNK_SIZE=5;
  var originalURL;
  var useDOMInjection;
  
  this.handleEvent = function(args) {
      if (args.type == "showingItem") {
        var groupId = args.gid;
      	window.location.href= originalURL +  "#" + groupId + "," + args.id;
        showItemDetails(args.id, args.uuid);
      } else if (args.type == "getChunck") {
          //get chunck with args;
      }
  }
  
  function showItemDetails(id, uuid) {
      var infoName = document.getElementById(uuid + "_infopaneName");
      var infoDescription =  document.getElementById(uuid + "_infopaneDescription");
      var infoShortDescription =  document.getElementById(uuid + "_infopaneShortDescription");  
      var i = pList.getItem(id);
      setNodeText(infoName, genHTML(i.name));
      var sd = "";
      var description = "";
      if (i.description) description = genHTML(i.description)
      if (description.length > 70) {
        description.substring(0,71) + "...";
      } else {
          sd = description;
      }
      setNodeText(infoShortDescription,sd);
      setNodeText(infoDescription, description);
  }
  
    function setNodeText(t, text) {
      if (typeof t == 'undefined') return;
      if (typeof useDOMInjection == 'undefined') {
          testInnerHTML(t);
      }
      if (useDOMInjection) {
          if (t.lastChild == null) {
              var child = document.createTextNode(text);
              t.appendChild(child);
          } else {
            t.lastChild.nodeValue = text;
          }
      } else {
          t.innerHTML = text;
      }
  }
  
  
  function testInnerHTML(infoName) {
        var testString = "   ";
        infoName.innerHTML = testString;
        if (!useDOMInjection && infoName.innerHTML != testString) {
            useDOMInjection = true;
        } else {
            useDOMInjection = false;
        }
  }
  
  /**
  * Un-Escape HTML
  */
  function genHTML(orig) {
      var decode = orig.replace(/&gt;/g, ">");
      decode = decode.replace(/&lt;/g, "<");
      decode = decode.replace(/&quot;/g, "\"");
      decode = decode.replace(/&amp;/g, "&");
      return decode;
  }
  
  this.initialize = function() {
      processURLParameters();

  }
  
  this.loadJSON = function(serviceURL, scroller) {
      var req = getXHR();
      req.onreadystatechange = function() {
          if (req.readyState == 4) {
              if (req.status == 200) {
                  var group = eval('(' + req.responseText + ')');
                  scroller.addItems(group.items);
                  scroller.setGroupId(group.id);
                  pList.addChunck(group.id, 0, group.items);
                  scroller.showImage(group.items[0].id);
              }
          }
      };
      req.open("GET", serviceURL, true);
      req.send(null);
  }
  
  // this needs to happen after we have loaded the intial data
  function processURLParameters() {
      originalURL = decodeURIComponent(window.location.href);
      var params = {};
      // look for the params
      if (originalURL.indexOf("#") != -1) {
          var qString = originalURL.split('#')[1];
          var args = qString.split(',');
          originalURL = originalURL.split('#')[0];
          // load group args[0] with item args[1];
          return;
      }
  }

  function getXHR () {
      if (window.XMLHttpRequest) {
          return new XMLHttpRequest();
      } else if (window.ActiveXObject) {
          return new ActiveXObject("Microsoft.XMLHTTP");
      }
  }
    
  /**
   *  Insert a script tag in the head of the document which will inter load the flicker photos
   *  and call jsonFlickrFeed(obj) with the corresponding object.
   *
   */
  this.loadFlickr = function(tags, scroller) {
      
      var tag = "";
      for (var l=0; l < tags.length; l++) {
          tag = tag + tags[l];
          if (l < (tags.length -1)) {
              tag = tag + ",";
          }
      }
      // TODO: may be a problem with multiple concurrent feeds
      _global.jsonFlickrFeed = function(arg) {
          var _scroller = scroller;
          postProcessFlicker(arg, _scroller);
      }
      var s = document.createElement("script");
      var url ="http://www.flickr.com/services/feeds/photos_public.gne?tags=" + tag + "&format=json";
      s.src = url;
      s.type = "text/javascript";
      s.charset = "utf-8";
      document.body.appendChild(s);
      
  }
  
  function postProcessFlicker (obj, scroller) {
      var flickrPhotos = obj;
      // get info from the JSON object
      var fi = [];
      for (var l=0; l < flickrPhotos.items.length; l++) {
          var itemId = "flickr_" + l;
          var description = flickrPhotos.items[l].description;            
          var start = description.indexOf("src=") + 10;
          var stop =  description.indexOf("_m.jpg");
          var imageBase = description.substring(start,stop);
          var thumbURL = imageBase + "_m.jpg";
          var imageURL = imageBase + ".jpg";
          description = "Author: " + flickrPhotos.items[l].author + " tags:" + flickrPhotos.items[l].tags;
          var price = 0;
          var name = flickrPhotos.items[l].title;
          var i = {id:itemId , name: name, thumbnailURL: thumbURL, imageURL: imageURL, description: description};
          fi.push(i);
      }
      scroller.addItems(fi);
      var tags = flickrPhotos.items[0].tags
          scroller.setGroupId(tags);
      pList.addChunck(tags, 0, fi);
      scroller.showImage(fi[0].id);
  }
  
  function GroupList() {
      var _plist = this;
      var map = new Map();
      var gmap = new Map();
      
      this.addChunck = function(pid, chunkNumber, items) {
          for (var il =0; il < items.length; il++) {
              gmap.put(items[il].id, items[il]);
          }
          map.put(pid + "_" + chunkNumber, items, true);  
      }
      
      this.getChunck = function(pid, chunkNumber) {
          return map.get(pid + "_" + chunkNumber);  
      }
      
      this.hasChunck = function(pid, chunkNumber) {
          return (map.get(pid + "_" + chunkNumber) != null);  
      }
      
      this.getItem = function(id) {
          return gmap.get(id);
      }
  }
  
  function Map() {
      
      var size = 0;
      var keys = [];
      var values = [];
      
      this.put = function(key,value, replace) {
          if (this.get(key) == null) {
              keys[size] = key; values[size] = value;
              size++;
          } else if (replace) {
              for (i=0; i < size; i++) {
                  if (keys[i] == key) {
                      values[i] = value;
                  }
              }
          }
      }
      
      this.get = function(key) {
          for (i=0; i < size; i++) {
              if (keys[i] == key) {
                  return values[i];
              }
          }
          return null;
      }
      
      this.clear = function() {
          size = 0;
          keys = [];
          values = [];
      }
  }
}
