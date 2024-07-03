#!/usr/bin/env sh

app_root=~/hello
script_path=${app_root}/deploy.sh
git_repo=cao7113/hello-api-elixir

mkdir -p $app_root  
script_url="https://raw.githubusercontent.com/${git_repo}/main/run/deploy.sh"
if [ ! -e $script_path ]; then
  wget -q -O $script_path $script_url
  chmod +x $script_path
  echo "Setup deploy-script into ${script_path} from ${script_url}"
else 
  echo "Use existed deploy-script: ${script_path}, manually delete it when need update"
fi

echo "## Deploy as following"
echo "$script_path v0.1.35 $app_root bin/hello_api cao7113/hello-api-elixir 3"