import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    required property var modelData
    property int thickness: States.frameThickness
    property int rounding: States.frameRounding
    property color frameColor: Theme.bgcolor
    visible: States.frameVis
    screen: modelData
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Top
    color: "transparent"

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    Rectangle {
        id: maskRect
    }

    Rectangle {
        anchors.fill: parent
        anchors.topMargin: States.barHeight
        color: "transparent"
        clip: true
        layer.enabled: true
        layer.samples: 4

        Shape {
            id: frameShape

            readonly property int tlx: root.thickness
            readonly property int tly: root.thickness
            readonly property int trx: parent.width - root.thickness
            readonly property int try_: root.thickness
            readonly property int blx: root.thickness
            readonly property int bly: parent.height - root.thickness
            readonly property int brx: parent.width - root.thickness
            readonly property int bry: parent.height - root.thickness
            readonly property int r: root.rounding

            antialiasing: true
            anchors.fill: parent

            ShapePath {
                strokeWidth: 0
                fillColor: root.frameColor
                fillRule: ShapePath.OddEvenFill

                PathLine {
                    x: 0
                    y: 0
                }

                PathLine {
                    x: 0
                    y: root.height
                }

                PathLine {
                    x: root.width
                    y: root.height
                }

                PathLine {
                    x: root.width
                    y: 0
                }

                PathLine {
                    x: 0
                    y: 0
                }

                PathLine {
                    x: frameShape.tlx + frameShape.r
                    y: frameShape.tly
                }

                PathArc {
                    x: frameShape.tlx
                    y: frameShape.tly + frameShape.r
                    direction: PathArc.Counterclockwise
                    radiusX: frameShape.r
                    radiusY: frameShape.r
                }

                PathLine {
                    x: frameShape.blx
                    y: frameShape.bly - frameShape.r
                }

                PathArc {
                    x: frameShape.blx + frameShape.r
                    y: frameShape.bly
                    direction: PathArc.Counterclockwise
                    radiusX: frameShape.r
                    radiusY: frameShape.r
                }

                PathLine {
                    x: frameShape.brx - frameShape.r
                    y: frameShape.bry
                }

                PathArc {
                    x: frameShape.brx
                    y: frameShape.bry - frameShape.r
                    direction: PathArc.Counterclockwise
                    radiusX: frameShape.r
                    radiusY: frameShape.r
                }

                PathLine {
                    x: frameShape.trx
                    y: frameShape.try_ + frameShape.r
                }

                PathArc {
                    x: frameShape.trx - frameShape.r
                    y: frameShape.try_
                    direction: PathArc.Counterclockwise
                    radiusX: frameShape.r
                    radiusY: frameShape.r
                }

                PathLine {
                    x: frameShape.tlx + frameShape.r
                    y: frameShape.tly
                }

            }

        }

    }

    mask: Region {
        item: maskRect
    }

}
