Role Name
=========

This role where created to simplify the instalation and configuration of the containerd to be used by a kubernetes cluster.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

cntlr_cidr: "10.1.0.0/24"
containerd_cri_url: "http://192.168.1.73:8000/cri/"
containerd_cri_version: "v1.18.0"
containerd_url: "http://192.168.1.73:8000/containerd/"
containerd_version: "1.3.6"
containerd_runc_url: "http://192.168.1.73:8000/runc/"
containerd_runc_version: "v1.0.0-rc91"
cni_plugin_url: "http://192.168.1.73:8000/cni/"
cni_plugin_version: "v0.8.6"
cni_version: "0.3.1"
containerd_templates:
  - { src: "config.toml.j2", dst: "/etc/containerd/" }
  - { src: "containerd.service.j2", dst: "/etc/systemd/system/" }
  - { src: "10-bridge.conf.j2", dst: "/etc/cni/net.d/" }
  - { src: "99-loopback.conf.j2", dst: "/etc/cni/net.d/" }
containerd_directories:
  - "/tmp/containerd"
  - "/etc/containerd"
  - "/tmp/cni"
  - "/opt/cni/bin"
  - "/etc/cni/net.d"

Example Playbook
----------------

    ---
    - name: test
      hosts: all
      become: yes
      become_user: root
      gather_facts: yes
      roles:
        - role: containerd
          cntlr_cidr: "10.1.0.0/24"
          containerd_cri_url: "http://192.168.1.73:8000/cri/"
          containerd_cri_version: "v1.18.0"
          containerd_url: "http://192.168.1.73:8000/containerd/"
          containerd_version: "1.3.6"
          containerd_runc_url: "http://192.168.1.73:8000/runc/"
          containerd_runc_version: "v1.0.0-rc91"
          cni_plugin_url: "http://192.168.1.73:8000/cni/"
          cni_plugin_version: "v0.8.6"
          cni_version: "0.3.1"

License
-------

BSD

Author Information
------------------

[Luis Gomes](https://github.com/luishmg/luishmg.github.io)
