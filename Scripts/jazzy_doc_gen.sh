#!/bin/sh

# This script generates API documentation using jazzy.
# It requires jazzy and sourcekitten.

set -e

REPO="aws-amplify/amplify-ios-maplibre.git"
RELEASE_DIR="amplify-map-libre-release"

git clone git@github.com:$REPO $(mktemp -d -t $RELEASE_DIR)
TEMP_DIR=$_

echo "Temporary Directory: $TEMP_DIR"

generate_docs() {
    cd $TEMP_DIR
    git checkout gh-pages
    git reset --hard origin/main
    sourcekitten doc --module-name AmplifyMapLibreAdapter -- -scheme AmplifyMapLibreAdapter-Package -destination generic/platform=iOS > adapter.json
    sourcekitten doc --module-name AmplifyMapLibreUI -- -scheme AmplifyMapLibreAdapter-Package -destination generic/platform=iOS > adapter-ui.json
    jazzy --sourcekitten adapter.json,adapter-ui.json --config .jazzy.yml
    rm adapter.json adapter-ui.json
    git add docs
    git commit -m "chore: update API docs [skip ci]"
    git push --force
}

generate_docs

set +e
