if (document.getElementById("source_pie")) {

  window.axios = require('axios');

  var Chart = require('chart.js');
  var data;
  function addCommas(nStr)
    {
        nStr += '';
        var x = nStr.split('.');
        var x1 = x[0];
        var x2 = x.length > 1 ? '.' + x[1] : '';
        var rgx = /(\d+)(\d{3})/;
        while (rgx.test(x1)) {
            x1 = x1.replace(rgx, '$1' + ',' + '$2');
        }
        return x1 + x2;
    }

  axios.get('/a/tablero/sources_chart')
  .then(function (response) {
    data = response.data;

    var data = {
      labels: [
        "Disponible",
        "Reservado",
        "Asignado",
        "Pagado"
      ],
      datasets: [
        {
          data: data,
          backgroundColor: [
            "#4BC0C0",
            "#FFCE56",
            "#36A2EB",
            "#FF6384"
          ],
          hoverBackgroundColor: [
            "#4BC0C0",
            "#FFCE56",
            "#36A2EB",
            "#FF6384"
          ]
        }]
    };
    var ctx = document.getElementById("source_pie")

    var myDoughnutChart = new Chart(ctx, {
        type: 'pie',
        data: data,
        options: {
            tooltips: {
                mode: 'label',
                label: 'mylabel',
                callbacks: {
                    label: function(tooltipItem, data) {
                        var value = data.datasets[0].data[tooltipItem.index];
                        return '$ ' + addCommas(value);
                    }
                }
             }
        }
    });

    // var ctx2 = document.getElementById("source_pie2")

    // var myDoughnutChart = new Chart(ctx2, {
    //   type: 'doughnut',
    //   data: data
    // });
  })
  .catch(function (error) {
    console.log(error);
  });
    axios.get('/a/tablero/rp_sources_chart')
        .then(function (response) {
            data = response.data;

            var data = {
                labels: [
                    "Disponible",
                    "Reservado",
                    "Asignado",
                    "Pagado",
                ],
                datasets: [
                    {
                        data: data,
                        backgroundColor: [
                            "#4BC0C0",
                            "#FFCE56",
                            "#36A2EB",
                            "#FF6384",
                            "#c542f4"
                        ],
                        hoverBackgroundColor: [
                            "#4BC0C0",
                            "#FFCE56",
                            "#36A2EB",
                            "#FF6384",
                            "#c542f4"
                        ]
                    }]
            };

            var ctx2 = document.getElementById("source_pie2")

            var myDoughnutChart = new Chart(ctx2, {
                type: 'doughnut',
                data: data,
                options: {
                    tooltips: {
                        mode: 'label',
                        label: 'mylabel',
                        callbacks: {
                            label: function(tooltipItem, data) {
                                var value = data.datasets[0].data[tooltipItem.index];
                                return '$ ' + addCommas(value);
                            }
                        }
                    }
                }
            });
        })
        .catch(function (error) {
            console.log(error);
        });
}
