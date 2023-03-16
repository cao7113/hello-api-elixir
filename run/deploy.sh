#! /usr/bin/env sh

# ~/hello/deploy.sh v0.1.34 ~/hello bin/hello_api cao7113/hello-api-elixir 3

vsn=$1
app_root=${2:-~/hello}
bin_path=${3:-bin/hello_api}
git_repo=${4:-cao7113/hello-api-elixir}
keep_limit=${5:-3}

bin_name=$(basename $bin_path)
bare_vsn=$(echo $vsn | sed 's/^v//')
vsn_dir=${app_root}/$vsn
echo "Preparing deploy $vsn into dir: $vsn_dir"

if [ ! -d $vsn_dir ]; then 
  vsn_url=https://github.com/${git_repo}/releases/download/${vsn}/${bin_name}-${bare_vsn}.tar.gz 
  echo "Download $vsn app from url: $vsn_url"
  mkdir -p $vsn_dir
  tarfile=${app_root}/${vsn}.tar.gz
  wget -q -O $tarfile $vsn_url 
  tar -C $vsn_dir -xzf $tarfile
else 
  echo "Found existed app version: $vsn_dir, use it"
fi

cur_rel=$app_root/current
full_bin=$cur_rel/$bin_path

if [ -e $cur_rel ]; then
  $full_bin stop 2>/dev/null || true
  echo Stop old process in $cur_rel if need at $(date -Iseconds)
  rm -f $cur_rel
  echo Clean current-release old link from $cur_rel
fi

echo Link new current-release to $vsn_dir and start it at $(date -Iseconds)
ln -sf $vsn_dir $cur_rel
$full_bin daemon_iex
timeout=60
limit=$(( $timeout + 1 ))
for i in $(seq 1 $limit); do
  if [ $i -gt $timeout ]; then 
    echo "Waiting timeout, more than $timeout seconds at $(date -Iseconds)"
    exit 1
  fi

  $full_bin pid &>/dev/null
  if [ $? -eq 0 ]; then
    echo "New release=${vsn} come alive at $(date -Iseconds)"
    sleep 1
    break
  else
    echo Waiting pid alive at $(date -Iseconds)
    sleep 1
  fi
done
echo "Congrats! Deploy app to ${vsn_dir} at $(date -Iseconds)"
echo "==> bin-path: $full_bin"

## clean old versions
cd $app_root
total=$(find . -maxdepth 1 -mindepth 1 -type f -name "v*.tar.gz" | wc -l)
if [ $total -gt $keep_limit ]; then 
  old_num=$(( $total - $keep_limit ))
  for vsn in $(find . -maxdepth 1 -mindepth 1 -type f -name "v*.tar.gz" | sed 's/.*\///; s/\.tar\.gz//' | sort -V | head -n $old_num ) ; do 
    echo Cleaning old-version: $vsn
    rm -fr $app_root/$vsn
    rm -fr $app_root/$vsn.tar.gz
  done
fi
echo Keep ${keep_limit} versions from total=$total in app_root=$app_root