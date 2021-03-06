# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

define win_firewall::open_local_port (
    String  $fw_display_name,
    Integer $port,
    String $remote_ip,
    Boolean $reciprocal,
) {

    # Resource from puppet-windows_firewall

    windows_firewall::exception { "allow_${fw_display_name}_in":
        ensure       => present,
        direction    => 'in',
        action       => 'allow',
        enabled      => true,
        protocol     => 'TCP',
        local_port   => $port,
        remote_ip    => 'any',
        display_name => "${fw_display_name}_IN",
        description  => "ALLOWED ${fw_display_name} in. [${port}]",
    }
    if $reciprocal {
        windows_firewall::exception { "allow_${fw_display_name}_out":
            ensure       => present,
            direction    => 'out',
            action       => 'allow',
            enabled      => true,
            protocol     => 'TCP',
            local_port   => $port,
            remote_ip    => 'any',
            display_name => "${fw_display_name}_OUT",
            description  => "ALLOWED ${fw_display_name} out. [${port}]",
        }
    }
}
