#!/bin/sh

repo_dir=/repo/git
work_dir=/var/www/html

# Ask for input for repository name
echo "Enter repository name: "
read repo_name

# Ask for input for deploy name
echo "Enter deploy name[$repo_name]: "
read deploy_name

if [ -z $deploy_name ]; then
    deploy_name=$repo_name
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
chown -R www-data.www-data $work_dir/$deploy_name && find $work_dir/$deploy_name/App/Runtime -type d -exec chmod g+w {} \;" >> post-receive

chmod +x post-receive

chown -R git.git $repo_dir/$repo_name.git
cd $work_dir
# mkdir $deploy_name

echo "Task completed successfully.";
echo "Your git directory $repo_dir/$repo_name.git";
echo "Your project directory: $work_dir/$deploy_name";
