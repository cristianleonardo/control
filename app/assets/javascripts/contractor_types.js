if (document.getElementById("contractor_type_form")) {
  new Vue({
    el: '#contractor_type_form',

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("contractor_type\[" + field_name + "\]") ||
          this.errors.has("contractor_type\[" + field_name + "\]")
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
