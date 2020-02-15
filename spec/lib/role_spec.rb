require "./lib/article"
require "./lib/permission"
require "./lib/role"

RSpec.describe Role do
  let(:role) { described_class.new(:contributor) }

  describe "#permit?" do
    let(:article) { Article.new("Lorem ipsum") }

    subject { role.permit?(:update, article) }

    context "with no permissions" do
      it { is_expected.to be(false) }
    end

    context "with a general permission" do
      before do
        role.permit(:update, Article)
      end

      it { is_expected.to be(true) }
    end

    context "with a specific permission" do
      before do
        role.permit(:update, article)
      end

      it { is_expected.to be(true) }
    end

    context "with a wrong permission" do
      let(:another_article) { Article.new("Dolor amet") }

      before do
        role.permit(:update, another_article)
      end

      it { is_expected.to be(false) }
    end
  end
end
