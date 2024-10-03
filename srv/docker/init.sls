docker:
  pkg.installed:
    - name: docker.io

docker_service:
  service.running:
    -name: docker
    -enable: true

