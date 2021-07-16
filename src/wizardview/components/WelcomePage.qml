/*
 * Copyright (C) 2021 by Savoir-faire Linux
 * Author: Yang Wang <yang.wang@savoirfairelinux.com>
 * Author: Sébastien blin <sebastien.blin@savoirfairelinux.com>
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
import QtGraphicalEffects 1.14

import net.jami.Models 1.0
import net.jami.Adapters 1.0
import net.jami.Constants 1.0

import "../../commoncomponents"

Rectangle {
    id: root

    property int preferredHeight: welcomePageColumnLayout.implicitHeight

    signal scrollToBottom
    signal showThisPage

    color: JamiTheme.transparentColor

    Connections {
        target: WizardViewStepModel

        function onMainStepChanged() {
            if (WizardViewStepModel.mainStep === WizardViewStepModel.MainSteps.Initial)
                root.showThisPage()
        }
    }

    ColumnLayout {
        id: welcomePageColumnLayout

        anchors.centerIn: parent

        spacing: JamiTheme.wizardViewPageLayoutSpacing

        Text {
            id: welcomeLabel

            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: JamiTheme.wizardViewPageBackButtonMargins
            Layout.preferredHeight: contentHeight

            text: JamiStrings.welcomeTo
            color: JamiTheme.textColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            font.pointSize: JamiTheme.welcomeLabelPointSize
            font.kerning: true
        }

        ResponsiveImage {
            id: welcomeLogo

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: JamiTheme.welcomeLogoWidth
            Layout.preferredHeight: JamiTheme.welcomeLogoHeight

            source: JamiTheme.darkTheme ?
                        JamiResources.logo_jami_standard_coul_white_svg :
                        JamiResources.logo_jami_standard_coul_svg
        }

        MaterialButton {
            id: newAccountButton

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: preferredWidth
            Layout.preferredHeight: preferredHeight

            text: JamiStrings.createAJamiAccount
            fontCapitalization: Font.AllUppercase
            toolTipText: JamiStrings.createNewJamiAccount
            source: JamiResources.default_avatar_overlay_svg
            color: JamiTheme.buttonTintedBlue
            hoveredColor: JamiTheme.buttonTintedBlueHovered
            pressedColor: JamiTheme.buttonTintedBluePressed

            onClicked: WizardViewStepModel.startAccountCreationFlow(
                           WizardViewStepModel.AccountCreationOption.CreateJamiAccount)
        }

        MaterialButton {
            id: newRdvButton

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: preferredWidth
            Layout.preferredHeight: preferredHeight

            text: JamiStrings.createRV
            fontCapitalization: Font.AllUppercase
            toolTipText: JamiStrings.createNewRV
            source: JamiResources.groups_24dp_svg
            color: JamiTheme.buttonTintedBlue
            hoveredColor: JamiTheme.buttonTintedBlueHovered
            pressedColor: JamiTheme.buttonTintedBluePressed

            onClicked: WizardViewStepModel.startAccountCreationFlow(
                           WizardViewStepModel.AccountCreationOption.CreateRendezVous)
        }

        MaterialButton {
            id: fromDeviceButton

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: preferredWidth
            Layout.preferredHeight: preferredHeight

            text: JamiStrings.linkFromAnotherDevice
            fontCapitalization: Font.AllUppercase
            toolTipText: JamiStrings.importAccountFromOtherDevice
            source: JamiResources.devices_24dp_svg
            color: JamiTheme.buttonTintedBlue
            hoveredColor: JamiTheme.buttonTintedBlueHovered
            pressedColor: JamiTheme.buttonTintedBluePressed

            onClicked: WizardViewStepModel.startAccountCreationFlow(
                           WizardViewStepModel.AccountCreationOption.ImportFromDevice)
        }

        MaterialButton {
            id: fromBackupButton

            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: preferredWidth
            Layout.preferredHeight: preferredHeight

            text: JamiStrings.connectFromBackup
            fontCapitalization: Font.AllUppercase
            toolTipText: JamiStrings.importAccountFromBackup
            source: JamiResources.backup_24dp_svg
            color: JamiTheme.buttonTintedBlue
            hoveredColor: JamiTheme.buttonTintedBlueHovered
            pressedColor: JamiTheme.buttonTintedBluePressed

            onClicked: WizardViewStepModel.startAccountCreationFlow(
                           WizardViewStepModel.AccountCreationOption.ImportFromBackup)
        }

        MaterialButton {
            id: showAdvancedButton

            Layout.alignment: Qt.AlignCenter
            Layout.bottomMargin: newSIPAccountButton.visible ?
                                     0 : JamiTheme.wizardViewPageBackButtonMargins
            Layout.preferredWidth: preferredWidth
            Layout.preferredHeight: preferredHeight

            text: JamiStrings.advancedFeatures
            fontCapitalization: Font.AllUppercase
            toolTipText: JamiStrings.showAdvancedFeatures
            color: JamiTheme.buttonTintedBlue
            hoveredColor: JamiTheme.buttonTintedBlueHovered
            pressedColor: JamiTheme.buttonTintedBluePressed
            outlined: true

            hoverEnabled: true

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

            text: JamiStrings.connectJAMSServer
            fontCapitalization: Font.AllUppercase
            toolTipText: JamiStrings.createFromJAMS
            source: JamiResources.router_24dp_svg
            color: JamiTheme.buttonTintedBlue
            hoveredColor: JamiTheme.buttonTintedBlueHovered
            pressedColor: JamiTheme.buttonTintedBluePressed

            onClicked: WizardViewStepModel.startAccountCreationFlow(
                           WizardViewStepModel.AccountCreationOption.ConnectToAccountManager)
        }

        MaterialButton {
            id: newSIPAccountButton

            Layout.alignment: Qt.AlignCenter
            Layout.bottomMargin: JamiTheme.wizardViewPageBackButtonMargins
            Layout.preferredWidth: preferredWidth
            Layout.preferredHeight: preferredHeight

            visible: false

            text: JamiStrings.addSIPAccount
            fontCapitalization: Font.AllUppercase
            toolTipText: JamiStrings.createNewSipAccount
            source: JamiResources.default_avatar_overlay_svg
            color: JamiTheme.buttonTintedBlue
            hoveredColor: JamiTheme.buttonTintedBlueHovered
            pressedColor: JamiTheme.buttonTintedBluePressed

            onClicked: WizardViewStepModel.startAccountCreationFlow(
                           WizardViewStepModel.AccountCreationOption.CreateSipAccount)
        }

        onHeightChanged: scrollToBottom()
    }

    BackButton {
        id: backButton

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: JamiTheme.wizardViewPageBackButtonMargins

        Connections {
            target: LRCInstance

            function onAccountListChanged() {
                backButton.visible = UtilsAdapter.getAccountListSize()
            }
        }

        preferredSize: JamiTheme.wizardViewPageBackButtonSize

        visible: UtilsAdapter.getAccountListSize()

        onClicked: WizardViewStepModel.previousStep()
    }
}
