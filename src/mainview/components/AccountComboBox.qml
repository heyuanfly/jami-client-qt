/*
 * Copyright (C) 2020 by Savoir-faire Linux
 * Author: Mingrui Zhang <mingrui.zhang@savoirfairelinux.com>
 * Author: Andreas Traczyk <andreas.traczyk@savoirfairelinux.com>
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
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.14

import net.jami.Models 1.0
import net.jami.Adapters 1.0
import net.jami.Constants 1.0

import "../../commoncomponents"

Label {
    id: root

    signal settingBtnClicked
    property alias popup: comboBoxPopup

    // TODO: remove these refresh hacks use QAbstractItemModels correctly
    Connections {
        target: AccountAdapter

        function onCurrentAccountIdChanged() {
            root.update()
            resetAccountListModel(AccountAdapter.currentAccountId)
        }

        function onAccountStatusChanged(accountId) {
            resetAccountListModel(accountId)
        }
    }

    function resetAccountListModel(accountId) {
        accountListModel.updateAvatarUid(accountId)
        accountListModel.reset()
    }

    function togglePopup() {
        if (root.popup.opened) {
            root.popup.close()
        } else {
            root.popup.open()
        }
    }

    background: Rectangle {
        id: background

        implicitWidth: root.width
        implicitHeight: root.height
        color: root.popup.opened ?
                   Qt.lighter(JamiTheme.hoverColor, 1.0) :
                   mouseArea.containsMouse ?
                       Qt.lighter(JamiTheme.hoverColor, 1.05) :
                       JamiTheme.backgroundColor
        Behavior on color {
            ColorAnimation { duration: JamiTheme.fadeDuration }
        }

        // TODO: this can be removed when frameless window is implemented
        Rectangle {
            height: 1
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            color: JamiTheme.tabbarBorderColor
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: togglePopup()
    }

    AccountComboBoxPopup {
        id: comboBoxPopup

        Shortcut {
            sequence: "Ctrl+J"
            context: Qt.ApplicationShortcut
            onActivated: togglePopup()
        }
    }

    Connections {
        target: accountListModel

        function onModelReset() {
            avatar.updateImage(AccountAdapter.currentAccountId,
                               accountListModel.data(accountListModel.index(0, 0),
                                                     AccountListModel.PictureUid))
            avatar.presenceStatus = accountListModel.data(accountListModel.index(0, 0),
                                                          AccountListModel.Status)
            userAliasText.text = accountListModel.data(accountListModel.index(0,0),
                                                       AccountListModel.Alias)
            usernameText.text = accountListModel.data(accountListModel.index(0,0),
                                                      AccountListModel.Username)
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        spacing: 10

        AvatarImage {
            id: avatar

            Layout.preferredWidth: JamiTheme.accountListAvatarSize
            Layout.preferredHeight: JamiTheme.accountListAvatarSize
            Layout.alignment: Qt.AlignVCenter

            imageId: AccountAdapter.currentAccountId

            presenceStatus: accountListModel.data(accountListModel.index(0, 0),
                                                  AccountListModel.Status)
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 2

            Text {
                id: userAliasText

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                text: accountListModel.data(accountListModel.index(0,0),
                                            AccountListModel.Alias)
                font.pointSize: JamiTheme.textFontSize
                color: JamiTheme.textColor
                elide: Text.ElideRight
            }

            Text {
                id: usernameText

                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                visible: text.length

                text:  accountListModel.data(accountListModel.index(0,0),
                                             AccountListModel.Username)
                font.pointSize: JamiTheme.textFontSize
                color: JamiTheme.faddedLastInteractionFontColor
                elide: Text.ElideRight
            }
        }

        Row {
            id: controlRow

            spacing: 10

            Layout.preferredWidth: childrenRect.width
            Layout.preferredHeight: parent.height

            ResponsiveImage {
                id: arrowDropDown

                width: 24
                height: 24
                anchors.verticalCenter: parent.verticalCenter

                layer {
                    enabled: true
                    effect: ColorOverlay {
                        color: JamiTheme.textColor
                    }
                }

                source: !root.popup.opened ?
                            "qrc:/images/icons/expand_more-24px.svg" :
                            "qrc:/images/icons/expand_less-24px.svg"
            }


            PushButton {
                id: shareButton

                width: visible ? preferredSize : 0
                height: visible ? preferredSize : 0
                anchors.verticalCenter: parent.verticalCenter

                visible: AccountAdapter.currentAccountType === Profile.Type.RING
                toolTipText: JamiStrings.displayQRCode

                source: "qrc:/images/icons/share-24px.svg"

                normalColor: JamiTheme.backgroundColor
                imageColor: JamiTheme.textColor

                onClicked: {
                    if (visible)
                        qrDialog.open()
                }
            }

            PushButton {
                id: settingsButton

                anchors.verticalCenter: parent.verticalCenter
                source: !mainView.inSettingsView ?
                            "qrc:/images/icons/settings-24px.svg" :
                            "qrc:/images/icons/round-close-24px.svg"

                normalColor: JamiTheme.backgroundColor
                imageColor: JamiTheme.textColor
                toolTipText: !mainView.inSettingsView ?
                                 JamiStrings.openSettings :
                                 JamiStrings.closeSettings

                onClicked: {
                    settingBtnClicked()
                    background.state = "normal"
                }
            }
        }
    }

    Shortcut {
        sequence: "Ctrl+,"
        context: Qt.ApplicationShortcut
        onActivated: settingBtnClicked()
    }
}
