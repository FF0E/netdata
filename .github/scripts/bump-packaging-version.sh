#!/bin/sh

VERSION="$(git describe 2>/dev/null || cat packaging/version)"
echo "$VERSION" > packaging/version
git add -A
git ci -m "[netdata nightly] $VERSION"
