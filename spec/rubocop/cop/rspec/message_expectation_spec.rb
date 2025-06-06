# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::MessageExpectation do
  context 'when EnforcedStyle is allow' do
    let(:cop_config) do
      { 'EnforcedStyle' => 'allow' }
    end

    it 'flags expect(...).to receive' do
      expect_offense(<<~RUBY)
        expect(foo).to receive(:bar)
        ^^^^^^ Prefer `allow` for setting message expectations.
      RUBY
    end

    it 'approves of allow(...).to receive' do
      expect_no_offenses('allow(foo).to receive(:bar)')
    end

    it_behaves_like 'detects style', 'allow(foo).to receive(:bar)',  'allow'
    it_behaves_like 'detects style', 'expect(foo).to receive(:bar)', 'expect'
  end

  context 'when EnforcedStyle is expect' do
    let(:cop_config) do
      { 'EnforcedStyle' => 'expect' }
    end

    it 'flags allow(...).to receive' do
      expect_offense(<<~RUBY)
        allow(foo).to receive(:bar)
        ^^^^^ Prefer `expect` for setting message expectations.
      RUBY
    end

    it 'approves of expect(...).to receive' do
      expect_no_offenses('expect(foo).to receive(:bar)')
    end

    it_behaves_like 'detects style', 'expect(foo).to receive(:bar)', 'expect'
    it_behaves_like 'detects style', 'allow(foo).to receive(:bar)',  'allow'
  end
end
