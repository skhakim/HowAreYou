import React from 'react'
import "./Tests.css"
import { useState, useEffect } from 'react'
import {useNavigate} from "react-router-dom";
import {getToken} from "./Variables";


const Tests = (props) => {

    const [specificTests, setSpecificTests] = useState([])
    const navigate = useNavigate();

    useEffect( () => {
        const getTests = async () => {
        const testsFromServer = await fetchTests()
        console.log('Tests from server', testsFromServer)
        setSpecificTests(testsFromServer)
        }

        getTests()
    }, [])

    //Fetch Tasks
    const fetchTests = async () => {
        const res = await fetch('/api/tests',
            {
                method: "GET",
                headers: {'Content-type': 'application/vnd.api+json', 'Accept': 'application/vnd.api+json'
                , 'x-access-token': getToken()}
            })
        const data = await res.json()
        console.log('Data: ', data)
        if (typeof data.data === 'undefined'){
            console.log('Returning empty ')
            return []
        }
        console.log('Data.data: ', data.data)
        return data.data
    }

    console.log("Props", props, (props == {}))

    if(Object.keys(props).length === 0) {
        return (
            <div className='tests-body'>
                {/*<span className='topic-header'>General Questionnaire</span>*/}
                {/*<hr className='line'></hr>*/}
                {/*<div className="test-name">Self-Rated Level 1 Cross-Cutting Symptom Measure</div>*/}
                {/*<div class="test-desc">Are you experiencing the most common symptoms of autism? Find out using our Autism tests.</div>*/}

                <div className='test-name' onClick={() => navigate('/show_verified_reports')}>View Verified Reports
                </div>
                <hr className='line'></hr>
                <div className='test-name' onClick={() => navigate('/approved_file_requests')}>View File Upload Requests
                </div>
                <hr className='line'></hr>
                <div className='topic-header spaced'>Specific Questionnaire</div>
                <hr className='line'></hr>

                {console.log(specificTests)}
                {(specificTests.length == 0) ? <h3>Not logged in as patient</h3> :
                    <div>{
                        specificTests.map(
                            (test) => (
                                <div>
                                    {console.log(test.attributes.test_id)}
                                    <div className="test-name"
                                         onClick={() => navigate("/tests/" + test.attributes.test_id)}>{test.attributes.name}</div>
                                    <div class="test-desc">{test.attributes.description}</div>
                                </div>
                            )
                        )
                    }
                    </div>
                }

            </div>
        )
    } else {
        return (
            <div className='tests-body'>

                <div className='topic-header spaced'>Specific Questionnaire to Edit</div>
                <hr className='line'></hr>

                {console.log(specificTests)}
                {(specificTests.length == 0) ? <h3>Not logged in as patient</h3> :
                    <div>{
                        specificTests.map(
                            (test) => (
                                <div>
                                    <div className="test-name"
                                         onClick={() => navigate("/a_d_ques/" + test.attributes.test_id)}>{test.attributes.name}</div>
                                    <div class="test-desc">{test.attributes.description}</div>
                                </div>
                            )
                        )
                    }
                    </div>
                }

            </div>
        )
    }
}

export default Tests
