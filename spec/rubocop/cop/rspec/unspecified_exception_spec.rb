# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::UnspecifiedException do
  context 'with raise_error matcher' do
    it 'detects the `unspecified_exception` offense' do
      expect_offense(<<~RUBY)
        expect {
          raise StandardError
        }.to raise_error
             ^^^^^^^^^^^ Specify the exception being captured
      RUBY
    end

    it 'allows empty exception specification when not expecting an error' do
      expect_no_offenses(<<~RUBY)
        expect {
          raise StandardError
        }.not_to raise_error
      RUBY
    end

    it 'allows exception classes' do
      expect_no_offenses(<<~RUBY)
        expect {
          raise StandardError
        }.to raise_error(StandardError)
      RUBY
    end

    it 'allows exception messages' do
      expect_no_offenses(<<~RUBY)
        expect {
          raise StandardError.new('error')
        }.to raise_error('error')
      RUBY
    end

    it 'allows exception types with messages' do
      expect_no_offenses(<<~RUBY)
        expect {
          raise StandardError.new('error')
        }.to raise_error(StandardError, 'error')
      RUBY
    end

    it 'allows exception matching regular expressions' do
      expect_no_offenses(<<~RUBY)
        expect {
          raise StandardError.new('error')
        }.to raise_error(/err/)
      RUBY
    end

    it 'allows exception types with matching regular expressions' do
      expect_no_offenses(<<~RUBY)
        expect {
          raise StandardError.new('error')
        }.to raise_error(StandardError, /err/)
      RUBY
    end

    it 'allows classes with blocks with braces' do
      expect_no_offenses(<<~RUBY)
        expect {
          raise StandardError.new('error')
        }.to raise_error { |err| err.data }
      RUBY
    end

    it 'allows classes with blocks with do/end' do
      expect_no_offenses(<<~RUBY)
        expect {
          raise StandardError.new('error')
        }.to raise_error do |error|
          error.data
        end
      RUBY
    end

    it 'allows parameterized exceptions' do
      expect_no_offenses(<<~RUBY)
        my_exception = StandardError.new('my exception')
        expect {
          raise my_exception
        }.to raise_error(my_exception)
      RUBY
    end

    it 'allows a subject function to be named raise_error' do
      expect_no_offenses(<<~RUBY)
        def raise_exception
          raise StandardError
        end

        expect {
          raise_error
        }.to raise_error(StandardError)
      RUBY
    end

    it 'allows a subject function to be named raise_exception' do
      expect_no_offenses(<<~RUBY)
        def raise_exception
          raise StandardError
        end

        expect {
          raise_exception
        }.to raise_error(StandardError)
      RUBY
    end
  end

  context 'with raise_exception matcher' do
    it 'detects the `unspecified_exception` offense' do
      expect_offense(<<~RUBY)
        expect {
          raise StandardError
        }.to raise_exception
             ^^^^^^^^^^^^^^^ Specify the exception being captured
      RUBY
    end

    it 'allows empty exception specification when not expecting an error' do
      expect_no_offenses(<<~RUBY)
        expect {
          raise StandardError
        }.not_to raise_exception
      RUBY
    end

    it 'allows exception classes' do
      expect_no_offenses(<<~RUBY)
        expect {
          raise StandardError
        }.to raise_exception(StandardError)
      RUBY
    end

    it 'allows exception messages' do
      expect_no_offenses(<<~RUBY)
        expect {
          raise StandardError.new('error')
        }.to raise_exception('error')
      RUBY
    end

    it 'allows exception types with messages' do
      expect_no_offenses(<<~RUBY)
        expect {
          raise StandardError.new('error')
        }.to raise_exception(StandardError, 'error')
      RUBY
    end

    it 'allows exception matching regular expressions' do
      expect_no_offenses(<<~RUBY)
        expect {
          raise StandardError.new('error')
        }.to raise_exception(/err/)
      RUBY
    end

    it 'allows exception types with matching regular expressions' do
      expect_no_offenses(<<~RUBY)
        expect {
          raise StandardError.new('error')
        }.to raise_exception(StandardError, /err/)
      RUBY
    end

    it 'allows classes with blocks with braces' do
      expect_no_offenses(<<~RUBY)
        expect {
          raise StandardError.new('error')
        }.to raise_exception { |err| err.data }
      RUBY
    end

    it 'allows classes with blocks with do/end' do
      expect_no_offenses(<<~RUBY)
        expect {
          raise StandardError.new('error')
        }.to raise_exception do |error|
          error.data
        end
      RUBY
    end

    it 'allows parameterized exceptions' do
      expect_no_offenses(<<~RUBY)
        my_exception = StandardError.new('my exception')
        expect {
          raise my_exception
        }.to raise_exception(my_exception)
      RUBY
    end

    it 'detects chained offenses' do
      expect_offense(<<~RUBY)
        expect {
          foo
        }.to raise_exception.and change { bar }
             ^^^^^^^^^^^^^^^ Specify the exception being captured
      RUBY
    end

    it 'detects more chained offenses' do
      expect_offense(<<~RUBY)
        expect {
          foo
        }.to raise_exception.and change { bar }.and change { baz }
             ^^^^^^^^^^^^^^^ Specify the exception being captured
      RUBY
    end

    it 'detects more complex chained offenses' do
      expect_offense(<<~RUBY)
        expect {
          foo
        }.to change { bar }.and raise_exception.and change { baz }
                                ^^^^^^^^^^^^^^^ Specify the exception being captured
      RUBY
    end

    it 'does not confuse blocks with chains' do
      expect_no_offenses(<<~RUBY)
        expect do
          expect { foo }.not_to raise_error
        end.to change(Foo, :count).by(3)
      RUBY
    end

    it 'allows a subject function to be named raise_exception' do
      expect_no_offenses(<<~RUBY)
        def raise_error
          raise StandardError
        end

        expect {
          raise_exception
        }.to raise_exception(StandardError)
      RUBY
    end

    it 'allows a subject function to be named raise_error' do
      expect_no_offenses(<<~RUBY)
        def raise_error
          raise StandardError
        end

        expect {
          raise_error
        }.to raise_exception(StandardError)
      RUBY
    end

    it 'detects even when a non-send node is an ancestor' do
      expect_offense(<<~RUBY)
        expect { raise 'error' }.to (branch_conditional ? raise_error : handle_exception)
                                                          ^^^^^^^^^^^ Specify the exception being captured
      RUBY
    end
  end
end
