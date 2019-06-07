module API
  class TransactionsController < ApplicationController
    before_action :authenticate_user!
    cache_sweeper :transaction_sweeper

    def create
      @base = params[:polymorphic_type].classify.constantize.find(params[:polymorphic_id])

      @transaction = @base.transactions.new(
                                          issue_date: params[:issue_date],
                                          amount: params[:amount],
                                          notes: params[:notes],
                                          transaction_type: params[:transaction_type],
                                          user_id: current_user.id,
                                          is_adittion: params[:is_addition],
                                          addition_id: params[:addition]
                                        )

      if @transaction.save
        @base.update_attributes(value: calculate_total_value)
        render nothing: true, status: 200
      else
        render nothing: true, status: 404
      end
    end

    def destroy
      @transaction = Transaction.find(params[:id])
      @base = @transaction.transactionable

      # TODO: Refactor
      # new_base_value = BigDecimal(@base.value - @transaction.amount) if @transaction.transaction_type == 'add'
      # new_base_value = BigDecimal(@base.value + @transaction.amount) if @transaction.transaction_type == 'subtract'


      @transaction.destroy

      new_base_value = calculate_total_value
      @base.update_attributes(value: new_base_value)

      render nothing: true, status: 200
    end

    private
    # TODO: Refactor
    def calculate_base_value
      return BigDecimal(@base.value + @transaction.amount) if @transaction.transaction_type == 'add'
      return BigDecimal(@base.value - @transaction.amount) if @transaction.transaction_type == 'subtract'
    end

    def calculate_total_value
      addition_value = @base.transactions.where(transaction_type: 'add').sum(:amount)
      subtract_value = @base.transactions.where(transaction_type: 'subtract').sum(:amount)
      addition_value - subtract_value
    end

  end
end
