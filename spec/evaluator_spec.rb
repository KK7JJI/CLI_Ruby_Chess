require_relative '../lib/interface/interface'

describe CLIChess::Evaluator do
  subject(:evaluator) { CLIChess::Evaluator.new }
  let(:tokenizer) { CLIChess::Tokenizer.new }
  let(:parser) { CLIChess::Parser.new }

  def evaluate(statement)
    tokenizer.tokenize_line_input(statement: statement)
    parser.parse_line(
      token_list: tokenizer.tokens,
      statement: statement
    )
    evaluator.evaluate_line(
      parser_tree: parser.parser_tree,
      statement: statement
    )
    evaluator.result
  end

  describe '#evaluate_line' do
    [
      ['0', CLIChess::IntegerValue, 0],
      ['"Hello World"', CLIChess::StringValue, 'Hello World'],
      ['true', CLIChess::BooleanValue, true],
      ['false', CLIChess::BooleanValue, false]

    ].each do |statement, expectedclass, expected|
      it "evaluates #{statement.inspect} to #{expected}" do
        result = evaluate(statement)
        expect(result).to be_a(expectedclass)
        expect(result.value).to eq(expected)
      end
    end
  end

  describe '#evaluate unary operations' do
    context 'integer operations' do
      [
        ['-1', CLIChess::IntegerValue, -1],
        ['+1', CLIChess::IntegerValue, 1],
        ['!1', CLIChess::BooleanValue, false],
        ['!!1', CLIChess::BooleanValue, true]
      ].each do |statement, expectedclass, expected|
        it "evaluates #{statement} to #{expected}" do
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
          expect(result.value).to eq(expected)
        end
      end
    end
    context 'string operations' do
      [
        ['!"Hi"', CLIChess::BooleanValue, false],
        ['!!"Hi"', CLIChess::BooleanValue, true]
      ].each do |statement, expectedclass, expected|
        it "evaluates #{statement} to #{expected}" do
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
          expect(result.value).to eq(expected)
        end
      end
    end
    context 'boolean operations' do
      [
        ['!true', CLIChess::BooleanValue, false],
        ['!false', CLIChess::BooleanValue, true]
      ].each do |statement, expectedclass, expected|
        it "evaluates #{statement} to #{expected}" do
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
          expect(result.value).to eq(expected)
        end
      end
    end
    context 'errors' do
      [
        ['-"Hi"', CLIChess::ErrorMsg],
        ['-true', CLIChess::ErrorMsg]
      ].each do |statement, expectedclass|
        it "evaluates #{statement} to error message" do
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
        end
      end
    end
  end
  describe '#evaluate binary operations' do
    context 'arithmatic integer operations' do
      [
        ['1+2', CLIChess::IntegerValue, 3],
        ['2-1', CLIChess::IntegerValue, 1],
        ['5*2', CLIChess::IntegerValue, 10],
        ['10/2', CLIChess::IntegerValue, 5],
        ['10%9', CLIChess::IntegerValue, 1]
      ].each do |statement, expectedclass, expected|
        it "evaluates #{statement} to #{expected}" do
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
          expect(result.value).to eq(expected)
        end
      end
    end

    context 'arithmatic string operations' do
      [
        ['"H"+"ello"', CLIChess::StringValue, 'Hello'],
        ['"H"*5', CLIChess::StringValue, 'H' * 5],
        ['"H"+1', CLIChess::StringValue, 'H1'],
        ['1+"H"', CLIChess::StringValue, '1H']
      ].each do |statement, expectedclass, expected|
        it "evaluates #{statement} to #{expected}" do
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
          expect(result.value).to eq(expected)
        end
      end
    end

    context 'boolean integer operations' do
      [
        ['0==0', CLIChess::BooleanValue, true],
        ['0==1', CLIChess::BooleanValue, false],
        ['0!=0', CLIChess::BooleanValue, false],
        ['0!=1', CLIChess::BooleanValue, true],
        ['0<=0', CLIChess::BooleanValue, true],
        ['0<=1', CLIChess::BooleanValue, true],
        ['1<=0', CLIChess::BooleanValue, false],
        ['1>=1', CLIChess::BooleanValue, true],
        ['1>=0', CLIChess::BooleanValue, true],
        ['0>=1', CLIChess::BooleanValue, false],
        ['0>1', CLIChess::BooleanValue, false],
        ['1>0', CLIChess::BooleanValue, true],
        ['0>1', CLIChess::BooleanValue, false],
        ['0>0', CLIChess::BooleanValue, false],
        ['0<1', CLIChess::BooleanValue, true],
        ['1>0', CLIChess::BooleanValue, true],
        ['0<0', CLIChess::BooleanValue, false]
      ].each do |statement, expectedclass, expected|
        it "evaluates #{statement} to #{expected}" do
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
          expect(result.value).to eq(expected)
        end
      end
    end

    context 'boolean string operations' do
      [
        ['"Hi"=="Hi"', CLIChess::BooleanValue, true],
        ['"Hi"=="HI"', CLIChess::BooleanValue, false],
        ['"Hi"!="Hi"', CLIChess::BooleanValue, false],
        ['"Hi"!="HI"', CLIChess::BooleanValue, true],
        ['"a"<="a"', CLIChess::BooleanValue, true],
        ['"a"<="b"', CLIChess::BooleanValue, true],
        ['"b"<="a"', CLIChess::BooleanValue, false],
        ['"a">="a"', CLIChess::BooleanValue, true],
        ['"b">="a"', CLIChess::BooleanValue, true],
        ['"a">="b"', CLIChess::BooleanValue, false],
        ['"a">"b"', CLIChess::BooleanValue, false],
        ['"b">"a"', CLIChess::BooleanValue, true],
        ['"a">"a"', CLIChess::BooleanValue, false],
        ['"a"<"b"', CLIChess::BooleanValue, true],
        ['"b"<"a"', CLIChess::BooleanValue, false],
        ['"a"<"a"', CLIChess::BooleanValue, false]
      ].each do |statement, expectedclass, expected|
        it "evaluates #{statement} to #{expected}" do
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
          expect(result.value).to eq(expected)
        end
      end
    end

    context 'boolean boolean operations' do
      [
        ['true == true', CLIChess::BooleanValue, true],
        ['true == false', CLIChess::BooleanValue, false],
        ['true != true', CLIChess::BooleanValue, false],
        ['true != false', CLIChess::BooleanValue, true]
      ].each do |statement, expectedclass, expected|
        it "evaluates #{statement} to #{expected}" do
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
          expect(result.value).to eq(expected)
        end
      end
    end

    context 'boolean mixed case operations' do
      [
        ['"Hi"==1', CLIChess::BooleanValue, false],
        ['1=="HI"', CLIChess::BooleanValue, false],
        ['"Hi"!=1', CLIChess::BooleanValue, true],
        ['1!="HI"', CLIChess::BooleanValue, true],
        ['true=="Hi"', CLIChess::BooleanValue, false],
        ['"Hi"==true', CLIChess::BooleanValue, false],
        ['1==true', CLIChess::BooleanValue, false],
        ['true=="a"', CLIChess::BooleanValue, false]
      ].each do |statement, expectedclass, expected|
        it "evaluates #{statement} to #{expected}" do
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
          expect(result.value).to eq(expected)
        end
      end
    end

    context 'integer mixed case errors' do
      [
        ['1>="a"', CLIChess::ErrorMsg],
        ['1>=true', CLIChess::ErrorMsg],
        ['1<="a"', CLIChess::ErrorMsg],
        ['1<=true', CLIChess::ErrorMsg],
        ['1>"a"', CLIChess::ErrorMsg],
        ['1>true', CLIChess::ErrorMsg],
        ['1<"a"', CLIChess::ErrorMsg],
        ['1<true', CLIChess::ErrorMsg]
      ].each do |statement, expectedclass|
        it "evaluates #{statement} to error message" do
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
        end
      end
    end

    context 'string mixed case errors' do
      [
        ['"a">=1', CLIChess::ErrorMsg],
        ['"a">=true', CLIChess::ErrorMsg],
        ['"a"<=1', CLIChess::ErrorMsg],
        ['"a"<=true', CLIChess::ErrorMsg],
        ['"a">1', CLIChess::ErrorMsg],
        ['"a">true', CLIChess::ErrorMsg],
        ['"a"<1', CLIChess::ErrorMsg],
        ['"a"<true', CLIChess::ErrorMsg]
      ].each do |statement, expectedclass|
        it "evaluates #{statement} to error message" do
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
        end
      end
    end
  end
  describe '#variable operations' do
    context 'variable assignment' do
      [
        ['a=1', CLIChess::IntegerValue, 1],
        ['a="Hi"', CLIChess::StringValue, 'Hi'],
        ['a=true', CLIChess::BooleanValue, true]
      ].each do |statement, expectedclass, expected|
        it "evaluates #{statement} to #{expected}" do
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
          expect(result.value).to eq(expected)
        end
      end
    end
    context 'variable retrieval' do
      [
        ['a=1', 'a', CLIChess::IntegerValue, 1],
        ['a="Hi"', 'a', CLIChess::StringValue, 'Hi'],
        ['a=true', 'a', CLIChess::BooleanValue, true]
      ].each do |statement1, statement2, expectedclass, expected|
        it "evaluates #{statement2} to #{expected}" do
          result = evaluate(statement1)
          result = evaluate(statement2)
          expect(result).to be_a(expectedclass)
          expect(result.value).to eq(expected)
        end
      end
    end
    context 'errors' do
      [
        ['a', CLIChess::ErrorMsg]
      ].each do |statement, expectedclass|
        it 'evaluates unitialized variable to error message' do
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
        end
      end
    end
  end
  describe 'Expressions' do
    context 'valid expressions' do
      [
        ['1+1+1+1+1', 5],
        ['5-1-1-1-1', 1],
        ['5*4*3*2*1', 120],
        ['---+5', -5],
        ['"a"+"b"+"c"+"d"', 'abcd'],
        ['1+(2+2)', 5],
        ['1+(2+2)', 5],
        ['--5', 5],
        ['!!5', true],
        ['(+(-+5))', -5],
        ['!(0 == 0)', false],
        ['1 + + + 2', 3],
        ['-(--1)', -1],
        ["'hello' + 'world'", 'helloworld'],
        ["'a' + ('b' + 'c')", 'abc'],
        ["'x' * 5", 'xxxxx'],
        ['!true', false],
        ['!false', true],
        ['!(1 + 1 == 2)', false],
        ['!(1 + 1 != 2)', true],
        ['-(1 + (1 * (2 + 3)))', -6],
        ['+(1 * +5)', 5],
        ['!(!1)', true],
        ['-5', -5],
        ['+5', 5],
        ['!-0', false],
        ['!1', false],
        ['!0', false],
        ['1 + 2', 3],
        ['10 - 3', 7],
        ['4 * 5', 20],
        ['20 / 4', 5],
        ['7 % 3', 1]
      ].each do |statement, expected|
        it "#{statement} evaluates to #{expected}" do
          result = evaluate(statement)
          expect(result.value).to eq(expected)
        end
      end
    end
    context 'invalid expressions' do
      [
        ['1(1+2)', CLIChess::ErrorMsg, 1],
        ['1+(1+2', CLIChess::ErrorMsg, 6],
        ['1+(1+', CLIChess::ErrorMsg, 4],
        ['1+(1+)', CLIChess::ErrorMsg, 5],
        ['+', CLIChess::ErrorMsg, 0],
        ['-()', CLIChess::ErrorMsg, 2],
        ['a=', CLIChess::ErrorMsg, 1],
        ['a+2=', CLIChess::ErrorMsg, 3],
        ['1+()/3', CLIChess::ErrorMsg, 3],
        ['1@(2+3)', CLIChess::ErrorMsg, 1],
        ['1&', CLIChess::ErrorMsg, 1],
        ['1*', CLIChess::ErrorMsg, 1]

      ].each do |statement, expectedclass, pos|
        it "#{statement} evaluates to error message, pos #{pos}" do
          result = evaluate(statement)
          expect(result).to be_a(expectedclass)
          expect(result.start_pos).to eq(pos)
        end
      end
    end
    describe 'Functions' do
      context '#add_ints, valid functions' do
        [['add_ints()', 0],
         ['add_ints(1)', 1],
         ['add_ints(1 + 1)', 2],
         ['add_ints(1, 1)', 2],
         ['add_ints(1, 1 + 1)', 3],
         ['add_ints(1 + 1, 1)', 3],
         ['add_ints(1 + 1, 1 + 1, 1 + 1)', 6],
         ['2*add_ints(1,1)', 4],
         ['add_ints(add_ints(1+1), add_ints(1+1))',
          4]].each do |function, expected_result|
          it "#{function} evaluates to #{expected_result}" do
            result = evaluate(function)
            expect(result.value).to eq(expected_result)
          end
        end
      end
      context '#add_ints, invalid functions' do
        [['add_ints', CLIChess::ErrorMsg],
         ['add_ints(', CLIChess::ErrorMsg],
         ['add_ints(1+)', CLIChess::ErrorMsg],
         ['add_ints(1(4*3))', CLIChess::ErrorMsg],
         ['add_ints("1")', CLIChess::ErrorMsg],
         ['add_ints("1"+2)',
          CLIChess::ErrorMsg]].each do |function, expected_class|
          it "#{function} evaluates to #{expected_class}" do
            result = evaluate(function)
            expect(result).to be_a(expected_class)
          end
        end
      end
      context '#prod_ints, valid functions' do
        [['prod_ints()', 0],
         ['prod_ints(1)', 1],
         ['prod_ints(1 + 1)', 2],
         ['prod_ints(2, 3)', 6],
         ['prod_ints(3, 1 + 1)', 6],
         ['prod_ints(1 + 1, 3)', 6],
         ['prod_ints(1 + 1, 1 + 1, 1 + 1)', 8],
         ['2*prod_ints(2,4)', 16],
         ['prod_ints(prod_ints(1+2), prod_ints(2+1))',
          9]].each do |function, expected_result|
          it "#{function} evaluates to #{expected_result}" do
            result = evaluate(function)
            expect(result.value).to eq(expected_result)
          end
        end
      end
      context '#prod_ints, invalid functions' do
        [['prod_ints', CLIChess::ErrorMsg],
         ['prod_ints(', CLIChess::ErrorMsg],
         ['prod_ints(1,1+)', CLIChess::ErrorMsg],
         ['prod_ints(1(4*3))', CLIChess::ErrorMsg],
         ['prod_ints("1")', CLIChess::ErrorMsg],
         ['prod_ints("1"+2)',
          CLIChess::ErrorMsg]].each do |function, expected_class|
          it "#{function} evaluates to #{expected_class}" do
            result = evaluate(function)
            expect(result).to be_a(expected_class)
          end
        end
      end

      context '#factoria, valid functions' do
        [['factorial(0)', 1],
         ['factorial(1)', 1],
         ['factorial(2)', 2],
         ['factorial(3)', 6],
         ['factorial(4)', 24],
         ['factorial(5)', 120]].each do |function, expected_result|
          it "#{function} evaluates to #{expected_result}" do
            result = evaluate(function)
            expect(result.value).to eq(expected_result)
          end
        end
      end
      context '#factoria, invalid functions' do
        [['factorial("0")', CLIChess::ErrorMsg],
         ['factorial(1', CLIChess::ErrorMsg],
         ['factorial(1+(1+))', CLIChess::ErrorMsg],
         ['factorial(-1)', CLIChess::ErrorMsg],
         ['factorial(+)', CLIChess::ErrorMsg],
         ['factorial(5,4)',
          CLIChess::ErrorMsg]].each do |function, expected_class|
          it "#{function} evaluates to #{expected_class}" do
            result = evaluate(function)
            expect(result).to be_a(expected_class)
          end
        end
      end
    end
  end
end
