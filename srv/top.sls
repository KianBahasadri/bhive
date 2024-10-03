base:
  '*':
    - install_docker
    - configure_fail2ban

  'hub-node':
    - wireguard_host
    - docker_swarm_init
    - deploy_traefik

  'worker-node*':
    - install_unattended_upgrades
    - wireguard_client
    - configure_iptables
    - docker_swarm_join

