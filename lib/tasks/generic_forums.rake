namespace :gf do
  task :create_rules => :environment do
    ["about", "rules"].each do |r|
      File.open("#{Rails.root}/app/views/home/#{r}.html.erb", "w") do |f|
        f.write Markdown.new(File.read("#{Rails.root}/app/views/home/_#{r}.md")).to_html
      end
    end
  end
end
