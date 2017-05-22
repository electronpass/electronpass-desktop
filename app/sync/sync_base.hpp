/*
This file is part of ElectronPass.

ElectronPass is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ElectronPass is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with ElectronPass. If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef SYNC_BASE_HPP
#define SYNC_BASE_HPP

#include <QObject>
#include "sync_manager.hpp"

enum class SyncManagerStatus;

class SyncBase {
public:
    virtual ~SyncBase() {}
    virtual void download_wallet() = 0;
    virtual void upload_wallet(const std::string&) = 0;
    virtual void abort() = 0;

signals:
    virtual void wallet_downloaded(const std::string& wallet, SyncManagerStatus success) = 0;
    virtual void wallet_uploaded(SyncManagerStatus success) = 0;
};

#endif // SYNC_BASE_HPP
