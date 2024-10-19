docker_install:
  pkg.installed:
    - name: docker.io
docker_compose_install:
  pkg.installed:
    - name: docker-compose-v2

/srv/salt/_modules:
  file.directory

docker_compose_v2_install:
  pip.installed:
    - name: python-on-whales
    - upgrade: true
  file.managed:
    - source: https://raw.githubusercontent.com/ITJamie/salt/refs/heads/dockercomposev2/salt/modules/dockercomposev2.py
    - name: /srv/salt/_modules/dockercomposev2.py
    - skip_verify: true
  saltutil.sync_modules:
    - refresh: True

docker_service:
  service.running:
    - name: docker
    - enable: true

