class BlockTagTest < Test::Unit::TestCase
  include Liquid

  class TestFileSystem 
    def read_template_file(template_path)
      case template_path
      when "another_path"
        "{% block content %}Hello, World!{% endblock %}"
      when "order"
        "start {% block content %}content{% endblock %} end"
      else
        template_path
      end
    end
  end

  def setup
    Liquid::Template.file_system = TestFileSystem.new
  end

  def test_extends
    document = Template.parse("{% extends another_path %}{% block content %}Hola, Mundo!{% endblock %}")
    rendered = document.render({})
    assert_equal 'Hola, Mundo!', rendered
  end

  def test_extends_order
    document = Template.parse("{% extends order %}{% block content %}Hola, Mundo!{% endblock %}")
    rendered = document.render({})
    assert_equal 'start Hola, Mundo! end', rendered
  end
end