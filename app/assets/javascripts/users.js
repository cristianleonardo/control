if (document.getElementById("user_form")) {
  new Vue({
    el: '#user_form',

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

  $( "#send_invitation_button" ).click(function() {
    $('#sentInvitationModal').modal('hide');
  });
}
