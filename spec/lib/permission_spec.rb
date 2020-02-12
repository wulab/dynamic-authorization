require "./lib/account"
require "./lib/article"
require "./lib/permission"
require "./lib/role"

RSpec.describe Permission do
  describe "#allow?" do
    let(:article) { Article.new("Lorem ipsum") }
    let(:account) { Account.new('Acme') }

    subject { permission.allow?(:update, article) }

    context "given a create article permission" do
      let(:permission) { described_class.new(:create, Article) }

      it { is_expected.to be(false) }
    end

    context "given an update ANY article permission" do
      let(:permission) { described_class.new(:update, Article) }

      it { is_expected.to be(true) }
    end

    context "given an update ACCOUNT article permission" do
      let(:permission) { described_class.new(:update, Article, account) }

      it { is_expected.to be(false) }
    end

    context "given an update ACCOUNT article permission and a published article" do
      let(:permission) { described_class.new(:update, Article, account) }

      before do
        account.publish(article)
      end

      it { is_expected.to be(true) }
    end

    context "given an update SPECIFIC article permission" do
      let(:permission) { described_class.new(:update, article) }

      it { is_expected.to be(true) }
    end
  end
end
