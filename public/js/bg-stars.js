var BgStars = (function() {


    function init(params) {
        var params = mergeObjs(defaultParams(), params),
            dims = getWindowDims(),
            stars = makeStars(params, dims);

        for (var o = 0, m = stars.length; o < m; o++) {
            params.target.appendChild(stars[o]);
        }

        return stars;
    }



    function defaultParams() {
        return {
            // The number of stars to make.
            number: getRandomIntInclusive(1, 100),
            // Must be a number or a two-item array.
            arms: [2, 10],
            // Must be a number or a two-item array.
            armHeight: [2, 10],  // vhs
            // Must be a number or a two-item array.
            armWidth: [10, 9000],  // vws
            // Must be a boolean.
            markCenter: true,  // radius is 2x? maximum arm width
            // Must be a document element.
            target: document.body,
            // Must be an object with keys that spell a color notation
            // and each subobject must contain: vals, unit, and int.
            colors: {
                h: {vals: [0, 360], unit: null, int: true},
                s: {vals: [0, 100], unit: '%', int: true},
                l: {vals: [0, 100], unit: '%', int: true},
                a: {vals: [0, 1], unit: null, int: false},
            }
        };
    }



    function mergeObjs(objA, objB) {
        var objC = { };

        for (key in objA) {
            objC[key] = (objB.hasOwnProperty(key))
                ? objB[key]
                : objA[key];
        }

        return objC;
    }



    // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random
    // Returns a random integer between min (included) and max (included)
    // Using Math.round() will give you a non-uniform distribution!
    function getRandomIntInclusive(min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }



    // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random
    // Returns a random number between min (inclusive) and max (exclusive)
    function getRandomArbitrary(min, max) {
        return Math.random() * (max - min) + min;
    }



    function getWindowDims() {
        var width = window.innerWidth
            || document.documentElement.clientWidth
            || document.body.clientWidth;

        var height = window.innerHeight
            || document.documentElement.clientHeight
            || document.body.clientHeight;

        return {
            height: height, width: width
        };
    }



    function makeStars(params, dims) {
        var stars = [ ];

        var quant = (typeof params.number == 'number')
            ? params.number
            : getRandomIntInclusive(params.number[0], params.number[1]);

        var arms = (typeof params.arms == 'number')
            ? params.arms
            : null;

        var armW = (typeof params.armWidth == 'number')
            ? params.armWidth
            : null;

        var armH = (typeof params.armHeight == 'number')
            ? params.armHeight
            : null;

        for (var o = 0, m = quant; o < m; o++) {
            var star = document.createElement('div'),
                posX = getRandomIntInclusive(0, dims.width),
                posY = getRandomIntInclusive(0, dims.height),
                num_arms = arms || getRandomIntInclusive(params.arms[0], params.arms[1]),
                turn = Math.floor(180 / num_arms),
                color = makeColor(params.colors),
                arm_elems = [ ],
                maxH = 0;

            star.style.position = 'absolute';
            star.style.left = posX + 'px';
            star.style.top = posY + 'px';

            for (var i = 0, n = num_arms; i < n; i++) {
                var arm = document.createElement('div'),
                    h = armH || getRandomIntInclusive(params.armHeight[0], params.armHeight[1]),
                    maxH = (h > maxH) ? h : maxH;

                arm.style.position = 'absolute';
                arm.style.left = '50%';
                arm.style.top = '50%';

                arm.style.height = h + 'px';

                arm.style.width = (armW)
                    ? armW + 'px'
                    : getRandomIntInclusive(params.armWidth[0], params.armWidth[1]) + 'px';

                // The rotation must come after the translation.
                arm.style.transform = 'translate(-50%, -50%) rotate('+(turn * i)+'deg)';

                arm.style.backgroundColor = color;

                arm_elems.push(arm);
            }

            var size = maxH * 2;

            for (var i = 0, n = arm_elems.length; i < n; i++) {
                if (parseInt(arm_elems[i].style.width) <= size) {
                    arm_elems[i].style.width = (size * 2) + 'px';
                }
                star.appendChild(arm_elems[i]);
            }

            if (params.markCenter) {
                star.style.height = size + 'px';
                star.style.width = size + 'px';
                star.style.borderRadius = size + 'px';
                star.style.backgroundColor = color;
                star.style.transform = 'translate(-50%, -50%)';
            }

            stars.push(star);
        }

        return stars;
    }



    function makeColor(conf) {
        var notation = '',
            vals = [ ];

        for (key in conf) {
            notation += key;

            var val;

            if (typeof conf[key].vals == 'number') {
                val = (conf[key].int)
                    ? getRandomIntInclusive(conf[key].vals, conf[key].vals)
                    : getRandomArbitrary(conf[key].vals, conf[key].vals);
            }
            else {
                val = (conf[key].int)
                    ? getRandomIntInclusive(conf[key].vals[0], conf[key].vals[1])
                    : getRandomArbitrary(conf[key].vals[0], conf[key].vals[1]);
            }

            if (conf[key].unit) {
                val += conf[key].unit;
            }

            vals.push(val);
        }

        return notation + '(' + vals.join(', ') + ')';
    }





    /*
     * Public.
     */
    return {
        init: init,
    }

})();
