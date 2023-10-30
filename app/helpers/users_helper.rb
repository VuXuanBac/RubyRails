module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for user, size: Settings.gravatar_size
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = format Settings.gravatar_template,
                          id: gravatar_id, size: size
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end
