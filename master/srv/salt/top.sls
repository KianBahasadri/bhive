base:
  {% do salt["log.debug"]("$$$$ random log item") %}
  '*':
    - fail2ban
    - unattended_upgrades
    - docker

  'master':
    - wireguard
    - wireguard.host
    - docker.automation_api
    - wireguard.inotify
    #- docker.swarm_init
    #- traefik

  'minion*':
    - wireguard
    #- iptables
    #- docker.swarm_join

