if (document.getElementById("contractor_form")) {
  var vm = new Vue({
    el: '#contractor_form',

    data: {
      contractor_type_id: document.getElementById("contractor_form").getAttribute("data-contractortype"),
      legal_representant_name: document.getElementById("contractor_form").getAttribute("data-name"),
      legal_representant_document_type: document.getElementById("contractor_form").getAttribute("data-type"),
      legal_representant_document_number: document.getElementById("contractor_form").getAttribute("data-number"),
      name: document.getElementById("contractor_form").getAttribute("data-Cname"),
      document_number: document.getElementById("contractor_form").getAttribute("data-Cnumber"),
      document_type: document.getElementById("contractor_form").getAttribute("data-Ctype")
    },

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("contractor\[" + field_name + "\]") ||
          this.errors.has("contractor\[" + field_name + "\]")
        );
      }
    },

    mounted: function () {
      this.$nextTick(function () {
        this.$validator.validateAll();
      });
    }
  });
  vm.contractor_type_id = document.getElementById("contractor_form").getAttribute("data-contractortype");
}
