if (document.getElementById("source_form")) {
  new Vue({
    el: '#source_form',

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("source\[" + field_name + "\]") ||
          this.errors.has("source\[" + field_name + "\]")
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
