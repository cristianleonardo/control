if (document.getElementById("budget_form")) {

  axios.defaults.headers.common['X-CSRF-TOKEN'] = document.getElementsByName('csrf-token')[0].getAttribute('content');

  var vm = new Vue({
    el: '#budget_form',

    data: {
      transaction_type: 'add',
      issue_date: null,
      transaction_id: null,
      amount: null,
      notes: '',
      polymorphic_id: null,
      polymorphic_type: null,
      max_amount: null,
      release_max_amount: null,
      designate_name: '',
      max_amount_with_format: '',
      release_max_amount_with_format: '',
      is_adittion: false,
      additions: JSON.parse(document.getElementById("budget_form").getAttribute('data-additions')),
      selected_addition: null
    },

    methods: {
      isValidField(field_name, index) {
        return (
          this.errors.firstByRule("budget[funds_attributes]["+index+"]["+field_name+"]", "required")
        );
      },

      isValidNumberField(field_name, index){
        return (
          (this.errors.firstByRule("budget[funds_attributes]["+index+"]["+field_name+"]", "decimal") !== null ||
          this.errors.firstByRule("budget[funds_attributes]["+index+"]["+field_name+"]", "min_value") !== null) &&
          document.getElementsByName("budget[funds_attributes]["+index+"]["+field_name+"]")[0].value !== ""
        );
      },

        openAndPrepareTransacionModal(p_id, p_type, max_amount, designate_name, max_amount_with_format, release_max_amount, release_max_amount_with_format) {
        // Save polymorphic info
        this.polymorphic_id = p_id;
        this.polymorphic_type = p_type;
        this.max_amount = max_amount;
        this.designate_name = designate_name;
        this.max_amount_with_format = max_amount_with_format;
        this.release_max_amount = release_max_amount;
        this.release_max_amount_with_format = release_max_amount_with_format;

        // Reset modal fields
        this.transaction_type = 'add';
        this.issue_date = moment().format('YYYY/MM/DD');
        this.amount = null;
        this.notes = '';

        $('#transactionModal').modal('show');
      },

      openDestroyTransacionModal(transaction_id) {
        this.transaction_id = transaction_id;
        $('#destroyTransactionModal').modal('show');
      },

      destroyTransaction() {
        axios.delete('/api/transactions/' + this.transaction_id)
        .then(function (response) {
          $('#destroyTransactionModal').modal('hide');
          location.reload();
        })
        .catch(function (error) {});
      },

        setTransactionType(type) {
            this.transaction_type = type;
      },

      registerTransaction() {
        if(this.amount <= 0 || (this.transaction_type == 'add' && this.amount > this.max_amount) || (this.transaction_type == 'subtract' && this.amount > this.release_max_amount)){
        }else{
          if(this.transaction_type === 'subtract' || this.selected_addition === null){this.is_adittion = false}
          axios.post('/api/transactions', {
            polymorphic_id: this.polymorphic_id,
            polymorphic_type: this.polymorphic_type,
            transaction_type: this.transaction_type,
            issue_date: this.issue_date,
            amount: this.amount,
            notes: this.notes,
            is_addition: this.is_adittion,
            addition: this.selected_addition
          })
            .then(function (response) {
              $('#transactionModal').modal('hide');
              location.reload();
            })
            .catch(function (error) {});
        }
      }
    },
    mounted: function () {
      this.$nextTick(function () {
        this.$validator.validateAll();
      });
    }
  });
  $(".select2").on('change', function() { vm[$(this).data('fieldname')] = $(this).val(); });
}
