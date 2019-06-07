import VueContentLoading from 'vue-content-loading';

if (document.getElementById("tmp")) {
  var tmp = new Vue({
    el: '#tmp',
    data: {
      comp: JSON.parse(document.getElementById('tmp').dataset.comp_trun),
      component: JSON.parse(document.getElementById('tmp').dataset.comp),
      components_id: JSON.parse(document.getElementById('tmp').dataset.comp_id),
      selectedTab: 1
    },
    components: {
          VueContentLoading
        }
  });
}
else if (document.getElementById("tmp2")) {
  var tmp2 = new Vue({
    el: '#tmp2',
    components: {
          VueContentLoading
        }
  });
}
