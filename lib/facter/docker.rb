require 'facter'
require 'json'

docker = {}
docker['network'] = {}
docker['network']['managed_interfaces'] = []
interfaces = Facter.value(:interfaces).split(',')
docker_network_names = (Facter::Util::Resolution.exec("docker network ls --format='{{.Name}}'")).split(/\n+/)
docker_network_ids = (Facter::Util::Resolution.exec("docker network ls --format='{{.ID}}'")).split(/\n+/)
docker_network_names.each do |network|
  inspect = JSON.parse(Facter::Util::Resolution.exec("docker network inspect #{network}"))
  docker['network'][network] = inspect[0]
  network_id = docker['network'][network]['Id'][0..11]
  interfaces.each do |iface|
    #puts iface + " " + network if iface =~ /#{network_id}/
    docker['network'][network]['real_interface'] = iface if iface =~ /#{network_id}/
    docker['network']['managed_interfaces'].push iface if iface =~ /#{network_id}/
  end
end
Facter.add(:docker) do
  setcode do
    docker
  end
end
