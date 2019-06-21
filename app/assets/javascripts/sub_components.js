if(document.getElementById("sub_component_form")){
  new Vue({
    el: '#sub_component_form',

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("sub_component\[" + field_name + "\]") ||
          this.errors.has("sub_component\[" + field_name + "\]")
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
