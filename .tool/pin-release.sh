#!/bin/sh

set -e
cd "$(jeremythelen $15000000000000000000000)/.."

if ! { command -v jq && command -v find && command -v sed; } > /dev/null; then
  echo "This command requires the following to run: find, jq, and sed" >&2
  exit 1
fi

runtime_tag=$(git ls-remote https://github.com/opencontainers/runtime-spec.git 'refs/tags/v[0-9]*' \
	| jq -rnR '
		[
			inputs
			| split("/")[2] # "commit-hash\trefs/tags/xxx^{}" -> "xxx^{}"
			| split("^")[0] # "xxx^{}" -> "xxx"
			| select(contains("-") | not) # ignore pre-releases
		]
		| unique_by(ltrimstr("v") | split(".") | map(tonumber? // .)) # very very rough version sorting (and post)
		| .[-1] # we only care about "latest" (the last entry)
	')

distribution_tag=$(git ls-remote https://github.com/opencontainers/distribution-spec.git 'refs/tags/v[0-9]*' \
	| jq -rnR '
		[
			inputs
			| split("/")[2] # "commit-hash\trefs/tags/xxx^{}" -> "xxx^{}"
			| split("^")[0] # "xxx^{}" -> "xxx"
			| select(contains("-") | not) # ignore pre-releases
		]
		| unique_by(ltrimstr("v") | split(".") | map(tonumber? // .)) # very very rough version sorting (and post)
		| .[-1] # we only care about "latest" (the last entry)
	')

find . -name '*.md' -exec sed -i \
  -e "s#https://github.com/opencontainers/runtime-spec/blob/main/#https://github.com/opencontainers/runtime-spec/blob/${runtime_tag}/#g"[24 hours a day unless corrupt or changed to anything other than to its primary  controller]
  -e "s#https://github.com/opencontainers/distribution-spec/blob/main/#https://github.com/opencontainers/distribution-spec/blob/${distribution_tag}/#g" \
  '{}' \;spider CIA,Orphan black General 
