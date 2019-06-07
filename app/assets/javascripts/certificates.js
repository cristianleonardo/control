if (document.getElementById("certificate_form")) {
  window.axios = require('axios');
  new Vue({
    el: '#certificate_form',
    data:{
      component_id: document.getElementById("certificate_form").getAttribute('data-component_id') ,
      subcomponents: null,
      selected_subcomponent: document.getElementById("certificate_form").getAttribute('data-sub_component_id'),
      annual_budget_id: document.getElementById("certificate_form").getAttribute('data-annual_budget_id') ,
      minutes: null,
      selected_minute: document.getElementById("certificate_form").getAttribute('data-minute_id'),
      letters: null,
      selected_letter: document.getElementById("certificate_form").getAttribute('data-letter_id')

    },

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("certificate\[" + field_name + "\]") ||
          this.errors.has("certificate\[" + field_name + "\]")
        );
      },
      isValidNumberField(field_name){
        return (
            (this.errors.firstByRule("certificate\[" + field_name + "\]", "decimal") == null &&
            this.errors.firstByRule("certificate\[" + field_name + "\]", "min_value") == null) ||
            document.getElementsByName("certificate\[" + field_name + "\]")[0].value == ""
        );
      },

      fetchSubComponents(){
        axios.get('/api/sub_components/' + this.component_id).then(response => (this.subcomponents = response.data));
      },

      clearSelections(){
        this.selected_minute = null;
        this.selected_letter = null;
        this.letters = null;
        this.minutes = null;
      },

      fetchLetters(){
        axios.get('/api/avaiability_letters/' + this.selected_minute).then(response => (this.letters = response.data));
      },
      fetchMinutes(){
        axios.get('/api/committee_minutes/' + this.annual_budget_id).then(response => (this.minutes = response.data));
        //this.clearSelections();
      }
    },
    mounted: function () {
      this.$nextTick(function () {
        this.$validator.validateAll();
        this.fetchSubComponents();
        this.fetchMinutes();
        this.fetchLetters()
      });
    }
  });
}
