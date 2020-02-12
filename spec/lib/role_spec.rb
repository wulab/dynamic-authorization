require "./lib/article"
require "./lib/permission"
require "./lib/role"

RSpec.describe Role do
  let(:role) { described_class.new(:contributor) }

  describe "#allow?" do
    let(:article) { Article.new("Lorem ipsum") }

    subject { role.allow?(:update, article) }

    context "without an update article permission" do
      it { is_expected.to be(false) }
    end

    context "with an update ANY article permission" do
      before do
        role.permit(:update, Article)
      end

      it { is_expected.to be(true) }
    end

    context "with an update SPECIFIC article permission" do
      before do
        role.permit(:update, article)
      end

      it { is_expected.to be(true) }
    end

    context "with a WRONG update article permission" do
      let(:another_article) { Article.new("Dolor amet") }

      before do
        role.permit(:update, another_article)
      end

      it { is_expected.to be(false) }
    end
  end
end
