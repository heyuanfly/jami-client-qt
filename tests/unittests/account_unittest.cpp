/*
 * Copyright (C) 2021 by Savoir-faire Linux
 * Author: Albert Babí Oller <albert.babi@savoirfairelinux.com>
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

#include "globaltestenvironment.h"

TestEnvironment globalEnv;

/*!
 * Test fixture for AccountAdapter testing
 */
class AccountFixture : public ::testing::Test
{
public:
    // Prepare unit test context. Called at
    // prior each unit test execution
    void SetUp() override {}

    // Close unit test context. Called
    // after each unit test ending
    void TearDown() override {}
};

/*!
 * WHEN  There is no account initially.
 * THEN  Account list should be empty.
 */
TEST_F(AccountFixture, InitialAccountListCheck)
{
    auto accountListSize = globalEnv.lrcInstance->accountModel().getAccountList().size();

    ASSERT_EQ(accountListSize, 0);
}

/*!
 * WHEN  An SIP account is created.
 * THEN  The size of the account list should be one.
 */
TEST_F(AccountFixture, CreateSIPAccountTest)
{
    // AccountAdded signal spy
    QSignalSpy accountAddedSpy(&globalEnv.lrcInstance->accountModel(),
                               &lrc::api::NewAccountModel::accountAdded);

    // Create SIP Acc
    globalEnv.accountAdapter->createSIPAccount(QVariantMap());

    QVERIFY(accountAddedSpy.wait());
    QCOMPARE(accountAddedSpy.count(), 1);

    QList<QVariant> accountAddedArguments = accountAddedSpy.takeFirst();
    QVERIFY(accountAddedArguments.at(0).type() == QVariant::String);

    // Select the created account
    globalEnv.lrcInstance->setCurrentAccountId(accountAddedArguments.at(0).toString());

    auto accountListSize = globalEnv.lrcInstance->accountModel().getAccountList().size();
    ASSERT_EQ(accountListSize, 1);

    // Make sure the account setup is done
    QSignalSpy accountStatusChangedSpy(&globalEnv.lrcInstance->accountModel(),
                                       &lrc::api::NewAccountModel::accountStatusChanged);

    QVERIFY(accountStatusChangedSpy.wait());
    QCOMPARE(accountStatusChangedSpy.count(), 1);

    // Remove the account
    globalEnv.lrcInstance->accountModel().removeAccount(
        globalEnv.lrcInstance->getCurrentAccountId());

    QSignalSpy accountRemovedSpy(&globalEnv.lrcInstance->accountModel(),
                                 &lrc::api::NewAccountModel::accountRemoved);

    QVERIFY(accountRemovedSpy.wait());
    QCOMPARE(accountRemovedSpy.count(), 1);

    accountListSize = globalEnv.lrcInstance->accountModel().getAccountList().size();
    ASSERT_EQ(accountListSize, 0);
}