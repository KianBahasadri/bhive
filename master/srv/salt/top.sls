base:
  '*':
    - fail2ban
    - unattended_upgrades
    - wireguard
    - docker

  'master':
    - wireguard.host
    #- docker.swarm_init
    #- traefik

  'minion*':
    - wireguard.client
    - iptables
    - docker.swarm_join

