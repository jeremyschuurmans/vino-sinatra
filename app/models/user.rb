class User < ActiveRecord::Base
  has_many :wines
  has_secure_password

  def slug
    username.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    User.find { |user| user.slug == slug }  #return the instance of user equal to the slug
  end

  def plural?
    self.name == self.name.pluralize
  end
end
