# $0 v0.1.1
vsn=$1
app_root=${2:-~/hello}
bin_path=${3:-bin/hello_api}

vsn_dir=${app_root}/$vsn
echo "Preparing deploy app-version=$vsn into dir: $vsn_dir"

if [ ! -d $vsn_dir ]; then 
  mkdir -p $vsn_dir
  tarfile=${app_root}/${vsn}.tar.gz
  vsn_url=https://github.com/cao7113/hello-api-elixir/releases/download/$vsn/hello_api-0.1.0.tar.gz 
  wget -q -O $tarfile $vsn_url 
  tar -C $vsn_dir -xzf $tarfile
  echo "download $vsn app into $vsn_dir from url: $vsn_url"
else 
  echo "version: $vsn_dir already existed, use it"
fi

cur_rel=$app_root/current
full_bin=$cur_rel/$bin_path

if [ -e $cur_rel ]; then
  echo try stop exist process in $cur_rel
  $full_bin stop || true
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

# clean history versions after ok