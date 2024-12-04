document.addEventListener('DOMContentLoaded', function() {
    const ctx = document.getElementById('participationChart').getContext('2d');
    
    const data = {
        labels: participationData.labels,
        datasets: [{
            data: participationData.values,
            backgroundColor: [
                '#34D399', '#10B981', '#059669', '#047857', '#065F46',
                '#047C4F', '#06845A', '#089F6B', '#0AB982', '#0CD398'
            ],
            borderWidth: 1
        }]
    };

    new Chart(ctx, {
        type: 'pie',
        data: data,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'right',
                    labels: {
                        font: {
                            size: 12
                        }
                    }
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
                            const percentage = ((context.raw / total) * 100).toFixed(1);
                            return `${context.label}: ${percentage}%`;
                        }
                    }
                },
                datalabels: {
                    formatter: (value, context) => {
                        return `${context.chart.data.labels[context.dataIndex]}: ${value}kg`;
                    },
                    color: '#fff',
                    font: {
                        weight: 'bold'
                    }
                }
            }
        },
        plugins: [ChartDataLabels]
    });
}); 