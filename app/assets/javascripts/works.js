if (document.getElementById("work_form")) {
  new Vue({
    el: '#work_form',

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("contract_type\[" + field_name + "\]") ||
          this.errors.has("contract_type\[" + field_name + "\]")
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
