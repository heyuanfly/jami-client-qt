/*
 * Copyright (C) 2019-2020 by Savoir-faire Linux
 * Author: Yang Wang   <yang.wang@savoirfairelinux.com>
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

#include "deviceitemlistmodel.h"

DeviceItemListModel::DeviceItemListModel(QObject* parent)
    : QAbstractListModel(parent)
{}

DeviceItemListModel::~DeviceItemListModel() {}

int
DeviceItemListModel::rowCount(const QModelIndex& parent) const
{
    if (!parent.isValid()) {
        /*
         * Count.
         */
        return LRCInstance::getCurrentAccountInfo().deviceModel->getAllDevices().size();
    }
    /*
     * A valid QModelIndex returns 0 as no entry has sub-elements.
     */
    return 0;
}

int
DeviceItemListModel::columnCount(const QModelIndex& parent) const
{
    Q_UNUSED(parent);
    /*
     * Only need one column.
     */
    return 1;
}

QVariant
DeviceItemListModel::data(const QModelIndex& index, int role) const
{
    auto deviceList = LRCInstance::getCurrentAccountInfo().deviceModel->getAllDevices();
    if (!index.isValid() || deviceList.size() <= index.row()) {
        return QVariant();
    }

    switch (role) {
    case Role::DeviceName:
        return QVariant(deviceList.at(index.row()).name);
    case Role::DeviceID:
        return QVariant(deviceList.at(index.row()).id);
    case Role::IsCurrent:
        return QVariant(deviceList.at(index.row()).isCurrent);
    }
    return QVariant();
}

QHash<int, QByteArray>
DeviceItemListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[DeviceName] = "DeviceName";
    roles[DeviceID] = "DeviceID";
    roles[IsCurrent] = "IsCurrent";
    return roles;
}

QModelIndex
DeviceItemListModel::index(int row, int column, const QModelIndex& parent) const
{
    Q_UNUSED(parent);
    if (column != 0) {
        return QModelIndex();
    }

    if (row >= 0 && row < rowCount()) {
        return createIndex(row, column);
    }
    return QModelIndex();
}

QModelIndex
DeviceItemListModel::parent(const QModelIndex& child) const
{
    Q_UNUSED(child);
    return QModelIndex();
}

Qt::ItemFlags
DeviceItemListModel::flags(const QModelIndex& index) const
{
    auto flags = QAbstractItemModel::flags(index) | Qt::ItemNeverHasChildren | Qt::ItemIsSelectable;
    if (!index.isValid()) {
        return QAbstractItemModel::flags(index);
    }
    return flags;
}

void
DeviceItemListModel::reset()
{
    beginResetModel();
    endResetModel();
}
