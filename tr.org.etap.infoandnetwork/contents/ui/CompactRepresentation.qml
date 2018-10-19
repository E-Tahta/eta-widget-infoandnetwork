/*****************************************************************************
 *   Copyright (C) 2018 by Yunusemre Şentürk                                 *
 *   <yunusemre.senturk@pardus.org.tr>                                       *
 *                                                                           *
 *   This program is free software; you can redistribute it and/or modify    *
 *   it under the terms of the GNU General Public License as published by    *
 *   the Free Software Foundation; either version 2 of the License, or       *
 *   (at your option) any later version.                                     *
 *                                                                           *
 *   This program is distributed in the hope that it will be useful,         *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of          *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           *
 *   GNU General Public License for more details.                            *
 *                                                                           *
 *   You should have received a copy of the GNU General Public License       *
 *   along with this program; if not, write to the                           *
 *   Free Software Foundation, Inc.,                                         *
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .          *
 *****************************************************************************/

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
                    spacing: 1
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
                    }
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
                    }
                }
            }
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
                    width: minimumWidth - networkcontainer.width - 2 * leftrightAlign + 3
                    height: topPartHeight / 2 - 2
                    anchors {
                        verticalCenter: parent.verticalCenter
                    }
                    Column {
                        id: infoColumn
                        width: parent.width
                        height: parent.height / 2
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.verticalCenterOffset: 5
                        spacing: 3
                        Text {
                            id: nameSurname
                            width: parent.width
                            font.family: textFont
                            text: userDataSource.data["Local"]["fullname"].toUpperCase()
                            color: containerTextColor
                            font.pointSize: 11
                            font.bold: true
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignLeft
                        }

                        Text {
                            id: branch
                            width: parent.width
                            font.family: textFont
                            text: userDataSource.data["Local"]["loginname"]
                            color: containerTextColor
                            font.pointSize: minimumWidth * 3 / 100
                            font.bold: false
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideLeft
                            horizontalAlignment: Text.AlignLeft

                        }
                    }
                }


            }

            Rectangle {
                id: networkcontainer
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: leftrightAlign - 5
                color: "transparent"
                height: infoColumn.height
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
