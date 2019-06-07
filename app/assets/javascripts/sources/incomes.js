if (document.getElementById("source_income_form")) {
  window.axios = require('axios');
  new Vue({
    el: '#source_income_form',

    data:{
      component_id: document.getElementById("source_income_form").getAttribute('data-component_id') ,
      subcomponents: null,
      selected_subcomponent: document.getElementById("source_income_form").getAttribute('data-sub_component_id')
    },

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("income\[" + field_name + "\]") ||
          this.errors.has("income\[" + field_name + "\]")
        );
      },
      fetchSubComponents(){
        axios.get('/api/sub_components/' + this.component_id).then(response => (this.subcomponents = response.data));
      }
    },

    mounted: function () {
      this.$nextTick(function () {
        this.$validator.validateAll();
        this.fetchSubComponents();
      });
    }
  });
}
