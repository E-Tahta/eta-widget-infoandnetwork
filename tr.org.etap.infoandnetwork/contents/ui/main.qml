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
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.networkmanagement 0.1 as PlasmaNM

Rectangle {
    id: mainWindow;

    property int minimumWidth: 300;
    property int minimumHeight: 300;
    property bool showSections: true;
    property string textFont: "Open Symbol"
    property string containerBackgroundColor : "#383838";
    property string containerTextColor : "#eeeeee";

    property Component compactRepresentation: CompactRepresentation {
        Component.onCompleted: {
            plasmoid.addEventListener('configChanged', mainWindow.configChanged)
        }
    }

    signal sectionChanged();
    color : containerBackgroundColor

    PlasmaNM.GlobalConfig {
        id: globalConfig;

        onDetailKeysChanged: {
            connectionModel.updateItems();
        }

        onNetworkSpeedUnitChanged: {
            connectionModel.updateItems();
        }
    }

    PlasmaNM.Handler {
            id: handler;
    }

    PlasmaNM.NetworkModel {
        id: connectionModel;
    }
    PlasmaNM.AppletProxyModel {
        id: appletProxyModel;

        sourceModel: connectionModel;
    }

    PlasmaCore.Svg {
        id: svgNetworkIcons;

        multipleImages: true;
        imagePath: "icons/plasma-networkmanagement2";
    }

    PlasmaCore.FrameSvgItem {
        id: padding
        imagePath: "widgets/viewitem"
        prefix: "hover"
        opacity: 0
        anchors.fill: parent
    }

    Item {
        id: sizes;

        property int iconSize: theme.iconSizes.toolbar;
        property int itemSize: iconSize + padding.margins.top + padding.margins.bottom;
    }

    Toolbar {
        id: toolbar;

        anchors {
            left: parent.left;
            right: parent.right;
            top: parent.top;
        }
    }

    ListView {
        id: connectionView;

        anchors {
            bottom: parent.bottom;
            left: parent.left;
            right: parent.right;
            top: toolbar.bottom;
        }
        clip: true
        model: appletProxyModel;
        currentIndex: -1;
        interactive: true;
        boundsBehavior: Flickable.StopAtBounds;
        section.property: showSections ? "Section" : "";
        section.delegate: Header { text: section }
        delegate: ConnectionItem {
            onStateChanged: {
                if (state == "expanded") {
                    connectionView.currentIndex = index;
                }
            }
        }
    }

    Component.onCompleted: {
        configChanged();
        plasmoid.addEventListener('configChanged', mainWindow.configChanged)
    }

    function configChanged() {
        var keys;
        textFont = plasmoid.readConfig("textFont");
        keys = plasmoid.readConfig("detailKeys");
        globalConfig.setDetailKeys(keys);
        var speedUnit;
        speedUnit = plasmoid.readConfig("networkSpeedUnit");
        globalConfig.setNetworkSpeedUnit(speedUnit);
        showSections = plasmoid.readConfig("showSections");
    }
}
