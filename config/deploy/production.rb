# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :app, %w{deployer@46.101.232.186}
role :web, %w{deployer@46.101.232.186}
role :db,  %w{deployer@46.101.232.186}

set :rails_env, :production
set :stage, :production

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

server '46.101.232.186', user: 'deployer', roles: %w{web app db}, primary: true


# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
set :ssh_options, {
   keys: %w(/home/oleg/.ssh/id_rsa),
   forward_agent: true,
   auth_methods: %w(publickey password),
   port: 4321
}
