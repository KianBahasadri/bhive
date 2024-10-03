install_fail2ban:
  pkg.installed:
    -name: fail2ban

fail2ban:
  service.running:
    -enable: True



