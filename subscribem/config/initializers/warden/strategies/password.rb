Warden::Strategies.add(:password) do
  def valid?
    host = request.host
    subdomain = ActionDispatch::Http::URL.extract_subdomains(host, 1)
    subdomain.present? && params["user"]
  end

  def authenticate!
    if u = Subscribem::User.find_by(email: params["user"]["email"])
      u.authenticate(params["user"]["password"]) ? success!(u) : fail!
    else
      fail!
    end
  end
end