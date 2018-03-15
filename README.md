# Deb package for nginx compiled with mruby

From: github.com/matsumoto-r/ngx_mruby.git


# Install the package

```bash
sudo add-apt-repository ppa:0k53d-karl-f830m/openssl
sudo apt-get update
sudo apt-get install -y openssl

cd /tmp
curl -sfLO https://raw.githubusercontent.com/foliohd/nginx_mruby/master/nginx-mruby_1.0.0-1_amd64.deb
sudo dpkg -i --force-overwrite nginx-mruby_1.0.0-1_amd64.deb
```
