#!/bin/bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

versions=( "$@" )
if [ ${#versions[@]} -eq 0 ]; then
	versions=( */ )
fi
versions=( "${versions[@]%/}" )

packagesUrl='http://nginx.org/download/'
packages="$(echo "$packagesUrl" | sed -r 's/[^a-zA-Z.-]+/-/g')"
curl -sSL "${packagesUrl}" > "$packages"

for version in "${versions[@]}"; do
	set -x
	fullVersion="$(grep '<a href="nginx-'"$version." "$packages" | grep -vE 'zip|asc' | sed -r 's!.*<a href="nginx-([^"/]+)\.tar\.gz".*!\1!' | sort -V | tail -1)"
	
	(
		set -x
		sed -ri 's/^(ENV NGINX_VERSION) .*/\1 '"$fullVersion"'/;' "$version/Dockerfile"
	)
done

rm "$packages"
