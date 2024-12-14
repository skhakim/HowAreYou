import React from 'react'
import "./ScoreNDResponse.css"
import { useState, useEffect } from 'react'
import {useNavigate} from "react-router-dom";
import {getToken} from "./Variables";

const ScoreNDResponse = () => {

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
    const res = await fetch('/test_responses', {method: "GET", headers: {'Accept': 'application/vnd.api+json'
                            , 'x-access-token': getToken() }})
    const data = await res.json()

    return data.results
  }


  return(
      <div className='container'>


        <div className='test-name'>Patient Scores And Responses</div>
        <hr className='line-psy'></hr>


        <table style={{marginLeft:"7%"}} className="table-wrapper-cross-y content-table">
          <thead>
          <tr>
            <th>Test Name</th>
            <th>Patient Name</th>
            <th>System Score</th>
            <th>Response</th>
          </tr>
          </thead>

          <tbody>
          {
            responses.map(
                (response) => (
                    <tr>
                      <td>{response.test_name}</td>
                      <td>{response.patient_name}</td>
                      {/* <td>John</td> */}
                      <td>{response.score}</td>
                      {/* TODO: insert a l
                      ink to */}
                      <td><div className='response-text' onClick={() => navigate('/test_result/' + response.test_result_id)}>Get Response</div></td><br/> <br/>
                    </tr>
                )
            )
          }
          </tbody>
        </table>


      </div>
  )
}

export default ScoreNDResponse