#!/usr/bin/env bash
# taken from https://github.com/samoshkin/tmux-plugin-sysstat/

set -u
set -e

LC_NUMERIC=C

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

get_tmux_option() {
  local option="$1"
  local default_value="$2"
  local option_value="$(tmux show-option -gqv "$option")"
  if [ -z "$option_value" ]; then
    echo "$default_value"
  else
    echo "$option_value"
  fi
}

set_tmux_option() {
  local option="$1"
  local value="$2"
  tmux set-option -gq "$option" "$value"
}

is_osx() {
  [ $(uname) == "Darwin" ]
}

is_linux(){
  [ $(uname -s) == "Linux" ]
}

is_freebsd() {
  [ $(uname) == FreeBSD ]
}

command_exists() {
  local command="$1"
  type "$command" >/dev/null 2>&1
}

calc() {
  local stdin;
  read -d '' -u 0 stdin;
  awk "BEGIN { print $stdin }";
}

fcomp() {
  awk -v n1="$1" -v n2="$2" 'BEGIN {if (n1<n2) exit 0; exit 1}'
}

function get_size_scale_factor(){
  local size_unit="$1"
  case "$size_unit" in 
    G) echo 1048576;;
    M) echo 1024;;
    K) echo 1;;
  esac
}

function get_size_format(){
  local size_unit="$1"
  case "$size_unit" in 
    G) echo '%.1f%s';;
    M) echo '%.0f%s';;
    K) echo '%.0f%s';;
  esac
}

mem_view_tmpl=$(get_tmux_option "@sysstat_mem_view_tmpl" '#{mem.pused}#[default]')

mem_medium_threshold=$(get_tmux_option "@sysstat_mem_medium_threshold" "75")
mem_stress_threshold=$(get_tmux_option "@sysstat_mem_stress_threshold" "90")

mem_color_low=$(get_tmux_option "@sysstat_mem_color_low" "green")
mem_color_medium=$(get_tmux_option "@sysstat_mem_color_medium" "yellow")
mem_color_stress=$(get_tmux_option "@sysstat_mem_color_stress" "red")

size_unit=$(get_tmux_option "@sysstat_mem_size_unit" "G")

get_mem_color() {
  local mem_pused=$1

  if fcomp "$mem_stress_threshold" "$mem_pused"; then
    echo "$mem_color_stress";
  elif fcomp "$mem_medium_threshold" "$mem_pused"; then
    echo "$mem_color_medium";
  else
    echo "$mem_color_low";
  fi
}

print_mem() {
  local mem_usage
  local scale
  local size_format

  if is_osx; then
    mem_usage=$(get_mem_usage_osx)
  elif is_linux; then 
    mem_usage=$(get_mem_usage_linux)
  elif is_freebsd; then
    mem_usage=$(get_mem_usage_freebsd)
  fi

  local size_scale="$(get_size_scale_factor "$size_unit")"
  local size_format="$(get_size_format "$size_unit")"

  # Extract free and used memory in MiB, calculate total and percentage
  local mem_free=$(echo $mem_usage | awk -v scale="$size_scale" '{ print $1/scale }')
  local mem_used=$(echo $mem_usage | awk -v scale="$size_scale" '{ print $2/scale }')
  local mem_total=$(echo "$mem_free + $mem_used" | calc)
  local mem_pused=$(echo "($mem_used / $mem_total) * 100" | calc)
  local mem_pfree=$(echo "($mem_free / $mem_total) * 100" | calc)

  # Calculate colors for mem and swap
  local mem_color=$(get_mem_color "$mem_pused")

  local mem_view="$mem_view_tmpl"
  mem_view="${mem_view//'#{mem.used}'/$(printf "$size_format" "$mem_used" "$size_unit")}"
  mem_view="${mem_view//'#{mem.pused}'/$(printf "%.0f%%" "$mem_pused")}"
  mem_view="${mem_view//'#{mem.free}'/$(printf "$size_format" "$mem_free" "$size_unit")}"
  mem_view="${mem_view//'#{mem.pfree}'/$(printf "%.0f%%" "$mem_pfree")}"
  mem_view="${mem_view//'#{mem.total}'/$(printf "$size_format" "$mem_total" "$size_unit")}"  
  mem_view="${mem_view//'#{mem.color}'/$(echo "$mem_color" | awk '{ print $1 }')}"
  mem_view="${mem_view//'#{mem.color2}'/$(echo "$mem_color" | awk '{ print $2 }')}"
  mem_view="${mem_view//'#{mem.color3}'/$(echo "$mem_color" | awk '{ print $3 }')}"

  echo "$mem_view"
}


# Report like it does htop on OSX:
# used = active + wired
# free = free + inactive + speculative + occupied by compressor
# see `vm_stat` command
get_mem_usage_osx(){

  local page_size=$(sysctl -nq "vm.pagesize")
  vm_stat | awk -v page_size=$page_size -F ':' '
  BEGIN { free=0; used=0 }

  /Pages active/ || 
    /Pages wired/ { 
      gsub(/^[ \t]+|[ \t]+$/, "", $2); used+=$2;
    }
  /Pages free/ || 
    /Pages inactive/ || 
    /Pages speculative/ || 
    /Pages occupied by compressor/ { 
      gsub(/^[ \t]+|[ \t]+$/, "", $2); free+=$2;
    }
  END { print (free * page_size)/1024, (used * page_size)/1024 }
  '
}

# Relies on vmstat, but could also be done with top on FreeBSD
get_mem_usage_freebsd(){
  vmstat -H | tail -n 1 | awk '{ print $5, $4 }'
}

get_mem_usage_linux(){
  </proc/meminfo awk '
  BEGIN { total=0; free=0; }
  /MemTotal:/ { total=$2; }

  /MemFree:/ { free+=$2; }
  /Buffers:/ { free+=$2; }
  /Cached:/ { free+=$2; }
  /MemAvailable:/ { free=$2; exit;}
  END { print free, total-free }
  '
}

main() {
  print_mem
}

main
