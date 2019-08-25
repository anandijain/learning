#!/bin/sh/

: <<'END'
Basic shell script for merging multiple repos into a single repository, keeping the histories.
Largely taken from: http://dominik.honnef.co/posts/2016/04/merging-git-repositories/

I'm new to bash so I think that this is https specific.


=== USAGE ===
1. The first argument is the path to the new repo, the directory will be created.
2. The second argument is the github username.
3. The rest of the arguments are the names of the git repos that you'd like to merge.


thats one option to try and do, but i think it might be easier just to modify this file 

so edit new repo, the git username (BASE), and then PROJECTS
=============

END


NEW_REPO=./learning_merged #$1
BASE=https://github.com/anandijain #$2
# args=($@)
PROJECTS=('sys_bio' 'career_preparation' 'neuro') #($@)

mkdir -p "$NEW_REPO"
cd "$NEW_REPO"
git init
git commit --allow-empty -m "Initial commit"
INDEX=0
for PRJ in "${PROJECTS[@]}"; do
    # if [ i == 0 || i == 1 ]; then
    #        continue
    # fi 
    git remote add "$PRJ" "$BASE/$PRJ.git"
    git fetch "$PRJ"
    git filter-branch -f --index-filter \
        'git ls-files -s | sed "s%\t\"*%&'"$PRJ"'/%" |
          GIT_INDEX_FILE=$GIT_INDEX_FILE.new git update-index --index-info &&
          mv "$GIT_INDEX_FILE.new" "$GIT_INDEX_FILE"' "$PRJ/master"
    git merge -m "Merge $PRJ" "$PRJ/master" --allow-unrelated-histories
    git remote rm "$PRJ"
    # ((INDEX++))
done
