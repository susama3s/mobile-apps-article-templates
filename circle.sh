#!/bin/bash -xe

# check if there are changes
if [[ `git status --porcelain` ]]; then
    git status
    git log -1
    git config --global user.name "GuardianAndroid"
    git config --global user.email "guardian.android@gmail.com"
    git config --global push.default simple
    git status
    git add .
    git status
    git commit -m "Generate files for release"
    git checkout release
    git reset --hard origin/release
    git merge -X theirs master -m "Merge master into release"
    git log -1
    npm --no-git-tag-version version patch 
    git add package.json
    PACKAGE_VERSION=$(node -p "require('./package.json').version")
    git commit -m "$(printf "Update to version $PACKAGE_VERSION")"
    git push origin release
    npm publish --access public
fi
