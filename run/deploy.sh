# $0 v0.1.1 ~/hello bin/hello_api cao7113/hello-api-elixir 3

vsn=$1
app_root=${2:-~/hello}
bin_path=${3:-bin/hello_api}
git_repo=${4:-cao7113/hello-api-elixir}
keep_limit=${5:-3}

bin_name=$(basename $bin_path)
vsn_dir=${app_root}/$vsn
echo "Preparing deploy app-version=$vsn into dir: $vsn_dir"

if [ ! -d $vsn_dir ]; then 
  mkdir -p $vsn_dir
  tarfile=${app_root}/${vsn}.tar.gz
  vsn_url=https://github.com/${git_repo}/releases/download/${vsn}/${bin_name}-0.1.0.tar.gz 
  wget -q -O $tarfile $vsn_url 
  tar -C $vsn_dir -xzf $tarfile
  echo "download $vsn app into $vsn_dir from url: $vsn_url"
else 
  echo "version: $vsn_dir already existed, use it"
fi

cur_rel=$app_root/current
full_bin=$cur_rel/$bin_path

if [ -e $cur_rel ]; then
  $full_bin stop 2>/dev/null || true
  echo try stop exist process in $cur_rel
  rm -f $cur_rel
  echo clean current release old reference from $cur_rel
fi

ln -sf $vsn_dir $cur_rel
$full_bin daemon_iex
while true; do
  $full_bin pid &>/dev/null
  if [ $? -eq 0 ]; then
    $full_bin pid
    break
  else
    echo $(date) waiting pid ok
    sleep 1
  fi
done
echo "finished update app version: ${vsn} in ${vsn_dir}"
echo "entry bin-path: $full_bin with version: ${vsn}"

## clean old versions
cd $app_root
total=$(find . -maxdepth 1 -mindepth 1 -type f -name "v*.tar.gz" | wc -l)
if [ $total -gt $keep_limit ]; then 
  old_num=$(( $total - $keep_limit ))
  for vsn in $(find . -maxdepth 1 -mindepth 1 -type f -name "v*.tar.gz" | sed 's/.*\///; s/\.tar\.gz//' | sort -V | head -n $old_num ) ; do 
    echo cleaning old-version: $vsn
    rm -fr $app_root/$vsn
    rm -fr $app_root/$vsn.tar.gz
  done
fi
echo keep ${keep_limit} versions from total=$total in app_root=$app_root