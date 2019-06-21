if (document.getElementById("addition_form")) {
  new Vue({
    el: '#addition_form',
    data: {
      type: ''
    },
    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("addition\[" + field_name + "\]") ||
          this.errors.has("addition\[" + field_name + "\]")
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
