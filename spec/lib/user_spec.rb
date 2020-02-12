require "./lib/article"
require "./lib/permission"
require "./lib/role"
require "./lib/user"

RSpec.describe User do
  let(:user) { described_class.new('John') }

  describe "#can?" do
    let(:article) { Article.new("Lorem ipsum") }

    subject { user.can?(:update, article) }

    context "without any role or permission" do
      it { is_expected.to be(false) }
    end

    context "with a role that allows updating an article" do
      let(:role) { Role.new(:contributor) }

      before do
        role.permit(:update, article)
        user.acquire(role)
      end

      it { is_expected.to be(true) }
    end

    context "with an update article permission" do
      let(:permission) { Permission.new(:update, article) }

      before do
        user.acquire(permission)
      end

      it { is_expected.to be(true) }
    end

    context "with an insufficient role" do
      let(:role) { Role.new(:approver) }

      before do
        role.permit(:read, Article)
        user.acquire(role)
      end

      it { is_expected.to be(false) }
    end

    context "with an insufficient permission" do
      let(:permission) { Permission.new(:read, Article) }

      before do
        user.acquire(permission)
      end

      it { is_expected.to be(false) }
    end
  end
end
