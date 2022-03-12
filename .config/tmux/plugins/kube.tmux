#!/usr/bin/env bash

# Kubernetes status line for tmux
# Displays current context and namespace

# Copyright 2018 Jon Mosco
#
#  Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Default values for the plugin
KUBE_TMUX_BINARY="${KUBE_TMUX_BINARY:-kubectl}"
KUBE_TMUX_SYMBOL_ENABLE="${KUBE_TMUX_SYMBOL_ENABLE:-true}"
KUBE_TMUX_SYMBOL_DEFAULT="${KUBE_TMUX_SYMBOL_DEFAULT:-\u2388 }"
KUBE_TMUX_SYMBOL_USE_IMG="${KUBE_TMUX_SYMBOL_USE_IMG:-false}"
KUBE_TMUX_NS_ENABLE="${KUBE_TMUX_NS_ENABLE:-true}"
KUBE_TMUX_DIVIDER="${KUBE_TMUX_DIVIDER-:}"
KUBE_TMUX_SYMBOL_COLOR="${KUBE_TMUX_SYMBOL_COLOR-blue}"
KUBE_TMUX_CTX_COLOR="${KUBE_TMUX_CTX_COLOR-red}"
KUBE_TMUX_NS_COLOR="${KUBE_TMUX_NS_COLOR-cyan}"
KUBE_TMUX_KUBECONFIG_CACHE="${KUBECONFIG}"
KUBE_TMUX_UNAME=$(uname)
KUBE_TMUX_LAST_TIME=0

_kube_tmux_binary_check() {
  command -v "$1" > /dev/null
}

_kube_tmux_symbol() {
  if ((BASH_VERSINFO[0] >= 4)) && [[ $'\u2388 ' != '\u2388 ' ]]; then
    KUBE_TMUX_SYMBOL=$'\u2388 '
    KUBE_TMUX_SYMBOL_IMG=$'\u2638 '
  else
    KUBE_TMUX_SYMBOL=$'\xE2\x8E\x88 '
    KUBE_TMUX_SYMBOL_IMG=$'\xE2\x98\xB8 '
  fi

  if [[ ${KUBE_TMUX_SYMBOL_USE_IMG} == true ]]; then
    KUBE_TMUX_SYMBOL="${KUBE_TMUX_SYMBOL_IMG}"
  fi

  echo "${KUBE_TMUX_SYMBOL}"
}

_kube_tmux_split() {
  type setopt > /dev/null 2>&1 && setopt SH_WORD_SPLIT
  local IFS=$1
  echo "$2"
}

_kube_tmux_file_newer_than() {
  local mtime
  local file=$1
  local check_time=$2

  if [[ $KUBE_TMUX_UNAME == "Linux" ]]; then
    mtime=$(stat -c %Y "${file}")
  elif [[ $KUBE_TMUX_UNAME == "Darwin" ]]; then
    # Use native stat in cases where gnutils are installed
    mtime=$(/usr/bin/stat -f %m "$file")
  fi

  [[ ${mtime} -gt ${check_time} ]]
}

_kube_tmux_update_cache() {
  if ! _kube_tmux_binary_check "${KUBE_TMUX_BINARY}"; then
    # No ability to fetch context/namespace; display N/A.
    KUBE_TMUX_CONTEXT="BINARY-N/A"
    KUBE_TMUX_NAMESPACE="N/A"
    return
  fi
  if [[ ${KUBECONFIG} != "${KUBE_TMUX_KUBECONFIG_CACHE}" ]]; then
    # User changed KUBECONFIG; unconditionally refetch.
    KUBE_TMUX_KUBECONFIG_CACHE=${KUBECONFIG}
    _kube_tmux_get_context_ns
    return
  fi

  # kubectl will read the environment variable $KUBECONFIG
  # otherwise set it to ~/.kube/config
  local conf
  for conf in $(_kube_tmux_split : "${KUBECONFIG:-${HOME}/.kube/config}"); do
    [[ -r ${conf} ]] || continue
    if _kube_tmux_file_newer_than "${conf}" "${KUBE_TMUX_LAST_TIME}"; then
      _kube_tmux_get_context_ns
      return
    fi
  done
}

export KUBECONFIG
kube_tmux() {
  # local pty
  local context
  local contexts
  local KUBE_TMUX
  local ns
  if [ -z $4 ]; then
    exit
  fi
  # TODO: refactor me figure our why kubectl is not available here
  asdf shell kubectl 1.20.9

  # pty=$(basename "$4")
  KUBECONFIG="/Users/stuart.s.robinson/.config/tmux/kube/config.${4}"
  if [ ! -f "$KUBECONFIG" ]; then
    cp ~/.kube/config "$KUBECONFIG"
  fi
  contexts=$(
    /Users/stuart.s.robinson/.asdf/shims/kubectl config get-contexts --kubeconfig="$KUBECONFIG"
  )
  if [ -z "$contexts" ]; then
    echo "no contexts: $(which kubectl)"
    exit
  fi
  context=$(
    awk '$1 == "*" { print $2 }' <<< "$contexts"
  )
  ns=$(
    awk '$1 == "*" { print $5 }' <<< "$contexts"
  )

  # Symbol / Context
  if grep prod <<< "$context" &> /dev/null; then
    KUBE_TMUX+="#[fg=red]$(_kube_tmux_symbol)#[fg=colour${1}]"
    KUBE_TMUX+="#[fg=red]${context}"
  elif grep staging <<< "$context" &> /dev/null; then
    KUBE_TMUX+="#[fg=orange]$(_kube_tmux_symbol)#[fg=colour${1}]"
    KUBE_TMUX+="#[fg=yellow]${context}"
  else
    KUBE_TMUX+="#[fg=blue]$(_kube_tmux_symbol)#[fg=colour${1}]"
    KUBE_TMUX+="#[fg=blue]${context}"
  fi

  # Namespace
  if [[ -n ${KUBE_TMUX_DIVIDER} ]]; then
    KUBE_TMUX+="#[fg=colour250]${KUBE_TMUX_DIVIDER}"
  fi
  KUBE_TMUX+="#[fg=white]${ns}"

  cp -f "$KUBECONFIG" ~/.kube/config

  echo "$KUBE_TMUX"
  # echo "ns: $ns 4: $4 I: $I KC: $KC KUBECONFIG: $KUBECONFIG"
}

kube_tmux "$@"
