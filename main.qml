import QtQuick 2.0
import Ubuntu.Components 0.1
import "components"

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.intirix.kidsdraw"


    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    width: units.gu(75)
    height: units.gu(75)

 //   visibility: "FullScreen"

    Page {
//        title: i18n.tr("Draw")

        Column {
            spacing: units.gu(1)
            anchors {
//                margins: units.gu(2)
                fill: parent
            }

            Rectangle {
                width: parent.width
                height: parent.height - colorRow.height - ( parent.spacing * 2 )
                border.color: "black"
                border.width: 1
                Canvas {
                    id: canvas
                    property var strokes: []
                    property var strokeMap: ({})
                    property string currentColor: "red"
                    width: parent.width
                    height: parent.height
    //                objectName: "label"

    //                text: i18n.tr("Hello..")
                    onPaint: {
                        var context = getContext("2d");

                        for (var i = 0; i < strokes.length; i++) {
                            var stroke = strokes[ i ];
                            if ( stroke.points.length > 1 ) {
                                // Draw a line
                                context.beginPath();
                                context.lineWidth = 2;
                                context.moveTo(stroke.points[0].x, stroke.points[0].y);
                                context.strokeStyle = stroke.color;
                                for (var j = 1; j < stroke.points.length; j++) {
                                    context.lineTo(stroke.points[j].x, stroke.points[j].y);
                                }

                                context.stroke();
                            }
                        }

                    }
                    MultiPointTouchArea {
                        width: parent.width
                        height: parent.height

                        onPressed: {
//                            console.log("onPressed("+touchPoints.length+")");
                            for (var i = 0; i < touchPoints.length; i++ ) {
                                var tp = touchPoints[ i ];
                                var path = { 'color': canvas.currentColor, points: [ {'x':tp.x,'y':tp.y} ] };
                                canvas.strokes.push( path );
                                canvas.strokeMap[tp.pointId] = path;
                                console.log(tp.pointId + ": Started at ("+tp.x + ',' + tp.y+')');
                            }

                        }

                        onUpdated: {
                            for (var i = 0; i < touchPoints.length; i++ ) {
                                var tp = touchPoints[ i ];
                                canvas.strokeMap[tp.pointId].points.push({'x':tp.x,'y':tp.y});
                                console.log(tp.pointId + ": Moved from ("+tp.previousX + ',' + tp.previousY+") to ("+tp.x + ',' + tp.y+')');
                            }
                            canvas.requestPaint();
                        }

                        onReleased: {
                            for (var i = 0; i < touchPoints.length; i++ ) {
                                var tp = touchPoints[ i ];
                                console.log(tp.pointId + ": Finished at ("+tp.x + ',' + tp.y+')');
                            }
                        }
                    }
                }
            }

            Row {
                id: colorRow
                spacing: units.gu(1)
                height: units.gu(10)
                property real selectedBorderWidth: units.gu(1)
                anchors.right: parent.right
                anchors.margins: spacing
                Rectangle {
                    color: "red"
                    height: parent.height
                    width: parent.height
                    border.width: colorRow.selectedBorderWidth;
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            for (var i = 0; i < colorRow.children.length - 1; i++) {
                                colorRow.children[i].border.width = 0;
                            }

                            canvas.currentColor = parent.color;
                            parent.border.width = colorRow.selectedBorderWidth;
                        }
                    }
                }
                Rectangle {
                    color: "green"
                    height: parent.height
                    width: parent.height
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            for (var i = 0; i < colorRow.children.length - 1; i++) {
                                colorRow.children[i].border.width = 0;
                            }

                            canvas.currentColor = parent.color;
                            parent.border.width = colorRow.selectedBorderWidth;
                        }
                    }
                }
                Rectangle {
                    color: "blue"
                    height: parent.height
                    width: parent.height
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            for (var i = 0; i < colorRow.children.length - 1; i++) {
                                colorRow.children[i].border.width = 0;
                            }

                            canvas.currentColor = parent.color;
                            parent.border.width = colorRow.selectedBorderWidth;
                        }
                    }
                }
                Rectangle {
                    color: "#F36AFA" // Purple
                    height: parent.height
                    width: parent.height
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            for (var i = 0; i < colorRow.children.length - 1; i++) {
                                colorRow.children[i].border.width = 0;
                            }

                            canvas.currentColor = parent.color;
                            parent.border.width = colorRow.selectedBorderWidth;
                        }
                    }
                }
                Rectangle {
                    color: "#DBAA37" // Orange
                    height: parent.height
                    width: parent.height
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            for (var i = 0; i < colorRow.children.length - 1; i++) {
                                colorRow.children[i].border.width = 0;
                            }

                            canvas.currentColor = parent.color;
                            parent.border.width = colorRow.selectedBorderWidth;
                        }
                    }
                }
                Rectangle {
                    color: "white"
                    height: parent.height
                    width: parent.height
                    border.width: colorRow.selectedBorderWidth / 4
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            console.log( "Clearing drawing" );
                            canvas.strokes = [];
                            canvas.strokeMap = {};
                            canvas.getContext("2d").clearRect ( 0,0 , canvas.width, canvas.height );
                            canvas.requestPaint();
                        }
                    }
                }
            }
        }
    }
}

