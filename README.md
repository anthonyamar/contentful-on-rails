# 💎 Contentful on Rails

## Description

Contentful on Rails is a starter template using Rails 6, PostgreSQL, Webpacker, React JS, Bootstrap, Bugsnag for bug monitoring and Contentful as a headless CMS. I like this stack for small project with basics needs from CMS such as blogs, portoflios, ecommerce and things like this. 

This is the perfect stack for people who want the power from Rails and React JS and the simplicity of a free headless CMS to get started quickly on new projects. 

Disclaimers : I don't get any benefits from Contentful for this, neither from Bugsnag. I choosed this headless CMS because it is the only one I know that have a real free plan while a Ruby gem for Rails. Same for Bugsnag.

## Requirements

This template currently works with:

- Rails 6.0.x
- PostgreSQL

If you need help setting up a Ruby development environment, check out [this tutorial from dev.to](https://dev.to/vvo/a-rails-6-setup-guide-for-2019-and-2020-hf5)

You'll need : 

- A [Contentful](https://www.contentful.com/) account
- A [Bugsnag](https://www.bugsnag.com/) account

## Get started

This template assume that you're already familiar with Rails and Contentful. If it's your first time into the world of headless CMS, espacialy Contentful, please checkout [their documentation.](https://www.contentful.com/developers/docs/)  

1. Clone the repository on your local machine 

   ```bash
   git clone https://github.com/anthonyamar/contentful-on-rails.git
   ```

2. Create a file `config/application.yml` file for handling API keys and yours. 

   ```yml
   # config/application.yml is the file for handling API keys with Figaro.
   # Replace values with your own API keys and keep them secret.
   
   contentful_access_token: "your_contentful_access_token"
   contentful_space_id: "your_contentful_space_id"
   bugsnag_api_key: "your_bugsnag_api_key" 
   ```

3. Migrate the DB and launch the server.

   ```bash
   rails db:migrate
   rails server
   ```

You're all good ! 👌

## Usage

Contentful work with models, just like Rails. To start using Contentful on Rails, you need to create your first model and add some things to link it to your Contentful's model and display it content on your website. 

#### Example with Article

Let's say you're creating a blog, with articles. Assuming that you already created your Article model in Contentful, we need to get the content from the Contentful Delivery app to display it on our application. 

1. Generate an Article model. This will create a migration that create an Article table with a `contentful_id` string field.

   ```bash
   rails g model Article contentful_id:string
   rails db:migrate
   ```

2. We need now tell to the Article model that it will render content from Contentful. In `app/models/article.rb`

   ```ruby
   class Article < ApplicationRecord
     
     # ============= Contentful =============
     # This model is manage on Contentful. 
     # Which mean, the most of the data structure is defined on Contentful space.
     # The fields store in our DB are used to pair our model to Contentful's model.
     
     include ContentfulRenderable
     CONTENT_TYPE = "article" # This is the content_type_id from Contentful. 
     
     # ============= relationships =============
     # Article(content_type: article) can has_one Author(content_type: author)
     # After a Article object is rendered, we can do article.author to get the Author object
     # It works just as any Active Model records, 
   	# but the relations are entirely made in Contentful.
     
     # ============= validations =============
     
     validates :contentful_id, presence: true, uniqueness: true
     
   end
   ```

3. Generate an articles_controller file to render content. Theses two methods come from `models/concerns/contentful_renderable.rb`

   ```ruby
   class Blog::ArticlesController < ApplicationController
   
     def index
       @articles = Article.render_all
     end
     
     def show
       # Instead of using the id, we're using the contentful_id for internal links in articles.
       @article = Article.find_by!(contentful_id: params[:id]).render
     end
    
   end
   ```

4. In your view (show e.g). We're using the Kramdown gem to convert Markdown from Contentful to HTML in our view.

   ```erb
   <!-- Display the title -->
   <h1><%= @article.title %></h1>
   
   <!-- Display rich text/Markdown body content with Kramdown gem -->
   <p><%= Kramdown::Document.new(@article.body).to_html.html_safe %></p>
   
   <!-- Display images stored on Contentful assets server. -->
   <%= image_tag(@article.image.image_url) %>
   
   <!-- Display the name of the author (or any fields from any relation) -->
   <p><%= @article.author.name %></p>
   
   <!-- Link to the article. Here .id return the contentful id -->
   <%= link_to "Article", article_path(@article.id) %>
   ```

5. That's it, you created your first blog. Everything around is just Rails. 

#### Customize

If you want to perform more complex requests, such as filtering, limit, scopes and things like that, you can take a look at the file at `models/concerns/contentful_renderable.rb` that handle the rendering logic using the contentful client. 

- [Official contentful gem](https://github.com/contentful/contentful.rb)
- [Contentful Documentation](https://www.contentful.com/developers/docs/)

## Contribute

You can contribute on this repository by adding issues or directly making pull requests. 

