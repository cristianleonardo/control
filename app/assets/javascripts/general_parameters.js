if (document.getElementById("general_parameter_form")) {
  new Vue({
    el: '#general_parameter_form',

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("general_parameter\[" + field_name + "\]") ||
          this.errors.has("general_parameter\[" + field_name + "\]")
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
