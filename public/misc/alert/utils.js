/*

  These are scraps. A place for them might become apparent at some
  point, but currently they are floating.

  setCssTransform: function(elem, xpos, ypos) {
  elem.style.webkitTransform = 'translate(' + xpos +', ' + ypos + ')';
  elem.style.mozTransform = 'translate(' + xpos +', ' + ypos + ')';
  elem.style.msTransform = 'translate(' + xpos +', ' + ypos + ')';
  elem.style.transform = 'translate(' + xpos +', ' + ypos + ')';
  },



  isMouseOffTarget: function(evnt, trgt) {
  var ret = null,
  targ = null;

  if ((typeof evnt == 'object') && (trgt)) {
  if (evnt.type == 'mouseout') {
  targ = evnt.relatedTarget || evnt.fromElement;
  }
  else if (evnt.type == 'mouseover') {
  targ = evnt.target;
  }

  if (targ) {
  while ((targ != trgt) && (targ != document.body) && (targ != document)) {
  targ = targ.parentNode;
  }
  }
  ret = (targ == trgt) ? false : true;
  }

  return ret;
  },



  // From http://javascript.info/tutorial/animation
  animate: function(opts) {
  var start = new Date;

  var id = setInterval(function() {
  var timePassed = new Date - start;
  var progress = timePassed / opts.duration;

  if (progress > 1) {progress = 1;}

  var delta = opts.delta(progress);
  opts.step(delta);

  if (progress == 1) {clearInterval(id);}
  }, opts.delay || 10);    
  },


  quad: function(progress) {
  return Math.pow(progress, 4)
  },



    // function execElementScripts(elem) {
    //     var scrs = elem.getElementsByTagName('script');
    //     for (var o = 0, m = scrs.length; o < m; o++) {
    //         eval(scrs[o].innerHTML);
    //     }
    // }

*/


var Utils = (function () {

    function nestObject(keys, end_val) {
        var ret = { };

        if (keys.length == 1) {
            if (keys[0] in ret) {
                if (!(typeof end_val == 'undefined')) {
                    if (end_val.constructor == Object) {
                        ret[keys[0]] = merge(ret[keys[0]], end_val);
                    }
                    else {
                        ret[keys[0]] = end_val;
                    }
                }
            }
            else {
                ret[keys[0]] = (typeof end_val == 'undefined') ? { } : end_val;
            }
        }
        else {
            ret[keys[0]] = nestObject(keys.slice(1), end_val);
        }

        return ret;
    }



    function merge(obj1, obj2) {
        for (var key in obj2) {
            if (obj2.hasOwnProperty(key)) {
                if ((obj1[key]) &&
                    (obj1[key].constructor == Object) &&
                    (obj2[key].constructor == Object)) {
                    obj1[key] = merge(obj1[key], obj2[key]);
                }
                else {
                    obj1[key] = obj2[key];
                }
            }
        }

        return obj1;
    }



    function sieveObjects(obj1, obj2) {
        var new_obj = { };

        for (var key in obj1) {
            if (obj1.hasOwnProperty(key)) {
                if (obj2.hasOwnProperty(key)) {
                    if (obj1[key] === null) {
                        new_obj[key] = obj2[key];
                    }

                    else if ((obj1[key].constructor == Object) &&
                             (obj2[key].constructor == Object)) {
                        new_obj[key] = sieveObjects(obj1[key], obj2[key]);
                    }

                    else {
                        new_obj[key] = obj2[key];
                    }
                }

                else {
                    new_obj[key] = obj1[key];
                }
            }
        }

        return new_obj;
    }



    function getElemsByAttrs(elem, attrs) {
        var elems = [ ];

        if (elem.tagName) {
            var inc = true;

            for (var key in attrs) {
                if (!(check = elem.getAttribute(key)) ||
                    (check != attrs[key])) {
                    inc = false;
                }
            }

            if (inc) {
                elems.push(elem);
            }
            else if (elem.childNodes) {
                var checks = elem.childNodes;
                for (var o = 0, m = checks.length; o < m; o++) {
                    elems = elems.concat(getElemsByAttrs(checks[o], attrs));
                }
            }
        }

        return elems;
    }



    // Pass this a list of nodes and a function to pass each of those
    // to. It will return an object with two keys: `pass`, being an
    // array containing the nodes that passed the check, and `fail`,
    // being an array containing the nodes that didn't.
    // The check will be recursive unless specified otherwise.
    function checkNodes(nodes, check, recur) {
        recur = (typeof recur == 'undefined') ? true : recur;

        var matches = { pass: [ ], fail: [ ] };

        for (var o = 0, m = nodes.length; o < m; o++) {
            // For element nodes.
            if (nodes[o].nodeType == 1) {
                if ((recur) && (nodes[o].childNodes.length > 0)) {
                    if (checkNodes(nodes[o].childNodes, check, recur).pass.length > 0) {
                        matches.pass.push(nodes[o]);
                    }
                    else {
                        matches.fail.push(nodes[o]);
                    }
                }

                else if (check(nodes[o])) {
                    matches.pass.push(nodes[o]);
                }

                else {
                    matches.fail.push(nodes[o]);
                }
            }

            // For text nodes.
            else if (nodes[o].nodeType == 3) {
                if (check(nodes[o])) {
                    matches.pass.push(nodes[o]);
                }

                else {
                    matches.fail.push(nodes[o]);
                }
            }
        }

        return matches;
    }





    /*
     * Public methods.
     */
    return {

        // This is a modified version of the procedure found here:
        // http://stackoverflow.com/questions/912596/how-to-turn-a-string-into-a-javascript-function-call
        // Rather than produce a callable function and then call it with supplied arguments,
        // this just returns the function.
        stringToFunction: function(functionName, context) {
            context = (typeof context == 'undefined') ? window : context;

            var namespaces = functionName.split('.');
            var func = namespaces.pop();

            for (var o = 0, m = namespaces.length; o < m; o++) {
                context = context[namespaces[o]];
            }

            if (typeof context[func] == 'function') {
                return context[func];
            }
            else {
                return false;
            }
        },



        buildNestedObject: function(keys, end_val) {
            return nestObject(keys, end_val);
        },



        mergeObjects: function(obj1, obj2) {
            return merge(obj1, obj2);
        },



        // Pass this two objects. It will return a copy of `obj1`
        // but with the values of matching keys from `obj2`.
        sieve: function(obj1, obj2) {
            return sieveObjects(obj1, obj2);
        },



        checkElemsForString: function(elems, string) {
            return checkNodes(elems,
                              (function (elem) {
                                  if ((typeof elem == 'object') &&
                                      (elem.nodeType == 3) &&
                                      (elem.nodeValue.toLowerCase().indexOf(string) > -1)) {
                                      return true;
                                  }

                                  else if ((typeof elem == 'string') &&
                                           (elem.toLowerCase().indexOf(string) > -1)) {
                                      return true;
                                  }

                                  else {
                                      return false;
                                  }
                              })
                             );
        },



        checkElemsForAttr: function(elems, attr_val, attr_name, recur) {
            attr_name = (typeof attr_name == 'undefined') ? 'class' : attr_name;
            recur = (typeof recur == 'undefined') ? false : recur;

            return checkNodes(elems,
                              (function (elem) {
                                  if ((typeof elem == 'object') &&
                                      (attr = elem.getAttribute(attr_name)) &&
                                      (attr.split(' ').indexOf(attr_val) > -1)) {
                                      return true;
                                  }
                                  else {
                                      return false;
                                  }
                              }),
                              recur
                             );
        },



        // This is just a shortcut to `checkNodes`.
        runCheck: function(elems, check, recur) {
            return checkNodes(elems, check, recur);
        },



        appendChildren: function(parent, childs) {
            var ret = parent;

            for (var o = 0, m = childs.length; o < m; o++) {
                parent.appendChild(childs[o]);
            }

            return parent;
        },



        // Pass this an array of keys, an array of objects, a
        // function to perform on each member of the object array,
        // and a function to perform on the members of resulting
        // object before it's returned.
        makeDataObj: function(key_arr, obj_arr, obj_fx, key_fx) {
            obj_fx = (typeof obj_fx == 'function') ? obj_fx : false;
            key_fx = (typeof key_fx == 'function') ? key_fx : false;

            var ret = { };

            for (var o = 0, m = key_arr.length; o < m; o++) {
                var key = key_arr[o],
                    arr = [ ];

                for (var i = 0, n = obj_arr.length; i < n; i++) {
                    if (obj_arr[i].hasOwnProperty(key)) {
                        if (obj_fx) {
                            arr.push(obj_fx(obj_arr[i][key]));
                        }
                        else {
                            arr.push(obj_arr[i][key]);
                        }
                    }
                }

                ret[key] = (key_fx) ? key_fx(arr) : arr;
            }

            // console.log("Made data object:");
            // console.log(ret);

            return ret;
        },



        // Pass this an object, a key in that object, a function to
        // perform with the value of that key, if it exists, and a
        // function to transform that value before returning it. The
        // last parameter is optional.
        getFromObj: function(obj, key, check, transform) {
            var ret = false;

            if ((key in obj) && (check(obj[key]))) {
                ret = (typeof transform == 'function') ? transform(obj[key]) : obj[key];
            }

            return ret;
        },



        looksLikeJSON: function(string) {
            if ((typeof string == 'string') &&
                (string[0] == '{') && (string[(string.length - 1)] == '}')) {
                return true;
            }
            else {
                return false;
            }
        },



        makeNumber: function(x) {
            var num = 0;

            // So we know it's not nothing.
            if (x) {
                if (typeof x == 'number') {
                    num = x;
                }

                else if (typeof x == 'string') {
                    if (x.match(/[, ]/)) {
                        num = x.replace(/[, ]/g, '');
                    }

                    num = (x.match(/\./))
                        ? parseFloat(x)
                        : parseInt(x);
                }

            }

            return num;
        },



        getNearestParentByTagname: function(source, tagname) {
            var elem = source;

            while ((!elem.tagName) ||
                   ((elem.tagName.toLowerCase() != tagname) &&
                    (elem != document.body))) {
                elem = elem.parentNode;
            }

            if (elem == document.body) {return false;}
            else {return elem;}
        },



        getNearestParentByClassname: function(source, check_class, attr_name) {
            if (typeof attr_name == 'undefined') {
                attr_name = 'class';
            }

            var elem = source,
                found = false;

            while ((!found) && (elem != document.body)) {
                if ((elem.hasAttribute(attr_name)) &&
                    (elem.getAttribute(attr_name).split(' ').indexOf(check_class) > -1)) {
                    found = true;
                }
                
                if (!found) {
                    elem = elem.parentNode;
                }
            }

            if (found) {
                return elem;
            }
            else {
                return found;
            }
        },



        getElementsByAttributes: function(elem, attrs) {
            return getElemsByAttrs(elem, attrs);
        },



        getSiblings: function(source, count, dir) {
            dir = (typeof dir == 'undefined') ? 1 : dir;
            count = (typeof count == 'number') ? count : 1;

            if (dir == 1) {
                var getNext = (function (node) {
                    return node.nextSibling;
                });
            }
            else {
                var getNext = (function (node) {
                    return node.previousSibling;
                });
            }

            var node = source,
                sibs = [ ],
                n = 0;

            while ((n < count) && (node = getNext(node))) {
                if (node.nodeType == 1) {
                    sibs.push(node);
                    n += 1;
                }
            }

            if (sibs.length == 1) {return sibs[0];}
            else {return sibs;}
            // return sibs;
        },



        addListeners: function(elems, func, event_type) {
            event_type = (typeof event_type == 'undefined') ? 'click' : event_type;
            var m = elems.length;

            for (var o = 0; o < m; o++) {
                elems[o].addEventListener(event_type, func, false);
            }
        },



        addToParent: function(content) {
        },



        // This ensures the given URL starts with `http://` or `https:/`.
        prefixUrl: function(url) {
            // http:// == 0-6
            if (url.substring(0, 6) == window.location.origin.substring(0, 6)) {
                return url;
            }
            else {
                if (url[0] == '/') {
                    return window.location.origin + url;
                }
                else {
                    return window.location.origin + '/' + url;
                }
            }
        },



        makeElement: function(tagname, attrs, content) {
            var elem = document.createElement(tagname);

            for (var key in attrs) {
                if (attrs.hasOwnProperty(key)) {
                    elem.setAttribute(key, attrs[key]);
                }
            }

            if ((typeof content !== 'undefined') && (content)) {
                if (typeof content == 'object') {
                    elem.appendChild(content);
                }
                else {
                    elem.innerHTML = content;
                }
            }

            return elem;
        },



        replaceChild: function(old_elem, new_elem) {
            var par = old_elem.parentNode,
                childs = par.childNodes,
                index = -1;

            out:
            for (var o = 0, m = childs.length; o < m; o++) {
                if (childs[o] == old_elem) {
                    index = o;
                    par.insertBefore(new_elem, childs[o]);
                    par.removeChild(old_elem);
                    break out;
                }
            }

            return index;
        },



        // From http://www.shamasis.net/2009/09/fast-algorithm-to-find-unique-items-in-javascript-array/
        unique: function(array) {
            var o = {}, i, l = array.length, r = [];
            for (i=0; i<l; i++) {o[array[i]] = array[i];}
            for (i in o) {r.push(o[i]);}
            return r;
        },



        // This is a modified version of the function from
        // http://www.quirksmode.org/js/findpos.html
        getPosition: function(elem) {
	        var curleft = curtop = 0;

            if (elem.offsetParent) {
                do {
			        curleft += elem.offsetLeft;
			        curtop += elem.offsetTop;
                } while (elem = elem.offsetParent);
            }

	        return {x: curleft, y: curtop};
        },



        getIndexOf(list, item) {
            var index = -1;

            out:
            for (var o = 0, m = list.length; o < m; o++) {
                if (list[o] == item) {
                    index = o;
                    break out;
                }
            }

            return index;
        },



        average: function(array) {
            var m = 0,
                n = 0;

            for (var o = 0, x = array.length; o < x; o++) {
                if (typeof array[o] == 'number') {
                    n += array[o];
                    m += 1;
                }
            }

            return (n / m);
        }

    };

})();
