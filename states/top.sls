base:
  '*':
    - docker
    - fail2ban
    - wireguard

  'master':
    - wireguard.host
    - docker.swarm_init
    - traefik

  'worker-node*':
    - _unattended_upgrades
    - wireguard.client
    - iptables
    - docker.swarm_join

