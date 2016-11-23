#!/bin/sh

repo_dir=/repo/git
work_dir=/var/www/html

# Ask for input for repository name
repo_name=$1
if [ -z $repo_name ]; then 
    echo "Enter repository name: "
    read repo_name
    if [ -z $repo_name ]; then
        echo "Repository name required!"
        exit 1
    fi
fi

# Ask for input for deploy name
deploy_name=$2
if [ -z $deploy_name ]; then
    echo "Enter deploy name[$repo_name]: "
    read deploy_name
    if [ -z $deploy_name ]; then
        deploy_name=$repo_name
    fi
fi

cd $repo_dir
# Make git directory for a repository
mkdir $repo_name.git
cd $repo_name.git
# Initialize git and create hook script
git init --bare
cd hooks
touch post-receive
echo "#!/bin/sh
git --work-tree=$work_dir/$deploy_name --git-dir=$repo_dir/$repo_name.git checkout -f
chown -R www-data.www-data $work_dir/$deploy_name && find $work_dir/$deploy_name/App/Runtime -type d -exec chmod g+s {} \;" >> post-receive

chmod +x post-receive

chown -R git.git $repo_dir/$repo_name.git
cd $work_dir
mkdir $deploy_name && chown -R www-data.www-data $deploy_name && chmod g+ws $deploy_name

echo "Task completed successfully.";
echo "Your git directory $repo_dir/$repo_name.git";
echo "Your project directory: $work_dir/$deploy_name";
