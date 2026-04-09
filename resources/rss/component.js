

function Rss(){
	var _widget = widget;
	this.uuid = widget.uuid;
	var _rssInstance;
	this.channel;
    this.id = 0;
    this.link = [];
    this.title = [];
    this.description = [];
    this.opacitysetting = 0.2; 
    this.getXHR = function() {
	    if (window.XMLHttpRequest) {
        	return new XMLHttpRequest();
    	} else if (window.ActiveXObject) {
        	return new ActiveXObject("Microsoft.XMLHTTP");
    	}
	}
	this.ajax = this.getXHR();
    this.getRSSContent();
}

Rss.prototype.getRSSContent = function(){
    _rssInstance = this;
    var _widget = widget;
    this.ajax.onreadystatechange = function(){ _rssInstance.loadRss()};
    var url = jmaki.webRoot + "/rssprovider?url=" + encodeURIComponent(_widget.service) + "&format=json&itemIndex=4";
    this.ajax.open('GET', url, true);
    this.ajax.send(null);
}

Rss.prototype.loadRss = function() {

    if (this.ajax.readyState == 4){ 

        if (this.ajax.status == 200){ 
	        this.channel = eval("(" + this.ajax.responseText + ")");
            this.rssItems = this.channel.channel.item;
            var tickerDiv = document.getElementById(this.uuid);
            if (typeof this.rssItems == 'undefined' || this.rssItems.length == 0) { 
                tickerDiv.innerHTML = "Sorry, cannot load RSS feed<br />" + response;
                return;
            }       
            
            var itemStr = '<div class="rssitem"><a href="'+this.rssItems[this.id].link+'">'+this.rssItems[this.id].title +'</a></div>';
            var descriptionStr = '<div class="rssdescription">'+this.rssItems[this.id].date +'</div>';
            var tickerStr = itemStr + descriptionStr ;
            this.fade("reset");
            tickerDiv.innerHTML = tickerStr;
            this.fadetimer1 = setInterval(function(){_rssInstance.fade('up', 'fadetimer1')}, 5000) 
            this.id=(this.id < this.rssItems.length-1)? this.id+1 : 0
            setTimeout(function(){_rssInstance.loadRss()}, 5000) 
        }
    }
}

Rss.prototype.fade=function(type, timerid){
    var tickerDiv=document.getElementById(this.uuid)
    if (type=="reset")
        this.opacitysetting=0.2
    if (tickerDiv.filters && tickerDiv.filters[0]){
        if (typeof tickerDiv.filters[0].opacity=="number") 
            tickerDiv.filters[0].opacity=this.opacitysetting*100
        else 
            tickerDiv.style.filter="alpha(opacity="+this.opacitysetting*100+")"
    } else if (typeof tickerDiv.style.MozOpacity!="undefined" && this.mozopacityisdefined){
        tickerDiv.style.MozOpacity=this.opacitysetting
    }
    if (type == "up")
        this.opacitysetting+=0.2
    if (type=="up" && this.opacitysetting>=1)
        clearInterval(this[timerid])
}

var rss = new Rss();