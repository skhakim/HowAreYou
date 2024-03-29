import React, {useState, useEffect} from 'react'

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
import SentimentVeryDissatisfiedIcon from '@mui/icons-material/SentimentVeryDissatisfied';
import GroupsIcon from '@mui/icons-material/Groups';
import QuestionAnswerIcon from '@mui/icons-material/QuestionAnswer';
import SupervisorAccountIcon from '@mui/icons-material/SupervisorAccount';

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

    const [set, isSet] = useState(false);

    const labels = []
    const dataPoint = []
    for (let i = 0; i < 30; i++) {
        labels.push(i.toString());
        dataPoint.push(Math.floor(Math.random() * 100));
    } 
    const labels2 = ["Malaria", "Dengue", "Fever", "COVID"]
    const dataPoint2 = [300, 421, 269, 88]

    // const colors = []

    const [dataFromServer, setDataFromServer] = useState ({
        "totalResponseLabel" : labels,
        "totalResponseData":dataPoint,
        "detectedLabel" : labels2,
        "detectedData" : dataPoint2
    })

    const fetchFromServer = async () => {
        const response = await fetch("/trends")
        const data = await response.json()
        console.log(data)
        setDataFromServer(data)
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
            backgroundColor: "#8cba7f",
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
                        size: 16,
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

    if(!set)
        fetchFromServer().then(() => isSet(true))

    return (
        <div style={{marginTop:"3%"}}>

            {/*<button onClick={()=>fetchFromServer()}>hfh</button>*/}
            
            <div className={styles.trendHeader}>
                <div style={{width:"48%", textAlign:"center", marginBottom:"2%"}}>
                    <b>Responses in Last 30 Days</b>
                </div>

                <div style={{width:"48%", textAlign:"center", marginBottom:"2%"}}>
                    <b>Disorders Recorded</b>
                </div>
            </div>

            <div style={{display:"flex"}}>
                <div style={{width:"37%", marginLeft:"5%"}}>
                    <Bar options={options} data={data} />
                </div>

                <div style={{width:"43%", marginLeft:"5%"}}>
                    <Bar options={options2} data={data2} />
                </div>
                
            </div>

            <div style={{marginTop:"4%"}} className={styles.numberStat}>
                <div style={{display:"flex"}}>
                    {/* left */}
                    <div style={{width:"24%", textAlign:"center"}}>
                        <div><CountUp end={dataFromServer.n_patients} /></div>
                        <div><SentimentVeryDissatisfiedIcon sx={{fontSize:"4rem", mt:1.5, color:"#353634"}} /></div>
                        <div style={{fontSize:"1.5rem"}}>Patients</div>
                    </div>

                    {/* Right */}
                    <div style={{width:"24%", textAlign:"center"}}>
                        <CountUp end={dataFromServer.n_psychiatrists} />
                        <div><GroupsIcon sx={{fontSize:"4rem", mt:1.5, color:"#353634"}} /></div>
                        <div style={{fontSize:"1.5rem"}}>Psychiatrists</div>
                    </div>

                    {/* left */}
                    <div style={{width:"24%", textAlign:"center"}}>
                        <CountUp end={dataFromServer.n_tests_conducted} />
                        <div><QuestionAnswerIcon sx={{fontSize:"4rem", mt:1.5, color:"#353634"}} /></div>
                        <div style={{fontSize:"1.5rem"}}>Tests Conducted</div>
                    </div>

                    {/* Right */}
                    <div style={{width:"24%", textAlign:"center"}}>
                        <CountUp end={dataFromServer.n_consultations_done} />
                        <div><SupervisorAccountIcon sx={{fontSize:"4rem", mt:1.5, color:"#353634"}} /></div>
                        <div style={{fontSize:"1.5rem"}}>Consultations Given</div>
                    </div>
                    
                </div>
            </div>
            
            
            
        </div>
    )
}

export default Trends