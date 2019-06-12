class InventoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_work
  before_action :set_inventory, only: [:edit, :update, :destroy, :inputs]

  def index
    @inventories = @work.inventories.all
  end

  def new
    @inventory = @work.inventories.new
  end

  def inputs
    @inputs = @inventory.inputs
  end

  def edit
  end

  def create
    @inventory = @work.inventories.new(inventory_params)
    respond_to do |format|
      if @inventory.save
        format.html { redirect_to work_inventories_path(@work, query: params[:query], page: params[:page]), notice: 'El inventario fue creado exitosamente.' }
      else
       format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @inventory.update(inventory_params)
        format.html { redirect_to work_inventories_path(@work, query: params[:query], page: params[:page]), notice: 'El inventario fue actualizado exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @inventory.destroy
    respond_to do |format|
      format.html { redirect_to work_inventories_path(@work, query: params[:query], page: params[:page]), notice: 'El inventario fue eliminado exitosamente.' }
    end
  end

  private


  def set_work
    @work = Work.find(params[:work_id])
  end

  def set_inventory
    @inventory = Inventory.find(params[:id])
  end

  def inventory_params
    params.require(:inventory).permit(
      :work_id,
      :code,
      :state,
      :review_period
    )
  end
end
