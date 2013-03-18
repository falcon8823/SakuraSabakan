require "bundler/capistrano"

# アプリケーション名
set :application, "SakuraSabakan"

# リポジトリの場所
set :repository,  "ssh://git@github.com/falcon8823/SakuraSabakan.git"
# デプロイ先
set :deploy_to,  "/usr/local/rails-app/#{application}"
set :deploy_via, :remote_cache

# Git
set :scm, :git
set :scm_verbose, true

# 設置するアカウント
set :use_sudo, false

# 本番環境
task :production do
  set :domain, "sabakan.falconsrv.net"
  set :user, "falcon"
  set :branch, "production"
  role :web, domain # 公開サーバ
  role :app, domain # 設置サーバ
  role :db,  domain, :primary => true # プライマリDBサーバ
end

# 末尾でrequireすること
require "capistrano-unicorn"

after 'deploy:start', 'unicorn:start'
after 'deploy:restart', 'unicorn:restart'

