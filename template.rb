#
# Add the clean application
#
git :init
git :add => "."
git :commit => %Q{-m 'Initial commit'}

#
# Remove gems from the Gemfile which we don't want anything to do with
#
original_gemfile = File.read("Gemfile")
new_gemfile = original_gemfile.split("\n").select { |line| line =~ /\A\s*[a-z]/ }
gems_to_remove = ['turbolinks', 'jbuilder', 'sdoc']
new_gemfile = new_gemfile.reject do |line|
  line =~ /gem ['"](#{gems_to_remove.join('|')})['"]/
end
File.open("Gemfile", 'w') { |f| f.write(new_gemfile.join("\n"))}

#
# Add gems
#
gem 'haml', '~> 4.0.5'
gem 'nifty-utils', '~> 1.0.2'
gem 'nilify_blanks', '~> 1.1.0'
gem 'authie', '~> 1.0.0'
gem 'annotate', '~> 2.6.5'
gem 'kaminari', '~> 0.16.1'
gem 'chronic', '~> 0.10.2'
gem 'dynamic_form'
gem 'activevalidators'
gem 'bcrypt', '~> 3.1.7'
gem 'rails_env_config', '~> 1', :group => :development

#
# Replace the default template with a HAML one
#
inside "app/views/layouts" do
  run "rm application.html.erb"
  file "application.html.haml", <<-CODE
!!!
%html
  %head
    %title #{@page_title}
    = javascript_include_tag 'application'
    = stylesheet_link_tag 'application'
    = csrf_meta_tags
  %body
    = flash_display
    = yield  
CODE
end

#
# Copy the default CSS to SCSS
#
inside "app/assets/stylesheets" do
  run "mv application.css application.scss"
end

#
# Copy the default JS to coffeescript
#
inside "app/assets/javascripts" do
  file_contents = File.read("application.js").gsub(/\/\//, '##')
  File.open("application.coffee", "w") { |f| f.write(file_contents) }
  run "rm application.js"
end

#
# Remove turbolinks from application.coffee
#
inside "app/assets/javascripts" do
  content = File.readlines("application.coffee").reject do |line|
    line =~ /\A##= require turbolinks/
  end
  File.open("application.coffee", 'w') { |f| f.write(content.join) }
end

#
# Disable all generators
#
environment <<-CODE
config.generators do |g|
      g.orm             :active_record
      g.test_framework  false
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
    end
CODE

#
# Add autoload path
#
environment 'config.autoload_paths += %W(#{config.root}/lib)'

#
# Add a default environment.yml for configuration
#
run "echo 'config/environment.yml' >> .gitignore"
file "config/environment.yml", "#EXAMPLE_VAR: Hello there!\n"

#
# Commit before we begin
#
git :add => "."
git :commit => %Q{-m 'Setup application'}
