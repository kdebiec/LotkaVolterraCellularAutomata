Array.prototype.attach = function(listmodel) {
    this.model = listmodel;
    this.flush();
}

Array.prototype.flush = function() {
    var i;
    while (this.model.count > this.length)
        this.model.remove(this.model.count-1);

    for (i = 0; i < this.model.count; i++)
        this.model.set(i, typeof this[i] == 'object' ? this[i] : {value: this[i]});

    for (;i < this.length; i++)
        this.model.append(typeof this[i] == 'object' ? this[i] : {value: this[i]});
}

var worldMapArray = []
var rows = 40
var init = function(listModel) {
    start()

    for (var i = 0; i < rows*rows; i++)
        worldMapArray.push("0")

    for (var i = 0; i < rows; i++) {
        for(var j = 0; j< rows; j++)
            worldMapArray[j + i*rows] = field[i][j]
    }

    worldMapArray.attach(listModel);
}

var reset = function() {
    start()

    for(var i = 0; i < rows; i++) {
        for(var j = 0; j< rows; j++)
            worldMapArray[j + i*rows] = field[i][j]
    }

    worldMapArray.flush();
}

var day = 0;
var numOfWolves = []
var numOfRabbits = []

var field = new Array(rows); // 1 - grass, 2 - wolve, 3 - rabbit
for(var i=0; i<rows; i++ )
    field[i] = new Array(rows);

var initialWolvesPopulation = 0.02;
var initialRabbitPopulation = 0.2;
var pWolvesDeath = 0.02
var pWolvesBirth = 0.9;
var pRabbitsBirth = 0.04;
var wolvesPopulation = 0;
var rabbitPopulation = 0;

function chooseState() {
    var chances = Math.random();
    var state = 1;
    if (chances < initialWolvesPopulation) {
        state = 2;
        wolvesPopulation++;
    }
    else if (chances < initialWolvesPopulation+initialRabbitPopulation) {
        state = 3;
        rabbitPopulation++;
    }

    return state;
}

function start() {
    var i=0;
    wolvesPopulation = 0;
    rabbitPopulation = 0;

    for (i=0; i<rows; i++)
        for (var j=0; j<rows; j++)
            field[i][j] = chooseState();
}

var nextDay = function() {
    for (var i=0; i<rows; i++) {
        for (var j=0; j<rows; j++) {
            var point = field[i][j];
            if (point == 1)
                continue;
            if (Math.random() > 0.5)
                continue;

            var neigX = Math.ceil(Math.random()*3) - 2;
            var neigY;
            if (neigX != 0)
                neigY = Math.ceil(Math.random()*3) - 2;
            else
                neigY = (Math.random() > 0.5 ? 1 : -1);

            var otherX = i+neigX, otherY = j+neigY;
            if (otherX < 0)
                otherX = rows-1;
            else if (otherX >= rows)
                otherX = 0;
            if (otherY < 0)
                otherY = rows-1;
            else if (otherY >= rows)
                otherY = 0;
            var other = field[otherX][otherY];
            var delta1 = point + other;
            if (point == 2) {
                if (other == 3) {
                    if (Math.random() > pWolvesBirth)
                        field[otherX][otherY] = 1;
                    else
                        field[otherX][otherY] = 2;
                }
                else if (Math.random() < pWolvesDeath)
                    field[i][j] = 1;
                else if (other == 1)
                    field[i][j] = 1;field[otherX][otherY] = 2;
            }
            else if (point == 3) {
                if (other == 2)
                    field[i][j] = 1;
                else if (other == 1) {
                    if (Math.random() < pRabbitsBirth)
                        field[otherX][otherY] = 3;
                    else
                        field[i][j] = 1;field[otherX][otherY] = 3;
                }
            }
            var delta = field[i][j] + field[otherX][otherY] - delta1;
            if (delta == -1) {
                if (delta1 < 5)
                    wolvesPopulation--;
                else {
                    wolvesPopulation++;
                    rabbitPopulation--;
                }
            }
            else if (delta == -2)
                rabbitPopulation--;
            else if (delta == 2)
                rabbitPopulation++;
        }
    }

    for (var i = 0; i < rows; i++) {
        for(var j = 0; j < rows; j++)
            worldMapArray[j + i*rows] = field[i][j]
    }

    numOfWolves.push(wolvesPopulation);
    numOfRabbits.push(rabbitPopulation);
    day++;

    worldMapArray.flush();
}

