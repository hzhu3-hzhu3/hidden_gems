class QuillEditorInput < Formtastic::Inputs::TextInput
  def input_html_options
    super.merge(class: 'quill-editor')
  end
end