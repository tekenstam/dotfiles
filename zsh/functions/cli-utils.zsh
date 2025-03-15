# Command-line utility functions
# Inspired by popular dotfiles repositories

# Create a new directory and enter it
mkd() {
  mkdir -p "$@" && cd "$_"
}

# Find files by name
ff() {
  find . -type f -name "$1"
}

# Find directories by name
fd() {
  find . -type d -name "$1"
}

# Create a data URL from a file
dataurl() {
  local mimeType=$(file -b --mime-type "$1")
  if [[ $mimeType == text/* ]]; then
    mimeType="${mimeType};charset=utf-8"
  fi
  echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Start an HTTP server from a directory
server() {
  local port="${1:-8000}"
  python3 -m http.server "$port"
}

# Get external IP address
myip() {
  curl -s https://ifconfig.me
}

# Get local IP addresses
localip() {
  ifconfig | grep "inet " | grep -v 127.0.0.1 | awk '{print $2}'
}

# Show disk usage of current directory, sorted by size
ducks() {
  du -cksh * | sort -hr
}

# Show directory size
dirsize() {
  du -sh "$@"
}

# Show top processes by memory usage
topmem() {
  ps aux | sort -nr -k 4 | head -10
}

# Show top processes by CPU usage
topcpu() {
  ps aux | sort -nr -k 3 | head -10
}

# Calculator
calc() {
  echo "$*" | bc -l
}

# Extract archives
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)  tar xjf $1   ;;
      *.tar.gz)   tar xzf $1   ;;
      *.bz2)      bunzip2 $1   ;;
      *.rar)      unrar x $1   ;;
      *.gz)       gunzip $1    ;;
      *.tar)      tar xf $1    ;;
      *.tbz2)     tar xjf $1   ;;
      *.tgz)      tar xzf $1   ;;
      *.zip)      unzip $1     ;;
      *.Z)        uncompress $1;;
      *.7z)       7z x $1      ;;
      *)          echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Create a new git repo
ginit() {
  git init && git add . && git commit -m "Initial commit"
}

# Generate a random password
genpasswd() {
  local length=${1:-16}
  LC_ALL=C tr -dc 'A-Za-z0-9_!@#$%^&*()\-+=' < /dev/urandom | head -c "$length" | xargs
}

# Find largest files in a directory
findlarge() {
  local size=${1:-"+100M"}
  find . -type f -size "$size" -exec ls -lh {} \; | sort -k5 -rh | head -n 20
}

# Weather information
weather() {
  local city=${1:-$(curl -s https://ipinfo.io/city)}
  curl -s "https://wttr.in/$city?format=3"
}

# JSON pretty print
jsonpp() {
  if [ -t 0 ]; then  # argument
    python -m json.tool "$1"
  else  # pipe
    python -m json.tool
  fi
}

# Convert Unix timestamp to date
timestamp2date() {
  date -r "$1" +"%Y-%m-%d %H:%M:%S"
}

# Show current date in Unix timestamp
date2timestamp() {
  date +%s
}

# Get cheat sheet for a command
cheat() {
  curl -s "https://cheat.sh/$1"
}

# Benchmark shell startup time
shellbench() {
  local runs=${1:-10}
  local total=0
  
  for i in $(seq 1 $runs); do
    local start=$(date +%s.%N)
    zsh -i -c exit
    local end=$(date +%s.%N)
    local elapsed=$(echo "$end - $start" | bc)
    total=$(echo "$total + $elapsed" | bc)
    echo "Run $i: $elapsed seconds"
  done
  
  local average=$(echo "scale=3; $total / $runs" | bc)
  echo "Average startup time over $runs runs: $average seconds"
}

# List all listening ports
listening() {
  if [ "$OSTYPE" = "linux-gnu" ]; then
    sudo netstat -tulpn | grep LISTEN
  else
    sudo lsof -iTCP -sTCP:LISTEN -n -P
  fi
}

# Kill processes using a specific port
killport() {
  local port="$1"
  local pid=$(lsof -i tcp:"$port" | awk 'NR!=1 {print $2}')
  
  if [ -z "$pid" ]; then
    echo "No process found using port $port"
    return 1
  fi
  
  echo "Killing process $pid using port $port"
  kill -9 "$pid"
}
