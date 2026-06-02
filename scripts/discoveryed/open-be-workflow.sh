 !/usr/bin/env bash

SESSION="CC-BE"
BACKEND_DIR=~/de-sandbox/apps/careers-api/

# Attach if session already exists
if tmux has-session -t $SESSION 2>/dev/null; then
  tmux attach -t $SESSION
  exit
fi

# Window 1: FE editor
tmux new-session -d -s $SESSION -n "editor" -c $BACKEND_DIR
tmux send-keys -t $SESSION:1 "cd $BACKEND_DIR && nvim" Enter

# Window 2: FE server
tmux new-window -t $SESSION -n "server" -c $BACKEND_DIR
tmux send-keys -t $SESSION:2 "cd $BACKEND_DIR" Enter  

# Window 3: Claude
tmux new-window -t $SESSION -n "claude"
tmux send-keys -t $SESSION:3 "cd $BACKEND_DIR && claude" ENTER

# Window 4: General terminal, usually used for git
tmux new-window -t $SESSION -n "git"
tmux send-keys -t $SESSION:4 "cd $BACKEND_DIR" ENTER

# Window 5: pg-cli 
tmux new-window -t $SESSION -n "postgres cli"
tmux send-keys -t $SESSION:4 "cd $BACKEND_DIR" ENTER

# Focus the FE editor on attach
tmux select-window -t $SESSION:1
tmux attach -t $SESSION
