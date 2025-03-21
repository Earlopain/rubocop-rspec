# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::Focus do
  it 'flags all rspec example blocks with that include `focus: true`' do
    expect_offense(<<~RUBY)
      example 'test', meta: true, focus: true do; end
                                  ^^^^^^^^^^^ Focused spec found.
      xit 'test', meta: true, focus: true do; end
                              ^^^^^^^^^^^ Focused spec found.
      describe 'test', meta: true, focus: true do; end
                                   ^^^^^^^^^^^ Focused spec found.
      RSpec.describe 'test', meta: true, focus: true do; end
                                         ^^^^^^^^^^^ Focused spec found.
      it 'test', meta: true, focus: true do; end
                             ^^^^^^^^^^^ Focused spec found.
      xspecify 'test', meta: true, focus: true do; end
                                   ^^^^^^^^^^^ Focused spec found.
      specify 'test', meta: true, focus: true do; end
                                  ^^^^^^^^^^^ Focused spec found.
      example_group 'test', meta: true, focus: true do; end
                                        ^^^^^^^^^^^ Focused spec found.
      scenario 'test', meta: true, focus: true do; end
                                   ^^^^^^^^^^^ Focused spec found.
      xexample 'test', meta: true, focus: true do; end
                                   ^^^^^^^^^^^ Focused spec found.
      xdescribe 'test', meta: true, focus: true do; end
                                    ^^^^^^^^^^^ Focused spec found.
      context 'test', meta: true, focus: true do; end
                                  ^^^^^^^^^^^ Focused spec found.
      xcontext 'test', meta: true, focus: true do; end
                                   ^^^^^^^^^^^ Focused spec found.
      feature 'test', meta: true, focus: true do; end
                                  ^^^^^^^^^^^ Focused spec found.
      xfeature 'test', meta: true, focus: true do; end
                                   ^^^^^^^^^^^ Focused spec found.
      xscenario 'test', meta: true, focus: true do; end
                                    ^^^^^^^^^^^ Focused spec found.
      pending 'test', meta: true, focus: true do; end
                                  ^^^^^^^^^^^ Focused spec found.
      shared_examples 'test', meta: true, focus: true do; end
                                          ^^^^^^^^^^^ Focused spec found.
      shared_context 'test', meta: true, focus: true do; end
                                         ^^^^^^^^^^^ Focused spec found.
    RUBY

    expect_correction(<<~RUBY)
      example 'test', meta: true do; end
      xit 'test', meta: true do; end
      describe 'test', meta: true do; end
      RSpec.describe 'test', meta: true do; end
      it 'test', meta: true do; end
      xspecify 'test', meta: true do; end
      specify 'test', meta: true do; end
      example_group 'test', meta: true do; end
      scenario 'test', meta: true do; end
      xexample 'test', meta: true do; end
      xdescribe 'test', meta: true do; end
      context 'test', meta: true do; end
      xcontext 'test', meta: true do; end
      feature 'test', meta: true do; end
      xfeature 'test', meta: true do; end
      xscenario 'test', meta: true do; end
      pending 'test', meta: true do; end
      shared_examples 'test', meta: true do; end
      shared_context 'test', meta: true do; end
    RUBY
  end

  it 'flags all rspec example blocks that include `:focus`' do
    expect_offense(<<~RUBY)
      example_group 'test', :focus do; end
                            ^^^^^^ Focused spec found.
      feature 'test', :focus do; end
                      ^^^^^^ Focused spec found.
      xexample 'test', :focus do; end
                       ^^^^^^ Focused spec found.
      xdescribe 'test', :focus do; end
                        ^^^^^^ Focused spec found.
      xscenario 'test', :focus do; end
                        ^^^^^^ Focused spec found.
      specify 'test', :focus do; end
                      ^^^^^^ Focused spec found.
      example 'test', :focus do; end
                      ^^^^^^ Focused spec found.
      xfeature 'test', :focus do; end
                       ^^^^^^ Focused spec found.
      xspecify 'test', :focus do; end
                       ^^^^^^ Focused spec found.
      scenario 'test', :focus do; end
                       ^^^^^^ Focused spec found.
      describe 'test', :focus do; end
                       ^^^^^^ Focused spec found.
      RSpec.describe 'test', :focus do; end
                             ^^^^^^ Focused spec found.
      xit 'test', :focus do; end
                  ^^^^^^ Focused spec found.
      context 'test', :focus do; end
                      ^^^^^^ Focused spec found.
      xcontext 'test', :focus do; end
                       ^^^^^^ Focused spec found.
      it 'test', :focus do; end
                 ^^^^^^ Focused spec found.
      pending 'test', :focus do; end
                      ^^^^^^ Focused spec found.
      shared_examples 'test', :focus do; end
                              ^^^^^^ Focused spec found.
      shared_context 'test', :focus do; end
                             ^^^^^^ Focused spec found.
    RUBY

    expect_correction(<<~RUBY)
      example_group 'test' do; end
      feature 'test' do; end
      xexample 'test' do; end
      xdescribe 'test' do; end
      xscenario 'test' do; end
      specify 'test' do; end
      example 'test' do; end
      xfeature 'test' do; end
      xspecify 'test' do; end
      scenario 'test' do; end
      describe 'test' do; end
      RSpec.describe 'test' do; end
      xit 'test' do; end
      context 'test' do; end
      xcontext 'test' do; end
      it 'test' do; end
      pending 'test' do; end
      shared_examples 'test' do; end
      shared_context 'test' do; end
    RUBY
  end

  it 'does not flag unfocused specs' do
    expect_no_offenses(<<~RUBY)
      xcontext      'test' do; end
      xscenario     'test' do; end
      xspecify      'test' do; end
      describe      'test' do; end
      example       'test' do; end
      xexample      'test' do; end
      scenario      'test' do; end
      specify       'test' do; end
      xit           'test' do; end
      feature       'test' do; end
      xfeature      'test' do; end
      context       'test' do; end
      it            'test' do; end
      example_group 'test' do; end
      xdescribe     'test' do; end
      shared_examples 'test' do; end
      shared_context  'test' do; end
    RUBY
  end

  it 'flags a method that is focused twice' do
    expect_offense(<<~RUBY)
      fit "foo", :focus do
      ^^^^^^^^^^^^^^^^^ Focused spec found.
      end
    RUBY

    expect_correction(<<~RUBY)
      it "foo" do
      end
    RUBY
  end

  it 'ignores non-rspec code with :focus blocks' do
    expect_no_offenses(<<~RUBY)
      some_method "foo", focus: true do
      end
    RUBY
  end

  it 'flags focused block types' do
    expect_offense(<<~RUBY)
      fdescribe 'test' do; end
      ^^^^^^^^^^^^^^^^ Focused spec found.
      RSpec.fdescribe 'test' do; end
      ^^^^^^^^^^^^^^^^^^^^^^ Focused spec found.
      ffeature 'test' do; end
      ^^^^^^^^^^^^^^^ Focused spec found.
      fcontext 'test' do; end
      ^^^^^^^^^^^^^^^ Focused spec found.
      fit 'test' do; end
      ^^^^^^^^^^ Focused spec found.
      fscenario 'test' do; end
      ^^^^^^^^^^^^^^^^ Focused spec found.
      fexample 'test' do; end
      ^^^^^^^^^^^^^^^ Focused spec found.
      fspecify 'test' do; end
      ^^^^^^^^^^^^^^^ Focused spec found.
      focus 'test' do; end
      ^^^^^^^^^^^^ Focused spec found.
    RUBY

    expect_correction(<<~RUBY)
      describe 'test' do; end
      RSpec.describe 'test' do; end
      feature 'test' do; end
      context 'test' do; end
      it 'test' do; end
      scenario 'test' do; end
      example 'test' do; end
      specify 'test' do; end
      focus 'test' do; end
    RUBY
  end

  it 'flags rspec example blocks that include `:focus` preceding a hash' do
    expect_offense(<<~RUBY)
      describe 'test', :focus, js: true do; end
                       ^^^^^^ Focused spec found.
    RUBY

    expect_correction(<<~RUBY)
      describe 'test', js: true do; end
    RUBY
  end

  it 'ignores with chained method calls' do
    expect_no_offenses(<<~RUBY)
      let(:fit) { Tax.federal_income_tax }
      let(:fit_id) { fit.id }
    RUBY
  end

  it 'ignores when inside define method' do
    expect_no_offenses(<<~RUBY)
      context 'test' do
        def foo
          fdescribe 'test'
          ffeature 'test'
          fcontext 'test'
          fit 'test'
          fscenario 'test'
          fexample 'test'
          fspecify 'test'
          focus 'test'
        end
      end
    RUBY
  end

  it 'ignores when inside define singleton method' do
    expect_no_offenses(<<~RUBY)
      def self.foo
        fdescribe 'test'
        ffeature 'test'
        fcontext 'test'
        fit 'test'
        fscenario 'test'
        fexample 'test'
        fspecify 'test'
        focus 'test'
      end
    RUBY
  end
end
