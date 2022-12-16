#!/bin/bash
gitUser="tigernaxoJr"
gitRepo="quickstart"
hugo new site ${gitRepo}
cd ${gitRepo}/
git init
git clone https://github.com/hugo-toha/toha.git themes/toha
rm -rf themes/toha/.git
#sed -i "1,1s=http://localhost:1313/=https://${gitUser}.github.io/${gitRepo}/=g" config.toml

echo "public" >> .gitignore

echo "#!/bin/bash" >>  run-commit-gh-pages.sh
echo "rm -rf public/" >> run-commit-gh-pages.sh
echo "hugo" >> run-commit-gh-pages.sh
echo "cd public && git add --all && git commit -m \"Publishing to gh-pages\" && cd .." >> run-commit-gh-pages.sh

echo "#!/bin/bash" >>  run-push-gh-pages.sh
echo "git push origin gh-pages" >> run-push-gh-pages.sh

chmod a+x run-commit-gh-pages.sh
chmod a+x run-push-gh-pages.sh

git add .
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:${gitUser}/${gitRepo}.git 

git checkout --orphan gh-pages
git reset --hard
git commit --allow-empty -m "Initializing gh-pages branch"
git push origin gh-pages
git checkout main

#if [ "`git status -s`" ]
#then
#    echo "The working directory is dirty. Please commit any pending changes."
#    exit 1;
#fi
#
#echo "Deleting old publication"
#rm -rf public
#mkdir public
#git worktree prune
#rm -rf .git/worktrees/public/
#
#echo "Checking out gh-pages branch into public"
#git worktree add -B gh-pages public origin/gh-pages
#
#echo "Removing existing files"
#rm -rf public/*
#
#echo "Generating site"
#hugo
#
#echo "Updating gh-pages branch"
#cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"
#
##echo "Pushing to github"
#git push --all

FILE="run_publish.sh"
cat > $FILE <<- EOF
#!/bin/bash
if [ "\`git status -s\`" ]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to gh-pages (publish.sh)"

#echo "Pushing to github"
git push --all
EOF
chmod a+x ${FILE}
./${FILE}
