module Liquid
  class ExtendsTag < Tag
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
    end

    def override(document)
      file_system = Liquid::Template.file_system
      source  = file_system.read_template_file(@template_name)
      document.parse(Liquid::Template.tokenize(source))
    end
  end

  Template.register_tag('extends', ExtendsTag)  
end
