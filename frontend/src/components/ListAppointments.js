import React from 'react'
import "./ScoreNDResponse.css"
import { useState, useEffect } from 'react'
import {useNavigate} from "react-router-dom";

const ListAppointments = () => {
    const navigate = useNavigate();
    const [requests, setRequests] = useState([])

    useEffect( () => {
        const getRequests = async () => {
            const responsesFromServer = await fetchRequests()
            console.log(responsesFromServer)
            setRequests(responsesFromServer.consultation_requests)
        }
        getRequests()
    }, [])
    
    const fetchRequests = async () => {
        const res = await fetch('/view_appointments/', {
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
                <th>Response</th>
                    <th>Time</th>
                </tr>
                </thead>

                <tbody>
                {
                    requests.map(
                    (request) => (
                        <tr>
                        <td>{request.id}</td>
                        {/*<td>{request.requestBy}</td>*/}
                            <td>{request.name}</td>
                            <td>{request.time}</td>
                        {/*    <td>{request.sched}</td>*/}
                        {/*    {console.log(request.testId, request.id, request.mode)}*/}
                        {/*<td><div className='response-text'*/}
                        {/*         onClick={()=>navigate('/det/' + request.testId + '/' + request.id + '/' + request.mode)}>*/}
                        {/*    See Request</div></td><br/> <br/>*/}
                        </tr>
                    )
                    )
                }
                </tbody>
            </table>

        
        </div>
    )
}

export default ListAppointments