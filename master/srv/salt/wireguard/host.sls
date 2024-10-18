/etc/wireguard/:
  file.directory

wireguard_genkeys:
  cmd.run:
    - name: "wg genkey > /etc/wireguard/privatekey"
    - creates: /etc/wireguard/privatekey # blocks cmd if this file exists
    - user: root
    - group: root
    - mode: 400
wireguard_genkeys2:
  cmd.run:
    - name: "cat /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey"
    - creates: /etc/wireguard/publickey

wireguard_config:
  file.managed:
    - name: /etc/wireguard/wg0.conf
    - source: salt://wireguard/wg0.conf 
    - user: root
    - group: root
    - mode: 600
  cmd.run:
    - name: "sed -i s/PRIVATE_KEY/$(cat /etc/wireguard/privatekey)/ /etc/wireguard/wg0.conf"

wireguard_interface:
  service.enabled:
    - name: wg-quick@wg0

