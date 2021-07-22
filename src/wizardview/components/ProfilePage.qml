/*
 * Copyright (C) 2021 by Savoir-faire Linux
 * Author: Yang Wang <yang.wang@savoirfairelinux.com>
 * Author: Mingrui Zhang <mingrui.zhang@savoirfairelinux.com>
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
import QtQuick.Layouts 1.14
import QtQuick.Controls 2.14

import net.jami.Adapters 1.0
import net.jami.Constants 1.0
import net.jami.Helpers 1.0
import net.jami.Models 1.0

import "../../commoncomponents"

Rectangle {
    id: root

    // trigger a default avatar prior to account generation
    property string createdAccountId: "dummy"
    property int preferredHeight: profilePageColumnLayout.implicitHeight

    signal showThisPage

    function initializeOnShowUp() {
        createdAccountId = "dummy"
        clearAllTextFields()
        saveProfileBtn.spinnerTriggered = true
    }

    function clearAllTextFields() {
        aliasEdit.clear()
    }

    color: JamiTheme.backgroundColor

    Connections {
        target: WizardViewStepModel

        function onMainStepChanged() {
            if (WizardViewStepModel.mainStep === WizardViewStepModel.MainSteps.Profile) {
                initializeOnShowUp()
                root.showThisPage()
            }
        }

        function onAccountIsReady(accountId) {
            saveProfileBtn.spinnerTriggered = false
            createdAccountId = accountId
            aliasEdit.forceActiveFocus()
        }
    }

    ColumnLayout {
        id: profilePageColumnLayout

        spacing: JamiTheme.wizardViewPageLayoutSpacing

        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        RowLayout {
            spacing: JamiTheme.wizardViewPageLayoutSpacing

            Layout.topMargin: JamiTheme.wizardViewPageBackButtonMargins
            Layout.preferredWidth: saveProfileBtn.width
            Layout.alignment: Qt.AlignCenter

            Label {
                text: JamiStrings.profileSharedWithContacts
                color: JamiTheme.textColor
                font.pointSize: JamiTheme.textFontSize + 3
            }

            BubbleLabel {
                Layout.alignment: Qt.AlignRight

                text: JamiStrings.optional
                bubbleColor: JamiTheme.wizardBlueButtons
            }
        }

        PhotoboothView {
            id: setAvatarWidget

            Layout.alignment: Qt.AlignCenter

            imageId: createdAccountId
            avatarSize: 200

            onVisibleChanged: {
                if (visible)
                    LRCInstance.currentAccountAvatarSet = false
            }
        }

        MaterialLineEdit {
            id: aliasEdit

            objectName: "aliasEdit"

            property string lastFirstChar

            Layout.preferredHeight: fieldLayoutHeight
            Layout.preferredWidth: fieldLayoutWidth
            Layout.alignment: Qt.AlignCenter

            focus: visible

            selectByMouse: true
            placeholderText: {
                if (WizardViewStepModel.accountCreationOption !==
                        WizardViewStepModel.AccountCreationOption.CreateRendezVous)
                    return JamiStrings.enterYourName
                else
                    return JamiStrings.enterRVName
            }
            font.pointSize: JamiTheme.textFontSize
            font.kerning: true

            borderColorMode: MaterialLineEdit.NORMAL

            fieldLayoutWidth: saveProfileBtn.width

            onTextEdited: {
                if (LRCInstance.currentAccountAvatarSet)
                    return
                if (text.length === 0) {
                    lastFirstChar = ""
                    AccountAdapter.setCurrAccDisplayName(lastFirstChar)
                } else if (text.length == 1 && text.charAt(0) !== lastFirstChar) {
                    lastFirstChar = text.charAt(0)
                    AccountAdapter.setCurrAccDisplayName(lastFirstChar)
                }
            }
        }

        SpinnerButton {
            id: saveProfileBtn

            objectName: "saveProfileBtn"

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: preferredWidth
            Layout.preferredHeight: preferredHeight

            enabled: !spinnerTriggered
            normalText: JamiStrings.saveProfile
            spinnerTriggeredtext: {
                if (WizardViewStepModel.accountCreationOption ===
                        WizardViewStepModel.AccountCreationOption.CreateRendezVous)
                    return JamiStrings.generatingRV
                else
                    return JamiStrings.creatingAccount
            }

            onClicked: {
                AccountAdapter.setCurrAccDisplayName(aliasEdit.text)
                WizardViewStepModel.nextStep()
            }
        }

        MaterialButton {
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: preferredWidth
            Layout.preferredHeight: preferredHeight

            text: JamiStrings.skip
            enabled: saveProfileBtn.enabled
            color: enabled? JamiTheme.buttonTintedGrey : JamiTheme.buttonTintedGreyInactive
            hoveredColor: JamiTheme.buttonTintedGreyHovered
            pressedColor: JamiTheme.buttonTintedGreyPressed
            outlined: true

            onClicked: {
                AccountAdapter.setCurrentAccountAvatarBase64()
                aliasEdit.clear()
                WizardViewStepModel.nextStep()
            }
        }
    }
}
