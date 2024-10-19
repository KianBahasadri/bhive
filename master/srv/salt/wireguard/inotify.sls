inotify_install:
  pkg.installed:
    - name: inotify-tools
  file.managed:
    - source: salt://wireguard/start_inotify.sh
    - name: /etc/wireguard/start_inotify.sh
    - mode: 755
inotify_up:
  file.managed:
    - source: salt://wireguard/wg-inotify.service
    - name: /etc/systemd/system/wg-inotify.service
  service.running:
    - name: 'wg-inotify'
    - enable: true

