if (document.getElementById("annual_budget_form")) {
  new Vue({
    el: '#annual_budget_form',

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("annual_budget\[" + field_name + "\]") ||
          this.errors.has("annual_budget\[" + field_name + "\]")
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
