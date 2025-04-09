ActiveAdmin.register Page do
  permit_params :slug, :body

  form do |f|
    f.inputs "Page Details" do
      f.input :slug
      f.input :body, as: :quill_editor
    end
    f.actions
  end
end