#!/bin/bash
set -e -o pipefail

help() {
echo "Use: $0 [-j jenkins_url] [-n slave_name] [-s secret] [-w workdir]"
exit 0
}

echo "$0 starting"
echo "arguments: $@"
jenkins_host="https://build.squid-cache.org"
slavename=""
secret=""
jnlpurl=""
workdir="$HOME/workspace"
while getopts "w:j:n:s:h" arg; do
	case $arg in
	n) slavename="${OPTARG}" ;;
	s) secret="${OPTARG}" ;;
	j) jenkins_host="${OPTARG}" ;;
	w) workdir="${OPTARG}" ;;
	*) help ;;
	esac
done
shift $((OPTIND-1))

slave_jar_url="${jenkins_host}/jnlpJars/agent.jar"
test -n "$slavename" && jnlpurl="-jnlpUrl ${jenkins_host}/computer/${slavename}/slave-agent.jnlp"
test -n "$secret" && secret="-secret $secret"


test -d "${workdir}" || mkdir -p "${workdir}"
cd ${workdir}
curl -k -o agent.jar "${slave_jar_url}"
exec java -jar agent.jar $jnlpurl $secret -workDir "${workdir}" -internalDir "remoting"
