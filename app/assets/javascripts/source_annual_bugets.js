if (document.getElementById("source_annual_budget_form")) {
  new Vue({
    el: '#source_annual_budget_form',

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("source_annual_budget_form\[" + field_name + "\]") ||
          this.errors.has("source_annual_budget_form\[" + field_name + "\]")
        );
      }
    },

    mounted: function () {
      this.$nextTick(function () {
        this.$validator.validateAll();
      });
    }
  });
}
