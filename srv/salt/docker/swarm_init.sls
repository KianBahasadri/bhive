docker_swarm_init:
  swarm.swarm_init:
    - advertise_addr: {{ grains['ip_interfaces']['wg0'][0] }}
    - listen_addr: '0.0.0.0'
    - force_new_cluster: False
