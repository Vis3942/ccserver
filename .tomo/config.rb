plugin "git"
plugin "env"
plugin "bundler"
plugin "rails"
plugin "nodenv"
plugin "puma"
plugin "rbenv"
plugin "./plugins/ccserver.rb"

host "deployer@54.145.143.16"

set application: "ccserver"
set deploy_to: "/var/www/%{application}"
set nodenv_node_version: "14.2.0"
set nodenv_yarn_version: "1.22.4"
set git_url: "https://Vis3942:SiSavakthi^9*81*Inf@github.com/Vis3942/ccserver.git"
set git_branch: "main"
set git_exclusions: %w[
  .tomo/
  spec/
  test/
]
set env_vars: {
  RACK_ENV: "production",
  RAILS_ENV: "production",
  RAILS_LOG_TO_STDOUT: "1",
  RAILS_SERVE_STATIC_FILES: "1",
  DATABASE_URL: :prompt,
  SECRET_KEY_BASE: :prompt,
  RDS_DB_NAME: "ccserver_production",
  RDS_USERNAME: "ccserveruser",
  RDS_PASSWORD: "SiSavakthi^bc1154a28b*Inf",
  RDS_HOSTNAME: "database-1.c5vduxq3dc4y.us-east-1.rds.amazonaws.com",
  RDS_PORT: "3306",
  NODE_ENV: "production"
}
set linked_dirs: %w[
  log
  node_modules
  public/assets
  public/packs
  tmp/cache
  tmp/pids
  tmp/sockets
]

set rbenv_ruby_version: "2.6.6"
set puma_host: "127.0.0.1"

setup do
  run "env:setup"
  run "core:setup_directories"
  run "git:clone"
  run "git:create_release"
  run "core:symlink_shared"
  run "nodenv:install"
  run "rbenv:install"
  run "bundler:upgrade_bundler"
  run "bundler:config"
  run "bundler:install"
  run "rails:db_create"
  run "rails:db_structure_load"
  run "rails:db_seed"
  run "puma:setup_systemd"
end

deploy do
  run "env:update"
  run "git:create_release"
  run "core:symlink_shared"
  run "core:write_release_json"
  run "bundler:install"
  run "rails:db_migrate"
  run "rails:db_seed"
  run "rails:assets_precompile"
  run "core:symlink_current"
  run "puma:restart"
  run "puma:check_active"
  run "core:clean_releases"
  run "bundler:clean"
  run "core:log_revision"
end
