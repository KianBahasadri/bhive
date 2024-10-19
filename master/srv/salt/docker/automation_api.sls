load_my_custom_module:
  module.run:
    - name: saltutil.sync_all
    - refresh: True
  pip.installed:
    - name: salt
    - upgrade: true

load2:
  pip.installed:
    - name: python-on-whales
    - upgrade: true

automation_api_build:
  module.run:
    - dockercomposev2.build:
      - path: /home/ubuntu/bhive/master/compose.yml

automation_api_up:
  module.run:
    - dockercomposev2.up:
      - path: /home/ubuntu/bhive/master/compose.yml
