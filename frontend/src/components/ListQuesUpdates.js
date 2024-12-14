import React from 'react'
import "./ScoreNDResponse.css"
import { useState, useEffect } from 'react'
import {useNavigate} from "react-router-dom";

const ListQuesUpdates = () => {
    const navigate = useNavigate();
    const [requests, setRequests] = useState([])

    useEffect( () => {
        const getRequests = async () => {
            const responsesFromServer = await fetchRequests()
            console.log(responsesFromServer)
            setRequests(responsesFromServer.questions)
        }
        getRequests()
    }, [])
    
    const fetchRequests = async () => {
        const res = await fetch('/quesReviewRequests', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'x-access-token': localStorage.getItem('token')
            }
        })
        const data = await res.json()
        return data
    }

    return (
        <div className='container'>

            <div className='test-name'>Questionnaire Update Requests</div>
            <hr className='line-psy'></hr>
            

            <table className="content-table">
                <thead>
                <tr>
                <th>Test Name</th>
                {/*<th>Requested By</th>*/}
                <th>Mode</th>
                <th>Response</th>
                </tr>
                </thead>

                <tbody>
                {
                    requests.map(
                    (request) => (
                        <tr>
                        <td>{request.testName}</td>
                        {/*<td>{request.requestBy}</td>*/}
                        <td>{request.mode}</td>
                            {console.log(request.testId, request.id, request.mode)}
                        <td><div className='response-text'
                                 onClick={()=>navigate('/det/' + request.testId + '/' + request.id + '/' + request.mode)}>
                            See Request</div></td><br/> <br/>
                        </tr>
                    )
                    )
                }
                </tbody>
            </table>

        
        </div>
    )
}

export default ListQuesUpdates