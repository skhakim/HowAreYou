import React, {useEffect, useState} from 'react'
import "./ScoreNDResponse.css"
import {useNavigate} from "react-router-dom";
import {getToken} from "./Variables";
import {Upload} from "./Upload";


export function ViewFileRequest(props) {

    const [responses, setResponses] = useState([])
    const navigate = useNavigate()

    useEffect(() => {
        const getResponses = async () => {
            const responsesFromServer = await fetchResponses()
            setResponses(responsesFromServer)
        }
        getResponses()
    }, [])

    const fetchResponses = async () => {
        const res = await fetch('/vfr_id/' + props.frID, {
            method: "GET", headers: {
                'Accept': 'application/vnd.api+json'
                , 'x-access-token': getToken()
            }
        })
        const data = await res.json()
        console.log(data)
        return data
    }

    return (
        <div className='container'>
            <div className='test-name'><h1>Title: {responses['title']}</h1></div>
            <br/>
            <p> {responses['description']}</p>
            <br/>
            <Upload frID={props.frID}/>
        </div>
    )

}


export function ApproveFileRequest(props) {

    const [responses, setResponses] = useState([])
    const navigate = useNavigate()

    useEffect(() => {
        const getResponses = async () => {
            const responsesFromServer = await fetchResponses()
            setResponses(responsesFromServer)
        }
        getResponses()
    }, [])

    const fetchResponses = async () => {
        const res = await fetch('/vfr_id_rev/' + props.frID, {
            method: "GET", headers: {
                'Accept': 'application/vnd.api+json'
                , 'x-access-token': getToken()
            }
        })
        const data = await res.json()
        console.log(data)
        return data
    }

    const approveFR = async (frID) => {
        var url_start = '/app_fr/'
        const res = await fetch(url_start + frID,
            {
                method: "POST", headers: {
                    "x-access-token": getToken()
                }
            })
        const data = await res.json()
        if(data['response'] === 'success') {
            alert("Successfully approved")
            navigate('/psyhome')
        } else {
            alert('Please try again')
        }
        return data
    }

    const rejectFR = async (frID) => {
        var url_start = '/app_fr/'
        const res = await fetch(url_start + frID,
            {
                method: "POST", headers: {
                    "x-access-token": getToken()
                }
            })
        const data = await res.json()
        if(data['response'] === 'success') {
            alert("Successfully rejected")
            navigate('/psyhome')
        } else {
            alert('Please try again')
        }
        return data
    }


    return (
        <div className='container'>
            <div className='test-name'><h1>Title: {responses['title']}</h1></div>
            <br/>
            <p> {responses['description']}</p>
            <br/>

            <div className='done-btn2' onClick={() => approveFR(props.frID)}>
                Approve
            </div>

            <div className='done-btn2' onClick={() => rejectFR(props.frID)}>
                Decline
            </div>
        </div>
    )

}
