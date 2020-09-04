/*
 * Copyright (C) 2020 by Savoir-faire Linux
 * Author: Yang Wang <yang.wang@savoirfairelinux.com>
 * Author: Sébastien blin <sebastien.blin@savoirfairelinux.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.14
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.14
import QtGraphicalEffects 1.15
import net.jami.Models 1.0
import net.jami.Adapters 1.0

import "../../constant"
import "../../commoncomponents"

Rectangle {
    id: root

    signal welcomePageRedirectPage(int toPageIndex)
    signal leavePage

    color: JamiTheme.backgroundColor

    ColumnLayout {
        anchors.centerIn: parent

        spacing: layoutSpacing

        Text {
            id: welcomeLabel

            Layout.alignment: Qt.AlignCenter
            Layout.preferredHeight: contentHeight

            text: qsTr("Welcome to")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.pointSize: 30
            font.kerning: true
        }

        Label {
            id: welcomeLogo

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 300
            Layout.preferredHeight: 150

            color: "transparent"
            background: Image {
                id: logoIMG
                source: "qrc:/images/logo-jami-standard-coul.png"
                fillMode: Image.PreserveAspectFit
                mipmap: true
            }
        }

        MaterialButton {
            id: newAccountButton

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: preferredWidth
            Layout.preferredHeight: preferredHeight

            text: qsTr("Create a jami account")
            fontCapitalization: Font.AllUppercase
            toolTipText: qsTr("Create new Jami account")
            source: "qrc:/images/default_avatar_overlay.svg"
            color: JamiTheme.buttonTintedBlue
            hoveredColor: JamiTheme.buttonTintedBlueHovered
            pressedColor: JamiTheme.buttonTintedBluePressed

            onClicked: {
                welcomePageRedirectPage(1)
            }
        }

        MaterialButton {
            id: fromDeviceButton

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: preferredWidth
            Layout.preferredHeight: preferredHeight

            text: qsTr("Import from another device")
            fontCapitalization: Font.AllUppercase
            toolTipText: qsTr("Import account from other device")
            source: "qrc:/images/icons/devices-24px.svg"
            color: JamiTheme.buttonTintedBlue
            hoveredColor: JamiTheme.buttonTintedBlueHovered
            pressedColor: JamiTheme.buttonTintedBluePressed

            onClicked: {
                welcomePageRedirectPage(5)
            }
        }

        MaterialButton {
            id: fromBackupButton

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: preferredWidth
            Layout.preferredHeight: preferredHeight

            text: qsTr("Connect from backup")
            fontCapitalization: Font.AllUppercase
            toolTipText: qsTr("Import account from backup file")
            source: "qrc:/images/icons/backup-24px.svg"
            color: JamiTheme.buttonTintedBlue
            hoveredColor: JamiTheme.buttonTintedBlueHovered
            pressedColor: JamiTheme.buttonTintedBluePressed

            onClicked: {
                welcomePageRedirectPage(3)
            }
        }

        MaterialButton {
            id: showAdvancedButton

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: preferredWidth
            Layout.preferredHeight: preferredHeight

            text: qsTr("Show advanced")
            fontCapitalization: Font.AllUppercase
            toolTipText: qsTr("Show advanced options")
            color: JamiTheme.buttonTintedBlue
            hoveredColor: JamiTheme.buttonTintedBlueHovered
            pressedColor: JamiTheme.buttonTintedBluePressed
            outlined: true

            hoverEnabled: true

            ToolTip.delay: Qt.styleHints.mousePressAndHoldInterval
            ToolTip.visible: hovered
            ToolTip.text: qsTr("Show advanced options")

            onClicked: {
                connectAccountManagerButton.visible = !connectAccountManagerButton.visible
                newSIPAccountButton.visible = !newSIPAccountButton.visible
            }
        }

        MaterialButton {
            id: connectAccountManagerButton

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: preferredWidth
            Layout.preferredHeight: preferredHeight

            visible: false

            text: qsTr("Connect to management server")
            fontCapitalization: Font.AllUppercase
            toolTipText: qsTr("Login to account manager")
            source: "qrc:/images/icons/router-24px.svg"
            color: JamiTheme.buttonTintedBlue
            hoveredColor: JamiTheme.buttonTintedBlueHovered
            pressedColor: JamiTheme.buttonTintedBluePressed

            onClicked: {
                welcomePageRedirectPage(6)
            }
        }

        MaterialButton {
            id: newSIPAccountButton

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: preferredWidth
            Layout.preferredHeight: preferredHeight

            visible: false

            text: qsTr("Create a sip account")
            fontCapitalization: Font.AllUppercase
            toolTipText: qsTr("Create new SIP account")
            source: "qrc:/images/default_avatar_overlay.svg"
            color: JamiTheme.buttonTintedBlue
            hoveredColor: JamiTheme.buttonTintedBlueHovered
            pressedColor: JamiTheme.buttonTintedBluePressed

            onClicked: {
                welcomePageRedirectPage(2)
            }
        }
    }

    HoverableButton {
        id: backButton

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 20

        Connections {
            target: LRCInstance

            function onAccountListChanged() {
                backButton.visible = UtilsAdapter.getAccountListSize()
            }
        }

        width: 35
        height: 35

        visible: UtilsAdapter.getAccountListSize()
        radius: 30

        backgroundColor: root.color
        onExitColor: root.color

        source: "qrc:/images/icons/ic_arrow_back_24px.svg"
        toolTipText: qsTr("Back")

        onClicked: leavePage()
    }
}
