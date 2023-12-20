# Dynamic Authorization
A prototype for the new authorization system in SmartSupport

## Background

### How roles work currently

* The roles table is a join table between accounts and users
* There are 5 predefined roles: admin, moderator, approver, contributor, and agent
* Each predefined role can be enabled by setting a corresponding boolean value
* Authorizations are enforced by checking user roles in controller before filters

### What if we use Pundit?

Say, we define the following article policy with Pundit:

    class ArticlePolicy < ApplicationPolicy
      def update?
        role.is_admin? || role.is_moderator?
      end
    end

For the client account, we want to allow an Editor to update an article. However, the role doesn't exist yet. We decide to migrate the roles table to add it.

    class AddIsEditorToRoles < ActiveRecord::Migration[5.1]
      def change
        add_column :roles, :is_editor, :boolean
      end
    end

Finally, we update the article policy to:

    class ArticlePolicy < ApplicationPolicy
      def update?
        role.is_admin? || role.is_moderator? || role.is_editor?
      end
    end

Although tedious but it seems to work, right? I doubt it. The problem is that the article policy is static and enforced on all accounts. The Editor role might not exist in another account or could have a different set of permissions.

### Why Pundit isn't the solution

* Pundit works by predefining a policy for each resource
* The new requirement states that custom roles can be created on an account-by-account basis
* It is hard to add a custom role as that would mean adding a new column to the roles table
* Pundit policies are static and enforced on all accounts

### How will this prototype solve the problem?

In the prototype, a role is just a collection of permissions so we define a permission first.

    permission = Permission.new(:update_article, account)

Then, we define roles that have the above permission.

    admin = Role.new(:admin)
    moderator = Role.new(:moderator)
    admin.assign(permission)
    moderator.assign(permission)

Which we could assign to a particular user.

    john = User.new("John")
    john.assign(moderator)

Given we want to allow an Editor to update an article on the client account, we just need to add another role and assign it on another user.

    editor = Role.new(:editor)
    editor.permit(:update_article, account)
    jane = User.new("Jane")
    jane.assign(editor)

### Benefits over Pundit

* Roles can be created on an account-by-account basis
* Roles can be added or removed at any time
* Roles don't need to be predefined, it's up to an account admin to define them

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
    >> john.assign(permission)
    >> john.can?(:create_article, account)
    => true

### Assign a role

    >> role = Role.new(:contributor)
    >> role.assign(permission)
    >> jane.assign(role)
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

### Permission definitions

Define a permission that can update any article

    Permission.new(:update, Article)
    Permission.new(:update, { class: "Article" })

Define a permission that can only update a specific article

    Permission.new(:update, article)
    Permission.new(:update, { class: "Article", id: 1 })

Define a permission that can only update an unpublished article

    Permission.new(:update, { class: "Article", published?: false })

Define a permission that can only update an article in the finance department

    Permission.new(:update, { class: "Article", department: { name: "Finance" } })
