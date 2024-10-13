cd
rsync -avz ./bhive/ salt.bahasadri.com:bhive/
ssh salt.bahasadri.com 'cd /home/ubuntu/bhive/; sudo ./add_master.sh'
