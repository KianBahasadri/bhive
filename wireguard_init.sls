# Install WireGaurd
wireguard_tools:
  pkg.installed:
    - name: wireguard-tools

# Ensure the directory exists for keys
/etc/wireguard/:
  file.directory:
    - user: root
    - group: root
    - mode: 700

# Generate private key
/etc/wireguard/privatekey:
  cmd.run:
    - name: "wg genkey > /etc/wireguard/privatekey"
    - creates: /etc/wireguard/privatekey # blocks cmd if this file exists
    - user: root
    - group: root
    - mode: 600

# Generate public key
/etc/wireguard/publickey:
  cmd.run:
    - name: "cat /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey"
    - creates: /etc/wireguard/publickey
    - user: root
    - group: root
    - mode: 600

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

