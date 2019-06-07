if (document.getElementById("payment_form")) {
  const paymentForm = document.getElementById("payment_form");
  const expenditures_props = paymentForm.dataset.expenditures !== undefined ? JSON.parse(paymentForm.dataset.expenditures) : [],
        vat_prop = paymentForm.dataset.vat !== undefined ? JSON.parse(paymentForm.dataset.vat) : false,
        vat_percentage_prop = paymentForm.dataset.percentage ? JSON.parse(paymentForm.dataset.percentage) : null,
        prepayment_prop = paymentForm.dataset.prepayment ? JSON.parse(paymentForm.dataset.prepayment) : false


  var vm = new Vue({
    el: '#payment_form',
    data:{
      vat: false || vat_prop,
      vat_percentage: false || vat_percentage_prop,
      prepayment: null || prepayment_prop,
      expenditures: null || expenditures_props
    },
    computed: {
      calculate_expenditure_value: function(){
        this.expenditures.forEach(function(e, index){
          if (e.original_value !== null){
            e.value = Number.parseFloat(e.original_value - e.prepayment_amortization).toFixed(2);
          }
        });
      }
    },
    methods: {
      isValidField(field_name) {
        return (
          this.errors.firstByRule("payment\[" + field_name + "\]", "required")
        );
      },
      isValidNumberField(field_name){
        return (
            (this.errors.firstByRule("payment\[" + field_name + "\]", "decimal") == null &&
            this.errors.firstByRule("payment\[" + field_name + "\]", "min_value") == null) ||
            document.getElementsByName("payment\[" + field_name + "\]")[0].value == ""
        );
      },
      isValidExpenditureField(field_name,index) {
        return (
          this.errors.firstByRule("payment[expenditures_attributes]["+index+"][" + field_name + "]", "required")
        );
      },
      isValidExpenditureNumberField(field_name, index){
        return (
          (this.errors.firstByRule("payment[expenditures_attributes]["+index+"][" + field_name + "]", "decimal") != null ||
           this.errors.firstByRule("payment[expenditures_attributes]["+index+"][" + field_name + "]", "min_value") != null) &&
            document.getElementsByName("payment[expenditures_attributes]["+index+"][" + field_name + "]")[0].value != ""
        );
      },

    },
    mounted: function () {
      this.$nextTick(function () {
        this.$validator.validateAll();
      });
    }
  });
  vm.$watch('vat', function(){
    if(!vm.vat){
      vm.vat_percentage = '';
    }
  });
}
