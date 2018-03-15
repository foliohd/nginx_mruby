export NGX_MRUBY_SRC=/tmp/ngx_mruby
export NGINX_SRC=/tmp/ngx_mruby/build/nginx_src
export OPENSSL_SRC_VER=openssl-1.0.2l

sudo add-apt-repository ppa:0k53d-karl-f830m/openssl
sudo apt-get update
sudo apt-get install -y openssl libpcre3-dev bison libxslt-dev libgd-dev libgeoip-dev

cd /tmp
git clone git://github.com/matsumoto-r/ngx_mruby.git
cd ngx_mruby

# Set Nginx version vars
. ./nginx_version

cd build
if [ ! -e ${NGINX_SRC_VER} ]; then
  wget http://nginx.org/download/${NGINX_SRC_VER}.tar.gz
  tar xzf ${NGINX_SRC_VER}.tar.gz
fi

./configure --with-ngx-src-root=build/${NGINX_SRC_VER}
make build_mruby
make generate_gems_config

cd /tmp/ngx_mruby/build/${NGINX_SRC_VER}

./configure --with-cc-opt='-g -O2 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2' \
--with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro' \
--prefix=/usr \
--conf-path=/etc/nginx/nginx.conf \
--http-log-path=/var/log/nginx/access.log \
--error-log-path=/var/log/nginx/error.log --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid \
--add-module=/tmp/ngx_mruby --add-module=/tmp/ngx_mruby/dependence/ngx_devel_kit \
--http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
--http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi \
--http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-http_ssl_module \
--with-http_stub_status_module --with-http_realip_module --with-http_addition_module --with-http_dav_module \
--with-http_geoip_module --with-http_gzip_static_module --with-http_image_filter_module \
--with-http_sub_module --with-http_xslt_module --with-mail --with-mail_ssl_module \
--with-stream --without-stream_access_module

make

# Install and create deb package: nginx-mruby_1.0.0-1_amd64.deb
checkinstall --pkgversion=1.0.0 --pkgname=nginx-mruby -y --dpkgflags --force-overwrite make install

# Then scp the package and add to this repo.
