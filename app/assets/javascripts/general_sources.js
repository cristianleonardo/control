if (document.getElementById("general_source_form")) {
  new Vue({
    el: '#general_source_form',

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("general_source\[" + field_name + "\]") ||
          this.errors.has("general_source\[" + field_name + "\]")
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
