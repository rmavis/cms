/*
 * WhalesharkSkin :: args -> HTMLElement
 * args = An object containing any of these key-value pairs:
 *   cols = (int|[int,int]) the number of columns
 *   line = (string|[[int,int]{3}]) the border color
 *   boxColor = (string|[[int,int]{3}]) the box background color
 *   dotColor = (string|[[int,int]{3}]) the dot color
 *   dotSize = (int|[int,int]) the size of the dot as a percentage
 *     of the box size
 * For each of these parameters, a value can either be given directly
 * (as a string or integer) or upper and lower bounds for randomization
 * can be given in arrays. For colors, values will be set in HSL.
 */
function Whalesharkskin(args) {

    // init :: args -> HTMLElement
    function init(args) {
        return makeSquares(getGridStyles(args));
    }

    // getGridStyles :: args -> conf
    // conf = An object containing key-value pairs for building the
    //   elements. It's similar to an `args` object but its values
    //   are functions, except for `cols`, `rows`, `size`. For the
    //   others, the functions all accept one argument and return
    //   a value appropriate for its purpose.
    function getGridStyles(args) {
        var width = Math.max(window.screen.width, window.outerWidth, document.body.offsetWidth);
        var height = Math.max(window.screen.height, window.outerHeight, document.body.offsetHeight);

        var cols = makeArgMaker(args.cols, makeNumberRandomizer, makeIdentity(20))();
        var size = Math.ceil(width / cols);
        var rows = Math.ceil(height / size);

        return {
            cols: cols,
            size: size,
            rows: rows,
            line: makeArgMaker(args.line, makeIdentity, makeIdentity('hsl(0, 0%, 50%)')),
            boxColor: makeArgMaker(args.boxColor, makeColorRandomizer, makeIdentity('hsl(0, 0%, 100%)')),
            dotColor: makeArgMaker(args.dotColor, makeColorRandomizer, makeIdentity('hsl(0, 0%, 0%)')),
            dotSize: makeArgMaker(args.dotSize, makePercentRandomizer, makeIdentity(50), makePercentIdentity),
        };
    }

    // makeSquares :: conf -> HTMLElement
    function makeSquares(conf) {
        var wrap = makeWrap(conf);
        for (var o = 0; o < conf.rows; o++) {
            var row = makeRow(conf);
            for (var i = 0; i < conf.cols; i++) {
                row.appendChild(makeSquare(conf));
            }
            wrap.appendChild(row);
        }
        return wrap;
    }

    // makeWrap :: conf -> HTMLElement
    function makeWrap(conf) {
        return makeElement(
            'div',
            {
                style: {
                    position: 'absolute',
                    top: '50%',
                    left: '50%',
                    transform: 'translate(-50%,-50%)',
                    margin: '0',
                    padding: '0',
                    width: (conf.size * conf.cols) + 'px',
                    height: (conf.size * conf.rows) + 'px',
                    fontSize: '0',
                },
            },
            null
        );
    }

    // makeRow :: conf -> HTMLElement
    function makeRow(conf) {
        return makeElement(
            'div',
            {
                style: {
                    display: 'block',
                    position: 'relative',
                    width: (conf.size * conf.cols) + 'px',
                    height: conf.size + 'px',
                    fontSize: 0,
                    whiteSpace: 'nowrap',
                },
            },
            null
        );
    }

    // makeSquare :: conf -> HTMLElement
    function makeSquare(conf) {
        return makeElement(
            'div',
            {
                style: {
                    display: 'inline-block',
                    position: 'relative',
                    width: conf.size + 'px',
                    height: conf.size + 'px',
                    backgroundColor: conf.boxColor(),
                    border: '1px solid ' + conf.line(),
                    overflow: 'visible',
                },
            },
            makeDot(conf)            
        );
    }

    // makeDot :: conf -> HTMLElement
    function makeDot(conf) {
        var dot_size = conf.dotSize(conf.size);
        return makeElement(
            'div',
            {
                style: {
                    display: 'block',
                    position: 'absolute',
                    top: '50%',
                    left: '50%',
                    transform: 'translate(-50%, -50%)',
                    height: 0,
                    width: 0,
                    border: (dot_size / 2) + 'px solid ' + conf.dotColor(),
                    borderRadius: (dot_size / 2) + 'px',
                    zIndex: 1,
                },
            },
            null
        );
    }

    // makeElement :: (string, attrs, HTMLElement) -> HTMLElement
    // attrs = An object containing an object containing key-value
    //   pairs to be set as the element's attributes. Mostly useful
    //   for setting styles, but could be used for other things.
    function makeElement(tag, attrs, child) {
        var elem = document.createElement(tag);
        for (var attr in attrs) {
            if (attrs.hasOwnProperty(attr)) {
                for (var prop in attrs[attr]) {
                    if (attrs[attr].hasOwnProperty(prop)) {
                        elem[attr][prop] = attrs[attr][prop];
                    }
                }
            }
        }
        if (child) {
            elem.appendChild(child);
        }
        return elem;
    }

    // makeColorRandomizer :: [[int,int]{3}] -> b -> string
    function makeColorRandomizer(x) {
        // The color can be given as a string...
        if (typeof(x) == 'string') {
            return function (n) {
                return x;
            }
        }

        if (!(x instanceof Array)) {
            console.log("ERROR: color must be string or array, given:", x);
        }

        // ...or as an array. The array can either contain three tuples
        // or a arbitrary number of strings.
        if (x[0] instanceof Array) {
            return function (n) {
                return 'hsl('+
                    getRandomInt(x[0][0], x[0][1])+','+
                    getRandomInt(x[1][0], x[1][1])+'%,'+
                    getRandomInt(x[2][0], x[2][1])+'%)';
            }
        }
        else {
            return function (n) {
                return x[(getRandomInt(0, x.length - 1))];
            }
        }
    }

    // makeNumberRandomizer :: [int,int] -> b -> int
    function makeNumberRandomizer(x) {
        return function (n) {
            return getRandomInt(x[0], x[1]);
        }
    }

    // makePercentRandomizer :: [int,int] -> int -> int
    function makePercentRandomizer(x) {
        return function (n) {
            return ((n / 100) * getRandomInt(x[0], x[1]));
        };
    }

    // makePercentIdentity :: int -> int -> int
    function makePercentIdentity(x) {
        return function (n) {
            return ((n / 100) * x);
        }
    }

    // makeIdentity :: a -> b -> a
    function makeIdentity(x) {
        return function (n) {
            return x;
        };
    }

    // makeArgmaker :: (a, (b -> c), (b -> c)) -> (c -> d) -> d
    function makeArgMaker(arg, maker, alt, transform) {
        if (arg instanceof Array) {
            return maker(arg);
        }
        else if ((typeof arg == 'string') ||
                 (typeof arg == 'number')) {
            if (transform) {
                return transform(arg);
            }
            else {
                return makeIdentity(arg);
            }
        }
        else {
            return alt;
        }
    }

    // via https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random
    function getRandomInt(min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    return init((args || {}));
}
