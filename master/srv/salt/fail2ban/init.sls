fail2ban_install:
  pkg.installed:
    - name: fail2ban

fail2ban_service:
  service.running:
    - name: fail2ban
    - enable: True

