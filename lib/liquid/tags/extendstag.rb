module Liquid
  class ExtendsTag < Block
    Syntax = /(#{QuotedFragment}+)/

    def initialize(tag_name, markup, tokens)
      if markup =~ Syntax

        @template_name = $1
        @attributes    = {}

        markup.scan(TagAttributes) do |key, value|
          @attributes[key] = value
        end

      else
        raise SyntaxError.new("Error in tag 'extends' - Valid syntax: extends '[template]'")
      end

      super
    end

    def parse(tokens)
      new_tokens = Template.tokenize(Template.file_system.read_template_file(@template_name) + '{% endextends %}')
      super(new_tokens + tokens)
    end

    def render(context)
      render_all(@nodelist, context)
    end
  end

  Template.register_tag('extends', ExtendsTag)  
end
