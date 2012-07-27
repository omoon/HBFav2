class User
  attr_reader :name

  def initialize(dict)
    @name = dict[:name]
  end

  def profile_image_url(small = false)
    if small
      return "http://www.st-hatena.com/users/" + @name[0, 2] + "/#{name}/profile_l.gif"
    else
      return "http://www.st-hatena.com/users/" + @name[0, 2] + "/#{name}/profile.gif"
    end
  end
end