/*
 * Copyright (C) 2020 by Savoir-faire Linux
 * Author: Aline Gondim Santos <aline.gondimsantos@savoirfairelinux.com>
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
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.14
import QtQuick.Controls 2.15
import QtQuick.Controls.Universal 2.12
import QtGraphicalEffects 1.14
import QtQuick.Controls.Styles 1.4
import net.jami.Models 1.0
import net.jami.Adapters 1.0
import Qt.labs.platform 1.1
import "../../commoncomponents"

ColumnLayout {
    id: root

    Connections {
        target: settingsViewRect

        function onStopBooth() {
            stopBooth()
        }

        function onSetAvatar() {
            setAvatar()
        }
    }

    function updateAccountInfo() {
        displayNameLineEdit.text = SettingsAdapter.getCurrentAccount_Profile_Info_Alias()
    }

    function isPhotoBoothOpened() {
        return currentAccountAvatar.takePhotoState
    }

    function setAvatar() {
        currentAccountAvatar.setAvatarPixmap(SettingsAdapter.getAvatarImage_Base64(currentAccountAvatar.boothWidth), SettingsAdapter.getIsDefaultAvatar())
    }

    function stopBooth() {
        currentAccountAvatar.stopBooth()
    }

    Text {
        Layout.fillWidth: true
        Layout.preferredHeight: JamiTheme.preferredFieldHeight

        text: qsTr("Profile")
        elide: Text.ElideRight

        font.pointSize: JamiTheme.headerFontSize
        font.kerning: true

        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    PhotoboothView {
        id: currentAccountAvatar

        Layout.fillWidth: true
        Layout.alignment: Qt.AlignCenter

        boothWidth: 180

        onImageAcquired: SettingsAdapter.setCurrAccAvatar(imgBase64)

        onImageCleared: {
            SettingsAdapter.clearCurrentAvatar()
            setAvatar()
        }
    }

    MaterialLineEdit {
        id: displayNameLineEdit

        Layout.alignment: Qt.AlignCenter
        Layout.preferredHeight: JamiTheme.preferredFieldHeight
        Layout.preferredWidth: JamiTheme.preferredFieldWidth

        font.pointSize: JamiTheme.textFontSize
        font.kerning: true

        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        padding: 8

        onEditingFinished: AccountAdapter.setCurrAccDisplayName(text)
    }
}