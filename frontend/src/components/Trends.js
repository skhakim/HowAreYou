import React from 'react'
import styles from "./newCss/Trends.module.css"
import {
    Chart as ChartJS,
    CategoryScale,
    LinearScale,
    BarElement,
    Title,
    Tooltip,
    Legend,
  } from 'chart.js';
import { Bar } from 'react-chartjs-2';
import CountUp from 'react-countup';

ChartJS.register(
    CategoryScale,
    LinearScale,
    BarElement,
    Title,
    Tooltip,
    Legend
);

const Trends = () => {

    //Remove these variables

    const labels = []
    const dataPoint = []
    for (let i = 0; i < 30; i++) {
        labels.push(i.toString());
        dataPoint.push(Math.floor(Math.random() * 100));
    } 
    const labels2 = ["Malaria", "Dengue", "Fever", "COVID"]
    const dataPoint2 = [300, 421, 269, 88]

    // const colors = []

    const dataFromServer = {
        "totalResponseLabel" : labels,
        "totalResponseData":dataPoint,
        "detectedLabel" : labels2,
        "detectedData" : dataPoint2
    }







    const options = {
        responsive: true,

        plugins: {
          legend: {
            display:false,
            // position: "top",
          },
          title: {
            display: false,
            // text: "Responses in Last 30 Days",
          },
        },

        scales: {
            yAxes: [
              {
                ticks: {
                  beginAtZero: true,
                },
              },
            ],
            xAxes: {
              ticks: {
                display: false,
              },
            },
        },
    };

    var r = Math.floor(Math.random() * 255);
    var g = Math.floor(Math.random() * 255);
    var b = Math.floor(Math.random() * 255);

    var col = "rgba(" + r + ", " + g + ", " + b + ", 0.8)";

    const data = {
        labels:dataFromServer.totalResponseLabel,
        datasets: [
          {
            label: '',
            data: dataFromServer.totalResponseData,
            backgroundColor: col,
          },
        ],
    };










    const options2 = {
        responsive: true,

        plugins: {
          legend: {
            display:false,
            // position: "bottom",
          },
          title: {
            display: false,
            // text: "Responses in Last 30 Days",
          },
        },

        scales: {
            yAxes: [
              {
                ticks: {
                  beginAtZero: true,
                },
              },
            ],
            x: {
                ticks: {
                    font: {
                        size: 20,
                    }
                }
            }
        },
    };

    const colors = []
    var sz = dataFromServer.detectedLabel.length;
    for(let i=0; i< sz; i++){
        r = Math.floor(Math.random() * 255);
        g = Math.floor(Math.random() * 255);
        b = Math.floor(Math.random() * 255);

        col = "rgba(" + r + ", " + g + ", " + b + ", 0.6)";
        colors.push(col)
    }
    console.log(colors)

    const data2 = {
        labels: dataFromServer.detectedLabel,
        datasets: [
          {
            label: '',
            data: dataFromServer.detectedData,
            backgroundColor: colors,
          },
        ],
    };

    return (
        <div style={{marginTop:"3%"}}>
            
            <div className={styles.trendHeader}>
                <div style={{width:"48%", textAlign:"center", marginBottom:"2%"}}>
                    <b>Responses in Last 30 Days</b>
                </div>

                <div style={{width:"48%", textAlign:"center", marginBottom:"2%"}}>
                    <b>Disorders Recorded</b>
                </div>
            </div>

            <div style={{display:"flex"}}>
                <div style={{width:"40%", marginLeft:"5%"}}>
                    <Bar options={options} data={data} />
                </div>

                <div style={{width:"40%", marginLeft:"5%"}}>
                    <Bar options={options2} data={data2} />
                </div>
                
            </div>

            <div className={styles.numberStat}>
                <div style={{display:"flex"}}>
                    {/* left */}
                    <div>
                        <CountUp end={500} />
                    </div>
                    
                </div>
            </div>
            
            
            
        </div>
    )
}

export default Trends