if (document.getElementById("component_form")) {
  new Vue({
    el: '#component_form',

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("component\[" + field_name + "\]") ||
          this.errors.has("component\[" + field_name + "\]")
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
