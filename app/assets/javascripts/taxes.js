if (document.getElementById("tax_form")) {
  new Vue({
    el: '#tax_form',

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("tax\[" + field_name + "\]") ||
          this.errors.has("tax\[" + field_name + "\]")
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
