require "./lib/article_controller"
require "./lib/permission"
require "./lib/role"

RSpec.describe ArticleController do
  let(:role) { Role.new(:contributor) }
  let(:controller) { described_class.new(role) }

  describe "#create" do
    subject(:make_request!) { controller.create }

    context "without a create article permission" do
      it "should respond with unauthorized" do
        expect(make_request!).to eq(:unauthorized)
      end
    end

    context "with a create article permission" do
      before do
        role.permit(:create, Article)
      end

      it "should respond with ok" do
        expect(make_request!).to eq(:ok)
      end
    end
  end
end
