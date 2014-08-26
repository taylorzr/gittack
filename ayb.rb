require 'rye'

dbc_hosts = (9..15).map{ |number| "dbc%02d.local" % number }
user = 'apprentice'
password = 'mvclover'

# rset = Rye::Set.new(parallel: true)

# dbc_hosts.each do |dbc_host|
#   box = Rye::Box.new(dbc_host, user: user, safe: false, password: password, password_prompt: false)
#   rset.add_box(box)
# end

# rset.execute("osascript -e 'set volume 7'")
# rset.execute("say 'all your base are belong to us'")

box = Rye::Box.new("dbc12.local", user: user, safe: false, password: password, password_prompt: false)
rset.execute("osascript -e 'set volume 7'")
rset.execute("say 'all your base are belong to us'")


