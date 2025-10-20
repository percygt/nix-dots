pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Wayland
import QtQuick.Effects
import qs.config
import QtQuick.Shapes

ShellRoot {
    id: root

    readonly property int barWidth: 50

    Variants {
        model: Quickshell.screens

        Scope {
            id: scope

            required property ShellScreen modelData

            Scope {
                ExclusionZone {
                    anchors.left: true
                    exclusiveZone: root.barWidth
                    screen: scope.modelData
                }

                ExclusionZone {
                    anchors.top: true
                    screen: scope.modelData
                }

                ExclusionZone {
                    anchors.right: true
                    screen: scope.modelData
                }

                ExclusionZone {
                    anchors.bottom: true
                    screen: scope.modelData
                }
            }

            StyledWindow {
                id: win

                WlrLayershell.exclusionMode: ExclusionMode.Ignore
                WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
                anchors.bottom: true
                anchors.left: true
                anchors.right: true
                anchors.top: true
                name: "drawers"
                screen: scope.modelData

                mask: Region {
                    height: win.height - Config.border.thickness * 2
                    intersection: Intersection.Xor
                    // regions: regions.instances
                    width: win.width - root.barWidth - Config.border.thickness
                    x: root.barWidth
                    y: Config.border.thickness
                }
                MouseArea {
                    property int scrollAccumulatedY: 0
                    anchors.fill: parent
                    hoverEnabled: true

                    function onWheel(event: WheelEvent): void {
                    }

                    onWheel: event => {
                        // Update accumulated scroll
                        if (Math.sign(event.angleDelta.y) !== Math.sign(scrollAccumulatedY))
                        scrollAccumulatedY = 0;
                        scrollAccumulatedY += event.angleDelta.y;

                        // Trigger handler and reset if above threshold
                        if (Math.abs(scrollAccumulatedY) >= 120) {
                            onWheel(event);
                            scrollAccumulatedY = 0;
                        }
                    }
                  Item {
                    // property real margin: 5

                    // x: win.width - barWidth
                    anchors.rightMargin: 2
                    anchors.right: win.anchors.left
                    // Set the implicit size of the containing item to the size of
                    // the contained item, plus the margin on each side.
                    implicitWidth: child.implicitWidth
                    implicitHeight: child.implicitHeight

                    Rectangle {
                      id: child

                      // Set the size of the child item relative to the actual size
                      // of the parent item. If the parent item is constrained
                      // or stretched the child's position and size will be similarly
                      // constrained.
                      // x: parent.margin
                      // y: parent.margin
                      width: parent.width
                      height: parent.height

                      // The child's implicit / desired size, which will be respected
                      // by the container item as long as it is not constrained
                      // or stretched.
                      implicitWidth: 10
                      implicitHeight: 10
                    }
                  }
                }

                // Variants {
                //     id: regions
                //
                //     model: panels.children
                //
                //     Region {
                //         required property Item modelData
                //
                //         x: modelData.x + root.barWidth
                //         y: modelData.y + 10
                //         width: modelData.width
                //         height: modelData.height
                //         intersection: Intersection.Subtract
                //     }
                // }
                Item {
                    anchors.fill: parent
                    layer.enabled: true

                    layer.effect: MultiEffect {
                        blurMax: 15
                        shadowColor: Qt.alpha("#000000", 0.7)
                        shadowEnabled: true
                    }

                    Shape {
                        anchors.fill: parent
                        anchors.margins: Config.border.thickness
                        anchors.leftMargin: root.barWidth
                        preferredRendererType: Shape.CurveRenderer
                        ShapePath {
                          strokeWidth: 4
                          strokeColor: "red"
                          fillGradient: LinearGradient {
                              x1: 20; y1: 20
                              x2: 180; y2: 130
                              GradientStop { position: 0; color: "blue" }
                              GradientStop { position: 0.2; color: "green" }
                              GradientStop { position: 0.4; color: "red" }
                              GradientStop { position: 0.6; color: "yellow" }
                              GradientStop { position: 1; color: "cyan" }
                          }
                          strokeStyle: ShapePath.DashLine
                          dashPattern: [ 1, 4 ]
                          startX: 0; startY: 0
                          PathLine { x: 180; y: 130 }
                          PathLine { x: 20; y: 130 }
                          PathLine { x: 0; y: 20 }
                      }
                    }
                    Item {
                        anchors.fill: parent

                        Rectangle {
                            anchors.fill: parent
                            color: Qt.alpha("#000000", 0.7)
                            layer.enabled: true

                            Behavior on color {
                                ColorAnimation {
                                    duration: 400
                                    easing.bezierCurve: Appearance.anim.curves.standard
                                    easing.type: Easing.BezierSpline
                                }
                            }
                            layer.effect: MultiEffect {
                                maskEnabled: true
                                maskInverted: true
                                maskSource: mask
                                maskSpreadAtMin: 1
                                maskThresholdMin: 0.5
                            }
                        }

                        Item {
                            id: mask

                            anchors.fill: parent
                            layer.enabled: true
                            visible: false

                            Rectangle {
                                anchors.fill: parent
                                anchors.leftMargin: root.barWidth
                                anchors.margins: Config.border.thickness
                                radius: Config.border.rounding
                            }
                        }
                    }
                }
            }
        }
    }

    component ExclusionZone: StyledWindow {
        exclusiveZone: Config.border.thickness
        name: "border-exclusion"

        mask: Region {
        }
    }
    component StyledRect: Rectangle {
        color: "transparent"

        Behavior on color {
            ColorAnimation {
                duration: 400
                easing.bezierCurve: Appearance.anim.curves.standard
                easing.type: Easing.BezierSpline
            }
        }
    }
    component StyledWindow: PanelWindow {
        required property string name

        WlrLayershell.namespace: `percygt-${name}`
        color: "transparent"
    }
}
