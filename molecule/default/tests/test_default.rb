# frozen_string_literal: true

# Molecule managed

describe file('/etc/hosts') do
  its('owner') { should eq 'root' }
  its('group') { should eq 'root' }
  its('mode') { should cmp '0644' }
end

# Verify dependencies

packages_list = %w(
  conntrack-tools
  ipset
  socat
)

packages_list.each do |installed|
  describe package("#{installed}"), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end
end

module_list = %w(
  nf_conntrack
)

module_list.each do |module_enabled|
  describe kernel_module("#{module_enabled}") do
    it { should be_loaded }
  end
end

bin_file_list = %w(
  /opt/cni/bin/bridge
  /opt/cni/bin/dhcp
  /opt/cni/bin/firewall
  /opt/cni/bin/host-device
  /opt/cni/bin/ipvlan
  /opt/cni/bin/macvlan
  /opt/cni/bin/ptp
  /opt/cni/bin/sbr
  /opt/cni/bin/static
  /opt/cni/bin/vlan
)

bin_file_list.each do |file_present|
  describe file("#{file_present}") do
    it { should be_file }
    it { should be_mode 0755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_readable.by('owner') }
    it { should be_readable.by('group') }
    it { should be_readable.by('others') }
    it { should be_executable.by('owner') }
    it { should be_executable.by('group') }
    it { should be_executable.by('others') }
  end
end

conf_list = %w(
  /etc/cni/net.d/10-bridge.conf
  /etc/cni/net.d/99-loopback.conf
  /etc/containerd/config.toml
  /etc/systemd/system/containerd.service
)

conf_list.each do |file_present|
  describe file("#{file_present}") do
    it { should be_file }
    it { should be_mode 0640 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_readable.by('owner') }
    it { should be_readable.by('group') }
    it { should be_writable.by('owner') }
  end
end

describe service('containerd') do
  it { should be_running }
  it { should be_enabled }
end

describe file('/etc/modules-load.d/containerd.conf') do
  its(:content) { should match /^overlay$/ }
  its(:content) { should match /^br_netfilter$/ }
end

describe file('/etc/containerd/config.toml') do
  its(:content)  { should match /^    snapshotter = "overlayfs"$/ }
  its(:content)  { should match /^      runtime_type = "io.containerd.runtime.v1.linux"$/ }
  its(:content)  { should match /^      runtime_engine = "\/usr\/local\/bin\/runc"$/ }
  its(:content)  { should match /^      runtime_root = ""$/ }
end

describe file('/etc/sysctl.d/99-kubernetes-cri.conf') do
  its(:content) { should match /^net\.bridge\.bridge-nf-call-iptables  = 1$/ }
  its(:content) { should match /^net\.ipv4\.ip_forward                 = 1$/ }
  its(:content) { should match /^net\.bridge\.bridge-nf-call-ip6tables = 1$/ }
end

describe file('/etc/systemd/system/containerd.service') do
  its(:content) { should match /^\[Unit\]$/ }
  its(:content) { should match /^Description=containerd container runtime$/ }
  its(:content) { should match /^Documentation=https:\/\/containerd.io$/ }
  its(:content) { should match /^After=network.target$/ }
  its(:content) { should match /^\[Service\]$/ }
  its(:content) { should match /^ExecStartPre=\/sbin\/modprobe overlay$/ }
  its(:content) { should match /^ExecStart=\/bin\/containerd$/ }
  its(:content) { should match /^Restart=always$/ }
  its(:content) { should match /^RestartSec=5$/ }
  its(:content) { should match /^Delegate=yes$/ }
  its(:content) { should match /^KillMode=process$/ }
  its(:content) { should match /^OOMScoreAdjust=-999$/ }
  its(:content) { should match /^LimitNOFILE=1048576$/ }
  its(:content) { should match /^LimitNPROC=infinity$/ }
  its(:content) { should match /^LimitCORE=infinity$/ }
  its(:content) { should match /^\[Install\]$/ }
  its(:content) { should match /^WantedBy=multi-user.target$/ }
end

describe file('/etc/cni/net.d/10-bridge.conf') do
  its(:content) { should match /^ +"name": "bridge",$/ }
  its(:content) { should match /^ +"type": "bridge",$/ }
  its(:content) { should match /^ +"bridge": "cnio0",$/ }
  its(:content) { should match /^ +"isGateway": true,$/ }
  its(:content) { should match /^ +"ipMasq": true,$/ }
  its(:content) { should match /^ +"ipam": \{$/ }
  its(:content) { should match /^ +"type": "host-local",$/ }
  its(:content) { should match /^ +[{"subnet": "[0-9]{1,2,3}\.[0-9]{1,2,3}\.[0-9]{1,2,3}\.[0-9]{1,2,3}\/[0-9]{2}"}]$/ }
  its(:content) { should match /^ +"routes": \[\{"dst": "0.0.0.0\/0"\}\]$/ }
end

describe file('/etc/cni/net.d/99-loopback.conf') do
  its(:content) { should match /^ +"cniVersion": "[0-9.]+",$/ }
  its(:content) { should match /^ +"name": "lo",$/ }
  its(:content) { should match /^ +"type": "loopback"$/ }
end
