ActiveAdmin.register Category do
  permit_params :name
  
  actions :all
  
  controller do
    def destroy
      @category = Category.find(params[:id])
      if @category.destroy
        redirect_to admin_categories_path, notice: "Category was successfully destroyed."
      else
        redirect_to admin_categories_path, alert: "Failed to destroy category."
      end
    end
  end
end