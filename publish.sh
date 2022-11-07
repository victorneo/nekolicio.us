#!/bin/sh

if [ "`git status -s`" ]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
git rm -rf docs

echo "Generating site"
hugo

echo "Renaming public to docs"
mv public docs

echo "Adding docs"
git add -f docs

git commit -m "Publishing to gh-pages (publish.sh)"

#echo "Pushing to github"
git push origin gh-pages
