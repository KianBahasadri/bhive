# Install WireGaurd
wireguard_tools:
  pkg.installed:
    - name: wireguard-tools

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

