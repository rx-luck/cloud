#!/bin/bash
set -o errexit
if [ "$1" ];then
  action=$1
fi
echo "$action"
git config --global user.email "1332459572@qq.com"
git config --global user.name "rx-luck"
git config --global credential.helper store

if [ "$action" == "Build" ];then
  echo "Building..."
  currentVersion=$(npm run env | grep npm_package_version | cut -d '=' -f 2)
  echo "current version is $currentVersion"

  branch=$(git rev-parse --abbrev-ref HEAD)
  git branch --set-upstream-to origin/"$branch" "$branch"
  npm config ls
  npm ci

  if [ -d 'dist/' ]; then
    rm -rf 'dist/';
  fi

  npm run build
  node ./build.js
  cd dist/
  npm publish
  cd ../
  newVersion=$(npm version prerelease --no-git-tag-version)
  npm version
  echo "$currentVersion is built, next version $newVersion"
  git add .
  git commit -m "$currentVersion is built"
  git push

elif [[ "$action" == Release* ]];then
  echo  "Releasing..."
  branch=$(git rev-parse --abbrev-ref HEAD)
  git branch --set-upstream-to origin/"$branch" "$branch"
  npm config ls

  releaseVersion=$(npm version patch)
  git push origin "$releaseVersion"
  git checkout "$releaseVersion"
  npm version

  npm ci
  if [ -d 'dist/' ]; then
    rm -rf 'dist/';
  fi
  npm run build
  node ./build.js

  cd dist/
  ls
  if [ "$action" == "Release_npm" ];then
      echo  "Releasing npm..."
      npm publish --registry=https://registry.npmjs.org/
  else
      echo  "Releasing goEasy npm..."
      npm publish --registry=http://maven.uwantsoft.com/repository/goeasy-public-npm-releases/
  fi
  cd ../
  git checkout -f "$branch"

  nextVersion=$(npm version prerelease --no-git-tag-version)
  npm version

  echo "$releaseVersion is released, next version $nextVersion"
  git add .
  git commit -m "$releaseVersion is released"
  git push
else
  echo "No Action..."
fi

git config --global --unset user.email
git config --global --unset user.name
git config --global --unset credential.helper