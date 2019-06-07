if (document.getElementById("expenditure_form")) {
  var vm = new Vue({
    el: '#expenditure_form',
    data:{
    },
    methods: {
        isValidField(field_name,index) {
        return (
            this.errors.firstByRule("payment[expenditures_attributes]["+index+"][" + field_name + "]", "required")
        );
      },
        isValidNumberField(field_name, index){
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

}
