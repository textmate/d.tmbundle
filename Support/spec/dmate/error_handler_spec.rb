require 'spec_helper'

require 'text_mate/text_mate'
require 'dmate/error_handler'

describe DMate::ErrorHandler do
  let(:handler) { DMate::ErrorHandler.new }

  describe 'module_to_path' do
    def module_to_path(*args)
      handler.send(:module_to_path, *args)
    end

    context 'when not in a project' do
      before :each do
        allow(TextMate).to receive(:project?).and_return(false)
      end

      context 'when the given value is a module name' do
        it 'returns the given path unchanged' do
          module_to_path('foo.bar').should == 'foo.bar'
        end

        context 'and original module name exists' do
          before :each do
            expect(File).to receive(:exist?).once.and_return(true)
          end

          it 'returns the given path unchanged' do
            module_to_path('foo.bar').should == 'foo.bar'
          end
        end
      end

      context 'when the given value is a path' do
        it 'returns the given path unchanged' do
          module_to_path('x/y').should == 'x/y'
        end

        context 'and original path exists' do
          before :each do
            expect(File).to receive(:exist?).once.and_return(true)
          end

          it 'returns the given path unchanged' do
            module_to_path('x/y').should == 'x/y'
          end
        end
      end
    end

    context 'when in a project' do
      let(:project_path) { '/foo/bar' }

      before :each do
        allow(TextMate).to receive(:project?).and_return(true)
        allow(TextMate).to receive(:project_path).and_return(project_path)
      end

      context 'when the given value is module name' do
        it 'returns the full path of the given module name' do
          module_to_path('x.y').should == project_path + '/x/y.d'
        end

        context 'and original module name exists' do
          before :each do
            expect(File).to receive(:exist?).once.and_return(true)
          end

          it 'returns the given path unchanged' do
            module_to_path('foo.bar').should == 'foo.bar'
          end
        end
      end

      context 'when the given value is a path' do
        it 'returns the full path of the given module name' do
          module_to_path('x/y').should == project_path + '/x/y.d'
        end

        context 'and original path exists' do
          before :each do
            expect(File).to receive(:exist?).once.and_return(true)
          end

          it 'returns the given path unchanged' do
            module_to_path('x/y').should == 'x/y'
          end
        end
      end
    end
  end
end
