hostnames = ENV["PERMITTED_EMAIL_HOSTNAMES"]

if hostnames.present?
  Books.permitted_email_hostnames = hostnames.split(",")
else
  Books.permitted_email_hostnames = []
end
