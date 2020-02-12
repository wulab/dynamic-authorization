# SmartSupport Authorization
A prototype for the new authorization system in SmartSupport

## Installation

    $ bundle install
    $ rspec --color --format doc

## Usage

### Load dependencies

    >> require './lib/account'
    >> require './lib/article'
    >> require './lib/permission'
    >> require './lib/role'
    >> require './lib/user'

### Set up objects

    >> john = User.new("John")
    >> jane = User.new("Jane")
    >> account = Account.new("Acme")

### Ask for a permission

    >> john.can?(:create_article, account)
    => false
    >> jane.can?(:create_article, account)
    => false

### Grant a permission

    >> permission = Permission.new(:create_article, account)
    >> john.acquire(permission)
    >> john.can?(:create_article, account)
    => true

### Assign a role

    >> role = Role.new(:contributor)
    >> role.permit(:create_article, account)
    >> jane.acquire(role)
    >> jane.can?(:create_article, account)
    => true

### Use in a controller

    def create
      unless current_user.can?(:create_article, current_account)
        raise NotAuthorizedError
      end
      ...
    end

### Use in a view

    <% if current_user.can?(:create_article, current_account) %>
      <%= link_to "Create new article", new_article_path %>
    <% end %>
