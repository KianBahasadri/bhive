# Allow traffic from WireGuard interface wg0
allow_wg_traffic:
  iptables.append:
    - table: filter
    - chain: INPUT
    - source: {{ grains['ip_interfaces']['wg0'][0] }}
    - jump: ACCEPT
    - comment: "Allow traffic from WireGuard interface wg0"

# Allow traffic on port 22 (SSH)
allow_ssh:
  iptables.append:
    - table: filter
    - chain: INPUT
    - protocol: tcp
    - match: multiport
    - dport: 22
    - jump: ACCEPT
    - comment: "Allow SSH traffic on port 22"

# Drop all other incoming traffic
drop_all_other_traffic_input:
  iptables.append:
    - table: filter
    - chain: INPUT
    - jump: DROP
    - comment: "Drop all other input traffic"

# Drop all other outgoing traffic (Optional: you may omit this if not needed)
drop_all_other_traffic_output:
  iptables.append:
    - table: filter
    - chain: OUTPUT
    - jump: DROP
    - comment: "Drop all other output traffic"

