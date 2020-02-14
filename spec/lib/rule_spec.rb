require "./lib/account"
require "./lib/article"
require "./lib/rule"

RSpec.describe Rule do
  describe "#comply?" do
    subject { rule.comply?(object) }

    context "initialized with a class" do
      let(:rule) { described_class.new(Article) }

      context "given a wrong object" do
        let(:object) { Object }

        it { is_expected.to be(false) }
      end

      context "given a correct object" do
        let(:object) { Article }

        it { is_expected.to be(true) }
      end
    end

    context "initialized with an object" do
      let(:rule) { described_class.new(object) }
      let(:object) { Article.new("Lorem ipsum") }

      context "given a wrong object" do
        subject { rule.comply?(Article.new("Dolor sit amet")) }

        it { is_expected.to be(false) }
      end

      context "given a correct object" do
        it { is_expected.to be(true) }
      end
    end

    context "initialized with a general rule" do
      let(:rule) { described_class.new({ class: Article }) }

      context "given a wrong object" do
        let(:object) { Object }

        it { is_expected.to be(false) }
      end

      context "given a correct object" do
        let(:object) { Article }

        it { is_expected.to be(true) }
      end
    end

    context "initialized with a rule containing attributes" do
      let(:rule) { described_class.new({ class: Article, id: 1 }) }
      let(:object) { Article.new("Lorem ipsum") }

      context "given a wrong object" do
        it { is_expected.to be(false) }
      end

      context "given a correct object" do
        before do
          allow(object).to receive(:id).and_return(1)
        end

        it { is_expected.to be(true) }
      end
    end

    context "initialized with a rule containing methods" do
      let(:rule) { described_class.new({ class: Article, published?: true }) }
      let(:object) { Article.new("Lorem ipsum") }

      context "given a wrong object" do
        it { is_expected.to be(false) }
      end

      context "given a correct object" do
        before do
          object.published = true
        end

        it { is_expected.to be(true) }
      end
    end

    context "initialized with a nested rule" do
      let(:rule) do
        described_class.new({ class: Article, account: { name: "Acme" } })
      end
      let(:object) { Article.new("Lorem ipsum") }

      context "given a wrong object" do
        it { is_expected.to be(false) }
      end

      context "given a correct object" do
        before do
          object.account = Account.new("Acme")
        end

        it { is_expected.to be(true) }
      end
    end
  end
end
