/*
 * SCROLL MONITOR
 *
 * ScrollMonitor is a class for monitoring scroll distances and
 * positions. It's useful for cases in which you want to trigger
 * things when the user scrolls by a certain amount or within range
 * of an edge, like changing the nav menu when they scroll to the
 * top of the page or sliding something in from the left when they
 * scroll right.
 *
 *
 * USAGE
 *
 * Create an instance of ScrollMonitor by passing it a config object:
 *   var scroll_mon = new ScrollMonitor({
 *       pos: 'top',
 *       dist: 50,
 *       func_in: makeNavAppear,
 *       func_out: makeNavDisappear
 *   });
 *
 * After being initialized, `scroll_mon` will monitor the window's
 * scroll position and call `makeNavAppear` when the user scrolls
 * within 50 pixels of the top of the window and `makeNavDisappear`
 * when they scroll more than 50 pixels away from it. The functions
 * will be called only when the transition occurs and registers (if
 * the user scrolls quickly, the `scroll` event may not fire on
 * every pixel), and the callback will be passed an object
 * containing position and vector data that looks like:
 *   {
 *       x: {
 *           // an integer describing the current X position
 *           pos: (int),
 *           // a signed integer describing contiguous movement
 *           // along the X axis
 *           vect: (int)
 *       },
 *       y: {  // same but for the Y axis
 *           pos: (int),
 *           vect: (int)
 *       }
 *   }
 *
 * If that instance needs to change the buffer to 100 pixels:
 *   scroll_mon.dist(100);
 *
 * If that instance needs to change to monitor 100-pixel buffers
 * on both the top and bottom of the screen:
 *   scroll_mon.pos('y');
 *
 * To pause/stop monitoring (remove the `scroll` event listener):
 *   scroll_mon.stop();
 *
 * And then kill the instance:
 *   scroll_mon = null;
 *
 * Or to start monitoring again:
 *   scroll_mon.start();
 *
 * For a full list of public properties, see documentation on the
 * `setPublicProperties` function.
 *
 *
 * DEPENDENCIES
 *
 * None.
 *
 *
 * DETAILS
 *
 * An instance of ScrollMonitor can track either scroll position or
 * scroll distance but not both. The configuration of a positional
 * instance must look like:
 *   {
 *       // The element to monitor. Optional. Defaults to `window`.
 *       elem: (DOM element),
 *       // The position to monitor. Required.
 *       pos: [top|bottom|right|left|x|y],
 *       // A buffer off of that position. Optional. Defaults to 0.
 *       dist: (int),
 *       // The function to call when the scroll position moves into
 *       // the buffer range or against the edge. Required.
 *       func_in: (function),
 *       // The function to call when the scroll position moves out
 *       // of the buffer range or off of the edge. Required.
 *       func_out: (function),
 *       // Whether you want to see log messages. Optional. Defaults
 *       // to false.
 *       log: (bool)
 *   }
 *
 * The configuration of a distance instance looks nearly identical,
 * with these changes:
 *       // The direction of distance to monitor. Required.
 *       // This is instead of `pos`.
 *       dir: [up|down|left|right|x|y],
 *       // The distance the user must scroll in the given `dir`
 *       // in order to trigger the callback. Required.
 *       dist: (int),
 *       // The function to fire when the user scrolls the given
 *       // `dist` in the given `dir`. Required. Use this instead
 *       // of `func_in` and `func_out`.
 *       func: (function),
 *
 * During initialization, the functions that check distances and
 * position are set as state variables. This is in effort to
 * minimize the number of checks that must be made each time the
 * scroll event is fired, which can come frequently.
 *
 * Because those checks are set during initialization, a change in
 * any of the related configuration options must be reflected in the
 * internal state -- for example, if the user changes the instance's
 * monitored direction from `up` to `y`. For the sake of consistency,
 * the getting and setting of configuration options is done through
 * a function. These functions will have the same names as the keys
 * used to set them on instantiation -- e.g., `dist()` will return
 * the instance's distance, and `dist(9000)` will set its distance
 * to `9000`.
 *
 * Any of the configuration options can be changed at any time.
 *
 * One thing to be aware of is setting the "far edge" distance, e.g.
 *   pos: 'bottom', dist: 50
 *
 * When scrolling, the current position is always measured from the
 * top- and left-most corner of the window. So the number actually
 * set as the measurement of the "far edge" is:
 *     (height/width of document)
 *   - (height/width of viewport)
 *   - (height/width of `dist`)
 *
 * So for a document 1000 pixels high, in a viewport 100 pixels high,
 * with a `dist` of 50, the "far edge" is 850.
 *
 * Also note that, if you want to kill an instance, you must first
 * `stop()` it to remove the event listener.
 *
 */

function ScrollMonitor(config) {

    /*
     * These variables prefixed with `$` are state variables. They
     * retain the instance's scroll position, config, etc.
     *
     * `$self` will contain, e.g., instructions on handling the
     * scroll event. It will not be made public because those things
     * should not be exposed to the user and they provide no useful
     * information.
     *
     * `$conf` is given by the user. It makes some sense that they
     * should be able to change it, but the values are also used
     * internally, so they should be checked a little. See how they
     * are returned in `setPublicProperties`.
     *
     * The `$pos` coordinates can expose useful information but they
     * are also used internally, so to the user they are read-only.
     */
    var $self = { },
        $conf = { },
        $pos = {
            x: {orig: 0, last: 0, vect: 0},
            y: {orig: 0, last: 0, vect: 0}
        };



    /*
     * The default config lacks a `pos` key, even though that is a
     * valid key. See `validateConfig` for more on that.
     *
     * If `dir` is `null` is the user's config, then the `func` will
     * fire when the user scrolls the `dist` in any direction.
     */
    function getDefaultConfig() {
        if ($conf.log) {
            console.log("Getting default config object.");
        }

        return {
            // This is the direction. Valid values are given in
            // `getValidDirections`.
            dir: null,
            // This is the distance. It should be an integer.
            dist: null,
            // This is the element. Any scrollable element will work.
            elem: window,
            // This is the callback function.
            func: null,
            // This will trigger many messages in the console.log.
            log: false
        };
    }



    /*
     * `x` maps to `left` and `right`, `y` maps to `up` and `down`.
     * For more on those, see `validateConfig`.
     */
    function getValidDirections() {
        if ($conf.log) {
            console.log("Getting valid directions.");
        }

        return ['up', 'down', 'left', 'right', 'x', 'y'];
    }



    /*
     * Similarly, `x` maps to `left` and `right`, `y` maps to `top`
     * and `bottom`.
     */
    function getValidPositions() {
        if ($conf.log) {
            console.log("Getting valid positions.");
        }

        return ['top', 'bottom', 'left', 'right', 'x', 'y'];
    }


    /*
     * This dispatches to parameter-validation and self-setting and
     * returns the resulting user-facing properties.
     */
    function init(config) {
        if (($conf.log) || (config.log)) {
            console.log("Starting initialization of new scroll object with:");
            console.log(config);
        }

        var valid = null;

        if ((config.constructor === Object) &&
            (valid = validateConfig(mergeObjects(getDefaultConfig(), config)))) {

            $conf = valid;

            setSelfFromConf();
            addListener();

            if ($conf.log) {
                console.log("Validated and merged $conf:");
                console.log($conf);
                console.log("And $self:");
                console.log($self);
            }

            $self.handler();
        }

        else {
            console.log("Cannot initialize new scroll monitor: bad config object.");
            console.log(config);
        }

        var public = setPublicProperties();

        if ($conf.log) {
            console.log("Returning initialized object:");
            console.log(public);
        }

        return public;
    }



    /*
     * A ScrollMonitor instance will monitor either a `pos` or a
     * `dir`. In the interest of usability, the user-given position/
     * direction needs to be a descriptive word. In the interest of
     * efficiency, `x` and `y` are also valid words.
     *
     * If a `pos` is specified, then two functions should be given:
     * a `func_in` and a `func_out`. When the scroll position moves
     * into the given position, the `func_in` will fire, and when it
     * moves out, `func_out`.
     *
     * With a `dir` monitor only one `func` is needed.
     *
     * If a `pos` is specified, then the given `dist` will specify a
     * buffer off of that position.  So a config with
     *   { ... pos: 'top', dist: 100, ... }
     * will fire its `func_in` when the scroll position moves within
     * 100 pixels of the top of the element, and its `func_out` when
     * it moves out of that range.
     *
     * If `x` or `y` is given, then a bi-directional/-positional
     * boolean will be set to true, else false. This boolean allows
     * for easy setting of the vector in `getDeltas` and also easy
     * checking of the direction in `didScrollEnoughInDirection`, etc.
     *
     */
    function validateConfig(conf) {
        if ($conf.log) {
            console.log('Validating config.');
        }

        var valid = { };

        if ((conf.hasOwnProperty('pos')) &&
            (getValidPositions().indexOf(conf.pos) != -1)) {
            valid.pos = conf.pos;

            if ((conf.hasOwnProperty('func_in')) &&
                (typeof conf.func_in == 'function') &&
                (conf.hasOwnProperty('func_out')) &&
                (typeof conf.func_out == 'function')) {
                valid.func_in = conf.func_in;
                valid.func_out = conf.func_out;
            }
            else {
                console.log("Error: lacking in/out callback functions.");
                return null;
            }

            valid.dist = ((conf.hasOwnProperty('dist')) &&
                          (isInt(conf.dist)))
                ? conf.dist
                : 0;
        }

        else if (((conf.hasOwnProperty('dir')) &&
                  (isDirectionValid(conf.dir))) ||
                 (!conf.hasOwnProperty('dir'))) {
            valid.dir = conf.dir;

            if ((conf.hasOwnProperty('func')) &&
                (typeof conf.func == 'function')) {
                valid.func = conf.func;
            }
            else {
                console.log("Error: no callback function given.");
                return null;
            }

            if ((conf.hasOwnProperty('dist')) && (isInt(conf.dist))) {
                valid.dist = conf.dist;
            }
            else {
                console.log("Error: no distance given.");
                return null;
            }
        }

        else {
            console.log("Error: no direction/position given.");
            return null;
        }

        valid.elem = conf.elem;
        valid.log = conf.log;

        return valid;
    }



    /*
     * This is a convenience function, since the direction can be
     * set both on init and later by the user.
     */
    function isDirectionValid(dir) {
        if ($conf.log) {
            console.log('Checking if direction "'+dir+'" is valid.');
        }

        if (((getValidDirections().indexOf(dir) != -1)) ||
            (dir == null)) {
            return true;
        }
        else {
            return false;
        }
    }



    function setSelfFromConf() {
        if ($conf.log) {
            console.log('Setting $self state from $conf state.');
        }

        // The handlers are set on instantiation so they don't need
        // to be checked every time the event fires.
        if ($conf.hasOwnProperty('pos')) {
            $self.handler = checkScrollPosition;
            setSelfBiPosition($conf.pos);
        }
        else {
            $self.handler = checkScrollDistance;
            setSelfBiDirection($conf.dir);
            // The scroll vector will be checked against this before
            // firing. A vector is a contiguous run. A change in
            // direction will reset the vector.
            $self.last_f = 0;
        }

        if ($conf.elem == window) {
            $self.dist_x = 'scrollX';
            $self.dist_y = 'scrollY';
        }
        else {
            $self.dist_x = 'scrollLeft';
            $self.dist_y = 'scrollTop';
        }
    }



    function setSelfBiDirection(dir) {
        if ($conf.log) {
            console.log('Checking bidirectionality');
        }

        if (dir == null) {
            $self.bi_dir = true;
            $self.checkDist = didScrollEnough;
        }
        else {
            $self.bi_dir = ((dir == 'x') || (dir == 'y'))
                ? true
                : false;
            $self.checkDist = didScrollEnoughInDirection;
        }
    }



    function setSelfBiPosition(pos) {
        if ($conf.log) {
            console.log('Checking bipositionality');
        }

        // This sets the axis to check in the `pos` object.
        $self.pos_check = ((pos == 'y') || (pos == 'top') || (pos == 'bottom'))
            ? 'y'
            : 'x';

        if ((pos == 'top') || (pos == 'left')) {
            $self.bi_pos = false;
            $self.checkEdge = isWithinNearRange;
            $self.pos_edge = 0;  // The $conf.dist is checked instead.
        }
        else if ((pos == 'bottom') || (pos == 'right')) {
            $self.bi_pos = false;
            $self.checkEdge = isWithinFarRange;
            $self.pos_edge = getFarEdge($self.pos_check);
        }
        else {
            $self.bi_pos = true;
            $self.checkEdge = isWithinEitherRange;
            $self.pos_edge = getFarEdge($self.pos_check);
        }
    }



    function checkScrollPosition(evt) {
        if ($conf.log) {
            console.log("Checking scroll position.");
        }

        var curr = getCurrentPosition(),
            diff = getDeltas(curr),
            new_pos_check = $self.checkEdge(curr[$self.pos_check]),
            old_pos_check = $self.checkEdge($pos[$self.pos_check].last),
            func = null;

        // If the new position is within range and the old one wasn't.
        if ((new_pos_check) && (!old_pos_check)) {
            func = $conf.func_in;
        }
        // If the new position isn't within range and the old one was.
        else if ((!new_pos_check) && (old_pos_check)) {
            func = $conf.func_out;
        }

        var exec_pos = (func) ? curr[$self.pos_check] : null;

        scrollCheckWrapup(curr, exec_pos, func);
    }



    function checkScrollDistance(evt) {
        if ($conf.log) {
            console.log("Checking scroll distance.");
        }

        var curr = getCurrentPosition(),
            diff = getDeltas(curr),
            exec_pos = null,
            pos = null,
            dir = null;

        // Prefer the Y difference.
        if (Math.abs(diff.x.dist) < Math.abs(diff.y.dist)) {
            pos = curr.y;
            dir = diff.y.dir;
        }
        else {
            pos = curr.x;
            dir = diff.x.dir;
        }

        if ($self.checkDist(Math.abs($self.last_f - pos), dir)) {
            $self.last_f = pos;
            exec_pos = pos;
        }

        scrollCheckWrapup(curr, exec_pos, $conf.func);
    }



    /*
     * The `func` parameter must be a function or this will fail.
     */
    function scrollCheckWrapup(curr, exec_pos, func) {
        if ($conf.log) {
            console.log('Wrapping up scroll check.');
        }

        if (isInt(exec_pos)) {
            func({
                x: {
                    pos: curr.x,
                    vect: $pos.x.vect
                },
                y: {
                    pos: curr.y,
                    vect: $pos.y.vect
                }
            });
        }

        $pos.x.last = curr.x,
        $pos.y.last = curr.y;
    }



    function getCurrentPosition() {
        if ($conf.log) {
            console.log('Getting current position.');
        }

        return {
            x: $conf.elem[$self.dist_x],
            y: $conf.elem[$self.dist_y]
        }
    }


    /*
     * For bi-directional instances, this will set the vector's
     * direction as the axis name rather than the direction's name.
     * If the parameter results in no difference from the previous
     * state, then the returned `dist`s will be `0` and the `dir`s
     * will be `null`.
     */
    function getDeltas(curr) {
        if ($conf.log) {
            console.log('Getting deltas and setting x and y vectors.');
        }

        var x_dist = (curr.x - $pos.x.last),
            y_dist = (curr.y - $pos.y.last),
            x_dir = null,
            y_dir = null;

        if (x_dist < 0) {
            x_dir = ($self.bi_dir) ? 'x' : 'left';
            $pos.x.vect = ($pos.x.vect < 0) ? ($pos.x.vect + x_dist) : x_dist;
        }
        else if (0 < x_dist) {
            x_dir = ($self.bi_dir) ? 'x' : 'right';
            $pos.x.vect = (0 < $pos.x.vect) ? ($pos.x.vect + x_dist) : x_dist;
        }

        if (y_dist < 0) {
            y_dir = ($self.bi_dir) ? 'y' : 'up';
            $pos.y.vect = ($pos.y.vect < 0) ? ($pos.y.vect + y_dist) : y_dist;
        }
        else if (0 < y_dist) {
            y_dir = ($self.bi_dir) ? 'y' : 'down';
            $pos.y.vect = (0 < $pos.y.vect) ? ($pos.y.vect + y_dist) : y_dist;
        }

        return {
            x: {dist: x_dist, dir: x_dir},
            y: {dist: y_dist, dir: y_dir}
        }
    }



    function isWithinNearRange(pos) {
        if (pos < $conf.dist) {
            return true;
        }
        else {
            return false;
        }
    }



    function isWithinFarRange(pos) {
        if (($self.pos_edge - $conf.dist) <= pos) {
            return true;
        }
        else {
            return false;
        }
    }



    function isWithinEitherRange(pos) {
        if ((isWithinNearRange(pos)) || (isWithinFarRange(pos))) {
            return true;
        }
        else {
            return false;
        }
    }



    function didScrollEnoughInDirection(dist, dir) {
        if ($conf.log) {
            console.log('Checking if scroll distance ('+$conf.dist+' vs '+dist+') in the right direction ('+$conf.dir+' vs '+dir+') was enough.');
        }

        if (($conf.dir == dir) && ($conf.dist < dist)) {
            return true;
        }
        else {
            return false;
        }
    }



    function didScrollEnough(dist, dir) {
        if ($conf.log) {
            console.log('Checking if scroll distance was enough.');
        }

        if ($conf.dist < dist) {
            return true;
        }
        else {
            return false;
        }
    }



    /*
     * When scrolling, the greatest possible distance from the
     * origin you can reach is:
     *   (element [height|width]) - (viewport [height|width])
     * So when checking agaist the far edge, it's that number that's
     * being checked. So for
     *   elem H: 1000, viewport H: 100, dist: 50
     * the value that the position will compare to will be 850.
     *
     * The parameter to this needs to be `x` or `y`.
     *
     * The `inner[Height|Width]` properties are not supported below
     * IE9. And `clientHeight` is for IE.
     */
    function getFarEdge(v) {
        var prop = (v == 'x') ? 'Width' : 'Height',
            elem = ($conf.elem == window) ? document.body : $conf.elem,
            elem_v = elem['scroll'+prop] || elem['client'+prop],
            view_v = ($conf.elem == window)
            ? window['inner'+prop]
            : elem['client'+prop];
        
        // console.log('prop:'+prop);
        // console.log('elem:');
        // console.log(elem);
        // console.log(elem_v);
        // console.log(view_v);
        // console.log(elem_v - view_v);

        return (elem_v - view_v);
    }



    /*
     * Rather than just modifying the first parameter in-place and
     * returning it, this creates a new object, fills it first with
     * the properties of the first parameter and, second, with the
     * properties of the second. So the assignments will not change
     * any state variables if one of those is one of the parameters.
     */
    function mergeObjects(obj1, obj2) {
        if ($conf.log) {
            console.log('Merging this object:');
            console.log(obj1);
            console.log('with this one:');
            console.log(obj2);
        }

        var merged = { };

        for (var key in obj1) {
            if (obj1.hasOwnProperty(key)) {
                merged[key] = obj1[key];
            }
        }

        for (var key in obj2) {
            if (obj2.hasOwnProperty(key)) {
                if ((merged[key]) &&
                    (merged[key].constructor == Object) &&
                    (obj2[key].constructor == Object)) {
                    merged[key] = mergeObjects(merged[key], obj2[key]);
                }
                else {
                    merged[key] = obj2[key];
                }
            }
        }

        return merged;
    }



    // Copied and modified this from:
    // http://www.inventpartners.com/javascript_is_int
    function isInt(n) {
        if ($conf.log) {
            console.log('Checking if '+n+' is an integer.');
        }

        if ((parseInt(n) == parseFloat(n)) && (!isNaN(n))) {
            return true;
        }
        else {
            return false;
        }
    }



    /*
     * This is required because elements of `$self` result from the
     * values of the `$conf`. So if one of the config options change,
     * then `$self` needs to change accordingly.
     */
    function changeDirection(dir) {
        if ($conf.log) {
            console.log("Changing monitored direction.");
        }

        if (isDirectionValid(dir)) {
            setSelfBiDirection(dir);
            $conf.dir = dir;
        }
        else {
            console.log("Invalid direction '"+dir+"'. Skipping it.");
        }
    }



    /*
     * Similar to the situation with `changeDirection`.
     */
    function changePosition(pos) {
        if ($conf.log) {
            console.log("Changing monitored position.");
        }

        if ((getValidPositions().indexOf(pos) != -1)) {
            setSelfBiPosition(pos);
            $conf.pos = pos;
        }
        else {
            console.log("Invalid position '"+pos+"'. Skipping it.");
        }
    }



    /*
     * For setting `$conf` properties.
     */
    function changeOrView(prop, val) {
        if (typeof val == 'undefined') {
            return $conf[prop];
        }

        else {
            if (typeof prop == 'function') {
                prop(val);
            }
            else {
                $conf[prop] = val;
            }

            return true;
        }
    }



    function addListener() {
        if ($conf.log) {
            console.log('Adding window scroll listener.');
        }

        $conf.elem.addEventListener('scroll', $self.handler);
    }



    function removeListener() {
        if ($conf.log) {
            console.log('Removing window scroll listener.');
        }

        $conf.elem.removeEventListener('scroll', $self.handler);
    }



    /*
     * All of the instance's public properties will be functions.
     * The values given in the initialization parameter can be
     * viewed on those same keys, and set by passing a parameter.
     * In addition to those, `x` and `y` are given as read-only
     * access to the `$pos.[x|y]` state variables, and `start` and
     * `stop` are given for in case monitoring needs to be paused.
     */
    function setPublicProperties() {
        if ($conf.log) {
            console.log('Setting public properties.');
        }

        var public = {
            dist: (function (n) {return changeOrView('dist', n);}),
            elem: (function (n) {return changeOrView('elem', n);}),
            log: (function (n) {return changeOrView('log', n);}),
            x: (function () {return $pos.x;}),
            y: (function () {return $pos.y;}),
            start: addListener,
            stop: removeListener
        };

        if ('pos' in $conf) {
            public.pos = (function (n) {return changeOrView(changePosition, n);});
            public.func_in = (function (n) {return changeOrView('func_in', n);});
            public.func_out = (function (n) {return changeOrView('func_out', n);});
        }
        else {
            public.dir = (function (n) {return changeOrView(changeDirection, n);});
            public.func = (function (n) {return changeOrView('func', n);});
        }

        return public;
    }




    //////////////////////////////




    // This needs to stay down here.
    return init(config);
}
