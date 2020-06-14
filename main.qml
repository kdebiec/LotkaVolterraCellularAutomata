import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtCharts 2.0

import "gridWorld.js" as GridWorld

Rectangle {
    id: mainWindow
    property ListModel worldMap: ListModel {}

    visible: true
    width: 1280
    height: 800

    Material.theme: Material.Dark
    Material.accent: Material.Purple

    Component.onCompleted: {
        GridWorld.init(mainWindow.worldMap);
        timer.start()
    }

    Timer {
        id: timer
        interval: 500;
        running: false;
        repeat: true
        onTriggered: {
            GridWorld.nextDay()

            axisX.max = GridWorld.day
            lineSeries1.append(GridWorld.day, GridWorld.numOfWolves[GridWorld.day-1]);
            lineSeries2.append(GridWorld.day, GridWorld.numOfRabbits[GridWorld.day-1]);
        }
    }

    Row {
        anchors.centerIn: parent
        spacing: 50

        Grid {
            x: 5; y: 5
            rows: GridWorld.rows;
            columns: GridWorld.rows;
            spacing: 5

            Repeater {
                id: repeaterMap
                model: mainWindow.worldMap

                Rectangle {
                    width: 15;
                    height: 15;
                    color: mainWindow.worldMap.get(index).value == 3 ? "blue" :
                               (mainWindow.worldMap.get(index).value == 2 ? "red" : "white")

                }
            }
        }

        Column {
            spacing: 10;
            Label {
                text: "Time in [ms]"
            }
            TextField {
                id: timeValue
                placeholderText: qsTr("Enter time")
                validator: IntValidator { bottom:0; top: 2000}
                text: timer.interval

                onAccepted: {
                    timer.interval = timeValue.text
                }
            }

            Label {
                text: "Initial percentage of wolves:"
            }
            TextField {
                id: initialWolvesPopulation
                placeholderText: qsTr("Enter probability")
                validator: DoubleValidator { bottom:0; top: 1}
                text: GridWorld.initialWolvesPopulation

                onAccepted: {
                    GridWorld.initialWolvesPopulation =
                            parseFloat(initialWolvesPopulation.text.replace(',', '.'))
                }
            }

            Label {
                text: "Initial percentage of rabbits:"
            }
            TextField {
                id: initialRabbitPopulation
                placeholderText: qsTr("Enter probability")
                validator: DoubleValidator { bottom:0; top: 1}
                text: GridWorld.initialRabbitPopulation

                onAccepted: {
                    GridWorld.initialRabbitPopulation =
                            parseFloat(initialRabbitPopulation.text.replace(',', '.'))
                }
            }

            Label {
                text: "Probability of death of wolves:"
            }
            TextField {
                id: pWolvesDeathValue
                placeholderText: qsTr("Enter probability")
                validator: DoubleValidator { bottom:0; top: 1}
                text: GridWorld.pWolvesDeath

                onAccepted: {
                    GridWorld.pWolvesDeath =
                            parseFloat(pWolvesDeathValue.text.replace(',', '.'))
                }
            }

            Label {
                text: "Probability of birth of wolves:"
            }
            TextField {
                id: pWolvesBirthValue
                placeholderText: qsTr("Enter probability")
                validator: DoubleValidator { bottom:0; top: 1}
                text: GridWorld.pWolvesBirth

                onAccepted: {
                    GridWorld.pWolvesBirth =
                            parseFloat(pWolvesBirthValue.text.replace(',', '.'))
                }
            }

            Label {
                text: "Probability of birth of rabbits:"
            }
            TextField {
                id: pRabbitsBirthValue
                placeholderText: qsTr("Enter probability")
                validator: DoubleValidator { bottom:0; top: 1}
                text: GridWorld.pRabbitsBirth

                onAccepted: {
                    GridWorld.pRabbitsBirth =
                            parseFloat(pRabbitsBirthValue.text.replace(',', '.'))
                }
            }

            Row {
                spacing: 10

                Button {
                    text: timer.running ? "Stop" : "Start"
                    onClicked: {
                        if(timer.running) {
                            timer.stop()
                        }
                        else {
                            timer.start()
                        }
                    }
                }

                Button {
                    text: "Reset"
                    onClicked: {
                        GridWorld.reset()
                    }
                }
            }
        }

        ChartView {
            id: chartView
            height: 700
            width: 700
            animationOptions: ChartView.SeriesAnimations

            ValueAxis {
                id: axisY
                min: 0
                max: 625
            }

            ValueAxis {
                id: axisX
                min: 0
                max: 0
            }
            LineSeries {
                id: lineSeries1
                name: "Wolves population"
                axisX: axisX
                axisY: axisY
                color: "red"
            }
            LineSeries {
                id: lineSeries2
                name: "Rabbit population"
                axisX: axisX
                axisYRight: axisY
                color: "blue"
            }
        }
    }
}
