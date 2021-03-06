# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class roles_profiles::profiles::network {

    case $::operatingsystem {
        'Darwin': {
            include ::macos_utils::wifi_disabled
            include ::macos_utils::bonjour_advertisements_disabled
        }
        'Windows': {

            if $facts['custom_win_location'] == 'datacenter' {
                include win_network::set_search_domain
                include win_network::disable_ipv6
            }
            if $facts['custom_win_location'] != 'datacenter' {
                $net_category = 'private'
                if $facts['custom_win_net_category'] != $net_category {
                    win_network::set_network_category { 'aws_network_category':
                        network_category => $net_category,
                    }
                }
            }
            # Bug list
            # Network category
            # https://bugzilla.mozilla.org/show_bug.cgi?id=1563287
        }
        default: {
            fail("${::operatingsystem} not supported")
        }
    }


}
