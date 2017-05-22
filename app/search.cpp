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

void DataHolder::sort_items() {
    permutation_vector = std::vector<int>(item_ids.size());
    for (unsigned int i = 0; i < item_ids.size(); ++i) permutation_vector[i] = i;

    // Sort indices based on values in item_names.
    sort(permutation_vector.begin(), permutation_vector.end(),
        [&] (int a, int b) {
            if (item_names[a] == item_names[b]) return item_subnames[a] < item_subnames[b];
            return item_names[a] < item_names[b];
        }
    );

    inverse_permutation_vector = std::vector<int>(item_ids.size());
    for (unsigned int i = 0; i < item_ids.size(); ++i) {
        inverse_permutation_vector[permutation_vector[i]] = i;
    }
}

int DataHolder::search(const QString &s) {
    searching = true;

    int best_match = -1, best_match_index = std::numeric_limits<int>::max();
    search_results = {};

    for (unsigned int i = 0; i < item_ids.size(); ++i) {
        int index = permutation_vector[i];
        int found = search_strings[index].indexOf(s, 0, Qt::CaseInsensitive);
        if (found != -1) {
            search_results.push_back(i);
            if (best_match_index > found) {
                best_match_index = found;
                best_match = i;
            }
        }
    }

    inverse_search_results = std::vector<int>(item_ids.size(), -1);
    for (unsigned int i = 0; i < search_results.size(); ++i) {
        inverse_search_results[search_results[i]] = i;
    }

    if (best_match == -1) return -1;
    return inverse_search_results[best_match];
}

void DataHolder::stop_search() {
    search_results = {};
    searching = false;
}
