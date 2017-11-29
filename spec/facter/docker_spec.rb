require 'spec_helper'

describe Facter::Util::Fact do
  before do
    Facter.clear
  end
  describe 'docker' do
    context 'with value' do
      before :each do
        expect(Facter.value(:interfaces)).to {
          'br-19a6ebf6f5a5,br-c5810f1e3113,docker0,eno16780032,lo'
        }
        expect(Facter::Util::Resolution).to receive(:exec).with("docker network ls --format='{{.Name}}'") {'
          bridge
          host
          none
          dummyapp_default
        '}
        expect(Facter::Util::Resolution).to receive(:exec).with("docker network ls --format='{{.ID}}'") {'
          d9e04c239a53
          ca5f5f36c8d7
          23d26bed53a8
          c5810f1e3113
        '}
      end
      it do
        expect(Facter.fact(:docker).value).to eq('{
  network => {
    managed_interfaces => [
      "br-c5810f1e3113"
    ],
    bridge => {
      Name => "bridge",
      Id => "d9e04c239a5353b3ece6f2c9ab4f318aa4e23e52de37df1b8b84897ae5269e40",
      Created => "2017-08-23T11:04:57.365447259-04:00",
      Scope => "local",
      Driver => "bridge",
      EnableIPv6 => false,
      IPAM => {
        Driver => "default",
        Options => ,
        Config => [
          {
            Subnet => "172.17.0.0/16",
            Gateway => "172.17.0.1"
          }
        ]
      },
      Internal => false,
      Attachable => false,
      Containers => {},
      Options => {
        com.docker.network.bridge.default_bridge => "true",
        com.docker.network.bridge.enable_icc => "true",
        com.docker.network.bridge.enable_ip_masquerade => "true",
        com.docker.network.bridge.host_binding_ipv4 => "0.0.0.0",
        com.docker.network.bridge.name => "docker0",
        com.docker.network.driver.mtu => "1500"
      },
      Labels => {}
    },
    host => {
      Name => "host",
      Id => "ca5f5f36c8d7311d43a5f84147719b5437c8d3a80b502498a543cc279ee348f7",
      Created => "2017-02-16T12:45:25.180741832-05:00",
      Scope => "local",
      Driver => "host",
      EnableIPv6 => false,
      IPAM => {
        Driver => "default",
        Options => ,
        Config => []
      },
      Internal => false,
      Attachable => false,
      Containers => {},
      Options => {},
      Labels => {}
    },
    none => {
      Name => "none",
      Id => "23d26bed53a8c458e40268f559ce7b5bb40d1a9a090c7acfc931d9fc2c4eb169",
      Created => "2017-02-16T12:45:25.171935752-05:00",
      Scope => "local",
      Driver => "null",
      EnableIPv6 => false,
      IPAM => {
        Driver => "default",
        Options => ,
        Config => []
      },
      Internal => false,
      Attachable => false,
      Containers => {},
      Options => {},
      Labels => {}
    },
    dummyapp_default => {
      Name => "dummyapp_default",
      Id => "c5810f1e3113e8856c0615d9484a7491b7367ea80c6c32a2e5118069fe4af565",
      Created => "2017-11-28T11:37:08.744115226-05:00",
      Scope => "local",
      Driver => "bridge",
      EnableIPv6 => false,
      IPAM => {
        Driver => "default",
        Options => ,
        Config => [
          {
            Subnet => "172.18.0.0/16",
            Gateway => "172.18.0.1"
          }
        ]
      },
      Internal => false,
      Attachable => false,
      Containers => {},
      Options => {},
      Labels => {},
      real_interface => "br-c5810f1e3113"
    }
  }
}')
      end
    end
  end
end
