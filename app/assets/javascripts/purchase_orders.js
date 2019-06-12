if (document.getElementById("purchase_order_form")) {
  window.axios = require('axios');
  new Vue({
    el: '#purchase_order_form',

    data: {
      provider: '',
      inputs: [],
      selected_input: []
    },

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("provider\[" + field_name + "\]") ||
          this.errors.has("provider\[" + field_name + "\]")
        );
      },
      fetchInputs(){
        axios.get('/api/inputs/' + this.provider).then(response => (this.inputs = response.data));
      }
    },

    mounted: function () {
      this.$nextTick(function () {
        this.$validator.validateAll();
      });
    }
  });
}
