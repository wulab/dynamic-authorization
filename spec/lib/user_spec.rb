require "./lib/article"
require "./lib/permission"
require "./lib/role"
require "./lib/user"

RSpec.describe User do
  let(:user) { described_class.new('John') }

  describe "#can?" do
    let(:article) { Article.new("Lorem ipsum") }

    subject { user.can?(:update, article) }

    context "with no roles or permissions" do
      it { is_expected.to be(false) }
    end

    context "with a valid role" do
      let(:role) { Role.new(:contributor) }

      before do
        role.permit(:update, article)
        user.acquire(role)
      end

      it { is_expected.to be(true) }
    end

    context "with a valid permission" do
      let(:permission) { Permission.new(:update, article) }

      before do
        user.acquire(permission)
      end

      it { is_expected.to be(true) }
    end

    context "with a wrong role" do
      let(:role) { Role.new(:approver) }

      before do
        role.permit(:read, Article)
        user.acquire(role)
      end

      it { is_expected.to be(false) }
    end

    context "with a wrong permission" do
      let(:permission) { Permission.new(:read, Article) }

      before do
        user.acquire(permission)
      end

      it { is_expected.to be(false) }
    end
  end
end
