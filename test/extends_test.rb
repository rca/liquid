class ExtendsTest < Test::Unit::TestCase
  include Liquid

  class TestFileSystem 
    def read_template_file(template_path)
      case template_path
      when "another_path"
        "Another path!"
      else
        template_path
      end
    end
  end

  def setup
    Liquid::Template.file_system = TestFileSystem.new
  end

  def test_extends
    document = Template.parse("{% extends another_path %}")
    assert_equal 'Another path!', document.render({})
  end

  def test_extends_with_more
    document = Template.parse("{% extends another_path %} Hello!")
    assert_equal 'Another path! Hello!', document.render({})
  end

  def test_extends_with_more_and_var
    document = Template.parse("{% extends another_path %} Hello, {{ name }}!")
    assert_equal 'Another path! Hello, berto!', document.render({'name' => 'berto'})
  end
end