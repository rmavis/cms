function Circles(params) {

    this.init = function(pobj) {
        // Limits on the radius.
        if ('radius' in pobj) {
            this.radMin = ('min' in pobj.radius) ? pobj.radius.min : 1;
            this.radMax = ('max' in pobj.radius) ? pobj.radius.max : randInt(10,50);
        } else {
            this.radMin = 1;
            this.radMax = randInt(100,300);
        }

        // Limits on the layering.
        if ('zIndex' in pobj) {
            this.zMin = ('min' in pobj.zIndex) ? pobj.zIndex.min : 0;
            this.zMax = ('max' in pobj.zIndex) ? pobj.zIndex.max : 20;
        } else {
            this.zMin = 0;
            this.zMax = 20;
        }

        // The HSLA color, must be between 0 and 359
        if ('hue' in pobj) {
            this.hueMin = ('min' in pobj.hue) ? pobj.hue.min : randInt(0,180);
            this.hueMax = ('max' in pobj.hue) ? pobj.hue.max : randInt(180,359);
        } else {
            this.hueMin = randInt(0,180);
            this.hueMax = randInt(180,359);
        }

        // The HSLA saturation, will be a percentage
        if ('saturation' in pobj) {
            this.satMin = ('min' in pobj.saturation) ? pobj.saturation.min : randInt(50,70);
            this.satMax = ('max' in pobj.saturation) ? pobj.saturation.max : randInt(70,100);
        } else {
            this.satMin = randInt(50,70);
            this.satMax = randInt(70,100);
        }

        // The HSLA light, will be a percentage.
        if ('light' in pobj) {
            this.lgtMin = ('min' in pobj.light) ? pobj.light.min : randInt(40,50);
            this.lgtMax = ('max' in pobj.light) ? pobj.light.max : randInt(50,60);
        } else {
            this.lgtMin = randInt(40,50);
            this.lgtMax = randInt(50,60);
        }

        // The HSLA alpha, will be a percentage.
        if ('alpha' in pobj) {
            this.aMin = ('min' in pobj.alpha) ? pobj.alpha.min : randNum(0.1,0.3);
            this.aMax = ('max' in pobj.alpha) ? pobj.alpha.max : randNum(0.7,0.9);
        } else {
            this.aMin = randNum(0.1,0.3);
            this.aMax = randNum(0.7,0.9);
        }

        // The quantity.
        if ('quantity' in pobj) {
            this.quant = ('quantity' in pobj) ? pobj.quantity : randInt(8,25);
        } else {
            this.quant = (this.radMax < 20) ? randInt(15,45) : randInt(10,25);
        }

        // The fill mode. Appropriate values: fill, ring, rand.
        this.fillMode = ('fillMode' in pobj) ? pobj.fillMode : 'rand';

        this.target = ('target' in pobj) ? pobj.target : document.getElementById('bg-screen');

        this.main();
    };



    this.reset = function() {
        this.current = document.createElement('div');
        this.rad = randInt(this.radMin, this.radMax);
        this.hue = randInt(this.hueMin, this.hueMax);
        this.sat = randInt(this.satMin, this.satMax);
        this.lgt = randInt(this.lgtMin, this.lgtMax);
        this.alf = randNum(this.aMin, this.aMax);
        this.zin = randInt(this.zMin, this.zMax);
    };



    this.main = function() {
        var fillAct = null;
        if (this.fillMode == 'fill') {
            fillAct = this.setFill.bind(this);
        }
        else if (this.fillMode == 'ring') {
            fillAct = this.setRing.bind(this);
        }
        else {
            fillAct = this.setRand.bind(this);
        }

        for (var o = 0; o < this.quant; o++) {
            this.reset();
            this.setBasics();
            fillAct();
            this.target.appendChild(this.current);
        }
    };



    this.setBasics = function() {
        this.current.style.display = 'block';
        this.current.style.position = 'absolute';
        this.current.style.top = randInt(0, 100) + '%';
        this.current.style.left = randInt(0, 100) + '%';
        this.current.style.zIndex = this.zin;

        this.current.style.webkitTransform = 'translate(-50%, -50%)';
        this.current.style.mozTransform = 'translate(-50%, -50%)';
        this.current.style.transform = 'translate(-50%, -50%)';
    };



    this.setFill = function() {
        this.current.style.width = this.rad + 'px';
        this.current.style.height = this.rad + 'px';
        this.current.style.borderRadius = this.rad + 'px';
        this.current.style.mozBorderRadius = this.rad + 'px';
        this.current.style.webkitBorderRadius = this.rad + 'px';
        this.current.style.backgroundColor = 'hsla('+ this.hue +', '+ this.sat +'%, '+ this.lgt +'%, '+ this.alf +')';
    };


    this.setRing = function() {
        var x = this.rad - randInt(0, this.rad);
        var y = this.rad - x;

        this.current.style.width = x + 'px';
        this.current.style.height = x + 'px';
        this.current.style.backgroundColor = 'hsla(0,0%,0%,0.0)';

        this.current.style.webkitBorderRadius = this.rad + 'px';
        this.current.style.mozBorderRadius = this.rad + 'px';
        this.current.style.borderRadius = this.rad + 'px';
        this.current.style.border = y + 'px solid';
        this.current.style.borderColor = 'hsla('+ this.hue +', '+ this.sat +'%, '+ this.lgt +'%, '+ this.alf +')';
    };



    this.setRand = function() {
        var chk = Math.random();
        if (chk > 0.49) {this.setRing();}
        else {this.setFill();}
    }



    // This needs to stay down here.
    if (typeof params == 'object') {this.init(params);}
    else {this.init({});}
}





/*

Sample parameters:
var params = {
    target: document.getElementById('bg-screen'),
    quantity: 15,
    radius: {
        min: 2,
        max: 400
    },
    zIndex: {
        min: 0,
        max: 20
    },
    hue: {
        min: 0,
        max: 180
    },
    saturation: {
        min: 50,
        max: 100
    },
    light: {
        min: 25,
        max: 75
    },
    alpha: {
        min: 0.2,
        max: 0.8
    }
};

*/
