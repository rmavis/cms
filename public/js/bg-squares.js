function Squares(params) {

    this.init = function(pobj) {
        this.target = ('target' in pobj) ? pobj.target : document.getElementById('bg-screen');

        this.rows = ('rows' in pobj) ? pobj.rows : randInt(5,25);
        this.cols = ('cols' in pobj) ? pobj.cols : randInt(5,25);

        // The HSL color, must be between 0 and 359
        if ('hue' in pobj) {
            this.hueMin = ('min' in pobj.hue) ? pobj.hue.min : randInt(0,180);
            this.hueMax = ('max' in pobj.hue) ? pobj.hue.max : randInt(180,359);
            this.hueModX = ('modX' in pobj.hue) ? pobj.hue.modX : randVal(0,15,true);
            this.hueModY = ('modY' in pobj.hue) ? pobj.hue.modY : randVal(0,15,true);
        } else {
            this.hueMin = randInt(0,180);
            this.hueMax = randInt(180,359);
            this.hueModX = randVal(0,15,true);
            this.hueModY = randVal(0,15,true);
        }

        if ('saturation' in pobj) {
            this.satMin = ('min' in pobj.saturation) ? pobj.saturation.min : randInt(50,80);
            this.satMax = ('max' in pobj.saturation) ? pobj.saturation.max : randInt(80,100);
            this.satModX = ('modX' in pobj.saturation) ? pobj.saturation.modX : randVal(0,5,true);
            this.satModY = ('modY' in pobj.saturation) ? pobj.saturation.modY : randVal(0,5,true);
        } else {
            this.satMin = randInt(50,80);
            this.satMax = randInt(80,100);
            this.satModX = randVal(0,5,true);
            this.satModY = randVal(0,5,true);
        }

        if ('light' in pobj) {
            this.lgtMin = ('min' in pobj.light) ? pobj.light.min : randInt(50,80);
            this.lgtMax = ('max' in pobj.light) ? pobj.light.max : randInt(80,100);
            this.lgtModX = ('modX' in pobj.light) ? pobj.light.modX : randVal(0,5,true);
            this.lgtModY = ('modY' in pobj.light) ? pobj.light.modY : randVal(0,5,true);
        } else {
            this.lgtMin = randInt(50,80);
            this.lgtMax = randInt(80,100);
            this.lgtModX = randVal(0,5,true);
            this.lgtModY = randVal(0,5,true);
        }


        this.rowHeight = (100 / this.rows) + '%';
        this.rowWidth = '100%';
        this.boxHeight = '100%';
        this.boxWidth = (100 / this.cols) + '%',

        this.main();
    };



    this.main = function() {
        var baseHue = randInt(this.hueMin, this.hueMax),
            baseSat = randInt(this.satMin, this.satMax),
            baseLgt = randInt(this.lgtMin, this.lgtMax);

        var oHue = baseHue,
            oSat = baseSat,
            oLgt = baseLgt,
            iHue = 0,
            iSat = 0,
            iLgt = 0;

        var oSatMod = this.satModY;
        var oLgtMod = this.lgtModY;
        var oFullLgt = 0;
        var oFullSat = 0;

        for (var o = 0; o < this.rows; o++) {
            var row = document.createElement('div');
            row.style.height = this.rowHeight;
            row.style.width = this.rowWidth;

            if (o > 0) {
                if (!this.hueModY == 0) {
                    oHue += this.hueModY;
                }
                if (!this.satModY == 0) {
                    if (oFullSat > 1) {
                        oFullSat = 0;
                        oSatMod = (oSatMod * -1);
                    }
                    oSat += oSatMod;
                }
                if (!this.lgtModY == 0) {
                    if (oFullLgt > 1) {
                        oFullLgt = 0;
                        oLgtMod = (oLgtMod * -1);
                    }
                    oLgt += oLgtMod;
                }

                if (oSat > 100) {oSat = 100;}
                if (oSat < 0) {oSat = 0;}
                if ((oSat >= 100) || (oSat <= 0)) {oFullSat += 1;}
                if (oLgt > 100) {oLgt = 100;}
                if (oLgt < 0) {oLgt = 0;}
                if ((oLgt >= 100) || (oLgt <= 0)) {oFullLgt += 1;}
            }

            iHue = oHue,
            iSat = oSat,
            iLgt = oLgt;

            iFullSat = 0;
            iFullLgt = 0;
            iSatMod = this.satModX;
            iLgtMod = this.lgtModX;

            for (var i = 0; i < this.cols; i++) {
                if (i > 0) {
                    if (!this.hueModX == 0) {
                        iHue += this.hueModX;
                    }
                    if (!this.satModX == 0) {
                        if (iFullSat > 1) {
                            iFullSat = 0;
                            iSatMod = (iSatMod * -1);
                        }
                        iSat += iSatMod;
                    }
                    if (!this.lgtModX == 0) {
                        if (iFullLgt > 1) {
                            iFullLgt = 0;
                            iLgtMod = (iLgtMod * -1);
                        }
                        iLgt += iLgtMod;
                    }

                    if (iSat > 100) {iSat = 100;}
                    if (iSat < 0) {iSat = 0;}
                    if ((iSat >= 100) || (iSat <= 0)) {iFullSat += 1;}
                    if (iLgt > 100) {iLgt = 100;}
                    if (iLgt < 0) {iLgt = 0;}
                    if ((iLgt >= 100) || (iLgt <= 0)) {iFullLgt += 1;}
                }

                row.appendChild(this.newBox(iHue, iSat, iLgt));
            }

            this.target.appendChild(row);
        }
    };



    this.newBox = function(hue, sat, lgt) {
        var box = document.createElement('div');
        box.style.display = 'inline-block';
        box.style.fontSize = '0';
        box.style.width = this.boxWidth;
        box.style.height = this.boxHeight;
        box.style.backgroundColor = 'hsl('+ hue +', '+ sat +'%, '+ lgt +'%)';

        box.setAttribute('hue', hue);
        box.setAttribute('sat', sat);
        box.setAttribute('lgt', lgt);

        return box;
    };


    // This needs to stay down here.
    if (typeof params == 'object') {this.init(params);}
    else {this.init({});}
}





/*

Sample parameters:
var params = {
    target: document.getElementById('bg-screen'),
    rows: 10,
    cols: 10,
    hue: {
        min: 0,
        max: 359,
        modX: 0,
        modY: 10
    },
    saturation: {
        min: 70,
        max: 100,
        modX: 5,
        modY: 10
    },
    light: {
        min: 40,
        max: 60,
        modX: 5,
        modY: 0
    }
};

*/
