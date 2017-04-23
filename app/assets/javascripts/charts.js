var currencyRatesChart;

$(document).ready(function() {
  currencyRatesChart = new Highcharts.Chart({
    chart: {
      renderTo: 'chart-container',
      type: 'spline',
      plotBackgroundColor: null,
      plotBorderWidth: null,
      plotShadow: false,
      events: {
        load: requestRates(forecastId)
      }
    },
    title: {
      text: 'Forecast'
    },
    xAxis: {
      type: 'datetime',
      tickmarkPlacement: 'on',
      title: {
        enabled: false
      },
      dateTimeLabelFormats: {
         day: '%d %b %Y'    //ex- 01 Jan 2016
      }
    },
    yAxis: {
      title: {
        text: 'Target Currency'
      }
    },
    tooltip: {
      formatter: function() {
        str = this.series.name + ': ' + this.y;
        return str;
      }
    },
    plotOptions: {
      area: {
        stacking: 'percent',
        lineColor: '#ffffff',
        lineWidth: 1,
        marker: {
          lineWidth: 1,
          lineColor: '#ffffff'
        }
      }
    },
    series: []
  });
  currencyRatesChart.showLoading();
});

function requestRates(forecastId) {
  $.ajax({
    url: "/forecasts/fetch_forecast_rates",
    type: "GET",
    data: {id: forecastId},
    success: function(data_arr) {
      data_arr.forEach(function(ret_data) {
        currencyRatesChart.addSeries({
          name: ret_data.name,
          type: 'line',
          pointStart: ret_data.point_start,
          pointIntervalUnit: ret_data.point_interval_unit,
          data: ret_data.data
        });
      });
      currencyRatesChart.hideLoading();
    },
    cache: false
  });
}
