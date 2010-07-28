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
      Template.blocks[@template_name] = self
    end
  
    def render(context)
      block = Template.blocks[@template_name]
      
      # if the block in the template blocks hash is not this, do nothing
      if block != self
        return
      end
      
      super
    end
    
    def tokens(document)
    end
  end

  Template.register_tag('block', BlockTag)  
end