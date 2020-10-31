class LabelInput
    include Formtastic::Inputs::Base
  
      def to_html
          input_wrapping do
              label_html <<
              "#{@object.send(method)}"
          end
      end
    end