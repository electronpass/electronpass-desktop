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

    reverse_permutaton_vector = std::vector<int>(item_ids.size());
    for (unsigned int i = 0; i < item_ids.size(); ++i) {
        reverse_permutaton_vector[permutation_vector[i]] = i;
    }
}

int DataHolder::search(const QString& s) const {
    return 0;
}

void DataHolder::stop_search() const {
}
