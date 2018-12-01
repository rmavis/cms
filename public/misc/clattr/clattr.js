/*
 * CLATTR
 *
 * This is a module for managing element attributes.
 *
 *
 * USAGE
 *
 * Toggle the class of a hamburger menu:
 * Clattr.toggle(document.getElementById('burger-button'),
 *               'toggle-on');
 *
 * Highlight required form elements:
 * Clattr.add(formElem.getElementsByClassName('required-inputs'),
 *            'required-missing');
 *
 * Set a image's alt text:
 * Clattr.set(document.getElementById('img-id'),
 *            'This image is very good.',
 *            'alt');
 * 
 *
 * DEPENDENCIES
 *
 * None.
 *
 *
 * DETAILS
 *
 * The `has`, `set`, `add`, `remove`, and `toggle` methods all take
 * the same three parameters: an element or list of elements, an
 * attribute value or list of values, and an attribute name or list
 * of names. The `replace` method is similar except it accepts two
 * lists of attribute values -- it will remove the first and add the
 * second -- before the attribute name, for a total of four possible
 * parameters.
 *
 * For each method, the first two parameters (three for `replace`)
 * are requried. The third (fourth for `replace`) is optional. If it
 * not given, then the values will be applied to the currently-set
 * attribute.
 *
 * By default, Clattr operates on the `class` attribute. You can
 * change the attribute that Clattr operates on with the `setAttr`
 * method. Give it any string or array of strings. You can change
 * back to the default "class" attribute with the `resetAttr`
 * method, which takes no parameters.
 *
 * So calling
 * Clattr.add(document.getElementById('bam'), 'boom')
 *
 * will add "boom" to the class list of the element ID'd "bam", and
 * Clattr.add(document.getElementsByTagName("p"), ['boom', 'room'])
 *
 * will add "boom" and "room" to the class list of each `p` element
 * in the document. If the element(s) lack a "class" attribute, then
 * one will be added.
 *
 * Aside from the boolean returned by the `has` method, each return
 * value indicates whether the named action occurred on the given
 * element(s) for each of the given values. So `add` called with a
 * list of elements and a list of values will return true only if
 * each value was added to each element. The method will not add a
 * duplicate class name to the element's list, so if a duplicate
 * occurs, then `add` will return false, though the method will
 * effectively ensure that each of the given class names are on each
 * of the given elements.
 *
 * The exception to this MO is `toggle`, which will run through the
 * given class names and remove those it currently has and add those
 * it doesn't. If all of the given class name(s) are added to all of
 * the given elements, then it will return true.
 *
 */

var Clattr = (function () {

    var elem_attr_array = null,
        attr_name_default = ["class"];
    var attr_name_active = attr_name_default;



    function exec(funcs, elems, attr_list, attr_names) {
        // Check the parameters.

        if (!elems || typeof attr_list == 'undefined') {
            console.log("Clattr fail: missing elems ("+typeof elems+") or attribute list ("+typeof attr_list+").");
            return false;
        }

        if (typeof attr_list == 'string') {
            attr_list = [attr_list];
        }

        /* The `elems` parameter can be a variety of things -- an element, an
         * array, an HTMLCollection -- that are all `typeof` object, and that
         * all can have a `length` greater than 1 (even an element pulled by
         * `getElementById` will have a length of 2). It seems that the easiest
         * distinction between an object that is an element and an object that
         * is a collection of elements is the `tagName`. A collection will not
         * have a `tagName`. */
        var func = (elems.tagName) ? funcs.single : funcs.plural;

        var attr_name_swap = null;

        if (typeof attr_names != 'undefined') {
            if (typeof attr_names == 'string') {
                attr_name_swap = attr_name_active;
                attr_name_active = [attr_names];
            }
            else if (attr_names instanceof Array) {
                attr_name_swap = attr_name_active;
                attr_name_active = attr_names;
            }
        }


        // Operate on each attribute name.

        var trues = 0,
            names = attr_name_active.length;

        for (var o = 0; o < names; o++) {
            if (func(elems, attr_list, attr_name_active[o])) {
                trues += 1;
            }
            elem_attr_array = null;
        }


        // Wrap it up.

        if (attr_name_swap) {
            attr_name_active = attr_name_swap;
        }

        if (trues == names) {return true;}
        else {return false;}
    }



    function getAttrArray(elem, attr_name) {
        if (elem.hasAttribute(attr_name)) {
            elem_attr_array = elem.getAttribute(attr_name).split(" ");
            return elem_attr_array;
        }
        else {
            return [ ];
        }
    }



    function doesElemHaveAttr(elem, attr_list, attr_name) {
        var attr_arr = (elem_attr_array) ? elem_attr_array : getAttrArray(elem, attr_name);
        var n = attr_arr.length,
            has = false;

        if (n > 0) {
            has = true;
            var m = attr_list.length;

            outA:
            for (var o = 0; o < m; o++) {
                var ihas = false,
                    attx = attr_list[o];

                outB:
                for (var i = 0; i < n; i++) {
                    if (attr_arr[i] == attx) {
                        ihas = true;
                        break outB;
                    }
                }

                if (!ihas) {
                    has = false;
                    break outA;
                }
            }
        }

        return has;
    }



    function doesGroupHaveAttr(elem_list, attr_list, attr_name) {
        var have = true;

        out:
        for (var o = 0, n = elem_list.length; o < n; o++) {
            if (!doesElemHaveAttr(elem_list[o], attr_list, attr_name)) {
                have = false;
                break out;
            }
        }

        return have;
    }



    function setAttrOnElem(elem, attr_list, attr_name) {
        if (elem.setAttribute(attr_name, attr_list.join(" ").trim())) {
            return true;
        }
        else {
            return false;
        }
    }



    function addAttrToElem(elem, attr_list, attr_name) {
        var attr_arr = getAttrArray(elem, attr_name);
        var m = attr_arr.length,
            added = false;

        if (m == 0) {
            added = setAttrOnElem(elem, attr_list, attr_name);
        }

        else {
            var m = attr_list.length,
                adds = 0;

            for (var o = 0; o < m; o++) {
                var attx = attr_list[o];

                if (!doesElemHaveAttr(elem, [attx], attr_name)) {
                    attr_arr.push(attx);
                    adds += 1;
                }
            }

            setAttrOnElem(elem, attr_arr, attr_name);
            added = (adds == m) ? true : false;
        }

        return added;
    }



    function removeAttrFromElem(elem, attr_list, attr_name) {
        var attr_arr = getAttrArray(elem, attr_name);
        var m = attr_arr.length,
            removed = false;

        if (m > 0) {
            var n = attr_list.length,
                keeps = [ ],
                rms = 0;

            for (var o = 0; o < m; o++) {
                var attx = attr_arr[o],
                    keep = true;

                out:
                for (var i = 0; i < n; i++) {
                    if (attr_list[i] == attx) {
                        keep = false;
                        break out;
                    }
                }

                if (keep) {
                    keeps.push(attx);
                }
                else {
                    rms += 1;
                }
            }

            setAttrOnElem(elem, keeps, attr_name);
            removed = (rms == n) ? true : false;
        }

        return removed;
    }



    function toggleAttrOnElem(elem, attr_list, attr_name) {
        var is_on = false;

        if (!removeAttrFromElem(elem, attr_list, attr_name)) {
            is_on = addAttrToElem(elem, attr_list, attr_name);
        }

        return is_on;
    }



    function applyToGroup(func, elem_list, attr_list, attr_name) {
        var n = elem_list.length,
            ops = 0;

        for (var o = 0; o < n; o++) {
            if (func(elem_list[o], attr_list, attr_name)) {
                ops += 1;
            }
        }

        if (ops == n) {return true;}
        else {return false;}
    }



    function addAttrToGroup(elem_list, attr_list, attr_name) {
        return applyToGroup(addAttrToElem, elem_list, attr_list, attr_name);
    }



    function removeAttrFromGroup(elem_list, attr_list, attr_name) {
        return applyToGroup(removeAttrFromElem, elem_list, attr_list, attr_name);
    }



    function setAttrOnGroup(elem_list, attr_list, attr_name) {
        return applyToGroup(setAttrOnElem, elem_list, attr_list, attr_name);
    }



    function toggleAttrOnGroup(elem_list, attr_list, attr_name) {
        var m = attr_list.length,
            togs = 0;

        for (var o = 0; o < m; o++) {
            if (applyToGroup(toggleAttrOnElem, elem_list, [attr_list[o]], attr_name)) {
                togs += 1;
            }
        }

        if (togs == m) {return true;}
        else {return false;}
    }





    /*
     * Public methods.
     */

    return {

        has: function(elems, attr_vals, attr_names) {
            return exec({single: doesElemHaveAttr, plural: doesGroupHaveAttr},
                        elems, attr_vals, attr_names);
        },

        set: function(elems, attr_vals, attr_names) {
            return exec({single: setAttrOnElem, plural: setAttrOnGroup},
                        elems, attr_vals, attr_names);
        },

        add: function(elems, attr_vals, attr_names) {
            return exec({single: addAttrToElem, plural: addAttrToGroup},
                        elems, attr_vals, attr_names);
        },

        remove: function(elems, attr_vals, attr_names) {
            return exec({single: removeAttrFromElem, plural: removeAttrFromGroup},
                        elems, attr_vals, attr_names);
        },

        toggle: function(elems, attr_vals, attr_names) {
            return exec({single: toggleAttrOnElem, plural: toggleAttrOnGroup},
                        elems, attr_vals, attr_names);
        },

        replace: function(elems, attrs_o, attrs_i, attr_names) {
            var r = this.remove(elems, attrs_o, attr_names);
            var a = this.add(elems, attrs_i, attr_names);
            return (r && a);
        },

        setAttr: function(attr) {
            if (typeof attr == 'string') {
                attr_name_active = [attr];
            }
            else if ((typeof attr == 'object') && (attr instanceof Array)) {
                attr_name_active = attr;
            }
            else {
                attr_name_active = attr_name_default;
            }
        },

        resetAttr: function() {
            this.setAttr();
        }

    };
})();
