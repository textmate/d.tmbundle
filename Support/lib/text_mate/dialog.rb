module TextMate
  class Dialog
    attr_reader :env

    def initialize(env)
      @env = env
    end

    def register_images(images)
      images = images.map { |k, v| "#{k} = #{v}" }.join(' ')
      icon_plist = "{ #{images} }"
      system(env.dialog, 'images', '--register', icon_plist)
    end
  end
end
