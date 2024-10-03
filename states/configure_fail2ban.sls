install_fail2ban:
  pkg.installed:
    -name: fail2ban

configure_fail2ban:
  /etc/fail2ban/jail.local:
    file.managed:
      -source: salt://fail2ban/jail.local

fail2ban:
  service.running:
    -enable: True


