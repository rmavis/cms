/*
 * ALERT
 *
 * This is a library for creating good-looking notifications and
 * alerts. An alert and a notification are nearly identical, so the
 * motivation behind this library was to enable easy management of
 * both.
 *
 * In this documenation, an "alert" will have one or more buttons,
 * and a "notification" will have zero. And "alert" will be used as
 * the generic term since it's shorter.
 *
 *
 * USAGE
 *
 * This call:
 * Alert.new("Howdy, neighbor.");
 *
 * will create HTML that looks something like this:
 * <div class="alert-scr alert-fade" killable="y" timestamp="alert-1446145337248">
 *   <div class="alert-win" killable="y">
 *     <div class="alert-msg" killable="y">Howdy, neighbor.</div>
 *   </div>
 * </div>
 *
 * and append that element to the element ID'd `notifications-wrap`.
 *
 * This call:
 * Alert.new(
 *   {
 *     message: "WHAT HATH BOG BROUGHT",
 *     opts: [
 *       {txt: 'nothing much', val: 'foo', esc: true},
 *       {txt: 'something cool', val: 'bar'},
 *       {txt: 'something lame', val: 'buz'},
 *       {txt: 'something decent', val: 'wat'}
 *     ]
 *   },
 *   {
 *     screen: {toggle_class: 'screen-whoopie'},
 *     message: {tag: 'h1', css_class: 'heads-up-message'},
 *     button: {css_class: 'rad-alert-buttons'},
 *     delay: {dismiss: 0},
 *     callback: Admin.howdy
 *   }
 * );
 *
 * will create something like this:
 * <div class="alert-scr alert-fade" killable="y" timestamp="alert-1446145734142">
 *   <div class="alert-win">
 *     <h1 class="heads-up-message">WHAT HATH BOG BROUGHT</h1>
 *     <div class="alert-btns-wrap">
 *       <div class="rad-alert-buttons" style="width:25%" value="0" killable="y">nothing much</div>
 *       <div class="rad-alert-buttons" style="width:25%" value="1" killable="y">something cool</div>
 *       <div class="rad-alert-buttons" style="width:25%" value="2" killable="y">something lame</div>
 *       <div class="rad-alert-buttons" style="width:25%" value="3" killable="y">something decent</div>
 *     </div>
 *   </div>
 * </div>
 *
 * and append it to the same element as before, since no new target
 * was ID'd. When one of the buttons are clicked, or when the user
 * hits the escape key, the callback function `Admin.howdy` will be
 * called, and passed either the `val` corresponding to the button
 * or the `val` of the `opt` with `esc: true`, so in this case
 * `foo`. If no `opt` was designated the `esc` value, then the
 * callback would be passed the `default_esc` value.
 *
 * There are many configuration options. The defaults are specified
 * in the `getDefaultConfig` function. Each option is explained in
 * there.
 *
 * Since this library is intended to be used for both alerts and
 * notifications, many of both can be created, and every one can
 * have its own settings. The user experience of each will depend on
 * your CSS.
 *
 *
 * DEPENDENCIES
 * - Utils.js for utility functions.
 *
 *
 * DETAILS
 *
 * Definitions of terms:
 * - The "message" element will contain the content of the alert.
 *   It can be a string or an element.
 * - The "buttons" element contains at least one "button" element
 *   that the user can click. You can control the number of buttons
 *   and the values associated with each via the `opts` array in the
 *   parameter. You can pass the boolean `true` instead of an array
 *   to use the default button. If no `opts` are passed, there will
 *   be no buttons.
 * - The "window" is the element that contains the alert's message
 *   and its button(s), if there are any.
 * - The "screen" element will contain the "window".
 *
 * Those terms are used in the configuration object.
 *
 * There are four public methods.
 *
 * Use the `new` method to create a new alert. It accepts up to two
 * parameters. To create a notification, the first should be a
 * string. To create an alert, the first should be an object with up
 * to three keys:
 * - message, being the body of the alert. This is required.
 * - callback, being the function to call when dismissing this
 *   alert. This is optional.
 * - opts, being either the boolean `true` or an array of objects.
 *   The buttons will be built from those objects, and each must
 *   contain two keys: `txt`, being the text of the button, and
 *   `val`, being the value associated with the button, which will
 *   be passed to the callback if the user clicks the button. One of
 *   these can also have an `esc: true`. If one does, then that
 *   `val` will be passed to the callback when the user either
 *   clicks the "screen" or hits the escape key.
 *
 * When an alert is created, event listeners are added to the
 * relevant elements. If there are `opts`, then each button will be
 * clickable. If not, then the message will be. And in both cases,
 * the "screen" will be clickable, and the window will listen for
 * keypresses. It will only react to the escape key, which will
 * dismiss the most recent alert.
 *
 * `new` returns an object containing five keys:
 * - id, being the identifying attribute for the topmost element
 * - elem, being the alert element
 * - opts, being an object containing three keys:
 *   - elem, being the element containing the buttons, if there are
 *     any
 *   - vals, being the values corresponding to each button
 *   - esc, being the escape value
 * - callback, being the callback function
 * - conf, being the alert's configuration options
 *
 * You can pass that object to the public `kill` method to kill the
 * alert.
 *
 * You can change the session's configuration options by passing an
 * object with any subset of the structure of the default config
 * object to `setConf`. And you can revert to the defaults by
 * calling `resetConf`.
 *
 */


var Alert = (function () {

    function getDefaultConfig() {
        return {
            // The `target` is the element that the alert will get
            // added into.
            target: {
                // You can specify an element ID.
                id: false,  // 'notifications-wrap',

                // Or you can specify an element. If both are not
                // false, then the ID will take precedence. If
                // both are false, then the target will be
                // `document.body`.
                elem: false
            },

            // The `screen` is the outermost wrapper for the alert.
            // It is useful for, eg, covering the `target` with an
            // overlay, with the alert's `window` in the center.
            screen: {
                // To build the screen, we need a tagname...
                tag: 'div',

                // and a CSS class...
                css_class: 'alert-scr',

                // and, if you want to trigger a transition, this
                // class will be added and removed at the right
                // times.
                toggle_class: 'alert-fade'
            },

            // The `window` contains the `message` and the `buttons`,
            // if any buttons exist.
            window: {
                // It needs a tagname...
                tag: 'div',

                // and a CSS class.
                css_class: 'alert-win'
            },

            // The `message` contains the body content of the alert.
            message: {
                // It needs a tagname...
                tag: 'div',

                // and a CSS class.
                css_class: 'alert-msg'
            },

            // The `buttons` element contains the buttons.
            buttons: {
                // It needs a tagname...
                tag: 'div',

                // and a CSS class.
                css_class: 'alert-btns-wrap'
            },

            // Each `button`...
            button: {
                // needs a tagname...
                tag: 'div',

                // and a CSS class.
                css_class: 'alert-btn'
            },

            // These are the settings for the default button, used
            // when `opts: true` or when the alert is a notification
            // and `use_default` is true.
            values: {
                // This indicates whether you want to use these
                // values with notifications.
                use_default: false,

                // This will be the content of the button.
                default_txt: 'okay',

                // This will be value associated with that button.
                default_val: true,

                // This will be the value if the user hits escape.
                default_esc: false
            },

            // You can delay the alert's dismissal.
            delay: {
                // This is the delay between click and dismiss.
                dismiss: 0,

                // This is the delay for autokilling, mostly useful
                // for ephemeral notifications. If this is less than
                // 1, the alert will not self destruct.
                autokill: 0
            },

            // If you want to use the same callback for every alert,
            // name that function here.
            callback: false,

            // If this is true, then Alert.js will write messages to
            // your console.
            log: false
        }
    }


    var conf = getDefaultConfig(),

        // This keeps the alert objects. The keys are the timestamp
        // IDs generated for each.
        alerts_keep = { },

        // This specifies the element's attribute read and used to
        // identify the alert in the keep.
        kills = {
            stamp_id: 'timestamp',
            attr: 'killable'
        };



    function makeNewConf(conf_obj) {
        if (conf.log) {
            console.log("Pulling new config settings from:");
            console.log(conf_obj);
        }

        var new_conf = Utils.sieve(conf, conf_obj);

        if (conf.log) {
            console.log("New config settings:");
            console.log(new_conf);
        }

        return new_conf;
    }



    function resetConf() {
        if (conf.log) {
            console.log("Resetting config to default.");
        }

        conf = getDefaultConfig();
        return conf;
    }



    function getTarget(entry) {
        var check = (typeof entry == 'object') ? entry.conf : conf;

        if (check.target.id) {
            if (check.log) {
                console.log("Getting alert element target by ID ("+check.target.id+").");
            }

            return document.getElementById(check.target.id);
        }

        else if (check.target.elem) {
            if (check.log) {
                console.log("Getting alert element target.");
            }

            return check.target.elem;
        }

        else {
            if (check.log) {
                console.log("No target ID or element specified. Using the document body.");
            }

            return document.body;
        }
    }



    function getTimestamp() {
        var stamp = (new Date().getTime());

        if (conf.log) {
            console.log("Getting timestamp: " + stamp);
        }

        return stamp;
    }



    function parseParamObj(arg_obj) {
        if (conf.log) {
            console.log("Parsing alert parameter object.");
        }

        var ret = {
            opts: null,
            message: null,
            callback: null
        };

        if ('message' in arg_obj) {
            if (conf.log) {
                console.log("Got the message:");
                console.log(arg_obj.message);
            }

            ret.message = arg_obj.message;
        }

        else {
            console.log("Error: no message to alert. Quietly dying.");
            return null;
        }

        if ('callback' in arg_obj) {
            if (conf.log) {
                console.log("Got callback function.");
            }

            ret.callback = arg_obj.callback;
        }

        else if (conf.callback) {
            if (conf.log) {
                console.log("Using default callback function.");
            }

            ret.callback = conf.callback;
        }

        else {
            if (conf.log) {
                console.log("This alert will have no callback.");
            }
        }

        if (arg_obj.opts) {
            if (conf.log) {
                console.log("Got the options.");
            }

            ret.opts = arg_obj.opts;
        }

        else if (conf.values.use_default) {
            if (conf.log) {
                console.log("No options given, but using default options.");
            }

            ret.opts = conf.values.use_default;
        }

        else {
            if (conf.log) {
                console.log("No options given.");
            }
        }

        return ret;
    }



    function displayNewAlertWithTempConfig(alert_obj, conf_obj) {
        if (conf.log) {
            console.log("Building new alert with temporary configuration settings.");
        }

        var bk_conf = JSON.parse(JSON.stringify(conf));
        conf = makeNewConf(conf_obj);

        var elem = displayNewAlert(alert_obj);
        conf = makeNewConf(bk_conf);

        return elem;
    }



    function displayNewAlert(alert_obj) {
        if (conf.log) {
            console.log("Building new alert.");
        }

        var alert = null;

        if (typeof alert_obj == 'string') {
            if (conf.values.use_default) {
                alert = buildAlert({
                    message: alert_obj,
                    opts: true
                });
            }

            else {
                alert = buildAlert({
                    message: alert_obj,
                    opts: false
                });
            }
        }

        else if (typeof alert_obj == 'object') {
            alert = buildAlert(parseParamObj(alert_obj));
        }

        else {
            console.log("Error: invalid alert parameter. Quietly dying.");
        }

        if (alert) {
            addAlertToKeep(alert);
            addAlertToTarget(alert);
        }

        return alert;
    }



    // This will set the `killable` attribute where appropriate.
    // Alerts that have no options or screen can be killed by
    // clicking the message/window. But those that do can only be
    // killed by clicking the buttons or the screen.
    function buildAlert(content) {
        if (conf.log) {
            console.log("Building alert elements with content:");
            console.log(content);
        }

        var alert = {
            id: 'alert-'+(new Date().getTime()),
            callback: content.callback,
            elem: null,
            opts: null
        };

        var message_elem = Utils.makeElement(
            conf.message.tag,
            {class: conf.message.css_class},
            content.message
        );

        alert.elem = Utils.makeElement(
            conf.window.tag,
            {class: conf.window.css_class},
            message_elem
        );

        // If there are opts, each will get its own event listener.
        if (content.opts) {
            alert.opts = buildValsFromOpts(content.opts);
            alert.elem.appendChild(alert.opts.elem);
        }

        // But if not, then the alert element itself needs one.
        else {
            alert.opts = {esc: conf.values.default_esc, vals: null, elem: null};
            alert.elem.addEventListener('click', handleAlertEvent, false);
            message_elem.setAttribute(kills.attr, kills.attr);
            alert.elem.setAttribute(kills.attr, kills.attr);
        }

        if (conf.screen) {
            alert.elem = Utils.makeElement(
                conf.screen.tag,
                {class: conf.screen.css_class},
                alert.elem
            );

            alert.elem.addEventListener('click', handleAlertEvent, false);
            alert.elem.setAttribute(kills.attr, kills.attr);
        }

        alert.elem.setAttribute(kills.stamp_id, alert.id);

        return alert;
    }



    // The parameter should be an array of objects or `true`.
    function buildValsFromOpts(opts) {
        if (opts === true) {
            opts = [{
                txt: conf.values.default_txt,
                val: conf.values.default_val
            }];
        }

        var btn_width = (100 / opts.length) + '%',
            buttons_bar = Utils.makeElement(
                conf.buttons.tag,
                {class: conf.buttons.css_class}
            ),
            esc_val = conf.values.default_esc,
            vals = [ ];

        for (var o = 0, m = opts.length; o < m; o++) {
            var button = Utils.makeElement(
                conf.button.tag,
                {
                    class: conf.button.css_class,
                    style: 'width:'+btn_width,
                    value: ''+o,
                },
                opts[o].txt
            );

            button.addEventListener('click', handleAlertEvent, false);
            button.setAttribute(kills.attr, kills.attr);
            buttons_bar.appendChild(button);
            vals.push(opts[o].val);

            if (opts[o].esc) {
                esc_val = opts[o].val;
            }
        }

        return {
            elem: buttons_bar,
            esc: esc_val,
            vals: vals
        }
    }



    function addAlertToKeep(alert_obj) {
        // Add the alert's conf in case of customizations. So the
        // procedures started by the event listeners will use the
        // alert's conf, not the global conf.
        alert_obj.conf = JSON.parse(JSON.stringify(conf));
        alerts_keep[alert_obj.id] = alert_obj;

        if (conf.log) {
            console.log("Adding alert to keep with key: " + alert_obj.id);
            console.log("Entries in the keep: " + Object.keys(alerts_keep).length);
        }
    }



    function addAlertToTarget(alert) {
        if (conf.log) {
            console.log("Adding alert to target, listeners to target and window.");
        }

        var target = getTarget();
        target.appendChild(alert.elem);

        window.addEventListener('keydown', handleAlertEvent, false);

        if (conf.screen.toggle_class) {
            window.setTimeout(
                (function () {
                    if (conf.log) {console.log("Applying alert screen's toggle class.");}
                    alert.elem.className += ' ' + conf.screen.toggle_class;
                }),
                10
            );
        }

        if (conf.delay.autokill > 0) {
            setAlertAutokill(alert);
        }

        return target;
    }



    function setAlertAutokill(alert) {
        if (conf.log) {
            console.log("Setting alert autokill delay: " + conf.delay.autokill);
        }

        setTimeout(
            // The values of `conf` in this closure are those in the
            // primary `conf`, not the temporary one potentially set
            // by the custom values passed with the new alert. That
            // is mostly okay, since the alert's custom conf will be
            // used by `removeAlertByAlertObject`, and `getTarget`
            // will pull the correct target when given the `alert`.
            (function () {
                var target = getTarget(alert),
                    nodes = target.childNodes;

                if (nodes.length > 0) {
                    var kill = false;
                    for (var o = 0, m = nodes.length; o < m; o++) {
                        if (nodes[o] == alert.elem) {
                            kill = true;
                        }
                    }

                    if (kill) {
                        if (conf.log) {
                            console.log("Autokilling alert.");
                        }

                        removeAlertByAlertObject(alert);
                    }

                    else {
                        if (conf.log) {
                            console.log("Not autokilling alert: it's not in the target.");
                        }
                    }
                }

                else {
                    if (conf.log) {
                        console.log("Alert autokill fail: it has already been removed.");
                    }
                }
            }),
            conf.delay.autokill
        );
    }



    function handleAlertEvent(evt) {
        if (!evt) {var evt = window.event;}
        evt.stopPropagation();

        var event_type = evt.type,
            dismiss = false,
            is_esc = false,
            caller = null,
            entry = null;

        if (conf.log) {
            console.log("Handling alert event: " + event_type);
        }

        if (event_type == 'click') {
            caller = getCallerFromEvent(evt);

            if (caller) {
                dismiss = (caller.hasAttribute(kills.attr)) ? true : false;

                if (dismiss) {
                    entry = pullKeepEntryFromCaller(caller);

                    if (entry) {
                        is_esc = (caller.className.split(' ')
                                  .indexOf(entry.conf.screen.css_class) > -1)
                            ? true
                            : false;
                    }
                }
            }

            else {
                console.log("Couldn't get caller from click event.");
            }
        }

        else if (event_type == 'keydown') {
            if (evt.keyCode == 27) {  // The esc key.
                if (conf.log) {
                    console.log("User hit the escape key.");
                }

                entry = pullLastKeepEntry();
                dismiss = true;
                is_esc = true;
            }
        }

        else {
            console.log("Unhandled event type: " + event_type);
        }

        if ((dismiss) && (entry)) {
            removeAlertByEntry(entry, is_esc);
        }

        else {
            if (conf.log) {
                console.log("Not dismissing the alert.");
            }
        }
    }



    function getCallerFromEvent(event) {
        caller = (event.target) ? event.target : event.scrElement;

        while (!caller.className) {
            caller = caller.parentNode;
        }

        if (conf.log) {
            console.log("Got caller from event:");
            console.log(caller);
        }

        if (caller == document.body) {return false;}
        else {return caller;}
    }



    function pullKeepEntryFromCaller(caller) {
        var entry = null,
            found = false,
            parent = caller;

        while ((!found) && (parent !== document.body)) {
            if (attr = parent.getAttribute(kills.stamp_id)) {
                entry = alerts_keep[attr];
                delete alerts_keep[attr];
                found = true;
            }
            else {
                parent = parent.parentNode;
            }
        }

        if (conf.log) {
            console.log("Getting keep entry from caller.");
            console.log("Entry:");
            console.log(entry);
            console.log("Remaining entries in the keep: " + Object.keys(alerts_keep).length);
        }

        return entry;
    }



    function pullLastKeepEntry() {
        if (conf.log) {
            console.log("Popping last alert entry off the stack.");
        }

        var keys = Object.keys(alerts_keep),
            entry = null;

        if (keys.length > 0) {
            var key = keys.shift();
            entry = alerts_keep[key];
            delete alerts_keep[key];

            if (conf.log) {
                console.log("Remaining entries in the keep: " + Object.keys(alerts_keep).length);
            }
        }

        else {
            if (conf.log) {
                console.log("No entries in the keep.");
            }
        }

        return entry;
    }



    function getButtonValue(button, entry) {
        var val = null;

        if (entry.opts.vals) {
            val = entry.opts.vals[parseInt(button.getAttribute('value'))];

            if (conf.log) {
                console.log("Got button value: " + val);
            }
        }

        else {
            val = entry.opts.esc;

            if (conf.log) {
                console.log("This alert has no value options. Using escape value.");
            }
        }

        return val;
    }



    function removeAlertByAlertObject(alert_obj) {
        if (conf.log) {
            console.log("Dismissing the alert by its returned object:");
            console.log(alert_obj);
        }

        var is_esc = (alert_obj.elem.className == conf.screen.css_class) ? true : false;

        var entry = alerts_keep[alert_obj.id];
        delete alerts_keep[alert_obj.id];

        removeAlertByEntry(entry, is_esc);
    }



    function removeAlertByEntry(entry, is_esc) {
        if (entry.conf.log) {
            console.log("Dismissing the alert by its entry in the keep.");
        }

        removeAlert(entry);

        if (entry.callback) {
            if (entry.conf.log) {
                console.log("Firing callback.");
            }

            if (is_esc) {entry.callback(entry.opts.esc);}
            else {entry.callback(getButtonValue(caller, entry));}
        }
    }



    function removeAlert(entry) {
        if (entry.conf.log) {
            console.log("Removing alert element.");
        }

        // This triggers the CSS transition.
        if (entry.conf.screen.toggle_class) {
            window.setTimeout(
                (function () {
                    if (entry.conf.log) {console.log("Removing alert screen's toggle class.");}
                    entry.elem.className = entry.elem.className.replace(entry.conf.screen.toggle_class, '');
                }),
                1
            );
        }

        window.setTimeout(
            (function () {
                if (entry.conf.log) {console.log("Remove alert element from its parent after "+entry.conf.delay.dismiss+" millisecs.");}
                entry.elem.parentNode.removeChild(entry.elem);
            }),
            entry.conf.delay.dismiss
        );

        // The other listeners don't need to be removed because the
        // elements no longer exist.
        if (Object.keys(alerts_keep).length == 0) {
            if (conf.log) {
                console.log("There are no more active alerts. Removing window keydown event.");
            }

            window.removeEventListener('keydown', handleAlertEvent);
        }
    }





    /*
     * Public methods.
     */

    return {
        new: function(alert_obj, conf_obj) {
            if (typeof conf_obj == 'object') {
                return displayNewAlertWithTempConfig(alert_obj, conf_obj);
            }
            else {
                return displayNewAlert(alert_obj);
            }
        },

        kill: function(alert_obj) {
            return removeAlertByAlertObject(alert_obj);
        },

        setConf: function(conf_obj) {
            conf = makeNewConf(conf_obj);
            return conf;
        },

        resetConf: function() {
            return resetConf();
        }

    };
})();
