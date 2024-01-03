# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::ContextMethod do
  it 'ignores describe blocks' do
    expect_no_offenses(<<~RUBY)
      describe '.foo_bar' do
      end

      describe '#foo_bar' do
      end
    RUBY
  end

  it 'ignores context without `.` or `#` at the beginning' do
    expect_no_offenses(<<~RUBY)
      context "when it's sunny" do
      end
    RUBY
  end

  it 'flags context with `.` at the beginning' do
    expect_offense(<<~RUBY)
      context '.foo_bar' do
              ^^^^^^^^^^ Use `describe` for testing methods.
      end
    RUBY

    expect_correction(<<~RUBY)
      describe '.foo_bar' do
      end
    RUBY
  end

  it 'flags context with `#` at the beginning' do
    expect_offense(<<~RUBY)
      context '#foo_bar' do
              ^^^^^^^^^^ Use `describe` for testing methods.
      end
    RUBY

    expect_correction(<<~RUBY)
      describe '#foo_bar' do
      end
    RUBY
  end

  it 'flags multi-line context with `#` at the beginning' do
    expect_offense(<<~'RUBY')
      context '#foo_bar' \
              ^^^^^^^^^^^^ Use `describe` for testing methods.
              '.baz'do
      end
    RUBY

    expect_correction(<<~'RUBY')
      describe '#foo_bar' \
              '.baz'do
      end
    RUBY
  end
end
