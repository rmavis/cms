function Malevich(args) {

    /*
     * Init & config.
     */

    var $frame = document.body;

    var $frame_pad = 10;

    var $min_elems = 3;
    var $max_elems = 10;

    var $min_dim = 5;
    var $max_dim = 100;

    var $dim_unit_x = 'vw';
    var $dim_unit_y = 'vh';

    var $colors = [
        {
            base: [0, 0, 0, 1],  // black
            variants: [
                [[0, 330], 100, 50, [0.1, 0.9]],
                [[0, 180], 100, 50, [0.1, 0.9]],
                [[180, 360], 100, 50, [0.1, 0.9]],
                [[160, 180], 100, 50, [0.1, 0.9]],
                [0, 0, [10, 100], [0.1, 0.9]],
                [0, 0, [10, 100], [0.4, 0.6]],
                [0, 0, [10, 100], 1],
                [getRandomInt(0, 330), 100, [10, 100], 1]
            ]
        },
        {
            base: [0, 0, 100, 1],  // white
            variants: [
                [[0, 330], 100, 50, [0.1, 0.9]],
                [[0, 180], 100, 50, [0.1, 0.9]],
                [[180, 360], 100, 50, [0.1, 0.9]],
                [[160, 180], 100, 50, [0.1, 0.9]],
                [0, 0, [0, 90], [0.1, 0.9]],
                [0, 0, [0, 90], [0.4, 0.6]],
                [0, 0, [0, 90], 1],
                [getRandomInt(0, 330), 100, [0, 90], 1]
            ]
        },
        {
            base: [0, 100, 50, 1],  // red
            variants: [
                [[30, 330], 100, 50, [0.1, 0.9]],
                [[30, 90], 100, 50, [0.1, 0.9]],
                [180, 100, [0, 100], [0.1, 0.9]],
                [0, [0, 50], 100, [0.1, 0.9]],
                [getRandomInt(30, 330), 100, [0, 100], [0.1, 0.9]],
            ]
        },
    ];


    var $shapes = [
        makeCircle,
        makeSquare,
        makeRectangle,
    ];



    function init(args) {
        var min_elems = (args.min_elems || $min_elems),
            max_elems = (args.max_elems || $max_elems),
            frame = (args.frame || $frame);

        var points = getPoints(getRandomInt(min_elems, max_elems)),
            shapes = makeShapes(points),
            colors = getColors(shapes.length);

        shapes = giveShapesColors(shapes, colors.fgs);
        var elems = makeElements(shapes);

        frame.style.backgroundColor = colors.bg;
        compileImage(frame, elems);
    }





    /*
     * Shape functions.
     */

    function getPoints(n) {
        var points = [ ],
            min = ($frame_pad + $min_dim),
            max = (100 - $frame_pad - $min_dim);

        for (var o = 0; o < n; o++) {
            var center = {
                x: getRandomInt(min, max),
                y: getRandomInt(min, max)
            };

            var max_x = ((max - center.x) < $min_dim) ? $min_dim : (max - center.x),
                max_y = ((max - center.y) < $min_dim) ? $min_dim : (max - center.y);

            var dims = {
                w: getRandomInt($min_dim, max_x),
                h: getRandomInt($min_dim, max_y),
            };

            points.push({
                center: center,
                dims: dims
            });
        }

        return points;
    }

    // http://math.stackexchange.com/questions/270194/how-to-find-the-vertices-angle-after-rotation
    // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/sin
    // function getRotatedPoints(shape) {
    // }



    function makeShapes(points) {
        var shapes = [ ];

        for (var o = 0; o < points.length; o++) {
            var func = $shapes[getRandomInt(0, ($shapes.length - 1))],
                shape = func(points[o]);
            shapes.push(shape);
        }

        return shapes;
    }



    function getShapeElemAttributes() {
        return {
            position: 'absolute',
            top: 0,
            left: 0,
            width: 0,
            height: 0,
            borderWidth: 0,
            borderRadius: 0,
            borderColor: null,
            backgroundColor: null,
            transform: null,
        };
    }



    function makeSquare(point) {
        var shape = getShapeElemAttributes();
        var dim = (Math.random() < 0.5) ? point.dims.w : point.dims.h;
        var unit = (Math.random() < 0.5) ? $dim_unit_x : $dim_unit_y;

        shape.width = dim + unit;
        shape.height = dim + unit;

        shape.left = (point.center.x - (dim / 2)) + $dim_unit_x;
        shape.top = (point.center.y - (dim / 2)) + $dim_unit_y;

        shape.transform = 'rotate('+getRandomInt(0, 90)+'deg)';

        return shape;
    }



    function makeRectangle(point) {
        var shape = getShapeElemAttributes();

        shape.width = point.dims.w + $dim_unit_x;
        shape.height = point.dims.h + $dim_unit_y;

        shape.left = (point.center.x - (point.dims.w / 2)) + $dim_unit_x;
        shape.top = (point.center.y - (point.dims.h / 2)) + $dim_unit_y;

        shape.transform = 'rotate('+getRandomInt(0, 90)+'deg)';

        return shape;
    }



    function makeCircle(point) {
        var shape = makeSquare(point);

        shape.borderRadius = shape.height;
        shape.borderWidth = '1px';

        return shape;
    }



    function giveShapesColors(shapes, colors) {
        for (var o = 0, m = shapes.length; o < m; o++) {
            shapes[o].backgroundColor = colors[o];
        }

        return shapes;
    }





    /*
     * Color functions.
     */

    function getColors(n) {
        var color = $colors[getRandomInt(0, ($colors.length - 1))],
            variant = color.variants[getRandomInt(0, (color.variants.length - 1))],
            fgs = [ ];

        // console.log(variant);

        for (var o = 0; o < n; o++) {
            fgs.push(makeColorString(varyColor(color.base, variant)));
        }

        // console.log(fgs);

        return {
            bg: makeColorString(color.base),
            fgs: fgs
        };
    }



    // color = [int, int, int]
    // lims = [[int, int], [int, int], [int, int], [float, float]]
    function varyColor(color, lims) {
        var variant = [ ];

        for (var o = 0, m = lims.length; o < m; o++) {
            if ((lims[o] === false) || (lims[o] === null)) {
                variant.push(color[o]);
            }
            else if (lims[o].constructor == Array) {
                // This presumes the array only has two values.
                // Are there use cases for more?
                var f = ((lims[o][0] % 1 === 0) &&
                         (lims[o][1] % 1 === 0))
                    ? getRandomInt
                    : getRandomArbitrary;
                variant.push(f(lims[o][0], lims[o][1]));
            }
            else {
                variant.push(lims[o]);
            }
        }

        return variant;
    }



    function makeColorString(color) {
        return 'hsla('+color[0]+', '+color[1]+'%, '+color[2]+'%, '+color[3]+')';
    }





    /*
     * Element functions.
     */

    function makeElements(shapes) {
        var elems = [ ];

        for (var o = 0, m = shapes.length; o < m; o++) {
            var elem = document.createElement('div');

            for (var key in shapes[o]) {
                elem.style[key] = shapes[o][key];
            }

            elems.push(elem);
        }

        return elems;
    }



    function compileImage(frame, elems) {
        for (var o = 0, m = elems.length; o < m; o++) {
            frame.appendChild(elems[o]);
        }

        return frame;
    }





    /*
     * Utility functions.
     */

    // via https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random
    function getRandomInt(min, max) {
        min = Math.ceil(min);
        max = Math.floor(max);
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }



    // via same as above
    // max is not inclusive
    function getRandomArbitrary(min, max) {
        return Math.random() * (max - min) + min;
    }



    return init(args)
};
