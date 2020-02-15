require "./lib/account"
require "./lib/article_controller"
require "./lib/permission"
require "./lib/role"
require "./lib/user"

RSpec.describe ArticleController do
  let(:user) { User.new("John") }
  let(:account) { Account.new("Acme") }
  let(:controller) { described_class.new(user, account) }

  describe "#create" do
    subject(:make_request!) { controller.create }

    context "with no permissions" do
      it "should respond with unauthorized" do
        expect(make_request!).to eq(:unauthorized)
      end
    end

    context "with a general permission" do
      let(:permission) { Permission.new(:create_article, Account) }

      before do
        user.assign(permission)
      end

      it "should respond with ok" do
        expect(make_request!).to eq(:ok)
      end
    end

    context "with a wrong permission" do
      let(:another_account) { Account.new("Acme") }
      let(:permission) { Permission.new(:create_article, another_account) }

      before do
        user.assign(permission)
      end

      it "should respond with ok" do
        expect(make_request!).to eq(:unauthorized)
      end
    end

    context "with a specific permission" do
      let(:permission) { Permission.new(:create_article, account) }

      before do
        user.assign(permission)
      end

      it "should respond with ok" do
        expect(make_request!).to eq(:ok)
      end
    end
  end
end
