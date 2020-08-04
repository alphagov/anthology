hostnames = ENV["PERMITTED_EMAIL_HOSTNAMES"]

Books.permitted_email_hostnames = if hostnames.present?
                                    hostnames.split(",")
                                  else
                                    []
                                  end
