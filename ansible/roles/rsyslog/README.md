rsyslog
=======

[![Build Status](https://travis-ci.org/kbrebanov/ansible-rsyslog.svg?branch=master)](https://travis-ci.org/kbrebanov/ansible-rsyslog)

Installs and configures rsyslog

Requirements
------------

This role requires Ansible 1.9 or higher.

Role Variables
--------------

| Name                                    | Default                       | Description                                   |
|:----------------------------------------|:------------------------------|:----------------------------------------------|
| rsyslog_repeated_msg_reduction          | "on"                          | Enable/disable repeated msg redution          |
| rsyslog_action_file_default_template    | RSYSLOG_TraditionalFileFormat | Action file default template                  |
| rsyslog_klog_permit_non_kernel_facility | "on"                          | Enable/disable logging of non kernel facility |
| rsyslog_udp_enable                      | false                         | Enable or disable rsyslog to listen on UDP    |
| rsyslog_udp_address                     | 127.0.0.1                     | Address to bind to for UDP                    |
| rsyslog_udp_port                        | 514                           | UDP port                                      |
| rsyslog_tcp_enable                      | false                         | Enable or disable rsyslog to listen on TCP    |
| rsyslog_tcp_port                        | 514                           | TCP port                                      |
| rsyslog_apps                            | []                            | List of hashes for app specific configs       |

Dependencies
------------

None

Example Playbook
----------------

Install rsyslog
```yaml
- hosts: all
  roles:
    - kbrebanov.rsyslog
```

Install rsyslog and disable repeated msg reduction
```yaml
- hosts: all
  vars:
    rsyslog_repeated_msg_reduction: "off"
  roles:
    - kbrebanov.rsyslog
```

Install rsyslog and configure logging options for HAProxy
```yaml
- hosts: all
  vars:
    rsyslog_apps:
      - name: haproxy
        priority: 49
        lines:
          - "local0.* -/var/log/haproxy_0.log"
          - "local1.* -/var/log/haproxy_1.log"
          - "& ~"
  roles:
    - kbrebanov.rsyslog

```

License
-------

BSD

Author Information
------------------

Kevin Brebanov
