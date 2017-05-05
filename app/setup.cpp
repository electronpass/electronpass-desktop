#include "setup.hpp"

Setup::Setup() {
    first_usage = globals::settings.get_first_usage();
}

bool Setup::need_setup() {
    return first_usage;
}

void Setup::finish() {
    globals::settings.set_first_usage(false);
}
