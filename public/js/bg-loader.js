function BackgroundLoader() {
    var n = Math.random();

    if (n < 0.2) {
        if (n < 0.1) {
            document.getElementById('bg-screen').appendChild(Whalesharkskin({
                cols: 25,
                line: 'hsl(0, 0%, 80%)',
                boxColor: [[60, 120], [50, 50], [90, 100]],
                dotColor: [[150, 210], [80, 80], [50, 50]],
                dotSize: [25, 75],
            }));
        }
        else {
            document.getElementById('bg-screen').appendChild(Whalesharkskin({
                cols: 25,
                line: 'hsl(0, 0%, 80%)',
                boxColor: 'hsl(0, 0%, 100%)',
                dotColor: [[0, 0], [0, 0], [10, 100]],
                dotSize: [15, 85],
            }));
        }
    }
    else if (n < 0.4) {
        new Circles();
    }
    else if (n < 0.6) {
        new Squares();
    }
    else if (n < 0.8) {
        if (n < 0.7) {
            BgStars.init({
                target: document.getElementById('bg-screen'),
                number: [5, 15],
                arms: [2, 8],
                armHeight: [2, 10],
                armWidth: [10, 2000],
                colors: {
                    h: {vals: [0, 360], unit: null, int: true},
                    s: {vals: [0, 100], unit: '%', int: true},
                    l: {vals: [0, 100], unit: '%', int: true},
                    a: {vals: [0.25, 1], unit: null, int: false},
                }
            });
        }
        else {
            var target = document.getElementById('bg-screen'),
                star_color = randNum(0, 361),
                target_bg = randNum(0, 101);
            // Some shade of grey.
            target.style.backgroundColor = 'hsl(0, 0%, '+target_bg+'%)';
            BgStars.init({
                target: target,
                number: [15, 50],
                arms: [2, 8],
                armHeight: [2, 4],
                armWidth: [10, 80],
                colors: {
                    h: {vals: star_color, unit: null, int: true},
                    s: {vals: 100, unit: '%', int: true},
                    l: {vals: 50, unit: '%', int: true},
                }
            });
        }
    }
    else {
        new Malevich({
            max_elems: 10,
            frame: document.getElementById('bg-screen'),
        });
    }
}



// Clipped these from https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Math/random?redirectlocale=en-US&redirectslug=JavaScript%2FReference%2FGlobal_Objects%2FMath%2Frandom
function randInt(min, max) {
    return Math.floor(this.randNum(min, max));
}
function randNum(min, max) {
    return Math.random() * (max - min) + min;
}



function randVal(min, max, zeroOk) {
    zeroOk = (zeroOk) ? true : false;
    var val = 0;

    val = ((isInt(min)) && (isInt(max)))
        ? randInt(min, max)
        : randNum(min, max);

    if (val == 0) {
        if (zeroOk) {return val;}
        else {return randVal(min, max);}
    }
    else {
        if (randone()) {return -val;}
        else {return val;}
    }
}



// Clipped this from http://stackoverflow.com/questions/3885817/how-to-check-if-a-number-is-float-or-integer
function isInt(n) {
    return n % 1 === 0;
}



// This will be a random boolean.
function randone() {
    return (Math.round(Math.random()) == 1);
}
