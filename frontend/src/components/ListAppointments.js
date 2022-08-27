import React from 'react'
import "./ScoreNDResponse.css"
import { useState, useEffect } from 'react'
import {useNavigate} from "react-router-dom";

const ListAppointments = (props) => {
    const navigate = useNavigate();
    const [requests, setRequests] = useState([])

    const acceptConsultationRequest = async (id) => {
        const data = await fetch('/accept_consultation_request/' + id, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'x-access-token': localStorage.getItem('token')
            }
        }).then()
        alert("Patient will be notified that you have accepted their request")
        window.location.reload()
    }

    const deleteConsultationRequest = async (id) => {
        const data = await fetch('/delete_consultation_request/' + id, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'x-access-token': localStorage.getItem('token')
            }
        }).then()
        alert("Patient will be notified that you have declined their request")
        window.location.reload()
    }

    useEffect( () => {
        const getRequests = async () => {
            const responsesFromServer = await fetchRequests()
            console.log(responsesFromServer)
            setRequests(responsesFromServer.consultation_requests)
        }
        getRequests()
    }, [])
    
    const fetchRequests = async () => {
        const res = await fetch('/view_appointments/' + props.type, {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'x-access-token': localStorage.getItem('token')
            }
        })
        console.log(res)
        const data = await res.json()
        console.log('data')
        return data
    }

    return (
        <div className='container'>

            <div className='test-name'>{props.type == 'pending' ? <>Pending</> : <>Accepted</>} Consultation Requests</div>
            <hr className='line-psy'></hr>
            

            <table className="content-table">
                <thead>
                <tr>
                {/*<th>Test Name</th>*/}
                {/*<th>Requested By</th>*/}
                <th>Patient Name</th>
                    <th>Scheduled Time</th>
                            {
                                props.type == 'pending' ? <>
                                    <th>Accept Request</th>
                                    <th>Decline Request</th>
                                    </> : <></>
                            }
                </tr>
                </thead>

                <tbody>
                {
                    requests.map(
                    (request) => (
                        <tr>
                        {/*<td>{request.id}</td>*/}
                        {/*<td>{request.requestBy}</td>*/}
                            <td>{request.name}</td>
                            <td>{request.time}</td>
                        {/*    <td>{request.sched}</td>*/}
                        {/*    {console.log(request.testId, request.id, request.mode)}*/}
                        {/*<td><div className='response-text'*/}
                        {/*         onClick={()=>navigate('/det/' + request.testId + '/' + request.id + '/' + request.mode)}>*/}
                        {/*    See Request</div></td><br/> <br/>*/}

                            {
                                props.type == 'pending' ? <>
                                    <td><div className='response-text' onClick={() => acceptConsultationRequest(request.id)}>🆗 Accept</div></td>
                                    <td><div className='response-text' onClick={() => deleteConsultationRequest(request.id)}>❌ Decline</div> </td>
                                    </> : <></>
                            }
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