if (document.getElementById("committee_minute_form")) {

  var csrf_token = document.getElementsByName('csrf-token')[0].getAttribute('content');
  axios.defaults.headers.common['X-CSRF-TOKEN'] = csrf_token;

  var currentAction = document.getElementById('committee_minute_form').dataset.action;
  var minuteId = document.getElementById('committee_minute_form').dataset.minute_id;

  Vue.filter('momentjs', function(value) {
    return moment(value).format('ddd MMMM D [de] YYYY, h:mm a');
  });

  new Vue({
    el: '#committee_minute_form',

    data:{
      medias: [],
      mediaToDestroy: {
        name: ''
      },
      committee_minute: {},
      uploadedFiles: 0
    },

    created () {
      this.fetchMinute();
      this.fetchMinuteMedias(minuteId);
      this.initDropzone();
    },

    methods: {
      isValidField(field_name) {
        return (
          this.fields.clean("committee_minute\[" + field_name + "\]") ||
          this.errors.has("committee_minute\[" + field_name + "\]")
        );
      },
      initDropzone: function() {
        self = this;
        self.$nextTick(function() {
          self.mediaDropzone  = new Dropzone("#media-dropzone", {
            url: '/api/medias/'  +  'committee_minute/' + minuteId,
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

      fetchMinute: function() {
        var self = this;
        axios.get('/api/committee_minutes/' + minuteId)
        .then(function (response) { self.committee_minute = response.data; });
      },

      fetchAndAddMediaToList: function(media_id){
        axios.get('/api/medias/' + media_id)
        .then(function (response) {
          self.medias.push(response.data);
          return response.data;
        });
      },

      fetchMinuteMedias: function(minute_id) {
        var self = this;
        axios.get('/api/committee_minutes/' + minute_id + '/medias')
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
    },
    mounted: function () {
      this.$nextTick(function () {
        this.$validator.validateAll();
      });
    },
  });
}
