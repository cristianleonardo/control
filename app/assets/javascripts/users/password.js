
// BEGIN NEW Password Restore Form
if (document.getElementById("new_password_restore_form")) {
  axios.defaults.headers.common['X-CSRF-TOKEN'] = document.getElementsByName('csrf-token')[0].getAttribute('content');

  new Vue({
    el: '#new_password_restore_form',

    data: {
      email: '',
      isValid: false
    },

    computed: {
      hasEmailFormat: function() {
        return /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/.test(this.email);
      }
    },

    methods: {
      checkIfEmailIsRegistrated: function() {
        var self = this;
        axios.get('/api/sessions/email_is_registrated?email=' + btoa(this.email))
          .then(function (response) {
            self.isValid = response.data;
          }).catch(function (error) {});
      }
    }
  });
}

// BEGIN EDIT Password Restore Form
if (document.getElementById("edit_password_restore_form")) {
  new Vue({
    el: '#edit_password_restore_form',

    data: {
      password: '',
      password_confirmation: ''
    },

    computed: {
      passwordsNotMatch: function() {
        return (this.password !== this.password_confirmation)
      }
    },

    methods: {
      onPasswordInvalid: function () {
        this.password_confirmation = null
      }
    }
  });
}
