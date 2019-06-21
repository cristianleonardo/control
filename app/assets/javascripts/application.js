// Vendors
//= require_tree .
var Vue = require('vue');
window.Vue = Vue;

var VeeValidate = require('vee-validate');
window.VeeValidate = VeeValidate;
Vue.use(VeeValidate);

var $ = require('jquery');
window.jQuery = $;
window.$ = $;

window.axios = require('axios');
window.moment = require('moment');

require('select2');
require('bootstrap-sass');
require('bootstrap-datepicker');
require('bootstrap-datepicker/dist/locales/bootstrap-datepicker.es.min');
require('jquery-mask-plugin');
require('jquery-ujs');

var Dropzone = require('dropzone/dist/dropzone');
window.Dropzone = Dropzone;

var VueTruncate = require('vue-truncate-filter')
Vue.use(VueTruncate)

// Business logic
require('./users/invitations');
require('./contract_types');
require('./contractor_types');
require('./general_parameters');
require('./components');
require('./sub_components');
require('./sources');
require('./sources/incomes');
require('./contractors');
require('./avaiability_letters');
require('./committee_minutes');
require('./annual_budgets');
require('./contracts');
require('./additions');
require('./certificates');
require('./designates');
require('./budgets');
require('./payments');
require('./payments/withholdings');
require('./dashboard');
require('./expenditures');
require('./concile_payment');
require('./taxes');
require('./reports');
require('./strategic_planning');
require('./users');
require('./users/password');
require('./source_annual_bugets');
require('./provider');
require('./inputs');
require('./work_types');
require('./works');
require('./inventories');
require('./purchase_orders');

// Datepicker
$('.datepicker').datepicker({
  startView: 1,
  format: 'yyyy-mm-dd',
  language: 'es',
  autoclose: false
});

$('.yearpicker').datepicker({
  minViewMode: 2,
  format: 'yyyy'
});

// Select2 calls
$('.select2-tags').select2({
  placeholder: 'Seleccione una opción',
  tags: true,
});

$('.select2').select2({
  placeholder: 'Seleccione una opción',
  allowClear: true,
  width: '100%',
  "language": {
    "noResults": function(){
      return "No se encontraron resultados";
    }
  }
}).on("select2:close", function (e) {
  $(this).focus();
});
