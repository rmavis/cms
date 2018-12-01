function Grid(params) {

    this.init = function(pobj) {

        if ('width' in pobj) {
            this.width = pobj.width;
        } else {
            var maxWidthX = randInt(5,10);
            var maxWidthY = randInt(5,10);
            this.width = {
                x: {min: randInt(1,3), max: maxWidthX},
                y: {min: randInt(1,3), max: maxWidthY}
            };
        }

        if ('hue' in pobj) {
            this.hue = pobj.hue;
        } else {
            this.hue = {
                x: {min: randInt(0,180), max: randInt(0,359)},
                y: {min: randInt(0,180), max: randInt(0,359)}
            };
        }

        if ('saturation' in pobj) {
            this.sat = pobj.saturation;
        } else {
            this.sat = {
                x: {min: randInt(60,70), max: randInt(70,100)},
                y: {min: randInt(60,70), max: randInt(70,100)}
            };
        }

        if ('light' in pobj) {
            this.lgt = pobj.light;
        } else {
            this.lgt = {
                x: {min: randInt(30,50), max: randInt(50,70)},
                y: {min: randInt(30,50), max: randInt(50,70)}
            };
        }

        if ('alpha' in pobj) {
            this.alf = pobj.alpha;
        } else {
            this.alf = {
                x: {min: randNum(0.1,0.2), max: randNum(0.8,1.0)},
                y: {min: randNum(0.1,0.2), max: randNum(0.8,1.0)}
            };
        }

        if ('quantity' in pobj) {
            this.lines = pobj.quantity;
        } else {
            var quantX = (maxWidthX > 10) ? randInt(2,5) : randInt(5,10);
            var quantY = (maxWidthY > 10) ? randInt(2,5) : randInt(5,10);
            this.lines = {
                x: quantX,
                y: quantY
            };
        }

        if ('zIndex' in pobj) {
            this.zin = pobj.zIndex;
        } else {
            this.zin = {
                x: {min: 0, max: randInt(1,quantX)},
                y: {min: 0, max: randInt(1,quantY)}
            };
        }


        this.target = ('target' in pobj) ? pobj.target : document.getElementById('bg-screen');

        this.pole = null;  // This will become 'x' or 'y'.
        this.line_widths = [ ];  // This will be filled with numbers.
        this.pad_widths = [ ];  // So will this.

        this.main();
    };



    this.main = function() {
        var poles = ['x', 'y'];
        for (var o = 0; o < poles.length; o++) {
            this.pole = poles[o];
            this.getWidths();
            this.placeLines();
        }
    };



    this.getWidths = function() {
        this.line_widths = [ ];
        this.pad_widths = [ ];

        var lw = 0,
            total = 0;

        for (var o = 0; o < this.lines[this.pole]; o++) {
            lw = randInt(this.width[this.pole].min,
                         this.width[this.pole].max);
            total += lw;
            this.line_widths.push(lw);
        }

        // var pw = Math.round((100 - total) / (this.lines[this.pole] + 1));
        var pw = (100 / (this.lines[this.pole] + 1));

        for (var o = 0; o < (this.lines[this.pole] + 1); o++) {
            this.pad_widths.push(pw);
        }

        this.line_widths = shuffle(this.line_widths);
        this.pad_widths = shuffle(this.pad_widths);
    };



    this.reset = function() {
        this.current = document.createElement('div');
        this.curr_hue = randInt(this.hue[this.pole].min,
                                this.hue[this.pole].max);
        this.curr_sat = randInt(this.sat[this.pole].min,
                                this.sat[this.pole].max);
        this.curr_lgt = randInt(this.lgt[this.pole].min,
                                this.lgt[this.pole].max);
        this.curr_alf = randNum(this.alf[this.pole].min,
                                this.alf[this.pole].max);
        this.curr_zin = randInt(this.zin[this.pole].min,
                                this.zin[this.pole].max);
    };



    this.setBasics = function() {
        this.current.style.display = 'block';
        this.current.style.position = 'absolute';

        this.current.style.zIndex = randInt(this.zin[this.pole].min,
                                            this.zin[this.pole].max);

        // var trans = (this.pole == 'x') ? '0, -50%' : '-50%, 0';
        // this.current.style.webkitTransform = 'translate('+trans+')';
        // this.current.style.mozTransform = 'translate('+trans+')';
        // this.current.style.transform = 'translate('+trans+')';

        this.current.style.backgroundColor = 'hsla('+ this.curr_hue +', '+ this.curr_sat +'%, '+ this.curr_lgt +'%, '+ this.curr_alf +')';
    };



    this.placeLines = function() {
        var posit_a = 'top',
            posit_b = 'left',            
            girth_a = 'height',
            girth_b = 'width',
            unit = 'vw';

        if (this.pole == 'x') {
            posit_a = 'left',
            posit_b = 'top',
            girth_a = 'width',
            girth_b = 'height',
            unit = 'vh';
        }

        var mult = 1;
        for (var i = 0; i < this.lines[this.pole]; i++) {
            this.reset();
            this.setBasics();

            this.current.style[posit_a] = '0px';
            this.current.style[girth_a] = '100%';

            var lw = this.line_widths.pop(),
                pw = this.pad_widths.pop();

            this.current.style[girth_b] = lw + unit;
            this.current.style[posit_b] = ((pw * mult) - (lw / 2)) + unit;

            this.target.appendChild(this.current);

            mult += 1;
        }
    };




    // Clipped this from: http://stackoverflow.com/questions/2450954/how-to-randomize-shuffle-a-javascript-array
    function shuffle(array) {
        var currentIndex = array.length, temporaryValue, randomIndex ;

        // While there remain elements to shuffle...
        while (0 !== currentIndex) {

            // Pick a remaining element...
            randomIndex = Math.floor(Math.random() * currentIndex);
            currentIndex -= 1;

            // And swap it with the current element.
            temporaryValue = array[currentIndex];
            array[currentIndex] = array[randomIndex];
            array[randomIndex] = temporaryValue;
        }

        return array;
    }



    // This needs to stay down here.
    if (typeof params == 'object') {this.init(params);}
    else {this.init({});}
}





/*

Sample parameters:

var params = {
    target: document.getElementById('bg-screen'),
    quantity: {
        x: 10, y: 10
    },
    width: {
        x: {min: 1, max: 10},
        y: {min: 1, max: 10}
    },
    hue: {
        x: {min: 0, max: 180},
        y: {min: 0, max: 180}
    },
    saturation: {
        x: {min: 50, max: 50},
        y: {min: 50, max: 50}
    },
    light: {
        x: {min: 50, max: 50},
        y: {min: 50, max: 50}
    },
    alpha: {
        x: {min: 1.0, max: 1.0},
        y: {min: 1.0, max: 1.0}
    },
    zIndex: {
        x: {min: 0, max: 0},
        y: {min: 0, max: 0}
    }
};

*/
