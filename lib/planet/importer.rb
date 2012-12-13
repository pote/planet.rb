class PostImporter

  def self.import(planet)
    posts_dir = planet.config.fetch('posts_directory', 'source/_posts/')
    FileUtils.mkdir_p(posts_dir)
    puts "=> Writing #{ planet.posts.size } posts to the #{ posts_dir } directory."

    planet.posts.each do |post|
      file_name = posts_dir + post.file_name

      File.open(file_name + '.markdown', "w+") { |f| f.write(post.to_s) }
    end
  end

end
