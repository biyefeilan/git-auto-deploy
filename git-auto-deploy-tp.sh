#!/bin/sh

repo_dir=/repo/git/
temp_dir=`pwd`

read -p "Input work dir[$temp_dir]: " work_dir
if [ -z "$work_dir" ]; then
    work_dir=$temp_dir
else
    cd $work_dir
fi


# Ask for input for repository name
repo_name=$1
if [ -z "$repo_name" ]; then 
    echo "Input repository name: "
    read repo_name
    if [ -z "$repo_name" ]; then
        echo "Repository name required!"
        exit 1
    fi
fi

echo $repo_name | grep -q ".git$"
if [ $? -ne 0 ]; then
    repo_name=$repo_name.git
fi

echo > .gitignore <<EOF
.idea
*.log
composer.lock
EOF

if [ -d "$work_dir/App/Runtime" ]; then
     echo > $work_dir/App/Runtime/.gitignore <<EOF
*
!.gitignore
EOF
fi

git init --separate-git-dir=$repo_dir$repo_name 
git=git --git-dir=$repo_dir$repo_name
$git add *
$git commit -m "first commit"

echo "Task completed successfully.";
echo "Your git directory $repo_dir$repo_name";
echo "Your project directory: $work_dir/$deploy_name";
