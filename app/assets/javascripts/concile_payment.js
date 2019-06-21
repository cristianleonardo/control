if (document.getElementById("conciled_payment_form")) {
    new Vue({
        el: '#conciled_payment_form',

        methods: {
            isValidField(field_name) {
                return (
                    this.fields.clean("payment\[" + field_name + "\]") ||
                        this.errors.has("payment\[" + field_name + "\]")
                );
            },
            isValidNumberField(field_name){
                return (
                    (this.errors.firstByRule("payment\[" + field_name + "\]", "decimal") == null &&
                     this.errors.firstByRule("payment\[" + field_name + "\]", "min_value") == null) ||
                        document.getElementsByName("payment\[" + field_name + "\]")[0].value == ""
                );
            },
        },
        mounted: function () {
            this.$nextTick(function () {
                this.$validator.validateAll();
            });
        }
    });
}
 
