base:
  '*':
    - docker
    - fail2ban
    - wireguard

  'master':
    - wireguard.host
    - docker.swarm_init
    - traefik

  'minion*':
    - unattended_upgrades
    - wireguard.client
    - iptables
    - docker.swarm_join

