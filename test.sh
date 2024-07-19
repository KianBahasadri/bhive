diagnostic=$(cat <<- END
{
  "cores": 2,
  "ram": 4,
  "free_space": 400,
  "total_space": 500
}
END
)

curl -s -X POST https://bahasadri.com/add-server \
     -d "$diagnostic" \
     -H "Content-Type: application/json"
     #-o "$HOME/ssh_key.pem"
