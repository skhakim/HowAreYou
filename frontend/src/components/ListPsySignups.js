import React from 'react'
import "./ScoreNDResponse.css"
import { useState, useEffect } from 'react'
import {useNavigate} from "react-router-dom";

const ListPsySignups = () => {
    const navigate = useNavigate();
    const [requests, setRequests] = useState([])

    useEffect( () => {
        const getRequests = async () => {
            const responsesFromServer = await fetchRequests()
            console.log(responsesFromServer)
            setRequests(responsesFromServer.psychiatrists)
        }
        getRequests()
    }, [])
    
    const fetchRequests = async () => {
        const res = await fetch('/psy_not_app', {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json',
                'x-access-token': localStorage.getItem('token')
            }
        })
        const data = await res.json()
        console.log(data)
        return data
    }

    return (
        <div className='container'>

            <div className='test-name'>Psychiatrist Signup Requests</div>
            <hr className='line-psy'></hr>
            

            <table className="content-table">
                <thead>
                <tr>
                <th>Test Name</th>
                {/*<th>Requested By</th>*/}
                <th>See Details</th>
                </tr>
                </thead>

                <tbody>
                {
                    requests.map(
                    (request) => (
                        <tr>
                        <td>{request.name}</td>
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

export default ListPsySignups