/*
    Copyright 2013 Jan Grulich <jgrulich@redhat.com>

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) version 3, or any
    later version accepted by the membership of KDE e.V. (or its
    successor approved by the membership of KDE e.V.), which shall
    act as a proxy defined in Section 6 of version 3 of the license.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 1.1
import Qt 4.7
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.networkmanagement 0.1 as PlasmaNM

Item {
    id: panelIconWidget

    property int minimumWidth: userDataSource.data["Local"]["width"] * 14 / 100
    property int minimumHeight: topPartHeight // clock.height + topseperatorcontainer.height + teacherinfo.height
    property int leftrightAlign: minimumWidth * 9 / 100
    property int lineAlign: minimumWidth * 7 / 100
    property int textAlign: minimumWidth * 4 / 100
    property int topPartHeight: userDataSource.data["Local"]["height"] * 17 / 100




    PlasmaNM.NetworkStatus {
        id: networkStatus
    }

    PlasmaNM.ConnectionIcon {
        id: connectionIconProvider
    }

    Column {
        anchors.fill: parent

        Rectangle {
            id: clock
            width: minimumWidth
            height: topPartHeight / 2
            color: containerBackgroundColor
            Row {
                anchors {
                    top: parent.top
                    topMargin: 0
                    fill: parent
                }
                Item {
                    id: textclockcontainer
                    anchors {
                        left: parent.left
                        leftMargin: leftrightAlign
                        top: parent.top
                        topMargin: lineAlign
                        verticalCenter: parent.verticalCenter
                    }
                    Column {
                        Text {
                            id: date
                            font.family: textFont
                            font.pointSize: minimumWidth * 3 / 100
                            text: Qt.formatDate(
                                      dataSource.data["Local"]["Date"],
                                      "dddd, d MMMM yyyy")
                            color: containerTextColor
                            horizontalAlignment: Text.AlignLeft
                            anchors {
                                left: parent.left
                                leftMargin: 0
                            }
                        } //textdate
                        Text {
                            id: time
                            font.bold: true
                            font.family: textFont
                            font.pointSize: minimumWidth * 11 / 100
                            text: (Qt.formatTime(
                                       dataSource.data["Local"]["Time"],
                                       "h:mmap")).toString().slice(0, -2)
                            color: containerTextColor
                            horizontalAlignment: Text.AlignLeft
                            anchors {
                                top: date.bottom
                                topMargin: 1
                                left: parent.left
                                leftMargin: 0
                            }
                        } //texttime
                    } // Column
                } // Item textclockcontainer
            } //Row
        }

        Rectangle {
            id: topseperatorcontainer
            color: containerBackgroundColor
            height: 3
            width: minimumWidth
            Rectangle {
                id: topseperator
                color: containerTextColor
                height: 1
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: lineAlign
                    right: parent.right
                    rightMargin: lineAlign
                }
            } //Rectangle line
        }

        Rectangle {
            id: teacherinfo
            width: minimumWidth
            height: topPartHeight / 2
            color: containerBackgroundColor
            Row {
                height: parent.height
                width: parent.width - 50
                anchors {
                    left: parent.left
                    leftMargin: leftrightAlign
                }

                Rectangle {
                    id: labelcontainer
                    color: "transparent"
                    width: minimumWidth / 2 - lineAlign
                    height: topPartHeight / 2 - 2
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                    Column {
                        id: infoColumn
                        spacing: 3
                        anchors {
                            left: parent.left
                            leftMargin: 0
                            verticalCenter: parent.verticalCenter
                        }
                        Text {
                            id: nameSurname
                            font.family: textFont
                            text: userDataSource.data["Local"]["fullname"].toUpperCase()
                            color: containerTextColor
                            font.pointSize: minimumWidth * 5 / 100
                            font.bold: true
                            elide: Text.ElideLeft
                            horizontalAlignment: Text.AlignLeft
                            anchors {
                                left: parent.left
                                leftMargin: 0
                            }
                        } //label
                        Text {
                            id: branch
                            font.family: textFont
                            text: userDataSource.data["Local"]["loginname"] // hocabranş
                            color: containerTextColor
                            font.pointSize: minimumWidth * 3 / 100
                            font.bold: false
                            elide: Text.ElideLeft
                            horizontalAlignment: Text.AlignLeft
                            anchors {
                                left: parent.left
                                leftMargin: 0
                            }
                        } //label
                    }
                }


            }

            Rectangle {
                id: networkcontainer
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: leftrightAlign
                color: "transparent"
                height: infoColumn.height + 6
                width: height
                PlasmaCore.Svg {
                    id: svgIcons

                    multipleImages: true
                    imagePath: "icons/plasma-networkmanagement2"
                }

                PlasmaCore.SvgItem {
                    id: connectionIcon
                    anchors.fill: parent
                    svg: svgIcons
                    elementId: connectionIconProvider.connectionIcon

                    PlasmaComponents.BusyIndicator {
                        id: connectingIndicator

                        anchors.fill: parent
                        running: connectionIconProvider.connecting
                        visible: running
                    }

                    MouseArea {
                        id: mouseAreaPopup

                        anchors.fill: connectionIcon
                        hoverEnabled: true
                        onClicked: plasmoid.togglePopup()

                        PlasmaCore.ToolTip {
                            id: tooltip
                            target: mouseAreaPopup
                            image: connectionIconProvider.connectionTooltipIcon
                            subText: networkStatus.activeConnections
                        }
                    }
                }
            }

        }
    }

    PlasmaCore.DataSource {
        id: dataSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 500
    }

    PlasmaCore.DataSource {
        id: userDataSource
        engine: "userinfo"
        connectedSources: ["Local"]
        interval: 500
    }
}
