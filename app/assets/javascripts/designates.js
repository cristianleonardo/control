if (document.getElementById("designate_form")) {

  axios.defaults.headers.common['X-CSRF-TOKEN'] = document.getElementsByName('csrf-token')[0].getAttribute('content');

  new Vue({
    el: '#designate_form',

    data: {
      source_id: document.getElementById("designate_form").getAttribute("data-source-id"),
      transaction_type: 'add',
      issue_date: null,
      amount: null,
      notes: '',
      polymorphic_id: null,
      polymorphic_type: null,
      max_amount: null,
      release_max_amount: null,
      transaction_id: null
    },

    methods: {
      isValidField(field_name) {
        return (
          this.errors.firstByRule("designate\[" + field_name + "\]", "required")
        );
      },

      isValidNumberField(field_name) {
        return (
          (this.errors.firstByRule("designate\[" + field_name + "\]", "decimal") !== null ||
          this.errors.firstByRule("designate\[" + field_name + "\]", "min_value") !== null) &&
          document.getElementsByName("designate\[" + field_name + "\]")[0].value !== ""
        );
      },

        openAndPrepareTransacionModal(p_id, p_type, max_amount, release_max_amount) {
        // Save polymorphic info
        this.polymorphic_id = p_id;
        this.polymorphic_type = p_type;
        this.max_amount = max_amount;
        this.release_max_amount = release_max_amount;

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
        if(this.amount <= 0 || (this.transaction_type == 'subtract' && this.amount > this.release_max_amount)){
        }else{
          axios.post('/api/transactions', {
            polymorphic_id: this.polymorphic_id,
            polymorphic_type: this.polymorphic_type,
            transaction_type: this.transaction_type,
            issue_date: this.issue_date,
            amount: this.amount,
            notes: this.notes
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
}
