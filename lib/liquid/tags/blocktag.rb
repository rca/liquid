module Liquid
  class BlockTag < Block
    Syntax = /(#{QuotedFragment}+)/
  
    def initialize(tag_name, markup, tokens)
      if markup =~ Syntax

        @template_name = $1        
        @attributes    = {}

        markup.scan(TagAttributes) do |key, value|
          @attributes[key] = value
        end

      else
        raise SyntaxError.new("Error in tag 'block' - Valid syntax: block '[name]'")
      end
      
      super
    end
    
    def end_tag
      block = Template.blocks[@template_name]
      
      if block
        block.nodelist = @nodelist
        @nodelist = []
      else
        Template.blocks[@template_name] = self
      end
    end
  end

  Template.register_tag('block', BlockTag)  
end