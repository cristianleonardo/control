if (document.getElementById("invitation_edit_form")) {
  new Vue({
    el: '#invitation_edit_form',

    data: {
      password: '',
      password_confirmation: ''
    },

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("user\[" + field_name + "\]") ||
          this.errors.has("user\[" + field_name + "\]")
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
