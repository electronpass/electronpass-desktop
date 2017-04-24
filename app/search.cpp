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

#include "data_holder.hpp"

int DataHolder::search(const QString& s) {
    search_in_progress = true;
    int best_match = -1, best_match_index = std::numeric_limits<int>::max();
    found_indices = {};

    for (unsigned int i = 0; i < search_strings.size(); ++i) {
        int found = search_strings[i].indexOf(s, 0, Qt::CaseInsensitive);
        if (found != -1) {
            found_indices.push_back(i);
            if (best_match_index > found) {
                best_match = i;
                best_match_index = found;
            }
        }
    }
    return best_match;
}

void DataHolder::stop_search() {
    found_indices = {};
    search_in_progress = false;
}
