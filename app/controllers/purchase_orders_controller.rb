class PurchaseOrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_work, only: [:set_inventory]
  before_action :set_inventory
  before_action :set_purchase_order, only: [:edit, :update, :destroy, :inputs]

  def index
    @purchase_orders = @inventory.purchase_orders.all
  end

  def new
    @purchase_order = @inventory.purchase_orders.new
  end

  def edit
  end

  def create
    @purchase_order = @inventory.purchase_orders.new(purchase_order_params)
    respond_to do |format|
      if @purchase_order.save
        format.html { redirect_to work_invenroy_inputs_path(id: @inventory.id, query: params[:query], page: params[:page]), notice: 'El inventario fue creado exitosamente.' }
      else
       format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @purchase_order.update(purchase_order_params)
        format.html { redirect_to work_invenroy_inputs_path(inventory_id: @inventory.id, query: params[:query], page: params[:page]), notice: 'El inventario fue actualizado exitosamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @purchase_order.destroy
    respond_to do |format|
      format.html { redirect_to work_invenroy_inputs_path(inventory_id: @inventory.id, query: params[:query], page: params[:page]), notice: 'El inventario fue eliminado exitosamente.' }
    end
  end

  private

  def set_work
    @work = Work.find(params[:work_id])
  end

  def set_inventory
    set_work
    @inventory = Inventory.find(params[:inventory_id])
  end

  def set_purchase_order
    @purchase_order = Purchase_order.find(params[:id])
  end

  def purchase_order_params
    params[:purchase_order][:input_ids] = params[:purchase_order][:input_ids].split(',')
    params.require(:purchase_order).permit(
      :order_number,
      :invoice_number,
      :detail,
      :base_value,
      :vat_value,
      :vat_percentage,
      :inventory_id,
      input_ids: []
    )
  end
end
