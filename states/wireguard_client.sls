# Install WireGaurd
wireguard_tools:
  pkg.installed:
    - name: wireguard-tools

# Manage WireGuard configuration file for wg0 interface
/etc/wireguard/wg0.conf:
  file.managed:
    - source: salt://wireguard/files/wg0.conf # point this at the actual location
    - user: root
    - group: root
    - mode: 600
    - template: jinja

# Ensure the WireGuard interface is up and running
wireguard_interface_up:
  cmd.run:
    - name: wg-quick up wg0
    - unless: test -d /sys/class/net/wg0

# Ensure WireGuard service is enabled and running
wireguard_service:
  service.running:
    - name: wg-quick@wg0
    - enable: True

