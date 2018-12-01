function Visitor(params) {

    this.init = function(pobj) {
        if (typeof pobj == 'undefined') {
            pobj = {
                indexAlias: '/contents',
                visClass: 'visited',
                autorun: true
            }
        }

        this.indexAlias = pobj.indexAlias;
        this.visClass = pobj.visClass;

        this.curl = null;  // curl = Current URL
        this.urls = null;  // Will be an array later.
        this.tags = null;  // The document's a tags.

        if (pobj['autorun']) {
            this.getURLs();
            this.getCURL();
            this.addCURL();
            this.getTags();
            this.addListeners();
            this.applyVisClass();
            this.cleanup()
        }
    };



    this.getCURL = function() {
        var url = window.location.pathname;
        this.curl = ((url == '/') && (this.indexAlias))
            ? this.indexAlias
            : url;
        // console.log('curl = ' + this.curl);
    };

    this.addCURL = function() {
        document.cookie = this.cleanURL()+'=1'+'; path=/';
        // console.log("added curl to cookie: " + document.cookie);
    };



    this.addListeners = function() {
        for (var i = 0; i < this.tags.length; i++) {
            this.tags[i].addEventListener('click', this, false);
        }
    };



    this.getTags = function() {
        this.tags = document.getElementsByTagName('a');
    };



    // Thanks to Quirksmode: http://www.quirksmode.org/js/cookies.html
    this.getURLs = function() {
        this.urls = [ ];

	      var cookarr = document.cookie.split(';');
	      for (var i = 0; i < cookarr.length; i++) {
		        var cook = cookarr[i];
            // Could use str.trim() if don't care about IE < 9
		        while (cook.charAt(0) == ' ') {
                cook = cook.substring(1, cook.length);
            }

            var urllen = cook.indexOf('=');
            if (urllen > -1) {
                var url = cook.substring(0, urllen);
                this.urls.push(url);
            }
	      }
    };



    this.cookieContainsURL = function(chk) {
        var ret = false,
            url = '';

        if (typeof(chk) == 'string') {
            url = this.cleanURL(chk);
        }
        else {
            this.getURLs();
            this.getCURL();
            url = this.cleanURL();
        }

        for (var i = 0; i < this.urls.length; i++) {
            if (this.urls[i] == url) {ret = true;}
        }

        return ret;
    };



    this.applyVisClass = function(tags) {
        if (typeof tags == 'undefined') {this.getTags();}
        else {this.tags = tags;}

        for (var i = 0; i < this.tags.length; i++) {
            var chk = this.tags[i].getAttribute('href') || null;
            if ((chk) && (this.cookieContainsURL(chk))) {
                this.tags[i].className = this.tags[i].className + ' ' + this.visClass;
            }
        }
    };



    this.addTag = function(tag) {
        this.curl = tag.getAttribute('href');
        this.addCURL();
        this.getURLs();
        this.applyVisClass([tag]);
    };



    this.cleanURL = function(url) {
        url = (typeof url == 'string') ? url : this.curl;
        return url.replace(/[^A-Z0-9a-z]/g, '');
    };



    this.cleanup = function() {
        this.curl = null;
        this.urls = null;
        this.tags = null;
    };



    this.handleEvent = function(evt) {
        if (!evt) {var evt = window.event;}
        this.evt = evt;

        this.evt.stopPropagation();
        // this.evt.preventDefault();

        if (this.evt.type == 'click') {
            var targ = this.evt.target;
            while (targ.nodeName != 'A') {targ = targ.parentNode;}
            this.addTag(targ);
        }
    };



    this.init(params);
}
