if (document.getElementById("contract_form")) {

  var csrf_token = document.getElementsByName('csrf-token')[0].getAttribute('content');
  axios.defaults.headers.common['X-CSRF-TOKEN'] = csrf_token;

  var currentAction = document.getElementById('contract_form').dataset.action;
  var contractId = document.getElementById('contract_form').dataset.contract_id;

  Vue.filter('momentjs', function(value) {
    return moment(value).format('ddd MMMM D [de] YYYY, h:mm a');
  });

  var vm =  new Vue({

    el: '#contract_form',
    
    data:{
      contractor_id:  document.getElementById("contract_form").getAttribute('data-contractor'),
      interventor_id: document.getElementById("contract_form").getAttribute('data-interventor'),
      supervisor_id:  document.getElementById("contract_form").getAttribute('data-supervisor'),
      start_date:     document.getElementById("contract_form").getAttribute('data-start-date'),
      term_days:      document.getElementById("contract_form").getAttribute('data-term-days'),
      term_months:    document.getElementById("contract_form").getAttribute('data-term-months'),
      medias: [],
      mediaToDestroy: {
        name: ''
      },
      contract: {},
      uploadedFiles: 0
    },

    created () {
      this.fetchContract();
      this.fetchContracteMedias(contractId);
      this.initDropzone();
    },

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("contract\[" + field_name + "\]") ||
          this.errors.firstByRule("contract\[" + field_name + "\]", "required") != null
        );
      },

      initDropzone: function() {
        self = this;
        self.$nextTick(function() {
          self.mediaDropzone  = new Dropzone("#media-dropzone", {
            url: '/api/medias/' + '/contract/' + contractId,
            acceptedFiles: "application/pdf",
            maxFilesize: 6,
            headers: { "X-CSRF-TOKEN": csrf_token },
            previewTemplate: "<table class=\"table table-condensed\"><tbody><tr><td width=\"10%\"><button data-dz-remove class=\"btn btn-danger btn-xs delete\"><i class=\"fa fa-trash\"></i></button></td><td width=\"25%\"><p class=\"name\" data-dz-name></p></td><td width=\"25%\"><p class=\"size\" data-dz-size></p></td><td width=\"40%\"><div class=\"progress\" role=\"progressbar\" aria-valuemin=\"0\" aria-valuemax=\"100\" aria-valuenow=\"0\"><div class=\"progress-bar\" style=\"width:0%;\" data-dz-uploadprogress></div></div></td></tr></tbody></table>"
          });
          return self.mediaDropzone.on("success", function(file, responseText) {
            var _this = this;
            self.fetchAndAddMediaToList(responseText.id);
            self.mediaDropzone.removeFile(file);
            self.uploadedFiles += 1;
          });
        });
      },

      fetchContract: function() {
        var self = this;
        axios.get('/api/contracts/' + contractId)
        .then(function (response) { self.contract = response.data; });
      },

      fetchAndAddMediaToList: function(media_id){
        axios.get('/api/medias/' + media_id)
        .then(function (response) {
          self.medias.push(response.data);
          return response.data;
        });
      },

      fetchContracteMedias: function(contract_id) {
        var self = this;
        axios.get('/api/contracts/' + contract_id + '/medias')
        .then(function (response) { self.medias = response.data; });
      },

      destroyModal: function() {
        $('#destroyMediaoModal').modal('toggle');
      },

      showDestroyWarning: function(media){
        this.mediaToDestroy = media;
        $('#destroyMediaModal').modal('toggle');
      },

      destroyMedia: function(media) {
        var self = this;
        axios.delete('/api/medias/' + media.id)
        .then(function (response) {
          const index = self.medias.indexOf(media);
          if (index !== -1) {
            self.medias.splice(index, 1);
          }
          $('#destroyMediaModal').modal('toggle');
        });
      },

      isValidNumberField(field_name) {
        return (
          (this.errors.firstByRule("contract\[" + field_name + "\]", "decimal") == null &&
          this.errors.firstByRule("contract\[" + field_name + "\]", "min_value") == null) ||
          document.getElementsByName("contract\[" + field_name + "\]")[0].value == ""
        );
      },
    },

    computed: {
      hasValidContractors: function () {
        // TODO: Refactor this conditional
        return(
          (this.contractor_id === this.supervisor_id && ((this.contractor_id !== null && this.supervisor_id !== null) && (this.contractor_id !== "" && this.supervisor_id !== ""))) ||
          (this.contractor_id === this.interventor_id && ((this.contractor_id !== null && this.interventor_id !== null)&& (this.contractor_id !== "" && this.interventor_id !== ""))) ||
          (this.supervisor_id === this.interventor_id && ((this.supervisor_id !== null && this.interventor_id !== null)&& (this.supervisor_id !== "" && this.interventor_id !== "")))
        );
      },

      fetchEndingDate: function () {
        if (this.start_date) {
          let moment_sd =  moment(this.start_date, moment.ISO_8601);

          if (this.term_days > 0  || this.term_months > 0) {
            return moment_sd.add(this.term_days, 'days').add(this.term_months, 'months').format('YYYY-MM-DD');
          }
        }

        return '-';
      }
    },

    mounted: function () { this.$nextTick(function () { this.$validator.validateAll(); }); }
  });

  $("#contract_start_date").on('change', function() { vm[$(this).data('fieldname')] = $(this).val(); });
  $(".select2").on('change', function() { vm[$(this).data('fieldname')] = $(this).val(); });
}
