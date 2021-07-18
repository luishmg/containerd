Role Name
=========

This role where created to simplify the instalation and configuration of the containerd to be used by a kubernetes cluster.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

cntlr_cidr: "10.1.0.0/24"
cri_url: "http://192.168.1.73:8000/cri/"
cri_version: "v1.18.0"
containerd_url: "http://192.168.1.73:8000/containerd/"
containerd_version: "1.3.6"
runc_url: "http://192.168.1.73:8000/runc/"
runc_version: "v1.0.0-rc91"
cni_plugin_url: "http://192.168.1.73:8000/cni/"
cni_plugin_version: "v0.8.6"
cni_version: "0.3.1"

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
          cri_url: "https://github.com/kubernetes-sigs/cri-tools/releases/download/"
          cri_version: "v1.21.0"
          containerd_url: "https://github.com/containerd/containerd/releases/download/v"
          containerd_version: "1.3.6"
          runc_url: "https://github.com/opencontainers/runc/releases/download/"
          runc_version: "v1.0.0-rc91"
          cni_plugin_url: "https://github.com/containernetworking/plugins/releases/download/"
          cni_plugin_version: "v0.8.6"
          cni_version: "0.3.1"
          

Customize and Test
------------------

To customize this role you should install pipenv, then follow the steps bellow:

This command will install the correct version of python and the dependencies, as a virtual environment:

`pipenv install`

This command will load the virtual environment:

`pipenv shell`

Now if you want to follow the TDD patter you should go to the molecule folder and create the test for the change that you want to implement, to run the molecule full test use the command below:

`molecule test`

Tips to speedup the tests
-------------------------

As a side note you can just use the command below to run your role:

`molecule converge`

Then you can use this command to run the choosen test suit:

`molecule verify`

License
-------

BSD

Author Information
------------------

[Luis Gomes](https://github.com/luishmg/luishmg.github.io)
