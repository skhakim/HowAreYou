import React from 'react'
import "./DetailedQuesReview.css"
import "./ShowResponse.css"
import {useState, useEffect} from "react";
import {getToken} from "./Variables";
import {useNavigate} from "react-router-dom";

const DetailedQuesRequest = (props) => {

    const [requestDetails, setRequestDetails] = useState([])
    const navigate = useNavigate()

    useEffect( () => {
        const getRequests = async (quesID, testID) => {
            const responsesFromServer = await fetchDetails(quesID, testID)
            setRequestDetails([responsesFromServer])
            console.log(responsesFromServer)
        }
        //Uncomment This
        getRequests(props.quesID, props.testID).then()

        //Fetching from db.json was not working. remove this hardcoded value in implementation.
        /*const req = [
            {
                "id":2,
                "testName" : "HIV",
                "requestBy": "Doe",
                "mode":"Add",
                "quesId":200,
                "quesBody":"What Have you done?",
                "options":[
                  "gone", "eaten", "played"
                ],
                "reason":""
            }
        ]*/
        // setRequestDetails(req)

    }, [])
    
    const fetchDetails = async (quesID, testID) => {
        const res = await fetch('/get_ques/' + quesID + '/' + testID)
        const data = await res.json()
        return data
    }

    const approveQuestion = async (quesID, testID) => {
        var url_start = '/approve_question/'
        if(props.mode === "delete")
            url_start = '/approve_delete_question/'
        const res = await fetch(url_start + testID + '/' + quesID,
            {
                method: "POST", headers: {
                    "x-access-token": getToken()
                }
            })
        const data = await res.json()
        if(data['response'] === 'success') {
            alert("Successfully approved")
            navigate('/psyhome')
        }
        return data
    }

    const rejectQuestion = async (quesID, testID) => {
        var url_start = '/reject_question/'
        if(props.mode === "delete")
            url_start = '/reject_delete_question/'
        const res = await fetch(url_start + testID + '/' + quesID,
            {
                method: "POST", headers: {
                    "x-access-token": getToken()
                }
            })
        const data = await res.json()
        if(data['response'] === 'success') {
            alert("Successfully rejected")
            navigate('/psyhome')
         }
        return data
    }


    return (
        <div className='container'>
            {
                requestDetails.map(
                    (request) => (
                        <>
                            <div >
                                {request.requestBy} has Requested to {props.mode} a question from { request.testName } Test
                            </div>
                            <hr className='line-psy'></hr>

                            <div className='answersHandler'>

                                <div className='questionTextContainer'>
                                    <div className='questionText'>{request.quesBody}</div>
                                </div>

                                {
                                    request.options.map(
                                        (option) => (
                                            <div style={{"marginTop":"20px", "marginLeft":"2%"}} className='optionContainer'>
                                                <label className="ckbox-container-show">{option}
                                                    {
                                                        <input type="checkbox" disabled />
                                                    }
                                                    <span className="ckbox-checkmark-show"></span>
                                                        
                                                </label>
                                            </div>
                                        )
                                    )
                                }

                                {/*
                                    (request.reason.length > 0) ? (
                                        <>
                                            <div className='reason'>
                                                <div style={{"marginRight":"10px"}}><b>Reason:</b></div>
                                                <div>{request.reason}</div>
                                            </div>


                                        </>

                                    ) : (<></>)
                                */}

                                <div className='done-btn2' onClick={() => approveQuestion(props.quesID, props.testID)}>
                                    🆗 Approve
                                </div>

                                <div className='done-btn2' onClick={() => rejectQuestion(props.quesID, props.testID)}>
                                    ❌ Decline
                                </div>

                            </div>
                        </>
                        
                    )
                )
            }

        </div>
    )
}

export default DetailedQuesRequest