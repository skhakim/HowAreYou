import React from 'react'
import "./VerifiedReport.css"
import { useEffect, useState } from 'react'
import {FaAngleDown, FaAngleUp} from 'react-icons/fa'
import {getToken} from "./Variables";

/*
const VerifiedReport = () => {

    const [expands, setExpands] = useState({});
    const [verifiedReports, setVerifiedReports] = useState([]);

    useEffect( () => {
        const getResponse = async () => {
            const verifiedFromServer = await fetchVerifiedReports()
            setVerifiedReports(verifiedFromServer.verified_reports)
            console.log("Report From Server" ,verifiedFromServer.verified_reports)

            var expandDict = {}
            verifiedFromServer.verified_reports.map(
                (report) => expandDict[report.reportId] = false
            );
            setExpands(expandDict);
            // console.log("expand dict", expandDict)
        }
        getResponse()

    }, [])
    const fetchVerifiedReports = async () => {
        const res = await fetch('http://localhost:5000/view_verified_report/',
                                {
                                    method: "GET",
                                    headers: {'Content-type': 'application/vnd.api+json', 'Accept': 'application/vnd.api+json'
                                    , 'x-access-token': getToken()}
                                })
        const data = await res.json()
        return data
    }

    const changeSpecificExpand = (id) => {
        var tempDict = {}
        for (const [key, value] of Object.entries(expands)){
            tempDict[key] = value
        }
        tempDict[id] = !tempDict[id];
        console.log("tempDict", tempDict);
        setExpands(tempDict);
    }

    return (
        <div className='container'>
            <h2>Verified Reports</h2>
            <hr className='line-psy' style={{width:"70%"}}></hr>

            {
                verifiedReports.map(
                    (verifiedReport) => (
                        <div>
                            <div className="review-card">
                                <div className='title'>
                                    <div className='left'>
                                    Your <div className='link'>test </div> {verifiedReport.test_name} submitted at {verifiedReport.submitted_at} has been verified by <b>{verifiedReport.psychiatrist}</b> <div style={{"marginLeft":"0.5%"}}></div> 
                                    </div>

                                    <div className='right'>
                                        <div className='rightElem' onClick={() => changeSpecificExpand(verifiedReport.reportId)}>
                                            {expands[verifiedReport.reportId] ?
                                                (<FaAngleUp/>) : (<FaAngleDown />)
                                            }
                                            
                                        </div>
                                    </div>
                                </div>
                                <span>On {verifiedReport.verified_at}</span>
                                

                                {expands[verifiedReport.reportId] ?
                                    (
                                        <div>
                                            <br /><br />
                                            <b>Initial query result:</b>
                                            <div style={{"margin-left":"3%"}}>{verifiedReport.systemScore}</div><br />

                                            <b>Suggestions:</b>
                                            <div style={{"margin-left":"3%", "word-wrap":"break-word"}}>{verifiedReport.sugesstions}</div><br />
                                                
                                            <b>Suggested Psychiatrists:</b>
                                            <div >
                                                <ul >
                                                    
                                                    {
                                                        verifiedReport.suggestedPsychiatrists.map(
                                                            (suggPsy) => <li>{suggPsy.name}</li>
                                                        )
                                                    }

                                                </ul>
                                            </div>
                                        </div>
                                    ) : (<></>)
                                }
                
                            </div>
                        </div>
                    )
                )
            }

            

        </div>
    )
}

export default VerifiedReport
*/



const VerifiedReports = () => {

    const [expands, setExpands] = useState({});
    const [verifiedReports, setVerifiedReports] = useState([]);
    const [showModal, setShowModal] = useState(false);
    const [psyDetail, setPsyDetail] = useState({});
    const [counsel_id, setCounsel_id] = useState(0);
    const [test_result_id, setTest_result_id] = useState(0);
    const [time, setTime] = useState("")

    useEffect( () => {
        const getResponse = async () => {
            const verifiedFromServer = await fetchVerifiedReports()
            setVerifiedReports(verifiedFromServer)
            console.log(verifiedFromServer)
            // console.log(verifiedFromServer['verified_reports'])
            var expandDict = {}
            verifiedFromServer.map(
                (report) => expandDict[report.reportId] = false
            );
            setExpands(expandDict);
        }
        getResponse()

    }, [])
    const fetchVerifiedReports = async () => {
        const res = await fetch('/view_verified_report', {method: "GET", headers: {'Accept': 'application/vnd.api+json'
                            , 'x-access-token': getToken()}})
        const data = await res.json()
        console.log(data)
        return data['verified_reports']
    }

    const changeSpecificExpand = (id) => {
        var tempDict = {}
        for (const [key, value] of Object.entries(expands)){
            tempDict[key] = value
        }
        tempDict[id] = !tempDict[id];
        setExpands(tempDict);
    }

    const psyClicked = async (id) =>{
        let details = {}
        await fetchPsychiatristDetails(id).then(
            (data) => {
                details = data
                console.log(data)
                setPsyDetail(data)
            }
        )

        // const details = {
        //     "id":1,
        //     "name":"MA. Adnan Rahman",
        //     "designation": "Cancer Specialist",
        //     "cell": 42042069,
        //     "email": "johndoe@gmail.com",
        //     "area_of_expertise":[
        //       "cancer", "skin", "bone"
        //     ],
        //     "awards": [
        //       "some random award",
        //       "random award with too big name random award with too big name random award with too big name"
        //     ],
        //     "available_hours" : [
        //       {"id":1, "datetime":"Monday 6pm - 8pm"},
        //       {"id":2, "datetime":"Tuesday 7pm - 10pm"},
        //       {"id":3, "datetime":"Wednesday 6pm - 8pm"},
        //       {"id":4, "datetime":"Friday 5pm - 9pm"}
        //     ]
        // }

        console.log(details)
        setShowModal(true)
    }

    const fetchPsychiatristDetails = async (id) => {
        const res = await fetch('pd/' + id)
        console.log("res", res)
        const data = await res.json()
        console.log("Data", data)
        return data
    }
    const requestTime = async (e) => {
        e.preventDefault()
        console.log(e)
        if (!time) {
            alert("Fill Atleast One Time")
            return
        }

        console.log(time)

        const res = await fetch('/make_consul_request', {
            method: "POST", headers: {
                'Accept': 'application/vnd.api+json'
                , 'x-access-token': getToken()
            }, body: JSON.stringify({
                "counsel_id":  counsel_id,
                "test_result_id": test_result_id,
                "schedule": time
            })
        })
        console.log(res)
        if (res.status === 200) {
            alert("Consultation request sent")
            setShowModal(false)
        }

        setTime("")
    }

    return (
        <>
            <div className='container'>
                <h2>Verified Reports</h2>
                <hr className='line-psy' style={{width:"70%"}}></hr>

                {
                    verifiedReports.map(
                        (verifiedReport) => (
                            <div>
                                <div className="review-card">
                                    <div className='title'>
                                        <div className='left'>
                                            <b>{verifiedReport.psychiatrist}</b> <div style={{"marginLeft":"0.5%"}}></div> reviewed your <div className='link'> report </div>
                                        </div>

                                        <div className='right'>
                                            <div className='rightElem' onClick={() => changeSpecificExpand(verifiedReport.reportId)}>
                                                {expands[verifiedReport.reportId] ?
                                                    (<FaAngleUp/>) : (<FaAngleDown />)
                                                }

                                            </div>
                                        </div>
                                    </div>
                                    <span>On {verifiedReport.verified_at}</span>


                                    {expands[verifiedReport.reportId] ?
                                        (
                                            <div>
                                                <br /><br />
                                                <b>Initial query result:</b>
                                                <div style={{"margin-left":"3%"}}>{verifiedReport.systemScore}</div><br />

                                                <b>Suggestions:</b>
                                                <div style={{"margin-left":"3%", "word-wrap":"break-word"}}>{verifiedReport.manual_report}</div><br />

                                                <b>Suggested Psychiatrists:</b>
                                                <div >
                                                    <ul >

                                                        {
                                                            verifiedReport.suggestedPsychiatrists.map(
                                                                (suggPsy) => <li><span className='docName' onClick={() => {
                                                                    psyClicked(suggPsy.psychiatrist_id).then();
                                                                    setCounsel_id(suggPsy.counsel_id);
                                                                    setTest_result_id(verifiedReport.reportId);
                                                                }}>{suggPsy.name}</span></li>
                                                            )
                                                        }

                                                    </ul>
                                                </div>
                                            </div>
                                        ) : (<></>)
                                    }

                                </div>
                            </div>
                        )
                    )
                }
            </div>

            {
                showModal && (
                    <div className='modal'>
                        <div onClick={() => setShowModal(false)} className="overlay"></div>

                        <div className="modal-content">
                            <div className='detailContainer'>
                                {/*{console.log("PD: ", psyDetail)}*/}
                                <div className='docNameModal'><h1>{psyDetail.name}</h1></div>
                                <br/>
                                <hr className='line-psy' style={{width:"70%"}}></hr>

                                <div className='flexbox'>
                                    <div className='leftFlex'>
                                        <img src="https://picsum.photos/200" />
                                        <div className='designation'>{psyDetail.designation}</div>
                                        <div className='cell'>Cell:  {psyDetail.cell}</div>
                                        <div className='cell'>Email:  {psyDetail.email}</div>
                                    </div>

                                    <div className='middleFlex'>
                                    </div>

                                    <div className='rightFlex'>
                                        <b>AREAS OF EXPERTISE</b>
                                        <hr className='line-psy' style={{width:"90%"}}></hr>
                                        <ul>
                                            {
                                                psyDetail['area_of_expertise'].map(
                                                    (area) => <li className='cell'>{area}</li>
                                                )
                                            }
                                        </ul>

                                        <b>HONORS and AWARDS</b>
                                        <hr className='line-psy' style={{width:"90%"}}></hr>
                                        <ul>
                                            {
                                                psyDetail.awards.map(
                                                    (award) => <li className='cell'>{award}</li>
                                                )
                                            }
                                        </ul>

                                        
                                        <b>Available Hours</b>
                                        <hr className='line-psy' style={{width:"90%"}}></hr>
                                        <form onSubmit={requestTime}>
                                            {
                                                psyDetail.available_hours.map(
                                                    (available) => (
                                                        <div className='optionContainer' onChange={(e) => {
                                                            setTime(e.target.value);
                                                        }}>
                                                            <input type="radio" className='radio' name="selectTime" value={available} />
                                                            <label align={"left"}>{available}</label>
                                                        </div>
                                                    )
                                                )
                                            }
                                            <button type="submit" className="btn-btn">Send </button>
                                        </form>
                                    </div>

                                </div>
                            </div>



                            <button className="close-modal" onClick={() => setShowModal(false)}>
                            CLOSE
                            </button>
                        </div>
                    </div>
                )
            }



        </>
    )
}

export default VerifiedReports