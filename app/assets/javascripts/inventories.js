if (document.getElementById("inventory_form")) {
  new Vue({
    el: '#inventory_form',

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("provider\[" + field_name + "\]") ||
          this.errors.has("provider\[" + field_name + "\]")
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
