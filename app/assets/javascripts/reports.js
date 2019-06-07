if (document.getElementById("withholdings_reports_form")) {
    var withholdings = new Vue({
        el: '#withholdings_reports_form',
        methods: {
            isValidField(field_name) {
                return (
                    this.fields.clean(field_name) ||
                        this.errors.has(field_name)
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
if (document.getElementById("financial_reports_form")) {
    var financial = new Vue({
        el: '#financial_reports_form',
        methods: {
            isValidField(field_name) {
                return (
                    this.fields.clean(field_name) ||
                        this.errors.has(field_name)
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
if (document.getElementById("pda_reports_form")) {
    var pda = new Vue({
        el: '#pda_reports_form',
        methods: {
            isValidField(field_name) {
                return (
                    this.fields.clean(field_name) ||
                        this.errors.has(field_name)
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
if (document.getElementById("cdr_reports_form")) {
    var cdr = new Vue({
        el: '#cdr_reports_form',
        methods: {
            isValidField(field_name) {
                return (
                    this.fields.clean(field_name) ||
                        this.errors.has(field_name)
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
if (document.getElementById("available_balance_contract_form")) {
    var cdr = new Vue({
        el: '#available_balance_contract_form',
        methods: {
            isValidField(field_name) {
                return (
                    this.fields.clean(field_name) ||
                        this.errors.has(field_name)
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
if (document.getElementById("subcomponent_and_source_form")) {
    var cdr = new Vue({
        el: '#subcomponent_and_source_form',
        methods: {
            isValidField(field_name) {
                return (
                    this.fields.clean(field_name) ||
                        this.errors.has(field_name)
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
if (document.getElementById("design_mod_form")) {
    var cdr = new Vue({
        el: '#design_mod_form',
        methods: {
            isValidField(field_name) {
                return (
                    this.fields.clean(field_name) ||
                        this.errors.has(field_name)
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
if (document.getElementById("fia_form")) {
    var cdr = new Vue({
        el: '#fia_form',
        methods: {
            isValidField(field_name) {
                return (
                    this.fields.clean(field_name) ||
                        this.errors.has(field_name)
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
if (document.getElementById("taxes_by_municipio_form")) {
    var cdr = new Vue({
        el: '#taxes_by_municipio_form',
        methods: {
            isValidField(field_name) {
                return (
                    this.fields.clean(field_name) ||
                        this.errors.has(field_name)
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
