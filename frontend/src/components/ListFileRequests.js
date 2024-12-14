import React from 'react'
import "./ScoreNDResponse.css"
import { useState, useEffect } from 'react'
import {useNavigate} from "react-router-dom";

const ListFileRequests = () => {
    const navigate = useNavigate();
    const [requests, setRequests] = useState([])

    useEffect( () => {
        const getRequests = async () => {
            const responsesFromServer = await fetchRequests()
            console.log(responsesFromServer)
            setRequests(responsesFromServer.file_requests)
        }
        getRequests()
    }, [])
    
    const fetchRequests = async () => {
        const res = await fetch('/fileReviewRequests', {
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

            <div className='test-name'>Review File Upload Requests</div>
            <hr className='line-psy'></hr>
            

            <table className="content-table">
                <thead>
                <tr>
                <th>Test Name</th>
                <th>See Details</th>
                </tr>
                </thead>

                <tbody>
                {
                    requests.map(
                    (request) => (
                        <tr>
                        <td>{request.title}</td>
                        {/*<td>{request.requestBy}</td>*/}
                        <td><div className='response-text'
                                 onClick={()=>navigate('/review_file_request/' + request.id)}>
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

export default ListFileRequests