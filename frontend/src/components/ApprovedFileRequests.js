import React from 'react'
import "./ScoreNDResponse.css"
import { useState, useEffect } from 'react'
import {useNavigate} from "react-router-dom";
import {getIdType, getToken} from "./Variables";
import {saveAs} from "file-saver";

const ApprovedFileRequests = () => {

  const [responses, setResponses] = useState([])
  const navigate = useNavigate()

  useEffect( () => {
    const getResponses = async () => {
      const responsesFromServer = await fetchResponses()
      setResponses(responsesFromServer)
    }
    getResponses()
  }, [])

  const fetchResponses = async () => {
    const res = await fetch('/vfr', {method: "GET", headers: {'Accept': 'application/vnd.api+json'
                            , 'x-access-token': getToken() }})
    const data = await res.json()
    console.log(data)
    return data
  }

  const download = async (id) => {
    console.log("In download")
    const res = await fetch('/vfu/' + id, {method: "GET", headers: {'Accept': 'application/vnd.api+json'
                            , 'x-access-token': getToken() }})
    const data = await res.blob()
    saveAs(data, id + ".zip")
    console.log(data)
    return data
  }


  return(
      <div className='container'>
        <div className='test-name'>Incoming File Requests</div>
        <hr className='line-psy'></hr>


        <table className="table-wrapper-cross-y content-table">
          <thead>
          <tr>
            <th>Title</th>
            <th>View</th>
          </tr>
          </thead>

          <tbody>
          {
            responses.map(
                (response) => (
                    <tr>
                      <td>{response.title}</td>
                      {/* TODO: insert a l
                      ink to */}
                      { (getIdType() === 'patient_id') ?
                      <td><div className='response-text' onClick={() => navigate('/file_request/' + response.file_request_id)}>View Details</div></td>
                      : (
                          getIdType() === 'psychiatrist_id' ?
                        <td><div className='response-text' onClick={() => download(response.file_request_id)}>Download</div></td>
                      : <h1></h1> )}
                      <br/> <br/>
                      </tr>
                )
            )
          }
          </tbody>
        </table>


      </div>
  )
}

export default ApprovedFileRequests