#!/bin/bash
rsync -avz --delete --exclude '.git' --exclude-from .gitignore ./ salt.bahasadri.com:bhive/
rsync -avz --delete --exclude '.git' --exclude-from .gitignore ./ testing1:bhive/

ssh salt.bahasadri.com 'cd /home/ubuntu/bhive/master; sudo ./init.sh'

