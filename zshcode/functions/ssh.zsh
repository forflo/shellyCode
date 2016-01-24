#ssh

if [ -z "$SSH_AGENT_PID" ]; then #in case of reloading the profile
    eval $(ssh-agent -s)
fi
