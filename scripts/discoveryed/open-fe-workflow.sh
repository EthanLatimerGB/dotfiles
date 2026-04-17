 !/usr/bin/env bash

SESSION="CC-FE"
FRONTEND_DIR=~/de-sandbox/apps/careers-app/

# Attach if session already exists
if tmux has-session -t $SESSION 2>/dev/null; then
  tmux attach -t $SESSION
  exit
fi

# Window 1: FE editor
tmux new-session -d -s $SESSION -n "editor" -c $FRONTEND_DIR
tmux send-keys -t $SESSION:1 "cd $FRONTEND_DIR && nvim" Enter

# Window 2: FE server
tmux new-window -t $SESSION -n "server" -c $FRONTEND_DIR
tmux send-keys -t $SESSION:2 "cd $FRONTEND_DIR && npm run serve" Enter  

# Window 3: Claude
tmux new-window -t $SESSION -n "claude"
tmux send-keys -t $SESSION:3 "cd $FRONTEND_DIR && claude" ENTER

# Window 4: General terminal, usually used for git
tmux new-window -t $SESSION -n "git"
tmux send-keys -t $SESSION:4 "cd $FRONTEND_DIR" ENTER

# Focus the FE editor on attach
tmux select-window -t $SESSION:1
tmux attach -t $SESSION
